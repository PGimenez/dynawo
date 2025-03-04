within Dynawo.NonElectrical.Blocks.Continuous;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

block AbsLimRateLimFirstOrderFreeze "First order filter with absolute and rate limits, and a freezing flag"
  import Modelica;
  import Dynawo.Types;

  extends Modelica.Blocks.Icons.Block;

  parameter Types.PerUnit DyMax "Maximun rising slew rate of output";
  parameter Types.PerUnit DyMin = -DyMax "Maximun falling slew rate of output";
  parameter Types.Time tI "Filter time constant in s";
  parameter Types.PerUnit YMax "Upper limit of output";
  parameter Types.PerUnit YMin = -YMax "Lower limit of output";

  Modelica.Blocks.Interfaces.RealInput u "Input signal connector" annotation(
    Placement(visible = true, transformation(origin = {-220, 1.77636e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput y(start = Y0) "Output signal connector" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gain(k = 1 / tI) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = DyMax, uMin = DyMin) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Y0) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = YMax, uMin = YMin) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanInput freeze annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit Y0 "Initial value of output";

equation
  connect(gain.y, limiter.u) annotation(
    Line(points = {{-99, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(u, feedback.u1) annotation(
    Line(points = {{-220, 0}, {-168, 0}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-151, 0}, {-122, 0}}, color = {0, 0, 127}));
  connect(limiter1.y, y) annotation(
    Line(points = {{121, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(freeze, switch1.u2) annotation(
    Line(points = {{0, 120}, {0, 0}, {18, 0}}, color = {255, 0, 255}));
  connect(const.y, switch1.u1) annotation(
    Line(points = {{-39, -40}, {0, -40}, {0, -8}, {18, -8}}, color = {0, 0, 127}));
  connect(switch1.y, integrator.u) annotation(
    Line(points = {{42, 0}, {58, 0}}, color = {0, 0, 127}));
  connect(integrator.y, limiter1.u) annotation(
    Line(points = {{82, 0}, {98, 0}}, color = {0, 0, 127}));
  connect(limiter1.y, feedback.u2) annotation(
    Line(points = {{121, 0}, {180, 0}, {180, -60}, {-160, -60}, {-160, -8}}, color = {0, 0, 127}));
  connect(limiter.y, switch1.u3) annotation(
    Line(points = {{-38, 0}, {-20, 0}, {-20, 8}, {18, 8}}, color = {0, 0, 127}));

  annotation(
  preferredView = "diagram",
  Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Line(origin = {-40, 1.06}, points = {{-40, -121.057}, {20, 118.943}}), Line(origin = {40, 1.05741}, points = {{-80, -121.057}, {-40, -121.057}, {20, 118.943}, {60, 118.943}}), Rectangle(lineColor = {0, 0, 127}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {12, 28}, extent = {{-44, 34}, {26, -16}}, textString = "1"), Text(origin = {2, -44}, extent = {{-60, 22}, {60, -22}}, textString = "1 + sT"), Line(origin = {4, 0}, points = {{-86, 0}, {86, 0}})}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end AbsLimRateLimFirstOrderFreeze;
