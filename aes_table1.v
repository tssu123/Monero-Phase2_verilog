
module aes_table1(
                input wire [7 : 0]  tab1_i,
                output wire [31 : 0] tab1_o
               );


  //----------------------------------------------------------------
  // The sbox array.
  //----------------------------------------------------------------
  wire [31 : 0] tab1 [0 : 255];


  //----------------------------------------------------------------
  // Four parallel muxes.
  //----------------------------------------------------------------
  assign tab1_o = tab1[tab1_i];

  assign tab1[8'h00] = 32'ha56363c6;
  assign tab1[8'h01] = 32'h847c7cf8;
  assign tab1[8'h02] = 32'h997777ee;
  assign tab1[8'h03] = 32'h8d7b7bf6;
  assign tab1[8'h04] = 32'h0df2f2ff;
  assign tab1[8'h05] = 32'hbd6b6bd6;
  assign tab1[8'h06] = 32'hb16f6fde;
  assign tab1[8'h07] = 32'h54c5c591;
  assign tab1[8'h08] = 32'h50303060;
  assign tab1[8'h09] = 32'h03010102;
  assign tab1[8'h0a] = 32'ha96767ce;
  assign tab1[8'h0b] = 32'h7d2b2b56;
  assign tab1[8'h0c] = 32'h19fefee7;
  assign tab1[8'h0d] = 32'h62d7d7b5;
  assign tab1[8'h0e] = 32'he6abab4d;
  assign tab1[8'h0f] = 32'h9a7676ec;
  assign tab1[8'h10] = 32'h45caca8f;
  assign tab1[8'h11] = 32'h9d82821f;
  assign tab1[8'h12] = 32'h40c9c989;
  assign tab1[8'h13] = 32'h877d7dfa;
  assign tab1[8'h14] = 32'h15fafaef;
  assign tab1[8'h15] = 32'heb5959b2;
  assign tab1[8'h16] = 32'hc947478e;
  assign tab1[8'h17] = 32'h0bf0f0fb;
  assign tab1[8'h18] = 32'hecadad41;
  assign tab1[8'h19] = 32'h67d4d4b3;
  assign tab1[8'h1a] = 32'hfda2a25f;
  assign tab1[8'h1b] = 32'heaafaf45;
  assign tab1[8'h1c] = 32'hbf9c9c23;
  assign tab1[8'h1d] = 32'hf7a4a453;
  assign tab1[8'h1e] = 32'h967272e4;
  assign tab1[8'h1f] = 32'h5bc0c09b;
  assign tab1[8'h20] = 32'hc2b7b775;
  assign tab1[8'h21] = 32'h1cfdfde1;
  assign tab1[8'h22] = 32'hae93933d;
  assign tab1[8'h23] = 32'h6a26264c;
  assign tab1[8'h24] = 32'h5a36366c;
  assign tab1[8'h25] = 32'h413f3f7e;
  assign tab1[8'h26] = 32'h02f7f7f5;
  assign tab1[8'h27] = 32'h4fcccc83;
  assign tab1[8'h28] = 32'h5c343468;
  assign tab1[8'h29] = 32'hf4a5a551;
  assign tab1[8'h2a] = 32'h34e5e5d1;
  assign tab1[8'h2b] = 32'h08f1f1f9;
  assign tab1[8'h2c] = 32'h937171e2;
  assign tab1[8'h2d] = 32'h73d8d8ab;
  assign tab1[8'h2e] = 32'h53313162;
  assign tab1[8'h2f] = 32'h3f15152a;
  assign tab1[8'h30] = 32'h0c040408;
  assign tab1[8'h31] = 32'h52c7c795;
  assign tab1[8'h32] = 32'h65232346;
  assign tab1[8'h33] = 32'h5ec3c39d;
  assign tab1[8'h34] = 32'h28181830;
  assign tab1[8'h35] = 32'ha1969637;
  assign tab1[8'h36] = 32'h0f05050a;
  assign tab1[8'h37] = 32'hb59a9a2f;
  assign tab1[8'h38] = 32'h0907070e;
  assign tab1[8'h39] = 32'h36121224;
  assign tab1[8'h3a] = 32'h9b80801b;
  assign tab1[8'h3b] = 32'h3de2e2df;
  assign tab1[8'h3c] = 32'h26ebebcd;
  assign tab1[8'h3d] = 32'h6927274e;
  assign tab1[8'h3e] = 32'hcdb2b27f;
  assign tab1[8'h3f] = 32'h9f7575ea;
  assign tab1[8'h40] = 32'h1b090912;
  assign tab1[8'h41] = 32'h9e83831d;
  assign tab1[8'h42] = 32'h742c2c58;
  assign tab1[8'h43] = 32'h2e1a1a34;
  assign tab1[8'h44] = 32'h2d1b1b36;
  assign tab1[8'h45] = 32'hb26e6edc;
  assign tab1[8'h46] = 32'hee5a5ab4;
  assign tab1[8'h47] = 32'hfba0a05b;
  assign tab1[8'h48] = 32'hf65252a4;
  assign tab1[8'h49] = 32'h4d3b3b76;
  assign tab1[8'h4a] = 32'h61d6d6b7;
  assign tab1[8'h4b] = 32'hceb3b37d;
  assign tab1[8'h4c] = 32'h7b292952;
  assign tab1[8'h4d] = 32'h3ee3e3dd;
  assign tab1[8'h4e] = 32'h712f2f5e;
  assign tab1[8'h4f] = 32'h97848413;
  assign tab1[8'h50] = 32'hf55353a6;
  assign tab1[8'h51] = 32'h68d1d1b9;
  assign tab1[8'h52] = 32'h00000000;
  assign tab1[8'h53] = 32'h2cededc1;
  assign tab1[8'h54] = 32'h60202040;
  assign tab1[8'h55] = 32'h1ffcfce3;
  assign tab1[8'h56] = 32'hc8b1b179;
  assign tab1[8'h57] = 32'hed5b5bb6;
  assign tab1[8'h58] = 32'hbe6a6ad4;
  assign tab1[8'h59] = 32'h46cbcb8d;
  assign tab1[8'h5a] = 32'hd9bebe67;
  assign tab1[8'h5b] = 32'h4b393972;
  assign tab1[8'h5c] = 32'hde4a4a94;
  assign tab1[8'h5d] = 32'hd44c4c98;
  assign tab1[8'h5e] = 32'he85858b0;
  assign tab1[8'h5f] = 32'h4acfcf85;
  assign tab1[8'h60] = 32'h6bd0d0bb;
  assign tab1[8'h61] = 32'h2aefefc5;
  assign tab1[8'h62] = 32'he5aaaa4f;
  assign tab1[8'h63] = 32'h16fbfbed;
  assign tab1[8'h64] = 32'hc5434386;
  assign tab1[8'h65] = 32'hd74d4d9a;
  assign tab1[8'h66] = 32'h55333366;
  assign tab1[8'h67] = 32'h94858511;
  assign tab1[8'h68] = 32'hcf45458a;
  assign tab1[8'h69] = 32'h10f9f9e9;
  assign tab1[8'h6a] = 32'h06020204;
  assign tab1[8'h6b] = 32'h817f7ffe;
  assign tab1[8'h6c] = 32'hf05050a0;
  assign tab1[8'h6d] = 32'h443c3c78;
  assign tab1[8'h6e] = 32'hba9f9f25;
  assign tab1[8'h6f] = 32'he3a8a84b;
  assign tab1[8'h70] = 32'hf35151a2;
  assign tab1[8'h71] = 32'hfea3a35d;
  assign tab1[8'h72] = 32'hc0404080;
  assign tab1[8'h73] = 32'h8a8f8f05;
  assign tab1[8'h74] = 32'had92923f;
  assign tab1[8'h75] = 32'hbc9d9d21;
  assign tab1[8'h76] = 32'h48383870;
  assign tab1[8'h77] = 32'h04f5f5f1;
  assign tab1[8'h78] = 32'hdfbcbc63;
  assign tab1[8'h79] = 32'hc1b6b677;
  assign tab1[8'h7a] = 32'h75dadaaf;
  assign tab1[8'h7b] = 32'h63212142;
  assign tab1[8'h7c] = 32'h30101020;
  assign tab1[8'h7d] = 32'h1affffe5;
  assign tab1[8'h7e] = 32'h0ef3f3fd;
  assign tab1[8'h7f] = 32'h6dd2d2bf;
  assign tab1[8'h80] = 32'h4ccdcd81;
  assign tab1[8'h81] = 32'h140c0c18;
  assign tab1[8'h82] = 32'h35131326;
  assign tab1[8'h83] = 32'h2fececc3;
  assign tab1[8'h84] = 32'he15f5fbe;
  assign tab1[8'h85] = 32'ha2979735;
  assign tab1[8'h86] = 32'hcc444488;
  assign tab1[8'h87] = 32'h3917172e;
  assign tab1[8'h88] = 32'h57c4c493;
  assign tab1[8'h89] = 32'hf2a7a755;
  assign tab1[8'h8a] = 32'h827e7efc;
  assign tab1[8'h8b] = 32'h473d3d7a;
  assign tab1[8'h8c] = 32'hac6464c8;
  assign tab1[8'h8d] = 32'he75d5dba;
  assign tab1[8'h8e] = 32'h2b191932;
  assign tab1[8'h8f] = 32'h957373e6;
  assign tab1[8'h90] = 32'ha06060c0;
  assign tab1[8'h91] = 32'h98818119;
  assign tab1[8'h92] = 32'hd14f4f9e;
  assign tab1[8'h93] = 32'h7fdcdca3;
  assign tab1[8'h94] = 32'h66222244;
  assign tab1[8'h95] = 32'h7e2a2a54;
  assign tab1[8'h96] = 32'hab90903b;
  assign tab1[8'h97] = 32'h8388880b;
  assign tab1[8'h98] = 32'hca46468c;
  assign tab1[8'h99] = 32'h29eeeec7;
  assign tab1[8'h9a] = 32'hd3b8b86b;
  assign tab1[8'h9b] = 32'h3c141428;
  assign tab1[8'h9c] = 32'h79dedea7;
  assign tab1[8'h9d] = 32'he25e5ebc;
  assign tab1[8'h9e] = 32'h1d0b0b16;
  assign tab1[8'h9f] = 32'h76dbdbad;
  assign tab1[8'ha0] = 32'h3be0e0db;
  assign tab1[8'ha1] = 32'h56323264;
  assign tab1[8'ha2] = 32'h4e3a3a74;
  assign tab1[8'ha3] = 32'h1e0a0a14;
  assign tab1[8'ha4] = 32'hdb494992;
  assign tab1[8'ha5] = 32'h0a06060c;
  assign tab1[8'ha6] = 32'h6c242448;
  assign tab1[8'ha7] = 32'he45c5cb8;
  assign tab1[8'ha8] = 32'h5dc2c29f;
  assign tab1[8'ha9] = 32'h6ed3d3bd;
  assign tab1[8'haa] = 32'hefacac43;
  assign tab1[8'hab] = 32'ha66262c4;
  assign tab1[8'hac] = 32'ha8919139;
  assign tab1[8'had] = 32'ha4959531;
  assign tab1[8'hae] = 32'h37e4e4d3;
  assign tab1[8'haf] = 32'h8b7979f2;
  assign tab1[8'hb0] = 32'h32e7e7d5;
  assign tab1[8'hb1] = 32'h43c8c88b;
  assign tab1[8'hb2] = 32'h5937376e;
  assign tab1[8'hb3] = 32'hb76d6dda;
  assign tab1[8'hb4] = 32'h8c8d8d01;
  assign tab1[8'hb5] = 32'h64d5d5b1;
  assign tab1[8'hb6] = 32'hd24e4e9c;
  assign tab1[8'hb7] = 32'he0a9a949;
  assign tab1[8'hb8] = 32'hb46c6cd8;
  assign tab1[8'hb9] = 32'hfa5656ac;
  assign tab1[8'hba] = 32'h07f4f4f3;
  assign tab1[8'hbb] = 32'h25eaeacf;
  assign tab1[8'hbc] = 32'haf6565ca;
  assign tab1[8'hbd] = 32'h8e7a7af4;
  assign tab1[8'hbe] = 32'he9aeae47;
  assign tab1[8'hbf] = 32'h18080810;
  assign tab1[8'hc0] = 32'hd5baba6f;
  assign tab1[8'hc1] = 32'h887878f0;
  assign tab1[8'hc2] = 32'h6f25254a;
  assign tab1[8'hc3] = 32'h722e2e5c;
  assign tab1[8'hc4] = 32'h241c1c38;
  assign tab1[8'hc5] = 32'hf1a6a657;
  assign tab1[8'hc6] = 32'hc7b4b473;
  assign tab1[8'hc7] = 32'h51c6c697;
  assign tab1[8'hc8] = 32'h23e8e8cb;
  assign tab1[8'hc9] = 32'h7cdddda1;
  assign tab1[8'hca] = 32'h9c7474e8;
  assign tab1[8'hcb] = 32'h211f1f3e;
  assign tab1[8'hcc] = 32'hdd4b4b96;
  assign tab1[8'hcd] = 32'hdcbdbd61;
  assign tab1[8'hce] = 32'h868b8b0d;
  assign tab1[8'hcf] = 32'h858a8a0f;
  assign tab1[8'hd0] = 32'h907070e0;
  assign tab1[8'hd1] = 32'h423e3e7c;
  assign tab1[8'hd2] = 32'hc4b5b571;
  assign tab1[8'hd3] = 32'haa6666cc;
  assign tab1[8'hd4] = 32'hd8484890;
  assign tab1[8'hd5] = 32'h05030306;
  assign tab1[8'hd6] = 32'h01f6f6f7;
  assign tab1[8'hd7] = 32'h120e0e1c;
  assign tab1[8'hd8] = 32'ha36161c2;
  assign tab1[8'hd9] = 32'h5f35356a;
  assign tab1[8'hda] = 32'hf95757ae;
  assign tab1[8'hdb] = 32'hd0b9b969;
  assign tab1[8'hdc] = 32'h91868617;
  assign tab1[8'hdd] = 32'h58c1c199;
  assign tab1[8'hde] = 32'h271d1d3a;
  assign tab1[8'hdf] = 32'hb99e9e27;
  assign tab1[8'he0] = 32'h38e1e1d9;
  assign tab1[8'he1] = 32'h13f8f8eb;
  assign tab1[8'he2] = 32'hb398982b;
  assign tab1[8'he3] = 32'h33111122;
  assign tab1[8'he4] = 32'hbb6969d2;
  assign tab1[8'he5] = 32'h70d9d9a9;
  assign tab1[8'he6] = 32'h898e8e07;
  assign tab1[8'he7] = 32'ha7949433;
  assign tab1[8'he8] = 32'hb69b9b2d;
  assign tab1[8'he9] = 32'h221e1e3c;
  assign tab1[8'hea] = 32'h92878715;
  assign tab1[8'heb] = 32'h20e9e9c9;
  assign tab1[8'hec] = 32'h49cece87;
  assign tab1[8'hed] = 32'hff5555aa;
  assign tab1[8'hee] = 32'h78282850;
  assign tab1[8'hef] = 32'h7adfdfa5;
  assign tab1[8'hf0] = 32'h8f8c8c03;
  assign tab1[8'hf1] = 32'hf8a1a159;
  assign tab1[8'hf2] = 32'h80898909;
  assign tab1[8'hf3] = 32'h170d0d1a;
  assign tab1[8'hf4] = 32'hdabfbf65;
  assign tab1[8'hf5] = 32'h31e6e6d7;
  assign tab1[8'hf6] = 32'hc6424284;
  assign tab1[8'hf7] = 32'hb86868d0;
  assign tab1[8'hf8] = 32'hc3414182;
  assign tab1[8'hf9] = 32'hb0999929;
  assign tab1[8'hfa] = 32'h772d2d5a;
  assign tab1[8'hfb] = 32'h110f0f1e;
  assign tab1[8'hfc] = 32'hcbb0b07b;
  assign tab1[8'hfd] = 32'hfc5454a8;
  assign tab1[8'hfe] = 32'hd6bbbb6d;
  assign tab1[8'hff] = 32'h3a16162c;
  endmodule
