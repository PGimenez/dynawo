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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model IntegratorVariableLimits "Integrator with limited value of output (variable limits) and freeze"
  import Modelica;
  import Dynawo.Types;

  extends Modelica.Blocks.Interfaces.SISO(y(start = Y0));

  parameter Boolean DefaultLimitMax = true "If limitMin > limitMax : if true, y = limitMax, if false, y = limitMin";
  parameter Types.PerUnit K = 1 "Integrator gain";
  parameter Types.Time tDer = 1e-3 "Time constant of derivative filter for limits in s";
  parameter Real TolInput = 1e-5 "Tolerance on limit crossing for integrator input";
  parameter Real TolOutput = 1e-5 "Tolerance on limit crossing for integrator output";

  Modelica.Blocks.Interfaces.RealInput limitMax "Connector of Real input signal used as maximum of output y" annotation(
    Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput limitMin "Connector of Real input signal used as minimum of output y" annotation(
    Placement(transformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Continuous.Derivative derivative(T = tDer, x_start = LimitMax0) annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative1(T = tDer, x_start = LimitMin0) annotation(
    Placement(visible = true, transformation(origin = {-70, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Real derLimitMax "Filtered derivative of upper limit of output";
  Real derLimitMin "Filtered derivative of lower limit of output";

  parameter Real LimitMax0 "Initial value of upper limit";
  parameter Real LimitMin0 "Initial value of lower limit";
  parameter Real Y0 = 0 "Initial or guess value of output (must be in the limits limitMin .. limitMax)";

protected
  Types.PerUnit kFreezeMax "Freeze coefficient for upper limit";
  Types.PerUnit kFreezeMin "Freeze coefficient for lower limit";
  Real v "Integrator input";
  Real w(start = Y0) "Non-limited integrator output";

equation
  v = K * u;

  derLimitMax = derivative.y;
  derLimitMin = derivative1.y;

  kFreezeMax = (1 / 4) * (1 + tanh((w - limitMax) / TolOutput)) * (1 + tanh((v - derLimitMax) / TolInput));
  kFreezeMin = (1 / 4) * (1 + tanh((limitMin - w) / TolOutput)) * (1 + tanh((derLimitMin - v) / TolInput));

  der(w) = derLimitMax * kFreezeMax + derLimitMin * kFreezeMin + v * (1 - kFreezeMax - kFreezeMin);

  if limitMin > limitMax and DefaultLimitMax then
    y = limitMax;
  elseif limitMin > limitMax then
    y = limitMin;
  elseif w > limitMax then
    y = limitMax;
  elseif w < limitMin then
    y = limitMin;
  else
    y = w;
  end if;

  connect(limitMax, derivative.u) annotation(
    Line(points = {{-120, 80}, {-82, 80}}, color = {0, 0, 127}));
  connect(limitMin, derivative1.u) annotation(
    Line(points = {{-120, -80}, {-82, -80}}, color = {0, 0, 127}));

  annotation(preferredView = "text",
  Documentation(info= "<html><head></head><body><p>
This blocks computes <strong>w</strong> as integral
of the input <strong>u</strong> multiplied by the gain <em>K</em>, with v = K * u<em>.</em></p>
<p>If the integral reaches a given upper limit <b>limitMax</b> or lower limit&nbsp;<b>limitMin</b>, the
integration is halted and only restarted if the input drives
the integral away from the bounds.</p><p>This freeze is imposed through two coefficients <b>kFreezeMax</b> and <b>kFreezeMin</b>, each defined by a continuous expression involving the hyperbolic tangent, the integrator input <b>v</b>, the integrator output <b>w</b>, the limit <b>limitMax</b> or <b>limitMin</b> and its filtered derivative <b>derLimitMax</b> or <b>derLimitMin</b>.</p><p>w &gt; limitMax and v &gt; derLimitMax =&gt; kFreezeMax = 1, kFreezeMin = 0 =&gt; der(w) = derLimitMax</p><p>w &lt; limitMin and v &lt; derLimitMin =&gt; kFreezeMax = 0, kFreezeMin = 1 =&gt; der(w) = derLimitMin</p><p>limitMax &gt; w &gt; limitMin or derLimitMax &gt; v &gt; derLimitMin =&gt; kFreezeMax = kFreezeMin = 1 =&gt; der(w) = v</p><p>The parameters <i>TolInput</i> and <i>TolOutput</i> determine the width of the transition zone from one domain to another.</p>
<p>The output <strong>y</strong> is the result of the limitation of <b>w</b> by both variable limits.</p>
<p>If the \"upper\" limit is smaller than the \"lower\" one, the output <i>y</i> is ruled by the parameter <i>DefaultLimitMax</i>: <i>y</i> is equal to either&nbsp;<b>limitMax&nbsp;</b>or&nbsp;<b>limitMin</b>.</p>
<p>The integrator is initialized with the value <em>Y0</em>.</p>
</body></html>"),
  Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Line(points={{-80,78},{-80,-90}}, color={192,192,192}),
        Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}),
        Line(points={{-90,-80},{82,-80}}, color={192,192,192}),
        Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{90, -80}, {68, -72}, {68, -88}, {90, -80}}),
        Line(points = {{-80, -80}, {20, 20}, {80, 20}}, color = {0, 0, 127}),
        Text(lineColor = {192, 192, 192}, extent = {{0, -10}, {60, -70}}, textString = "I"),
        Text(
          extent={{-150,-150},{150,-110}},
          textString="K=%K"),
        Line(
          points={{60,-100},{60,-80}},
          color={255,0,255},
          pattern=LinePattern.Dot)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle( lineColor={0,0,255}, extent={{-60,60},{60,-60}}),
        Text(
          extent={{-54,46},{-4,-48}},
          textString="lim"),
        Line(points={{-100,0},{-60,0}}, color={0,0,255}),
        Line(points={{60,0},{100,0}}, color={0,0,255}),
        Text(
          extent={{-8,60},{60,2}},
          textString="k"),
        Text(
          extent={{-8,-2},{60,-60}},
          textString="s"),
        Line(points={{4,0},{46,0}})}));
end IntegratorVariableLimits;
