within Dynawo.Examples.DynamicLineTests;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPD0.5-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

  model SMIBdynamicLineFault_INIT "Initialization for the DynamicLine_INIT inputs considering the SMIB model "

  import Dynawo;
  import Modelica;

  extends Icons.Example;

  parameter Real x = 0.5 "Emplacement of the fault relative to the line lenght : x= default location /line lenght";
  parameter Types.PerUnit UBusPu = 0.8681228 "Complex voltage amplitude at the infinite bus in pu (base Unom)";
  parameter Types.Angle UBusPhase = -18.96118 "Complex voltage phase at the infinite bus in rad";
  parameter Types.PerUnit RPu = 0.0037500000000000007 "Resistance in pu (base SnRef, UNom) ";
  parameter Types.PerUnit XPu = 0.037500000000000006 "Reactance in pu (base SnRef, UNom)";
  parameter Types.PerUnit GPu = 3.75e-05 "Half-conductance in pu (base SnRef, UNom)";
  parameter Types.PerUnit BPu = 3.75e-05  "Half-susceptance in pu (base SnRef, UNom)";
  parameter Real delta_t = 0.25 "Fault duration in seconds";

//Generator, lines and infinite bus
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous generatorSynchronous(Ce0Pu = 0.903, Cm0Pu = 0.903, Cos2Eta0 = 0.68888, DPu = 0, Efd0Pu = 2.4659, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 3.5, IRotor0Pu = 2.4659, IStator0Pu = 22.2009, Id0Pu = -0.91975, If0Pu = 1.4855, Iq0Pu = -0.39262, LDPPu = 0.16634, LQ1PPu = 0.92815, LQ2PPu = 0.12046, LambdaAD0Pu = 0.89347, LambdaAQ0Pu = -0.60044, LambdaAirGap0Pu = 1.0764, LambdaD0Pu = 0.89243, LambdaQ10Pu = -0.60044, LambdaQ20Pu = -0.60044, Lambdad0Pu = 0.75547, Lambdaf0Pu = 1.1458, Lambdaq0Pu = -0.65934, LdPPu = 0.15, LfPPu = 0.16990, LqPPu = 0.15, MdPPu = 1.66, MdSat0PPu = 1.5792, Mds0Pu = 1.5785, Mi0Pu = 1.5637, MqPPu = 1.61, MqSat0PPu = 1.5292, Mqs0Pu = 1.530930, MrcPPu = 0, MsalPu = 0.05, P0Pu = -19.98, PGen0Pu = 19.98, PNomAlt = 2200, PNomTurb = 2220, Pm0Pu = 0.903, Q0Pu = -9.68, QGen0Pu = 9.6789, QStator0Pu = 9.6789, RDPPu = 0.03339, RQ1PPu = 0.00924, RQ2PPu = 0.02821, RTfPu = 0, RaPPu = 0.003, RfPPu = 0.00074, SNom = 2220, Sin2Eta0 = 0.31111, SnTfo = 2220, Theta0 = 1.2107, ThetaInternal0 = 0.71622, U0Pu = 1, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, UPhase0 = 0.494442, UStator0Pu = 1, Ud0Pu = 0.65654, Uf0Pu = 0.00109, Uq0Pu = 0.75434, XTfPu = 0, md = 0.031, mq = 0.031, nd = 6.93, nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {80, 1.9984e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = BPu, GPu = GPu, RPu = RPu, XPu = XPu) annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1( BPu = BPu * (1 - x), GPu = GPu, RPu = RPu * (1 - x), XPu = XPu * (1 - x) ) annotation(
    Placement(visible = true, transformation(origin = {-60, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.Step PmPu(Value0 = 0.903, Height = 0.02, tStep = 1000);
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Basics.SetPoint EfdPu(Value0 = 2.4659);
  Dynawo.Electrical.Lines.Line line(BPu = BPu * x, GPu = GPu, RPu = RPu * x, XPu = XPu * x) annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Electrical.Buses.InfiniteBus infiniteBus(UPhase = UBusPhase, UPu = UBusPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Events.NodeFault nodeFault(RPu = 1e-05, XPu = 1e-05, tBegin = 5, tEnd = 5+delta_t)  annotation(
    Placement(visible = true, transformation(origin = {-10, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

initial equation
  der(generatorSynchronous.lambdafPu) = 0;
  der(generatorSynchronous.lambdaDPu) = 0;
  der(generatorSynchronous.lambdaQ1Pu) = 0;
  der(generatorSynchronous.lambdaQ2Pu) = 0;
  der(generatorSynchronous.theta) = 0;
  der(generatorSynchronous.omegaPu.value) = 0;

equation
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{60, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(generatorSynchronous.PmPu, PmPu.step);
  connect(generatorSynchronous.efdPu, EfdPu.setPoint);
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  connect(line2.terminal2, transformer.terminal1) annotation(
    Line(points = {{-10, -40}, {20, -40}, {20, 0}}, color = {0, 0, 255}));
  connect(line1.terminal2, line.terminal1) annotation(
    Line(points = {{-40, 40}, {-20, 40}}, color = {0, 0, 255}));
  connect(line.terminal2, transformer.terminal1) annotation(
    Line(points = {{20, 40}, {20, 0}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-80, 40}, {-80, 0}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-50, -40}, {-80, -40}, {-80, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal1) annotation(
    Line(points = {{-10, 86}, {-20, 86}, {-20, 40}}, color = {0, 0, 255}));

   annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
Initialize the value of U0Pu and U0Phase on the two terminal of the dynamic line to start the dynamicLine_INIT, considerating the line parameters choice, please use the LoadFlow_SMIBdynamicLineFault to initialize correctly the infinite bus.
</body></html>"));
end SMIBdynamicLineFault_INIT;
