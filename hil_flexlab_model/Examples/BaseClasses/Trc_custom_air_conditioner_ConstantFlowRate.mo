within hil_flexlab_model.Examples.BaseClasses;
model Trc_custom_air_conditioner_ConstantFlowRate

          package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
    package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);

  parameter Modelica.Units.SI.MassFlowRate mRec_flow_nominal=1
    "Nominal mass flow rate for recirculated air";



                  parameter Real TSupCooSet(unit="K")=273.15+12
    "Ccooling supply temperature setpoint";
        parameter Real TSupHeaSet(unit="K")=273.15+35
    "Heating supply temperature setpoint";
            parameter Real HeaCooCap(unit="J")=50000
    "Heater cooler capacity";
  Buildings.Fluid.Movers.FlowControlled_m_flow
                                     fan(
    redeclare package Medium = MediumAir,
    addPowerToMedium=false,
    m_flow_nominal=mRec_flow_nominal)
    "Fan"
    annotation (Placement(transformation(extent={{-118,-92},{-98,-72}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u
                                hea(
    redeclare final package Medium = MediumAir,
    m_flow_nominal=mRec_flow_nominal,
    dp_nominal=200,
    show_T=true,
    Q_flow_nominal=1)
    "Ideal heater"
    annotation (Placement(transformation(extent={{-78,-90},{-58,-70}})));
  Modelica.Blocks.Math.Gain        gain1(k=mRec_flow_nominal)
    annotation (Placement(transformation(extent={{-230,-54},{-210,-34}})));
  Modelica.Blocks.Math.Gain        gain(k=HeaCooCap)
    annotation (Placement(transformation(extent={{-144,-32},{-124,-12}})));
  Buildings.Controls.OBC.ASHRAE.G36.ThermalZones.ControlLoops conLoo(
    kCooCon=0.3,
    TiCooCon=300,
    kHeaCon=0.3,
    TiHeaCon=300)
    annotation (Placement(transformation(extent={{-16,12},{4,32}})));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{42,2},{62,22}})));
  SeparateHeatingCoolingThermalEnergy separateHeatingCoolingThermalEnergy
    annotation (Placement(transformation(extent={{-40,-112},{-20,-92}})));
  Modelica.Blocks.Interfaces.RealInput ZAT annotation (Placement(transformation(
          extent={{-140,44},{-100,84}}), iconTransformation(extent={{-140,44},{-100,
            84}})));
  Modelica.Blocks.Interfaces.RealOutput totalCoolingPower annotation (Placement(
        transformation(extent={{100,-12},{140,28}}), iconTransformation(extent={
            {100,-12},{140,28}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumAir) annotation (Placement(transformation(extent={{-120,-102},{
            -100,-82}}),
                    iconTransformation(extent={{-120,-102},{-100,-82}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumAir) annotation (Placement(transformation(extent={{98,-100},{118,
            -80}}),
        iconTransformation(extent={{98,-100},{118,-80}})));
  Dehumidifier              dehumidifier(const1(k=0.75))
    annotation (Placement(transformation(extent={{64,-140},{84,-120}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        MediumAir, m_flow_nominal=mRec_flow_nominal)
    annotation (Placement(transformation(extent={{-24,-150},{-4,-130}})));
  Buildings.Controls.Continuous.LimPID conPIDHea(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.3,
    Ti=300,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.2,
    reverseActing=false)
    annotation (Placement(transformation(extent={{-68,-184},{-48,-164}})));
  Buildings.Controls.Continuous.LimPID conPIDCoo(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.3,
    Ti=300,
    yMin=0,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=0.2,
    reverseActing=true)
    annotation (Placement(transformation(extent={{-54,-236},{-34,-216}})));
  Modelica.Blocks.Sources.Constant const1(k=TSupCooSet)
    annotation (Placement(transformation(extent={{-118,-242},{-98,-222}})));
  Modelica.Blocks.Sources.Constant const4(k=TSupHeaSet)
    annotation (Placement(transformation(extent={{-116,-188},{-96,-168}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold
                               greaterEqualThreshold
    annotation (Placement(transformation(extent={{34,-222},{54,-202}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{76,-216},{96,-196}})));
  Modelica.Blocks.Math.Max max1
    annotation (Placement(transformation(extent={{-162,-84},{-142,-64}})));
  Modelica.Blocks.Sources.Constant const5(k=0.05)
    annotation (Placement(transformation(extent={{-198,-118},{-178,-98}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{70,-102},{90,-82}})));
  Modelica.Blocks.Sources.Constant const6(k=1)
    annotation (Placement(transformation(extent={{-182,-152},{-162,-132}})));
  Modelica.Blocks.Interfaces.RealInput THeaSet annotation (Placement(
        transformation(extent={{-140,8},{-100,48}}), iconTransformation(extent=
            {{-140,-46},{-100,-6}})));
  Modelica.Blocks.Interfaces.RealInput TCooSet annotation (Placement(
        transformation(extent={{-134,-26},{-94,14}}), iconTransformation(extent=
           {{-140,0},{-100,40}})));
equation
  connect(fan.port_b,hea.port_a)
    annotation (Line(points={{-98,-82},{-84,-82},{-84,-80},{-78,-80}},
                                                color={0,127,255}));
  connect(gain.y,hea. u)
    annotation (Line(points={{-123,-22},{-120,-22},{-120,-66},{-114,-66},{-114,-60},
          {-86,-60},{-86,-74},{-80,-74}},                 color={0,0,127}));
  connect(conLoo.yCoo,add. u1) annotation (Line(points={{6,28},{32,28},{32,18},
          {40,18}}, color={0,0,127}));
  connect(conLoo.yHea,add. u2) annotation (Line(points={{6,16},{30,16},{30,6},{
          40,6}},    color={0,0,127}));
  connect(add.y,gain. u) annotation (Line(points={{63,12},{68,12},{68,-22},{-146,
          -22}},           color={0,0,127}));
  connect(hea.Q_flow, separateHeatingCoolingThermalEnergy.EffectiveThermalEnergy)
    annotation (Line(points={{-57,-74},{-48,-74},{-48,-94},{-50,-94},{-50,-102},
          {-42,-102}},                                             color={0,0,127}));
  connect(conLoo.TZon, ZAT) annotation (Line(points={{-18,22},{-32,22},{-32,64},
          {-120,64}},color={0,0,127}));
  connect(port_a, fan.port_a) annotation (Line(points={{-110,-92},{-110,-98},{
          -124,-98},{-124,-82},{-118,-82}},
                           color={0,127,255}));
  connect(dehumidifier.port_b, port_b) annotation (Line(points={{85,-129.8},{
          96.5,-129.8},{96.5,-90},{108,-90}},
                                        color={0,127,255}));
  connect(hea.port_b, senTem.port_a) annotation (Line(points={{-58,-80},{-50,-80},
          {-50,-92},{-52,-92},{-52,-140},{-24,-140}},
                                color={0,127,255}));
  connect(senTem.port_b, dehumidifier.port_a) annotation (Line(points={{-4,-140},
          {58,-140},{58,-130.2},{62.6,-130.2}},
                                             color={0,127,255}));
  connect(senTem.T, conPIDHea.u_m) annotation (Line(points={{-14,-129},{-4,-129},
          {-4,-128},{6,-128},{6,-186},{-58,-186}},
                                                color={0,0,127}));
  connect(senTem.T, conPIDCoo.u_m) annotation (Line(points={{-14,-129},{2,-129},
          {2,-130},{14,-130},{14,-238},{-44,-238}},
                                               color={0,0,127}));
  connect(const4.y, conPIDHea.u_s) annotation (Line(points={{-95,-178},{-80,-178},
          {-80,-174},{-70,-174}}, color={0,0,127}));
  connect(const1.y, conPIDCoo.u_s) annotation (Line(points={{-97,-232},{-66,-232},
          {-66,-226},{-56,-226}}, color={0,0,127}));
  connect(add.y, greaterEqualThreshold.u) annotation (Line(points={{63,12},{68,12},
          {68,-58},{40,-58},{40,-94},{42,-94},{42,-190},{22,-190},{22,-212},{32,
          -212}},
        color={0,0,127}));
  connect(greaterEqualThreshold.y, switch1.u2)
    annotation (Line(points={{55,-212},{64,-212},{64,-206},{74,-206}},
                                                   color={255,0,255}));
  connect(conPIDHea.y, switch1.u1) annotation (Line(points={{-47,-174},{66,-174},
          {66,-198},{74,-198}}, color={0,0,127}));
  connect(conPIDCoo.y, switch1.u3) annotation (Line(points={{-33,-226},{66,-226},
          {66,-214},{74,-214}}, color={0,0,127}));
  connect(switch1.y, gain1.u) annotation (Line(points={{97,-206},{97,-94},{96,-94},
          {96,-78},{-46,-78},{-46,-44},{-232,-44}}, color={0,0,127}));
  connect(gain1.y, max1.u1)
    annotation (Line(points={{-209,-44},{-118,-44},{-118,-68},{-164,-68}},
                                                     color={0,0,127}));
  connect(separateHeatingCoolingThermalEnergy.CoolingThermalEnergy, add1.u1)
    annotation (Line(points={{-18,-107.8},{-18,-108},{60,-108},{60,-86},{68,-86}},
        color={0,0,127}));
  connect(dehumidifier.latCooPow, add1.u2) annotation (Line(points={{79.4,-141},
          {79.4,-98},{68,-98}},color={0,0,127}));
  connect(add1.y, totalCoolingPower) annotation (Line(points={{91,-92},{98,-92},
          {98,-72},{94,-72},{94,8},{120,8}}, color={0,0,127}));
  connect(max1.u2, const5.y) annotation (Line(points={{-164,-80},{-120,-80},{-120,
          -108},{-177,-108}},    color={0,0,127}));
  connect(const6.y, fan.m_flow_in) annotation (Line(points={{-161,-142},{-90,-142},
          {-90,-64},{-108,-64},{-108,-70}}, color={0,0,127}));
  connect(TCooSet, conLoo.TCooSet) annotation (Line(points={{-114,-6},{-28,-6},
          {-28,28},{-18,28}}, color={0,0,127}));
  connect(THeaSet, conLoo.THeaSet) annotation (Line(points={{-120,28},{-34,28},
          {-34,16},{-18,16}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Trc_custom_air_conditioner_ConstantFlowRate;
