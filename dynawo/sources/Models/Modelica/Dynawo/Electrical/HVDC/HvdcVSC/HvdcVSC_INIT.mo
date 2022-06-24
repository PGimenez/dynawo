within Dynawo.Electrical.HVDC.HvdcVSC;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model HvdcVSC_INIT "Initialisation model for the HVDC VSC model"
  import Modelica;
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;

  parameter Types.ApparentPowerModule SNom "Injector nominal apparent power in MVA";
  parameter Types.PerUnit Lambda "Lambda coefficient for the QRefUPu calculation";
  parameter Types.PerUnit RdcPu "DC line resistance in pu (base UNom, SnRef)";
  parameter Real modeU1Set "Set value of the real assessing the mode of the control at terminal 1: 1 if U mode, 0 if Q mode";
  parameter Real modeU2Set "Set value of the real assessing the mode of the control at terminal 2: 1 if U mode, 0 if Q mode";

  Types.PerUnit Ip10Pu "Start value of active current at terminal 1 in pu (base SNom)";
  Types.PerUnit Iq10Pu "Start value of reactive current at terminal 1 in pu (base SNom)";
  Types.PerUnit Ip20Pu "Start value of active current at terminal 2 in pu (base SNom)";
  Types.PerUnit Iq20Pu "Start value of reactive current at terminal 2 in pu (base SNom)";
  Types.PerUnit Udc10Pu "Start value of dc voltage at terminal 1 in pu (base UdcNom)";
  Modelica.Blocks.Interfaces.RealOutput Udc20Pu "Start value of dc voltage at terminal 2 in pu (base UdcNom)";
  Modelica.Blocks.Interfaces.RealOutput URef10Pu "Start value of the voltage reference for the side 1 of the HVDC link in pu (base UNom)";
  Modelica.Blocks.Interfaces.RealOutput URef20Pu "Start value of the voltage reference for the side 1 of the HVDC link in pu (base UNom)";
  Modelica.Blocks.Interfaces.RealOutput QRef10Pu "Start value of reactive power reference at terminal 1 in pu (base SNom) (generator convention)";
  Modelica.Blocks.Interfaces.RealOutput QRef20Pu "Start value of reactive power reference at terminal 2 in pu (base SNom) (generator convention)";
  Modelica.Blocks.Interfaces.RealOutput PRef0Pu "Start value of reactive power reference in pu (base SNom) (generator convention)";
  Modelica.Blocks.Interfaces.RealOutput modeU10 "Start value of the real assessing the mode of the control at terminal 1: 1 if U mode, 0 if Q mode";
  Modelica.Blocks.Interfaces.RealOutput modeU20 "Start value of the real assessing the mode of the control at terminal 2: 1 if U mode, 0 if Q mode";

equation
  P10Pu = - U10Pu * Ip10Pu * (SNom/SystemBase.SnRef);
  Q10Pu = U10Pu * Iq10Pu * (SNom/SystemBase.SnRef);
  P20Pu = - U20Pu * Ip20Pu * (SNom/SystemBase.SnRef);
  Q20Pu = U20Pu * Iq20Pu * (SNom/SystemBase.SnRef);
  Udc10Pu = 1 + RdcPu * P10Pu;
  Udc20Pu = 1;
  QRef10Pu = - Q10Pu * (SystemBase.SnRef/SNom);
  QRef20Pu = - Q20Pu * (SystemBase.SnRef/SNom);
  PRef0Pu = - P10Pu * (SystemBase.SnRef/SNom);
  URef10Pu = U10Pu - Lambda * Q10Pu * (SystemBase.SnRef/SNom);
  URef20Pu = U20Pu - Lambda * Q20Pu * (SystemBase.SnRef/SNom);
  modeU10 = modeU1Set;
  modeU20 = modeU2Set;

  annotation(preferredView = "text");
end HvdcVSC_INIT;
