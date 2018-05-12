-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/simprim/VITAL/Attic/x_and4.vhd,v 1.7 2005/02/22 06:54:42 fphillip Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  4-input AND Gate
-- /___/   /\     Filename : X_AND4.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:57:06 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL X_AND4 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.Vital_Primitives.all;
use IEEE.Vital_Timing.all;

entity X_AND4 is
  generic(
    Xon   : boolean := true;
    MsgOn : boolean := true;
    LOC   : string  := "UNPLACED";

      tipd_I0 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_I1 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_I2 : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tipd_I3 : VitalDelayType01 := (0.000 ns, 0.000 ns);

      tpd_I0_O : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I1_O : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I2_O : VitalDelayType01 := (0.000 ns, 0.000 ns);
      tpd_I3_O : VitalDelayType01 := (0.000 ns, 0.000 ns)
    );

  port(
    O  : out std_ulogic;
    I0 : in  std_ulogic;
    I1 : in  std_ulogic;
    I2 : in  std_ulogic;
    I3 : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_AND4 : entity is true;

end X_AND4;

architecture X_AND4_V of X_AND4 is

  attribute VITAL_LEVEL1 of
    X_AND4_V : architecture is true;

  signal I0_ipd : std_ulogic := 'X';
  signal I1_ipd : std_ulogic := 'X';
  signal I2_ipd : std_ulogic := 'X';
  signal I3_ipd : std_ulogic := 'X';
begin
  WireDelay     : block
  begin
    VitalWireDelay (I0_ipd, I0, tipd_I0);
    VitalWireDelay (I1_ipd, I1, tipd_I1);
    VitalWireDelay (I2_ipd, I2, tipd_I2);
    VitalWireDelay (I3_ipd, I3, tipd_I3);
  end block;

  VITALBehavior           : process (I0_ipd, I1_ipd, I2_ipd, I3_ipd)
    variable O_zd         : std_ulogic;
    variable O_GlitchData : VitalGlitchDataType;
  begin
    O_zd := I0_ipd and I1_ipd and I2_ipd and I3_ipd;
    VitalPathDelay01 (
      OutSignal     => O,
      GlitchData    => O_GlitchData,
      OutSignalName => "O",
      OutTemp       => O_zd,
      Paths         => (0 => (I0_ipd'last_event, tpd_I0_O, true),
                        1   => (I1_ipd'last_event, tpd_I1_O, true),
                        2   => (I2_ipd'last_event, tpd_I2_O, true),
                        3   => (I3_ipd'last_event, tpd_I3_O, true)),
      Mode          => VitalTransport,
      Xon           => Xon,
      MsgOn         => MsgOn,
      MsgSeverity   => warning);
  end process;
end X_AND4_V;
