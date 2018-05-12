-- $RCSfile: dds_compiler_v1_1.vhd,v $
--
--  Copyright(C) 2006 by Xilinx, Inc. All rights reserved.
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
--  of this text at all times. (c) Copyright 1995-2006 Xilinx, Inc.
--  All rights reserved.
--
-------------------------------------------------------------------------------
-- Behavioural Model
-------------------------------------------------------------------------------
  
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.prims_constants_v9_1.ALL;
USE XilinxCoreLib.prims_utils_v9_1.ALL;
USE XilinxCoreLib.xcc_utils_v9_1.ALL;
use xilinxcorelib.iputils_conv.all;
use xilinxcorelib.pkg_dds_compiler_v1_1.all;
use xilinxcorelib.dds_compiler_v1_1_sim_comps.all;

-- (A)synchronous multi-input gate
--
--core_if on entity 
  entity dds_compiler_v1_1 is
    GENERIC (
      C_FAMILY : string :=  "virtex4";
      C_XDEVICEFAMILY : string :=  "virtex4";
      C_ACCUMULATOR_LATENCY : integer :=  1;
      C_ACCUMULATOR_WIDTH : integer :=  16;
      C_CHANNELS : integer :=  1;
      C_DATA_WIDTH : integer :=  16;
      C_ENABLE_RLOCS : integer :=  0;
      C_HAS_CE : integer :=  0;
      C_HAS_CHANNEL_INDEX : integer :=  0;
      C_HAS_RDY : integer :=  1;
      C_HAS_RFD : integer :=  0;
      C_HAS_SCLR : integer :=  0;
      C_LATENCY : integer :=  2;
      C_MEM_TYPE : integer :=  0;
      C_NEGATIVE_COSINE : integer :=  0;
      C_NEGATIVE_SINE : integer :=  0;
      C_NOISE_SHAPING : integer :=  0;
      C_OUTPUTS_REQUIRED : integer :=  2;
      C_OUTPUT_WIDTH : integer :=  16;
      C_PHASE_ANGLE_WIDTH : integer :=  12;
      C_PHASE_INCREMENT : integer :=  1;
      C_PHASE_INCREMENT_VALUE : string :=  "0";
      C_PHASE_OFFSET : integer :=  2;
      C_PHASE_OFFSET_VALUE : string :=  "0";
      C_PIPELINED : integer :=  0;
      C_OPTIMISE_GOAL : integer :=  0;
      C_USE_DSP48 : integer :=  0
      );
    PORT (
      a : in std_logic_vector(4 downto 0) := (others => '0');
      ce : in std_logic := '0';
      clk : in std_logic := '0';
      sclr : in std_logic := '0';
      we : in std_logic := '0';
      data : in std_logic_vector (C_DATA_WIDTH-1 downto 0) := (others => '0');
      rdy : out std_logic;
      rfd : out std_logic;
      channel : out std_logic_vector(sel_lines_reqd(C_CHANNELS)-1 downto 0);
      cosine : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
      sine : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0)
      );
--core_if off
END dds_compiler_v1_1;


ARCHITECTURE behavioral OF dds_compiler_v1_1 IS
  constant ci_check_generics : integer := check_generics(
    P_FAMILY                => C_FAMILY,
    P_ACCUMULATOR_LATENCY   => C_ACCUMULATOR_LATENCY,
    P_ACCUMULATOR_WIDTH     => C_ACCUMULATOR_WIDTH,
    P_CHANNELS              => C_CHANNELS,
    P_DATA_WIDTH            => C_DATA_WIDTH,
    P_ENABLE_RLOCS          => C_ENABLE_RLOCS,
    P_HAS_CE                => C_HAS_CE,
    P_HAS_CHANNEL_INDEX     => C_HAS_CHANNEL_INDEX,
    P_HAS_RDY               => C_HAS_RDY,
    P_HAS_RFD               => C_HAS_RFD,
    P_HAS_SCLR              => C_HAS_SCLR,
    P_LATENCY               => C_LATENCY,
    P_MEM_TYPE              => C_MEM_TYPE,
    P_NEGATIVE_COSINE       => C_NEGATIVE_COSINE,
    P_NEGATIVE_SINE         => C_NEGATIVE_SINE,
    P_NOISE_SHAPING         => C_NOISE_SHAPING,
    P_OUTPUTS_REQUIRED      => C_OUTPUTS_REQUIRED,
    P_OUTPUT_WIDTH          => C_OUTPUT_WIDTH,
    P_PHASE_ANGLE_WIDTH     => C_PHASE_ANGLE_WIDTH,
    P_PHASE_INCREMENT       => C_PHASE_INCREMENT,
    P_PHASE_INCREMENT_VALUE => C_PHASE_INCREMENT_VALUE,
    P_PHASE_OFFSET          => C_PHASE_OFFSET,
    P_PHASE_OFFSET_VALUE    => C_PHASE_OFFSET_VALUE,
    P_PIPELINED             => C_PIPELINED
    );

  -- purpose: resolve dsp48 according to generic and family
  function fn_use_dsp48 (
    p_use_dsp48 : integer;
    p_family    : string)
    return integer is
  begin  -- fn_use_dsp48
    if has_DSP48(p_family) or has_DSP48e(p_family) then
      return p_use_dsp48;
    end if;
    return 0;
  end fn_use_dsp48;
  constant ci_use_dsp48 : integer := fn_use_dsp48(C_USE_DSP48, C_FAMILY);
  
  ---------------------------------------------------------------------------
  -- Create the values of the sin/cos lookup table
  ---------------------------------------------------------------------------
  --  constant ci_rom_file : string := C_ELABORATION_DIR&"rom_lut.mif";
  function fn_sin_cos_address (
    p_acc_width : integer)
    return integer is
  begin  -- fn_sin_cos_address
    if p_acc_width < c_sin_cos_addr_limit then
      return p_acc_width;
    else
      return c_sin_cos_addr_limit;
    end if;
  end fn_sin_cos_address;
  constant ci_ram_addr_width : integer := C_PHASE_ANGLE_WIDTH;
    -- purpose: determines address width of ROM primitive
  -- purpose: determines if the rom is quarter, half or full sine wave
  type enum_range is (e_full, e_half, e_quarter);
  function fn_calc_rom_range (
    p_addr_width     : integer)
    return enum_range is
  begin  -- calc_rom_range
    case p_addr_width is
      when c_sin_cos_addr_limit =>
        return e_quarter;
      when c_sin_cos_addr_limit-1 =>
        return e_half;
      when others =>
        return e_full;
    end case;
  end fn_calc_rom_range;
  constant ci_range : enum_range := fn_calc_rom_range(ci_ram_addr_width);
  function fn_rom_data_width (
    p_data_width : integer;
    p_range : enum_range
    )
    return integer is
    variable ret : integer;
  begin  -- fn_rom_addr_width
    case p_range is
      when e_full =>
        ret := p_data_width;
      when others =>
        --ret := p_data_width-1;            --RAM is free in behv model!
        ret := p_data_width;            --RAM is free in behv model!
    end case;
    return ret;
  end fn_rom_data_width;
  constant ci_ram_data_width : integer := fn_rom_data_width(C_OUTPUT_WIDTH, ci_range);
--  constant ci_ram_data_width : integer := 18;

  subtype t_addr is integer range 0 to 15;
--  type t_ram_type is array (0 to C_CHANNELS-1) of std_logic_vector(C_DATA_WIDTH-1 downto 0);
  type t_ram_type is array (0 to 15) of std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0);  
  function fn_init_ram(
    p_val : string;
    p_channels : integer;
    p_data_width : integer
    )
    return t_ram_type is
    variable ret : t_ram_type;
    variable addr : integer;
    variable cursor : integer;
    variable len : integer;
    variable temp_str : string(1 to p_val'LENGTH);  
    variable clear_str : string(1 to p_val'LENGTH);  
    variable start : integer;
    variable v_val : string(1 to p_val'LENGTH);
  begin  -- fn_init_ram
    v_val := p_val;                     --at least now I know the string direction!
    
    --give it some safe defaults
    for i in 0 to p_channels-1 loop
      ret(i) := (others => '0');
    end loop;  -- i

--    if p_channels = 1 then
--      return ret;
--    end if;
    --parse the string
    len := v_val'LENGTH;
    assert len > 0 report "WARNING: string passed to RAM is too short" severity WARNING;

    --find the first non-space character
    start := 0;
    for i in 1 to len loop
      if v_val(i) = '0' or v_val(i) = '1' then
        start := i;
        exit;
      end if;
    end loop;  -- i

    if start = 0 then
      assert false report "WARNING: no 0/1's detected in RAM init string" severity WARNING;
      return ret;                       --all zeros at this stage
    end if;

    for w in temp_str'range loop
      clear_str(w) := '0';              --used to clear temp_str
    end loop;     

    temp_str := clear_str;
    addr := 0;
    cursor := 0;
    for j in start to len loop
      if v_val(j) = '1' or v_val(j) = '0' then
        cursor := cursor +1;            --keep track of its length
        temp_str(cursor) := v_val(j);   --construct element string
      else
        --next word
        ret(addr)(p_data_width-1 downto 0) := str_to_bound_slv_0(str_to_bound_str(temp_str(1 to cursor),p_data_width,"0"),p_data_width);
        temp_str := clear_str;
        cursor := 0;
        addr := addr+1;
        if addr >= p_channels then
          return ret;
        end if;
      end if;
    end loop;  -- j
--    if v_val(len) /= ' ' or v_val(len) /= ',' then
    ret(addr)(p_data_width-1 downto 0) := str_to_bound_slv_0(str_to_bound_str(temp_str(1 to cursor),p_data_width,"0"),p_data_width);
--      addr := addr+1;
--    end if;    
    return ret;
  end fn_init_ram;

  type t_ROM_table   is array (0 to 2**ci_ram_addr_width-1) of std_logic_vector(ci_ram_data_width-1 downto 0); 
  --Create lookup table of 1/x. i.e 1.0dddd = 1/0.1aaaa1
  --all the commented out code in this function is to do with the generation of
  --the coe file rather than mif file.
  function fn_ROM_table (
    p_addr_width : integer;
    p_data_width : integer)
    return t_ROM_table is
    constant ci_precision : integer := p_data_width + 10;
    variable ret_val      : t_ROM_table;
    variable x_rad        : real;
    variable sin_x        : real;
    variable addr         : integer;
    variable exact_result : integer;
    variable slv_result   : std_logic_vector(p_data_width-1 downto 0);
    variable super_precise_result : integer;
    variable super_slv_result   : std_logic_vector(ci_precision-1 downto 0);
  begin
    
    for i in 0 to 2**p_addr_width-1 loop
      x_rad        := (real(i)+0.5) * (MATH_PI/real(2**(p_addr_width-1)));
      sin_x        := sin(x_rad);
--      if C_NOISE_SHAPING = c_noise_shaping_taylor then
--        exact_result := integer(sin_x * real(2**(p_data_width-1)-1));  --kept for exact_result
--        super_precise_result := integer(sin_x * real(2**(ci_precision)-1));
--        super_slv_result(ci_precision-1 downto 0) := int_to_slv(super_precise_result, ci_precision);
--        slv_result(p_data_width-2 downto 0) := super_slv_result(super_slv_result'LEFT downto super_slv_result'LEFT-p_data_width+2);
--      else
        exact_result := integer(sin_x * real(2**(p_data_width-1)-2));
        slv_result(p_data_width-2 downto 0)   := int_2_std_logic_vector(exact_result, p_data_width-1);
--      end if;
      if exact_result >=0 then
        slv_result(p_data_width-1)   := '0';
      else
        slv_result(p_data_width-1)   := '1';
--        slv_result := slv_result - '1';
      end if;
--      assert false report "i = "&integer'IMAGE(i)&"  sin(i) = "&INTEGER'image(exact_result) severity note;          
      ret_val(i)   := slv_result(p_data_width-1 downto 0);  
    end loop;  -- i
    return ret_val;
  end fn_ROM_table;

  constant sin_lut : t_ROM_table := fn_ROM_table(ci_ram_addr_width, ci_ram_data_width);  -- 1k x 18 bits (10 used)
  signal diag_lut : t_ROM_table := sin_lut;

  -----------------------------------------------------------------------------
  --calculate latency distribution
  constant c_lat_alloc : t_latency_allocation_return := fn_alloc_lat_top(
    p_family            => C_FAMILY,
    p_latency           => C_LATENCY,
    p_acc_latency       => C_ACCUMULATOR_LATENCY,
    p_accumulator_width => C_ACCUMULATOR_WIDTH,
    p_noise_shaping     => C_NOISE_SHAPING,
    p_phase_angle_width => C_PHASE_ANGLE_WIDTH,
    p_phase_offset      => C_PHASE_OFFSET,
    p_optimization_goal => C_OPTIMISE_GOAL,
    p_use_dsp48         => ci_use_dsp48,
    p_channels          => C_CHANNELS
    );
  constant ci_pipe : t_pipe_top := c_lat_alloc.pipe;
  signal diag_pipe : t_pipe_top := ci_pipe;
  constant ci_latency : integer := c_lat_alloc.used;
  signal diag_latency : integer := ci_latency;
  -- example of internal constants derived from generics

  constant ci_acc_zero : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
  -- purpose: invert acc ram to mimic reset behaviour
  function fn_invert_ram (
    p_init : t_ram_type)
    return t_ram_type is
    variable ret : t_ram_type;
  begin  -- fn_invert_ram
    for i  in 0 to C_CHANNELS-1 loop
      ret(i) := ci_acc_zero-p_init(i)(C_DATA_WIDTH-1 downto 0);
    end loop;  -- i
    return ret;
  end fn_invert_ram;

  constant ci_phase_inc_inits : t_ram_type := fn_init_ram(C_PHASE_INCREMENT_VALUE,C_CHANNELS,C_DATA_WIDTH);
  constant ci_phase_adj_inits : t_ram_type := fn_init_ram(C_PHASE_OFFSET_VALUE,C_CHANNELS,C_DATA_WIDTH);
  constant ci_phase_inc_acc_inits : t_ram_type := fn_init_ram(C_PHASE_INCREMENT_VALUE,C_CHANNELS,C_ACCUMULATOR_WIDTH);
  constant ci_phase_adj_acc_inits : t_ram_type := fn_init_ram(C_PHASE_OFFSET_VALUE,C_CHANNELS,C_ACCUMULATOR_WIDTH);
  constant ci_phase_acc_inits : t_ram_type := fn_invert_ram(ci_phase_inc_inits);  -- to mimic reset, acc + inc = 0
  constant ci_phase_inc       : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := ci_phase_inc_acc_inits(0);
  constant ci_phase_adj       : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := ci_phase_adj_acc_inits(0);
  constant ci_rom_type        : t_rom_type                                       := BLOCK_ROM;
  constant ci_dither_width    : integer                                          := fn_dither_width(C_ACCUMULATOR_WIDTH,C_PHASE_ANGLE_WIDTH);
  constant ci_dither_shift    : integer                                          := C_ACCUMULATOR_WIDTH - ci_ram_addr_width - ci_dither_width +1;
  constant c_slv_dither_shift : std_logic_vector(ci_dither_shift -1 downto 0)    := (others => '0');
  constant ci_zero_lat_acc    : integer                                          := C_LATENCY;
  constant ci_chan_width : integer := sel_lines_reqd(C_CHANNELS);
  constant ci_big_one : std_logic_vector(3 downto 0) := "0001";
  constant ci_one : std_logic_vector(ci_chan_width-1 downto 0) := ci_big_one(ci_chan_width-1 downto 0);
  constant ci_op_zero : std_logic_vector(C_OUTPUT_WIDTH-1 downto 0) := (others => '0');
  
  subtype t_block_addr is INTEGER range 0 to 4095;
  
  -- signals section
  signal sclr_i  : std_logic := '0';     -- optional
  signal ce_i    : std_logic := '1';     -- optional
  signal rdy_i   : std_logic := '0';
  signal data_i  : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
  signal a_i     : std_logic_vector(3 downto 0) := (others => '0');
  signal phase_inc_we  : std_logic := '0';     --write enable for phase increment RAM
  signal phase_adj_we  : std_logic := '0';     --write enable for phase adjust RAM
  signal phase_inc_ram : t_ram_type := ci_phase_inc_inits;
  signal phase_adj_ram : t_ram_type := ci_phase_adj_inits;
  signal phase_acc_ram : t_ram_type := ci_phase_acc_inits;

  signal phase_acc_ram_op : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
  signal chan_addr        : std_logic_vector(ci_chan_width-1 downto 0) := ci_one;
  signal chan_addr_del1   : std_logic_vector(ci_chan_width-1 downto 0) := (others => '0');
  signal chan_addr_del2   : std_logic_vector(ci_chan_width-1 downto 0) := (others => '0');
  signal chan_addr_del3   : std_logic_vector(ci_chan_width-1 downto 0) := (others => '0');
  signal chan_addr_adj    : std_logic_vector(ci_chan_width-1 downto 0) := (others => '0');

  signal lfsr1    : std_logic_vector(12 downto 0) := (others => '0');
  signal lfsr2    : std_logic_vector(13 downto 0) := (others => '0');
  signal lfsr3    : std_logic_vector(14 downto 0) := (others => '0');
  signal lfsr4    : std_logic_vector(15 downto 0) := (others => '0');
  signal combine1 : std_logic_vector(ci_dither_width downto 0) := (others => '0');
  signal combine2 : std_logic_vector(ci_dither_width downto 0) := (others => '0');
  signal combine3 : std_logic_vector(ci_dither_width+1 downto 0) := (others => '0');

  signal pre_phase_inc      : std_logic_vector(C_DATA_WIDTH-1 downto 0) := (others => '0');
  signal pre_phase_inc_stretch : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
  signal phase_inc          : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := ci_phase_inc;
  signal acc_phase          : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
  signal acc_phasea         : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
  signal acc_phaseb         : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
  signal acc_phasec         : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
  signal acc_phase_adjusted : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
  signal acc_phase_shaped   : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
  signal diag_shaped        : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');
--  signal phase_adj          : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := ci_phase_adj;
  signal phase_adj          : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := (others => '0');  
  signal phase_adj_d1       : std_logic_vector(C_ACCUMULATOR_WIDTH-1 downto 0) := ci_phase_adj;
  signal dither             : std_logic_vector(ci_dither_width-1 downto 0)     := (others => '0');
  signal sin_rom_addr       : std_logic_vector(ci_ram_addr_width-1 downto 0):= (others => '0');
  signal cos_rom_addr       : std_logic_vector(ci_ram_addr_width-1 downto 0):= (others => '0');
  signal sin_x              : std_logic_vector(ci_ram_data_width-1 downto 0):= (others => '0');
  signal cos_x              : std_logic_vector(ci_ram_data_width-1 downto 0):= (others => '0');
  signal phase_error        : std_logic_vector(C_ACCUMULATOR_WIDTH-ci_ram_addr_width-1 downto 0) := (others => '0');

  signal pre_sine   : std_logic_vector(C_OUTPUT_WIDTH-1 downto 0) := (others => '0');
  signal pre_cosine : std_logic_vector(C_OUTPUT_WIDTH-1 downto 0) := (others => '0');

  signal clear_op : std_logic := '0';
BEGIN

  i_sclr: if C_HAS_SCLR = 1 generate
    sclr_i <= sclr;
  end generate i_sclr;
  i_ce: if C_HAS_CE = 1 generate
    ce_i <= ce;
  end generate i_CE;
  i_rdy: if C_HAS_RDY = 1 generate
    i_multi_channel : if C_CHANNELS > 1 generate
      i_rdy : dds_compiler_v1_1_reg
        generic map(
          C_LATENCY  => ci_latency,
          C_HAS_CE   => C_HAS_CE,
          C_HAS_SCLR => 1,
          C_WIDTH    => 1
          )
        port map(
          CLK  => CLK,
          CE   => ce_i,
          SCLR => sclr_i,
          D(0) => '1',
          Q(0) => rdy_i
          );

    end generate i_multi_channel;
    i_single_channel: if C_CHANNELS = 1 generate
      function fn_rdy_latency (
        p_lat : integer)
        return integer is
      begin  -- rdy_latency
        if p_lat = 0  then
          return 0;
        else
          return p_lat-1;
        end if;
      end fn_rdy_latency;
      constant rdy_latency : integer := fn_rdy_latency(ci_latency);
    begin
      i_rdy : dds_compiler_v1_1_reg
        generic map(
          C_LATENCY  => rdy_latency,     
          C_HAS_CE   => C_HAS_CE,
          C_HAS_SCLR => 1,
          C_WIDTH    => 1
          )
        port map(
          CLK  => CLK,
          CE   => ce_i,
          SCLR => sclr_i,
          D(0) => '1',
          Q(0) => rdy_i
          );
      
    end generate i_single_channel;
    rdy <= rdy_i;
  end generate i_rdy;
  i_rfd: if C_HAS_RFD = 1 generate
    rfd <= '1';
  end generate i_rfd;

  -----------------------------------------------------------------------------
  -- data port and address delay (allows we signals to be piped)
  -----------------------------------------------------------------------------
  i_fast: if C_OPTIMISE_GOAL = c_opt_speed generate
    i_port_delay: process (clk)
    begin  -- process i_port_delay
      if rising_edge(clk) then
        data_i <= data;
        a_i <= a(3 downto 0);
        if we = '1' then
          if a(4) = '0' then
            phase_inc_we <= '1';
            phase_adj_we <= '0';
          else
            phase_inc_we <= '0';
            phase_adj_we <= '1';
          end if;
        else
          phase_inc_we <= '0';
          phase_adj_we <= '0';
        end if;
      end if;
    end process i_port_delay;
  end generate i_fast;
  i_small: if C_OPTIMISE_GOAL = c_opt_area generate
    data_i <= data;
    a_i <= a(3 downto 0);
    phase_inc_we <= '1' when a(4) = '0' and we = '1' else '0';
    phase_adj_we <= '1' when a(4) = '1' and we = '1' else '0';
  end generate i_small;
  -----------------------------------------------------------------------------
  -- Multichannel channel index
  -----------------------------------------------------------------------------
  i_multichan: if C_CHANNELS >1 generate
    i_chancount: process(clk)
    begin
      if rising_edge(clk) then
        if sclr_i = '1' then 
          chan_addr      <= ci_one;
          chan_addr_del1 <= (others => '0');
          chan_addr_del2 <= (others => '0');
          chan_addr_del3 <= (others => '0');
        elsif ce_i = '1' then
          if std_logic_vector_2_posint(chan_addr) = C_CHANNELS-1 then
            chan_addr <= (others => '0');
          else
            chan_addr <= chan_addr+ci_one;
          end if;
          chan_addr_del1 <= chan_addr;
          chan_addr_del2 <= chan_addr_del1;
          chan_addr_del3 <= chan_addr_del2;
        end if;
      end if;
    end process i_chancount;
  end generate i_multichan;
  -----------------------------------------------------------------------------
  -- Phase inc port
  -----------------------------------------------------------------------------
  i_phase_inc_solo: if C_CHANNELS = 1 generate
    i_const_freq: if C_PHASE_INCREMENT = c_phase_inc_fixed generate
      pre_phase_inc <= ci_phase_inc(C_DATA_WIDTH-1 downto 0);
    end generate i_const_freq;
    i_prog_freq: if C_PHASE_INCREMENT = c_phase_inc_prog generate
      --when using DSP48 there's no way to initialize the CREG, so this
      --phase_inc has to be reset rather than preset.
      function fn_phase_inc_init (
        p_use_dsp48 : integer;
        p_phase_inc : std_logic_vector;
        p_width     : integer)
        return std_logic_vector is
        variable ret : std_logic_vector(p_width-1 downto 0);
      begin  -- fn_phase_inc_init
        ret := (others => '0');
        if p_use_dsp48 = 1 then
          return ret;
        end if;
        return p_phase_inc;
      end fn_phase_inc_init;
      constant ci_shift_phase_inc : std_logic_vector(C_DATA_WIDTH downto 1) := fn_phase_inc_init(ci_use_dsp48,ci_phase_inc,C_DATA_WIDTH);
--      constant ci_shift_phase_inc : std_logic_vector(C_ACCUMULATOR_WIDTH downto 1) := ci_phase_inc;
      constant ci_str_phase_inc : string(1 to C_DATA_WIDTH) := slv_to_str(ci_shift_phase_inc);
    begin
      i_prog_freq : dds_compiler_v1_1_reg
        generic map(
          C_LATENCY   => 1,
          C_HAS_CE    => 1,
          C_HAS_SCLR  => 0,
          C_AINIT_VAL => ci_str_phase_inc,
          C_WIDTH     => C_DATA_WIDTH
          )
        port map(
          CLK  => CLK,
          CE   => phase_inc_we,
          D    => data_i,
          Q    => pre_phase_inc
          );
    end generate i_prog_freq;
  end generate i_phase_inc_solo;
  i_phase_inc_multi: if C_CHANNELS > 1 generate
    i_const_freq: if C_PHASE_INCREMENT = c_phase_inc_fixed generate
      i_proc_prog_freq : process(clk)
        variable phase_inc_addra : t_addr;
      begin
        if rising_edge(clk) then
          if sclr_i = '1' then
            pre_phase_inc(C_DATA_WIDTH-1 downto 0) <= (others => '0');
          elsif ce_i = '1' then
            phase_inc_addra := std_logic_vector_2_posint(chan_addr);
            pre_phase_inc(C_DATA_WIDTH-1 downto 0) <= phase_inc_ram(phase_inc_addra)(C_DATA_WIDTH-1 downto 0);
          end if;
        end if;
      end process i_proc_prog_freq;
    end generate i_const_freq;
    i_prog_freq: if C_PHASE_INCREMENT = c_phase_inc_prog generate
      i_proc_prog_freq : process(clk)
        variable phase_inc_addra : t_addr;
        variable phase_inc_addrb : t_addr;
      begin
        if rising_edge(clk) then
          if phase_inc_we = '1' then
            phase_inc_addrb := std_logic_vector_2_posint(a_i);            
            phase_inc_ram(phase_inc_addrb)(C_DATA_WIDTH-1 downto 0) <= data_i;
          end if;
          phase_inc_addra := std_logic_vector_2_posint(chan_addr);
          if sclr_i = '1'  then
            pre_phase_inc(C_DATA_WIDTH-1 downto 0) <= (others => '0');
          elsif ce_i = '1' then
            pre_phase_inc(C_DATA_WIDTH-1 downto 0) <= phase_inc_ram(phase_inc_addra)(C_DATA_WIDTH-1 downto 0);
          end if;
        end if;
      end process i_proc_prog_freq;
    end generate i_prog_freq;
  end generate i_phase_inc_multi;

  pre_phase_inc_stretch <= std_logic_vector(resize(unsigned(pre_phase_inc),C_ACCUMULATOR_WIDTH));
  
  i_ph_inc_ctrl2dsp_speedup : dds_compiler_v1_1_reg
    generic map(
      C_LATENCY  => 0,--ci_pipe(ci_ctrl2dsp_stage),
      C_HAS_CE   => C_HAS_CE,
--      C_HAS_SCLR => C_HAS_SCLR,
      C_WIDTH    => C_ACCUMULATOR_WIDTH
      )
    port map(
      CLK  => CLK,
      CE   => ce_i,
--      SCLR => sclr_i,
      D    => pre_phase_inc_stretch,
      Q    => phase_inc
      );
  -----------------------------------------------------------------------------
  -- Phase Accumulator
  -----------------------------------------------------------------------------
  i_acc_solo: if C_CHANNELS = 1 generate
    acc_phaseb <= acc_phasea + phase_inc;
  end generate i_acc_solo;

  i_acc_multi: if C_CHANNELS > 1 generate
  begin
    acc_phaseb <= phase_acc_ram_op + phase_inc;

    i_phase_acc_ram : process(clk)
      variable phase_acc_addra : t_addr;
      variable phase_acc_addrb : t_addr;
    begin
      if rising_edge(clk) then
        if sclr_i = '1' then
          for i  in 0 to C_CHANNELS-1 loop
            phase_acc_ram(i) <= ci_acc_zero-phase_inc_ram(i)(C_DATA_WIDTH-1 downto 0);
          end loop;  -- i

          phase_acc_ram_op <= (others => '0');
        elsif ce_i = '1' then
          phase_acc_addra := std_logic_vector_2_posint(chan_addr_del1);
          phase_acc_ram(phase_acc_addra) <= acc_phaseb;          

          --not really in ce_i domain, since synth can't be, but needs to be
          --outwith sclr
          phase_acc_addrb := std_logic_vector_2_posint(chan_addr);
          phase_acc_ram_op <= phase_acc_ram(phase_acc_addrb);
        end if;
      end if;
    end process i_phase_acc_ram;

  end generate i_acc_multi;
  
  i_phase_acc : dds_compiler_v1_1_reg
    generic map(
      C_LATENCY     => 1,
      C_HAS_CE      => C_HAS_CE,
      C_HAS_SCLR    => C_HAS_SCLR,
      C_WIDTH       => C_ACCUMULATOR_WIDTH
      )
    port map(
      CLK   => CLK,
      CE    => ce_i,
      SCLR  => sclr_i,
      D     => acc_phaseb,
      Q     => acc_phasea
      );

--  i_zero_latency: if ci_pipe(ci_phase_acc_stage) = 0 or C_CHANNELS > 1 generate
  i_zero_latency: if ci_pipe(ci_phase_acc_stage) = 0 generate
    acc_phase <= acc_phaseb;
  end generate i_zero_latency;
--  i_non_zero_latency: if ci_pipe(ci_phase_acc_stage) = 1 and C_CHANNELS = 1 generate
  i_non_zero_latency: if ci_pipe(ci_phase_acc_stage) = 1 generate
    acc_phase <= acc_phasea;
  end generate i_non_zero_latency;
  -----------------------------------------------------------------------------
  -- Phase adjust port
  -----------------------------------------------------------------------------
  i_phase_adj_solo: if C_CHANNELS = 1 generate
    i_const_phase: if C_PHASE_OFFSET = c_phase_adj_fixed generate
      phase_adj <= ci_phase_adj;
    end generate i_const_phase;
    i_prog_phase: if C_PHASE_OFFSET = c_phase_adj_prog generate
      constant ci_shift_phase_adj : std_logic_vector(C_DATA_WIDTH downto 1) := ci_phase_adj(C_DATA_WIDTH-1 downto 0);
      constant ci_str_phase_adj : string(1 to C_DATA_WIDTH) := slv_to_str(ci_shift_phase_adj);
      signal reg_out : std_logic_vector(C_DATA_WIDTH-1 downto 0);
    begin
      i_prog_freq : dds_compiler_v1_1_reg
        generic map(
          C_LATENCY   => 1,
          C_HAS_CE    => 1,
          C_HAS_SCLR  => 0,
          C_AINIT_VAL => ci_str_phase_adj,
          C_WIDTH     => C_DATA_WIDTH
          )
        port map(
          CLK  => CLK,
          CE   => phase_adj_we,
          D    => data_i,
          Q    => reg_out
          );
      phase_adj <= std_logic_vector(resize(signed(reg_out),C_ACCUMULATOR_WIDTH));
    end generate i_prog_phase;
  end generate i_phase_adj_solo;

  i_phase_adj_multi: if C_CHANNELS > 1 generate
    chan_addr_adj <= chan_addr;
    
    i_const_phase: if C_PHASE_OFFSET = c_phase_adj_fixed generate
      i_proc_prog_phase : process(clk)
        variable phase_adj_addra : t_addr;
      begin
        if rising_edge(clk) then
          if ce_i = '1' then
            phase_adj_addra := std_logic_vector_2_posint(chan_addr_adj);
            phase_adj(C_ACCUMULATOR_WIDTH-1 downto 0) <= std_logic_vector(resize(signed(phase_adj_ram(phase_adj_addra)(C_DATA_WIDTH-1 downto 0)),C_ACCUMULATOR_WIDTH));
          end if;
        end if;
      end process i_proc_prog_phase;
    end generate i_const_phase;
    i_prog_phase: if C_PHASE_OFFSET = c_phase_adj_prog generate
      i_proc_prog_phase : process(clk)
        variable phase_adj_addra : t_addr;
        variable phase_adj_addrb : t_addr;
      begin
        if rising_edge(clk) then
          if phase_adj_we = '1' then
            phase_adj_addrb := std_logic_vector_2_posint(a_i);
            phase_adj_ram(phase_adj_addrb)(C_DATA_WIDTH-1 downto 0) <= data_i;
          end if;
          if ce_i = '1' then
            phase_adj_addra := std_logic_vector_2_posint(chan_addr_adj);
            phase_adj(C_ACCUMULATOR_WIDTH-1 downto 0) <= std_logic_vector(resize(signed(phase_adj_ram(phase_adj_addra)(C_DATA_WIDTH-1 downto 0)),C_ACCUMULATOR_WIDTH));
          end if;
        end if;
      end process i_proc_prog_phase;
    end generate i_prog_phase;
    
  end generate i_phase_adj_multi;

  -----------------------------------------------------------------------------
  -- Phase adjust latency balance
  -----------------------------------------------------------------------------
  i_dsp48_phase_adj: if ci_use_dsp48 = 1 generate
    --the ctrl2dsp stage register could be in the same place in the behv model
    --as the synth model, but this upsets the reset circuitry which is very fragile.
    --alternatively, the delay is compensated for in the phase adjust path.
    i_phase_acc : dds_compiler_v1_1_reg
      generic map(
        C_LATENCY     => ci_pipe(ci_phase_acc_stage)-ci_pipe(ci_ctrl2dsp_stage),
        C_HAS_CE      => C_HAS_CE,
        C_WIDTH       => C_ACCUMULATOR_WIDTH
        )
      port map(
        CLK   => CLK,
        CE    => ce_i,
        D     => phase_adj,
        Q     => phase_adj_d1
        );
  end generate i_dsp48_phase_adj;
  i_fabric_phase_adj: if ci_use_dsp48 = 0 generate
    phase_adj_d1 <= phase_adj;
  end generate i_fabric_phase_adj;
  -----------------------------------------------------------------------------
  -- Phase adjuster
  -----------------------------------------------------------------------------
  i_phase_no_adj: if C_PHASE_OFFSET = c_phase_adj_none generate
    acc_phase_adjusted <= acc_phase;
  end generate i_phase_no_adj;
  i_phase_adj: if C_PHASE_OFFSET /= c_phase_adj_none generate
    acc_phase_adjusted <= acc_phase + phase_adj_d1;  --used to have balancing delay. Removed.
  end generate i_phase_adj;
  -----------------------------------------------------------------------------
  -- Dither add
  -----------------------------------------------------------------------------
  i_dither: if C_NOISE_SHAPING = c_noise_shaping_dither generate
    i_lfsr1: process(clk)
    begin
      if rising_edge(clk) then
        if sclr_i = '1' then
          lfsr1 <= (others => '0');
          lfsr2 <= (others => '0');
          lfsr3 <= (others => '0');
          lfsr4 <= (others => '0');
        elsif ce_i = '1' then
          lfsr1 <= lfsr1(11 downto 0)& NOT(lfsr1(12) xor lfsr1(10) xor lfsr1(9) xor lfsr1(0));
          lfsr2 <= lfsr2(12 downto 0)& NOT(lfsr2(13) xor lfsr2(8) xor lfsr2(4) xor lfsr2(0));
          lfsr3 <= lfsr3(13 downto 0)& NOT(lfsr3(14) xor lfsr3(0));
          lfsr4 <= lfsr4(14 downto 0)& NOT(lfsr4(15) xor lfsr4(13) xor lfsr4(4) xor lfsr4(0));
        end if;
      end if;
    end process;
    combine1 <= (lfsr1(ci_dither_width-1)&lfsr1(ci_dither_width-1 downto 0))   + (lfsr2(ci_dither_width-1)&lfsr2(ci_dither_width-1 downto 0));
    combine2 <= (lfsr3(ci_dither_width-1)&lfsr3(ci_dither_width-1 downto 0))   + (lfsr4(ci_dither_width-1)&lfsr4(ci_dither_width-1 downto 0));
    combine3 <= (combine1(ci_dither_width)&combine1(ci_dither_width downto 0)) + (combine2(ci_dither_width)&combine2(ci_dither_width downto 0));

    --the timing of dither add is different depending on DSP48 use. This is
    --because the behv model and synth model agree as far as the output of the
    --accumulator in terms of timing, but thereafter, the synth has pipes in the
    --datapath, but the behv model doesn't. The synth model delays dither by 2,
    --then adds it after the adjust stage. However, in the case of dsp48, the
    --dither is added in parallel with phase adjust, hence the variations.

    i_dither_delay: block
      -- purpose: determines the length of the equalizing delay for dither
      function fn_dither_delay (
        p_pipe      : t_pipe_top;
        p_use_DSP48 : integer;
        p_channels  : integer)
        return integer is
        variable ret : integer;
      begin  -- fn_dither_delay
        ret := 0;
        if p_use_DSP48 = 1 then
          ret := 2-ci_pipe(ci_ctrl2dsp_stage);
        else
          ret := 2-ci_pipe(ci_phase_adj_stage)-ci_pipe(ci_phase_acc_stage);
        end if;
        --single channel DDS doesn't have so many delays in the accumulator
--        if p_channels = 1 then
          ret := ret + 1;
--        end if;
        return ret;
      end fn_dither_delay;
      constant ci_dither_delay : integer := fn_dither_delay(ci_pipe,ci_use_dsp48,C_CHANNELS);
    begin  -- block i_dither_delay
      i_dither_del : dds_compiler_v1_1_reg
        generic map(
          C_LATENCY  => ci_dither_delay,          
          C_HAS_CE   => C_HAS_CE,
--          C_HAS_SCLR => C_HAS_SCLR,
          C_WIDTH    => ci_dither_width
          )
        port map(
          CLK  => CLK,
          CE   => ce_i,
--          SCLR => sclr_i,
          D    => combine3(ci_dither_width+1 downto 2),
          Q    => dither
          );
      
    end block i_dither_delay;
    

    acc_phase_shaped <= acc_phase_adjusted + (dither&c_slv_dither_shift);
    diag_shaped <= acc_phase_shaped - acc_phase_adjusted;
  end generate i_dither;
  
  i_no_dither: if C_NOISE_SHAPING = c_noise_shaping_off or C_NOISE_SHAPING = c_noise_shaping_taylor generate
    acc_phase_shaped <= acc_phase_adjusted;
  end generate i_no_dither;
  -----------------------------------------------------------------------------
  -- Sine-Cosine LUT
  -----------------------------------------------------------------------------
  --this is the RTL model, remember? Hence, dont worry about quarter wave/halfwave
  --etc. Just look up a table and get on with it.
  i_block_rom: if ci_rom_type = BLOCK_ROM generate
    sin_rom_addr <= acc_phase_shaped(C_ACCUMULATOR_WIDTH-1 downto C_ACCUMULATOR_WIDTH-ci_ram_addr_width);
    cos_rom_addr <= sin_rom_addr + 2**(ci_ram_addr_width-2);  --quarter wave advance
    
    i_pos_sin: if C_NEGATIVE_SINE = 0 generate
      sin_x <= sin_lut(std_logic_vector_2_posint(sin_rom_addr));
    end generate i_pos_sin;
    i_neg_sin: if C_NEGATIVE_SINE = 1 generate
      sin_x <= int_2_std_logic_vector(0,ci_ram_data_width) - sin_lut(std_logic_vector_2_posint(sin_rom_addr));
    end generate i_neg_sin;
    
    i_pos_cos: if C_NEGATIVE_COSINE = 0 generate
      cos_x <= sin_lut(std_logic_vector_2_posint(cos_rom_addr));
    end generate i_pos_cos;
    i_neg_cos: if C_NEGATIVE_COSINE = 1 generate
      cos_x <= int_2_std_logic_vector(0,ci_ram_data_width) - sin_lut(std_logic_vector_2_posint(cos_rom_addr));
    end generate i_neg_cos;
  end generate i_block_rom;

  -----------------------------------------------------------------------------
  -- Non-EFF
  -----------------------------------------------------------------------------
  i_no_eff: if C_NOISE_SHAPING /= c_noise_shaping_taylor generate
    pre_sine   <= sin_x(ci_ram_data_width-1 downto ci_ram_data_width-C_OUTPUT_WIDTH) when clear_op = '0' else (others => 'X');
    pre_cosine <= cos_x(ci_ram_data_width-1 downto ci_ram_data_width-C_OUTPUT_WIDTH) when clear_op = '0' else (others => 'X');
  end generate i_no_eff;
  -----------------------------------------------------------------------------
  -- EFF
  -----------------------------------------------------------------------------
  i_eff: if C_NOISE_SHAPING = c_noise_shaping_taylor generate
    constant ci_phase_error_width : integer                                                    := C_ACCUMULATOR_WIDTH-CI_RAM_ADDR_WIDTH;
    constant ci_eff_stretch       : integer                                                    := C_OUTPUT_WIDTH - CI_RAM_ADDR_WIDTH;  -- amount EFF has to expand accuracy by
    constant ci_pi_len            : integer := 9;
    constant ci_pi                : std_logic_vector(ci_pi_len-1 downto 0)           := "011001001";
    constant padding_zeros        : std_logic_vector(ci_eff_stretch -1 downto 0) := (others => '0');    
    signal   eff_phase_error      : std_logic_vector(ci_eff_stretch + 2 -1 downto 0)           := (others => '0');
    signal   diag_pi              : std_logic_vector(ci_pi_len-1 downto 0)           := ci_pi;    
    signal   radian_error         : std_logic_vector((ci_eff_stretch+2)+ci_pi_len-1 downto 0)          := (others => '0'); --fixed length pi
    signal   radian_splice        : std_logic_vector(ci_eff_stretch+1 downto 0)                  := (others => '0');
    signal   ph_err_adj           : std_logic_vector(ci_eff_stretch downto 0)                  := (others => '0');
    signal   i_pi                 : integer                                                    := 35;
    signal   i_eff_phase_err      : integer                                                    := 35;
    signal   i_ph_err_adj         : integer                                                    := 35;
    signal   sin_factor           : std_logic_vector(ci_eff_stretch downto 0);
    signal   cos_factor           : std_logic_vector(ci_eff_stretch downto 0);
    signal   i_sin_x              : integer                                                    := 35;
    signal   i_cos_x              : integer                                                    := 35;
    signal   i_sin_mult_adj       : integer                                                    := 35;
    signal   i_cos_mult_adj       : integer                                                    := 35;
    signal   sin_mult_adj         : std_logic_vector(2*(ci_eff_stretch+1) downto 0)          := (others => '0');
    signal   cos_mult_adj         : std_logic_vector(2*(ci_eff_stretch+1) downto 0)          := (others => '0');
    signal   sin_adj              : std_logic_vector(C_OUTPUT_WIDTH+ci_eff_stretch-1 downto 0) := (others => '0');
    signal   cos_adj              : std_logic_vector(C_OUTPUT_WIDTH+ci_eff_stretch-1 downto 0) := (others => '0');
    signal   shifted_sin_x        : std_logic_vector(C_OUTPUT_WIDTH+ci_eff_stretch-1 downto 0) := (others => '0');
    signal   shifted_cos_x        : std_logic_vector(C_OUTPUT_WIDTH+ci_eff_stretch-1 downto 0) := (others => '0');
    signal off_final_sin : std_logic_vector(C_OUTPUT_WIDTH+ci_eff_stretch-1 downto 0) := (others => '0');
    signal off_final_cos : std_logic_vector(C_OUTPUT_WIDTH+ci_eff_stretch-1 downto 0) := (others => '0');
    signal final_sin  : std_logic_vector(C_OUTPUT_WIDTH+ci_eff_stretch-2 downto 0) := (others => '0');
    signal final_cos  : std_logic_vector(C_OUTPUT_WIDTH+ci_eff_stretch-2 downto 0) := (others => '0');
    
  begin
    shifted_sin_x <= sin_x&padding_zeros;
    shifted_cos_x <= cos_x&padding_zeros;  --'1' in synth model, but not here!
    phase_error   <= NOT(acc_phase_shaped(C_ACCUMULATOR_WIDTH-ci_ram_addr_width-1)) & --
                     --inverted top bit effects subtraction of 0.5
                     acc_phase_shaped(C_ACCUMULATOR_WIDTH-ci_ram_addr_width-2 downto 0);
    i_acc_bigger: if ci_phase_error_width >= ci_eff_stretch+2 generate
      eff_phase_error <= phase_error(phase_error'LEFT downto phase_error'LEFT - (ci_eff_stretch+2) +1);
    end generate i_acc_bigger;
    i_acc_smaller: if ci_eff_stretch+2 > ci_phase_error_width generate
      eff_phase_error(eff_phase_error'LEFT downto eff_phase_error'LEFT-ci_phase_error_width+1) <= phase_error;
    end generate i_acc_smaller;
    i_pi            <= slv_to_int(ci_pi);
    i_eff_phase_err <= slv_to_int(eff_phase_error);
    radian_error    <= int_to_slv((i_pi *i_eff_phase_err),(ci_eff_stretch+2)+ci_pi'LENGTH);

    radian_splice <= radian_error(radian_error'LEFT-1 downto radian_error'LEFT-(ci_eff_stretch+2));
    i_ph_err_adj <= slv_to_int(radian_splice);

    --multiplication here is unsigned, but the signed package is used here, so
    --force it with leading 0s.
    sin_factor <= sin_x(sin_x'LEFT downto sin_x'LEFT - ci_eff_stretch);
    cos_factor <= cos_x(cos_x'LEFT downto cos_x'LEFT - ci_eff_stretch);
    i_sin_x <= slv_to_int(sin_factor);
    i_cos_x <= slv_to_int(cos_factor);

    i_sin_mult_adj <= i_ph_err_adj * i_cos_x;
    i_cos_mult_adj <= i_ph_err_adj * i_sin_x;

    sin_mult_adj  <= int_to_slv(i_sin_mult_adj,2*(ci_eff_stretch+1)+1);
    cos_mult_adj  <= int_to_slv(i_cos_mult_adj,2*(ci_eff_stretch+1)+1);

    ---------------------------------------------------------------------------
    -- off_final_sin and cos have an extra digit due to the trick to avoid an
    -- 2's complementer after the ROM.
    ---------------------------------------------------------------------------
    i_norm_signs : if C_NEGATIVE_COSINE = C_NEGATIVE_SINE generate
      off_final_sin     <= shifted_sin_x + (sin_mult_adj);
      off_final_cos     <= shifted_cos_x - (cos_mult_adj);
    end generate i_norm_signs;
    i_diff_signs : if C_NEGATIVE_COSINE /= C_NEGATIVE_SINE generate
      off_final_sin     <= shifted_sin_x - (sin_mult_adj);
      off_final_cos     <= shifted_cos_x + (cos_mult_adj);
    end generate i_diff_signs;

    final_sin <= off_final_sin(off_final_sin'LEFT downto 1);
    final_cos <= off_final_cos(off_final_cos'LEFT downto 1);

    i_op_clear: process(sclr_i, clk)
    begin
      if sclr_i = '1' then
        clear_op <= '1';
      elsif rising_edge(clk) then
        if ce_i = '1' then
          clear_op <= '0';
        end if;
      end if;
    end process;
    
    pre_sine      <= final_sin(final_sin'LEFT downto final_sin'LEFT-C_OUTPUT_WIDTH+1) when clear_op = '0' else (others => 'X');
    pre_cosine    <= final_cos(final_cos'LEFT downto final_cos'LEFT-C_OUTPUT_WIDTH+1) when clear_op = '0' else (others => 'X');
  end generate i_eff;

  -- purpose: pipelines to mimic latency
  i_output_pipes: block
    -- purpose: find length of pipe (differs for single channel because of accumulator reset
    function fn_pipe_len (
      p_channels : integer;
      p_latency  : integer)
      return integer is
      variable ret : integer;
    begin  -- fn_pipe_leng
      if p_channels = 1 then
        ret := p_latency-1;
      else
        ret := p_latency-1;             
      end if;
      if ret < 0 then
        ret := 0;
      end if;
      return ret;
    end fn_pipe_len;
    constant ci_pipe_length : integer := fn_pipe_len(C_CHANNELS, ci_latency);
    function fn_clear_del (
      p_channels : integer;
      p_pipe     : t_pipe_top)
      return integer is
    begin  -- fn_clear_del
      if p_channels = 1 then
        return p_pipe(ci_phase_acc_stage);
      end if;
      return 0;
    end fn_clear_del;
  begin  -- block i_output_pipes
    i_has_sine : if C_OUTPUTS_REQUIRED = c_sine_op_reqd or C_OUTPUTS_REQUIRED = c_both_op_reqd generate
      i_pipe_sin : dds_compiler_v1_1_reg
        generic map(
          C_LATENCY   => ci_pipe_length,
          C_HAS_CE    => C_HAS_CE,
          C_HAS_SINIT => 1,
          C_WIDTH     => C_OUTPUT_WIDTH
          )
        port map(
          CLK   => CLK,
          CE    => ce_i,
          SINIT => sclr_i,
          D     => pre_sine,
          Q     => SINE
          );
    end generate i_has_sine;
    i_has_cos : if C_OUTPUTS_REQUIRED = c_cosine_op_reqd or C_OUTPUTS_REQUIRED = c_both_op_reqd generate
      i_pipe_cos : dds_compiler_v1_1_reg
        generic map(
          C_LATENCY   => ci_pipe_length,
          C_HAS_CE    => C_HAS_CE,
          C_HAS_SINIT => 1,
          C_WIDTH     => C_OUTPUT_WIDTH
          )
        port map(
          CLK   => CLK,
          CE    => ce_i,
          SINIT => sclr_i,
          D     => pre_cosine,
          Q     => COSINE
          );
    end generate i_has_cos;

    i_channel_index : if C_HAS_CHANNEL_INDEX = 1 generate
      i_pipe_channel : dds_compiler_v1_1_reg
        generic map(
--          C_LATENCY   => ci_pipe_length,
          C_LATENCY   => ci_latency,
          C_HAS_CE    => C_HAS_CE,
          C_HAS_SINIT => 1,
          C_WIDTH     => ci_chan_width
          )
        port map(
          CLK   => CLK,
          CE    => ce_i,
          SINIT => sclr_i,
          D     => chan_addr_del1,
          Q     => CHANNEL
          );

    end generate i_channel_index;

  end block i_output_pipes;
END behavioral;

