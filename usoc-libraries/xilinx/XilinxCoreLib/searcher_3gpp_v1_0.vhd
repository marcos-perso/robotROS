-- $RCSfile: searcher_3gpp_v1_0.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:22 $
--
--  Copyright(C) 2007 by Xilinx, Inc. All rights reserved.
--  This text/file contains proprietary, confidential
--  information of Xilinx, Inc., is distributed under license
--  from Xilinx, Inc., and may be used, copied and/or
--  disclosed only pursuant to the terms of a valid license
--  agreement with Xilinx, Inc.  Xilinx hereby grants you
--  a license to use this text/file solely for design, simulation,
--  implementation and creation of design files limited
--  to Xilinx devices or technologies. Use with non-Xilinx
--  devices or technologies is expressly prohibited and
--  immediately terminates your license unless covered by
--  a separate agreement.
--
--  Xilinx is providing this design, code, or information
--  "as is" solely for use in developing programs and
--  solutions for Xilinx devices.  By providing this design,
--  code, or information as one possible implementation of
--  this feature, application or standard, Xilinx is making no
--  representation that this implementation is free from any
--  claims of infringement.  You are responsible for
--  obtaining any rights you may require for your implementation.
--  Xilinx expressly disclaims any warranty whatsoever with
--  respect to the adequacy of the implementation, including
--  but not limited to any warranties or representations that this
--  implementation is free from claims of infringement, implied
--  warranties of merchantability or fitness for a particular
--  purpose.
--
--  Xilinx products are not intended for use in life support
--  appliances, devices, or systems. Use in such applications are
--  expressly prohibited.
--
--  This copyright and support notice must be retained as part
--  of this text at all times. (c) Copyright 1995-2007 Xilinx, Inc.
--  All rights reserved.
--
-------------------------------------------------------------------------------
-- Behavioural Model
-------------------------------------------------------------------------------
  
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.prims_constants_v9_0.ALL;
USE XilinxCoreLib.prims_utils_v9_0.ALL;

-- (A)synchronous multi-input gate
--
--core_if on entity 
  entity  searcher_3gpp_v1_0 is
    GENERIC (
      c_family        : string  := "virtex4";
      c_xdevicefamily : string  := "virtex4";
      c_has_ce        : integer := 0;
      c_clk_rate      : integer := 64;
      c_searches      : integer := 4;
      c_results       : integer := 8;
      c_window        : integer := 16;
      c_antenna       : integer := 2;
      c_oversample    : integer := 2;
      c_quantize      : integer := 7;
      c_search_length : integer := 2560
      );
    PORT (
      clk           : in  std_logic;
      reset         : in  std_logic;
      ce            : in  std_logic;
      sc_mcmd       : in  std_logic_vector(2 downto 0);
      sc_maddr      : in  std_logic_vector(3 downto 0);
      sc_mdata      : in  std_logic_vector(31 downto 0);
      sc_scmdaccept : out std_logic;
      sc_sinterrupt : out std_logic_vector(1 downto 0);
      a_mcmd        : in  std_logic_vector(2  downto 0);
      a_mdata       : in  std_logic_vector(15 downto 0);
      a_mdatainfo   : in  std_logic_vector(0  downto 0);
      a_scmdaccept  : out std_logic;
      a_sinterrupt  : out std_logic_vector(0 downto 0);
      sr_mcmd       : in  std_logic_vector(2 downto 0);
      sr_maddr      : in  std_logic_vector(22 Downto 0);
      sr_sdata      : out std_logic_vector(17 downto 0);
      sr_sdatainfo  : out std_logic_vector(0 downto 0);
      sr_scmdaccept : out std_logic;
      sr_sresp      : out std_logic_vector(1 downto 0);
      sr_sinterrupt : out std_logic_vector(0 downto 0)
      );
--core_if off
END searcher_3gpp_v1_0;


ARCHITECTURE behavioral OF searcher_3gpp_v1_0 IS

BEGIN
  
END behavioral;

