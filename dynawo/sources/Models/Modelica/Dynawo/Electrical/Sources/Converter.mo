within Dynawo.Electrical.Sources;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model Converter "Converter Model for Grid Forming and Grid Following applications"

/*
  Equivalent circuit and conventions:
                       __________
IdcSourcePu     IdcPu |          |iConvPu                           iPccPu
-------->-------->----|          |-->-----(Rfilter,Lfilter)---------->--(Rtransformer,Ltransformer)---(terminal)
              |       |          |                                |
UdcPu       (Cdc)     |  DC/AC   |  uConvPu         uFilterPu (Cfilter)                      uPccPu
              |       |          |                                |
              |       |          |                                |
----------------------|__________|---------------------------------------------------------------------

*/
  import Modelica;
  import Modelica.Math;
  import Modelica.ComplexMath;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffGenerator;

  Connectors.ACPower terminal (V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the converter to the grid" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {0, -105}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  parameter Types.PerUnit Rfilter "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit Lfilter "Filter inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Cfilter "Filter capacitance in pu (base UNom, SNom)";
  parameter Types.PerUnit Rtransformer "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit Ltransformer "Transformer inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Cdc "DC capacitance in pu (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom "Apparent power module reference for the converter";

  Modelica.Blocks.Interfaces.RealInput IdcSourcePu(start = IdcSource0Pu) "DC Current generated by the DC current source in pu (base UNom, SNom)"  annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = UdConv0Pu) "d-axis modulated voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, 30}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = UqConv0Pu) "q-axis modulated voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -30}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame" annotation(
    Placement(visible = true, transformation(origin = {-58, 50}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter angular frequency in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -50}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc0Pu) "DC Voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {0, 63}, extent = {{-3, -3}, {3, 3}}, rotation = -90), iconTransformation(origin = { -105, -70}, extent = {{5, -5}, {-5, 5}}, rotation = 180)));

  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {67, 60}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = 0) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {67, -60}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = IdConv0Pu) "d-axis current created by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, 20}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 30}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "q-axis current created by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, -20}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -30}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idPccPu(start = IdPcc0Pu) "d-axis current at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, 40}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 60}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqPccPu(start = IqPcc0Pu) "q-axis current at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, -40}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -60}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UdcPu(start = Udc0Pu) "DC Voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {67, 0}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  Types.PerUnit udConvPu(start = UdConv0Pu) "d-axis modulated voltage created by the converter in pu (base UNom)";
  Types.PerUnit uqConvPu(start = UqConv0Pu) "q-axis modulated voltage created by the converter in pu (base UNom)";
  Types.PerUnit udPccPu(start = UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)";
  Types.PerUnit uqPccPu(start = UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)";
  Types.PerUnit IdcPu(start = IdcSource0Pu) "DC Current entering the converter in pu (base UNom, SNom)";
  Types.PerUnit IConvPu(start = sqrt(IdConv0Pu * IdConv0Pu + IqConv0Pu * IqConv0Pu)) "Module of the current injected by the converter in pu (base UNom, SNom)";
  Types.PerUnit PGenPu(start = (UdPcc0Pu * IdPcc0Pu + UqPcc0Pu * IqPcc0Pu) * SNom / SystemBase.SnRef) "Active power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  Types.PerUnit QGenPu(start = (UqPcc0Pu * IdPcc0Pu - UdPcc0Pu * IqPcc0Pu) * SNom / SystemBase.SnRef) "Reactive power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";

  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in pu (base UNom)";
  parameter Types.Angle Theta0 "Start value of the phase shift between the converter's rotating frame and the grid rotating frame";
  parameter Types.PerUnit UdConv0Pu "Start value of the d-axis modulated voltage reference created by the converter in pu (base UNom)";
  parameter Types.PerUnit UdFilter0Pu "Start value of the d-axis voltage at the capacitor in pu (base UNom)";
  parameter Types.PerUnit UdPcc0Pu "Start value of the d-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of the d-axis current created by the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu "Start value of the d-axis current at the PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UqConv0Pu "Start value of the q-axis modulated voltage reference created by the converter in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of the q-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis current created by the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of the q-axis current at the PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdcSource0Pu "Start value of the DC source current in pu (base SnRefConverter)";
  parameter Types.PerUnit Udc0Pu "Start value of the DC voltage in pu (base Unom)";

equation
  if running.value then
    /* DQ reference frame change from network reference to converter reference and pu base change */
    [udPccPu; uqPccPu] = [cos(theta), sin(theta); -sin(theta), cos(theta)] * [terminal.V.re; terminal.V.im];
    [idPccPu; iqPccPu] = - [cos(theta), sin(theta); -sin(theta), cos(theta)] * [terminal.i.re; terminal.i.im] * SystemBase.SnRef / SNom;

    /* RL Transformer */
    Ltransformer / SystemBase.omegaNom * der(idPccPu) = udFilterPu - Rtransformer * idPccPu + omegaPu * Ltransformer * iqPccPu - udPccPu;
    Ltransformer / SystemBase.omegaNom * der(iqPccPu) = uqFilterPu - Rtransformer * iqPccPu - omegaPu * Ltransformer * idPccPu - uqPccPu;

    /* RLC Filter */
    Lfilter / SystemBase.omegaNom * der(idConvPu) = udConvPu - Rfilter * idConvPu + omegaPu * Lfilter * iqConvPu - udFilterPu;
    Lfilter / SystemBase.omegaNom * der(iqConvPu) = uqConvPu - Rfilter * iqConvPu - omegaPu * Lfilter * idConvPu - uqFilterPu;
    Cfilter / SystemBase.omegaNom * der(udFilterPu) = idConvPu + omegaPu * Cfilter * uqFilterPu - idPccPu;
    Cfilter / SystemBase.omegaNom * der(uqFilterPu) = iqConvPu - omegaPu * Cfilter * udFilterPu - iqPccPu;
    IConvPu = sqrt (idConvPu * idConvPu + iqConvPu * iqConvPu);

    /* DC Side */
    Cdc * der(UdcPu) = IdcSourcePu - IdcPu;

    /* AC Voltage Source */
    udConvPu = udConvRefPu * UdcPu / UdcRefPu;
    uqConvPu = uqConvRefPu * UdcPu / UdcRefPu;

    /* Power Conservation */
    udConvPu * idConvPu + uqConvPu * iqConvPu = UdcPu * IdcPu;

    /* Power Calculation */
    PGenPu = (udPccPu * idPccPu + uqPccPu * iqPccPu) * SNom / SystemBase.SnRef;
    QGenPu = (uqPccPu * idPccPu - udPccPu * iqPccPu) * SNom / SystemBase.SnRef;
  else
    udPccPu = 0;
    uqPccPu = 0;
    terminal.i.re = 0;
    terminal.i.im = 0;
    idPccPu = 0;
    iqPccPu = 0;
    idConvPu = 0;
    iqConvPu = 0;
    udFilterPu = 0;
    uqFilterPu = 0;
    IConvPu = 0;
    IdcPu = 0;
    udConvPu = 0;
    uqConvPu = 0;
    UdcPu = 0;
    PGenPu = 0;
    QGenPu = 0;
  end if;

  annotation(preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-133, -85.5}, extent = {{-25, 5.5}, {8, -4.5}}, textString = "omegaPu"), Text(origin = {-133, 4.5}, extent = {{-35, 14.5}, {8, -4.5}}, textString = "IdcSourcePu"), Text(origin = {-133, 44.5}, extent = {{-39, 12.5}, {8, -4.5}}, textString = "udConvRefPu"), Text(origin = {-133, 94.5}, extent = {{-17, 5.5}, {8, -4.5}}, textString = "theta"), Text(origin = {-131, -66.5}, extent = {{-43, 16.5}, {8, -4.5}}, textString = "UdcRefPu"), Text(origin = {119, 100.5}, extent = {{-8, 4.5}, {38, -12.5}}, textString = "udFilterPu"), Text(origin = {-133, -35.5}, extent = {{-41, 14.5}, {8, -4.5}}, textString = "uqConvRefPu"), Text(origin = {119, 68.5}, extent = {{-8, 4.5}, {25, -9.5}}, textString = "idPccPu"), Text(origin = {117, 10.5}, extent = {{-8, 4.5}, {38, -16.5}}, textString = "UdcPu"), Text(origin = {118, 37.5}, extent = {{-8, 4.5}, {25, -9.5}}, textString = "idConvPu"), Text(origin = {118, -21.5}, extent = {{-8, 4.5}, {30, -10.5}}, textString = "iqConvPu"), Text(origin = {118, -51.5}, extent = {{-8, 4.5}, {24, -12.5}}, textString = "iqPccPu"), Text(origin = {118, -78.5}, extent = {{-8, 4.5}, {35, -16.5}}, textString = "uqFilterPu"), Text(origin = {17, -107.5}, extent = {{-8, 4.5}, {14, -7.5}}, textString = "ACPower"), Text(origin = {5, 6}, extent = {{-95, 56}, {90, -68}}, textString = "Converter")}));

end Converter;
