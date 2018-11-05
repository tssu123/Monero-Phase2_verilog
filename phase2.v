//======================================================================
//
// phase2.v
// --------
// Top level wrapper for the AES block cipher core.
//
//
// Author: Joachim Strombergson
// Copyright (c) 2013, 2014 Secworks Sweden AB
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or
// without modification, are permitted provided that the following
// conditions are met:
//
// 1. Redistributions of source code must retain the above copyright
//    notice, this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimer in
//    the documentation and/or other materials provided with the
//    distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
// "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
// FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
// COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//======================================================================

module phase2(clk, reset, variant_in, tweak1_2, keccak_state, stp_phase1, debug_en, debug_cnt, rdata, addr_a, addr_b, wdata, cs, we, oe, 
    //`ifdef MCP6T_EMU
     core_a, core_b,
    // `endif   
    go_phase2, phase2_done );
    input                clk, reset;
    input                variant_in;
    input      [63:0]   tweak1_2;
    input      [511:0]  keccak_state;
    input                stp_phase1;
    input                debug_en;
    input      [19:0]    debug_cnt;
    input      [127:0]   rdata;
    output     [16:0]    addr_a; // Address Input
    output     [16:0]    addr_b; // Address Input
    output     [127:0]   wdata; // Data bi-directional
    output               cs; // Chip Select
    output               we; // Write Enable/Read Enable
    output               oe;
    //`ifdef MCP6T_EMU
    output     [127:0]   core_a; // for timing estimation
    output     [127:0]   core_b;
    //`endif
    output               go_phase2; // Write Enable/Read Enable
    output               phase2_done; // Write Enable/Read Enable
  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
 //localparam CORE_VERSION     = 32'h302e3630; // "0.60"


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
    wire [127 : 0]  core_block;
    wire [127 : 0]  aes_out;
    wire            aes_out_ready;
    wire [255 : 0]  state_a;
    wire [255 : 0]  state_b;
    wire [255 : 0]  state_ab;
    reg     	    cs;
    reg     	    we;
    wire [127:0]     wdata;
    reg [16:0]      addr_a;
    reg [16:0]      addr_b;
    reg [2:0]       state;
    reg [2:0]       next_state;
    reg     	    first_rd1;
    reg             initial_read;
    reg     	    go_phase2;
    reg     	    go_phase2_d1;
    reg [127:0]     core_a;
    reg [127:0]     core_b;
    reg [127:0]     new_b;
    reg     	    stp_d1;
    reg     	    stp_d2;
    reg             aes_pre;
    reg             aes_run;
    reg             aes_run2;
    reg             post_aes;
    reg             mul_add_run;
    reg             mul_add_run2;
    reg             post_add;
    reg             close_write;
    reg [64:0]      mul_addh;
    reg [64:0]      mul_addl;
    wire [127:0]    mul_add_result;
    wire [127:0]    mul_add_result_m;
    wire [127:0]    new_a;
    wire [127:0]    xor_op_to_new_a;
    reg [63:0]      mul_op1 /* synthesis syn_keep = 1 */;
    reg [63:0]      mul_op2 /* synthesis syn_keep = 1 */;
    reg [127:0]     post_aes_mem_rd /* synthesis syn_keep = 1 */; 
    reg [127:0]     add_op2 /* synthesis syn_keep = 1 */;
    wire [127:0]    mul_16b;
    reg [19:0]      round_cnt;
    reg flag_aes_in_collision; 
    reg flag_mul_in_collision; 
    reg flag_aes_in_collision_d1;
    reg [127:0] wdata_d1;

    // -- flow control : signals
    always @ (posedge clk)
        if(reset) begin  // using synchronous reset
            stp_d1 <= 0;
            stp_d2 <= 0;
        end 
        else begin 
            stp_d1 <= stp_phase1;
            stp_d2 <= stp_d1;
        end

    always @ (posedge clk) // using synchronous reset
        if(reset) go_phase2_d1 <= 0;
        else         go_phase2_d1 <= go_phase2;

    assign phase2_done = (~go_phase2)&go_phase2_d1;

    always @ (posedge clk) // using synchronous reset
        if(reset) begin 
            round_cnt <= 0;
        end
        else if (stp_d2) begin 
            round_cnt <= 0;
        end
        else if (post_add) begin 
            round_cnt <= round_cnt + 1;
        end

    always @ (posedge clk) // using synchronous reset
        if(reset) begin 
            state <= 0;
        end else begin 
            state <= next_state;
        end

    // -- flow control : state machine
    always @*
        begin
            go_phase2 = 0;
            initial_read = 0;
            aes_pre = 0;
            case(state)
            3'b000 : begin // IDLE   
                if(stp_d2) begin
                    initial_read = 1;
                    next_state = 3'b011;
                end else 
                    next_state = 3'b000;
            end
            3'b011 : begin // improve timing
                    go_phase2 = 1; // register first_rd1 set, and send rd addr
                    aes_pre = 1;
                    next_state = 3'b001;
            end
            3'b001 : begin // AES cycle start
                go_phase2 = 1;
                if (~(debug_en&(round_cnt>debug_cnt))) begin
                    next_state = 3'b010;
                end
                else next_state = 3'b000;
            end
            3'b010 : begin // through AES cycle 2, MUL, until ADD
                go_phase2 = 1;
                if (post_add) begin
                    if (round_cnt <20'h7ffff) begin
                        aes_pre = 1;
                        next_state = 3'b001;
                    end else begin
                        next_state = 3'b100; // ending, prepare writing last data
                    end
                end else
                    next_state = 3'b010;
            end
            3'b100 : begin // one latency cycle to finish writing sram
                go_phase2 = 1;
                next_state = 3'b000;
            end
            default : next_state = 3'b000;
        endcase 
    end

    always @(posedge clk)
        if(reset) begin
            first_rd1 <= 0;
        end else begin
            first_rd1 <= initial_read;
        end

    always @(posedge clk) // using synchronous reset
        if(reset) begin
            aes_run  <= 0;
            aes_run2 <= 0;
            post_aes <= 0;
            mul_add_run  <= 0;
            mul_add_run2 <= 0;
            post_add  <= 0;
        end else begin
            aes_run <= aes_pre;
            aes_run2 <= aes_run;
            post_aes <= aes_run2;
            mul_add_run  <= post_aes;
            mul_add_run2  <= mul_add_run;
            post_add <= mul_add_run2;
        end

    always @(posedge clk)
	if (next_state == 3'b100) close_write <= 1;
        else                      close_write <= 0;

    // -- a, b update
    always @(posedge clk)
       if (stp_phase1) begin // remove reset
            core_a <= state_ab[127:0];
            core_b <= state_ab[255:128];
       end
       else if (post_add) begin
            core_a <= new_a;
            core_b <= new_b;
       end    	         

    always @(posedge clk)
        if (aes_out_ready & aes_run2) begin
            new_b <= aes_out;
        end
  //assign core_key = keccak_state[1599:1599-255]; //byte 0~31, AES-256 key

  //a : 32 byte 0~31  --> [1599:1344] 
  //b : 32 byte 32~63 --> [1343:1088] 
  //assign state_a  = keccak_state[1599:1344];
  //assign state_b  = keccak_state[1343:1088];
  //assign state_a  = 256'ha619f3adefcdcef6f147bc8b00c7058567728685f16abb169d324a1eb8122cff;
  //assign state_b  = 256'hff9445e4a1ba9cdbbddcdbe2e1db90452300ccb337988323a7a1bf949aaa3993;
  //assign state_a  = 256'hff2c12b81e4a329d16bb6af1858672678505c7008bbc47f1f6cecdefadf319a6;
  //assign state_b  = 256'h9339aa9a94bfa1a723839837b3cc00234590dbe1e2dbdcbddb9cbaa1e44594ff;
  
    // [stage] AES - signal
    assign state_a  = keccak_state[255:0];
    assign state_b  = keccak_state[511:256];
    assign state_ab = state_a^state_b;
    assign core_block = flag_aes_in_collision_d1 ? wdata_d1 : rdata;    

    // [stage] POST AES - signal
    //--variant processing begin
    wire [7:0] var_1;
    wire [7:0] idx;
    wire [7:0] tab;
    wire [7:0] var_2;
    wire [127:0] aes_xor_m;
    wire [127:0] aes_xor;

    assign aes_xor = core_b ^ new_b; 
    assign var_1 = aes_xor[95:88];
    assign idx = ((((var_1 >> 3) & 8'd6 ) | (var_1 & 8'd1)) <<1);
    assign tab = (32'h00075310 >> idx) & 8'h30;
    assign var_2 = var_1 ^ tab;
    assign aes_xor_m = variant_in ? {aes_xor[127:96],var_2,aes_xor[87:0]} : aes_xor;

    always @(posedge clk)
        if (post_aes)
            mul_op1 <= flag_mul_in_collision ? aes_xor_m[63:0] : rdata[63:0];

    always @(posedge clk)
        if (post_aes)
            mul_op2 <= new_b[63:0];

    always @(posedge clk)
        if (post_aes)
            post_aes_mem_rd <= flag_mul_in_collision ? aes_xor_m[127:0] : rdata[127:0];

    always @(posedge clk)
        if (post_aes)
            add_op2 <= core_a;

    // [stage] MUL & ADD - signal
    assign mul_16b = mul_op2 * mul_op1;
    always @(posedge clk)
        if(mul_add_run2) begin
            mul_addh <= mul_16b[63:0]   + add_op2[127:64]; //65-bit
            mul_addl <= mul_16b[127:64] + add_op2[63:0]; //65-bit
        end


    // [stage] POST ADD - signal
    //variant processing
    wire [63:0] mul_addh_m;
    wire [63:0] tweak_swap;

    assign tweak_swap = {tweak1_2[7:0],tweak1_2[15:8],tweak1_2[23:16],tweak1_2[31:24],tweak1_2[39:32],tweak1_2[47:40],tweak1_2[55:48],tweak1_2[63:56]};  
    assign mul_addh_m = variant_in ? mul_addh[63:0] ^ tweak_swap : mul_addh[63:0];
    assign mul_add_result = {mul_addh[63:0],mul_addl[63:0]};
    assign mul_add_result_m = {mul_addh_m[63:0],mul_addl[63:0]};
    assign new_a = mul_add_result ^ post_aes_mem_rd;

    always @ (posedge clk) begin
        if(reset) begin
            flag_aes_in_collision_d1 <= 0;
        end
        else if (post_add) begin
            flag_aes_in_collision_d1 <= flag_aes_in_collision;
        end
    end

    always @ (posedge clk) begin
        if(reset) begin
            wdata_d1 <= 128'd0;
        end else if (post_add) begin
            wdata_d1 <= mul_add_result_m[127:0];
        end else if (post_aes) begin
            wdata_d1 <= aes_xor_m;
        end
    end

    // -- SRAM control
    wire [6:0] ramctrl = {first_rd1, aes_run, aes_run2, mul_add_run, post_add, close_write};
    assign wdata = wdata_d1[127:0];
    always@* begin
        addr_a = core_b[20:4];
        addr_b = core_a[20:4];
        cs = 0;
        we = 0;
        //wdata = 128'h0;
        case (ramctrl)
            6'b100000 : begin //first_rd1
                addr_b = core_a[20:4]; // read for aes
                cs = 1;
            end
            6'b010000 : begin // aes_run
                addr_a = core_b[20:4]; // write as closure of mul-add stage
                //wdata = wdata_d1; // the mul-add tweak output
                we = (round_cnt == 0) ? 0 : 1;
                addr_b = core_a[20:4]; // keep read address for AES multicycle
                cs = 1;
            end
            6'b001000 : begin // aes_run2
                addr_b = aes_out[20:4]; // read for mul
                cs = 1;
            end
            6'b000100 : begin // mul_add_run
                addr_a = core_a[20:4]; // postpone write operation could improve timing
                //wdata = wdata_d1; // the aes xor b output
                we = 1;
                cs = 1;
            end
            6'b000010 : begin // post_add
                addr_b = new_a[20:4]; // read for aes
                cs = 1;
            end
            6'b000001 : begin // close_write
                addr_a = core_b[20:4];
                //wdata = wdata_d1;
                we = 1;
                cs = 1;
            end
            default : begin
                addr_a = core_b[20:4];
                addr_b = core_a[20:4];
                //wdata = 128'h0;
                cs = 0;
                we = 0;
            end
        endcase
    end

    always @(post_aes, core_a[20:4], new_b[20:4])
        if(post_aes) flag_mul_in_collision = (core_a[20:4] == new_b[20:4]);
        else         flag_mul_in_collision = 0;

    always @(post_add, new_a[20:4], new_b[20:4]) begin
        if(post_add)    flag_aes_in_collision = (new_a[20:4] == new_b[20:4]);
        else            flag_aes_in_collision = 0;
    end

  //----------------------------------------------------------------
  // aes instantiation.
  //----------------------------------------------------------------
    wire aes_go = aes_run | aes_run2;

    aes_encipher_phase2 u_aes_encipher_phase2(
                          .clk(clk),
                          .reset_n((~reset)),

                          .next(aes_go),

                          .round_key(core_a),
                          .block(core_block),
                          .new_block(aes_out),
                          .ready(aes_out_ready)
                         );


endmodule
