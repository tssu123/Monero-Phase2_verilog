//======================================================================
//
// aes_encipher_block.v
// --------------------
// The AES encipher round. A pure combinational module that implements
// the initial round, main round and final round logic for
// enciper operations.
//
//
// Author: Joachim Strombergson
// Copyright (c) 2013, 2014, Secworks Sweden AB
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

module aes_encipher_phase2(
                          input wire            clk,
                          input wire            reset_n,

                          input wire            next,

                          //input wire            keylen,
                          //output wire [3 : 0]   round,
                          input wire [127 : 0]  round_key,

                          //output wire [31 : 0]  sboxw,
                          //input wire  [31 : 0]  new_sboxw,

                          input wire [127 : 0]  block,
                          output wire [127 : 0] new_block,
                          output wire           ready
                          //input wire            stp
                         );


  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
// localparam AES_128_BIT_KEY = 1'h0;
// localparam AES_256_BIT_KEY = 1'h1;

//  localparam AES128_ROUNDS = 4'ha;
  //localparam AES256_ROUNDS = 4'he; //standard
  //localparam AES256_ROUNDS = 4'ha; //monreo
  //localparam AES256_ROUNDS = 4'h9; //monreo
//  localparam AES256_ROUNDS = 4'h0; //monreo

//  localparam NO_UPDATE    = 3'h0;
//  localparam INIT_UPDATE  = 3'h1;
//  localparam SFT_UPDATE   = 3'h2;
//  localparam SBOX_UPDATE  = 3'h2;
//  localparam MAIN_UPDATE  = 3'h3;
//  localparam FINAL_UPDATE = 3'h4;

//  localparam CTRL_IDLE  = 3'h0;
//  localparam CTRL_INIT  = 3'h1;
  //localparam CTRL_SFT   = 3'h2;
//  localparam CTRL_SBOX  = 3'h2;
//  localparam CTRL_MAIN  = 3'h3;
//  localparam CTRL_FINAL = 3'h4;


  //----------------------------------------------------------------
  // Round functions with sub functions.
  //----------------------------------------------------------------
/*
  function [31 : 0] table1(input [7 : 0] state);
  reg [31 : 0] tab1 [0 : 255]; 
    begin
  assign table1 = tab1[state];

 // always@*
 //  begin
   tab1[8'h00] = 32'ha56363c6;
   tab1[8'h01] = 32'h847c7cf8;
   tab1[8'h02] = 32'h997777ee;
   tab1[8'h03] = 32'h8d7b7bf6;
   tab1[8'h04] = 32'h0df2f2ff;
   tab1[8'h05] = 32'hbd6b6bd6;
   tab1[8'h06] = 32'hb16f6fde;
   tab1[8'h07] = 32'h54c5c591;
   tab1[8'h08] = 32'h50303060;
   tab1[8'h09] = 32'h03010102;
   tab1[8'h0a] = 32'ha96767ce;
   tab1[8'h0b] = 32'h7d2b2b56;
   tab1[8'h0c] = 32'h19fefee7;
   tab1[8'h0d] = 32'h62d7d7b5;
   tab1[8'h0e] = 32'he6abab4d;
   tab1[8'h0f] = 32'h9a7676ec;
   tab1[8'h10] = 32'h45caca8f;
   tab1[8'h11] = 32'h9d82821f;
   tab1[8'h12] = 32'h40c9c989;
   tab1[8'h13] = 32'h877d7dfa;
   tab1[8'h14] = 32'h15fafaef;
   tab1[8'h15] = 32'heb5959b2;
   tab1[8'h16] = 32'hc947478e;
   tab1[8'h17] = 32'h0bf0f0fb;
   tab1[8'h18] = 32'hecadad41;
   tab1[8'h19] = 32'h67d4d4b3;
   tab1[8'h1a] = 32'hfda2a25f;
   tab1[8'h1b] = 32'heaafaf45;
   tab1[8'h1c] = 32'hbf9c9c23;
   tab1[8'h1d] = 32'hf7a4a453;
   tab1[8'h1e] = 32'h967272e4;
   tab1[8'h1f] = 32'h5bc0c09b;
   tab1[8'h20] = 32'hc2b7b775;
   tab1[8'h21] = 32'h1cfdfde1;
   tab1[8'h22] = 32'hae93933d;
   tab1[8'h23] = 32'h6a26264c;
   tab1[8'h24] = 32'h5a36366c;
   tab1[8'h25] = 32'h413f3f7e;
   tab1[8'h26] = 32'h02f7f7f5;
   tab1[8'h27] = 32'h4fcccc83;
   tab1[8'h28] = 32'h5c343468;
   tab1[8'h29] = 32'hf4a5a551;
   tab1[8'h2a] = 32'h34e5e5d1;
   tab1[8'h2b] = 32'h08f1f1f9;
   tab1[8'h2c] = 32'h937171e2;
   tab1[8'h2d] = 32'h73d8d8ab;
   tab1[8'h2e] = 32'h53313162;
   tab1[8'h2f] = 32'h3f15152a;
   tab1[8'h30] = 32'h0c040408;
   tab1[8'h31] = 32'h52c7c795;
   tab1[8'h32] = 32'h65232346;
   tab1[8'h33] = 32'h5ec3c39d;
   tab1[8'h34] = 32'h28181830;
   tab1[8'h35] = 32'ha1969637;
   tab1[8'h36] = 32'h0f05050a;
   tab1[8'h37] = 32'hb59a9a2f;
   tab1[8'h38] = 32'h0907070e;
   tab1[8'h39] = 32'h36121224;
   tab1[8'h3a] = 32'h9b80801b;
   tab1[8'h3b] = 32'h3de2e2df;
   tab1[8'h3c] = 32'h26ebebcd;
   tab1[8'h3d] = 32'h6927274e;
   tab1[8'h3e] = 32'hcdb2b27f;
   tab1[8'h3f] = 32'h9f7575ea;
   tab1[8'h40] = 32'h1b090912;
   tab1[8'h41] = 32'h9e83831d;
   tab1[8'h42] = 32'h742c2c58;
   tab1[8'h43] = 32'h2e1a1a34;
   tab1[8'h44] = 32'h2d1b1b36;
   tab1[8'h45] = 32'hb26e6edc;
   tab1[8'h46] = 32'hee5a5ab4;
   tab1[8'h47] = 32'hfba0a05b;
   tab1[8'h48] = 32'hf65252a4;
   tab1[8'h49] = 32'h4d3b3b76;
   tab1[8'h4a] = 32'h61d6d6b7;
   tab1[8'h4b] = 32'hceb3b37d;
   tab1[8'h4c] = 32'h7b292952;
   tab1[8'h4d] = 32'h3ee3e3dd;
   tab1[8'h4e] = 32'h712f2f5e;
   tab1[8'h4f] = 32'h97848413;
   tab1[8'h50] = 32'hf55353a6;
   tab1[8'h51] = 32'h68d1d1b9;
   tab1[8'h52] = 32'h00000000;
   tab1[8'h53] = 32'h2cededc1;
   tab1[8'h54] = 32'h60202040;
   tab1[8'h55] = 32'h1ffcfce3;
   tab1[8'h56] = 32'hc8b1b179;
   tab1[8'h57] = 32'hed5b5bb6;
   tab1[8'h58] = 32'hbe6a6ad4;
   tab1[8'h59] = 32'h46cbcb8d;
   tab1[8'h5a] = 32'hd9bebe67;
   tab1[8'h5b] = 32'h4b393972;
   tab1[8'h5c] = 32'hde4a4a94;
   tab1[8'h5d] = 32'hd44c4c98;
   tab1[8'h5e] = 32'he85858b0;
   tab1[8'h5f] = 32'h4acfcf85;
   tab1[8'h60] = 32'h6bd0d0bb;
   tab1[8'h61] = 32'h2aefefc5;
   tab1[8'h62] = 32'he5aaaa4f;
   tab1[8'h63] = 32'h16fbfbed;
   tab1[8'h64] = 32'hc5434386;
   tab1[8'h65] = 32'hd74d4d9a;
   tab1[8'h66] = 32'h55333366;
   tab1[8'h67] = 32'h94858511;
   tab1[8'h68] = 32'hcf45458a;
   tab1[8'h69] = 32'h10f9f9e9;
   tab1[8'h6a] = 32'h06020204;
   tab1[8'h6b] = 32'h817f7ffe;
   tab1[8'h6c] = 32'hf05050a0;
   tab1[8'h6d] = 32'h443c3c78;
   tab1[8'h6e] = 32'hba9f9f25;
   tab1[8'h6f] = 32'he3a8a84b;
   tab1[8'h70] = 32'hf35151a2;
   tab1[8'h71] = 32'hfea3a35d;
   tab1[8'h72] = 32'hc0404080;
   tab1[8'h73] = 32'h8a8f8f05;
   tab1[8'h74] = 32'had92923f;
   tab1[8'h75] = 32'hbc9d9d21;
   tab1[8'h76] = 32'h48383870;
   tab1[8'h77] = 32'h04f5f5f1;
   tab1[8'h78] = 32'hdfbcbc63;
   tab1[8'h79] = 32'hc1b6b677;
   tab1[8'h7a] = 32'h75dadaaf;
   tab1[8'h7b] = 32'h63212142;
   tab1[8'h7c] = 32'h30101020;
   tab1[8'h7d] = 32'h1affffe5;
   tab1[8'h7e] = 32'h0ef3f3fd;
   tab1[8'h7f] = 32'h6dd2d2bf;
   tab1[8'h80] = 32'h4ccdcd81;
   tab1[8'h81] = 32'h140c0c18;
   tab1[8'h82] = 32'h35131326;
   tab1[8'h83] = 32'h2fececc3;
   tab1[8'h84] = 32'he15f5fbe;
   tab1[8'h85] = 32'ha2979735;
   tab1[8'h86] = 32'hcc444488;
   tab1[8'h87] = 32'h3917172e;
   tab1[8'h88] = 32'h57c4c493;
   tab1[8'h89] = 32'hf2a7a755;
   tab1[8'h8a] = 32'h827e7efc;
   tab1[8'h8b] = 32'h473d3d7a;
   tab1[8'h8c] = 32'hac6464c8;
   tab1[8'h8d] = 32'he75d5dba;
   tab1[8'h8e] = 32'h2b191932;
   tab1[8'h8f] = 32'h957373e6;
   tab1[8'h90] = 32'ha06060c0;
   tab1[8'h91] = 32'h98818119;
   tab1[8'h92] = 32'hd14f4f9e;
   tab1[8'h93] = 32'h7fdcdca3;
   tab1[8'h94] = 32'h66222244;
   tab1[8'h95] = 32'h7e2a2a54;
   tab1[8'h96] = 32'hab90903b;
   tab1[8'h97] = 32'h8388880b;
   tab1[8'h98] = 32'hca46468c;
   tab1[8'h99] = 32'h29eeeec7;
   tab1[8'h9a] = 32'hd3b8b86b;
   tab1[8'h9b] = 32'h3c141428;
   tab1[8'h9c] = 32'h79dedea7;
   tab1[8'h9d] = 32'he25e5ebc;
   tab1[8'h9e] = 32'h1d0b0b16;
   tab1[8'h9f] = 32'h76dbdbad;
   tab1[8'ha0] = 32'h3be0e0db;
   tab1[8'ha1] = 32'h56323264;
   tab1[8'ha2] = 32'h4e3a3a74;
   tab1[8'ha3] = 32'h1e0a0a14;
   tab1[8'ha4] = 32'hdb494992;
   tab1[8'ha5] = 32'h0a06060c;
   tab1[8'ha6] = 32'h6c242448;
   tab1[8'ha7] = 32'he45c5cb8;
   tab1[8'ha8] = 32'h5dc2c29f;
   tab1[8'ha9] = 32'h6ed3d3bd;
   tab1[8'haa] = 32'hefacac43;
   tab1[8'hab] = 32'ha66262c4;
   tab1[8'hac] = 32'ha8919139;
   tab1[8'had] = 32'ha4959531;
   tab1[8'hae] = 32'h37e4e4d3;
   tab1[8'haf] = 32'h8b7979f2;
   tab1[8'hb0] = 32'h32e7e7d5;
   tab1[8'hb1] = 32'h43c8c88b;
   tab1[8'hb2] = 32'h5937376e;
   tab1[8'hb3] = 32'hb76d6dda;
   tab1[8'hb4] = 32'h8c8d8d01;
   tab1[8'hb5] = 32'h64d5d5b1;
   tab1[8'hb6] = 32'hd24e4e9c;
   tab1[8'hb7] = 32'he0a9a949;
   tab1[8'hb8] = 32'hb46c6cd8;
   tab1[8'hb9] = 32'hfa5656ac;
   tab1[8'hba] = 32'h07f4f4f3;
   tab1[8'hbb] = 32'h25eaeacf;
   tab1[8'hbc] = 32'haf6565ca;
   tab1[8'hbd] = 32'h8e7a7af4;
   tab1[8'hbe] = 32'he9aeae47;
   tab1[8'hbf] = 32'h18080810;
   tab1[8'hc0] = 32'hd5baba6f;
   tab1[8'hc1] = 32'h887878f0;
   tab1[8'hc2] = 32'h6f25254a;
   tab1[8'hc3] = 32'h722e2e5c;
   tab1[8'hc4] = 32'h241c1c38;
   tab1[8'hc5] = 32'hf1a6a657;
   tab1[8'hc6] = 32'hc7b4b473;
   tab1[8'hc7] = 32'h51c6c697;
   tab1[8'hc8] = 32'h23e8e8cb;
   tab1[8'hc9] = 32'h7cdddda1;
   tab1[8'hca] = 32'h9c7474e8;
   tab1[8'hcb] = 32'h211f1f3e;
   tab1[8'hcc] = 32'hdd4b4b96;
   tab1[8'hcd] = 32'hdcbdbd61;
   tab1[8'hce] = 32'h868b8b0d;
   tab1[8'hcf] = 32'h858a8a0f;
   tab1[8'hd0] = 32'h907070e0;
   tab1[8'hd1] = 32'h423e3e7c;
   tab1[8'hd2] = 32'hc4b5b571;
   tab1[8'hd3] = 32'haa6666cc;
   tab1[8'hd4] = 32'hd8484890;
   tab1[8'hd5] = 32'h05030306;
   tab1[8'hd6] = 32'h01f6f6f7;
   tab1[8'hd7] = 32'h120e0e1c;
   tab1[8'hd8] = 32'ha36161c2;
   tab1[8'hd9] = 32'h5f35356a;
   tab1[8'hda] = 32'hf95757ae;
   tab1[8'hdb] = 32'hd0b9b969;
   tab1[8'hdc] = 32'h91868617;
   tab1[8'hdd] = 32'h58c1c199;
   tab1[8'hde] = 32'h271d1d3a;
   tab1[8'hdf] = 32'hb99e9e27;
   tab1[8'he0] = 32'h38e1e1d9;
   tab1[8'he1] = 32'h13f8f8eb;
   tab1[8'he2] = 32'hb398982b;
   tab1[8'he3] = 32'h33111122;
   tab1[8'he4] = 32'hbb6969d2;
   tab1[8'he5] = 32'h70d9d9a9;
   tab1[8'he6] = 32'h898e8e07;
   tab1[8'he7] = 32'ha7949433;
   tab1[8'he8] = 32'hb69b9b2d;
   tab1[8'he9] = 32'h221e1e3c;
   tab1[8'hea] = 32'h92878715;
   tab1[8'heb] = 32'h20e9e9c9;
   tab1[8'hec] = 32'h49cece87;
   tab1[8'hed] = 32'hff5555aa;
   tab1[8'hee] = 32'h78282850;
   tab1[8'hef] = 32'h7adfdfa5;
   tab1[8'hf0] = 32'h8f8c8c03;
   tab1[8'hf1] = 32'hf8a1a159;
   tab1[8'hf2] = 32'h80898909;
   tab1[8'hf3] = 32'h170d0d1a;
   tab1[8'hf4] = 32'hdabfbf65;
   tab1[8'hf5] = 32'h31e6e6d7;
   tab1[8'hf6] = 32'hc6424284;
   tab1[8'hf7] = 32'hb86868d0;
   tab1[8'hf8] = 32'hc3414182;
   tab1[8'hf9] = 32'hb0999929;
   tab1[8'hfa] = 32'h772d2d5a;
   tab1[8'hfb] = 32'h110f0f1e;
   tab1[8'hfc] = 32'hcbb0b07b;
   tab1[8'hfd] = 32'hfc5454a8;
   tab1[8'hfe] = 32'hd6bbbb6d;
   tab1[8'hff] = 32'h3a16162c;
  end
//endfunction // table1

//  function [31 : 0] table2(input [7 : 0] state);
  reg [31 : 0] tab2 [0 : 255]; 
//    begin
//  assign table2 = tab2[state];

   always@*
   begin
   tab2[8'h00] = 32'h6363c6a5;
   tab2[8'h01] = 32'h7c7cf884;
   tab2[8'h02] = 32'h7777ee99;
   tab2[8'h03] = 32'h7b7bf68d;
   tab2[8'h04] = 32'hf2f2ff0d;
   tab2[8'h05] = 32'h6b6bd6bd;
   tab2[8'h06] = 32'h6f6fdeb1;
   tab2[8'h07] = 32'hc5c59154;
   tab2[8'h08] = 32'h30306050;
   tab2[8'h09] = 32'h01010203;
   tab2[8'h0a] = 32'h6767cea9;
   tab2[8'h0b] = 32'h2b2b567d;
   tab2[8'h0c] = 32'hfefee719;
   tab2[8'h0d] = 32'hd7d7b562;
   tab2[8'h0e] = 32'habab4de6;
   tab2[8'h0f] = 32'h7676ec9a;
   tab2[8'h10] = 32'hcaca8f45;
   tab2[8'h11] = 32'h82821f9d;
   tab2[8'h12] = 32'hc9c98940;
   tab2[8'h13] = 32'h7d7dfa87;
   tab2[8'h14] = 32'hfafaef15;
   tab2[8'h15] = 32'h5959b2eb;
   tab2[8'h16] = 32'h47478ec9;
   tab2[8'h17] = 32'hf0f0fb0b;
   tab2[8'h18] = 32'hadad41ec;
   tab2[8'h19] = 32'hd4d4b367;
   tab2[8'h1a] = 32'ha2a25ffd;
   tab2[8'h1b] = 32'hafaf45ea;
   tab2[8'h1c] = 32'h9c9c23bf;
   tab2[8'h1d] = 32'ha4a453f7;
   tab2[8'h1e] = 32'h7272e496;
   tab2[8'h1f] = 32'hc0c09b5b;
   tab2[8'h20] = 32'hb7b775c2;
   tab2[8'h21] = 32'hfdfde11c;
   tab2[8'h22] = 32'h93933dae;
   tab2[8'h23] = 32'h26264c6a;
   tab2[8'h24] = 32'h36366c5a;
   tab2[8'h25] = 32'h3f3f7e41;
   tab2[8'h26] = 32'hf7f7f502;
   tab2[8'h27] = 32'hcccc834f;
   tab2[8'h28] = 32'h3434685c;
   tab2[8'h29] = 32'ha5a551f4;
   tab2[8'h2a] = 32'he5e5d134;
   tab2[8'h2b] = 32'hf1f1f908;
   tab2[8'h2c] = 32'h7171e293;
   tab2[8'h2d] = 32'hd8d8ab73;
   tab2[8'h2e] = 32'h31316253;
   tab2[8'h2f] = 32'h15152a3f;
   tab2[8'h30] = 32'h0404080c;
   tab2[8'h31] = 32'hc7c79552;
   tab2[8'h32] = 32'h23234665;
   tab2[8'h33] = 32'hc3c39d5e;
   tab2[8'h34] = 32'h18183028;
   tab2[8'h35] = 32'h969637a1;
   tab2[8'h36] = 32'h05050a0f;
   tab2[8'h37] = 32'h9a9a2fb5;
   tab2[8'h38] = 32'h07070e09;
   tab2[8'h39] = 32'h12122436;
   tab2[8'h3a] = 32'h80801b9b;
   tab2[8'h3b] = 32'he2e2df3d;
   tab2[8'h3c] = 32'hebebcd26;
   tab2[8'h3d] = 32'h27274e69;
   tab2[8'h3e] = 32'hb2b27fcd;
   tab2[8'h3f] = 32'h7575ea9f;
   tab2[8'h40] = 32'h0909121b;
   tab2[8'h41] = 32'h83831d9e;
   tab2[8'h42] = 32'h2c2c5874;
   tab2[8'h43] = 32'h1a1a342e;
   tab2[8'h44] = 32'h1b1b362d;
   tab2[8'h45] = 32'h6e6edcb2;
   tab2[8'h46] = 32'h5a5ab4ee;
   tab2[8'h47] = 32'ha0a05bfb;
   tab2[8'h48] = 32'h5252a4f6;
   tab2[8'h49] = 32'h3b3b764d;
   tab2[8'h4a] = 32'hd6d6b761;
   tab2[8'h4b] = 32'hb3b37dce;
   tab2[8'h4c] = 32'h2929527b;
   tab2[8'h4d] = 32'he3e3dd3e;
   tab2[8'h4e] = 32'h2f2f5e71;
   tab2[8'h4f] = 32'h84841397;
   tab2[8'h50] = 32'h5353a6f5;
   tab2[8'h51] = 32'hd1d1b968;
   tab2[8'h52] = 32'h00000000;
   tab2[8'h53] = 32'hededc12c;
   tab2[8'h54] = 32'h20204060;
   tab2[8'h55] = 32'hfcfce31f;
   tab2[8'h56] = 32'hb1b179c8;
   tab2[8'h57] = 32'h5b5bb6ed;
   tab2[8'h58] = 32'h6a6ad4be;
   tab2[8'h59] = 32'hcbcb8d46;
   tab2[8'h5a] = 32'hbebe67d9;
   tab2[8'h5b] = 32'h3939724b;
   tab2[8'h5c] = 32'h4a4a94de;
   tab2[8'h5d] = 32'h4c4c98d4;
   tab2[8'h5e] = 32'h5858b0e8;
   tab2[8'h5f] = 32'hcfcf854a;
   tab2[8'h60] = 32'hd0d0bb6b;
   tab2[8'h61] = 32'hefefc52a;
   tab2[8'h62] = 32'haaaa4fe5;
   tab2[8'h63] = 32'hfbfbed16;
   tab2[8'h64] = 32'h434386c5;
   tab2[8'h65] = 32'h4d4d9ad7;
   tab2[8'h66] = 32'h33336655;
   tab2[8'h67] = 32'h85851194;
   tab2[8'h68] = 32'h45458acf;
   tab2[8'h69] = 32'hf9f9e910;
   tab2[8'h6a] = 32'h02020406;
   tab2[8'h6b] = 32'h7f7ffe81;
   tab2[8'h6c] = 32'h5050a0f0;
   tab2[8'h6d] = 32'h3c3c7844;
   tab2[8'h6e] = 32'h9f9f25ba;
   tab2[8'h6f] = 32'ha8a84be3;
   tab2[8'h70] = 32'h5151a2f3;
   tab2[8'h71] = 32'ha3a35dfe;
   tab2[8'h72] = 32'h404080c0;
   tab2[8'h73] = 32'h8f8f058a;
   tab2[8'h74] = 32'h92923fad;
   tab2[8'h75] = 32'h9d9d21bc;
   tab2[8'h76] = 32'h38387048;
   tab2[8'h77] = 32'hf5f5f104;
   tab2[8'h78] = 32'hbcbc63df;
   tab2[8'h79] = 32'hb6b677c1;
   tab2[8'h7a] = 32'hdadaaf75;
   tab2[8'h7b] = 32'h21214263;
   tab2[8'h7c] = 32'h10102030;
   tab2[8'h7d] = 32'hffffe51a;
   tab2[8'h7e] = 32'hf3f3fd0e;
   tab2[8'h7f] = 32'hd2d2bf6d;
   tab2[8'h80] = 32'hcdcd814c;
   tab2[8'h81] = 32'h0c0c1814;
   tab2[8'h82] = 32'h13132635;
   tab2[8'h83] = 32'hececc32f;
   tab2[8'h84] = 32'h5f5fbee1;
   tab2[8'h85] = 32'h979735a2;
   tab2[8'h86] = 32'h444488cc;
   tab2[8'h87] = 32'h17172e39;
   tab2[8'h88] = 32'hc4c49357;
   tab2[8'h89] = 32'ha7a755f2;
   tab2[8'h8a] = 32'h7e7efc82;
   tab2[8'h8b] = 32'h3d3d7a47;
   tab2[8'h8c] = 32'h6464c8ac;
   tab2[8'h8d] = 32'h5d5dbae7;
   tab2[8'h8e] = 32'h1919322b;
   tab2[8'h8f] = 32'h7373e695;
   tab2[8'h90] = 32'h6060c0a0;
   tab2[8'h91] = 32'h81811998;
   tab2[8'h92] = 32'h4f4f9ed1;
   tab2[8'h93] = 32'hdcdca37f;
   tab2[8'h94] = 32'h22224466;
   tab2[8'h95] = 32'h2a2a547e;
   tab2[8'h96] = 32'h90903bab;
   tab2[8'h97] = 32'h88880b83;
   tab2[8'h98] = 32'h46468cca;
   tab2[8'h99] = 32'heeeec729;
   tab2[8'h9a] = 32'hb8b86bd3;
   tab2[8'h9b] = 32'h1414283c;
   tab2[8'h9c] = 32'hdedea779;
   tab2[8'h9d] = 32'h5e5ebce2;
   tab2[8'h9e] = 32'h0b0b161d;
   tab2[8'h9f] = 32'hdbdbad76;
   tab2[8'ha0] = 32'he0e0db3b;
   tab2[8'ha1] = 32'h32326456;
   tab2[8'ha2] = 32'h3a3a744e;
   tab2[8'ha3] = 32'h0a0a141e;
   tab2[8'ha4] = 32'h494992db;
   tab2[8'ha5] = 32'h06060c0a;
   tab2[8'ha6] = 32'h2424486c;
   tab2[8'ha7] = 32'h5c5cb8e4;
   tab2[8'ha8] = 32'hc2c29f5d;
   tab2[8'ha9] = 32'hd3d3bd6e;
   tab2[8'haa] = 32'hacac43ef;
   tab2[8'hab] = 32'h6262c4a6;
   tab2[8'hac] = 32'h919139a8;
   tab2[8'had] = 32'h959531a4;
   tab2[8'hae] = 32'he4e4d337;
   tab2[8'haf] = 32'h7979f28b;
   tab2[8'hb0] = 32'he7e7d532;
   tab2[8'hb1] = 32'hc8c88b43;
   tab2[8'hb2] = 32'h37376e59;
   tab2[8'hb3] = 32'h6d6ddab7;
   tab2[8'hb4] = 32'h8d8d018c;
   tab2[8'hb5] = 32'hd5d5b164;
   tab2[8'hb6] = 32'h4e4e9cd2;
   tab2[8'hb7] = 32'ha9a949e0;
   tab2[8'hb8] = 32'h6c6cd8b4;
   tab2[8'hb9] = 32'h5656acfa;
   tab2[8'hba] = 32'hf4f4f307;
   tab2[8'hbb] = 32'heaeacf25;
   tab2[8'hbc] = 32'h6565caaf;
   tab2[8'hbd] = 32'h7a7af48e;
   tab2[8'hbe] = 32'haeae47e9;
   tab2[8'hbf] = 32'h08081018;
   tab2[8'hc0] = 32'hbaba6fd5;
   tab2[8'hc1] = 32'h7878f088;
   tab2[8'hc2] = 32'h25254a6f;
   tab2[8'hc3] = 32'h2e2e5c72;
   tab2[8'hc4] = 32'h1c1c3824;
   tab2[8'hc5] = 32'ha6a657f1;
   tab2[8'hc6] = 32'hb4b473c7;
   tab2[8'hc7] = 32'hc6c69751;
   tab2[8'hc8] = 32'he8e8cb23;
   tab2[8'hc9] = 32'hdddda17c;
   tab2[8'hca] = 32'h7474e89c;
   tab2[8'hcb] = 32'h1f1f3e21;
   tab2[8'hcc] = 32'h4b4b96dd;
   tab2[8'hcd] = 32'hbdbd61dc;
   tab2[8'hce] = 32'h8b8b0d86;
   tab2[8'hcf] = 32'h8a8a0f85;
   tab2[8'hd0] = 32'h7070e090;
   tab2[8'hd1] = 32'h3e3e7c42;
   tab2[8'hd2] = 32'hb5b571c4;
   tab2[8'hd3] = 32'h6666ccaa;
   tab2[8'hd4] = 32'h484890d8;
   tab2[8'hd5] = 32'h03030605;
   tab2[8'hd6] = 32'hf6f6f701;
   tab2[8'hd7] = 32'h0e0e1c12;
   tab2[8'hd8] = 32'h6161c2a3;
   tab2[8'hd9] = 32'h35356a5f;
   tab2[8'hda] = 32'h5757aef9;
   tab2[8'hdb] = 32'hb9b969d0;
   tab2[8'hdc] = 32'h86861791;
   tab2[8'hdd] = 32'hc1c19958;
   tab2[8'hde] = 32'h1d1d3a27;
   tab2[8'hdf] = 32'h9e9e27b9;
   tab2[8'he0] = 32'he1e1d938;
   tab2[8'he1] = 32'hf8f8eb13;
   tab2[8'he2] = 32'h98982bb3;
   tab2[8'he3] = 32'h11112233;
   tab2[8'he4] = 32'h6969d2bb;
   tab2[8'he5] = 32'hd9d9a970;
   tab2[8'he6] = 32'h8e8e0789;
   tab2[8'he7] = 32'h949433a7;
   tab2[8'he8] = 32'h9b9b2db6;
   tab2[8'he9] = 32'h1e1e3c22;
   tab2[8'hea] = 32'h87871592;
   tab2[8'heb] = 32'he9e9c920;
   tab2[8'hec] = 32'hcece8749;
   tab2[8'hed] = 32'h5555aaff;
   tab2[8'hee] = 32'h28285078;
   tab2[8'hef] = 32'hdfdfa57a;
   tab2[8'hf0] = 32'h8c8c038f;
   tab2[8'hf1] = 32'ha1a159f8;
   tab2[8'hf2] = 32'h89890980;
   tab2[8'hf3] = 32'h0d0d1a17;
   tab2[8'hf4] = 32'hbfbf65da;
   tab2[8'hf5] = 32'he6e6d731;
   tab2[8'hf6] = 32'h424284c6;
   tab2[8'hf7] = 32'h6868d0b8;
   tab2[8'hf8] = 32'h414182c3;
   tab2[8'hf9] = 32'h999929b0;
   tab2[8'hfa] = 32'h2d2d5a77;
   tab2[8'hfb] = 32'h0f0f1e11;
   tab2[8'hfc] = 32'hb0b07bcb;
   tab2[8'hfd] = 32'h5454a8fc;
   tab2[8'hfe] = 32'hbbbb6dd6;
   tab2[8'hff] = 32'h16162c3a;
  end	
//endfunction // table2

//  function [31 : 0] table3(input [7 : 0] state);
  reg [31 : 0] tab3 [0 : 255];
//    begin
//  assign table3 = tab3[state];

   always@*
   begin
   tab3[8'h00] = 32'h63c6a563;
   tab3[8'h01] = 32'h7cf8847c;
   tab3[8'h02] = 32'h77ee9977;
   tab3[8'h03] = 32'h7bf68d7b;
   tab3[8'h04] = 32'hf2ff0df2;
   tab3[8'h05] = 32'h6bd6bd6b;
   tab3[8'h06] = 32'h6fdeb16f;
   tab3[8'h07] = 32'hc59154c5;
   tab3[8'h08] = 32'h30605030;
   tab3[8'h09] = 32'h01020301;
   tab3[8'h0a] = 32'h67cea967;
   tab3[8'h0b] = 32'h2b567d2b;
   tab3[8'h0c] = 32'hfee719fe;
   tab3[8'h0d] = 32'hd7b562d7;
   tab3[8'h0e] = 32'hab4de6ab;
   tab3[8'h0f] = 32'h76ec9a76;
   tab3[8'h10] = 32'hca8f45ca;
   tab3[8'h11] = 32'h821f9d82;
   tab3[8'h12] = 32'hc98940c9;
   tab3[8'h13] = 32'h7dfa877d;
   tab3[8'h14] = 32'hfaef15fa;
   tab3[8'h15] = 32'h59b2eb59;
   tab3[8'h16] = 32'h478ec947;
   tab3[8'h17] = 32'hf0fb0bf0;
   tab3[8'h18] = 32'had41ecad;
   tab3[8'h19] = 32'hd4b367d4;
   tab3[8'h1a] = 32'ha25ffda2;
   tab3[8'h1b] = 32'haf45eaaf;
   tab3[8'h1c] = 32'h9c23bf9c;
   tab3[8'h1d] = 32'ha453f7a4;
   tab3[8'h1e] = 32'h72e49672;
   tab3[8'h1f] = 32'hc09b5bc0;
   tab3[8'h20] = 32'hb775c2b7;
   tab3[8'h21] = 32'hfde11cfd;
   tab3[8'h22] = 32'h933dae93;
   tab3[8'h23] = 32'h264c6a26;
   tab3[8'h24] = 32'h366c5a36;
   tab3[8'h25] = 32'h3f7e413f;
   tab3[8'h26] = 32'hf7f502f7;
   tab3[8'h27] = 32'hcc834fcc;
   tab3[8'h28] = 32'h34685c34;
   tab3[8'h29] = 32'ha551f4a5;
   tab3[8'h2a] = 32'he5d134e5;
   tab3[8'h2b] = 32'hf1f908f1;
   tab3[8'h2c] = 32'h71e29371;
   tab3[8'h2d] = 32'hd8ab73d8;
   tab3[8'h2e] = 32'h31625331;
   tab3[8'h2f] = 32'h152a3f15;
   tab3[8'h30] = 32'h04080c04;
   tab3[8'h31] = 32'hc79552c7;
   tab3[8'h32] = 32'h23466523;
   tab3[8'h33] = 32'hc39d5ec3;
   tab3[8'h34] = 32'h18302818;
   tab3[8'h35] = 32'h9637a196;
   tab3[8'h36] = 32'h050a0f05;
   tab3[8'h37] = 32'h9a2fb59a;
   tab3[8'h38] = 32'h070e0907;
   tab3[8'h39] = 32'h12243612;
   tab3[8'h3a] = 32'h801b9b80;
   tab3[8'h3b] = 32'he2df3de2;
   tab3[8'h3c] = 32'hebcd26eb;
   tab3[8'h3d] = 32'h274e6927;
   tab3[8'h3e] = 32'hb27fcdb2;
   tab3[8'h3f] = 32'h75ea9f75;
   tab3[8'h40] = 32'h09121b09;
   tab3[8'h41] = 32'h831d9e83;
   tab3[8'h42] = 32'h2c58742c;
   tab3[8'h43] = 32'h1a342e1a;
   tab3[8'h44] = 32'h1b362d1b;
   tab3[8'h45] = 32'h6edcb26e;
   tab3[8'h46] = 32'h5ab4ee5a;
   tab3[8'h47] = 32'ha05bfba0;
   tab3[8'h48] = 32'h52a4f652;
   tab3[8'h49] = 32'h3b764d3b;
   tab3[8'h4a] = 32'hd6b761d6;
   tab3[8'h4b] = 32'hb37dceb3;
   tab3[8'h4c] = 32'h29527b29;
   tab3[8'h4d] = 32'he3dd3ee3;
   tab3[8'h4e] = 32'h2f5e712f;
   tab3[8'h4f] = 32'h84139784;
   tab3[8'h50] = 32'h53a6f553;
   tab3[8'h51] = 32'hd1b968d1;
   tab3[8'h52] = 32'h00000000;
   tab3[8'h53] = 32'hedc12ced;
   tab3[8'h54] = 32'h20406020;
   tab3[8'h55] = 32'hfce31ffc;
   tab3[8'h56] = 32'hb179c8b1;
   tab3[8'h57] = 32'h5bb6ed5b;
   tab3[8'h58] = 32'h6ad4be6a;
   tab3[8'h59] = 32'hcb8d46cb;
   tab3[8'h5a] = 32'hbe67d9be;
   tab3[8'h5b] = 32'h39724b39;
   tab3[8'h5c] = 32'h4a94de4a;
   tab3[8'h5d] = 32'h4c98d44c;
   tab3[8'h5e] = 32'h58b0e858;
   tab3[8'h5f] = 32'hcf854acf;
   tab3[8'h60] = 32'hd0bb6bd0;
   tab3[8'h61] = 32'hefc52aef;
   tab3[8'h62] = 32'haa4fe5aa;
   tab3[8'h63] = 32'hfbed16fb;
   tab3[8'h64] = 32'h4386c543;
   tab3[8'h65] = 32'h4d9ad74d;
   tab3[8'h66] = 32'h33665533;
   tab3[8'h67] = 32'h85119485;
   tab3[8'h68] = 32'h458acf45;
   tab3[8'h69] = 32'hf9e910f9;
   tab3[8'h6a] = 32'h02040602;
   tab3[8'h6b] = 32'h7ffe817f;
   tab3[8'h6c] = 32'h50a0f050;
   tab3[8'h6d] = 32'h3c78443c;
   tab3[8'h6e] = 32'h9f25ba9f;
   tab3[8'h6f] = 32'ha84be3a8;
   tab3[8'h70] = 32'h51a2f351;
   tab3[8'h71] = 32'ha35dfea3;
   tab3[8'h72] = 32'h4080c040;
   tab3[8'h73] = 32'h8f058a8f;
   tab3[8'h74] = 32'h923fad92;
   tab3[8'h75] = 32'h9d21bc9d;
   tab3[8'h76] = 32'h38704838;
   tab3[8'h77] = 32'hf5f104f5;
   tab3[8'h78] = 32'hbc63dfbc;
   tab3[8'h79] = 32'hb677c1b6;
   tab3[8'h7a] = 32'hdaaf75da;
   tab3[8'h7b] = 32'h21426321;
   tab3[8'h7c] = 32'h10203010;
   tab3[8'h7d] = 32'hffe51aff;
   tab3[8'h7e] = 32'hf3fd0ef3;
   tab3[8'h7f] = 32'hd2bf6dd2;
   tab3[8'h80] = 32'hcd814ccd;
   tab3[8'h81] = 32'h0c18140c;
   tab3[8'h82] = 32'h13263513;
   tab3[8'h83] = 32'hecc32fec;
   tab3[8'h84] = 32'h5fbee15f;
   tab3[8'h85] = 32'h9735a297;
   tab3[8'h86] = 32'h4488cc44;
   tab3[8'h87] = 32'h172e3917;
   tab3[8'h88] = 32'hc49357c4;
   tab3[8'h89] = 32'ha755f2a7;
   tab3[8'h8a] = 32'h7efc827e;
   tab3[8'h8b] = 32'h3d7a473d;
   tab3[8'h8c] = 32'h64c8ac64;
   tab3[8'h8d] = 32'h5dbae75d;
   tab3[8'h8e] = 32'h19322b19;
   tab3[8'h8f] = 32'h73e69573;
   tab3[8'h90] = 32'h60c0a060;
   tab3[8'h91] = 32'h81199881;
   tab3[8'h92] = 32'h4f9ed14f;
   tab3[8'h93] = 32'hdca37fdc;
   tab3[8'h94] = 32'h22446622;
   tab3[8'h95] = 32'h2a547e2a;
   tab3[8'h96] = 32'h903bab90;
   tab3[8'h97] = 32'h880b8388;
   tab3[8'h98] = 32'h468cca46;
   tab3[8'h99] = 32'heec729ee;
   tab3[8'h9a] = 32'hb86bd3b8;
   tab3[8'h9b] = 32'h14283c14;
   tab3[8'h9c] = 32'hdea779de;
   tab3[8'h9d] = 32'h5ebce25e;
   tab3[8'h9e] = 32'h0b161d0b;
   tab3[8'h9f] = 32'hdbad76db;
   tab3[8'ha0] = 32'he0db3be0;
   tab3[8'ha1] = 32'h32645632;
   tab3[8'ha2] = 32'h3a744e3a;
   tab3[8'ha3] = 32'h0a141e0a;
   tab3[8'ha4] = 32'h4992db49;
   tab3[8'ha5] = 32'h060c0a06;
   tab3[8'ha6] = 32'h24486c24;
   tab3[8'ha7] = 32'h5cb8e45c;
   tab3[8'ha8] = 32'hc29f5dc2;
   tab3[8'ha9] = 32'hd3bd6ed3;
   tab3[8'haa] = 32'hac43efac;
   tab3[8'hab] = 32'h62c4a662;
   tab3[8'hac] = 32'h9139a891;
   tab3[8'had] = 32'h9531a495;
   tab3[8'hae] = 32'he4d337e4;
   tab3[8'haf] = 32'h79f28b79;
   tab3[8'hb0] = 32'he7d532e7;
   tab3[8'hb1] = 32'hc88b43c8;
   tab3[8'hb2] = 32'h376e5937;
   tab3[8'hb3] = 32'h6ddab76d;
   tab3[8'hb4] = 32'h8d018c8d;
   tab3[8'hb5] = 32'hd5b164d5;
   tab3[8'hb6] = 32'h4e9cd24e;
   tab3[8'hb7] = 32'ha949e0a9;
   tab3[8'hb8] = 32'h6cd8b46c;
   tab3[8'hb9] = 32'h56acfa56;
   tab3[8'hba] = 32'hf4f307f4;
   tab3[8'hbb] = 32'heacf25ea;
   tab3[8'hbc] = 32'h65caaf65;
   tab3[8'hbd] = 32'h7af48e7a;
   tab3[8'hbe] = 32'hae47e9ae;
   tab3[8'hbf] = 32'h08101808;
   tab3[8'hc0] = 32'hba6fd5ba;
   tab3[8'hc1] = 32'h78f08878;
   tab3[8'hc2] = 32'h254a6f25;
   tab3[8'hc3] = 32'h2e5c722e;
   tab3[8'hc4] = 32'h1c38241c;
   tab3[8'hc5] = 32'ha657f1a6;
   tab3[8'hc6] = 32'hb473c7b4;
   tab3[8'hc7] = 32'hc69751c6;
   tab3[8'hc8] = 32'he8cb23e8;
   tab3[8'hc9] = 32'hdda17cdd;
   tab3[8'hca] = 32'h74e89c74;
   tab3[8'hcb] = 32'h1f3e211f;
   tab3[8'hcc] = 32'h4b96dd4b;
   tab3[8'hcd] = 32'hbd61dcbd;
   tab3[8'hce] = 32'h8b0d868b;
   tab3[8'hcf] = 32'h8a0f858a;
   tab3[8'hd0] = 32'h70e09070;
   tab3[8'hd1] = 32'h3e7c423e;
   tab3[8'hd2] = 32'hb571c4b5;
   tab3[8'hd3] = 32'h66ccaa66;
   tab3[8'hd4] = 32'h4890d848;
   tab3[8'hd5] = 32'h03060503;
   tab3[8'hd6] = 32'hf6f701f6;
   tab3[8'hd7] = 32'h0e1c120e;
   tab3[8'hd8] = 32'h61c2a361;
   tab3[8'hd9] = 32'h356a5f35;
   tab3[8'hda] = 32'h57aef957;
   tab3[8'hdb] = 32'hb969d0b9;
   tab3[8'hdc] = 32'h86179186;
   tab3[8'hdd] = 32'hc19958c1;
   tab3[8'hde] = 32'h1d3a271d;
   tab3[8'hdf] = 32'h9e27b99e;
   tab3[8'he0] = 32'he1d938e1;
   tab3[8'he1] = 32'hf8eb13f8;
   tab3[8'he2] = 32'h982bb398;
   tab3[8'he3] = 32'h11223311;
   tab3[8'he4] = 32'h69d2bb69;
   tab3[8'he5] = 32'hd9a970d9;
   tab3[8'he6] = 32'h8e07898e;
   tab3[8'he7] = 32'h9433a794;
   tab3[8'he8] = 32'h9b2db69b;
   tab3[8'he9] = 32'h1e3c221e;
   tab3[8'hea] = 32'h87159287;
   tab3[8'heb] = 32'he9c920e9;
   tab3[8'hec] = 32'hce8749ce;
   tab3[8'hed] = 32'h55aaff55;
   tab3[8'hee] = 32'h28507828;
   tab3[8'hef] = 32'hdfa57adf;
   tab3[8'hf0] = 32'h8c038f8c;
   tab3[8'hf1] = 32'ha159f8a1;
   tab3[8'hf2] = 32'h89098089;
   tab3[8'hf3] = 32'h0d1a170d;
   tab3[8'hf4] = 32'hbf65dabf;
   tab3[8'hf5] = 32'he6d731e6;
   tab3[8'hf6] = 32'h4284c642;
   tab3[8'hf7] = 32'h68d0b868;
   tab3[8'hf8] = 32'h4182c341;
   tab3[8'hf9] = 32'h9929b099;
   tab3[8'hfa] = 32'h2d5a772d;
   tab3[8'hfb] = 32'h0f1e110f;
   tab3[8'hfc] = 32'hb07bcbb0;
   tab3[8'hfd] = 32'h54a8fc54;
   tab3[8'hfe] = 32'hbb6dd6bb;
   tab3[8'hff] = 32'h162c3a16;
  end
//endfunction // table3

//  function [31 : 0] table4(input [7 : 0] state);
  reg [31 : 0] tab4 [0 : 255];
//    begin
//  assign table4 = tab4[state];

   always@*
   begin
   tab4[8'h00] = 32'hc6a56363;
   tab4[8'h01] = 32'hf8847c7c;
   tab4[8'h02] = 32'hee997777;
   tab4[8'h03] = 32'hf68d7b7b;
   tab4[8'h04] = 32'hff0df2f2;
   tab4[8'h05] = 32'hd6bd6b6b;
   tab4[8'h06] = 32'hdeb16f6f;
   tab4[8'h07] = 32'h9154c5c5;
   tab4[8'h08] = 32'h60503030;
   tab4[8'h09] = 32'h02030101;
   tab4[8'h0a] = 32'hcea96767;
   tab4[8'h0b] = 32'h567d2b2b;
   tab4[8'h0c] = 32'he719fefe;
   tab4[8'h0d] = 32'hb562d7d7;
   tab4[8'h0e] = 32'h4de6abab;
   tab4[8'h0f] = 32'hec9a7676;
   tab4[8'h10] = 32'h8f45caca;
   tab4[8'h11] = 32'h1f9d8282;
   tab4[8'h12] = 32'h8940c9c9;
   tab4[8'h13] = 32'hfa877d7d;
   tab4[8'h14] = 32'hef15fafa;
   tab4[8'h15] = 32'hb2eb5959;
   tab4[8'h16] = 32'h8ec94747;
   tab4[8'h17] = 32'hfb0bf0f0;
   tab4[8'h18] = 32'h41ecadad;
   tab4[8'h19] = 32'hb367d4d4;
   tab4[8'h1a] = 32'h5ffda2a2;
   tab4[8'h1b] = 32'h45eaafaf;
   tab4[8'h1c] = 32'h23bf9c9c;
   tab4[8'h1d] = 32'h53f7a4a4;
   tab4[8'h1e] = 32'he4967272;
   tab4[8'h1f] = 32'h9b5bc0c0;
   tab4[8'h20] = 32'h75c2b7b7;
   tab4[8'h21] = 32'he11cfdfd;
   tab4[8'h22] = 32'h3dae9393;
   tab4[8'h23] = 32'h4c6a2626;
   tab4[8'h24] = 32'h6c5a3636;
   tab4[8'h25] = 32'h7e413f3f;
   tab4[8'h26] = 32'hf502f7f7;
   tab4[8'h27] = 32'h834fcccc;
   tab4[8'h28] = 32'h685c3434;
   tab4[8'h29] = 32'h51f4a5a5;
   tab4[8'h2a] = 32'hd134e5e5;
   tab4[8'h2b] = 32'hf908f1f1;
   tab4[8'h2c] = 32'he2937171;
   tab4[8'h2d] = 32'hab73d8d8;
   tab4[8'h2e] = 32'h62533131;
   tab4[8'h2f] = 32'h2a3f1515;
   tab4[8'h30] = 32'h080c0404;
   tab4[8'h31] = 32'h9552c7c7;
   tab4[8'h32] = 32'h46652323;
   tab4[8'h33] = 32'h9d5ec3c3;
   tab4[8'h34] = 32'h30281818;
   tab4[8'h35] = 32'h37a19696;
   tab4[8'h36] = 32'h0a0f0505;
   tab4[8'h37] = 32'h2fb59a9a;
   tab4[8'h38] = 32'h0e090707;
   tab4[8'h39] = 32'h24361212;
   tab4[8'h3a] = 32'h1b9b8080;
   tab4[8'h3b] = 32'hdf3de2e2;
   tab4[8'h3c] = 32'hcd26ebeb;
   tab4[8'h3d] = 32'h4e692727;
   tab4[8'h3e] = 32'h7fcdb2b2;
   tab4[8'h3f] = 32'hea9f7575;
   tab4[8'h40] = 32'h121b0909;
   tab4[8'h41] = 32'h1d9e8383;
   tab4[8'h42] = 32'h58742c2c;
   tab4[8'h43] = 32'h342e1a1a;
   tab4[8'h44] = 32'h362d1b1b;
   tab4[8'h45] = 32'hdcb26e6e;
   tab4[8'h46] = 32'hb4ee5a5a;
   tab4[8'h47] = 32'h5bfba0a0;
   tab4[8'h48] = 32'ha4f65252;
   tab4[8'h49] = 32'h764d3b3b;
   tab4[8'h4a] = 32'hb761d6d6;
   tab4[8'h4b] = 32'h7dceb3b3;
   tab4[8'h4c] = 32'h527b2929;
   tab4[8'h4d] = 32'hdd3ee3e3;
   tab4[8'h4e] = 32'h5e712f2f;
   tab4[8'h4f] = 32'h13978484;
   tab4[8'h50] = 32'ha6f55353;
   tab4[8'h51] = 32'hb968d1d1;
   tab4[8'h52] = 32'h00000000;
   tab4[8'h53] = 32'hc12ceded;
   tab4[8'h54] = 32'h40602020;
   tab4[8'h55] = 32'he31ffcfc;
   tab4[8'h56] = 32'h79c8b1b1;
   tab4[8'h57] = 32'hb6ed5b5b;
   tab4[8'h58] = 32'hd4be6a6a;
   tab4[8'h59] = 32'h8d46cbcb;
   tab4[8'h5a] = 32'h67d9bebe;
   tab4[8'h5b] = 32'h724b3939;
   tab4[8'h5c] = 32'h94de4a4a;
   tab4[8'h5d] = 32'h98d44c4c;
   tab4[8'h5e] = 32'hb0e85858;
   tab4[8'h5f] = 32'h854acfcf;
   tab4[8'h60] = 32'hbb6bd0d0;
   tab4[8'h61] = 32'hc52aefef;
   tab4[8'h62] = 32'h4fe5aaaa;
   tab4[8'h63] = 32'hed16fbfb;
   tab4[8'h64] = 32'h86c54343;
   tab4[8'h65] = 32'h9ad74d4d;
   tab4[8'h66] = 32'h66553333;
   tab4[8'h67] = 32'h11948585;
   tab4[8'h68] = 32'h8acf4545;
   tab4[8'h69] = 32'he910f9f9;
   tab4[8'h6a] = 32'h04060202;
   tab4[8'h6b] = 32'hfe817f7f;
   tab4[8'h6c] = 32'ha0f05050;
   tab4[8'h6d] = 32'h78443c3c;
   tab4[8'h6e] = 32'h25ba9f9f;
   tab4[8'h6f] = 32'h4be3a8a8;
   tab4[8'h70] = 32'ha2f35151;
   tab4[8'h71] = 32'h5dfea3a3;
   tab4[8'h72] = 32'h80c04040;
   tab4[8'h73] = 32'h058a8f8f;
   tab4[8'h74] = 32'h3fad9292;
   tab4[8'h75] = 32'h21bc9d9d;
   tab4[8'h76] = 32'h70483838;
   tab4[8'h77] = 32'hf104f5f5;
   tab4[8'h78] = 32'h63dfbcbc;
   tab4[8'h79] = 32'h77c1b6b6;
   tab4[8'h7a] = 32'haf75dada;
   tab4[8'h7b] = 32'h42632121;
   tab4[8'h7c] = 32'h20301010;
   tab4[8'h7d] = 32'he51affff;
   tab4[8'h7e] = 32'hfd0ef3f3;
   tab4[8'h7f] = 32'hbf6dd2d2;
   tab4[8'h80] = 32'h814ccdcd;
   tab4[8'h81] = 32'h18140c0c;
   tab4[8'h82] = 32'h26351313;
   tab4[8'h83] = 32'hc32fecec;
   tab4[8'h84] = 32'hbee15f5f;
   tab4[8'h85] = 32'h35a29797;
   tab4[8'h86] = 32'h88cc4444;
   tab4[8'h87] = 32'h2e391717;
   tab4[8'h88] = 32'h9357c4c4;
   tab4[8'h89] = 32'h55f2a7a7;
   tab4[8'h8a] = 32'hfc827e7e;
   tab4[8'h8b] = 32'h7a473d3d;
   tab4[8'h8c] = 32'hc8ac6464;
   tab4[8'h8d] = 32'hbae75d5d;
   tab4[8'h8e] = 32'h322b1919;
   tab4[8'h8f] = 32'he6957373;
   tab4[8'h90] = 32'hc0a06060;
   tab4[8'h91] = 32'h19988181;
   tab4[8'h92] = 32'h9ed14f4f;
   tab4[8'h93] = 32'ha37fdcdc;
   tab4[8'h94] = 32'h44662222;
   tab4[8'h95] = 32'h547e2a2a;
   tab4[8'h96] = 32'h3bab9090;
   tab4[8'h97] = 32'h0b838888;
   tab4[8'h98] = 32'h8cca4646;
   tab4[8'h99] = 32'hc729eeee;
   tab4[8'h9a] = 32'h6bd3b8b8;
   tab4[8'h9b] = 32'h283c1414;
   tab4[8'h9c] = 32'ha779dede;
   tab4[8'h9d] = 32'hbce25e5e;
   tab4[8'h9e] = 32'h161d0b0b;
   tab4[8'h9f] = 32'had76dbdb;
   tab4[8'ha0] = 32'hdb3be0e0;
   tab4[8'ha1] = 32'h64563232;
   tab4[8'ha2] = 32'h744e3a3a;
   tab4[8'ha3] = 32'h141e0a0a;
   tab4[8'ha4] = 32'h92db4949;
   tab4[8'ha5] = 32'h0c0a0606;
   tab4[8'ha6] = 32'h486c2424;
   tab4[8'ha7] = 32'hb8e45c5c;
   tab4[8'ha8] = 32'h9f5dc2c2;
   tab4[8'ha9] = 32'hbd6ed3d3;
   tab4[8'haa] = 32'h43efacac;
   tab4[8'hab] = 32'hc4a66262;
   tab4[8'hac] = 32'h39a89191;
   tab4[8'had] = 32'h31a49595;
   tab4[8'hae] = 32'hd337e4e4;
   tab4[8'haf] = 32'hf28b7979;
   tab4[8'hb0] = 32'hd532e7e7;
   tab4[8'hb1] = 32'h8b43c8c8;
   tab4[8'hb2] = 32'h6e593737;
   tab4[8'hb3] = 32'hdab76d6d;
   tab4[8'hb4] = 32'h018c8d8d;
   tab4[8'hb5] = 32'hb164d5d5;
   tab4[8'hb6] = 32'h9cd24e4e;
   tab4[8'hb7] = 32'h49e0a9a9;
   tab4[8'hb8] = 32'hd8b46c6c;
   tab4[8'hb9] = 32'hacfa5656;
   tab4[8'hba] = 32'hf307f4f4;
   tab4[8'hbb] = 32'hcf25eaea;
   tab4[8'hbc] = 32'hcaaf6565;
   tab4[8'hbd] = 32'hf48e7a7a;
   tab4[8'hbe] = 32'h47e9aeae;
   tab4[8'hbf] = 32'h10180808;
   tab4[8'hc0] = 32'h6fd5baba;
   tab4[8'hc1] = 32'hf0887878;
   tab4[8'hc2] = 32'h4a6f2525;
   tab4[8'hc3] = 32'h5c722e2e;
   tab4[8'hc4] = 32'h38241c1c;
   tab4[8'hc5] = 32'h57f1a6a6;
   tab4[8'hc6] = 32'h73c7b4b4;
   tab4[8'hc7] = 32'h9751c6c6;
   tab4[8'hc8] = 32'hcb23e8e8;
   tab4[8'hc9] = 32'ha17cdddd;
   tab4[8'hca] = 32'he89c7474;
   tab4[8'hcb] = 32'h3e211f1f;
   tab4[8'hcc] = 32'h96dd4b4b;
   tab4[8'hcd] = 32'h61dcbdbd;
   tab4[8'hce] = 32'h0d868b8b;
   tab4[8'hcf] = 32'h0f858a8a;
   tab4[8'hd0] = 32'he0907070;
   tab4[8'hd1] = 32'h7c423e3e;
   tab4[8'hd2] = 32'h71c4b5b5;
   tab4[8'hd3] = 32'hccaa6666;
   tab4[8'hd4] = 32'h90d84848;
   tab4[8'hd5] = 32'h06050303;
   tab4[8'hd6] = 32'hf701f6f6;
   tab4[8'hd7] = 32'h1c120e0e;
   tab4[8'hd8] = 32'hc2a36161;
   tab4[8'hd9] = 32'h6a5f3535;
   tab4[8'hda] = 32'haef95757;
   tab4[8'hdb] = 32'h69d0b9b9;
   tab4[8'hdc] = 32'h17918686;
   tab4[8'hdd] = 32'h9958c1c1;
   tab4[8'hde] = 32'h3a271d1d;
   tab4[8'hdf] = 32'h27b99e9e;
   tab4[8'he0] = 32'hd938e1e1;
   tab4[8'he1] = 32'heb13f8f8;
   tab4[8'he2] = 32'h2bb39898;
   tab4[8'he3] = 32'h22331111;
   tab4[8'he4] = 32'hd2bb6969;
   tab4[8'he5] = 32'ha970d9d9;
   tab4[8'he6] = 32'h07898e8e;
   tab4[8'he7] = 32'h33a79494;
   tab4[8'he8] = 32'h2db69b9b;
   tab4[8'he9] = 32'h3c221e1e;
   tab4[8'hea] = 32'h15928787;
   tab4[8'heb] = 32'hc920e9e9;
   tab4[8'hec] = 32'h8749cece;
   tab4[8'hed] = 32'haaff5555;
   tab4[8'hee] = 32'h50782828;
   tab4[8'hef] = 32'ha57adfdf;
   tab4[8'hf0] = 32'h038f8c8c;
   tab4[8'hf1] = 32'h59f8a1a1;
   tab4[8'hf2] = 32'h09808989;
   tab4[8'hf3] = 32'h1a170d0d;
   tab4[8'hf4] = 32'h65dabfbf;
   tab4[8'hf5] = 32'hd731e6e6;
   tab4[8'hf6] = 32'h84c64242;
   tab4[8'hf7] = 32'hd0b86868;
   tab4[8'hf8] = 32'h82c34141;
   tab4[8'hf9] = 32'h29b09999;
   tab4[8'hfa] = 32'h5a772d2d;
   tab4[8'hfb] = 32'h1e110f0f;
   tab4[8'hfc] = 32'h7bcbb0b0;
   tab4[8'hfd] = 32'ha8fc5454;
   tab4[8'hfe] = 32'h6dd6bbbb;
   tab4[8'hff] = 32'h2c3a1616;
  end
//endfunction // table4
*/

// function [7 : 0] gm2(input [7 : 0] op);
//   begin
//     gm2 = {op[6 : 0], 1'b0} ^ (8'h1b & {8{op[7]}});
//   end
// endfunction // gm2
//
// function [7 : 0] gm3(input [7 : 0] op);
//   begin
//     gm3 = gm2(op) ^ op;
//   end
// endfunction // gm3
//
// function [31 : 0] mixw(input [31 : 0] w);
//   reg [7 : 0] b0, b1, b2, b3;
//   reg [7 : 0] mb0, mb1, mb2, mb3;
//   begin
//     b0 = w[31 : 24];
//     b1 = w[23 : 16];
//     b2 = w[15 : 08];
//     b3 = w[07 : 00];
//
//     mb0 = gm2(b0) ^ gm3(b1) ^ b2      ^ b3;
//     mb1 = b0      ^ gm2(b1) ^ gm3(b2) ^ b3;
//     mb2 = b0      ^ b1      ^ gm2(b2) ^ gm3(b3);
//     mb3 = gm3(b0) ^ b1      ^ b2      ^ gm2(b3);
//
//     mixw = {mb0, mb1, mb2, mb3};
//   end
// endfunction // mixw
//
// function [127 : 0] mixcolumns(input [127 : 0] data);
//   reg [31 : 0] w0, w1, w2, w3;
//   reg [31 : 0] ws0, ws1, ws2, ws3;
//   begin
//     w0 = data[127 : 096];
//     w1 = data[095 : 064];
//     w2 = data[063 : 032];
//     w3 = data[031 : 000];
//
//     ws0 = mixw(w0);
//     ws1 = mixw(w1);
//     ws2 = mixw(w2);
//     ws3 = mixw(w3);
//
//     mixcolumns = {ws0, ws1, ws2, ws3};
//   end
// endfunction // mixcolumns
//
// function [127 : 0] shiftrows(input [127 : 0] data);
//   reg [31 : 0] w0, w1, w2, w3;
//   reg [31 : 0] ws0, ws1, ws2, ws3;
//   begin
//     w0 = data[127 : 096];
//     w1 = data[095 : 064];
//     w2 = data[063 : 032];
//     w3 = data[031 : 000];
//
//     ws0 = {w0[31 : 24], w1[23 : 16], w2[15 : 08], w3[07 : 00]};
//     ws1 = {w1[31 : 24], w2[23 : 16], w3[15 : 08], w0[07 : 00]};
//     ws2 = {w2[31 : 24], w3[23 : 16], w0[15 : 08], w1[07 : 00]};
//     ws3 = {w3[31 : 24], w0[23 : 16], w1[15 : 08], w2[07 : 00]};
//
//     shiftrows = {ws0, ws1, ws2, ws3};
//   end
// endfunction // shiftrows
//
// function [127 : 0] addroundkey(input [127 : 0] data, input [127 : 0] rkey);
//   begin
//     addroundkey = data ^ rkey;
//   end
// endfunction // addroundkey
wire [127:0] addrndkey;
//reg [127 : 0] state_in;
wire [127 : 0] state_in;
wire [31:0]   tab1_7_0   , tab2_47_40 , tab3_87_80 , tab4_127_120 ;
wire [31:0]   tab4_31_24 , tab1_39_32 , tab2_79_72 , tab3_119_112 ;
wire [31:0]   tab3_23_16 , tab4_63_56 , tab1_71_64 , tab2_111_104 ;
wire [31:0]   tab2_15_8  , tab3_55_48 , tab4_95_88 , tab1_103_96  ;


aes_table1 u_tab7_0(.tab1_i(state_in[7:0]), .tab1_o(tab1_7_0));
aes_table1 u_tab39_32(.tab1_i(state_in[39:32]), .tab1_o(tab1_39_32));
aes_table1 u_tab71_64(.tab1_i(state_in[71:64]), .tab1_o(tab1_71_64));
aes_table1 u_tab103_96(.tab1_i(state_in[103:96]), .tab1_o(tab1_103_96));

aes_table2 u_tab15_8(.tab2_i(state_in[15:8]), .tab2_o(tab2_15_8));
aes_table2 u_tab47_40(.tab2_i(state_in[47:40]), .tab2_o(tab2_47_40));
aes_table2 u_tab79_72(.tab2_i(state_in[79:72]), .tab2_o(tab2_79_72));
aes_table2 u_tab111_104(.tab2_i(state_in[111:104]), .tab2_o(tab2_111_104));

aes_table3 u_tab23_16(.tab3_i(state_in[23:16]), .tab3_o(tab3_23_16));
aes_table3 u_tab55_48(.tab3_i(state_in[55:48]), .tab3_o(tab3_55_48));
aes_table3 u_tab87_80(.tab3_i(state_in[87:80]), .tab3_o(tab3_87_80));
aes_table3 u_tab119_112(.tab3_i(state_in[119:112]), .tab3_o(tab3_119_112));

aes_table4 u_tab31_24(.tab4_i(state_in[31:24]), .tab4_o(tab4_31_24));
aes_table4 u_tab63_56(.tab4_i(state_in[63:56]), .tab4_o(tab4_63_56));
aes_table4 u_tab95_88(.tab4_i(state_in[95:88]), .tab4_o(tab4_95_88));
aes_table4 u_tab127_120(.tab4_i(state_in[127:120]), .tab4_o(tab4_127_120));

assign state_in = block;

assign addrndkey[31:0]  = (((tab1_7_0   ^ tab2_47_40) ^ (tab3_87_80 ^ tab4_127_120)) ^ round_key[31:0]  );
assign addrndkey[63:32] = (((tab4_31_24 ^ tab1_39_32) ^ (tab2_79_72 ^ tab3_119_112)) ^ round_key[63:32] );
assign addrndkey[95:64] = (((tab3_23_16 ^ tab4_63_56) ^ (tab1_71_64 ^ tab2_111_104)) ^ round_key[95:64] );
assign addrndkey[127:96]= (((tab2_15_8  ^ tab3_55_48) ^ (tab4_95_88 ^ tab1_103_96 )) ^ round_key[127:96]);

//assign addrndkey[31:0]  = table1(state_in[7:0])   ^ table2(state_in[47:40]) ^ table3(state_in[87:80]) ^ table4(state_in[127:120]) ^ round_key[31:0];
//assign addrndkey[63:32] = table4(state_in[31:24]) ^ table1(state_in[39:32]) ^ table2(state_in[79:72]) ^ table3(state_in[119:112]) ^ round_key[63:32];
//assign addrndkey[95:64] = table3(state_in[23:16]) ^ table4(state_in[63:56]) ^ table1(state_in[71:64]) ^ table2(state_in[111:104]) ^ round_key[95:64];
//assign addrndkey[127:96]= table2(state_in[15:8])  ^ table3(state_in[55:48]) ^ table4(state_in[95:88]) ^ table1(state_in[103:96])  ^ round_key[127:96];

//assign addrndkey[31:0]  = tab1[state_in[7:0]]   ^ tab2[state_in[47:40]] ^ tab3[state_in[87:80]] ^ tab4[state_in[127:120]] ^ round_key[31:0];
//assign addrndkey[63:32] = tab4[state_in[31:24]] ^ tab1[state_in[39:32]] ^ tab2[state_in[79:72]] ^ tab3[state_in[119:112]] ^ round_key[63:32];
//assign addrndkey[95:64] = tab3[state_in[23:16]] ^ tab4[state_in[63:56]] ^ tab1[state_in[71:64]] ^ tab2[state_in[111:104]] ^ round_key[95:64];
//assign addrndkey[127:96]= tab2[state_in[15:8]]  ^ tab3[state_in[55:48]] ^ tab4[state_in[95:88]] ^ tab1[state_in[103:96]]  ^ round_key[127:96];


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
//// reg [1 : 0]   sword_ctr_reg;
//// reg [1 : 0]   sword_ctr_new;
//// reg           sword_ctr_we;
//// reg           sword_ctr_inc;
//// reg           sword_ctr_rst;
////
//// reg [3 : 0]   round_ctr_reg;
//// reg [3 : 0]   round_ctr_new;
//// reg           round_ctr_we;
//// reg           round_ctr_rst;
//// reg           round_ctr_inc;
////
//// reg [127 : 0] block_new;
  //reg [127 : 0] block_shift;
  //reg [127 : 0] block_shift_in;
//// reg [31 : 0]  block_w0_reg;
//// reg [31 : 0]  block_w1_reg;
//// reg [31 : 0]  block_w2_reg;
//// reg [31 : 0]  block_w3_reg;
//// reg           block_w0_we;
//// reg           block_w1_we;
//// reg           block_w2_we;
//// reg           block_w3_we;
  //reg           block_sft_we;

//// reg           ready_reg;
//// reg           ready_new;
//// reg           ready_we;
////
//// reg [2 : 0]   enc_ctrl_reg;
//// reg [2 : 0]   enc_ctrl_new;
//// reg           enc_ctrl_we;


  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
//// reg [2 : 0]  update_type;
//// reg [31 : 0] muxed_sboxw;


  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
//// assign round     = round_ctr_reg;
//// assign sboxw     = muxed_sboxw;
  //assign new_block = {block_w0_reg, block_w1_reg, block_w2_reg, block_w3_reg};
  assign new_block = addrndkey;
  //assign ready     = ready_reg;
  assign ready     = next;


  //----------------------------------------------------------------
  // reg_update
  //
  // Update functionality for all registers in the core.
  // All registers are positive edge triggered with asynchronous
  // active low reset. All registers have write enable.
  //----------------------------------------------------------------
// always @ (posedge clk or negedge reset_n)
//     if (!reset_n)
//         state_in  <= 128'h0;
//     else if (block_w0_we)
//         state_in  <= block_new;

/*
  always @ (posedge clk or negedge reset_n)
    begin: reg_update
      if (!reset_n)
        begin
          block_w0_reg  <= 32'h0;
          block_w1_reg  <= 32'h0;
          block_w2_reg  <= 32'h0;
          block_w3_reg  <= 32'h0;
          sword_ctr_reg <= 2'h0;
          round_ctr_reg <= 4'h0;
          ready_reg     <= 1'b1;
          enc_ctrl_reg  <= CTRL_IDLE;
        end
      else
        begin
          if (block_w0_we)
            block_w0_reg <= block_new[127 : 096];

          if (block_w1_we)
            block_w1_reg <= block_new[095 : 064];

          if (block_w2_we)
            block_w2_reg <= block_new[063 : 032];

          if (block_w3_we)
            block_w3_reg <= block_new[031 : 000];

          if (sword_ctr_we)
            sword_ctr_reg <= sword_ctr_new;

          if (round_ctr_we)
            round_ctr_reg <= round_ctr_new;

          if (ready_we)
            ready_reg <= ready_new;

          if (enc_ctrl_we)
            enc_ctrl_reg <= enc_ctrl_new;
        end
    end // reg_update
*/
//  always @ (posedge clk or negedge reset_n)
//      if (!reset_n) block_shift_in <= 0;
//      else if (block_sft_we) block_shift_in <= block_shift;

  //----------------------------------------------------------------
  // round_logic
  //
  // The logic needed to implement init, main and final rounds.
  //----------------------------------------------------------------
/*
  always @*
    begin : round_logic
      reg [127 : 0] old_block, shiftrows_block, mixcolumns_block;
      reg [127 : 0] addkey_init_block, addkey_main_block, addkey_final_block;

      block_new   = 128'h0;
//      block_shift = 128'h0;
      muxed_sboxw = 32'h0;
      block_w0_we = 1'b0;
      block_w1_we = 1'b0;
      block_w2_we = 1'b0;
      block_w3_we = 1'b0;
//      block_sft_we = 1'b0;

     old_block          = {block_w0_reg, block_w1_reg, block_w2_reg, block_w3_reg};
//    shiftrows_block    = shiftrows(old_block);
//    mixcolumns_block   = mixcolumns(shiftrows_block);
//    addkey_init_block  = addroundkey(block, round_key);
//    addkey_main_block  = addroundkey(mixcolumns_block, round_key);
//    addkey_final_block = addroundkey(shiftrows_block, round_key);

//
//    old_block          = {block_w0_reg, block_w1_reg, block_w2_reg, block_w3_reg};
//    //shiftrows_block    = shiftrows(old_block);
//    shiftrows_block    = shiftrows(block_shift_in);
//    //mixcolumns_block   = mixcolumns(shiftrows_block);
//    mixcolumns_block   = mixcolumns(old_block);
//    addkey_init_block  = addroundkey(block, round_key);
//    addkey_main_block  = addroundkey(mixcolumns_block, round_key);
//    addkey_final_block = addroundkey(shiftrows_block, round_key);
//

      case (update_type)
        INIT_UPDATE:
          begin
            //block_new    = addkey_init_block;
            block_new    = block;
            //block_new    = shiftrows_block;
            //block_new    = addkey_main_block;
            block_w0_we  = 1'b1;
            block_w1_we  = 1'b1;
            block_w2_we  = 1'b1;
            block_w3_we  = 1'b1;
          end

        SBOX_UPDATE:
          begin
            block_new = {new_sboxw, new_sboxw, new_sboxw, new_sboxw};

            case (sword_ctr_reg)
              2'h0:
                begin
                  muxed_sboxw = block_w0_reg;
                  block_w0_we = 1'b1;
                end

              2'h1:
                begin
                  muxed_sboxw = block_w1_reg;
                  block_w1_we = 1'b1;
                end

              2'h2:
                begin
                  muxed_sboxw = block_w2_reg;
                  block_w2_we = 1'b1;
                end

              2'h3:
                begin
                  muxed_sboxw = block_w3_reg;
                  block_w3_we = 1'b1;
                end
            endcase // case (sbox_mux_ctrl_reg)
          end

        MAIN_UPDATE:
          begin
            //block_new    = addkey_main_block;
            block_new    = addrndkey;
            //block_shift    = addkey_main_block;
            //block_new    = shiftrows_block;
            block_w0_we  = 1'b1;
            block_w1_we  = 1'b1;
            block_w2_we  = 1'b1;
            block_w3_we  = 1'b1;
            //block_sft_we  = 1'b1;
          end

        FINAL_UPDATE:
          begin
            block_new    = addkey_final_block;
            block_w0_we  = 1'b1;
            block_w1_we  = 1'b1;
            block_w2_we  = 1'b1;
            block_w3_we  = 1'b1;
          end

        default:
          begin
          end
      endcase // case (update_type)
    end // round_logic
*/

  //----------------------------------------------------------------
  // sword_ctr
  //
  // The subbytes word counter with reset and increase logic.
  //----------------------------------------------------------------
/*
  always @*
    begin : sword_ctr
      sword_ctr_new = 2'h0;
      sword_ctr_we  = 1'b0;

      if (sword_ctr_rst)
        begin
          sword_ctr_new = 2'h0;
          sword_ctr_we  = 1'b1;
        end
      else if (sword_ctr_inc)
        begin
          sword_ctr_new = sword_ctr_reg + 1'b1;
          sword_ctr_we  = 1'b1;
        end
    end // sword_ctr
*/

  //----------------------------------------------------------------
  // round_ctr
  //
  // The round counter with reset and increase logic.
  //----------------------------------------------------------------
/*
  always @*
    begin : round_ctr
      round_ctr_new = 4'h0;
      round_ctr_we  = 1'b0;

      if (round_ctr_rst)
        begin
          round_ctr_new = 4'h0;
          round_ctr_we  = 1'b1;
        end
      else if (round_ctr_inc)
        begin
          round_ctr_new = round_ctr_reg + 1'b1;
          round_ctr_we  = 1'b1;
        end
    end // round_ctr
*/

  //----------------------------------------------------------------
  // encipher_ctrl
  //
  // The FSM that controls the encipher operations.
  //----------------------------------------------------------------
/*
  always @*
    begin: encipher_ctrl
      reg [3 : 0] num_rounds;

      // Default assignments.
      sword_ctr_inc = 1'b0;
      sword_ctr_rst = 1'b0;
      round_ctr_inc = 1'b0;
      round_ctr_rst = 1'b0;
      ready_new     = 1'b0;
      ready_we      = 1'b0;
      update_type   = NO_UPDATE;
      enc_ctrl_new  = CTRL_IDLE;
      enc_ctrl_we   = 1'b0;

      if (keylen == AES_256_BIT_KEY)
        begin
          num_rounds = AES256_ROUNDS;
        end
      else
        begin
          num_rounds = AES128_ROUNDS;
        end

      case(enc_ctrl_reg)
        CTRL_IDLE:
          begin
            if (next)
              begin
                round_ctr_rst = 1'b1;
                ready_new     = 1'b0;
                ready_we      = 1'b1;
                enc_ctrl_new  = CTRL_INIT;
                //enc_ctrl_new  = CTRL_SBOX;
                enc_ctrl_we   = 1'b1;
              end
            else if (stp)
              begin
                round_ctr_rst = 1'b1;
                ready_new     = 1'b0;
                ready_we      = 1'b1;
                //enc_ctrl_new  = CTRL_INIT;
                enc_ctrl_new  = CTRL_IDLE;
                enc_ctrl_we   = 1'b1;
              end
          end

        CTRL_INIT:
          begin
            //round_ctr_inc = 1'b1;
            //sword_ctr_rst = 1'b1;
            update_type   = INIT_UPDATE;
            //enc_ctrl_new  = CTRL_SBOX;
            enc_ctrl_new  = CTRL_MAIN;
            enc_ctrl_we   = 1'b1;
          end

//       CTRL_SFT:
//         begin
//           //round_ctr_inc = 1'b1;
//           //sword_ctr_rst = 1'b1;
//           //update_type   = INIT_UPDATE;
//           update_type   = SFT_UPDATE;
//           enc_ctrl_new  = CTRL_SBOX;
//           enc_ctrl_we   = 1'b1;
//         end

        CTRL_SBOX:
          begin
            sword_ctr_inc = 1'b1;
            update_type   = SBOX_UPDATE;
            if (sword_ctr_reg == 2'h3)
              begin
                enc_ctrl_new  = CTRL_MAIN;
                enc_ctrl_we   = 1'b1;
              end
          end

        CTRL_MAIN:
          begin
            sword_ctr_rst = 1'b1;
            round_ctr_inc = 1'b1;
            if (round_ctr_reg < num_rounds)
              begin
                update_type   = MAIN_UPDATE;
                //enc_ctrl_new  = CTRL_SBOX;
                enc_ctrl_new  = CTRL_MAIN;
                enc_ctrl_we   = 1'b1;
              end
            else
              begin
                //update_type  = FINAL_UPDATE;
                update_type  = MAIN_UPDATE;
                ready_new    = 1'b1;
                ready_we     = 1'b1;
                enc_ctrl_new = CTRL_IDLE;
                enc_ctrl_we  = 1'b1;
              end
          end

        default:
          begin
            // Empty. Just here to make the synthesis tool happy.
          end
      endcase // case (enc_ctrl_reg)
    end // encipher_ctrl
*/
endmodule // aes_encipher_block

//======================================================================
// EOF aes_encipher_block.v
//======================================================================
