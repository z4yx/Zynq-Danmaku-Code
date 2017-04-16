-- Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2016.4 (lin64) Build 1733598 Wed Dec 14 22:35:42 MST 2016
-- Date        : Sun Apr 16 10:41:24 2017
-- Host        : skyworks running 64-bit Ubuntu 16.04.2 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/skyworks/ZynqDanmaku/ZynqDanmaku-HDL/ZynqDanmaku.srcs/sources_1/bd/top_blk/ip/top_blk_pixel_transparent_0_4/top_blk_pixel_transparent_0_4_sim_netlist.vhdl
-- Design      : top_blk_pixel_transparent_0_4
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity top_blk_pixel_transparent_0_4_pixel_transparent_v1_0 is
  port (
    m00_axi_wstrb : out STD_LOGIC_VECTOR ( 7 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 39 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of top_blk_pixel_transparent_0_4_pixel_transparent_v1_0 : entity is "pixel_transparent_v1_0";
end top_blk_pixel_transparent_0_4_pixel_transparent_v1_0;

architecture STRUCTURE of top_blk_pixel_transparent_0_4_pixel_transparent_v1_0 is
begin
\m00_axi_wstrb[0]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAA2AAA"
    )
        port map (
      I0 => s00_axi_wstrb(0),
      I1 => s00_axi_wdata(0),
      I2 => s00_axi_wdata(3),
      I3 => s00_axi_wdata(2),
      I4 => s00_axi_wdata(4),
      I5 => s00_axi_wdata(1),
      O => m00_axi_wstrb(0)
    );
\m00_axi_wstrb[1]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAA2AAA"
    )
        port map (
      I0 => s00_axi_wstrb(1),
      I1 => s00_axi_wdata(5),
      I2 => s00_axi_wdata(8),
      I3 => s00_axi_wdata(7),
      I4 => s00_axi_wdata(9),
      I5 => s00_axi_wdata(6),
      O => m00_axi_wstrb(1)
    );
\m00_axi_wstrb[2]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAA2AAA"
    )
        port map (
      I0 => s00_axi_wstrb(2),
      I1 => s00_axi_wdata(10),
      I2 => s00_axi_wdata(13),
      I3 => s00_axi_wdata(12),
      I4 => s00_axi_wdata(14),
      I5 => s00_axi_wdata(11),
      O => m00_axi_wstrb(2)
    );
\m00_axi_wstrb[3]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAA2AAA"
    )
        port map (
      I0 => s00_axi_wstrb(3),
      I1 => s00_axi_wdata(15),
      I2 => s00_axi_wdata(18),
      I3 => s00_axi_wdata(17),
      I4 => s00_axi_wdata(19),
      I5 => s00_axi_wdata(16),
      O => m00_axi_wstrb(3)
    );
\m00_axi_wstrb[4]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAA2AAA"
    )
        port map (
      I0 => s00_axi_wstrb(4),
      I1 => s00_axi_wdata(20),
      I2 => s00_axi_wdata(23),
      I3 => s00_axi_wdata(22),
      I4 => s00_axi_wdata(24),
      I5 => s00_axi_wdata(21),
      O => m00_axi_wstrb(4)
    );
\m00_axi_wstrb[5]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAA2AAA"
    )
        port map (
      I0 => s00_axi_wstrb(5),
      I1 => s00_axi_wdata(25),
      I2 => s00_axi_wdata(28),
      I3 => s00_axi_wdata(27),
      I4 => s00_axi_wdata(29),
      I5 => s00_axi_wdata(26),
      O => m00_axi_wstrb(5)
    );
\m00_axi_wstrb[6]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAA2AAA"
    )
        port map (
      I0 => s00_axi_wstrb(6),
      I1 => s00_axi_wdata(30),
      I2 => s00_axi_wdata(33),
      I3 => s00_axi_wdata(32),
      I4 => s00_axi_wdata(34),
      I5 => s00_axi_wdata(31),
      O => m00_axi_wstrb(6)
    );
\m00_axi_wstrb[7]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAAAAA2AAA"
    )
        port map (
      I0 => s00_axi_wstrb(7),
      I1 => s00_axi_wdata(35),
      I2 => s00_axi_wdata(38),
      I3 => s00_axi_wdata(37),
      I4 => s00_axi_wdata(39),
      I5 => s00_axi_wdata(36),
      O => m00_axi_wstrb(7)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity top_blk_pixel_transparent_0_4 is
  port (
    m00_axi_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m00_axi_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m00_axi_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m00_axi_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m00_axi_awlock : out STD_LOGIC;
    m00_axi_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m00_axi_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m00_axi_awvalid : out STD_LOGIC;
    m00_axi_awready : in STD_LOGIC;
    m00_axi_wdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    m00_axi_wstrb : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m00_axi_wlast : out STD_LOGIC;
    m00_axi_wvalid : out STD_LOGIC;
    m00_axi_wready : in STD_LOGIC;
    m00_axi_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m00_axi_bvalid : in STD_LOGIC;
    m00_axi_bready : out STD_LOGIC;
    m00_axi_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    m00_axi_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m00_axi_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m00_axi_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    m00_axi_arlock : out STD_LOGIC;
    m00_axi_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    m00_axi_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    m00_axi_arvalid : out STD_LOGIC;
    m00_axi_arready : in STD_LOGIC;
    m00_axi_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    m00_axi_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    m00_axi_rlast : in STD_LOGIC;
    m00_axi_rvalid : in STD_LOGIC;
    m00_axi_rready : out STD_LOGIC;
    m00_axi_aclk : in STD_LOGIC;
    m00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s00_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_awlock : in STD_LOGIC;
    s00_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s00_axi_wlast : in STD_LOGIC;
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s00_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_arlock : in STD_LOGIC;
    s00_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rlast : out STD_LOGIC;
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of top_blk_pixel_transparent_0_4 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of top_blk_pixel_transparent_0_4 : entity is "top_blk_pixel_transparent_0_4,pixel_transparent_v1_0,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of top_blk_pixel_transparent_0_4 : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of top_blk_pixel_transparent_0_4 : entity is "pixel_transparent_v1_0,Vivado 2016.4";
end top_blk_pixel_transparent_0_4;

architecture STRUCTURE of top_blk_pixel_transparent_0_4 is
  signal \^m00_axi_arready\ : STD_LOGIC;
  signal \^m00_axi_awready\ : STD_LOGIC;
  signal \^m00_axi_bresp\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^m00_axi_bvalid\ : STD_LOGIC;
  signal \^m00_axi_rdata\ : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal \^m00_axi_rlast\ : STD_LOGIC;
  signal \^m00_axi_rresp\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^m00_axi_rvalid\ : STD_LOGIC;
  signal \^m00_axi_wready\ : STD_LOGIC;
  signal \^s00_axi_araddr\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^s00_axi_arburst\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^s00_axi_arcache\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^s00_axi_arlen\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^s00_axi_arlock\ : STD_LOGIC;
  signal \^s00_axi_arprot\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \^s00_axi_arsize\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \^s00_axi_arvalid\ : STD_LOGIC;
  signal \^s00_axi_awaddr\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^s00_axi_awburst\ : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^s00_axi_awcache\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^s00_axi_awlen\ : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^s00_axi_awlock\ : STD_LOGIC;
  signal \^s00_axi_awprot\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \^s00_axi_awsize\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \^s00_axi_awvalid\ : STD_LOGIC;
  signal \^s00_axi_bready\ : STD_LOGIC;
  signal \^s00_axi_rready\ : STD_LOGIC;
  signal \^s00_axi_wdata\ : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal \^s00_axi_wlast\ : STD_LOGIC;
  signal \^s00_axi_wvalid\ : STD_LOGIC;
begin
  \^m00_axi_arready\ <= m00_axi_arready;
  \^m00_axi_awready\ <= m00_axi_awready;
  \^m00_axi_bresp\(1 downto 0) <= m00_axi_bresp(1 downto 0);
  \^m00_axi_bvalid\ <= m00_axi_bvalid;
  \^m00_axi_rdata\(63 downto 0) <= m00_axi_rdata(63 downto 0);
  \^m00_axi_rlast\ <= m00_axi_rlast;
  \^m00_axi_rresp\(1 downto 0) <= m00_axi_rresp(1 downto 0);
  \^m00_axi_rvalid\ <= m00_axi_rvalid;
  \^m00_axi_wready\ <= m00_axi_wready;
  \^s00_axi_araddr\(31 downto 0) <= s00_axi_araddr(31 downto 0);
  \^s00_axi_arburst\(1 downto 0) <= s00_axi_arburst(1 downto 0);
  \^s00_axi_arcache\(3 downto 0) <= s00_axi_arcache(3 downto 0);
  \^s00_axi_arlen\(7 downto 0) <= s00_axi_arlen(7 downto 0);
  \^s00_axi_arlock\ <= s00_axi_arlock;
  \^s00_axi_arprot\(2 downto 0) <= s00_axi_arprot(2 downto 0);
  \^s00_axi_arsize\(2 downto 0) <= s00_axi_arsize(2 downto 0);
  \^s00_axi_arvalid\ <= s00_axi_arvalid;
  \^s00_axi_awaddr\(31 downto 0) <= s00_axi_awaddr(31 downto 0);
  \^s00_axi_awburst\(1 downto 0) <= s00_axi_awburst(1 downto 0);
  \^s00_axi_awcache\(3 downto 0) <= s00_axi_awcache(3 downto 0);
  \^s00_axi_awlen\(7 downto 0) <= s00_axi_awlen(7 downto 0);
  \^s00_axi_awlock\ <= s00_axi_awlock;
  \^s00_axi_awprot\(2 downto 0) <= s00_axi_awprot(2 downto 0);
  \^s00_axi_awsize\(2 downto 0) <= s00_axi_awsize(2 downto 0);
  \^s00_axi_awvalid\ <= s00_axi_awvalid;
  \^s00_axi_bready\ <= s00_axi_bready;
  \^s00_axi_rready\ <= s00_axi_rready;
  \^s00_axi_wdata\(63 downto 0) <= s00_axi_wdata(63 downto 0);
  \^s00_axi_wlast\ <= s00_axi_wlast;
  \^s00_axi_wvalid\ <= s00_axi_wvalid;
  m00_axi_araddr(31 downto 0) <= \^s00_axi_araddr\(31 downto 0);
  m00_axi_arburst(1 downto 0) <= \^s00_axi_arburst\(1 downto 0);
  m00_axi_arcache(3 downto 0) <= \^s00_axi_arcache\(3 downto 0);
  m00_axi_arlen(7 downto 0) <= \^s00_axi_arlen\(7 downto 0);
  m00_axi_arlock <= \^s00_axi_arlock\;
  m00_axi_arprot(2 downto 0) <= \^s00_axi_arprot\(2 downto 0);
  m00_axi_arsize(2 downto 0) <= \^s00_axi_arsize\(2 downto 0);
  m00_axi_arvalid <= \^s00_axi_arvalid\;
  m00_axi_awaddr(31 downto 0) <= \^s00_axi_awaddr\(31 downto 0);
  m00_axi_awburst(1 downto 0) <= \^s00_axi_awburst\(1 downto 0);
  m00_axi_awcache(3 downto 0) <= \^s00_axi_awcache\(3 downto 0);
  m00_axi_awlen(7 downto 0) <= \^s00_axi_awlen\(7 downto 0);
  m00_axi_awlock <= \^s00_axi_awlock\;
  m00_axi_awprot(2 downto 0) <= \^s00_axi_awprot\(2 downto 0);
  m00_axi_awsize(2 downto 0) <= \^s00_axi_awsize\(2 downto 0);
  m00_axi_awvalid <= \^s00_axi_awvalid\;
  m00_axi_bready <= \^s00_axi_bready\;
  m00_axi_rready <= \^s00_axi_rready\;
  m00_axi_wdata(63 downto 0) <= \^s00_axi_wdata\(63 downto 0);
  m00_axi_wlast <= \^s00_axi_wlast\;
  m00_axi_wvalid <= \^s00_axi_wvalid\;
  s00_axi_arready <= \^m00_axi_arready\;
  s00_axi_awready <= \^m00_axi_awready\;
  s00_axi_bresp(1 downto 0) <= \^m00_axi_bresp\(1 downto 0);
  s00_axi_bvalid <= \^m00_axi_bvalid\;
  s00_axi_rdata(63 downto 0) <= \^m00_axi_rdata\(63 downto 0);
  s00_axi_rlast <= \^m00_axi_rlast\;
  s00_axi_rresp(1 downto 0) <= \^m00_axi_rresp\(1 downto 0);
  s00_axi_rvalid <= \^m00_axi_rvalid\;
  s00_axi_wready <= \^m00_axi_wready\;
inst: entity work.top_blk_pixel_transparent_0_4_pixel_transparent_v1_0
     port map (
      m00_axi_wstrb(7 downto 0) => m00_axi_wstrb(7 downto 0),
      s00_axi_wdata(39 downto 35) => \^s00_axi_wdata\(60 downto 56),
      s00_axi_wdata(34 downto 30) => \^s00_axi_wdata\(52 downto 48),
      s00_axi_wdata(29 downto 25) => \^s00_axi_wdata\(44 downto 40),
      s00_axi_wdata(24 downto 20) => \^s00_axi_wdata\(36 downto 32),
      s00_axi_wdata(19 downto 15) => \^s00_axi_wdata\(28 downto 24),
      s00_axi_wdata(14 downto 10) => \^s00_axi_wdata\(20 downto 16),
      s00_axi_wdata(9 downto 5) => \^s00_axi_wdata\(12 downto 8),
      s00_axi_wdata(4 downto 0) => \^s00_axi_wdata\(4 downto 0),
      s00_axi_wstrb(7 downto 0) => s00_axi_wstrb(7 downto 0)
    );
end STRUCTURE;
