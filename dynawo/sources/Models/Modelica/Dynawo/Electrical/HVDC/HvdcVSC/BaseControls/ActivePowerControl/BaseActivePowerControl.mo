within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls.ActivePowerControl;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseActivePowerControl "Base active power control for the HVDC VSC model"
  import Modelica;
  import Dynawo.NonElectrical.Blocks;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_BaseActivePowerControl;

  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in pu (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -67}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = P0Pu) "Reference active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, 19}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput blocked1(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {-130, -9}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput IpMaxPu(start = IpMaxCstPu) "Max active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, 105}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput IpMinPu(start = - IpMaxCstPu) "Min active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-130, -95}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput ipRefPPu(start = Ip0Pu) "Active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {140, 27}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tMeasureP, y_start = P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-89, -67}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {3, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {110, 27}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zero(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {110, 126}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {31, 19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-54, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = PMaxOPPu, uMin = PMinOPPu)  annotation(
    Placement(visible = true, transformation(origin = {-24, 13}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising = SlopePRefPu, y(start = P0Pu))  annotation(
    Placement(visible = true, transformation(origin = {-90, 19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.PIAntiWindupVariableLimits pIAntiWindupVariableLimits(Ki = KiPControl, Kp = KpPControl, integrator.y_start = Ip0Pu)  annotation(
    Placement(visible = true, transformation(origin = {64, 19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.ActivePowerControl.RPFaultFunction RPFault(SlopeRPFault = SlopeRPFault) "rpfault function for HVDC" annotation(
    Placement(visible = true, transformation(origin = {-90, -23}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (generator convention)";
  Modelica.Blocks.Interfaces.BooleanInput blocked2(start = false) annotation(
    Placement(visible = true, transformation(origin = {-130, -39}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-27, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  connect(switch1.y, ipRefPPu) annotation(
    Line(points = {{121, 27}, {140, 27}}, color = {0, 0, 127}));
  connect(feedback.y, add1.u2) annotation(
    Line(points = {{12, 13}, {19, 13}}, color = {0, 0, 127}));
  connect(product.y, limiter.u) annotation(
    Line(points = {{-43, 13}, {-36, 13}}, color = {0, 0, 127}));
  connect(limiter.y, feedback.u1) annotation(
    Line(points = {{-13, 13}, {-5, 13}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product.u1) annotation(
    Line(points = {{-79, 19}, {-66, 19}}, color = {0, 0, 127}));
  connect(pIAntiWindupVariableLimits.y, switch1.u3) annotation(
    Line(points = {{75, 19}, {98, 19}}, color = {0, 0, 127}));
  connect(add1.y, pIAntiWindupVariableLimits.u) annotation(
    Line(points = {{42, 19}, {52, 19}}, color = {0, 0, 127}));
  connect(zero.y, switch1.u1) annotation(
    Line(points = {{99, 126}, {90, 126}, {90, 35}, {98, 35}}, color = {0, 0, 127}));
  connect(RPFault.rpfault, product.u2) annotation(
    Line(points = {{-79, -23}, {-72, -23}, {-72, 7}, {-66, 7}}, color = {0, 0, 127}));
  connect(feedback.u2, firstOrder2.y) annotation(
    Line(points = {{3, 5}, {3, -67}, {-78, -67}}, color = {0, 0, 127}));
  connect(IpMaxPu, pIAntiWindupVariableLimits.limitMax) annotation(
    Line(points = {{-130, 105}, {45, 105}, {45, 25}, {52, 25}}, color = {0, 0, 127}));
  connect(IpMinPu, pIAntiWindupVariableLimits.limitMin) annotation(
    Line(points = {{-130, -95}, {46, -95}, {46, 13}, {52, 13}}, color = {0, 0, 127}));
  connect(firstOrder2.u, PPu) annotation(
    Line(points = {{-101, -67}, {-130, -67}}, color = {0, 0, 127}));
  connect(blocked1, RPFault.blocked1) annotation(
    Line(points = {{-130, -9}, {-107, -9}, {-107, -20}, {-102, -20}}, color = {255, 0, 255}));
  connect(blocked2, RPFault.blocked2) annotation(
    Line(points = {{-130, -39}, {-107, -39}, {-107, -26}, {-102, -26}}, color = {255, 0, 255}));
  connect(PRefPu, slewRateLimiter.u) annotation(
    Line(points = {{-130, 19}, {-102, 19}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-110, -95}, {130, 105}})),
    Icon(coordinateSystem(grid = {1, 1})));
end BaseActivePowerControl;
