within hil_flexlab_model.Examples.BaseClasses;
model Dehumidifier "Model that demonstrates the ideal heater model"

  package Medium = Buildings.Media.Air;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=3000/1000/20
    "Nominal mass flow rate";

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-72,-6},{-52,14}})));

  Buildings.Fluid.HeatExchangers.PrescribedOutlet preOut(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0)
    annotation (Placement(transformation(extent={{22,-24},{42,-4}})));
  Buildings.Fluid.Sensors.MassFraction       senMasFra(redeclare package Medium
      = Medium)
    annotation (Placement(transformation(extent={{26,-90},{46,-70}})));
  Buildings.Utilities.Psychrometrics.X_pTphi x_pTphi
    annotation (Placement(transformation(extent={{76,24},{96,44}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{32,16},{52,36}})));
  Buildings.Fluid.Sensors.Pressure           senPre(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{22,-60},{42,-40}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-124,-12},{-104,8}}),
        iconTransformation(extent={{-124,-12},{-104,8}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{100,-8},{120,12}}),
        iconTransformation(extent={{100,-8},{120,12}})));
  Modelica.Blocks.Interfaces.RealOutput phi_in annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-42,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-78,-110})));
  Modelica.Blocks.Interfaces.RealOutput phi_out annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={50,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-4,-110})));
  Modelica.Blocks.Interfaces.RealOutput latCooPow "latent cooling power"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={142,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={54,-110})));
  Buildings.Fluid.Sensors.RelativeHumidity   senRelHum(redeclare package Medium
      = Medium)
    annotation (Placement(transformation(extent={{-40,-64},{-20,-44}})));
  Buildings.Fluid.Sensors.RelativeHumidity   senRelHum1(redeclare package
      Medium = Medium)
    annotation (Placement(transformation(extent={{128,-66},{148,-46}})));
  Modelica.Blocks.Math.Min min1
    annotation (Placement(transformation(extent={{124,18},{144,38}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{196,-130},{216,-110}})));
equation

  connect(senTem.port_b, preOut.port_a) annotation (Line(points={{-52,4},{12,4},
          {12,-14},{22,-14}}, color={0,127,255}));
  connect(senTem.port_b, senMasFra.port) annotation (Line(points={{-52,4},{12,4},
          {12,-66},{22,-66},{22,-94},{36,-94},{36,-90}}, color={0,127,255}));
  connect(const1.y, x_pTphi.phi) annotation (Line(points={{53,26},{62,26},{62,28},
          {74,28}}, color={0,0,127}));
  connect(senTem.T, x_pTphi.T) annotation (Line(points={{-62,15},{-62,34},{24,34},
          {24,42},{64,42},{64,34},{74,34}}, color={0,0,127}));
  connect(senTem.port_b, senPre.port) annotation (Line(points={{-52,4},{12,4},{12,
          -66},{32,-66},{32,-60}}, color={0,127,255}));
  connect(senPre.p, x_pTphi.p_in) annotation (Line(points={{43,-50},{54,-50},{54,
          12},{28,12},{28,44},{66,44},{66,40},{74,40}}, color={0,0,127}));
  connect(senTem.T, preOut.TSet) annotation (Line(points={{-62,15},{-62,34},{16,
          34},{16,2},{20,2},{20,-6}}, color={0,0,127}));
  connect(port_a, senTem.port_a) annotation (Line(points={{-114,-2},{-78,-2},{
          -78,4},{-72,4}},
                       color={0,127,255}));
  connect(preOut.port_b, port_b) annotation (Line(points={{42,-14},{188,-14},{
          188,2},{110,2}},
                         color={0,127,255}));
  connect(senTem.port_b, senRelHum.port) annotation (Line(points={{-52,4},{12,4},
          {12,-74},{-30,-74},{-30,-64}}, color={0,127,255}));
  connect(senRelHum.phi, phi_in) annotation (Line(points={{-19,-54},{-16,-54},{
          -16,-40},{-44,-40},{-44,-96},{-42,-96},{-42,-110}}, color={0,0,127}));
  connect(preOut.port_b, senRelHum1.port) annotation (Line(points={{42,-14},{
          122,-14},{122,-70},{138,-70},{138,-66}}, color={0,127,255}));
  connect(senRelHum1.phi, phi_out) annotation (Line(points={{149,-56},{154,-56},
          {154,-96},{50,-96},{50,-110}}, color={0,0,127}));
  connect(x_pTphi.X[1], min1.u1)
    annotation (Line(points={{97,34},{122,34}}, color={0,0,127}));
  connect(senMasFra.X, min1.u2) annotation (Line(points={{47,-80},{82,-80},{82,
          22},{122,22}}, color={0,0,127}));
  connect(min1.y, preOut.X_wSet) annotation (Line(points={{145,28},{174,28},{
          174,-32},{20,-32},{20,-10}}, color={0,0,127}));
  connect(preOut.Q_flow, gain.u) annotation (Line(points={{43,-6},{94,-6},{94,
          -124},{184,-124},{184,-120},{194,-120}}, color={0,0,127}));
  connect(gain.y, latCooPow) annotation (Line(points={{217,-120},{226,-120},{
          226,-116},{232,-116},{232,-110},{142,-110}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{200,
            200}})),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/HeaterCooler_u.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
Model that demonstrates the use of an ideal heater.
Both heater models are identical, except that one model is configured
as a steady-state model, whereas the other is configured as a dynamic model.
Both heaters add heat to the medium to track a set-point for the outlet
temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2014, by Christoph Nytsch-Geusen:<br/>
Rename experiment to HetaterColler_u
in the Annex 60 library.
</li>
<li>
September 19, 2013, by Michael Wetter:<br/>
Removed fan with a prescribed mass flow source for inclusion of the test model
in the Annex 60 library.
</li>
<li>
July 11, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=86400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end Dehumidifier;
