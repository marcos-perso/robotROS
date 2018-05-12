-- $RCSfile: c_mux_bit_v9_1_xst_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:42:49 $
--------------------------------------------------------------------------------
--  Copyright(C) 2005 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2005 Xilinx, Inc.
--  All rights reserved.
--------------------------------------------------------------------------------
-----------------------------------------------------------------------
--
-- Use VHDL package bb_comps to define black box components to be
-- generated by a synthesis tool.
--
-- This file should not be copied over to the export area
-- unless it is specifically required by the synthesis tool.
--
-- Try to ensue that the file-sets processed by XCC and the synthesis
-- tool is disjoint.
--
-----------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

PACKAGE c_mux_bit_v9_1_xst_comp IS

----------------------------------------------------------
-- Insert component declaration of top level xst file here
----------------------------------------------------------
  COMPONENT c_mux_bit_v9_1_xst
  GENERIC (
    c_family        : STRING := "virtex2";  -- Specifies device family being targeted
    c_inputs        : INTEGER := 2;  -- Specifies input data bus width to mux
    c_sel_width     : INTEGER := 1;          -- Specifies select bus width
    c_pipe_stages   : INTEGER := 0;  -- Specifies number of pipeline stages in conj. with c_latency (0,1,2)
    c_latency       : INTEGER := 1;          -- Specifies latency of mux (0,1,2,3)
    c_height        : INTEGER := 0;          -- Redundant in VHDL core
    c_ainit_val     : STRING := "0";  -- Async init value, defaults to 0 in the code, init value for registers
    c_sinit_val     : STRING := "0";           -- Sync init value, redundant here
    c_sync_enable   : INTEGER := 0;  -- Priority of CE and sync controls - passed to o/p register
    c_sync_priority : INTEGER := 1;  -- Priority of sync set and clear for output register
    c_has_o         : INTEGER := 0;          -- Unregistered output
    c_has_q         : INTEGER := 1;          -- Registered output
    c_has_ce        : INTEGER := 0;          -- Optional clock enable
    c_has_aclr      : INTEGER := 0;          -- Optional async clear
    c_has_aset      : INTEGER := 0;          -- Optional async set
    c_has_ainit     : INTEGER := 0;  -- Redundant async init - for interface only
    c_has_sclr      : INTEGER := 0;          -- Optional sync clear
    c_has_sset      : INTEGER := 0;          -- Optional sync set
    c_has_sinit     : INTEGER := 0;  -- Redundant sync init - for interface only
    c_enable_rlocs  : INTEGER := 0           -- Redundant in VHDL core
    );
  PORT (
    m     : IN  STD_LOGIC_VECTOR(c_inputs-1 DOWNTO 0)    := (OTHERS => '0');  -- Input vector
    s     : IN  STD_LOGIC_VECTOR(c_sel_width-1 DOWNTO 0) := (OTHERS => '0');  -- Select pin
    clk   : IN  STD_LOGIC                                := '0';  -- Optional clock
    ce    : IN  STD_LOGIC                                := '1';  -- optional clock enable
    aset  : IN  STD_LOGIC                                := '0';  -- Optional asynch set '1'
    aclr  : IN  STD_LOGIC                                := '0';  -- Optional asynch clear to '0'
    ainit : IN  STD_LOGIC                                := '0';  -- Redundant in this version
    sset  : IN  STD_LOGIC                                := '0';  -- Optional synch set to '1'
    sclr  : IN  STD_LOGIC                                := '0';  -- Optional synch clear to '0'
    sinit : IN  STD_LOGIC                                := '0';  -- Redundant in this version
    o     : OUT STD_LOGIC;              -- Output value
    q     : OUT STD_LOGIC               -- Registered output value
    );
  END COMPONENT;


END c_mux_bit_v9_1_xst_comp;

