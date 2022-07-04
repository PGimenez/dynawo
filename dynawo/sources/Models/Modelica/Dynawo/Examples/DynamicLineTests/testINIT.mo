within Dynawo.Examples.DynamicLineTests;

model testINIT
  import Modelica.Math;
  import Modelica.ComplexMath;
  import Dynawo;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit CPu = 2.9374375000000003e-08;
  parameter Types.PerUnit RPu = 0.000543749375;
  parameter Types.PerUnit LPu = 0.006062499375;
  parameter Types.PerUnit GPu = 0;
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus2(UPhase = 0, UPu = 1.01779) annotation(
    Placement(visible = true, transformation(origin = {-60, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = CPu/2, GPu = GPu/2 , XPu = LPu/2 , RPu = RPu/2) annotation(
    Placement(visible = true, transformation(origin = {-30, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = CPu/2, GPu = GPu/2, XPu = LPu/2 , RPu = RPu/2) annotation(
    Placement(visible = true, transformation(origin = {10, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus3(UPhase = 1.0, UPu = 1.01645) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line2(BPu = CPu, GPu = GPu, RPu = RPu, XPu = LPu) annotation(
    Placement(visible = true, transformation(origin = {-10, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  connect(line1.terminal2, infiniteBus3.terminal) annotation(
    Line(points = {{20, 12}, {30, 12}, {30, 0}, {40, 0}}, color = {0, 0, 255}));
  connect(line.terminal1, infiniteBus2.terminal) annotation(
    Line(points = {{-40, 12}, {-50, 12}, {-50, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, line1.terminal1) annotation(
    Line(points = {{-20, 12}, {0, 12}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus2.terminal) annotation(
    Line(points = {{-20, -12}, {-50, -12}, {-50, 0}, {-60, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBus3.terminal) annotation(
    Line(points = {{0, -12}, {30, -12}, {30, 0}, {40, 0}}, color = {0, 0, 255}));
end testINIT;
