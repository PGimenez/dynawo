within Dynawo.Examples.RVS.BaseSystems;

model Loadflow_equiv
  import Modelica.ComplexMath;
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical;
  import Dynawo.Electrical.SystemBase.SnRef;
  final parameter Types.VoltageModule UNom_lower = 138 "Nominal Voltage of the lower part of the network in kV";

  final parameter Types.VoltageModule URef0_bus_101 = 1.0342 * UNom_lower;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10101 = 10 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10101 = 7.477 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_gen_10101 = Complex(PRef0Pu_gen_10101, QRef0Pu_gen_10101);
  final parameter Types.ComplexVoltagePu u0Pu_gen_10101 = ComplexMath.fromPolar(1.0297, from_deg(-6.6884));
  final parameter Types.ComplexCurrentPu i0Pu_gen_10101 = ComplexMath.conj(s0Pu_gen_10101 / u0Pu_gen_10101);
  final parameter Types.ActivePowerPu PRef0Pu_gen_20101 = 10 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20101 = 7.477 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_gen_20101 = Complex(PRef0Pu_gen_20101, QRef0Pu_gen_20101);
  final parameter Types.ComplexVoltagePu u0Pu_gen_20101 = ComplexMath.fromPolar(1.0297, from_deg(-6.6884));
  final parameter Types.ComplexCurrentPu i0Pu_gen_20101 = ComplexMath.conj(s0Pu_gen_20101 / u0Pu_gen_20101);
  final parameter Types.ActivePowerPu PRef0Pu_gen_30101 = 76 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30101 = 22.195 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_gen_30101 = Complex(PRef0Pu_gen_30101, QRef0Pu_gen_30101);
  final parameter Types.ComplexVoltagePu u0Pu_gen_30101 = ComplexMath.fromPolar(1.0163, from_deg(-2.8597));
  final parameter Types.ComplexCurrentPu i0Pu_gen_30101 = ComplexMath.conj(s0Pu_gen_30101 / u0Pu_gen_30101);
  final parameter Types.ActivePowerPu PRef0Pu_gen_40101 = 76 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_40101 = 22.195 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_gen_40101 = Complex(PRef0Pu_gen_40101, QRef0Pu_gen_40101);
  final parameter Types.ComplexVoltagePu u0Pu_gen_40101 = ComplexMath.fromPolar(1.0163, from_deg(-2.8597));
  final parameter Types.ComplexCurrentPu i0Pu_gen_40101 = ComplexMath.conj(s0Pu_gen_40101 / u0Pu_gen_40101);
  final parameter Types.ActivePowerPu P0Pu_load_1101 = 118.8 / SnRef;
  final parameter Types.ReactivePowerPu Q0Pu_load_1101 = 24.2 / SnRef;
  final parameter Types.ComplexApparentPowerPu s0Pu_load_1101 = Complex(P0Pu_load_1101, Q0Pu_load_1101);
  final parameter Types.ComplexVoltagePu u0Pu_load_1101 = ComplexMath.fromPolar(1.043, from_deg(-16.2286));
  final parameter Types.ComplexCurrentPu i0Pu_load_1101 = ComplexMath.conj(s0Pu_load_1101 / u0Pu_load_1101);
  
  Types.ActivePowerPu check_Pinfbus;
  Types.ReactivePowerPu check_Qinfbus;
  Dynawo.Electrical.Controls.Basics.SetPoint N(Value0 = 0);
  Electrical.Controls.Basics.SetPoint PrefPu_load_1101(Value0 = P0Pu_load_1101);
  Electrical.Controls.Basics.SetPoint QrefPu_load_1101(Value0 = Q0Pu_load_1101);
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_20101_ABEL_G2(KGover = 0, PGen0Pu = PRef0Pu_gen_20101, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_20101, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.126, U0Pu = 1) annotation(
    Placement(visible = true, transformation(origin = {-20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //QGen0Pu = QRef0Pu_gen_20101
  //, QRef0Pu = -QRef0Pu_gen_20101
  Dynawo.Electrical.Buses.Bus bus_40101_ABEL_G4 annotation(
    Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_101_ABEL annotation(
    Placement(visible = true, transformation(origin = {20, -10}, extent = {{-90, -10}, {90, 10}}, rotation = 180)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10101_ABEL_G1(KGover = 0, PGen0Pu = PRef0Pu_gen_10101, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_10101, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.126, U0Pu = 1
  ) annotation(
    Placement(visible = true, transformation(origin = {-60, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //QGen0Pu = QRef0Pu_gen_10101,
  //,QRef0Pu = -QRef0Pu_gen_10101
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_30101_ABEL_G3(KGover = 0, PGen0Pu = PRef0Pu_gen_30101, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_30101, QMaxPu = 0.3, QMinPu = -0.25,
  QPercent = 0.374, U0Pu = 1) annotation(
    Placement(visible = true, transformation(origin = {20, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //QGen0Pu = QRef0Pu_gen_30101,
  //,QRef0Pu = -QRef0Pu_gen_30101
  Dynawo.Electrical.Lines.Line line_101_103(BPu = 0.057 / 2, GPu = 0, RPu = 0.055, XPu = 0.211) annotation(
    Placement(visible = true, transformation(origin = {30, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ load_1101_ABEL(i0Pu = i0Pu_load_1101, s0Pu = s0Pu_load_1101, u0Pu = u0Pu_load_1101) annotation(
    Placement(visible = true, transformation(origin = {-80, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_103_ADLER annotation(
    Placement(visible = true, transformation(origin = {30, 90}, extent = {{-30, -10}, {30, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_20101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 24), XPu = 0.15 * (100 / 24), rTfoPu = 0.95238) annotation(
    Placement(visible = true, transformation(origin = {-20, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_40101_ABEL_G4(KGover = 0, PGen0Pu = PRef0Pu_gen_40101, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_40101, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.374, U0Pu = 1
  ) annotation(
    Placement(visible = true, transformation(origin = {60, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Buses.Bus bus_10101_ABEL_G1 annotation(
    Placement(visible = true, transformation(origin = {-60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_1101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 150), XPu = 0.15 * (100 / 150), rTfoPu = 1.041505) annotation(
    Placement(visible = true, transformation(origin = {-40, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.Bus bus_1101_ABEL annotation(
    Placement(visible = true, transformation(origin = {-60, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus bus_20101_ABEL_G2 annotation(
    Placement(visible = true, transformation(origin = {-20, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_40101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 89), XPu = 0.15 * (100 / 89), rTfoPu = 0.95238) annotation(
    Placement(visible = true, transformation(origin = {60, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_10101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 24), XPu = 0.15 * (100 / 24), rTfoPu = 0.95238) annotation(
    Placement(visible = true, transformation(origin = {-60, -32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio tfo_30101_101(BPu = 0, GPu = 0, RPu = 0.003 * (100 / 89), XPu = 0.15 * (100 / 89), rTfoPu = 0.95238) annotation(
    Placement(visible = true, transformation(origin = {20, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_101(Gain = 1, U0 = URef0_bus_101, URef0 = URef0_bus_101, tIntegral = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-80, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus bus_30101_ABEL_G3 annotation(
    Placement(visible = true, transformation(origin = {20, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(-16.2), UPu = 1.007) annotation(
    Placement(visible = true, transformation(origin = {30, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  check_Pinfbus = SnRef * ComplexMath.real(infiniteBus.terminal.V * ComplexMath.conj(infiniteBus.terminal.i));
  check_Qinfbus = SnRef * ComplexMath.imag(infiniteBus.terminal.V * ComplexMath.conj(infiniteBus.terminal.i));
  connect(gen_20101_ABEL_G2.terminal, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-20, -70}, {-20, -50}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-30, 10}, {-20, 10}, {-20, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(gen_40101_ABEL_G4.terminal, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{60, -70}, {60, -50}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{60, -20}, {60, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal2, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-20, -40}, {-20, -50}}, color = {0, 0, 255}));
  connect(gen_30101_ABEL_G3.terminal, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{20, -70}, {20, -50}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{20, -20}, {20, -10}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal2, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{20, -40}, {20, -50}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal2, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{60, -40}, {60, -50}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-20, -20}, {-20, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(gen_10101_ABEL_G1.terminal, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-60, -70}, {-60, -50}}, color = {0, 0, 255}));
  connect(load_1101_ABEL.terminal, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-80, 10}, {-60, 10}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal2, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-50, 10}, {-60, 10}}, color = {0, 0, 255}));
  connect(line_101_103.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{30, 28}, {30, -10}, {20, -10}}, color = {0, 0, 255}));
  connect(line_101_103.terminal2, bus_103_ADLER.terminal) annotation(
    Line(points = {{30, 48}, {30, 90}}, color = {0, 0, 255}));
  line_101_103.switchOffSignal1.value = false;
  line_101_103.switchOffSignal2.value = false;
  load_1101_ABEL.switchOffSignal1.value = false;
  load_1101_ABEL.switchOffSignal2.value = false;
  PrefPu_load_1101.setPoint.value = load_1101_ABEL.PRefPu;
  QrefPu_load_1101.setPoint.value = load_1101_ABEL.QRefPu;
  vRRemote_bus_101.URegulated = ComplexMath.'abs'(bus_101_ABEL.terminal.V) * UNom_lower;
  gen_10101_ABEL_G1.switchOffSignal1.value = false;
  gen_10101_ABEL_G1.switchOffSignal2.value = false;
  gen_10101_ABEL_G1.switchOffSignal3.value = false;
  gen_10101_ABEL_G1.N = N.setPoint.value;
  gen_10101_ABEL_G1.NQ = vRRemote_bus_101.NQ;
  gen_20101_ABEL_G2.switchOffSignal1.value = false;
  gen_20101_ABEL_G2.switchOffSignal2.value = false;
  gen_20101_ABEL_G2.switchOffSignal3.value = false;
  gen_20101_ABEL_G2.N = N.setPoint.value;
  gen_20101_ABEL_G2.NQ = vRRemote_bus_101.NQ;
  gen_30101_ABEL_G3.switchOffSignal1.value = false;
  gen_30101_ABEL_G3.switchOffSignal2.value = false;
  gen_30101_ABEL_G3.switchOffSignal3.value = false;
  gen_30101_ABEL_G3.N = N.setPoint.value;
  gen_30101_ABEL_G3.NQ = vRRemote_bus_101.NQ;
  gen_40101_ABEL_G4.switchOffSignal1.value = false;
  gen_40101_ABEL_G4.switchOffSignal2.value = false;
  gen_40101_ABEL_G4.switchOffSignal3.value = false;
  gen_40101_ABEL_G4.N = N.setPoint.value;
  gen_40101_ABEL_G4.NQ = vRRemote_bus_101.NQ;
  tfo_1101_101.switchOffSignal1.value = false;
  tfo_1101_101.switchOffSignal2.value = false;
  tfo_10101_101.switchOffSignal1.value = false;
  tfo_10101_101.switchOffSignal2.value = false;
  tfo_20101_101.switchOffSignal1.value = false;
  tfo_20101_101.switchOffSignal2.value = false;
  tfo_30101_101.switchOffSignal1.value = false;
  tfo_30101_101.switchOffSignal2.value = false;
  tfo_40101_101.switchOffSignal1.value = false;
  tfo_40101_101.switchOffSignal2.value = false;
  connect(infiniteBus.terminal, bus_103_ADLER.terminal) annotation(
    Line(points = {{30, 120}, {30, 90}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal2, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-60, -42}, {-60, -50}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-60, -22}, {-60, -10}, {20, -10}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 0.002),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"));
end Loadflow_equiv;
