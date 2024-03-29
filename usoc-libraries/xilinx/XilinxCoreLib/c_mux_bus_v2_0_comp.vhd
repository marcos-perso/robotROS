-- $Id: c_mux_bus_v2_0_comp.vhd,v 1.1 2010-07-10 21:42:49 mmartinez Exp $
--
-- Filename - c_mux_bus_v2_0_comp.vhd
-- Author - Xilinx
-- Creation - 3 Mar 1999
--
-- Description - This file contains the component declaration for
--				 the C_MUX_BUS_V2_0 core

Library IEEE;
Use IEEE.std_logic_1164.all;

Library XilinxCoreLib;
Use XilinxCoreLib.prims_constants_v2_0.all;

package c_mux_bus_v2_0_comp is

----- Component C_MUX_BUS_V2_0 -----
-- Short Description
--
-- (A)Synchronous N*M-to-M Mux
--
component C_MUX_BUS_V2_0
	generic(
			 C_WIDTH 		: integer := 16;
			 C_INPUTS 		: integer := 2;
			 C_MUX_TYPE		: integer := c_lut_based;
			 C_SEL_WIDTH 	: integer := 1;
			 C_AINIT_VAL 	: string  := "";
			 C_SINIT_VAL 	: string  := "";
			 C_SYNC_PRIORITY: integer := c_clear;
			 C_SYNC_ENABLE 	: integer := c_override;
			 C_HAS_O 		: integer := 0;
			 C_HAS_Q 		: integer := 1;
			 C_HAS_CE 		: integer := 1;
			 C_HAS_EN 		: integer := 1;
			 C_HAS_ACLR 	: integer := 0;
			 C_HAS_ASET 	: integer := 0;
			 C_HAS_AINIT 	: integer := 0;
			 C_HAS_SCLR 	: integer := 0;
			 C_HAS_SSET 	: integer := 0;
			 C_HAS_SINIT 	: integer := 0;
			 C_ENABLE_RLOCS : integer := 1
			 ); 
			 
    port (MA 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MB 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MC 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MD 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  ME 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MF 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MG 	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  MH	: in std_logic_vector(C_WIDTH-1 downto 0) := (others => '0'); -- Input vector
		  S 	: in std_logic_vector(C_SEL_WIDTH-1 downto 0) := (others => '0'); -- Select pin
		  CLK 	: in std_logic := '0'; -- Optional clock
		  CE 	: in std_logic := '1';  -- Optional Clock enable
		  EN 	: in std_logic := '0';  -- Optional BUFT enable
		  ASET 	: in std_logic := '0'; -- optional asynch set to '1'
		  ACLR 	: in std_logic := '0'; -- Asynch init.
		  AINIT : in std_logic := '0'; -- optional asynch reset to init_val
		  SSET 	: in std_logic := '0'; -- optional synch set to '1'
		  SCLR 	: in std_logic := '0'; -- Synch init.
		  SINIT : in std_logic := '0'; -- Optional synch reset to init_val
		  O 	: out std_logic_vector(C_WIDTH-1 downto 0); -- Output value
		  Q 	: out std_logic_vector(C_WIDTH-1 downto 0) -- Registered output value
		  );
end component;


end c_mux_bus_v2_0_comp;
