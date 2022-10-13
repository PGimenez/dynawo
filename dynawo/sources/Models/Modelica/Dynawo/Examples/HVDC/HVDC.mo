within Dynawo.Examples.HVDC;

model HVDC "HVDC link connected to two infinite buses"
  /*
  * Copyright (c) 2015-2022, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
  */
  import Dynawo;
  import Modelica;
  extends Icons.Example;
  Dynawo.Electrical.HVDC.HvdcVSC.HvdcVSC HVDC(CdcPu = 1.68, DUDC = 0.01, DeadBandU = 0, InPu = 1.081, Ip10Pu = 0.885803, Ip20Pu = -0.876285, IpMaxCstPu = 2, Iq10Pu = -0.297138, Iq20Pu = -0.292657, KiACVoltageControl = 33.5, KiDeltaP = 20, KiPControl = 100, Kidc = 20, KpACVoltageControl = 0, KpDeltaP = 40, KpPControl = 0.4, Kpdc = 40, Lambda = 0.1316, P10Pu = -8.98, P20Pu = 9, PMaxOPPu = 1.05, PMinOPPu = -1.05, Q10Pu = -3.01229, Q20Pu = -3.00569, QMaxCombPu = 0.6, QMaxOPPu = 0.4, QMinCombPu = -0.6, QMinOPPu = -0.4, RdcPu = 0.00024, SNom = 1000, SlopePRefPu = 0.125, SlopeQRefPu = 100, SlopeRPFault = 6.7, SlopeURefPu = 100, TBlock = 0.1, TBlockUV = 0.01, TDeblockU = 0.02, TQ = 0.01, U10Pu = 1.01377, U20Pu = 1.02704, UBlockUVPu = 0.2, UMaxdbPu = 1.2, UMindbPu = 0.8, UPhase10 = 0.0316806, UPhase20 = -0.0328543, Udc10Pu = 0.997804, Udc20Pu = 1, UdcMaxPu = 1.15, UdcMinPu = 0.95, UdcRefMaxPu = 1.15, UdcRefMinPu = 0.95, i10Pu = Complex(-8.9477, 2.6893), i20Pu = Complex(8.85426, 2.63714), modeU10 = 1, modeU20 = 1, tFilter = 0.000001,tMeasure = 0.01,tMeasureP = 0.0001,u10Pu = Complex(1.01326, 0.03211), u20Pu = Complex(1.02648, -0.03373)) annotation(
    Placement(visible = true, transformation(origin = {20, -30}, extent = {{-50, -30}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0, GPu = 0, RPu = 0.00037, XPu = 0.0037) annotation(
    Placement(visible = true, transformation(origin = {-52, -25}, extent = {{-40, -40}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = 0, GPu = 0, RPu = 0.00037, XPu = 0.0037) annotation(
    Placement(visible = true, transformation(origin = {82, -25}, extent = {{-40, -40}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {-95, -55}, extent = {{-40, -40}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus2(UPhase = 0, UPu = 1) annotation(
    Placement(visible = true, transformation(origin = {95, -25}, extent = {{-40, -40}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Step URef1Pu(height = 0, offset = 1, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef1Pu(height = 0, offset = 0.301, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = 0, offset = 0.9, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant modeU1(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant modeu2(k = 1) annotation(
    Placement(visible = true, transformation(origin = {50, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRef2Pu(height = 0, offset = 0.301, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step URef2Pu(height = 0, offset = 1, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {50, 49}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step UdcRefPu(height = 0.0, offset = 1, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {50, 20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Electrical.Events.NodeFault nodeFault(RPu = 0.0005, XPu = 0, tBegin = 5, tEnd = 6) annotation(
    Placement(visible = true, transformation(origin = {42, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  HVDC.Conv1.switchOffSignal1.value = false;
  HVDC.Conv1.switchOffSignal2.value = false;
  HVDC.Conv1.switchOffSignal3.value = false;
  HVDC.Conv2.switchOffSignal1.value = false;
  HVDC.Conv2.switchOffSignal2.value = false;
  HVDC.Conv2.switchOffSignal3.value = false;
  connect(HVDC.terminal2, line2.terminal1) annotation(
    Line(points = {{30, -40}, {42, -40}}, color = {0, 0, 255}));
  connect(HVDC.terminal1, line1.terminal2) annotation(
    Line(points = {{-30, -40}, {-42, -40}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus1.terminal) annotation(
    Line(points = {{-92, -40}, {-110, -40}}, color = {0, 0, 255}));
  connect(line2.terminal2, infiniteBus2.terminal) annotation(
    Line(points = {{92, -40}, {110, -40}}, color = {0, 0, 255}));
  connect(QRef1Pu.y, HVDC.QRef1Pu) annotation(
    Line(points = {{-39, -10}, {-27, -10}, {-27, -18}}, color = {0, 0, 127}));
  connect(URef1Pu.y, HVDC.URef1Pu) annotation(
    Line(points = {{-39, 20}, {-21, 20}, {-21, -18}}, color = {0, 0, 127}));
  connect(PRefPu.y, HVDC.PRefPu) annotation(
    Line(points = {{-39, 50}, {-15, 50}, {-15, -18}}, color = {0, 0, 127}));
  connect(modeU1.y, HVDC.modeU1) annotation(
    Line(points = {{-39, 80}, {-9, 80}, {-9, -18}}, color = {0, 0, 127}));
  connect(modeu2.y, HVDC.modeU2) annotation(
    Line(points = {{39, -10}, {27, -10}, {27, -18}}, color = {0, 0, 127}));
  connect(UdcRefPu.y, HVDC.UdcRefPu) annotation(
    Line(points = {{39, 20}, {21, 20}, {21, -18}}, color = {0, 0, 127}));
  connect(URef2Pu.y, HVDC.URef2Pu) annotation(
    Line(points = {{39, 49}, {15, 49}, {15, -18}}, color = {0, 0, 127}));
  connect(QRef2Pu.y, HVDC.QRef2Pu) annotation(
    Line(points = {{39, 80}, {9, 80}, {9, -18}}, color = {0, 0, 127}));
  connect(nodeFault.terminal, line2.terminal1) annotation(
    Line(points = {{42, -84}, {42, -40}}, color = {0, 0, 255}));
//__OpenModelica_commandLineOptions = "--daeMode",
  annotation(
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-06, Interval = 0.0001, emit_protected = "()"),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">
     This test case works with Modelica Standard Library 3.2.3. <div><br></div><div>This test case consists in one HVDC link connected to two infinite buses. A short-circuit at the HVDC link terminal 2 is simulated at t = 5s and cleared at t = 6s.    </div><div><br></div><div>
    </div>
    <div><br></div><div><br></div><div><br></div><div><br></div><div><br></div><div><span style=\"font-size: 12px;\"><br></span></div>
</span></body></html>"),
    Diagram(coordinateSystem(preserveAspectRatio = false, grid = {1, 1})),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
    __OpenModelica_simulationFlags(initialStepSize = "0.001", lv = "LOG_STATS", s = "ida", nls = "hybrid", nlsLS = "klu", maxIntegrationOrder = "2", maxStepSize = "10"));
end HVDC;
