within Dynawo.Electrical.Controls.Converters;

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

model GridFormingControl_INIT "Initialization model for the grid forming control"

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends AdditionalIcons.Init;

  parameter Types.PerUnit Lfilter "Filter inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Cfilter "Filter capacitance in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealOutput PRef0Pu;
  Modelica.Blocks.Interfaces.RealOutput QRef0Pu;
  Modelica.Blocks.Interfaces.RealOutput IdcSourceRef0Pu;
  Modelica.Blocks.Interfaces.RealInput IdConv0Pu;
  Modelica.Blocks.Interfaces.RealInput IqConv0Pu;
  Modelica.Blocks.Interfaces.RealInput IdPcc0Pu;
  Modelica.Blocks.Interfaces.RealInput IqPcc0Pu;
  Modelica.Blocks.Interfaces.RealOutput UdFilter0Pu;
  Modelica.Blocks.Interfaces.RealInput UdConv0Pu;
  Modelica.Blocks.Interfaces.RealInput UqConv0Pu;
  Modelica.Blocks.Interfaces.RealInput Theta0;
  Modelica.Blocks.Interfaces.RealInput IdcSource0Pu;
  Modelica.Blocks.Interfaces.RealOutput UdcSource0Pu;

  equation

  PRef0Pu = UdFilter0Pu * IdPcc0Pu;
  PRef0Pu = IdcSourceRef0Pu * UdcSource0Pu;
  QRef0Pu =  - UdFilter0Pu * IqPcc0Pu;
  UdcSource0Pu = UdFilter0Pu;

annotation(preferredView = "text");

end GridFormingControl_INIT;
