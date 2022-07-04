within Dynawo.Examples.DynamicLineTests;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model SMIBdynamicLineFault "Node fault on a line for SMIB model with dynamic lines "

  import Dynawo;
  import Modelica;

  extends Icons.Example;

  parameter Real x = 0.5 "Emplacement of the fault relative to the line lenght : x = default location /line lenght";
  parameter Real theta_seuil = Modelica.Constants.pi * 270 / 180 "Maximum value of theta for a stable configuration in rad";
  parameter Types.Time delta_t = 0.9453125 "Fault duration in seconds" ;

  //Generator, dynamic lines and infinite bus
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous generatorSynchronous(Ce0Pu = 0.903, Cm0Pu = 0.903, Cos2Eta0 = 0.68888, DPu = 0, Efd0Pu = 2.4659, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 3.5, IRotor0Pu = 2.4659, IStator0Pu = 22.2009, Id0Pu = -0.91975, If0Pu = 1.4855, Iq0Pu = -0.39262, LDPPu = 0.16634, LQ1PPu = 0.92815, LQ2PPu = 0.12046, LambdaAD0Pu = 0.89347, LambdaAQ0Pu = -0.60044, LambdaAirGap0Pu = 1.0764, LambdaD0Pu = 0.89243, LambdaQ10Pu = -0.60044, LambdaQ20Pu = -0.60044, Lambdad0Pu = 0.75547, Lambdaf0Pu = 1.1458, Lambdaq0Pu = -0.65934, LdPPu = 0.15, LfPPu = 0.16990, LqPPu = 0.15, MdPPu = 1.66, MdSat0PPu = 1.5792, Mds0Pu = 1.5785, Mi0Pu = 1.5637, MqPPu = 1.61, MqSat0PPu = 1.5292, Mqs0Pu = 1.530930, MrcPPu = 0, MsalPu = 0.05, P0Pu = -19.98, PGen0Pu = 19.98, PNomAlt = 2200, PNomTurb = 2220, Pm0Pu = 0.903, Q0Pu = -9.68, QGen0Pu = 9.6789, QStator0Pu = 9.6789, RDPPu = 0.03339, RQ1PPu = 0.00924, RQ2PPu = 0.02821, RTfPu = 0, RaPPu = 0.003, RfPPu = 0.00074, SNom = 2220, Sin2Eta0 = 0.31111, SnTfo = 2220, Theta0 = 1.2107, ThetaInternal0 = 0.71622, U0Pu = 1, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, UPhase0 = 0.494442, UStator0Pu = 1, Ud0Pu = 0.65654, Uf0Pu = 0.00109, Uq0Pu = 0.75434, XTfPu = 0, md = 0.031, mq = 0.031, nd = 6.93, nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {46, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.Step PmPu(Value0 = 0.903, Height = 0.02, tStep = 1000);
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Basics.SetPoint EfdPu(Value0 = 2.4659);
  Dynawo.Electrical.Lines.DynamicLine line2(CPu = 0.0000375, GPu = 0, LPu = 0.0375, RPu = 0.00375, i10Pu = Complex(-11.09238, -0.4319655) , i20Pu = Complex(11.09237, 0.4320312), iGC10Pu = Complex(3.626336e-06, 3.2352e-05), iGC20Pu = Complex(-1.203307e-05, 3.330437e-05), iRL0Pu = Complex(-11.09238, -0.4319979), u10Pu = Complex(0.86272, -0.0967023), u20Pu = Complex(0.8881165, 0.3208819)) annotation(
    Placement(visible = true, transformation(origin = {-22, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine line1(CPu = (1 - x) * 0.0000375, GPu = 0, LPu = (1 - x) * 0.0375, RPu = (1 - x) *0.00375, i10Pu = Complex(-11.09238, -0.4319655) , i20Pu = Complex(11.09237, 0.4320312), iGC10Pu = Complex(3.626336e-06, 3.2352e-05), iGC20Pu = Complex(-1.203307e-05, 3.330437e-05), iRL0Pu = Complex(-11.09238, -0.4319979), u10Pu = Complex(0.86272, -0.0967023), u20Pu = Complex(0.8754183, 0.1120892)) annotation(
    Placement(visible = true, transformation(origin = {-44, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.Electrical.Lines.DynamicLine line3(CPu = x * 0.0000375, GPu = 0, LPu = x * 0.0375, RPu = x * 0.00375, i10Pu = Complex(-11.09238, -0.4319655) , i20Pu = Complex(11.09237, 0.4320312), iGC10Pu = Complex(3.626336e-06, 3.2352e-05), iGC20Pu = Complex(-1.203307e-05, 3.330437e-05), iRL0Pu = Complex(-11.09238, -0.4319979), u10Pu = Complex(0.8754183, 0.1120892), u20Pu = Complex(0.8881165, 0.3208819)) annotation(
    Placement(visible = true, transformation(origin = {2, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.005746957711326909, XPu = 0.019156525704423027, tBegin = 1, tEnd = 1 + delta_t) annotation(
    Placement(visible = true, transformation(origin = {18, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = -18.96118, UPu = 0.8681228) annotation(
    Placement(visible = true, transformation(origin = {-64, -4}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
initial equation
  der(generatorSynchronous.lambdafPu) = 0;
  der(generatorSynchronous.lambdaDPu) = 0;
  der(generatorSynchronous.lambdaQ1Pu) = 0;
  der(generatorSynchronous.lambdaQ2Pu) = 0;
  der(generatorSynchronous.theta) = 0;
  der(generatorSynchronous.omegaPu.value) = 0;

equation
  assert(generatorSynchronous.theta < theta_seuil, "temps critique atteint") "Stability condition";
  line1.omegaPu = generatorSynchronous.omegaPu.value;
  line2.omegaPu = generatorSynchronous.omegaPu.value;
  line3.omegaPu = generatorSynchronous.omegaPu.value;
  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(generatorSynchronous.PmPu, PmPu.step);
  connect(generatorSynchronous.efdPu, EfdPu.setPoint);
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = false;
  line3.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  connect(line1.terminal2, line3.terminal1) annotation(
    Line(points = {{-24, 30}, {-18, 30}}, color = {0, 0, 255}));
  connect(line3.terminal2, transformer.terminal1) annotation(
    Line(points = {{22, 30}, {26, 30}, {26, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, transformer.terminal1) annotation(
    Line(points = {{-2, -40}, {26, -40}, {26, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{66, 0}, {80, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line1.terminal2) annotation(
    Line(points = {{18, 86}, {-24, 86}, {-24, 30}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-64, 30}, {-64, -4}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-42, -40}, {-64, -40}, {-64, -4}}, color = {0, 0, 255}));

   annotation( preferredView = "text", experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06),
    Documentation(info = "<html><head></head><body>The purpose of this test case is to evaluate the transient stability of an SMIB model with dynamic lines by evaluating the rotor angle Theta for a node fault starting at (t_begin = 1 s) and (t_end = t_begin + delta_t).
    The following figures show the excepted evolution of the generator rotor angle a if delta_t < CCT (the critical clearing time).

    <figure>
    <img width=\"400\" src=\"modelica://Dynawo/Examples/DynamicLineTests/Images/theta.png\">
    </figure>

For delta_t > CCT, we represent the loss of synchronism with an assert stopping the simulation if theta exceeds 270 degrees.
    </body></html>"));
end SMIBdynamicLineFault;
