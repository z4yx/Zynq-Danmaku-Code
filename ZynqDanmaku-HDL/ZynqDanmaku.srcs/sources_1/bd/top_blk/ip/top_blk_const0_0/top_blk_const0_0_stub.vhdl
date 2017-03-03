-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
-- Date        : Wed Mar  1 11:41:23 2017
-- Host        : skyworks running 64-bit Ubuntu 16.04.1 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/skyworks/ZynqDanmaku/ZynqDanmaku-HDL/ZynqDanmaku.srcs/sources_1/bd/top_blk/ip/top_blk_const0_0/top_blk_const0_0_stub.vhdl
-- Design      : top_blk_const0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_blk_const0_0 is
  Port ( 
    dout : out STD_LOGIC_VECTOR ( 0 to 0 )
  );

end top_blk_const0_0;

architecture stub of top_blk_const0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "dout[0:0]";
begin
end;
