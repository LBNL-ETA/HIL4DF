within hil_flexlab_model.Examples.BaseClasses;
model Zone "Model of a thermal zone"
  extends Modelica.Blocks.Icons.Block;
  package Medium=Buildings.Media.Air
    "Medium model";
  parameter String zoneName=""
    "Name of the thermal zone";
  //parameter Modelica.Units.SI.MassFlowRate mOut_flow=0.3/3600*zon.V*Buildings.Media.Air.dStp
    //"Outside air mass flow rate with 0.3 ACH";
  Modelica.Blocks.Sources.Constant qConGai_flow(
    k=0)
    "Convective heat gain"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(
    k=0)
    "Radiative heat gain"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    "Multiplex to combine signals into a vector"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    redeclare package Medium=Medium,
    zoneName=zoneName,
    nPorts=5)
    "Thermal zone (core zone of the office building with 5 zones)"
    annotation (Placement(transformation(extent={{-18,6},{22,46}})));
  Buildings.Fluid.FixedResistances.PressureDrop duc(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=false,
    dp_nominal=100,
    m_flow_nominal=47*6/3600*1.2)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-30,-60},{-50,-40}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData bou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=1) "Mass flow rate boundary condition"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Fluid.Sources.Boundary_pT freshAir(redeclare package Medium =
        Medium, nPorts=1) "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(
    k=0)
    "Latent heat gain"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Fluid.Sensors.RelativeHumidity senRelHum(redeclare package Medium
      = Medium, warnAboutOnePortConnection=false)
    "Relative humidity in the room as computed by Modelica"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
  Modelica.Blocks.Interfaces.RealOutput TAir(
    final unit="K",
    displayUnit="degC")
    "Air temperature of the zone"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.RealOutput TRad(
    final unit="K",
    displayUnit="degC")
    "Radiative temperature of the zone"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput phi(
    final unit="1")
    "Relative humidity of zone air"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  Modelica.Blocks.Interfaces.RealInput m_flow_in
    annotation (Placement(transformation(extent={{-142,-94},{-102,-54}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-114,76},{-94,96}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{94,78},{114,98}})));
equation
  connect(qRadGai_flow.y,multiplex3_1.u1[1])
    annotation (Line(points={{-69,70},{-62,70},{-62,47},{-52,47}},color={0,0,127},smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1.u2[1])
    annotation (Line(points={{-69,40},{-52,40}},color={0,0,127},smooth=Smooth.None));
  connect(zon.qGai_flow,multiplex3_1.y)
    annotation (Line(points={{-20,36},{-24,36},{-24,40},{-29,40}},color={0,0,127}));
  connect(multiplex3_1.u3[1],qLatGai_flow.y)
    annotation (Line(points={{-52,33},{-62,33},{-62,10},{-69,10}},color={0,0,127}));
  connect(freshAir.ports[1],duc.port_b)
    annotation (Line(points={{-60,-50},{-50,-50}},color={0,127,255}));
  connect(zon.TAir,TAir)
    annotation (Line(points={{23,44},{58.5,44},{58.5,40},{110,40}},    color={0,0,127}));
  connect(zon.TRad,TRad)
    annotation (Line(points={{23,40},{60,40},{60,0},{110,0}},color={0,0,127}));
  connect(senRelHum.phi,phi)
    annotation (Line(points={{71,-40},{110,-40}},color={0,0,127}));
  connect(duc.port_a,zon.ports[1])
    annotation (Line(points={{-30,-50},{0.4,-50},{0.4,6.9}},            color={0,127,255}));
  connect(bou.ports[1],zon.ports[2])
    annotation (Line(points={{-60,-80},{1.2,-80},{1.2,6.9}},
                                                        color={0,127,255}));
  connect(senRelHum.port,zon.ports[3])
    annotation (Line(points={{60,-50},{60,-60},{2,-60},{2,6.9}},            color={0,127,255}));
  connect(bou.weaBus,weaBus)
    annotation (Line(points={{-80,-79.8},{-86,-79.8},{-86,-80},{-94,-80},{-94,0},{-100,0}},color={255,204,51},thickness=0.5));
  connect(bou.m_flow_in, m_flow_in) annotation (Line(points={{-80,-72},{-91,
          -72},{-91,-74},{-122,-74}}, color={0,0,127}));
  connect(port_a, zon.ports[4]) annotation (Line(points={{-104,86},{-104,26},
          {-24,26},{-24,2},{0,2},{0,4},{2.8,4},{2.8,6.9}}, color={0,127,255}));
  connect(port_b, zon.ports[5]) annotation (Line(points={{104,88},{104,54},{
          124,54},{124,-14},{3.6,-14},{3.6,6.9}}, color={0,127,255}));
end Zone;
