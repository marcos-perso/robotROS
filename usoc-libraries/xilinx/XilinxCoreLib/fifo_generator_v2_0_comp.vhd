-------------------------------------------------------------------------------
-- $RCSfile: fifo_generator_v2_0_comp.vhd,v $ $Revision: 1.1 $ $Date: 2010-07-10 21:43:08 $
-------------------------------------------------------------------------------
--
-- Fifo Generator - VHDL Behavioral Model Component Declaration
--
-------------------------------------------------------------------------------
--
-- Copyright(C) 2004 by Xilinx, Inc. All rights reserved.
-- This text/file contains proprietary, confidential
-- information of Xilinx, Inc., is distributed under
-- license from Xilinx, Inc., and may be used, copied
-- and/or disclosed only pursuant to the terms of a valid
-- license agreement with Xilinx, Inc. Xilinx hereby
-- grants you a license to use this text/file solely for
-- design, simulation, implementation and creation of
-- design files limited to Xilinx devices or technologies.
-- Use with non-Xilinx devices or technologies is expressly
-- prohibited and immediately terminates your license unless
-- covered by a separate agreement.
--
-- Xilinx is providing theis design, code, or information
-- "as-is" solely for use in developing programs and 
-- solutions for Xilinx devices, with no obligation on the 
-- part of Xilinx to provide support. By providing this design, 
-- code, or information as one possible implementation of
-- this feature, application or standard. Xilinx is making no
-- representation that this implementation is free from any
-- claims of infringement. You are responsible for obtaining
-- any rights you may require for your implementation.
-- Xilinx expressly disclaims any warranty whatsoever with
-- respect to the adequacy of the implementation, including
-- but not limited to any warranties or representations that this 
-- implementation is free from claims of infringement, implied
-- warranties of merchantability or fitness for a particular
-- purpose.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is 
-- expressly prohibited.
--
-- Any modifications that are made to the Source Code are
-- done at the user's sole risk and will be unsupported.
-- The Xilinx Support Hotline does not have access to source
-- code and therefore cannot answer specific questions related
-- to source HDL. The Xilinx Hotline support of original source
-- code IP shall only address issues and questions related
-- to source HDL. The Xilinx Hotline support of original source
-- code IP shall only address issues and questions related
-- to standard Netlist version of the core (and thus 
-- indirectly, the original core source).
--
-- This copyright and support notice must be retained as part 
-- of this text at all times. (c)Copyright 1995-2004 Xilinx, Inc.
-- All rights reserved.
--
-------------------------------------------------------------------------------
--
-- Filename: fifo__generator_v2_0_comp.vhd
--
-- Description: 
--  The behavioral model for the FIFO Generator core.
--                      
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE fifo_generator_v2_0_comp IS

 COMPONENT fifo_generator_v2_0 
  GENERIC (
    --------------------------------------------------------------------------------
    -- Generic Declarations (alphabetical)
    --------------------------------------------------------------------------------
    C_COMMON_CLOCK                : integer := 0;
    C_COUNT_TYPE                  : integer := 0;
    C_DATA_COUNT_WIDTH            : integer := 2;
    C_DEFAULT_VALUE               : string  := "";
    C_DIN_WIDTH                   : integer := 8;
    C_DOUT_RST_VAL                : string  := "";
    C_DOUT_WIDTH                  : integer := 8;
    C_ENABLE_RLOCS                : integer := 0;
    C_FAMILY                      : string  := "";
    C_HAS_ALMOST_EMPTY            : integer := 0;
    C_HAS_ALMOST_FULL             : integer := 0;
    C_HAS_BACKUP                  : integer := 0;
    C_HAS_DATA_COUNT              : integer := 0;
    C_HAS_MEMINIT_FILE            : integer := 0;
    C_HAS_OVERFLOW                : integer := 0;
    C_HAS_RD_DATA_COUNT           : integer := 0;
    C_HAS_RD_RST                  : integer := 0;
    C_HAS_RST                     : integer := 1;
    C_HAS_UNDERFLOW               : integer := 0;
    C_HAS_VALID                   : integer := 0;
    C_HAS_WR_ACK                  : integer := 0;
    C_HAS_WR_DATA_COUNT           : integer := 0;
    C_HAS_WR_RST                  : integer := 0;
    C_IMPLEMENTATION_TYPE         : integer := 0;
    C_INIT_WR_PNTR_VAL            : integer := 0;
    C_MEMORY_TYPE                 : integer := 1;
    C_MIF_FILE_NAME               : string  := "";
    C_OPTIMIZATION_MODE           : integer := 0;
    C_OVERFLOW_LOW                : integer := 0;
    C_PRELOAD_REGS                : integer := 0;
    C_PRELOAD_LATENCY             : integer := 1;
     C_PRIM_FIFO_TYPE             : integer := 512;
    C_PROG_EMPTY_THRESH_ASSERT_VAL: integer := 0;
    C_PROG_EMPTY_THRESH_NEGATE_VAL: integer := 0;
    C_PROG_EMPTY_TYPE             : integer := 0;
    C_PROG_FULL_THRESH_ASSERT_VAL : integer := 0;
    C_PROG_FULL_THRESH_NEGATE_VAL : integer := 0;
    C_PROG_FULL_TYPE              : integer := 0;
    C_RD_DATA_COUNT_WIDTH         : integer := 2;
    C_RD_DEPTH                    : integer := 256;
    C_RD_PNTR_WIDTH               : integer := 8;
    C_UNDERFLOW_LOW               : integer := 0;
    C_VALID_LOW                   : integer := 0;
    C_WR_ACK_LOW                  : integer := 0;
    C_WR_DATA_COUNT_WIDTH         : integer := 2;
    C_WR_DEPTH                    : integer := 256;
    C_WR_PNTR_WIDTH               : integer := 8;
    C_WR_RESPONSE_LATENCY         : integer := 1
    );


  PORT(
--------------------------------------------------------------------------------
-- Input and Output Declarations
--------------------------------------------------------------------------------
    CLK                       : IN  std_logic := '0';
    BACKUP                    : IN  std_logic := '0';
    BACKUP_MARKER             : IN  std_logic := '0';
    DIN                       : IN  std_logic_vector(C_DIN_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH         : IN  std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_ASSERT  : IN  std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_EMPTY_THRESH_NEGATE  : IN  std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH          : IN  std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_ASSERT   : IN  std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    PROG_FULL_THRESH_NEGATE   : IN  std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0) := (OTHERS => '0');
    RD_CLK                    : IN  std_logic := '0';
    RD_EN                     : IN  std_logic := '0';
    RD_RST                    : IN  std_logic := '0';
    RST                       : IN  std_logic := '0';
    WR_CLK                    : IN  std_logic := '0';
    WR_EN                     : IN  std_logic := '0';
    WR_RST                    : IN  std_logic := '0';

    ALMOST_EMPTY              : OUT std_logic;
    ALMOST_FULL               : OUT std_logic;
    DATA_COUNT                : OUT std_logic_vector(C_DATA_COUNT_WIDTH-1 DOWNTO 0);
    DOUT                      : OUT std_logic_vector(C_DOUT_WIDTH-1 DOWNTO 0);
    EMPTY                     : OUT std_logic;
    FULL                      : OUT std_logic;
    OVERFLOW                  : OUT std_logic;
    PROG_EMPTY                : OUT std_logic;
    PROG_FULL                 : OUT std_logic;
    VALID                     : OUT std_logic;
    RD_DATA_COUNT             : OUT std_logic_vector(C_RD_DATA_COUNT_WIDTH-1 DOWNTO 0);
    UNDERFLOW                 : OUT std_logic;
    WR_ACK                    : OUT std_logic;
    WR_DATA_COUNT             : OUT std_logic_vector(C_WR_DATA_COUNT_WIDTH-1 DOWNTO 0)
--     ; --SIM

--     DEBUG_WR_PNTR         : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --SIM
--     DEBUG_RD_PNTR         : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); --SIM
--     DEBUG_RAM_WR_EN       : OUT std_logic; --SIM
--     DEBUG_RAM_RD_EN       : OUT std_logic; --SIM
--     debug_wr_pntr_w       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --SIM
--     debug_wr_pntr_plus1_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --SIM
--     debug_wr_pntr_plus2_w : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --SIM
--     debug_wr_pntr_r       : OUT std_logic_vector(C_WR_PNTR_WIDTH-1 DOWNTO 0); --SIM
--     debug_rd_pntr_r       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); --SIM
--     debug_rd_pntr_plus1_r : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); --SIM
--     debug_rd_pntr_w       : OUT std_logic_vector(C_RD_PNTR_WIDTH-1 DOWNTO 0); --SIM
--     DEBUG_RAM_EMPTY       : OUT std_logic; --SIM
--     DEBUG_RAM_FULL        : OUT std_logic --SIM
    );
 END COMPONENT;

END fifo_generator_v2_0_comp;
