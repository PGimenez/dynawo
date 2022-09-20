within Dynawo.Electrical.Machines.OmegaRef;

model GeneratorSynchronous_INIT

  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends AdditionalIcons.Init;

  type ExcitationPuType = enumeration(NominalStatorVoltageNoLoad "1 pu gives nominal air-gap stator voltage at no load", Kundur "Base voltage as per Kundur, Power System Stability and Control", UserBase "User defined base for the excitation voltage", Nominal "Base for excitation voltage in nominal conditions (PNomAlt, QNom, UNom)");


  //Internal parameters (final value used in the equations) in pu (base UNom, SNom)
  /*For an initialization from internal parameters:
      - Apply the transformation due to the presence of the generator transformer to the internal parameters given by the user
    For an initialization from external parameters:
      - Calculate the internal parameter from the external parameters
      - Apply the transformation due to the presence of a generator transformer in the model to the internal parameters calculated from the external ones*/

 parameter Real mach = 0.4;
 parameter Types.PerUnit RaPPu = 0.003 "Armature resistance in pu";
 parameter Types.PerUnit LdPPu = 0.15 "Direct axis stator leakage in pu";
 parameter Types.PerUnit MdPPu = 1.66 "Direct axis mutual inductance in pu";
 parameter Types.PerUnit LDPPu = 0.16634 "Direct axis damper leakage in pu";
 parameter Types.PerUnit RDPPu = 0.03339 "Direct axis damper resistance in pu";
 parameter Types.PerUnit MrcPPu = 0 "Canay's mutual inductance in pu";
 parameter Types.PerUnit LfPPu = 0.16990 "Excitation winding leakage in pu";
 parameter Types.PerUnit RfPPu = 0.00074 "Excitation winding resistance in pu";
 parameter Types.PerUnit LqPPu = 0.15 "Quadrature axis stator leakage in pu";
 parameter Types.PerUnit MqPPu = 1.61 "Quadrature axis mutual inductance in pu";
 parameter Types.PerUnit LQ1PPu = 0.92815 "Quadrature axis 1st damper leakage in pu";
 parameter Types.PerUnit RQ1PPu = 0.00924 "Quadrature axis 1st damper resistance in pu";
 parameter Types.PerUnit LQ2PPu = 0.12046 "Quadrature axis 2nd damper leakage in pu";
 parameter Types.PerUnit RQ2PPu  = 0.02821 "Quadrature axis 2nd damper resistance in pu";
   parameter Types.VoltageModule UNom = 24 "Nominal voltage in kV";
  parameter Types.ApparentPowerModule SNom = 2220 * mach "Nominal apparent power in MVA";
  parameter Types.ActivePower PNomTurb = 2220 * mach "Nominal active (turbine) power in MW";
  parameter Types.ActivePower PNomAlt = 2220 * mach "Nominal active (alternator) power in MW";
  final parameter Types.ReactivePower QNomAlt = sqrt(SNom * SNom - PNomAlt * PNomAlt) "Nominal reactive (alternator) power in Mvar";
  parameter ExcitationPuType ExcitationPu = ExcitationPuType.NominalStatorVoltageNoLoad "Choice of excitation base voltage";
  parameter Types.Time H = 3.5 "Kinetic constant = kinetic energy / rated power";
  parameter Types.PerUnit DPu = 0 "Damping coefficient of the swing equation in pu";

  // Transformer input parameters
  parameter Types.ApparentPowerModule SnTfo = 2220*mach "Nominal apparent power of the generator transformer in MVA";
  parameter Types.VoltageModule UNomHV = 24 "Nominal voltage on the network side of the transformer in kV";
  parameter Types.VoltageModule UNomLV = 24 "Nominal voltage on the generator side of the transformer in kV";
  parameter Types.VoltageModule UBaseHV = 24 "Base voltage on the network side of the transformer in kV";
  parameter Types.VoltageModule UBaseLV = 24 "Base voltage on the generator side of the transformer in kV";
  parameter Types.PerUnit RTfPu = 0 "Resistance of the generator transformer in pu (base UBaseHV, SnTfo)";
  parameter Types.PerUnit XTfPu = 0 "Reactance of the generator transformer in pu (base UBaseHV, SnTfo)";

  // Mutual inductances saturation parameters, Shackshaft modelisation
  parameter Types.PerUnit md = 0.031 "Parameter for direct axis mutual inductance saturation modelling";
  parameter Types.PerUnit mq = 0.031 "Parameter for quadrature axis mutual inductance saturation modelling";
  parameter Types.PerUnit nd = 6.93 "Parameter for direct axis mutual inductance saturation modelling";
  parameter Types.PerUnit nq = 6.93 "Parameter for quadrature axis mutual inductance saturation modelling";

  final parameter Types.PerUnit RTfoPu = RTfPu * (UNomHV / UBaseHV) ^ 2 * (SNom / SnTfo) "Resistance of the generator transformer in pu (base SNom, UNom)";
  final parameter Types.PerUnit XTfoPu = XTfPu * (UNomHV / UBaseHV) ^ 2 * (SNom / SnTfo) "Reactance of the generator transformer in pu (base SNom, UNom)";
  final parameter Types.PerUnit rTfoPu = if RTfPu > 0.0 or XTfPu > 0.0 then UNomHV / UBaseHV / (UNomLV / UBaseLV) else 1.0 "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";

  // Start values calculated by the initialization model
  parameter Types.PerUnit MdPPuEfd = 0 "Direct axis mutual inductance used to determine the excitation voltage in pu";
  parameter Types.PerUnit MdPPuEfdNom = 0 "Direct axis mutual inductance used to determine the excitation voltage in nominal conditions in pu";
  Types.PerUnit Kuf "Scaling factor for excitation pu voltage";

  Types.ComplexApparentPowerPu sStator0Pu "Start value of complex apparent power at stator side in pu (base SnRef)";
  Types.ComplexVoltagePu uStator0Pu "Start value of complex voltage at stator side in pu (base UNom)";
  Types.ComplexCurrentPu iStator0Pu "Start value of complex current at stator side in pu (base UNom, SnRef)";

  Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal side in pu (base SnRef)";
  Types.ComplexVoltagePu u0Pu "Start value of ckomplex voltage at terminal side (base UNom)";
  Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal side (base UNom, SnRef)";
  Types.ApparentPowerModulePu S0Pu "Start value of apparent power at terminal side in pu (base SNom)";
  Types.CurrentModulePu I0Pu "Start value of current module at terminal side in pu (base UNom, SNom)";

  parameter Types.PerUnit U0Pu = 1 ;
  parameter Types.PerUnit UPhase0 = 0.49 ;
  parameter Types.ActivePowerPu PGen0Pu = 19.98 * mach "Start value of active power at terminal in pu (base SnRef) (generator convention)";
  parameter Types.ReactivePowerPu QGen0Pu = 9.68 * mach  "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";

  Types.Angle Theta0 "Start value of rotor angle: angle between machine rotor frame and port phasor frame";

  Types.PerUnit Ud0Pu "Start value of voltage of direct axis in pu";
  Types.PerUnit Uq0Pu "Start value of voltage of quadrature axis in pu";
  Types.PerUnit Id0Pu "Start value of current of direct axis in pu";
  Types.PerUnit Iq0Pu "Start value of current of quadrature axis in pu";

  Types.PerUnit If0Pu "Start value of current of excitation winding in pu";
  Types.PerUnit Uf0Pu "Start value of exciter voltage in pu (Kundur base)";
  Types.PerUnit Efd0Pu "Start value of input exciter voltage in pu (user-selected base)";

  Types.PerUnit Lambdad0Pu "Start value of flux of direct axis in pu";
  Types.PerUnit Lambdaq0Pu "Start value of flux of quadrature axis in pu";
  Types.PerUnit LambdaD0Pu "Start value of flux of direct axis damper";
  Types.PerUnit Lambdaf0Pu "Start value of flux of excitation winding";
  Types.PerUnit LambdaQ10Pu "Start value of flux of quadrature axis 1st damper";
  Types.PerUnit LambdaQ20Pu "Start value of flux of quadrature axis 2nd damper";

  Types.PerUnit Ce0Pu "Start value of electrical torque in pu (base SNom/omegaNom)";
  Types.PerUnit Cm0Pu "Start value of mechanical torque in pu (base PNomTurb/omegaNom)";
  Types.PerUnit Pm0Pu  "Start value of mechanical power in pu (base PNomTurb/omegaNom)";

  Types.VoltageModulePu UStator0Pu "Start value of stator voltage amplitude in pu (base UNom)";
  Types.CurrentModulePu IStator0Pu "Start value of stator current amplitude in pu (base SnRef)";
  Types.ReactivePowerPu QStator0Pu "Start value of stator reactive power generated in pu (base SnRef)";

  Types.CurrentModulePu IRotor0Pu "Start value of rotor current in pu (base SNom, user-selected base voltage)";
  Types.Angle ThetaInternal0 "Start value of internal angle in rad";

  parameter Types.PerUnit MsalPu = 0.05 "Constant difference between direct and quadrature axis saturated mutual inductances in pu";
  Types.PerUnit MdSat0PPu "Start value of direct axis saturated mutual inductance in pu";
  Types.PerUnit MqSat0PPu "Start value of quadrature axis saturated mutual inductance in pu";
  Types.PerUnit LambdaAirGap0Pu "Start value of total air gap flux in pu";
  Types.PerUnit LambdaAD0Pu "Start value of common flux of direct axis in pu";
  Types.PerUnit LambdaAQ0Pu "Start value of common flux of quadrature axis in pu";
  Types.PerUnit Mds0Pu "Start value of direct axis saturated mutual inductance in the case when the total air gap flux is aligned on the direct axis in pu";
  Types.PerUnit Mqs0Pu "Start value of quadrature axis saturated mutual inductance in the case when the total air gap flux is aligned on the quadrature axis in pu";
  Types.PerUnit Cos2Eta0 "Start value of the common flux of direct axis contribution to the total air gap flux in pu";
  Types.PerUnit Sin2Eta0 "Start value of the common flux of quadrature axis contribution to the total air gap flux in pu";
  Types.PerUnit Mi0Pu "Start value of intermediate axis saturated mutual inductance in pu";

  Types.PerUnit P0Pu;
  Types.PerUnit Q0Pu;

equation

  LambdaAD0Pu = MdSat0PPu * (Id0Pu + If0Pu );
  LambdaAQ0Pu = MqSat0PPu * (Iq0Pu);
  LambdaAirGap0Pu = sqrt(LambdaAD0Pu ^ 2 + LambdaAQ0Pu ^ 2);
  Mds0Pu = MdPPu / (1 + md * LambdaAirGap0Pu ^ nd);
  Mqs0Pu = MqPPu / (1 + mq * LambdaAirGap0Pu ^ nq);
  Cos2Eta0 = LambdaAD0Pu ^ 2 / LambdaAirGap0Pu ^ 2;
  Sin2Eta0 = LambdaAQ0Pu ^ 2 / LambdaAirGap0Pu ^ 2;
  Mi0Pu = Mds0Pu * Cos2Eta0 + Mqs0Pu * Sin2Eta0;
  MdSat0PPu = Mi0Pu + MsalPu * Sin2Eta0;
  MqSat0PPu = Mi0Pu - MsalPu * Cos2Eta0;

  // Park's transformations
  u0Pu.re = sin(Theta0) * Ud0Pu + cos(Theta0) * Uq0Pu;
  u0Pu.im = (-cos(Theta0) * Ud0Pu) + sin(Theta0) * Uq0Pu;
  i0Pu.re * SystemBase.SnRef / SNom = sin(Theta0) * Id0Pu + cos(Theta0) * Iq0Pu;
  i0Pu.im * SystemBase.SnRef / SNom = (-cos(Theta0) * Id0Pu) + sin(Theta0) * Iq0Pu;

  // Apparent power, voltage and current at stator side in pu (base SnRef, UNom)
  uStator0Pu = 1 / rTfoPu * (u0Pu - i0Pu * Complex(RTfoPu, XTfoPu) * SystemBase.SnRef / SNom);
  iStator0Pu = rTfoPu * i0Pu ;
  sStator0Pu = uStator0Pu * ComplexMath.conj(iStator0Pu);

  // Flux linkages
  Lambdad0Pu  = (MdSat0PPu + (LdPPu + XTfoPu)) * Id0Pu +          MdSat0PPu          * If0Pu;
  Lambdaf0Pu  =           MdSat0PPu            * Id0Pu + (MdSat0PPu + LfPPu + MrcPPu)* If0Pu;
  LambdaD0Pu  =           MdSat0PPu            * Id0Pu +     (MdSat0PPu + MrcPPu)    * If0Pu;
  LambdaQ10Pu =           MqSat0PPu            * Iq0Pu;
  LambdaQ20Pu =           MqSat0PPu            * Iq0Pu;
  Lambdaq0Pu = (MqSat0PPu + LqPPu + XTfoPu) * Iq0Pu ;
  // Equivalent circuit equations in Park's coordinates
  Ud0Pu = (RaPPu + RTfoPu) * Id0Pu - SystemBase.omega0Pu * Lambdaq0Pu;
  Uq0Pu = (RaPPu + RTfoPu) * Iq0Pu + SystemBase.omega0Pu * Lambdad0Pu;
  Uf0Pu = RfPPu * If0Pu;
  Efd0Pu = Uf0Pu/(Kuf*rTfoPu);

  // Mechanical equations
  Ce0Pu = Lambdaq0Pu*Id0Pu - Lambdad0Pu*Iq0Pu;
  Cm0Pu = Ce0Pu/PNomTurb*SNom;
  Pm0Pu = Cm0Pu*SystemBase.omega0Pu;

  // Output variables for external controlers
  UStator0Pu = ComplexMath.'abs' (uStator0Pu);
  IStator0Pu = rTfoPu * I0Pu *SNom/SystemBase.SnRef;
  QStator0Pu = - ComplexMath.imag(sStator0Pu);
  Kuf = RfPPu / MdPPu;
  IRotor0Pu = RfPPu / (Kuf * rTfoPu) * If0Pu;
  ThetaInternal0 = ComplexMath.arg(Complex(Uq0Pu, Ud0Pu));
  S0Pu = ComplexMath.'abs'(s0Pu)*SystemBase.SnRef/SNom;
  I0Pu = ComplexMath.'abs'(i0Pu)*SystemBase.SnRef/SNom;
  P0Pu = -PGen0Pu;
  Q0Pu = -QGen0Pu;
  u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
  s0Pu = Complex(P0Pu, Q0Pu);
  s0Pu = u0Pu * ComplexMath.conj(i0Pu);

end GeneratorSynchronous_INIT;
