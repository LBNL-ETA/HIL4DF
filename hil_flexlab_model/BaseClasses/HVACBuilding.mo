within hil_flexlab_model.BaseClasses;
partial model HVACBuilding
  "Partial model that contains the HVAC and building model"

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  final parameter Modelica.Units.SI.Volume VRooCor=flo.VRooCor
    "Room volume corridor";
  final parameter Modelica.Units.SI.Volume VRooSou=flo.VRooSou
    "Room volume south";
  final parameter Modelica.Units.SI.Volume VRooNor=flo.VRooNor
    "Room volume north";
  final parameter Modelica.Units.SI.Volume VRooEas=flo.VRooEas
    "Room volume east";
  final parameter Modelica.Units.SI.Volume VRooWes=flo.VRooWes
    "Room volume west";

  final parameter Modelica.Units.SI.Area AFloCor=flo.AFloCor
    "Floor area corridor";
  final parameter Modelica.Units.SI.Area AFloSou=flo.AFloSou "Floor area south";
  final parameter Modelica.Units.SI.Area AFloNor=flo.AFloNor "Floor area north";
  final parameter Modelica.Units.SI.Area AFloEas=flo.AFloEas "Floor area east";
  final parameter Modelica.Units.SI.Area AFloWes=flo.AFloWes "Floor area west";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";

  parameter Modelica.Units.SI.MassFlowRate mCor_flow_nominal
    "Design mass flow rate core";
  parameter Modelica.Units.SI.MassFlowRate mSou_flow_nominal
    "Design mass flow rate south";
  parameter Modelica.Units.SI.MassFlowRate mEas_flow_nominal
    "Design mass flow rate east";
  parameter Modelica.Units.SI.MassFlowRate mNor_flow_nominal
    "Design mass flow rate north";
  parameter Modelica.Units.SI.MassFlowRate mWes_flow_nominal
    "Design mass flow rate west";

  final parameter Modelica.Units.SI.MassFlowRate
     mCooVAV_flow_nominal[3]={
      mSou_flow_nominal,mNor_flow_nominal,
      mCor_flow_nominal} "Design mass flow rate of each zone";
  /*mCooVAV_flow_nominal[3]={
      mSou_flow_nominal,mEas_flow_nominal,mNor_flow_nominal,mWes_flow_nominal,
      mCor_flow_nominal} */

  parameter Modelica.Units.SI.Temperature THeaWatInl_nominal(displayUnit="degC")=
       45 + 273.15 "Reheat coil nominal inlet water temperature";

  replaceable Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC hvac
    constrainedby Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC(
    redeclare final package MediumA = MediumA,
    redeclare final package MediumW = MediumW,
    final VRoo={VRooSou,VRooNor,VRooCor},
    final AFlo={AFloSou,AFloNor,AFloCor},
    final mCooVAV_flow_nominal=mCooVAV_flow_nominal,
    final THeaWatInl_nominal=THeaWatInl_nominal) "HVAC system"
    annotation (Placement(transformation(extent={{-46,-28},{42,22}})));
    //final VRoo={VRooSou,VRooEas,VRooNor,VRooWes,VRooCor},
    //final AFlo={AFloSou,AFloEas,AFloNor,AFloWes,AFloCor},
  replaceable
  Buildings.Examples.VAVReheat.BaseClasses.PartialFloor flo
    constrainedby Buildings.Examples.VAVReheat.BaseClasses.PartialFloor(
      redeclare final package Medium = MediumA)
    "Building"
    annotation (Placement(transformation(extent={{20,40},{90,80}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
   filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
      computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=THeaWatInl_nominal,
    nPorts=1) "Sink for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-38,-80})));
  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=THeaWatInl_nominal,
    nPorts=1) "Source for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,-80})));
  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=279.15,
    nPorts=1) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-80})));
  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=279.15,
    nPorts=1) "Source for cooling coil loop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-80})));
  Buildings.Fluid.Sources.Boundary_pT souHeaTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=THeaWatInl_nominal,
    nPorts=1) "Source for heating of terminal boxes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,-80})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000,
    T=THeaWatInl_nominal,
    nPorts=1) "Source for heating of terminal boxes" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-80})));
equation
  connect(souHea.ports[1], hvac.portHeaCoiSup) annotation (Line(points={{-70,
          -70},{-70,-40},{-21.25,-40},{-21.25,-28}}, color={0,127,255}));
  connect(sinHea.ports[1], hvac.portHeaCoiRet) annotation (Line(points={{-38,
          -70},{-38,-42},{-13,-42},{-13,-28}}, color={0,127,255}));
  connect(hvac.portHeaTerSup, souHeaTer.ports[1]) annotation (Line(points={{
          17.25,-28},{18,-28},{18,-48},{50,-48},{50,-70}}, color={0,127,255}));
  connect(hvac.portHeaTerRet, sinHeaTer.ports[1]) annotation (Line(points={{
          25.5,-28},{26,-28},{26,-46},{80,-46},{80,-70}}, color={0,127,255}));
  connect(weaDat.weaBus, hvac.weaBus) annotation (Line(
      points={{-70,10},{-56,10},{-56,11.4444},{-40.225,11.4444}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, flo.weaBus) annotation (Line(
      points={{-70,10},{-66,10},{-66,86.1538},{64.1304,86.1538}},
      color={255,204,51},
      thickness=0.5));
  connect(souCoo.ports[1], hvac.portCooCoiSup) annotation (Line(points={{-10,
          -70},{-10,-46},{-2,-46},{-2,-28}}, color={0,127,255}));
  connect(sinCoo.ports[1], hvac.portCooCoiRet) annotation (Line(points={{20,-70},
          {20,-54},{6.25,-54},{6.25,-28}},
                                     color={0,127,255}));
  connect(hvac.port_supAir[1], flo.portsNor[1]) annotation (Line(points={{42.275,
          19.2222},{60,19.2222},{60,71.3846},{46.3261,71.3846}},
                                                       color={0,127,255}));
  connect(hvac.port_supAir[2], flo.portsCor[1]) annotation (Line(points={{42.275,
          19.2222},{54,19.2222},{54,60.9231},{46.3261,60.9231}}, color={0,127,255}));
  connect(hvac.port_supAir[3], flo.portsSou[1]) annotation (Line(points={{42.275,
          19.2222},{54,19.2222},{54,48.6154},{46.3261,48.6154}}, color={0,127,255}));
  connect(hvac.port_retAir[1], flo.portsNor[2]) annotation (Line(points={{42.275,
          -4.38889},{70,-4.38889},{70,71.3846},{47.8478,71.3846}},
                                                         color={0,127,255}));
  connect(hvac.port_retAir[2], flo.portsCor[2]) annotation (Line(points={{42.275,
          -4.38889},{74,-4.38889},{74,60.9231},{47.8478,60.9231}}, color={0,127,
          255}));
  connect(hvac.port_retAir[3], flo.portsSou[2]) annotation (Line(points={{42.275,
          -4.38889},{78,-4.38889},{78,48.6154},{47.8478,48.6154}}, color={0,127,
          255}));
  annotation (
    Documentation(info="<html>
<p>
Partial model that contains an HVAC system connected to a building
with five conditioned thermal zones.
</p>
</html>", revisions="<html>
<ul>
<li>
December 20, 2021, by Michael Wetter:<br/>
Changed parameter declarations for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2829\">issue #2829</a>.
</li>
<li>
November 17, 2021, by David Blum:<br/>
Changed chilled water supply temperature from 12 C to 6 C.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2763\">issue #2763</a>.
</li>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HVACBuilding;
