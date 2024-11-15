within hil_flexlab_model.BaseClasses;
package Controls "Package for RTU controls"
  extends Modelica.Icons.Package;

  model ConCool "Feedback cotroller for cooling equipment with status"
    parameter Modelica.Units.SI.Temperature airSet=273.15 + 13
      "Supply air temperature setpoint"
      annotation (Dialog(group="Air Temperature Control"));
    parameter Real k "Gain of controller";
    parameter Real yOff=0 "Output if uStatus is false";
    Buildings.Controls.Continuous.LimPID conPID(
      controllerType=Modelica.Blocks.Types.SimpleController.P,
      k=k,
      yMax=0,
      yMin=-1)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
    Modelica.Blocks.Interfaces.RealInput uMea "Measurement" annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,-120})));
    Modelica.Blocks.Logical.Switch switch
      annotation (Placement(transformation(extent={{50,-10},{70,10}})));
    Modelica.Blocks.Interfaces.RealOutput y "Output [0-1]"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.BooleanInput uStatus "Status signal"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
    Modelica.Blocks.Sources.Constant const(k=yOff)
      annotation (Placement(transformation(extent={{0,-20},{20,0}})));
    Modelica.Blocks.Math.Gain gain(k=-1)
      annotation (Placement(transformation(extent={{24,4},{36,16}})));
    Modelica.Blocks.Sources.Constant airSetConstant(k=airSet)
      "Set the pre-conditioning air temperature"
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  equation
    connect(conPID.u_m, uMea) annotation (Line(points={{-30,-2},{-30,-28},{0,-28},
            {0,-120}}, color={0,0,127}));
    connect(switch.y, y)
      annotation (Line(points={{71,0},{110,0}}, color={0,0,127}));
    connect(switch.u2, uStatus) annotation (Line(points={{48,0},{40,0},{40,60},{-120,
            60}}, color={255,0,255}));
    connect(const.y, switch.u3) annotation (Line(points={{21,-10},{28,-10},{28,-8},
            {48,-8}}, color={0,0,127}));
    connect(gain.y, switch.u1) annotation (Line(points={{36.6,10},{42,10},{42,8},{
            48,8}}, color={0,0,127}));
    connect(gain.u, conPID.y)
      annotation (Line(points={{22.8,10},{-19,10}}, color={0,0,127}));
    connect(airSetConstant.y, conPID.u_s)
      annotation (Line(points={{-59,10},{-42,10}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Line(points={{-90,20},{-90,-20}}, color={95,95,95}),
          Line(points={{-82,20},{-82,-20}}, color={95,95,95}),
          Line(points={{-82,0},{-10,0}}, color={95,95,95}),
          Ellipse(extent={{-10,10},{10,-10}}, lineColor={95,95,95}),
          Line(points={{0,-10},{0,-100}}, color={95,95,95}),
          Polygon(
            points={{-10,0},{-28,8},{-28,-8},{-10,0}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{4,3},{-14,11},{-14,-5},{4,3}},
            lineColor={95,95,95},
            origin={3,-14},
            rotation=90,
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Polygon(points={{68,0},{36,26},{36,-26},{68,0}}, lineColor={95,95,95}),
          Line(points={{68,0},{100,0},{100,0}}, color={95,95,95}),
          Line(points={{10,0},{36,0},{36,0}}, color={95,95,95}),
          Text(
            extent={{48,6},{56,-4}},
            lineColor={95,95,95},
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="k")}),                                     Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ConCool;

  model Thermostat "Thermostat controller for RTU fan with occupancy"
    parameter Modelica.Units.SI.Temperature TSet=273.15 + 25
      "Temperature Setpoint";
    parameter Real k=1 "Gain of controller";
    ConCool          conCool(k=k, airSet=TSet)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Interfaces.BooleanInput uOcc "Occupied status signal"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealInput uMea "Temperature measurement" annotation (
        Placement(transformation(
          extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,-120})));
    Modelica.Blocks.Interfaces.RealOutput y "Output [0-1]"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  equation
    connect(conCool.uStatus, uOcc) annotation (Line(points={{-12,6},{-20,6},{-20,40},{-80,
            40},{-80,0},{-120,0}}, color={255,0,255}));
    connect(conCool.uMea, uMea)
      annotation (Line(points={{0,-12},{0,-120}}, color={0,0,127}));
    connect(conCool.y, y) annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                  Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-60,60},{62,-60}},
            lineColor={0,0,0},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-24,24},{26,-16}},
            lineColor={255,255,255},
            fillColor={0,140,72},
            fillPattern=FillPattern.Solid,
            textStyle={TextStyle.Bold},
            textString="T")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
  end Thermostat;

  model ChargeState
    "This controller controls the state of each piece of equipment to determine the charge state."
    parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_water=0.0036
      "Nominal water flow";
    Modelica.Blocks.Math.BooleanToReal booRea
      "Convert charge mode to control signals"
      annotation (Placement(transformation(extent={{-38,70},{-18,90}})));
    Modelica.Blocks.Sources.Constant secFlo(k=m_flow_nominal_water)
      annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
    Modelica.Blocks.Logical.And andNotCharging "Discharge and activate"
      annotation (Placement(transformation(extent={{-16,-26},{-4,-14}})));
    Modelica.Blocks.Math.BooleanToReal booReaSecPum
      "Convert charge mode to control signals"
      annotation (Placement(transformation(extent={{24,-26},{36,-14}})));
    Modelica.Blocks.Math.RealToBoolean reaBoo
      "Convert charge mode to status signal"
      annotation (Placement(transformation(extent={{-50,-64},{-30,-44}})));
    Modelica.Blocks.Math.Product product
      annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
    Modelica.Blocks.Sources.Constant one(k=1)
      annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
    Modelica.Blocks.Math.Feedback feedback
      annotation (Placement(transformation(extent={{-60,-10},{-40,-30}})));
    Modelica.Blocks.Interfaces.RealOutput yVal "Valve signal"
      annotation (Placement(transformation(extent={{100,70},{120,90}})));
    Modelica.Blocks.Interfaces.RealOutput yPumSec "Secondary pump signal"
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusSec
      "Secondary water loop status"
      annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Sources.Constant priFlo(k=m_flow_nominal_water)
      "Set the primary pump flow"
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Modelica.Blocks.Interfaces.RealOutput yPumPri "Primary pump signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.BooleanInput uCharge
      "Sets charging mode (True to PCM charge mode, False to discharge mode)"
      annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
    Modelica.Blocks.Interfaces.BooleanInput uActivate
      "Activates discharging of the PCM material (True to PCM charge mode, False to discharge mode)"
      annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  equation
    connect(booRea.y,feedback. u2)
      annotation (Line(points={{-17,80},{0,80},{0,34},{-50,34},{-50,-12}},
                                                               color={0,0,127}));
    connect(feedback.y,reaBoo. u) annotation (Line(points={{-41,-20},{-30,-20},{
            -30,-36},{-52,-36},{-52,-54}},          color={0,0,127}));
    connect(one.y, feedback.u1)
      annotation (Line(points={{-79,-20},{-58,-20}}, color={0,0,127}));
    connect(secFlo.y, product.u1) annotation (Line(points={{-79,20},{52,20},{52,
            -34},{58,-34}},
                     color={0,0,127}));
    connect(booReaSecPum.y, product.u2) annotation (Line(points={{36.6,-20},{48,
            -20},{48,-46},{58,-46}},
                              color={0,0,127}));
    connect(reaBoo.y, andNotCharging.u2) annotation (Line(points={{-29,-54},{-26,-54},
            {-26,-24.8},{-17.2,-24.8}}, color={255,0,255}));
    connect(booRea.y, yVal) annotation (Line(points={{-17,80},{110,80}},
                  color={0,0,127}));
    connect(product.y, yPumSec)
      annotation (Line(points={{81,-40},{110,-40}}, color={0,0,127}));
    connect(reaBoo.y, statusSec) annotation (Line(points={{-29,-54},{0,-54},{0,
            -80},{110,-80}}, color={255,0,255}));
    connect(priFlo.y, yPumPri)
      annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
    connect(booRea.u, uCharge) annotation (Line(points={{-40,80},{-78,80},{-78,80},
            {-120,80}}, color={255,0,255}));
    connect(uActivate, andNotCharging.u1) annotation (Line(points={{-120,40},{-20,
            40},{-20,-20},{-17.2,-20}}, color={255,0,255}));
    connect(andNotCharging.y, booReaSecPum.u)
      annotation (Line(points={{-3.4,-20},{22.8,-20}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Rectangle(extent={{-60,70},{60,0}}, lineColor={95,95,95}),
          Ellipse(
            extent={{-60,-62},{60,-78}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-60,0},{60,-70}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-60,78},{60,62}},
            lineColor={95,95,95},
            fillColor={95,95,95},
            fillPattern=FillPattern.Solid),
          Ellipse(
            extent={{-60,8},{60,-8}},
            lineColor={95,95,95},
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid),
          Line(points={{60,0},{60,-70}}, color={95,95,95}),
          Line(points={{-60,0},{-60,-70}}, color={95,95,95}),
          Polygon(
            points={{4,3},{-14,11},{-14,-5},{4,3}},
            lineColor={135,135,135},
            origin={3,46},
            rotation=90,
            fillColor={135,135,135},
            fillPattern=FillPattern.Solid),
          Line(points={{0,50},{0,0}}, color={135,135,135}),
          Line(points={{0,0},{0,-50}}, color={135,135,135}),
          Polygon(
            points={{4,3},{-14,11},{-14,-5},{4,3}},
            lineColor={135,135,135},
            origin={-3,-46},
            rotation=270,
            fillColor={175,175,175},
            fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end ChargeState;

  model ChargeActivateSchedule "Schedule for charging and activation of pcm TES."
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads
      chaSch(table=[0,1.0; 6*3600,1.0; 6*3600,0.0; 22*3600,0.0; 22*3600,1.0; 24*
          3600,1.0]) "Charging schedule for PCM"
      annotation (Placement(transformation(extent={{-20,20},{0,40}})));
    Modelica.Blocks.Logical.GreaterThreshold
                                    greaterThreshold(threshold=0.5)
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    Modelica.Blocks.Logical.GreaterThreshold
                                    greaterThreshold1(threshold=0.5)
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads
      actSch(table=[0,0.0; 15*3600,0.0; 15*3600,1.0; 20*3600,1.0; 20*3600,0.0; 24
          *3600,0])        "Activation schedule for PCM"
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    Modelica.Blocks.Interfaces.BooleanOutput yCharge "Charging signal"
      annotation (Placement(transformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.BooleanOutput yActivate "Activation signal"
      annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  equation
    connect(chaSch.y[1],greaterThreshold. u)
      annotation (Line(points={{1,30},{18,30}},    color={0,0,127}));
    connect(actSch.y[1],greaterThreshold1. u)
      annotation (Line(points={{1,-10},{18,-10}},  color={0,0,127}));
    connect(greaterThreshold.y, yCharge) annotation (Line(points={{41,30},{60,30},
            {60,40},{110,40}}, color={255,0,255}));
    connect(greaterThreshold1.y, yActivate) annotation (Line(points={{41,-10},{60,
            -10},{60,-20},{110,-20}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5)}),                 Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end ChargeActivateSchedule;

  model StateControlChilledWaterConfig1
    Modelica.Blocks.Interfaces.IntegerInput u
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.IntegerOutput yHeaPum
      annotation (Placement(transformation(extent={{100,90},{120,110}})));
    Modelica.Blocks.Interfaces.IntegerOutput yEvaCoo
      annotation (Placement(transformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.IntegerOutput yTes
      annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
    Modelica.Blocks.Interfaces.IntegerOutput yPor
      annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusHeaPum
      annotation (Placement(transformation(extent={{100,70},{120,90}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusEvaCoo
      annotation (Placement(transformation(extent={{100,10},{120,30}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusTes
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusPor
      annotation (Placement(transformation(extent={{100,-110},{120,-90}})));

  equation
    if u == 1 then // Charge TES with HeaPum
      statusTes = true;
      statusHeaPum = true;
      statusEvaCoo = false;
      statusPor = false;
      yTes = 1;
      yHeaPum = 1;
      yPor = 1;
      yEvaCoo = 1;
    elseif u == 2 then // Charge TES with EvaCoo
      statusTes = true;
      statusEvaCoo = true;
      statusHeaPum = false;
      statusPor = false;
      yTes = 2;
      yEvaCoo = 1;
      yHeaPum = 1;
      yPor = 1;
    elseif u == 3 then // Supply Port with TES
      statusTes = true;
      statusPor = true;
      statusHeaPum = false;
      statusEvaCoo = false;
      yTes = 3;
      yPor = 3;
      yHeaPum = 1;
      yEvaCoo = 1;
    elseif u == 4 then // Supply Port with EvaCoo
      statusEvaCoo = true;
      statusPor = true;
      statusHeaPum = false;
      statusTes = false;
      yEvaCoo = 2;
      yPor = 2;
      yHeaPum = 1;
      yTes = 1;
    elseif u == 5 then // Supply Port with HeaPum
      statusHeaPum = true;
      statusPor = true;
      statusEvaCoo = false;
      statusTes = false;
      yHeaPum = 2;
      yPor = 1;
      yEvaCoo = 1;
      yTes = 1;
    else
      assert(false, "Control state is outside of range.");
      statusTes = true;
      statusHeaPum = true;
      statusEvaCoo = false;
      statusPor = false;
      yTes = 2;
      yHeaPum = 1;
      yPor = 1;
      yEvaCoo = 1;
    end if;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end StateControlChilledWaterConfig1;

  model StateScheduleChilledWaterSimple
    "Schedule for charging and activation of pcm TES."
    parameter Modelica.Units.SI.Temperature TSol "Solidus temperature of PCM";
    parameter Modelica.Units.SI.Temperature TLiq "Liquidus temperature of PCM";
    Modelica.Blocks.Math.RealToInteger realToInteger
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Modelica.Blocks.Interfaces.IntegerOutput y
      "Connector of Integer output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads staSchConfig1(
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments, table=[0,
          1.0; 7*3600,5.0; 11.75*3600,3.0; 15*3600,5.0; 21.5*3600,1.0; 24*3600,
          1.0])
      "State schedule for configuration 1"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Interfaces.RealInput Ttes
      "Temperature of thermal energy storage"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Logical.Hysteresis hysteresis1(
      uLow=TSol - 1,
      uHigh=TLiq - 1,
      pre_y_start=true)
      annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
    Modelica.Blocks.Logical.LessEqualThreshold
                                          lessEqualThreshold(
                                                         threshold=2.2)
      annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
    Modelica.Blocks.Sources.Constant staSweCoo1(k=5)
      annotation (Placement(transformation(extent={{30,-66},{50,-46}})));
    Modelica.Blocks.Logical.Switch swi2
      annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
    Modelica.Blocks.Logical.And and2
      annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
    Modelica.Blocks.Logical.Switch swi1
      annotation (Placement(transformation(extent={{110,-40},{130,-20}})));
  equation
    connect(realToInteger.y, y)
      annotation (Line(points={{81,0},{110,0}}, color={255,127,0}));
    connect(Ttes, hysteresis1.u) annotation (Line(points={{-120,0},{-82,0},{-82,
            -80},{-22,-80}}, color={0,0,127}));
    connect(lessEqualThreshold.y, and2.u1)
      annotation (Line(points={{51,-30},{68,-30}}, color={255,0,255}));
    connect(hysteresis1.y, and2.u2) annotation (Line(points={{1,-80},{60,-80},{60,
            -38},{68,-38}}, color={255,0,255}));
    connect(staSchConfig1.y[1], lessEqualThreshold.u) annotation (Line(points={{
            11,0},{20,0},{20,-30},{28,-30}}, color={0,0,127}));
    connect(staSchConfig1.y[1], swi1.u1) annotation (Line(points={{11,0},{20,0},{
            20,-14},{100,-14},{100,-22},{108,-22}}, color={0,0,127}));
    connect(swi1.y, realToInteger.u) annotation (Line(points={{131,-30},{140,-30},
            {140,-12},{48,-12},{48,0},{58,0}}, color={0,0,127}));
    connect(staSweCoo1.y, swi2.u1) annotation (Line(points={{51,-56},{66,-56},{66,
            -52},{78,-52}}, color={0,0,127}));
    connect(lessEqualThreshold.y, swi2.u2) annotation (Line(points={{51,-30},{56,
            -30},{56,-60},{78,-60}}, color={255,0,255}));
    connect(staSchConfig1.y[1], swi2.u3) annotation (Line(points={{11,0},{20,0},{
            20,-68},{78,-68}}, color={0,0,127}));
    connect(and2.y, swi1.u2)
      annotation (Line(points={{91,-30},{108,-30}}, color={255,0,255}));
    connect(swi2.y, swi1.u3) annotation (Line(points={{101,-60},{106,-60},{106,
            -44},{100,-44},{100,-38},{108,-38}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5)}),                 Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end StateScheduleChilledWaterSimple;

  model StateScheduleSwec "Schedule for charging and activation of pcm TES."
    parameter Modelica.Units.SI.Temperature TSol "Solidus temperature of PCM";
    parameter Modelica.Units.SI.Temperature TLiq "Liquidus temperature of PCM";
    Modelica.Blocks.Math.RealToInteger realToInteger
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Modelica.Blocks.Interfaces.IntegerOutput y
      "Connector of Integer output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads staSchConfig1(
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments, table=[0,
          1.0; 7*3600,5.0; 11.75*3600,3.0; 15*3600,5.0; 21.5*3600,1.0; 24*3600,
          1.0])
      "State schedule for configuration 1"
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
      annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
    Modelica.Blocks.Sources.Constant sweDel(k=2)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    Modelica.Blocks.Math.Add sub(k2=-1)
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.Blocks.Logical.Hysteresis hysteresis(
      uLow=TSol - 1,
      uHigh=TLiq - 1,
      pre_y_start=true)
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Modelica.Blocks.Logical.And and1
      annotation (Placement(transformation(extent={{40,40},{60,60}})));
    Modelica.Blocks.Logical.Switch swi
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=1.1)
      annotation (Placement(transformation(extent={{-20,30},{0,50}})));
    Modelica.Blocks.Sources.Constant staSweCoo(k=2)
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{12,60},{32,80}})));
    Modelica.Blocks.Logical.Hysteresis hysteresis1(
      uLow=TSol - 1,
      uHigh=TLiq - 1,
      pre_y_start=true)
      annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
    Modelica.Blocks.Interfaces.RealInput Ttes
      "Temperature of thermal energy storage"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Logical.LessThreshold lessThreshold1(threshold=2.2)
      annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
    Modelica.Blocks.Logical.And and2
      annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
    Modelica.Blocks.Logical.Switch swi1
      annotation (Placement(transformation(extent={{110,-40},{130,-20}})));
    Modelica.Blocks.Logical.Switch swi2
      annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
    Modelica.Blocks.Sources.Constant staSweCoo1(k=5)
      annotation (Placement(transformation(extent={{30,-66},{50,-46}})));
    Modelica.Blocks.Logical.GreaterThreshold
                                          greaterThreshold(threshold=4.4)
      annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
    Modelica.Blocks.Logical.And and3
      annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
    Modelica.Blocks.Logical.Switch swi3
      annotation (Placement(transformation(extent={{60,-140},{80,-120}})));
    Modelica.Blocks.Sources.Constant staSweCoo2(k=3)
      annotation (Placement(transformation(extent={{22,-206},{42,-186}})));
    Modelica.Blocks.Logical.Switch swi4
      annotation (Placement(transformation(extent={{80,-178},{100,-158}})));
    Modelica.Blocks.Sources.Constant staSweCoo3(k=4)
      annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  equation
    connect(realToInteger.y, y)
      annotation (Line(points={{81,0},{110,0}}, color={255,127,0}));
    connect(sweDel.y, sub.u2) annotation (Line(points={{-79,50},{-70,50},{-70,64},
            {-62,64}}, color={0,0,127}));
    connect(weaBus.TWetBul, sub.u1) annotation (Line(
        points={{-100,100},{-100,76},{-62,76}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sub.y, hysteresis.u)
      annotation (Line(points={{-39,70},{-22,70}}, color={0,0,127}));
    connect(and1.y, swi.u2) annotation (Line(points={{61,50},{70,50},{70,20},{12,
            20},{12,0},{18,0}}, color={255,0,255}));
    connect(staSchConfig1.y[1], lessThreshold.u) annotation (Line(points={{-39,
            -20},{-30,-20},{-30,40},{-22,40}}, color={0,0,127}));
    connect(staSweCoo.y, swi.u1)
      annotation (Line(points={{1,10},{6,10},{6,8},{18,8}}, color={0,0,127}));
    connect(staSchConfig1.y[1], swi.u3) annotation (Line(points={{-39,-20},{10,
            -20},{10,-8},{18,-8}}, color={0,0,127}));
    connect(not1.y, and1.u1) annotation (Line(points={{33,70},{34,70},{34,50},{38,
            50}}, color={255,0,255}));
    connect(hysteresis1.u, Ttes) annotation (Line(points={{-22,-80},{-80,-80},{
            -80,0},{-120,0}}, color={0,0,127}));
    connect(lessThreshold.y, and1.u2) annotation (Line(points={{1,40},{20,40},{20,
            42},{38,42}}, color={255,0,255}));
    connect(swi.y, lessThreshold1.u) annotation (Line(points={{41,0},{48,0},{48,
            -14},{20,-14},{20,-30},{28,-30}}, color={0,0,127}));
    connect(lessThreshold1.y, and2.u1)
      annotation (Line(points={{51,-30},{68,-30}}, color={255,0,255}));
    connect(hysteresis1.y, and2.u2) annotation (Line(points={{1,-80},{30,-80},{30,
            -82},{60,-82},{60,-38},{68,-38}}, color={255,0,255}));
    connect(and2.y, swi1.u2)
      annotation (Line(points={{91,-30},{108,-30}}, color={255,0,255}));
    connect(swi.y, swi1.u1) annotation (Line(points={{41,0},{48,0},{48,-14},{100,
            -14},{100,-22},{108,-22}}, color={0,0,127}));
    connect(swi1.y, realToInteger.u) annotation (Line(points={{131,-30},{140,-30},
            {140,-12},{52,-12},{52,0},{58,0}}, color={0,0,127}));
    connect(lessThreshold1.y, swi2.u2) annotation (Line(points={{51,-30},{56,-30},
            {56,-60},{78,-60}}, color={255,0,255}));
    connect(staSweCoo1.y, swi2.u1) annotation (Line(points={{51,-56},{68,-56},{68,
            -52},{78,-52}}, color={0,0,127}));
    connect(swi2.y, swi1.u3) annotation (Line(points={{101,-60},{104,-60},{104,
            -38},{108,-38}}, color={0,0,127}));
    connect(staSchConfig1.y[1], greaterThreshold.u) annotation (Line(points={{-39,
            -20},{-30,-20},{-30,-110},{-22,-110}}, color={0,0,127}));
    connect(and3.u1, greaterThreshold.y)
      annotation (Line(points={{18,-110},{1,-110}}, color={255,0,255}));
    connect(greaterThreshold.y, swi4.u2) annotation (Line(points={{1,-110},{10,
            -110},{10,-168},{78,-168}}, color={255,0,255}));
    connect(staSweCoo2.y, swi4.u3) annotation (Line(points={{43,-196},{60,-196},{
            60,-176},{78,-176}}, color={0,0,127}));
    connect(swi3.y, swi4.u1) annotation (Line(points={{81,-130},{90,-130},{90,
            -148},{68,-148},{68,-160},{78,-160}}, color={0,0,127}));
    connect(swi4.y, swi2.u3) annotation (Line(points={{101,-168},{110,-168},{110,
            -80},{68,-80},{68,-68},{78,-68}}, color={0,0,127}));
    connect(hysteresis.y, and3.u2) annotation (Line(points={{1,70},{4,70},{4,-118},
            {18,-118}}, color={255,0,255}));
    connect(staSweCoo3.y, swi3.u3) annotation (Line(points={{41,-150},{48,-150},{
            48,-138},{58,-138}}, color={0,0,127}));
    connect(and3.y, swi3.u2) annotation (Line(points={{41,-110},{48,-110},{48,
            -130},{58,-130}}, color={255,0,255}));
    connect(swi3.u1, swi2.u1) annotation (Line(points={{58,-122},{54,-122},{54,
            -56},{68,-56},{68,-52},{78,-52}}, color={0,0,127}));
    connect(hysteresis.y, not1.u)
      annotation (Line(points={{1,70},{10,70}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5),
          Ellipse(
            extent={{70,80},{90,56}},
            lineColor={28,108,200},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{72,74},{88,74},{80,94},{72,74}},
            lineColor={28,108,200},
            fillColor={28,108,200},
            fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end StateScheduleSwec;

  model StateControlChilledWaterConfig1b
    Modelica.Blocks.Interfaces.IntegerInput u
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.IntegerOutput yHeaPum
      annotation (Placement(transformation(extent={{100,90},{120,110}})));
    Modelica.Blocks.Interfaces.IntegerOutput yEvaCoo
      annotation (Placement(transformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.IntegerOutput yTes
      annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
    Modelica.Blocks.Interfaces.IntegerOutput yPor
      annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusHeaPum
      annotation (Placement(transformation(extent={{100,70},{120,90}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusEvaCoo
      annotation (Placement(transformation(extent={{100,10},{120,30}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusTes
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusPor
      annotation (Placement(transformation(extent={{100,-110},{120,-90}})));

    Modelica.Blocks.Interfaces.IntegerOutput yPorSec
      annotation (Placement(transformation(extent={{100,-150},{120,-130}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusPorSec
      annotation (Placement(transformation(extent={{100,-170},{120,-150}})));
  equation
    if u == 1 then // Charge TES with HeaPum
      statusTes = true;
      statusHeaPum = true;
      statusEvaCoo = false;
      statusPor = false;
      statusPorSec = false;
      yTes = 3;
      yHeaPum = 1;
      yPor = 1;
      yEvaCoo = 1;
      yPorSec = 1;
    elseif u == 2 then // Charge TES with EvaCoo and Primary port with Heatpump
      statusTes = true;
      statusEvaCoo = true;
      statusHeaPum = true;
      statusPor = true;
      statusPorSec = false;
      yTes = 2;
      yEvaCoo = 1;
      yHeaPum = 2;
      yPor = 1;
      yPorSec = 1;
    elseif u == 3 then // Supply Secondary Port with TES and Primary port with Heatpump
      statusTes = true;
      statusPor = true;
      statusHeaPum = true;
      statusEvaCoo = false;
      statusPorSec = true;
      yTes = 1;
      yPor = 1;
      yHeaPum = 2;
      yEvaCoo = 1;
      yPorSec = 1;
    elseif u == 4 then // Supply Secondary Port with EvaCoo and Primary port with Heatpump
      statusTes = false;
      statusPor = true;
      statusHeaPum = true;
      statusEvaCoo = true;
      statusPorSec = true;
      yTes = 1;
      yPor = 1;
      yHeaPum = 2;
      yEvaCoo = 2;
      yPorSec = 2;
    elseif u == 5 then // Supply Primary port with HeatPump
      statusHeaPum = true;
      statusPor = true;
      statusEvaCoo = false;
      statusTes = false;
      statusPorSec = false;
      yHeaPum = 2;
      yPor = 1;
      yEvaCoo = 1;
      yTes = 1;
      yPorSec = 1;
    else
      assert(false, "Control state is outside of range.");
      statusTes = true;
      statusHeaPum = true;
      statusEvaCoo = false;
      statusPor = false;
      statusPorSec = false;
      yTes = 2;
      yHeaPum = 1;
      yPor = 1;
      yEvaCoo = 1;
      yPorSec = 1;
    end if;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},
              {100,100}})),                                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,100}})));
  end StateControlChilledWaterConfig1b;

  model StateScheduleConfig1b
    "Schedule for charging and activation of pcm TES for configuration 1b"
    parameter Modelica.Units.SI.Temperature TSol "Solidus temperature of PCM";
    parameter Modelica.Units.SI.Temperature TLiq "Liquidus temperature of PCM";
    Modelica.Blocks.Math.RealToInteger realToInteger
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.IntegerOutput y
      "Connector of Integer output signal"
      annotation (Placement(transformation(extent={{140,-10},{160,10}})));
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads staSchConfig1(
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments, table=[0,
          1.0; 7*3600,5.0; 11.75*3600,3.0; 15*3600,5.0; 21.5*3600,1.0; 24*3600,
          1.0])
      "State schedule for configuration 1"
      annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
      annotation (Placement(transformation(extent={{-110,90},{-90,110}})));
    Modelica.Blocks.Sources.Constant sweDel(k=2)
      annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
    Modelica.Blocks.Math.Add sub(k2=-1)
      annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
    Modelica.Blocks.Logical.Hysteresis hysteresis(
      uLow=TSol - 1,
      uHigh=TLiq - 1,
      pre_y_start=true)
      annotation (Placement(transformation(extent={{-20,60},{0,80}})));
    Modelica.Blocks.Logical.And and1
      annotation (Placement(transformation(extent={{40,50},{60,70}})));
    Modelica.Blocks.Logical.Switch swi
      annotation (Placement(transformation(extent={{20,-10},{40,10}})));
    Modelica.Blocks.Logical.LessEqualThreshold
                                          lessEqualThreshold(threshold=1)
      annotation (Placement(transformation(extent={{-20,30},{0,50}})));
    Modelica.Blocks.Sources.Constant staSweCoo(k=2)
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{10,60},{30,80}})));
    Modelica.Blocks.Logical.And and2
      annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
    Modelica.Blocks.Logical.GreaterEqualThreshold
                                          greaterEqualThreshold(threshold=5)
      annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
    Modelica.Blocks.Logical.Switch swi1
      annotation (Placement(transformation(extent={{20,-120},{40,-100}})));
    Modelica.Blocks.Sources.Constant staSweCoo1(k=3)
      annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
    Modelica.Blocks.Logical.Switch swi2
      annotation (Placement(transformation(extent={{60,-18},{80,2}})));
    Modelica.Blocks.Logical.And and3
      annotation (Placement(transformation(extent={{40,-160},{60,-140}})));
    Modelica.Blocks.Logical.Switch swi3
      annotation (Placement(transformation(extent={{20,-200},{40,-180}})));
    Modelica.Blocks.Sources.Constant staSweCoo2(k=4)
      annotation (Placement(transformation(extent={{-20,-220},{0,-200}})));
    Modelica.Blocks.Interfaces.RealInput Ttes
      "Temperature of thermal energy storage"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Logical.Hysteresis hysteresis1(
      uLow=TSol - 1,
      uHigh=TLiq - 1,
      pre_y_start=true)
      annotation (Placement(transformation(extent={{158,76},{178,96}})));
    Modelica.Blocks.Logical.And and4
      annotation (Placement(transformation(extent={{248,126},{268,146}})));
    Modelica.Blocks.Logical.LessEqualThreshold
                                          lessEqualThreshold1(threshold=2)
      annotation (Placement(transformation(extent={{208,132},{228,152}})));
    Modelica.Blocks.Sources.Constant staSweCoo3(k=5)
      annotation (Placement(transformation(extent={{208,100},{228,120}})));
    Modelica.Blocks.Logical.Switch swi5
      annotation (Placement(transformation(extent={{288,126},{308,146}})));
  equation
    connect(realToInteger.y, y)
      annotation (Line(points={{121,0},{150,0}},color={255,127,0}));
    connect(sweDel.y, sub.u2) annotation (Line(points={{-79,50},{-70,50},{-70,64},
            {-62,64}}, color={0,0,127}));
    connect(weaBus.TWetBul, sub.u1) annotation (Line(
        points={{-100,100},{-100,76},{-62,76}},
        color={255,204,51},
        thickness=0.5), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}},
        horizontalAlignment=TextAlignment.Right));
    connect(sub.y, hysteresis.u)
      annotation (Line(points={{-39,70},{-22,70}}, color={0,0,127}));
    connect(lessEqualThreshold.y, and1.u2) annotation (Line(points={{1,40},{20,40},
            {20,52},{38,52}}, color={255,0,255}));
    connect(and1.y, swi.u2) annotation (Line(points={{61,60},{70,60},{70,20},{12,
            20},{12,0},{18,0}}, color={255,0,255}));
    connect(staSchConfig1.y[1], lessEqualThreshold.u) annotation (Line(points={{-39,
            -20},{-30,-20},{-30,40},{-22,40}}, color={0,0,127}));
    connect(staSweCoo.y, swi.u1)
      annotation (Line(points={{1,10},{6,10},{6,8},{18,8}}, color={0,0,127}));
    connect(staSchConfig1.y[1], swi.u3) annotation (Line(points={{-39,-20},{10,
            -20},{10,-8},{18,-8}}, color={0,0,127}));
    connect(hysteresis.y, not1.u)
      annotation (Line(points={{1,70},{8,70}}, color={255,0,255}));
    connect(not1.y, and1.u1) annotation (Line(points={{31,70},{34,70},{34,60},{38,
            60}}, color={255,0,255}));
    connect(staSchConfig1.y[1], greaterEqualThreshold.u) annotation (Line(points=
            {{-39,-20},{-30,-20},{-30,-80},{-22,-80}}, color={0,0,127}));
    connect(greaterEqualThreshold.y, and2.u2) annotation (Line(points={{1,-80},{4,
            -80},{4,-58},{38,-58}}, color={255,0,255}));
    connect(staSweCoo1.y, swi1.u1) annotation (Line(points={{1,-110},{8,-110},{8,
            -102},{18,-102}}, color={0,0,127}));
    connect(and2.y, swi1.u2) annotation (Line(points={{61,-50},{70,-50},{70,-90},
            {14,-90},{14,-110},{18,-110}}, color={255,0,255}));
    connect(lessEqualThreshold.y, swi2.u2) annotation (Line(points={{1,40},{50,40},
            {50,-8},{58,-8}}, color={255,0,255}));
    connect(swi1.y, swi2.u3) annotation (Line(points={{41,-110},{80,-110},{80,-28},
            {50,-28},{50,-16},{58,-16}}, color={0,0,127}));
    connect(swi2.y, realToInteger.u)
      annotation (Line(points={{81,-8},{88,-8},{88,0},{98,0}}, color={0,0,127}));
    connect(greaterEqualThreshold.y, and3.u2) annotation (Line(points={{1,-80},{
            10,-80},{10,-158},{38,-158}}, color={255,0,255}));
    connect(and3.y, swi3.u2) annotation (Line(points={{61,-150},{70,-150},{70,
            -172},{8,-172},{8,-190},{18,-190}}, color={255,0,255}));
    connect(swi3.y, swi1.u3) annotation (Line(points={{41,-190},{52,-190},{52,
            -164},{4,-164},{4,-118},{18,-118}}, color={0,0,127}));
    connect(hysteresis.y, and2.u1) annotation (Line(points={{1,70},{4,70},{4,-50},
            {38,-50}}, color={255,0,255}));
    connect(not1.y, and3.u1) annotation (Line(points={{31,70},{32,70},{32,-150},{
            38,-150}}, color={255,0,255}));
    connect(staSweCoo2.y, swi3.u1) annotation (Line(points={{1,-210},{12,-210},{
            12,-182},{18,-182}}, color={0,0,127}));
    connect(swi3.u3, greaterEqualThreshold.u) annotation (Line(points={{18,-198},
            {4,-198},{4,-180},{-30,-180},{-30,-80},{-22,-80}}, color={0,0,127}));
    connect(hysteresis1.u, Ttes) annotation (Line(points={{156,86},{-34,86},{-34,
            0},{-120,0}}, color={0,0,127}));
    connect(hysteresis1.y, and4.u2) annotation (Line(points={{179,86},{208,86},{
            208,84},{238,84},{238,128},{246,128}}, color={255,0,255}));
    connect(lessEqualThreshold1.y, and4.u1) annotation (Line(points={{229,142},{
            238,142},{238,136},{246,136}}, color={255,0,255}));
    connect(and4.y, swi5.u2)
      annotation (Line(points={{269,136},{286,136}}, color={255,0,255}));
    connect(swi.y, lessEqualThreshold1.u) annotation (Line(points={{41,0},{44,0},
            {44,142},{206,142}}, color={0,0,127}));
    connect(swi5.u1, lessEqualThreshold1.u) annotation (Line(points={{286,144},{
            286,160},{200,160},{200,142},{206,142}}, color={0,0,127}));
    connect(swi5.y, swi2.u1) annotation (Line(points={{309,136},{320,136},{320,16},
            {54,16},{54,0},{58,0}}, color={0,0,127}));
    connect(staSweCoo3.y, swi5.u3) annotation (Line(points={{229,110},{280,110},{
            280,128},{286,128}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{140,100}}),                                  graphics={
            Rectangle(
            extent={{-100,100},{140,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5),
          Ellipse(
            extent={{70,80},{90,56}},
            lineColor={102,44,145},
            fillColor={102,44,145},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{72,74},{88,74},{80,94},{72,74}},
            lineColor={102,44,145},
            fillColor={102,44,145},
            fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
            preserveAspectRatio=false, extent={{-100,-100},{140,100}})));
  end StateScheduleConfig1b;

  model StateControlConfig1c
    Modelica.Blocks.Interfaces.IntegerInput u
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.IntegerOutput yHeaPum
      annotation (Placement(transformation(extent={{100,90},{120,110}})));
    Modelica.Blocks.Interfaces.IntegerOutput yEvaCoo
      annotation (Placement(transformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.IntegerOutput yTes
      annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
    Modelica.Blocks.Interfaces.IntegerOutput yPor
      annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusHeaPum
      annotation (Placement(transformation(extent={{100,70},{120,90}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusEvaCoo
      annotation (Placement(transformation(extent={{100,10},{120,30}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusTes
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusPor
      annotation (Placement(transformation(extent={{100,-110},{120,-90}})));

  equation
    if u == 1 then // Charge TES with HeaPum
      statusTes = true;
      statusHeaPum = true;
      statusEvaCoo = false;
      statusPor = false;
      yTes = 1;
      yHeaPum = 1;
      yPor = 1;
      yEvaCoo = 1;
    elseif u == 2 then // Charge TES with EvaCoo
      statusTes = true;
      statusEvaCoo = true;
      statusHeaPum = false;
      statusPor = false;
      yTes = 2;
      yEvaCoo = 1;
      yHeaPum = 1;
      yPor = 1;
    elseif u == 3 then // Supply Heatpump with TES
      statusTes = true;
      statusPor = true;
      statusHeaPum = true;
      statusEvaCoo = false;
      yTes = 3;
      yPor = 1;
      yHeaPum = 1;
      yEvaCoo = 1;
    elseif u == 4 then // Supply Heatpump with EvaCoo
      statusEvaCoo = true;
      statusPor = true;
      statusHeaPum = true;
      statusTes = false;
      yEvaCoo = 2;
      yPor = 1;
      yHeaPum = 3;
      yTes = 1;
    elseif u == 5 then // Supply Port with HeaPum
      statusHeaPum = true;
      statusPor = true;
      statusEvaCoo = false;
      statusTes = false;
      yHeaPum = 2;
      yPor = 1;
      yEvaCoo = 1;
      yTes = 1;
    else
      assert(false, "Control state is outside of range.");
      statusTes = true;
      statusHeaPum = true;
      statusEvaCoo = false;
      statusPor = false;
      yTes = 2;
      yHeaPum = 1;
      yPor = 1;
      yEvaCoo = 1;
    end if;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end StateControlConfig1c;

  model StateScheduleChilledWaterHeatpumpOnly
    "Schedule for charging and activation of pcm TES."
    Modelica.Blocks.Math.RealToInteger realToInteger
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Modelica.Blocks.Interfaces.IntegerOutput y
      "Connector of Integer output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads staSchConfig1(
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments, table=[0,
          5.0; 7.5*3600,5.0; 15*3600,5.0; 18.5*3600,5.0; 24*3600,5.0])
      "State schedule for configuration 1"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(realToInteger.y, y)
      annotation (Line(points={{81,0},{110,0}}, color={255,127,0}));
    connect(staSchConfig1.y[1], realToInteger.u)
      annotation (Line(points={{11,0},{58,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5)}),                 Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end StateScheduleChilledWaterHeatpumpOnly;

  model SZVAV "Controller for single zone VAV system"
    extends Modelica.Blocks.Icons.Block;
    extends BaseClasses.SZVAVBase;

    annotation (Icon(coordinateSystem(extent={{-100,-140},{100,180}}),
                     graphics={Line(points={{-100,-100},{0,2},{-100,100}}, color=
                {0,0,0})}), Diagram(coordinateSystem(extent={{-100,-140},{100,180}})),
      experiment(
        StopTime=86400,
        Interval=60.0001344,
        Tolerance=1e-06,
        __Dymola_Algorithm="Radau"));
  end SZVAV;

  model SZVAVSec "Single zone VAV control with secondary cooling coil"
    extends SZVAV;
    ConCool conCool(airSet=TSetSupAir, k=4)
      annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
    Modelica.Blocks.Interfaces.RealOutput yCooCoiValSec(final unit="1")
      "Control signal for secondary cooling coil valve"
      annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
    Modelica.Blocks.Interfaces.RealInput TPre "Preconditioning air temperature"
      annotation (Placement(transformation(extent={{-140,-160},{-100,-120}})));
  equation
    connect(conCool.y,yCooCoiValSec)  annotation (Line(points={{61,-120},{80,-120},
            {80,-60},{110,-60}}, color={0,0,127}));
    connect(hysChiPla.y,conCool. uStatus) annotation (Line(points={{62,-40},{64,
            -40},{64,-70},{30,-70},{30,-114},{38,-114}},
                                                color={255,0,255}));
    connect(conCool.uMea,TPre)  annotation (Line(points={{50,-132},{50,-140},{
            -120,-140}}, color={0,0,127}));
  end SZVAVSec;

  model SZDOASIECHR
    "Controls for single zone DOAS system with heating coil and IEC heat recovery"
    extends BaseClasses.SZDOASBase;
    Modelica.Blocks.Interfaces.BooleanOutput heaRecSta
      "Heat recovery status signal"
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.BooleanOutput evaCooSta
      "Evaporative cooling status signal"
      annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Interfaces.BooleanInput heaSta "Heating status signal"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
    Modelica.Blocks.Interfaces.BooleanInput cooSta "Cooling status signal"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
    Modelica.Blocks.Interfaces.RealInput TOut "Outside air drybulb temperature"
      annotation (Placement(transformation(extent={{-140,-140},{-100,-100}})));
    Modelica.Blocks.Interfaces.RealInput TRet "Return air drybulb temperature"
      annotation (Placement(transformation(extent={{-140,-180},{-100,-140}})));
    Modelica.Blocks.Interfaces.RealInput phiRet "Return air relative humidity"
      annotation (Placement(transformation(extent={{-140,-220},{-100,-180}})));
    Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBul(redeclare
        package Medium = Buildings.Media.Air)
      annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
    Modelica.Blocks.Math.Feedback feedback1
      annotation (Placement(transformation(extent={{-50,-170},{-30,-150}})));
    Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysHeaRecCoo(
      uHigh=0.5,
      uLow=0,
      trueHoldDuration=60*15)
      "Hysteresis with delay to check for cooling potential of return air"
      annotation (Placement(transformation(extent={{-20,-170},{0,-150}})));
    Modelica.Blocks.Logical.And andHeaRecCoo
      annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
    Modelica.Blocks.Math.Feedback feedback2
      annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
    Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysHeaRecHea(
      uHigh=0.5,
      uLow=0,
      trueHoldDuration=60*15)
      "Hysteresis with delay to check for heating potential of return air"
      annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
    Modelica.Blocks.Logical.And andHeaRecHea
      annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
    Modelica.Blocks.Logical.Or orHeaRec
      annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
    Modelica.Blocks.Logical.And andDeaBan
      annotation (Placement(transformation(extent={{-20,-120},{0,-100}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));
    Modelica.Blocks.Logical.Not not2
      annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
    Buildings.Controls.OBC.CDL.Logical.Pre pre
      annotation (Placement(transformation(extent={{28,-90},{48,-70}})));
    Modelica.Blocks.Logical.And andDeaBan1
      annotation (Placement(transformation(extent={{32,-120},{52,-100}})));
    Modelica.Blocks.Logical.Or orHeaRec1
      annotation (Placement(transformation(extent={{124,-62},{144,-42}})));
    Modelica.Blocks.Logical.And andHeaRecHea1
      annotation (Placement(transformation(extent={{22,-20},{42,0}})));
    Modelica.Blocks.Math.Feedback feedback3
      annotation (Placement(transformation(extent={{-40,-28},{-20,-8}})));
    Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysHeaRecHea1(
      uHigh=0.5,
      uLow=0,
      trueHoldDuration=60*15)
      "Hysteresis with delay to check for heating potential of return air"
      annotation (Placement(transformation(extent={{-12,-28},{8,-8}})));
    Modelica.Blocks.Logical.Or orHeaRec2
      annotation (Placement(transformation(extent={{160,-20},{180,0}})));
  protected
    Modelica.Blocks.Sources.Constant atm(final k=101325) "Atmospheric pressure"
      annotation (Placement(transformation(extent={{-100,-240},{-80,-220}})));
  equation
    connect(TRet, wetBul.TDryBul) annotation (Line(points={{-120,-160},{-80,-160},
            {-80,-182},{-61,-182}}, color={0,0,127}));
    connect(phiRet, wetBul.phi) annotation (Line(points={{-120,-200},{-88,-200},{
            -88,-190},{-61,-190}}, color={0,0,127}));
    connect(atm.y, wetBul.p) annotation (Line(points={{-79,-230},{-70,-230},{-70,
            -198},{-61,-198}}, color={0,0,127}));
    connect(feedback1.y, hysHeaRecCoo.u)
      annotation (Line(points={{-31,-160},{-22,-160}}, color={0,0,127}));
    connect(TOut, feedback1.u1) annotation (Line(points={{-120,-120},{-80,-120},{
            -80,-160},{-48,-160}}, color={0,0,127}));
    connect(wetBul.TWetBul, feedback1.u2) annotation (Line(points={{-39,-190},{
            -30,-190},{-30,-174},{-40,-174},{-40,-168}}, color={0,0,127}));
    connect(hysHeaRecCoo.y, andHeaRecCoo.u2) annotation (Line(points={{2,-160},{
            18,-160},{18,-158}}, color={255,0,255}));
    connect(cooSta, andHeaRecCoo.u1) annotation (Line(points={{-120,-80},{10,-80},
            {10,-150},{18,-150}}, color={255,0,255}));
    connect(feedback2.y, hysHeaRecHea.u)
      annotation (Line(points={{-41,-50},{-32,-50}}, color={0,0,127}));
    connect(TOut, feedback2.u2) annotation (Line(points={{-120,-120},{-80,-120},{
            -80,-72},{-50,-72},{-50,-58}}, color={0,0,127}));
    connect(TRet, feedback2.u1) annotation (Line(points={{-120,-160},{-86,-160},{
            -86,-50},{-58,-50}}, color={0,0,127}));
    connect(hysHeaRecHea.y, andHeaRecHea.u1)
      annotation (Line(points={{-8,-50},{8,-50}}, color={255,0,255}));
    connect(heaSta, andHeaRecHea.u2) annotation (Line(points={{-120,-40},{-70,-40},
            {-70,-62},{0,-62},{0,-58},{8,-58}}, color={255,0,255}));
    connect(orHeaRec.u1, andHeaRecHea.y) annotation (Line(points={{68,-40},{52,
            -40},{52,-50},{31,-50}}, color={255,0,255}));
    connect(andHeaRecCoo.y, evaCooSta) annotation (Line(points={{41,-150},{80,
            -150},{80,-80},{110,-80}}, color={255,0,255}));
    connect(not1.y, andDeaBan.u1)
      annotation (Line(points={{-39,-110},{-22,-110}}, color={255,0,255}));
    connect(not2.y, andDeaBan.u2) annotation (Line(points={{-39,-130},{-30,-130},
            {-30,-118},{-22,-118}}, color={255,0,255}));
    connect(heaSta, not1.u) annotation (Line(points={{-120,-40},{-70,-40},{-70,
            -110},{-62,-110}}, color={255,0,255}));
    connect(cooSta, not2.u) annotation (Line(points={{-120,-80},{-74,-80},{-74,
            -130},{-62,-130}}, color={255,0,255}));
    connect(andHeaRecCoo.y, orHeaRec.u2) annotation (Line(points={{41,-150},{60,
            -150},{60,-48},{68,-48}}, color={255,0,255}));
    connect(andDeaBan.y, andDeaBan1.u2) annotation (Line(points={{1,-110},{12,
            -110},{12,-118},{30,-118}}, color={255,0,255}));
    connect(pre.y, andDeaBan1.u1) annotation (Line(points={{50,-80},{54,-80},{54,
            -90},{20,-90},{20,-110},{30,-110}}, color={255,0,255}));
    connect(andDeaBan1.y, orHeaRec1.u2) annotation (Line(points={{53,-110},{70,
            -110},{70,-72},{102,-72},{102,-60},{122,-60}}, color={255,0,255}));
    connect(orHeaRec.y, orHeaRec1.u1) annotation (Line(points={{91,-40},{94,-40},
            {94,-52},{122,-52}}, color={255,0,255}));
    connect(cooSta, andHeaRecHea1.u1) annotation (Line(points={{-120,-80},{-92,
            -80},{-92,-10},{20,-10}}, color={255,0,255}));
    connect(TSetSupAirConst.y, feedback3.u1) annotation (Line(points={{-59,20},{
            -54,20},{-54,-18},{-38,-18}}, color={0,0,127}));
    connect(TOut, feedback3.u2) annotation (Line(points={{-120,-120},{-80,-120},{
            -80,-32},{-30,-32},{-30,-26}}, color={0,0,127}));
    connect(hysHeaRecHea1.y, andHeaRecHea1.u2)
      annotation (Line(points={{10,-18},{20,-18}}, color={255,0,255}));
    connect(feedback3.y, hysHeaRecHea1.u)
      annotation (Line(points={{-21,-18},{-14,-18}}, color={0,0,127}));
    connect(orHeaRec1.y, orHeaRec2.u2) annotation (Line(points={{145,-52},{152,
            -52},{152,-18},{158,-18}}, color={255,0,255}));
    connect(andHeaRecHea1.y, orHeaRec2.u1)
      annotation (Line(points={{43,-10},{158,-10}}, color={255,0,255}));
    connect(orHeaRec2.y, heaRecSta) annotation (Line(points={{181,-10},{196,-10},
            {196,6},{98,6},{98,-40},{110,-40}}, color={255,0,255}));
    connect(pre.u, heaRecSta) annotation (Line(points={{26,-80},{20,-80},{20,-62},
            {98,-62},{98,-40},{110,-40}}, color={255,0,255}));
    connect(heaSta, swiHea.u2) annotation (Line(points={{-120,-40},{-86,-40},{-86,
            2},{48,2},{48,20},{58,20}}, color={255,0,255}));
    annotation (Diagram(coordinateSystem(extent={{-100,-200},{100,100}})), Icon(
          coordinateSystem(extent={{-100,-200},{100,100}}), graphics={Rectangle(
            extent={{-100,100},{100,-200}},
            lineColor={0,0,129},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}));
  end SZDOASIECHR;

  package BaseClasses "Contains base classes for HVAC controls"
    extends Modelica.Icons.BasesPackage;

    model SZVAVBase "Base class controller for single zone VAV system"
      extends Modelica.Blocks.Icons.Block;

      parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
        "Design air flowrate of system";

      parameter Modelica.Units.SI.MassFlowRate minAirFlo
        "Minimum air flowrate of system" annotation (Dialog(group="Air design"));

      parameter Modelica.Units.SI.MassFlowRate minOutAirFlo
        "Minimum outdoor air flowrate" annotation (Dialog(group="Air design"));

      parameter Boolean ventilation_source = true "Source for ventilation air";

      parameter Modelica.Units.SI.Temperature TSetSupAir
        "Cooling supply air temperature setpoint"
        annotation (Dialog(group="Air design"));

      parameter Real kHea(min=Modelica.Constants.small) = 1
        "Gain of heating controller"
        annotation(Dialog(group="Control gain"));

      parameter Real kCoo(min=Modelica.Constants.small)=1
        "Gain of controller for cooling valve"
        annotation(Dialog(group="Control gain"));

      parameter Real kFan(min=Modelica.Constants.small) = 0.5
        "Gain of controller for fan"
        annotation(Dialog(group="Control gain"));

      parameter Real kEco(min=Modelica.Constants.small) = 4
        "Gain of controller for economizer"
        annotation(Dialog(group="Control gain"));

      Modelica.Blocks.Interfaces.RealInput TRoo(
        final unit="K",
        displayUnit="degC") "Zone temperature measurement"
      annotation (Placement(
            transformation(
            extent={{-20,-20},{20,20}},
            origin={-120,-60})));

      Modelica.Blocks.Interfaces.RealInput TSetRooCoo(
        final unit="K",
        displayUnit="degC")
        "Zone cooling setpoint temperature" annotation (Placement(transformation(
            extent={{20,-20},{-20,20}},
            rotation=180,
            origin={-120,60})));
      Modelica.Blocks.Interfaces.RealInput TSetRooHea(
        final unit="K",
        displayUnit="degC")
        "Zone heating setpoint temperature" annotation (Placement(transformation(
            extent={{20,-20},{-20,20}},
            rotation=180,
            origin={-120,100})));

      Modelica.Blocks.Interfaces.RealInput TMix(
        final unit="K",
        displayUnit="degC")
        "Measured mixed air temperature"
        annotation (Placement(transformation(extent={{-140,0},{-100,40}})));

      Modelica.Blocks.Interfaces.RealInput TSup(
        final unit="K",
        displayUnit="degC")
        "Measured supply air temperature after the cooling coil"
        annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));

      Modelica.Blocks.Interfaces.RealInput TOut(
        final unit="K",
        displayUnit="degC")
        "Measured outside air temperature"
        annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));

      Modelica.Blocks.Interfaces.RealOutput yHea(final unit="1") "Control signal for heating coil"
        annotation (Placement(transformation(extent={{100,50},{120,70}})));

      Modelica.Blocks.Interfaces.RealOutput yFan(final unit="1")
        "Control signal for fan"
        annotation (Placement(transformation(extent={{100,80},{120,100}})));

      Modelica.Blocks.Interfaces.RealOutput yOutAirFra(final unit="1")
        "Control signal for outside air fraction"
        annotation (Placement(transformation(extent={{100,20},{120,40}})));

      Modelica.Blocks.Interfaces.RealOutput yCooCoiVal(final unit="1")
        "Control signal for cooling coil valve"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));

      Buildings.Air.Systems.SingleZone.VAV.BaseClasses.ControllerHeatingFan conSup(
        kHea=kHea,
        kFan=kFan,
        minAirFlo=minAirFlo/m_flow_nominal)
                   "Heating coil, cooling coil and fan controller"
        annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
      ControllerEconomizer                                                  conEco(final
          kEco=kEco) "Economizer control"
        annotation (Placement(transformation(extent={{40,40},{60,60}})));

      Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysChiPla(uLow=-1, uHigh=0)
        "Hysteresis to switch on cooling"
        annotation (Placement(transformation(extent={{40,-50},{60,-30}})));

      Modelica.Blocks.Math.Feedback errTRooCoo
        "Control error on room temperature for cooling"
        annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
      Buildings.Controls.Continuous.LimPID conCooVal(
        controllerType=Modelica.Blocks.Types.SimpleController.P,
        final yMax=1,
        final yMin=0,
        final k=kCoo,
        reverseActing=not (true)) "Cooling coil valve controller"
        annotation (Placement(transformation(extent={{0,-30},{20,-10}})));

      Modelica.Blocks.Logical.Switch swiCoo "Switch for turning cooling on and off"
        annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
      Modelica.Blocks.Interfaces.BooleanInput occSta
        "Indicates occupancy or standby mode"
        annotation (Placement(transformation(extent={{-140,120},{-100,160}})));
      Modelica.Blocks.Logical.Switch swiMinOA
        "Switch for minimum outside air requirements"
        annotation (Placement(transformation(extent={{12,10},{32,30}})));
      Modelica.Blocks.Logical.Switch swiFan "Switch for turning fan on or off"
        annotation (Placement(transformation(extent={{60,120},{80,140}})));
      Modelica.Blocks.Logical.Or orHeaCoo
        annotation (Placement(transformation(extent={{10,100},{30,120}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput cooSta
        "Cooling status signal"
        annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
      Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput heaSta
        "Heating status signal"
        annotation (Placement(transformation(extent={{100,-150},{120,-130}})));
      Modelica.Blocks.Sources.RealExpression minEcoPosCal(y=min(1.0, minOutAirFlo/
            max(1e-5*m_flow_nominal, (swiFan.y*m_flow_nominal))))
        annotation (Placement(transformation(extent={{-68,38},{-48,58}})));

      Modelica.Blocks.Logical.Or orHeaCoo1
        annotation (Placement(transformation(extent={{32,148},{52,168}})));
      Modelica.Blocks.Logical.And and1
        annotation (Placement(transformation(extent={{-32,160},{-12,180}})));
      Modelica.Blocks.Sources.BooleanConstant conVen(k=ventilation_source)
        annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
      Modelica.Blocks.Logical.Switch swiHea
        "Switch for turning heating coil on and off"
        annotation (Placement(transformation(extent={{60,70},{80,90}})));
      Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysHeaPla(uLow=-0.5, uHigh=0.5)
        "Hysteresis to switch on heating"
        annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
      Modelica.Blocks.Math.Feedback errTRooHea
        "Control error on room temperature for heating"
        annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
    protected
      Modelica.Blocks.Sources.Constant TSetSupAirConst(
        final k=TSetSupAir) "Set point for supply air temperature"
        annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

      Modelica.Blocks.Sources.Constant off(final k=0) "No cooling"
        annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
    equation
      connect(TSetSupAirConst.y, conEco.TMixSet) annotation (Line(points={{-39,-20},
              {-20,-20},{-20,58},{39,58}}, color={0,0,127}));
      connect(errTRooCoo.y, hysChiPla.u) annotation (Line(points={{-41,-60},{0,-60},
              {0,-40},{38,-40}},                           color={0,0,127}));
      connect(TSetRooCoo, errTRooCoo.u2) annotation (Line(points={{-120,60},{-80,60},
              {-80,-80},{-50,-80},{-50,-68}}, color={0,0,127}));
      connect(errTRooCoo.u1, TRoo) annotation (Line(points={{-58,-60},{-120,-60}},
                          color={0,0,127}));
      connect(TSetSupAirConst.y,conCooVal. u_s)
        annotation (Line(points={{-39,-20},{-2,-20}},        color={0,0,127}));
      connect(conSup.TSetRooHea, TSetRooHea) annotation (Line(points={{-41,86},{-88,
              86},{-88,100},{-120,100}},
                                       color={0,0,127}));
      connect(conSup.TSetRooCoo, TSetRooCoo) annotation (Line(points={{-41,80},{-80,
              80},{-80,60},{-120,60}}, color={0,0,127}));
      connect(conSup.TRoo, TRoo) annotation (Line(points={{-41,74},{-74,74},{-74,
              -60},{-120,-60}},
                           color={0,0,127}));
      connect(conEco.TMix, TMix) annotation (Line(points={{39,55},{-40,55},{-40,20},
              {-120,20}}, color={0,0,127}));
      connect(conEco.TRet, TRoo) annotation (Line(points={{39,52},{-34,52},{-34,12},
              {-88,12},{-88,-60},{-120,-60}},     color={0,0,127}));
      connect(conEco.TOut, TOut) annotation (Line(points={{39,45},{-30,45},{-30,8},{
              -94,8},{-94,-20},{-120,-20}},    color={0,0,127}));
      connect(conEco.yOutAirFra, yOutAirFra) annotation (Line(points={{61,50},{80,50},
              {80,30},{110,30}}, color={0,0,127}));
      connect(conCooVal.u_m, TSup)
        annotation (Line(points={{10,-32},{10,-100},{-120,-100}},
                                                                color={0,0,127}));
      connect(hysChiPla.y, swiCoo.u2)
        annotation (Line(points={{62,-40},{68,-40}}, color={255,0,255}));
      connect(conCooVal.y, swiCoo.u1) annotation (Line(points={{21,-20},{62,-20},{
              62,-32},{68,-32}},
                              color={0,0,127}));
      connect(swiCoo.y, yCooCoiVal) annotation (Line(points={{91,-40},{96,-40},{96,0},
              {110,0}}, color={0,0,127}));
      connect(off.y, swiCoo.u3) annotation (Line(points={{-9,-80},{62,-80},{62,-48},
              {68,-48}}, color={0,0,127}));
      connect(hysChiPla.y, conEco.cooSta) annotation (Line(points={{62,-40},{64,-40},
              {64,0},{-10,0},{-10,42},{39,42}},
                                         color={255,0,255}));
      connect(swiMinOA.y, conEco.minOAFra) annotation (Line(points={{33,20},{36,20},
              {36,48},{39,48}}, color={0,0,127}));
      connect(occSta, swiMinOA.u2) annotation (Line(points={{-120,140},{-6,140},{-6,
              20},{10,20}}, color={255,0,255}));
      connect(off.y, swiMinOA.u3) annotation (Line(points={{-9,-80},{-4,-80},{-4,12},
              {10,12}}, color={0,0,127}));
      connect(swiFan.y, yFan) annotation (Line(points={{81,130},{90,130},{90,90},{110,
              90}}, color={0,0,127}));
      connect(conSup.yFan, swiFan.u1) annotation (Line(points={{-19,84},{-2,84},{-2,
              138},{58,138}}, color={0,0,127}));
      connect(off.y, swiFan.u3) annotation (Line(points={{-9,-80},{34,-80},{34,122},
              {58,122}}, color={0,0,127}));
      connect(orHeaCoo.u2, conEco.cooSta) annotation (Line(points={{8,102},{4,102},{
              4,0},{-10,0},{-10,42},{39,42}}, color={255,0,255}));
      connect(hysChiPla.y, cooSta) annotation (Line(points={{62,-40},{64,-40},{64,
              -100},{110,-100}}, color={255,0,255}));
      connect(minEcoPosCal.y, swiMinOA.u1) annotation (Line(points={{-47,48},{-4,48},
              {-4,28},{10,28}}, color={0,0,127}));
      connect(orHeaCoo.y, orHeaCoo1.u2) annotation (Line(points={{31,110},{30,110},
              {30,150}},          color={255,0,255}));
      connect(conVen.y, and1.u1) annotation (Line(points={{-59,170},{-34,170}},
                         color={255,0,255}));
      connect(and1.u2, swiMinOA.u2) annotation (Line(points={{-34,162},{-50,162},{
              -50,140},{-6,140},{-6,20},{10,20}}, color={255,0,255}));
      connect(and1.y, orHeaCoo1.u1) annotation (Line(points={{-11,170},{8,170},{8,
              158},{30,158}}, color={255,0,255}));
      connect(orHeaCoo1.y, swiFan.u2) annotation (Line(points={{53,158},{60,158},{
              60,144},{48,144},{48,130},{58,130}}, color={255,0,255}));
      connect(conSup.yHea, swiHea.u1) annotation (Line(points={{-19,76},{46,76},{46,
              88},{58,88}}, color={0,0,127}));
      connect(swiHea.y, yHea) annotation (Line(points={{81,80},{90,80},{90,60},{110,
              60}}, color={0,0,127}));
      connect(swiHea.u3, swiFan.u3) annotation (Line(points={{58,72},{34,72},{34,
              122},{58,122}}, color={0,0,127}));
      connect(errTRooHea.y, hysHeaPla.u) annotation (Line(points={{-61,110},{-42,
              110}},                 color={0,0,127}));
      connect(TSetRooHea, errTRooHea.u1) annotation (Line(points={{-120,100},{-88,
              100},{-88,110},{-78,110}},
                                    color={0,0,127}));
      connect(hysHeaPla.y, orHeaCoo.u1)
        annotation (Line(points={{-18,110},{8,110}}, color={255,0,255}));
      connect(hysHeaPla.y, heaSta) annotation (Line(points={{-18,110},{-8,110},{-8,
              -140},{110,-140}},
                           color={255,0,255}));
      connect(TRoo, errTRooHea.u2) annotation (Line(points={{-120,-60},{-74,-60},{
              -74,92},{-70,92},{-70,102}}, color={0,0,127}));
      connect(hysHeaPla.y, swiHea.u2) annotation (Line(points={{-18,110},{-8,110},{
              -8,80},{58,80}}, color={255,0,255}));
      annotation (Icon(coordinateSystem(extent={{-100,-140},{100,220}}),
                       graphics={Line(points={{-100,-100},{0,2},{-100,100}}, color=
                  {0,0,0}), Rectangle(
              extent={{-100,220},{100,-140}},
              lineColor={0,0,129},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid)}),
                              Documentation(info="<html>
<p>
This is the controller for the VAV system with economizer, heating coil and cooling coil.
</p>
</html>",     revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
        Diagram(coordinateSystem(extent={{-100,-140},{100,220}})));
    end SZVAVBase;

    model ControllerEconomizer "Controller for economizer"
      extends Modelica.Blocks.Icons.Block;

      parameter Real kEco(min=Modelica.Constants.small) = 1
        "Gain of controller"
        annotation(Dialog(group="Control gain"));

      Modelica.Blocks.Interfaces.RealInput TMixSet(
        final unit="K",
        displayUnit="degC")
        "Mixed air setpoint temperature"
        annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
      Modelica.Blocks.Interfaces.RealInput TMix(
        final unit="K",
        displayUnit="degC")
        "Measured mixed air temperature"
        annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

      Modelica.Blocks.Interfaces.RealInput TOut(
        final unit="K",
        displayUnit="degC")
        "Measured outside air temperature"
        annotation (Placement(
            transformation(extent={{-120,-60},{-100,-40}})));

      Modelica.Blocks.Interfaces.RealInput TRet(
        final unit="K",
        displayUnit="degC")
        "Return air temperature"
        annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

      Modelica.Blocks.Interfaces.RealInput minOAFra(
        min = 0,
        max = 1,
        final unit="1")
        "Minimum outside air fraction"
        annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));

      Modelica.Blocks.Interfaces.RealOutput yOutAirFra(final unit="1")
        "Control signal for outside air fraction"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));

      Modelica.Blocks.Nonlinear.VariableLimiter Limiter(strict=true)
        "Signal limiter"
        annotation (Placement(transformation(extent={{60,-10},{80,10}})));
      Modelica.Blocks.Sources.Constant const(final k=1)
        "Constant output signal with value 1"
        annotation (Placement(transformation(extent={{20,60},{40,80}})));

      Modelica.Blocks.Logical.Switch switch1 "Switch to select control output"
        annotation (Placement(transformation(extent={{20,10},{40,30}})));

      Modelica.Blocks.MathBoolean.And and1(final nu=3) "Logical and"
        annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
      Buildings.Controls.Continuous.LimPID con(
        final k=kEco,
        final yMax=Modelica.Constants.inf,
        final yMin=-Modelica.Constants.inf,
        controllerType=Modelica.Blocks.Types.SimpleController.P,
        reverseActing=not (true)) "Controller"
        annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
      Modelica.Blocks.Math.Feedback feedback "Control error"
        annotation (Placement(transformation(extent={{-50,-38},{-30,-18}})));
      Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysTMix(
        uLow=-0.5,
        uHigh=0.5,
        trueHoldDuration=60*15)
        "Hysteresis with delay for mixed air temperature"
        annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

      Modelica.Blocks.Math.Feedback feedback1
        annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
      Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysCooPot(
        uHigh=0.5,
        uLow=0,
        trueHoldDuration=60*15)
        "Hysteresis with delay to check for cooling potential of outside air"
        annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
      Modelica.Blocks.Interfaces.BooleanInput cooSta "Status of cooling"
        annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
    equation
      connect(Limiter.limit2, minOAFra) annotation (Line(points={{58,-8},{-20,-8},{
              -20,-8},{-94,-8},{-94,-20},{-110,-20},{-110,-20}},
                                    color={0,0,127}));
      connect(const.y, Limiter.limit1) annotation (Line(points={{41,70},{50,70},{50,
              8},{58,8}},           color={0,0,127}));
      connect(minOAFra, switch1.u3) annotation (Line(points={{-110,-20},{-94,-20},{
              -94,12},{18,12}},  color={0,0,127}));
      connect(switch1.y, Limiter.u) annotation (Line(points={{41,20},{46,20},{46,0},
              {58,0}},          color={0,0,127}));
      connect(and1.y, switch1.u2) annotation (Line(points={{41.5,-50},{48,-50},{48,
              -6},{10,-6},{10,20},{18,20}},
                                         color={255,0,255}));
      connect(con.u_s, TMixSet)
        annotation (Line(points={{-92,80},{-92,80},{-110,80}}, color={0,0,127}));
      connect(TMix, con.u_m)
        annotation (Line(points={{-110,50},{-80,50},{-80,68}}, color={0,0,127}));
      connect(con.y, switch1.u1) annotation (Line(points={{-69,80},{12,80},{12,28},
              {18,28}}, color={0,0,127}));
      connect(TOut, feedback.u2) annotation (Line(points={{-110,-50},{-40,-50},{-40,
              -36}}, color={0,0,127}));
      connect(feedback.u1, TMix) annotation (Line(points={{-48,-28},{-80,-28},{-80,
              50},{-110,50}}, color={0,0,127}));
      connect(Limiter.y, yOutAirFra)
        annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
      connect(feedback.y, hysTMix.u)
        annotation (Line(points={{-31,-28},{-28,-28},{-28,-50},{-22,-50}},
                                                       color={0,0,127}));
      connect(feedback1.u1, TRet)
        annotation (Line(points={{-68,30},{-88,30},{-88,20},{-110,20}},
                                                      color={0,0,127}));
      connect(feedback1.u2,TOut)
        annotation (Line(points={{-60,22},{-60,-50},{-110,-50}}, color={0,0,127}));
      connect(feedback1.y, hysCooPot.u)
        annotation (Line(points={{-51,30},{-42,30}}, color={0,0,127}));
      connect(hysCooPot.y, and1.u[1]) annotation (Line(points={{-18,30},{6,30},{6,
              -45.3333},{20,-45.3333}}, color={255,0,255}));
      connect(hysTMix.y, and1.u[2])
        annotation (Line(points={{2,-50},{20,-50},{20,-50}}, color={255,0,255}));
      connect(cooSta, and1.u[3]) annotation (Line(points={{-110,-80},{6,-80},{6,
              -54.6667},{20,-54.6667}}, color={255,0,255}));
      annotation (    Documentation(info="<html>
<p>
Economizer controller.
</p>
</html>",     revisions="<html>
<ul>
<li>
June 21, 2017, by Michael Wetter:<br/>
Refactored implementation.
</li>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
    end ControllerEconomizer;

    model SZDOASBase "Base controls for single zone DOAS system with heating coil"
      extends Modelica.Blocks.Icons.Block;
      parameter Modelica.Units.SI.Temperature TSetSupAir
        "Cooling supply air temperature setpoint"
        annotation (Dialog(group="Air design"));
      parameter Real kHea(min=Modelica.Constants.small) = 2
        "Gain of heating controller"
        annotation(Dialog(group="Control gain"));
      Modelica.Blocks.Interfaces.BooleanInput occSta
        "Indicates occupancy or standby mode"
        annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
      Buildings.Controls.Continuous.LimPID conHea(
        controllerType=Modelica.Blocks.Types.SimpleController.P,
        final yMax=1,
        final yMin=0,
        final k=kHea,
        reverseActing=not (false)) "Heating coil controller"
        annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
      Modelica.Blocks.Interfaces.RealInput TSup "Supply air temperature"
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
      Modelica.Blocks.Logical.Switch swiFan "Switch for turning fan on or off"
        annotation (Placement(transformation(extent={{60,60},{80,80}})));
      Modelica.Blocks.Interfaces.RealOutput yFan(final unit="1")
        "Control signal for fan"
        annotation (Placement(transformation(extent={{100,50},{120,70}})));
      Modelica.Blocks.Interfaces.RealOutput yHea(final unit="1")
        "Control signal for heating coil"
        annotation (Placement(transformation(extent={{100,10},{120,30}})));
      Modelica.Blocks.Logical.Switch swiHea "Switch for turning heating on and off"
        annotation (Placement(transformation(extent={{60,10},{80,30}})));
    protected
      Modelica.Blocks.Sources.Constant TSetSupAirConst(final k=TSetSupAir)
        "Set point for supply air temperature"
        annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    protected
      Modelica.Blocks.Sources.Constant off(final k=0) "Off signal"
        annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
    protected
      Modelica.Blocks.Sources.Constant On(final k=1) "On signal"
        annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
    equation
      connect(TSetSupAirConst.y, conHea.u_s)
        annotation (Line(points={{-59,20},{-42,20}},  color={0,0,127}));
      connect(conHea.u_m, TSup)
        annotation (Line(points={{-30,8},{-30,0},{-120,0}},     color={0,0,127}));
      connect(swiFan.y, yFan) annotation (Line(points={{81,70},{88,70},{88,60},{110,
              60}}, color={0,0,127}));
      connect(off.y, swiFan.u3) annotation (Line(points={{-59,50},{-10,50},{-10,62},
              {58,62}}, color={0,0,127}));
      connect(On.y, swiFan.u1) annotation (Line(points={{-59,90},{-10,90},{-10,78},
              {58,78}}, color={0,0,127}));
      connect(occSta, swiFan.u2) annotation (Line(points={{-120,80},{-90,80},{-90,
              70},{58,70}}, color={255,0,255}));
      connect(swiHea.y, yHea)
        annotation (Line(points={{81,20},{110,20}}, color={0,0,127}));
      connect(conHea.y, swiHea.u1) annotation (Line(points={{-19,20},{20,20},{20,28},
              {58,28}}, color={0,0,127}));
      connect(off.y, swiHea.u3) annotation (Line(points={{-59,50},{40,50},{40,12},{
              58,12}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end SZDOASBase;

    model IECHR "Control class for IECHR"
      parameter Modelica.Units.SI.Temperature TSetSupAir
        "Cooling supply air temperature setpoint"
        annotation (Dialog(group="Air design"));
      Buildings.Utilities.Psychrometrics.TWetBul_TDryBulPhi wetBul(redeclare
          package Medium = Buildings.Media.Air)
        annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
      Modelica.Blocks.Math.Feedback feedback1
        annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
      Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysHeaRecCoo(
        uHigh=0.5,
        uLow=0,
        trueHoldDuration=60*15)
        "Hysteresis with delay to check for cooling potential of return air"
        annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
      Modelica.Blocks.Logical.And andHeaRecCoo
        annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
      Modelica.Blocks.Math.Feedback feedback2
        annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
      Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysHeaRecHea(
        uHigh=0.5,
        uLow=0,
        trueHoldDuration=60*15)
        "Hysteresis with delay to check for heating potential of return air"
        annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
      Modelica.Blocks.Logical.And andHeaRecHea
        annotation (Placement(transformation(extent={{10,60},{30,80}})));
      Modelica.Blocks.Logical.Or orHeaRec
        annotation (Placement(transformation(extent={{70,70},{90,90}})));
      Modelica.Blocks.Logical.And andDeaBan
        annotation (Placement(transformation(extent={{-20,0},{0,20}})));
      Modelica.Blocks.Logical.Not not1
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Modelica.Blocks.Logical.Not not2
        annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
      Buildings.Controls.OBC.CDL.Logical.Pre pre
        annotation (Placement(transformation(extent={{28,30},{48,50}})));
      Modelica.Blocks.Logical.And andDeaBan1
        annotation (Placement(transformation(extent={{32,0},{52,20}})));
      Modelica.Blocks.Logical.Or orHeaRec1
        annotation (Placement(transformation(extent={{124,58},{144,78}})));
      Modelica.Blocks.Logical.And andHeaRecHea1
        annotation (Placement(transformation(extent={{22,100},{42,120}})));
      Modelica.Blocks.Math.Feedback feedback3
        annotation (Placement(transformation(extent={{-40,92},{-20,112}})));
      Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysHeaRecHea1(
        uHigh=0.5,
        uLow=0,
        trueHoldDuration=60*15)
        "Hysteresis with delay to check for heating potential of return air"
        annotation (Placement(transformation(extent={{-12,92},{8,112}})));
      Modelica.Blocks.Logical.Or orHeaRec2
        annotation (Placement(transformation(extent={{160,100},{180,120}})));
      Modelica.Blocks.Interfaces.BooleanOutput heaRecSta
        "Heat recovery status signal"
        annotation (Placement(transformation(extent={{100,70},{120,90}})));
      Modelica.Blocks.Interfaces.BooleanOutput evaCooSta
        "Evaporative cooling status signal"
        annotation (Placement(transformation(extent={{100,30},{120,50}})));
      Modelica.Blocks.Interfaces.BooleanInput heaSta "Heating status signal"
        annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
      Modelica.Blocks.Interfaces.BooleanInput cooSta "Cooling status signal"
        annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
      Modelica.Blocks.Interfaces.RealInput TOut "Outside air drybulb temperature"
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
      Modelica.Blocks.Interfaces.RealInput TRet "Return air drybulb temperature"
        annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
      Modelica.Blocks.Interfaces.RealInput phiRet "Return air relative humidity"
        annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
    protected
      Modelica.Blocks.Sources.Constant atm(final k=101325) "Atmospheric pressure"
        annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
    equation
      connect(TRet,wetBul. TDryBul) annotation (Line(points={{-120,-40},{-86,-40},{
              -86,-62},{-61,-62}},    color={0,0,127}));
      connect(phiRet,wetBul. phi) annotation (Line(points={{-120,-80},{-88,-80},{-88,
              -70},{-61,-70}},       color={0,0,127}));
      connect(atm.y,wetBul. p) annotation (Line(points={{-79,-110},{-70,-110},{-70,-78},
              {-61,-78}},        color={0,0,127}));
      connect(feedback1.y,hysHeaRecCoo. u)
        annotation (Line(points={{-31,-40},{-22,-40}},   color={0,0,127}));
      connect(TOut,feedback1. u1) annotation (Line(points={{-120,0},{-80,0},{-80,-40},
              {-48,-40}},            color={0,0,127}));
      connect(wetBul.TWetBul,feedback1. u2) annotation (Line(points={{-39,-70},{-30,
              -70},{-30,-54},{-40,-54},{-40,-48}},         color={0,0,127}));
      connect(hysHeaRecCoo.y,andHeaRecCoo. u2) annotation (Line(points={{2,-40},{18,
              -40},{18,-38}},      color={255,0,255}));
      connect(cooSta,andHeaRecCoo. u1) annotation (Line(points={{-120,40},{10,40},{10,
              -30},{18,-30}},       color={255,0,255}));
      connect(feedback2.y,hysHeaRecHea. u)
        annotation (Line(points={{-41,70},{-32,70}},   color={0,0,127}));
      connect(TOut,feedback2. u2) annotation (Line(points={{-120,0},{-80,0},{-80,48},
              {-50,48},{-50,62}},            color={0,0,127}));
      connect(TRet,feedback2. u1) annotation (Line(points={{-120,-40},{-86,-40},{-86,
              70},{-58,70}},       color={0,0,127}));
      connect(hysHeaRecHea.y,andHeaRecHea. u1)
        annotation (Line(points={{-8,70},{8,70}},   color={255,0,255}));
      connect(heaSta,andHeaRecHea. u2) annotation (Line(points={{-120,80},{-70,80},{
              -70,58},{0,58},{0,62},{8,62}},      color={255,0,255}));
      connect(orHeaRec.u1,andHeaRecHea. y) annotation (Line(points={{68,80},{52,80},
              {52,70},{31,70}},        color={255,0,255}));
      connect(andHeaRecCoo.y,evaCooSta)  annotation (Line(points={{41,-30},{80,-30},
              {80,40},{110,40}},         color={255,0,255}));
      connect(not1.y,andDeaBan. u1)
        annotation (Line(points={{-39,10},{-22,10}},     color={255,0,255}));
      connect(not2.y,andDeaBan. u2) annotation (Line(points={{-39,-10},{-30,-10},{-30,
              2},{-22,2}},            color={255,0,255}));
      connect(heaSta,not1. u) annotation (Line(points={{-120,80},{-70,80},{-70,10},{
              -62,10}},          color={255,0,255}));
      connect(cooSta,not2. u) annotation (Line(points={{-120,40},{-74,40},{-74,-10},
              {-62,-10}},        color={255,0,255}));
      connect(andHeaRecCoo.y,orHeaRec. u2) annotation (Line(points={{41,-30},{60,-30},
              {60,72},{68,72}},         color={255,0,255}));
      connect(andDeaBan.y,andDeaBan1. u2) annotation (Line(points={{1,10},{12,10},{12,
              2},{30,2}},                 color={255,0,255}));
      connect(pre.y,andDeaBan1. u1) annotation (Line(points={{50,40},{54,40},{54,30},
              {20,30},{20,10},{30,10}},           color={255,0,255}));
      connect(andDeaBan1.y,orHeaRec1. u2) annotation (Line(points={{53,10},{70,10},{
              70,48},{102,48},{102,60},{122,60}},            color={255,0,255}));
      connect(orHeaRec.y,orHeaRec1. u1) annotation (Line(points={{91,80},{94,80},{94,
              68},{122,68}},       color={255,0,255}));
      connect(cooSta,andHeaRecHea1. u1) annotation (Line(points={{-120,40},{-92,40},
              {-92,110},{20,110}},      color={255,0,255}));
      connect(hysHeaRecHea1.y,andHeaRecHea1. u2)
        annotation (Line(points={{10,102},{20,102}}, color={255,0,255}));
      connect(feedback3.y,hysHeaRecHea1. u)
        annotation (Line(points={{-21,102},{-14,102}}, color={0,0,127}));
      connect(orHeaRec1.y,orHeaRec2. u2) annotation (Line(points={{145,68},{152,68},
              {152,102},{158,102}},      color={255,0,255}));
      connect(andHeaRecHea1.y,orHeaRec2. u1)
        annotation (Line(points={{43,110},{158,110}}, color={255,0,255}));
      connect(orHeaRec2.y,heaRecSta)  annotation (Line(points={{181,110},{196,110},{
              196,126},{98,126},{98,80},{110,80}},color={255,0,255}));
      connect(pre.u,heaRecSta)  annotation (Line(points={{26,40},{20,40},{20,58},{98,
              58},{98,80},{110,80}},        color={255,0,255}));
      connect(TRet, feedback3.u2) annotation (Line(points={{-120,-40},{-86,-40},{
              -86,88},{-30,88},{-30,94}}, color={0,0,127}));
      connect(feedback3.u1, feedback2.u2) annotation (Line(points={{-38,102},{-80,
              102},{-80,48},{-50,48},{-50,62}}, color={0,0,127}));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end IECHR;

    block OnOffController "On-off controller"
      extends Modelica.Blocks.Icons.PartialBooleanBlock;
      Modelica.Blocks.Interfaces.RealInput reference
        "Connector of Real input signal used as reference signal"
        annotation (Placement(transformation(extent={{-140,80},{-100,40}})));
      Modelica.Blocks.Interfaces.RealInput u
        "Connector of Real input signal used as measurement signal"
        annotation (Placement(transformation(extent={{-140,-40},{-100,-80}})));
      Modelica.Blocks.Interfaces.BooleanOutput y
        "Connector of Real output signal used as actuator signal"
        annotation (Placement(transformation(extent={{100,-10},{120,10}})));

      Modelica.Blocks.Interfaces.RealOutput diff
        "Connector of Real output signal used as debug signal"
        annotation (Placement(transformation(extent={{100,-58},{120,-38}}),
            iconTransformation(extent={{100,-58},{120,-38}})));

      parameter Real bandwidth(start=0.1) "Bandwidth around reference signal";
      parameter Boolean pre_y_start=false "Value of pre(y) at initial time";


    initial equation
      pre(y) = pre_y_start;
    equation
      diff = u-(reference - bandwidth/2);
      y = (pre(y) and (u < (reference + bandwidth/2))) or (u < (reference - bandwidth/
        2));

      annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
                -100},{100,100}}), graphics={
            Text(
              extent={{-92,74},{44,44}},
              textString="reference"),
            Text(
              extent={{-94,-52},{-34,-74}},
              textString="u"),
            Line(points={{-76,-32},{-68,-6},{-50,26},{-24,40},{-2,42},{16,36},{32,28},{48,12},{58,-6},{68,-28}},
              color={0,0,127}),
            Line(points={{-78,-2},{-6,18},{82,-12}},
              color={255,0,0}),
            Line(points={{-78,12},{-6,30},{82,0}}),
            Line(points={{-78,-16},{-6,4},{82,-26}}),
            Line(points={{-82,-18},{-56,-18},{-56,-40},{64,-40},{64,-20},{90,-20}},
              color={255,0,255})}), Documentation(info="<html>
<p>The block OnOffController sets the output signal <strong>y</strong> to <strong>true</strong> when
the input signal <strong>u</strong> falls below the <strong>reference</strong> signal minus half of
the bandwidth and sets the output signal <strong>y</strong> to <strong>false</strong> when the input
signal <strong>u</strong> exceeds the <strong>reference</strong> signal plus half of the bandwidth.</p>
</html>"));
    end OnOffController;
  end BaseClasses;

  model StateControlHotWaterConfig1
    Modelica.Blocks.Interfaces.IntegerInput u
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.IntegerOutput yHeaPum
      annotation (Placement(transformation(extent={{100,90},{120,110}})));
    Modelica.Blocks.Interfaces.IntegerOutput yTes
      annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
    Modelica.Blocks.Interfaces.IntegerOutput yPor
      annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusHeaPum
      annotation (Placement(transformation(extent={{100,70},{120,90}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusTes
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.BooleanOutput statusPor
      annotation (Placement(transformation(extent={{100,-110},{120,-90}})));

  equation
    if u == 1 then // Charge TES with HeaPum
      statusTes = true;
      statusHeaPum = true;
      statusPor = false;
      yTes = 1;
      yHeaPum = 1;
      yPor = 1;
    elseif u == 2 then // Supply Port with TES
      statusTes = true;
      statusPor = true;
      statusHeaPum = false;
      yTes = 2;
      yPor = 2;
      yHeaPum = 2;
    elseif u == 3 then // Supply Port with HeaPum
      statusHeaPum = true;
      statusPor = true;
      statusTes = false;
      yHeaPum = 2;
      yPor = 1;
      yTes = 1;
    else
      assert(false, "Control state is outside of range.");
      statusTes = true;
      statusHeaPum = true;
      statusPor = false;
      yTes = 2;
      yHeaPum = 1;
      yPor = 1;
    end if;
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end StateControlHotWaterConfig1;

  model StateScheduleHotWaterHeatpumpOnly
    "Schedule for charging and activation of pcm TES."
    Modelica.Blocks.Math.RealToInteger realToInteger
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Modelica.Blocks.Interfaces.IntegerOutput y
      "Connector of Integer output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads staSchConfig1(
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments, table=[0,3;
          7.5*3600,3; 15*3600,3; 18.5*3600,3; 24*3600,3])
      "State schedule for configuration 1"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(realToInteger.y, y)
      annotation (Line(points={{81,0},{110,0}}, color={255,127,0}));
    connect(staSchConfig1.y[1], realToInteger.u)
      annotation (Line(points={{11,0},{58,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5)}),                 Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end StateScheduleHotWaterHeatpumpOnly;

  model StateScheduleHotWaterSimple
    "Schedule for charging and activation of pcm TES."
    parameter Modelica.Units.SI.Temperature TSol "Solidus temperature of PCM";
    parameter Modelica.Units.SI.Temperature TLiq "Liquidus temperature of PCM";
    Modelica.Blocks.Math.RealToInteger realToInteger
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Modelica.Blocks.Interfaces.IntegerOutput y
      "Connector of Integer output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads staSchConfig1(
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments, table=[0,3;
          6*3600,2; 9*3600,1; 17*3600,3; 24*3600,3])
      "State schedule for configuration 1"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Logical.Hysteresis hysteresis1(
      uLow=TSol + 1,
      uHigh=TLiq + 1,
      pre_y_start=true)
      annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
    Modelica.Blocks.Logical.LessEqualThreshold
                                          lessEqualThreshold(threshold=1.0)
      annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
    Modelica.Blocks.Sources.Constant staSweCoo1(k=3)
      annotation (Placement(transformation(extent={{30,-66},{50,-46}})));
    Modelica.Blocks.Logical.Switch swi2
      annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
    Modelica.Blocks.Logical.And and2 "If charging but not able to"
      annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
    Modelica.Blocks.Logical.Switch swi1
      "If charging storage, and TES fills up, switch to supply port with heatpump"
      annotation (Placement(transformation(extent={{110,-40},{130,-20}})));
    Modelica.Blocks.Interfaces.RealInput Ttes
      "Temperature of thermal energy storage"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Logical.GreaterEqualThreshold
                                          greaterEqualThreshold(threshold=2.0)
      annotation (Placement(transformation(extent={{30,80},{50,100}})));
    Modelica.Blocks.Logical.Hysteresis hysteresis2(
      uLow=TSol - 2,
      uHigh=TSol - 1,
      pre_y_start=true)
      annotation (Placement(transformation(extent={{-20,80},{0,100}})));
    Modelica.Blocks.Logical.And and1
      annotation (Placement(transformation(extent={{70,40},{90,60}})));
    Modelica.Blocks.Logical.Switch swi3
      "If discharching TES, and TES empties, switch to supply port with heatpump"
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Logical.Not not2
      annotation (Placement(transformation(extent={{30,32},{50,52}})));
    Modelica.Blocks.Sources.Constant staSweCoo2(k=3)
      annotation (Placement(transformation(extent={{70,70},{90,90}})));
    Modelica.Blocks.Logical.Switch swi4
      annotation (Placement(transformation(extent={{122,10},{142,30}})));
    Modelica.Blocks.Interfaces.BooleanInput heaSta "Heating status"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Logical.Or or1
      "If not need charge anymore or need heating at port"
      annotation (Placement(transformation(extent={{50,-120},{70,-100}})));
    Modelica.Blocks.Logical.Not not3
      annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  equation
    connect(realToInteger.y, y)
      annotation (Line(points={{81,0},{110,0}}, color={255,127,0}));
    connect(Ttes,hysteresis1. u) annotation (Line(points={{-120,0},{-80,0},{-80,
            -90},{-22,-90}}, color={0,0,127}));
    connect(lessEqualThreshold.y,and2. u1)
      annotation (Line(points={{51,-30},{68,-30}}, color={255,0,255}));
    connect(staSchConfig1.y[1],lessEqualThreshold. u) annotation (Line(points={{
            11,0},{20,0},{20,-30},{28,-30}}, color={0,0,127}));
    connect(staSchConfig1.y[1],swi1. u1) annotation (Line(points={{11,0},{20,0},{
            20,-14},{100,-14},{100,-22},{108,-22}}, color={0,0,127}));
    connect(staSweCoo1.y,swi2. u1) annotation (Line(points={{51,-56},{66,-56},{66,
            -52},{78,-52}}, color={0,0,127}));
    connect(lessEqualThreshold.y,swi2. u2) annotation (Line(points={{51,-30},{56,
            -30},{56,-60},{78,-60}}, color={255,0,255}));
    connect(staSchConfig1.y[1],swi2. u3) annotation (Line(points={{11,0},{20,0},{
            20,-68},{78,-68}}, color={0,0,127}));
    connect(and2.y,swi1. u2)
      annotation (Line(points={{91,-30},{108,-30}}, color={255,0,255}));
    connect(swi2.y,swi1. u3) annotation (Line(points={{101,-60},{106,-60},{106,
            -44},{100,-44},{100,-38},{108,-38}}, color={0,0,127}));
    connect(Ttes, hysteresis2.u) annotation (Line(points={{-120,0},{-80,0},{-80,
            90},{-22,90}},
                       color={0,0,127}));
    connect(staSchConfig1.y[1], greaterEqualThreshold.u)
      annotation (Line(points={{11,0},{20,0},{20,90},{28,90}}, color={0,0,127}));
    connect(greaterEqualThreshold.y, and1.u1) annotation (Line(points={{51,90},{60,
            90},{60,50},{68,50}}, color={255,0,255}));
    connect(hysteresis2.y, not2.u) annotation (Line(points={{1,90},{10,90},{10,42},
            {28,42}}, color={255,0,255}));
    connect(not2.y, and1.u2)
      annotation (Line(points={{51,42},{68,42}}, color={255,0,255}));
    connect(and1.y, swi3.u2)
      annotation (Line(points={{91,50},{98,50}}, color={255,0,255}));
    connect(staSweCoo2.y, swi3.u1) annotation (Line(points={{91,80},{94,80},{94,58},
            {98,58}}, color={0,0,127}));
    connect(staSchConfig1.y[1], swi3.u3) annotation (Line(points={{11,0},{20,0},{20,
            28},{94,28},{94,42},{98,42}}, color={0,0,127}));
    connect(greaterEqualThreshold.y, swi4.u2) annotation (Line(points={{51,90},{60,
            90},{60,20},{120,20}}, color={255,0,255}));
    connect(swi3.y, swi4.u1) annotation (Line(points={{121,50},{124,50},{124,34},{
            110,34},{110,28},{120,28}}, color={0,0,127}));
    connect(swi1.y, swi4.u3) annotation (Line(points={{131,-30},{140,-30},{140,0},
            {110,0},{110,12},{120,12}}, color={0,0,127}));
    connect(swi4.y, realToInteger.u) annotation (Line(points={{143,20},{150,20},{150,
            16},{40,16},{40,0},{58,0}}, color={0,0,127}));
    connect(or1.y, and2.u2) annotation (Line(points={{71,-110},{78,-110},{78,-80},
            {60,-80},{60,-38},{68,-38}}, color={255,0,255}));
    connect(not3.y, or1.u2) annotation (Line(points={{21,-120},{34,-120},{34,-118},
            {48,-118}}, color={255,0,255}));
    connect(heaSta, not3.u) annotation (Line(points={{-120,-60},{-90,-60},{-90,
            -120},{-2,-120}}, color={255,0,255}));
    connect(hysteresis1.y, or1.u1) annotation (Line(points={{1,-90},{40,-90},{40,
            -110},{48,-110}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5)}),                 Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end StateScheduleHotWaterSimple;

  model StateScheduleHotWaterMF
    "Schedule for charging and activation of pcm TES."
    parameter Modelica.Units.SI.Temperature TSol "Solidus temperature of PCM";
    parameter Modelica.Units.SI.Temperature TLiq "Liquidus temperature of PCM";
    Modelica.Blocks.Math.RealToInteger realToInteger
      annotation (Placement(transformation(extent={{60,-10},{80,10}})));
    Modelica.Blocks.Interfaces.IntegerOutput y
      "Connector of Integer output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses.InternalLoads staSchConfig1(
        smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments, table=[0,1;
          6*3600,2; 9*3600,1; 17*3600,1; 24*3600,1])
      "State schedule for configuration 1"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Logical.Hysteresis hysteresis1(
      uLow=TSol + 1,
      uHigh=TLiq + 1,
      pre_y_start=true) "Check if fully charged"
      annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));
    Modelica.Blocks.Logical.LessEqualThreshold
                                          lessEqualThreshold(threshold=1.0)
      annotation (Placement(transformation(extent={{30,-40},{50,-20}})));
    Modelica.Blocks.Sources.Constant staSweCoo1(k=3)
      annotation (Placement(transformation(extent={{30,-66},{50,-46}})));
    Modelica.Blocks.Logical.Switch swi2
      annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
    Modelica.Blocks.Logical.And and2 "If charging but not able to"
      annotation (Placement(transformation(extent={{70,-40},{90,-20}})));
    Modelica.Blocks.Logical.Switch swi1
      "If charging storage, and TES fills up, switch to supply port with heatpump"
      annotation (Placement(transformation(extent={{110,-40},{130,-20}})));
    Modelica.Blocks.Interfaces.RealInput Ttes
      "Temperature of thermal energy storage"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Logical.GreaterEqualThreshold
                                          greaterEqualThreshold(threshold=2.0)
      annotation (Placement(transformation(extent={{30,80},{50,100}})));
    Modelica.Blocks.Logical.Hysteresis hysteresis2(
      uLow=TSol - 2,
      uHigh=TSol - 1,
      pre_y_start=true) "Check if still charge left"
      annotation (Placement(transformation(extent={{-20,80},{0,100}})));
    Modelica.Blocks.Logical.And and1
      annotation (Placement(transformation(extent={{70,40},{90,60}})));
    Modelica.Blocks.Logical.Switch swi3
      "If discharching TES, and TES empties, switch to supply port with heatpump"
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Logical.Not not2
      annotation (Placement(transformation(extent={{30,32},{50,52}})));
    Modelica.Blocks.Sources.Constant staSweCoo2(k=3)
      annotation (Placement(transformation(extent={{70,70},{90,90}})));
    Modelica.Blocks.Logical.Switch swi4
      annotation (Placement(transformation(extent={{122,10},{142,30}})));
    Modelica.Blocks.Interfaces.BooleanInput heaSta "Heating status"
      annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
    Modelica.Blocks.Logical.And and3
      "If not need charge anymore or need heating at port"
      annotation (Placement(transformation(extent={{50,-120},{70,-100}})));
    Modelica.Blocks.Logical.Not not3
      annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{12,-100},{32,-80}})));
  equation
    connect(realToInteger.y, y)
      annotation (Line(points={{81,0},{110,0}}, color={255,127,0}));
    connect(Ttes,hysteresis1. u) annotation (Line(points={{-120,0},{-80,0},{-80,
            -90},{-22,-90}}, color={0,0,127}));
    connect(lessEqualThreshold.y,and2. u1)
      annotation (Line(points={{51,-30},{68,-30}}, color={255,0,255}));
    connect(staSchConfig1.y[1],lessEqualThreshold. u) annotation (Line(points={{
            11,0},{20,0},{20,-30},{28,-30}}, color={0,0,127}));
    connect(staSchConfig1.y[1],swi1. u1) annotation (Line(points={{11,0},{20,0},{
            20,-14},{100,-14},{100,-22},{108,-22}}, color={0,0,127}));
    connect(staSweCoo1.y,swi2. u1) annotation (Line(points={{51,-56},{66,-56},{66,
            -52},{78,-52}}, color={0,0,127}));
    connect(lessEqualThreshold.y,swi2. u2) annotation (Line(points={{51,-30},{56,
            -30},{56,-60},{78,-60}}, color={255,0,255}));
    connect(staSchConfig1.y[1],swi2. u3) annotation (Line(points={{11,0},{20,0},{
            20,-68},{78,-68}}, color={0,0,127}));
    connect(and2.y,swi1. u2)
      annotation (Line(points={{91,-30},{108,-30}}, color={255,0,255}));
    connect(swi2.y,swi1. u3) annotation (Line(points={{101,-60},{106,-60},{106,
            -44},{100,-44},{100,-38},{108,-38}}, color={0,0,127}));
    connect(Ttes, hysteresis2.u) annotation (Line(points={{-120,0},{-80,0},{-80,
            90},{-22,90}},
                       color={0,0,127}));
    connect(staSchConfig1.y[1], greaterEqualThreshold.u)
      annotation (Line(points={{11,0},{20,0},{20,90},{28,90}}, color={0,0,127}));
    connect(greaterEqualThreshold.y, and1.u1) annotation (Line(points={{51,90},{60,
            90},{60,50},{68,50}}, color={255,0,255}));
    connect(hysteresis2.y, not2.u) annotation (Line(points={{1,90},{10,90},{10,42},
            {28,42}}, color={255,0,255}));
    connect(not2.y, and1.u2)
      annotation (Line(points={{51,42},{68,42}}, color={255,0,255}));
    connect(and1.y, swi3.u2)
      annotation (Line(points={{91,50},{98,50}}, color={255,0,255}));
    connect(staSweCoo2.y, swi3.u1) annotation (Line(points={{91,80},{94,80},{94,58},
            {98,58}}, color={0,0,127}));
    connect(staSchConfig1.y[1], swi3.u3) annotation (Line(points={{11,0},{20,0},{20,
            28},{94,28},{94,42},{98,42}}, color={0,0,127}));
    connect(greaterEqualThreshold.y, swi4.u2) annotation (Line(points={{51,90},{60,
            90},{60,20},{120,20}}, color={255,0,255}));
    connect(swi3.y, swi4.u1) annotation (Line(points={{121,50},{124,50},{124,34},{
            110,34},{110,28},{120,28}}, color={0,0,127}));
    connect(swi1.y, swi4.u3) annotation (Line(points={{131,-30},{140,-30},{140,0},
            {110,0},{110,12},{120,12}}, color={0,0,127}));
    connect(swi4.y, realToInteger.u) annotation (Line(points={{143,20},{150,20},{150,
            16},{40,16},{40,0},{58,0}}, color={0,0,127}));
    connect(and3.y, and2.u2) annotation (Line(points={{71,-110},{78,-110},{78,-80},
            {60,-80},{60,-38},{68,-38}}, color={255,0,255}));
    connect(not3.y, and3.u2) annotation (Line(points={{21,-120},{34,-120},{34,-118},
            {48,-118}}, color={255,0,255}));
    connect(heaSta, not3.u) annotation (Line(points={{-120,-60},{-90,-60},{-90,
            -120},{-2,-120}}, color={255,0,255}));
    connect(hysteresis1.y, not1.u)
      annotation (Line(points={{1,-90},{10,-90}}, color={255,0,255}));
    connect(not1.y, and3.u1) annotation (Line(points={{33,-90},{40,-90},{40,-110},
            {48,-110}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,80},{80,-80}}, lineColor={160,160,164}),
          Line(points={{0,80},{0,60}}, color={160,160,164}),
          Line(points={{80,0},{60,0}}, color={160,160,164}),
          Line(points={{0,-80},{0,-60}}, color={160,160,164}),
          Line(points={{-80,0},{-60,0}}, color={160,160,164}),
          Line(points={{37,70},{26,50}}, color={160,160,164}),
          Line(points={{70,38},{49,26}}, color={160,160,164}),
          Line(points={{71,-37},{52,-27}}, color={160,160,164}),
          Line(points={{39,-70},{29,-51}}, color={160,160,164}),
          Line(points={{-39,-70},{-29,-52}}, color={160,160,164}),
          Line(points={{-71,-37},{-50,-26}}, color={160,160,164}),
          Line(points={{-71,37},{-54,28}}, color={160,160,164}),
          Line(points={{-38,70},{-28,51}}, color={160,160,164}),
          Line(
            points={{0,0},{-50,50}},
            thickness=0.5),
          Line(
            points={{0,0},{40,0}},
            thickness=0.5)}),                 Diagram(coordinateSystem(
            preserveAspectRatio=false)));
  end StateScheduleHotWaterMF;

  model RTU "Implements common control for RTU system"
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
      "Design air flowrate of supply fan";
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_minOA
      "Minimum outdoor air flowrate";
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_hea
      "Heating air flowrate";
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_coo
      "Cooling outdoor air flowrate";
    parameter Boolean  EnableEconomizer = true "Enable economizer operation";
    parameter Modelica.Units.SI.TemperatureDifference Deadband_coo=1
      "Cooling deadband";
    parameter Modelica.Units.SI.TemperatureDifference DeadBand_hea=1
      "Heating deadband";
    Modelica.Blocks.Interfaces.BooleanInput occSta
      "Indicates occupancy or standby mode"
      annotation (Placement(transformation(extent={{-140,178},{-100,218}})));
    Modelica.Blocks.Interfaces.RealInput TSetRooHea(final unit="K", displayUnit=
          "degC")
      "Zone heating setpoint temperature" annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,138})));
    Modelica.Blocks.Interfaces.RealInput TSetRooCoo(final unit="K", displayUnit=
          "degC") "Zone cooling setpoint temperature"
                                          annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,78})));
    Modelica.Blocks.Interfaces.RealInput TEco(final unit="K", displayUnit="degC")
      "Economizer input temperature (e.g. outside drybulb temperature or wetbulb temperature)"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
    Modelica.Blocks.Interfaces.RealInput TRoo(final unit="K", displayUnit="degC")
                          "Zone temperature measurement"
    annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-120,18})));
    Modelica.Blocks.Interfaces.RealOutput yFan(final unit="1")
      "Control signal for fan"
      annotation (Placement(transformation(extent={{100,188},{120,208}})));
    Modelica.Blocks.Interfaces.RealOutput yHea(final unit="1")
      "Control signal for heating"
      annotation (Placement(transformation(extent={{100,108},{120,128}})));
    Modelica.Blocks.Interfaces.RealOutput yOutAirFra(final unit="1")
      "Control signal for outside air fraction"
      annotation (Placement(transformation(extent={{100,-32},{120,-12}})));
    Modelica.Blocks.Interfaces.RealOutput yCoo(final unit="1")
      "Control signal for cooling"
      annotation (Placement(transformation(extent={{100,48},{120,68}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput cooSta
      "Cooling status signal"
      annotation (Placement(transformation(extent={{100,-132},{120,-112}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput heaSta
      "Heating status signal"
      annotation (Placement(transformation(extent={{100,-92},{120,-72}})));
    Modelica.Blocks.Logical.OnOffController onOffConHea(bandwidth=DeadBand_hea)
      "Enable heating"
      annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
    Modelica.Blocks.Logical.OnOffController onOffConCoo(bandwidth=Deadband_coo)
      "Enable cooling"
      annotation (Placement(transformation(extent={{-60,-22},{-40,-2}})));
    Buildings.Controls.Continuous.LimPID conHea(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=false) "Heating feedback controller"
      annotation (Placement(transformation(extent={{0,108},{20,128}})));
    Modelica.Blocks.Logical.Switch swiHea "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{72,108},{92,128}})));
    Modelica.Blocks.Logical.Switch swiCoo "Switch for turning cooling on/off"
      annotation (Placement(transformation(extent={{72,48},{92,68}})));
    Buildings.Controls.Continuous.LimPID conCoo(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_coo,
      final yMax=1,
      final yMin=0,
      final k=k_coo,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=true) "Cooling feedback controller"
      annotation (Placement(transformation(extent={{0,48},{20,68}})));
    Modelica.Blocks.Sources.Constant fanFloVen(k=mAir_flow_minOA/
          mAir_flow_nominal)
      "Fan airflow for ventilation"
      annotation (Placement(transformation(extent={{-60,158},{-40,178}})));
    Modelica.Blocks.Sources.Constant fanFloHea(k=mAir_flow_hea/mAir_flow_nominal)
      "Fan airflow for heating"
      annotation (Placement(transformation(extent={{-60,128},{-40,148}})));
    Modelica.Blocks.Sources.Constant fanFloCoo(k=mAir_flow_coo/mAir_flow_nominal)
      "Fan airflow for cooling"
      annotation (Placement(transformation(extent={{-60,98},{-40,118}})));
    Modelica.Blocks.Routing.Multiplex4 mulPle3
      "Multiplex for fan speed setpoints"
      annotation (Placement(transformation(extent={{40,188},{60,208}})));
    Modelica.Blocks.Routing.Extractor fanModSel(nin=4, index(start=1))
                                                       "Fan mode selector"
      annotation (Placement(transformation(extent={{70,188},{90,208}})));
    Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
      annotation (Placement(transformation(extent={{-60,188},{-40,208}})));
    FanMode fanMod "Fan mode determination"
      annotation (Placement(transformation(extent={{40,158},{60,178}})));
    Modelica.Blocks.Sources.Constant offHea(k=0) "Off signal"
      annotation (Placement(transformation(extent={{40,88},{60,108}})));
    Modelica.Blocks.Sources.Constant offCoo(k=0) "Off signal"
      annotation (Placement(transformation(extent={{40,28},{60,48}})));
    Modelica.Blocks.Interfaces.RealInput TRet(final unit="K", displayUnit="degC")
      "Return air temperature"
      annotation (Placement(transformation(extent={{-140,-122},{-100,-82}})));
    Modelica.Blocks.Routing.Extractor oaFloSel(nin=4, index(start=1))
                                                      "OA flow selector"
      annotation (Placement(transformation(extent={{70,-32},{90,-12}})));
    Modelica.Blocks.Routing.Multiplex4 mulPle1
      "Multiplex for fan speed setpoints"
      annotation (Placement(transformation(extent={{40,-32},{60,-12}})));
    Modelica.Blocks.Sources.Constant off3(k=0) "Off signal"
      annotation (Placement(transformation(extent={{0,-2},{20,18}})));
    Modelica.Blocks.Sources.Constant full(k=1) "100% signal"
      annotation (Placement(transformation(extent={{0,-32},{20,-12}})));
    Modelica.Blocks.Sources.Constant minHea(k=mAir_flow_minOA/mAir_flow_hea)
      "Minimum OA during cooling mode"
      annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
    CooEcoSta cooEcoSta(k=k_eco, Ti=Ti_eco,
      EnableEconomizer=EnableEconomizer)
      annotation (Placement(transformation(extent={{0,-118},{20,-98}})));
    Modelica.Blocks.Sources.Constant minCoo(k=mAir_flow_minOA/mAir_flow_coo)
      "Minimum OA fraction during cooling mode"
      annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
    Modelica.Blocks.Logical.And andSat "Economizer is enabled and saturated"
      annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
    Modelica.Blocks.MathBoolean.Or or1(nu=2)
      "Economizer is enabled and saturated or economizer is not enabled"
      annotation (Placement(transformation(extent={{68,-102},{80,-90}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{46,-92},{54,-84}})));
    Modelica.Blocks.Logical.And andCoo
      "Economizer is enabled and saturated or not enabled, and cooling is enabled"
      annotation (Placement(transformation(extent={{70,-2},{50,18}})));
    Modelica.Blocks.Logical.Not notCoo "Not for cooling control"
      annotation (Placement(transformation(extent={{-32,-16},{-24,-8}})));
    parameter Real k_hea=0.1 "Proportional gain of heating controller";
    parameter Modelica.Units.SI.Time Ti_hea=240
      "Integral time constant of heating controller";
    parameter Real k_coo=0.1 "Proportional gain of cooling controller";
    parameter Modelica.Units.SI.Time Ti_coo=240
      "Integral time constant of cooling controller";
    parameter Real k_eco=0.75 "Proportional gain of economizer controller";
    parameter Modelica.Units.SI.Time Ti_eco=240
      "Integral time constant of economizer controller";
    Modelica.Blocks.Logical.Switch swiFrePro
      "Switch for turning freeze protection on"
      annotation (Placement(transformation(extent={{72,138},{92,158}})));
    Buildings.Controls.Continuous.LimPID conFrePro(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=false) "Freeze protection feedback controller"
      annotation (Placement(transformation(extent={{0,-152},{20,-132}})));
    Modelica.Blocks.Interfaces.RealInput TMix(final unit="K", displayUnit="degC")
      "Mixed air temperature"
      annotation (Placement(transformation(extent={{-140,-182},{-100,-142}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput freSta
      "Freeze protection status signal"
      annotation (Placement(transformation(extent={{100,-172},{120,-152}})));
    Modelica.Blocks.Sources.Constant freProSet(k=273.15 + 10)
      "Setpoint temperature for freeze protection"
      annotation (Placement(transformation(extent={{-100,-144},{-80,-124}})));
    Modelica.Blocks.Logical.OnOffController onOffConFrePro(bandwidth=1)
      "Enable freeze protection"
      annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
    Modelica.Blocks.Logical.And andFre
      "Freeze protection and not in heating mode"
      annotation (Placement(transformation(extent={{-24,-160},{-12,-148}})));
    Modelica.Blocks.Logical.Not notCoo1
                                       "Not for cooling control"
      annotation (Placement(transformation(extent={{-40,-132},{-32,-124}})));
    Modelica.Blocks.Interfaces.RealInput TSup(final unit="K", displayUnit="degC")
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-140,-242},{-100,-202}})));
    Modelica.Blocks.Logical.Switch swiOccHea
      "Switch for turning ventilation needed during heating on/off"
      annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
    Modelica.Blocks.Logical.Switch swiOccCoo
      "Switch for turning ventilation needed during cooling on/off"
      annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  equation
    connect(TSetRooHea, onOffConHea.reference) annotation (Line(points={{-120,138},
            {-78,138},{-78,24},{-62,24}},  color={0,0,127}));
    connect(TRoo, onOffConHea.u) annotation (Line(points={{-120,18},{-94,18},{-94,
            12},{-62,12}},       color={0,0,127}));
    connect(TSetRooCoo, onOffConCoo.reference) annotation (Line(points={{-120,78},
            {-90,78},{-90,-6},{-62,-6}},   color={0,0,127}));
    connect(TRoo, onOffConCoo.u) annotation (Line(points={{-120,18},{-94,18},{-94,
            -18},{-62,-18}},     color={0,0,127}));
    connect(conHea.y, swiHea.u1) annotation (Line(points={{21,118},{26,118},{26,126},
            {70,126}},      color={0,0,127}));
    connect(conHea.u_s, onOffConHea.reference) annotation (Line(points={{-2,118},{
            -10,118},{-10,38},{-78,38},{-78,24},{-62,24}},
                                            color={0,0,127}));
    connect(swiCoo.y, yCoo) annotation (Line(points={{93,58},{110,58}},
                      color={0,0,127}));
    connect(mulPle3.y,fanModSel. u) annotation (Line(points={{61,198},{68,198}},
                                            color={0,0,127}));
    connect(fanModSel.y, yFan)
      annotation (Line(points={{91,198},{110,198}}, color={0,0,127}));
    connect(off.y, mulPle3.u1[1]) annotation (Line(points={{-39,198},{-30,198},{-30,
            207},{38,207}},     color={0,0,127}));
    connect(fanFloVen.y, mulPle3.u2[1]) annotation (Line(points={{-39,168},{-28,168},
            {-28,201},{38,201}},      color={0,0,127}));
    connect(fanFloHea.y, mulPle3.u3[1]) annotation (Line(points={{-39,138},{-26,138},
            {-26,195},{38,195}},      color={0,0,127}));
    connect(fanFloCoo.y, mulPle3.u4[1]) annotation (Line(points={{-39,108},{-24,108},
            {-24,189},{38,189}}, color={0,0,127}));
    connect(fanMod.y1, fanModSel.index)
      annotation (Line(points={{61,168},{80,168},{80,186}}, color={255,127,0}));
    connect(fanMod.coo, cooSta) annotation (Line(points={{38,160},{-16,160},{-16,-122},
            {110,-122}},       color={255,0,255}));
    connect(onOffConHea.y, fanMod.hea) annotation (Line(points={{-39,18},{-18,18},
            {-18,168},{38,168}},      color={255,0,255}));
    connect(onOffConHea.y, heaSta) annotation (Line(points={{-39,18},{-18,18},{-18,
            -68},{96,-68},{96,-82},{110,-82}},         color={255,0,255}));
    connect(offHea.y, swiHea.u3) annotation (Line(points={{61,98},{64,98},{64,110},
            {70,110}},color={0,0,127}));
    connect(offCoo.y, swiCoo.u3)
      annotation (Line(points={{61,38},{64,38},{64,50},{70,50}},
                                                               color={0,0,127}));
    connect(TSetRooCoo, conCoo.u_s) annotation (Line(points={{-120,78},{-90,78},{-90,
            4},{-8,4},{-8,58},{-2,58}},         color={0,0,127}));
    connect(off3.y, mulPle1.u1[1]) annotation (Line(points={{21,8},{26,8},{26,-13},
            {38,-13}},      color={0,0,127}));
    connect(mulPle1.y, oaFloSel.u)
      annotation (Line(points={{61,-22},{68,-22}}, color={0,0,127}));
    connect(full.y, mulPle1.u2[1]) annotation (Line(points={{21,-22},{26,-22},{26,
            -19},{38,-19}}, color={0,0,127}));
    connect(TRoo, conCoo.u_m) annotation (Line(points={{-120,18},{-94,18},{-94,42},
            {10,42},{10,46}},  color={0,0,127}));
    connect(conHea.u_m, onOffConHea.u) annotation (Line(points={{10,106},{10,86},{
            -94,86},{-94,12},{-62,12}},   color={0,0,127}));
    connect(conCoo.y, swiCoo.u1) annotation (Line(points={{21,58},{28,58},{28,
            66},{70,66}},
                      color={0,0,127}));
    connect(cooEcoSta.yFra, mulPle1.u4[1]) annotation (Line(points={{21,-108},{26,
            -108},{26,-31},{38,-31}}, color={0,0,127}));
    connect(cooEcoSta.TSetRooCoo, onOffConCoo.reference) annotation (Line(points={{-2,-98},
            {-90,-98},{-90,-6},{-62,-6}},               color={0,0,127}));
    connect(cooEcoSta.TRoo, onOffConCoo.u) annotation (Line(points={{-2,-102},{-94,
            -102},{-94,-18},{-62,-18}},     color={0,0,127}));
    connect(TEco, cooEcoSta.TEco) annotation (Line(points={{-120,-40},{-86,-40},{
            -86,-106},{-2,-106}},  color={0,0,127}));
    connect(cooEcoSta.TRet, TRet) annotation (Line(points={{-2,-110},{-62,-110},{-62,
            -102},{-120,-102}},     color={0,0,127}));
    connect(yOutAirFra, oaFloSel.y)
      annotation (Line(points={{110,-22},{91,-22}}, color={0,0,127}));
    connect(fanMod.y1, oaFloSel.index) annotation (Line(points={{61,168},{98,168},
            {98,-42},{80,-42},{80,-34}}, color={255,127,0}));
    connect(cooEcoSta.ena, andSat.u1) annotation (Line(points={{21,-112},{30,-112},
            {30,-110},{38,-110}}, color={255,0,255}));
    connect(cooEcoSta.sat, andSat.u2) annotation (Line(points={{21,-116},{30,-116},
            {30,-118},{38,-118}}, color={255,0,255}));
    connect(cooEcoSta.ena, not1.u) annotation (Line(points={{21,-112},{32,-112},{32,
            -88},{45.2,-88}},      color={255,0,255}));
    connect(not1.y, or1.u[1]) annotation (Line(points={{54.4,-88},{64,-88},{64,
            -93.9},{68,-93.9}},   color={255,0,255}));
    connect(andSat.y, or1.u[2]) annotation (Line(points={{61,-110},{64,-110},{64,
            -98.1},{68,-98.1}},
                          color={255,0,255}));
    connect(or1.y, andCoo.u2) annotation (Line(points={{80.9,-96},{98,-96},{98,
            -42},{80,-42},{80,4},{86,4},{86,0},{72,0}},    color={255,0,255}));
    connect(andCoo.u1, cooSta) annotation (Line(points={{72,8},{78,8},{78,30},{
            -8,30},{-8,-122},{110,-122}},     color={255,0,255}));
    connect(cooEcoSta.cooEna, cooSta) annotation (Line(points={{-2,-118},{-16,-118},
            {-16,-122},{110,-122}}, color={255,0,255}));
    connect(fanMod.ven, occSta) annotation (Line(points={{38,176},{-20,176},{-20,78},
            {-70,78},{-70,198},{-120,198}}, color={255,0,255}));
    connect(onOffConCoo.y, notCoo.u)
      annotation (Line(points={{-39,-12},{-32.8,-12}}, color={255,0,255}));
    connect(notCoo.y, cooSta) annotation (Line(points={{-23.6,-12},{-16,-12},{-16,
            -122},{110,-122}}, color={255,0,255}));
    connect(swiHea.u2, fanMod.hea) annotation (Line(points={{70,118},{32,118},{32,
            84},{-18,84},{-18,168},{38,168}}, color={255,0,255}));
    connect(swiCoo.u2, andCoo.y) annotation (Line(points={{70,58},{32,58},{32,8},
            {49,8}},color={255,0,255}));
    connect(conHea.trigger, fanMod.hea) annotation (Line(points={{2,106},{-16,
            106},{-16,168},{38,168}},                 color={255,0,255}));
    connect(conCoo.trigger, andCoo.y) annotation (Line(points={{2,46},{2,38},{
            32,38},{32,8},{49,8}},
                            color={255,0,255}));
    connect(freProSet.y, onOffConFrePro.reference) annotation (Line(points={{-79,-134},
            {-70,-134},{-70,-144},{-62,-144}}, color={0,0,127}));
    connect(TMix, onOffConFrePro.u) annotation (Line(points={{-120,-162},{-69,-162},
            {-69,-156},{-62,-156}}, color={0,0,127}));
    connect(onOffConFrePro.y, andFre.u2) annotation (Line(points={{-39,-150},{-34,
            -150},{-34,-158.8},{-25.2,-158.8}}, color={255,0,255}));
    connect(notCoo1.y, andFre.u1) annotation (Line(points={{-31.6,-128},{-25.2,-128},
            {-25.2,-154}}, color={255,0,255}));
    connect(onOffConHea.y, notCoo1.u) annotation (Line(points={{-39,18},{-18,18},{
            -18,-118},{-50,-118},{-50,-128},{-40.8,-128}}, color={255,0,255}));
    connect(andFre.y, freSta) annotation (Line(points={{-11.4,-154},{-10,-154},{-10,
            -158},{28,-158},{28,-162},{110,-162}}, color={255,0,255}));
    connect(conFrePro.trigger, freSta) annotation (Line(points={{2,-154},{2,-158},
            {28,-158},{28,-162},{110,-162}}, color={255,0,255}));
    connect(freProSet.y, conFrePro.u_s) annotation (Line(points={{-79,-134},{-20,-134},
            {-20,-142},{-2,-142}}, color={0,0,127}));
    connect(swiFrePro.u2, freSta) annotation (Line(points={{70,148},{28,148},{28,-162},
            {110,-162}}, color={255,0,255}));
    connect(swiHea.y, swiFrePro.u3) annotation (Line(points={{93,118},{94,118},{94,
            134},{66,134},{66,140},{70,140}}, color={0,0,127}));
    connect(swiFrePro.y, yHea) annotation (Line(points={{93,148},{96,148},{96,118},
            {110,118}}, color={0,0,127}));
    connect(conFrePro.y, swiFrePro.u1) annotation (Line(points={{21,-142},{30,-142},
            {30,156},{70,156}}, color={0,0,127}));
    connect(TSup, conFrePro.u_m) annotation (Line(points={{-120,-222},{10,-222},
            {10,-154}},
                    color={0,0,127}));
    connect(swiOccHea.y, mulPle1.u3[1]) annotation (Line(points={{21,-50},{22,-50},
            {22,-25},{38,-25}}, color={0,0,127}));
    connect(minHea.y, swiOccHea.u1) annotation (Line(points={{-39,-50},{-32,-50},
            {-32,-42},{-2,-42}}, color={0,0,127}));
    connect(off.y, swiOccHea.u3) annotation (Line(points={{-39,198},{-36,198},{
            -36,-58},{-2,-58}}, color={0,0,127}));
    connect(swiOccHea.u2, occSta) annotation (Line(points={{-2,-50},{-20,-50},{
            -20,78},{-70,78},{-70,198},{-120,198}}, color={255,0,255}));
    connect(swiOccCoo.u2, occSta) annotation (Line(points={{-2,-80},{-20,-80},{
            -20,78},{-70,78},{-70,198},{-120,198}}, color={255,0,255}));
    connect(swiOccCoo.u3, swiOccHea.u3) annotation (Line(points={{-2,-88},{-36,
            -88},{-36,-58},{-2,-58}}, color={0,0,127}));
    connect(minCoo.y, swiOccCoo.u1) annotation (Line(points={{-39,-80},{-28,-80},
            {-28,-72},{-2,-72}}, color={0,0,127}));
    connect(swiOccCoo.y, cooEcoSta.minCooFra) annotation (Line(points={{21,-80},{
            24,-80},{24,-94},{-6,-94},{-6,-114},{-2,-114}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},
              {100,220}}),       graphics={
                                  Rectangle(
          extent={{-100,-220},{100,220}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},{100,220}})));
  end RTU;

  model FanMode "Fan mode selector"
    extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.BooleanInput ven "Ventilation"
      annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
    Modelica.Blocks.Interfaces.BooleanInput hea "Heating"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.BooleanInput coo "Cooling"
      annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
    Modelica.Blocks.Math.BooleanToReal booIntVen(realTrue=2, realFalse=1)
      "Boolean to integer conversion for ventilation"
      annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
    Modelica.Blocks.Interfaces.IntegerOutput y1
                                      "Connector of Integer output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Math.BooleanToReal booIntHea(realTrue=3, realFalse=1)
      "Boolean to integer conversion for heating"
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    Modelica.Blocks.Math.BooleanToReal booIntCoo(realTrue=4, realFalse=1)
      "Boolean to integer conversion for cooling"
      annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
    Modelica.Blocks.Math.MinMax minMax(nu=3)
      annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
    Modelica.Blocks.Math.RealToInteger reaInt "Convert real number to integer"
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  equation
    connect(ven, booIntVen.u)
      annotation (Line(points={{-120,80},{-82,80}}, color={255,0,255}));
    connect(hea, booIntHea.u)
      annotation (Line(points={{-120,0},{-82,0}}, color={255,0,255}));
    connect(booIntCoo.u, coo)
      annotation (Line(points={{-82,-80},{-120,-80}}, color={255,0,255}));
    connect(booIntVen.y, minMax.u[1]) annotation (Line(points={{-59,80},{-40,80},
            {-40,4.66667},{-8,4.66667}}, color={0,0,127}));
    connect(booIntHea.y, minMax.u[2]) annotation (Line(points={{-59,0},{-34,0},{
            -34,0},{-8,0}}, color={0,0,127}));
    connect(booIntCoo.y, minMax.u[3]) annotation (Line(points={{-59,-80},{-40,-80},
            {-40,-4.66667},{-8,-4.66667}}, color={0,0,127}));
    connect(minMax.yMax, reaInt.u)
      annotation (Line(points={{13,6},{30,6},{30,0},{38,0}}, color={0,0,127}));
    connect(reaInt.y, y1)
      annotation (Line(points={{61,0},{110,0}}, color={255,127,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end FanMode;

  model CooEcoSta "Cooling and economizer staging"
    extends Modelica.Blocks.Icons.Block;
    Buildings.Controls.Continuous.LimPID conEco(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti,
      final yMax=1,
      final yMin=0,
      final k=k,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=true) "Economizer feedback controller"
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    Modelica.Blocks.Logical.OnOffController onOffConEco(bandwidth=DeadBand_coo)
      "Enable economizer"
      annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
    Modelica.Blocks.Interfaces.RealOutput yFra "Output fraction"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealInput TSetRooCoo(final unit="K", displayUnit=
          "degC") "Zone cooling setpoint temperature"
                                          annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,100})));
    Modelica.Blocks.Interfaces.RealInput TEco(final unit="K", displayUnit="degC")
      "Economizer input temperature (e.g. outside drybulb temperature or wetbulb temperature)"
      annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
    Modelica.Blocks.Interfaces.RealInput TRet(final unit="K", displayUnit="degC")
      "Return air temperature"
      annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
    Modelica.Blocks.Interfaces.RealInput TRoo(final unit="K", displayUnit="degC")
                          "Zone temperature measurement"
    annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-120,60})));
    Modelica.Blocks.Interfaces.RealInput minCooFra
      "Minimum fraction at cooling fan speed" annotation (Placement(
          transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,-60})));
    Modelica.Blocks.Interfaces.BooleanOutput sat "Economizer saturated"
      annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
    Modelica.Blocks.Interfaces.BooleanOutput ena "Economizer enabled"
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Interfaces.BooleanInput cooEna "Cooling enabled"
      annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));
    Modelica.Blocks.MathBoolean.And
                                and1(nu=3)
                                     "Cooling enabled and economizer enabled"
      annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
    parameter Real DeadBand_coo=1 "Cooling deadband";
    parameter Real k "Gain of controller";
    parameter Modelica.Units.SI.Time Ti "Time constant of Integrator block";
    parameter Boolean  EnableEconomizer = true "Enable economizer operation";
    Modelica.Blocks.Logical.Hysteresis hys(uLow=0.9, uHigh=0.99)
      "Saturation hysteresis"
      annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
    Modelica.Blocks.Nonlinear.VariableLimiter lim "Signal limiter"
      annotation (Placement(transformation(extent={{40,0},{60,20}})));
    Modelica.Blocks.Sources.Constant one(k=1.0) "Constant one"
      annotation (Placement(transformation(extent={{0,40},{20,60}})));
    Modelica.Blocks.Logical.Switch switch1
      annotation (Placement(transformation(extent={{70,-10},{90,10}})));
    Modelica.Blocks.Sources.BooleanConstant enaEco(k=EnableEconomizer)
      "Enable economizer"
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  equation
    connect(TEco, onOffConEco.u) annotation (Line(points={{-120,20},{-96,20},{-96,
            -36},{-82,-36}}, color={0,0,127}));
    connect(TRet, onOffConEco.reference) annotation (Line(points={{-120,-20},{-92,
            -20},{-92,-24},{-82,-24}}, color={0,0,127}));
    connect(TRoo, conEco.u_m) annotation (Line(points={{-120,60},{-26,60},{-26,-10},
            {10,-10},{10,-2}}, color={0,0,127}));
    connect(TSetRooCoo, conEco.u_s) annotation (Line(points={{-120,100},{-20,100},
            {-20,10},{-2,10}},
                          color={0,0,127}));
    connect(and1.y, ena) annotation (Line(points={{-18.5,-30},{64,-30},{64,-40},{
            110,-40}},
                   color={255,0,255}));
    connect(hys.y, sat)
      annotation (Line(points={{91,-80},{110,-80}}, color={255,0,255}));
    connect(conEco.y, hys.u) annotation (Line(points={{21,10},{30,10},{30,-80},{68,
            -80}}, color={0,0,127}));
    connect(minCooFra, lim.limit2) annotation (Line(points={{-120,-60},{26,-60},{26,
            2},{38,2}}, color={0,0,127}));
    connect(conEco.y, lim.u)
      annotation (Line(points={{21,10},{38,10}}, color={0,0,127}));
    connect(one.y, lim.limit1) annotation (Line(points={{21,50},{34,50},{34,18},{38,
            18}}, color={0,0,127}));
    connect(conEco.trigger, ena) annotation (Line(points={{2,-2},{2,-30},{64,-30},
            {64,-40},{110,-40}}, color={255,0,255}));
    connect(switch1.y, yFra)
      annotation (Line(points={{91,0},{110,0}}, color={0,0,127}));
    connect(switch1.u2, ena) annotation (Line(points={{68,0},{64,0},{64,-40},{110,
            -40}}, color={255,0,255}));
    connect(lim.y, switch1.u1)
      annotation (Line(points={{61,10},{64,10},{64,8},{68,8}}, color={0,0,127}));
    connect(switch1.u3, lim.limit2)
      annotation (Line(points={{68,-8},{26,-8},{26,2},{38,2}}, color={0,0,127}));
    connect(enaEco.y, and1.u[1]) annotation (Line(points={{-59,10},{-46,10},{
            -46,-25.3333},{-40,-25.3333}},
                                       color={255,0,255}));
    connect(onOffConEco.y, and1.u[2]) annotation (Line(points={{-59,-30},{-50,-30},
            {-50,-30},{-40,-30}}, color={255,0,255}));
    connect(cooEna, and1.u[3]) annotation (Line(points={{-120,-100},{-50,-100},
            {-50,-34.6667},{-40,-34.6667}},color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end CooEcoSta;

  package Examples "Contains examples for controls"
  extends Modelica.Icons.ExamplesPackage;
    model RTU "Example of basic RTU control"
      extends Modelica.Icons.Example;
      hil_flexlab_model.BaseClasses.Controls.RTU con(
        mAir_flow_nominal=4,
        mAir_flow_minOA=0.5,
        mAir_flow_hea=2,
        mAir_flow_coo=4) "Control of rtu"
        annotation (Placement(transformation(extent={{-10,-16},{10,16}})));
      Modelica.Blocks.Sources.BooleanStep occ(startTime=3600*2) "Occupancy"
        annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
      Modelica.Blocks.Sources.Constant TSetRooHea(k=273.15 + 20)
        "Heating setpoint temperature"
        annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
      Modelica.Blocks.Sources.Constant TSetRooCoo(k=273.15 + 25)
        "Cooling setpoint temperature"
        annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
      Modelica.Blocks.Sources.Sine TRoo(
        amplitude=7.5,
        f=1/(24*3600),
        offset=273.15 + 22.5,
        startTime=0) "Room air temperature measurement"
        annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
      Modelica.Blocks.Sources.Sine TOut(
        amplitude=15,
        f=1/(24*3600),
        offset=273.15 + 20,
        startTime=2*3600) "Outside air temperature"
        annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
    equation
      connect(occ.y, con.occSta) annotation (Line(points={{-79,90},{-20,90},{
              -20,14.4},{-12,14.4}},
                         color={255,0,255}));
      connect(TSetRooHea.y, con.TSetRooHea) annotation (Line(points={{-79,50},{
              -22,50},{-22,10.0364},{-12,10.0364}},
                                  color={0,0,127}));
      connect(TSetRooCoo.y, con.TSetRooCoo) annotation (Line(points={{-79,20},{
              -24,20},{-24,5.67273},{-12,5.67273}},
                                color={0,0,127}));
      connect(TRoo.y, con.TRoo) annotation (Line(points={{-79,-10},{-60,-10},{
              -60,1.30909},{-12,1.30909}},
                         color={0,0,127}));
      connect(TOut.y, con.TEco) annotation (Line(points={{-79,-40},{-40,-40},{
              -40,-2.90909},{-12,-2.90909}},
                           color={0,0,127}));
      connect(con.TRet, con.TRoo) annotation (Line(points={{-12,-7.41818},{-60,
              -7.41818},{-60,1.30909},{-12,1.30909}},
                             color={0,0,127}));
      annotation (
        __Dymola_Commands(file="/home/dhbubu18/git/rtu-pcm/rtu-pcm/modelica-rtu-pcm/RTUPCM/Resources/Scripts/Dymola/HVAC/Controls/Examples/RTU.mos"
            "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
            coordinateSystem(preserveAspectRatio=false)),
        experiment(
          StopTime=172800,
          Interval=59.9999616,
          Tolerance=1e-06,
          __Dymola_Algorithm="Dassl"));
    end RTU;
  end Examples;

  model RTU_noCool "Implements common control for RTU system"
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
      "Design air flowrate of supply fan";
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_minOA
      "Minimum outdoor air flowrate";
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_hea
      "Heating air flowrate";
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_coo
      "Cooling outdoor air flowrate";
    parameter Boolean  EnableEconomizer = true "Enable economizer operation";
    parameter Modelica.Units.SI.TemperatureDifference Deadband_coo=1
      "Cooling deadband";
    parameter Modelica.Units.SI.TemperatureDifference DeadBand_hea=1
      "Heating deadband";
    Modelica.Blocks.Interfaces.BooleanInput occSta
      "Indicates occupancy or standby mode"
      annotation (Placement(transformation(extent={{-140,178},{-100,218}})));
    Modelica.Blocks.Interfaces.RealInput TSetRooHea(final unit="K", displayUnit=
          "degC")
      "Zone heating setpoint temperature" annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,138})));
    Modelica.Blocks.Interfaces.RealInput TSetRooCoo(final unit="K", displayUnit=
          "degC") "Zone cooling setpoint temperature"
                                          annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,78})));
    Modelica.Blocks.Interfaces.RealInput TEco(final unit="K", displayUnit="degC")
      "Economizer input temperature (e.g. outside drybulb temperature or wetbulb temperature)"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
    Modelica.Blocks.Interfaces.RealInput TRoo(final unit="K", displayUnit="degC")
                          "Zone temperature measurement"
    annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-120,18})));
    Modelica.Blocks.Interfaces.RealOutput yFan(final unit="1")
      "Control signal for fan"
      annotation (Placement(transformation(extent={{100,188},{120,208}})));
    Modelica.Blocks.Interfaces.RealOutput yHea(final unit="1")
      "Control signal for heating"
      annotation (Placement(transformation(extent={{100,108},{120,128}})));
    Modelica.Blocks.Interfaces.RealOutput yOutAirFra(final unit="1")
      "Control signal for outside air fraction"
      annotation (Placement(transformation(extent={{100,-32},{120,-12}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput cooSta
      "Cooling status signal"
      annotation (Placement(transformation(extent={{100,-132},{120,-112}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput heaSta
      "Heating status signal"
      annotation (Placement(transformation(extent={{100,-92},{120,-72}})));
    Modelica.Blocks.Logical.OnOffController onOffConHea(bandwidth=DeadBand_hea)
      "Enable heating"
      annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
    Modelica.Blocks.Logical.OnOffController onOffConCoo(bandwidth=Deadband_coo)
      "Enable cooling"
      annotation (Placement(transformation(extent={{-60,-22},{-40,-2}})));
    Buildings.Controls.Continuous.LimPID conHea(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=false) "Heating feedback controller"
      annotation (Placement(transformation(extent={{0,108},{20,128}})));
    Modelica.Blocks.Logical.Switch swiHea "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{72,108},{92,128}})));
    Modelica.Blocks.Sources.Constant fanFloVen(k=mAir_flow_minOA/
          mAir_flow_nominal)
      "Fan airflow for ventilation"
      annotation (Placement(transformation(extent={{-60,158},{-40,178}})));
    Modelica.Blocks.Sources.Constant fanFloHea(k=mAir_flow_hea/mAir_flow_nominal)
      "Fan airflow for heating"
      annotation (Placement(transformation(extent={{-60,128},{-40,148}})));
    Modelica.Blocks.Sources.Constant fanFloCoo(k=mAir_flow_coo/mAir_flow_nominal)
      "Fan airflow for cooling"
      annotation (Placement(transformation(extent={{-60,98},{-40,118}})));
    Modelica.Blocks.Routing.Multiplex4 mulPle3
      "Multiplex for fan speed setpoints"
      annotation (Placement(transformation(extent={{40,188},{60,208}})));
    Modelica.Blocks.Routing.Extractor fanModSel(nin=4, index(start=1))
                                                       "Fan mode selector"
      annotation (Placement(transformation(extent={{70,188},{90,208}})));
    Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
      annotation (Placement(transformation(extent={{-60,188},{-40,208}})));
    FanMode_noCool FanMod_noCool "Fan mode determination"
      annotation (Placement(transformation(extent={{40,158},{60,178}})));
    Modelica.Blocks.Sources.Constant offHea(k=0) "Off signal"
      annotation (Placement(transformation(extent={{40,88},{60,108}})));
    Modelica.Blocks.Interfaces.RealInput TRet(final unit="K", displayUnit="degC")
      "Return air temperature"
      annotation (Placement(transformation(extent={{-140,-122},{-100,-82}})));
    Modelica.Blocks.Routing.Extractor oaFloSel(nin=4, index(start=1))
                                                      "OA flow selector"
      annotation (Placement(transformation(extent={{70,-32},{90,-12}})));
    Modelica.Blocks.Routing.Multiplex4 mulPle1
      "Multiplex for fan speed setpoints"
      annotation (Placement(transformation(extent={{40,-32},{60,-12}})));
    Modelica.Blocks.Sources.Constant off3(k=0) "Off signal"
      annotation (Placement(transformation(extent={{0,-2},{20,18}})));
    Modelica.Blocks.Sources.Constant full(k=1) "100% signal"
      annotation (Placement(transformation(extent={{0,-32},{20,-12}})));
    Modelica.Blocks.Sources.Constant minHea(k=mAir_flow_minOA/mAir_flow_hea)
      "Minimum OA during cooling mode"
      annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
    CooEcoSta cooEcoSta(k=k_eco, Ti=Ti_eco,
      EnableEconomizer=EnableEconomizer)
      annotation (Placement(transformation(extent={{0,-118},{20,-98}})));
    Modelica.Blocks.Sources.Constant minCoo(k=mAir_flow_minOA/mAir_flow_coo)
      "Minimum OA fraction during cooling mode"
      annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
    Modelica.Blocks.Logical.And andSat "Economizer is enabled and saturated"
      annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
    Modelica.Blocks.MathBoolean.Or or1(nu=2)
      "Economizer is enabled and saturated or economizer is not enabled"
      annotation (Placement(transformation(extent={{68,-102},{80,-90}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{46,-92},{54,-84}})));
    Modelica.Blocks.Logical.Not notCoo "Not for cooling control"
      annotation (Placement(transformation(extent={{-32,-16},{-24,-8}})));
    parameter Real k_hea=0.1 "Proportional gain of heating controller";
    parameter Modelica.Units.SI.Time Ti_hea=240
      "Integral time constant of heating controller";
    parameter Real k_coo=0.1 "Proportional gain of cooling controller";
    parameter Modelica.Units.SI.Time Ti_coo=240
      "Integral time constant of cooling controller";
    parameter Real k_eco=0.75 "Proportional gain of economizer controller";
    parameter Modelica.Units.SI.Time Ti_eco=240
      "Integral time constant of economizer controller";
    Modelica.Blocks.Logical.Switch swiFrePro
      "Switch for turning freeze protection on"
      annotation (Placement(transformation(extent={{72,138},{92,158}})));
    Buildings.Controls.Continuous.LimPID conFrePro(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=false) "Freeze protection feedback controller"
      annotation (Placement(transformation(extent={{0,-152},{20,-132}})));
    Modelica.Blocks.Interfaces.RealInput TMix(final unit="K", displayUnit="degC")
      "Mixed air temperature"
      annotation (Placement(transformation(extent={{-140,-182},{-100,-142}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput freSta
      "Freeze protection status signal"
      annotation (Placement(transformation(extent={{100,-172},{120,-152}})));
    Modelica.Blocks.Sources.Constant freProSet(k=273.15 + 10)
      "Setpoint temperature for freeze protection"
      annotation (Placement(transformation(extent={{-100,-144},{-80,-124}})));
    Modelica.Blocks.Logical.OnOffController onOffConFrePro(bandwidth=1)
      "Enable freeze protection"
      annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
    Modelica.Blocks.Logical.And andFre
      "Freeze protection and not in heating mode"
      annotation (Placement(transformation(extent={{-24,-160},{-12,-148}})));
    Modelica.Blocks.Logical.Not notCoo1
                                       "Not for cooling control"
      annotation (Placement(transformation(extent={{-40,-132},{-32,-124}})));
    Modelica.Blocks.Interfaces.RealInput TSup(final unit="K", displayUnit="degC")
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-140,-242},{-100,-202}})));
    Modelica.Blocks.Logical.Switch swiOccHea
      "Switch for turning ventilation needed during heating on/off"
      annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
    Modelica.Blocks.Logical.Switch swiOccCoo
      "Switch for turning ventilation needed during cooling on/off"
      annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  equation
    connect(TSetRooHea, onOffConHea.reference) annotation (Line(points={{-120,138},
            {-78,138},{-78,24},{-62,24}},  color={0,0,127}));
    connect(TRoo, onOffConHea.u) annotation (Line(points={{-120,18},{-94,18},{-94,
            12},{-62,12}},       color={0,0,127}));
    connect(TSetRooCoo, onOffConCoo.reference) annotation (Line(points={{-120,78},
            {-90,78},{-90,-6},{-62,-6}},   color={0,0,127}));
    connect(TRoo, onOffConCoo.u) annotation (Line(points={{-120,18},{-94,18},{-94,
            -18},{-62,-18}},     color={0,0,127}));
    connect(conHea.y, swiHea.u1) annotation (Line(points={{21,118},{26,118},{26,126},
            {70,126}},      color={0,0,127}));
    connect(conHea.u_s, onOffConHea.reference) annotation (Line(points={{-2,118},{
            -10,118},{-10,38},{-78,38},{-78,24},{-62,24}},
                                            color={0,0,127}));
    connect(mulPle3.y,fanModSel. u) annotation (Line(points={{61,198},{68,198}},
                                            color={0,0,127}));
    connect(fanModSel.y, yFan)
      annotation (Line(points={{91,198},{110,198}}, color={0,0,127}));
    connect(off.y, mulPle3.u1[1]) annotation (Line(points={{-39,198},{-30,198},{-30,
            207},{38,207}},     color={0,0,127}));
    connect(fanFloVen.y, mulPle3.u2[1]) annotation (Line(points={{-39,168},{-28,168},
            {-28,201},{38,201}},      color={0,0,127}));
    connect(fanFloHea.y, mulPle3.u3[1]) annotation (Line(points={{-39,138},{-26,138},
            {-26,195},{38,195}},      color={0,0,127}));
    connect(fanFloCoo.y, mulPle3.u4[1]) annotation (Line(points={{-39,108},{-24,108},
            {-24,189},{38,189}}, color={0,0,127}));
    connect(fanMod.y1, fanModSel.index)
      annotation (Line(points={{61,168},{80,168},{80,186}}, color={255,127,0}));
    connect(fanMod.coo, cooSta) annotation (Line(points={{38,160},{-16,160},{-16,-122},
            {110,-122}},       color={255,0,255}));
    connect(onOffConHea.y, fanMod.hea) annotation (Line(points={{-39,18},{-18,18},
            {-18,168},{38,168}},      color={255,0,255}));
    connect(onOffConHea.y, heaSta) annotation (Line(points={{-39,18},{-18,18},{-18,
            -68},{96,-68},{96,-82},{110,-82}},         color={255,0,255}));
    connect(offHea.y, swiHea.u3) annotation (Line(points={{61,98},{64,98},{64,110},
            {70,110}},color={0,0,127}));
    connect(off3.y, mulPle1.u1[1]) annotation (Line(points={{21,8},{26,8},{26,-13},
            {38,-13}},      color={0,0,127}));
    connect(mulPle1.y, oaFloSel.u)
      annotation (Line(points={{61,-22},{68,-22}}, color={0,0,127}));
    connect(full.y, mulPle1.u2[1]) annotation (Line(points={{21,-22},{26,-22},{26,
            -19},{38,-19}}, color={0,0,127}));
    connect(conHea.u_m, onOffConHea.u) annotation (Line(points={{10,106},{10,86},{
            -94,86},{-94,12},{-62,12}},   color={0,0,127}));
    connect(cooEcoSta.yFra, mulPle1.u4[1]) annotation (Line(points={{21,-108},{26,
            -108},{26,-31},{38,-31}}, color={0,0,127}));
    connect(cooEcoSta.TSetRooCoo, onOffConCoo.reference) annotation (Line(points={{-2,-98},
            {-90,-98},{-90,-6},{-62,-6}},               color={0,0,127}));
    connect(cooEcoSta.TRoo, onOffConCoo.u) annotation (Line(points={{-2,-102},{-94,
            -102},{-94,-18},{-62,-18}},     color={0,0,127}));
    connect(TEco, cooEcoSta.TEco) annotation (Line(points={{-120,-40},{-86,-40},{
            -86,-106},{-2,-106}},  color={0,0,127}));
    connect(cooEcoSta.TRet, TRet) annotation (Line(points={{-2,-110},{-62,-110},{-62,
            -102},{-120,-102}},     color={0,0,127}));
    connect(yOutAirFra, oaFloSel.y)
      annotation (Line(points={{110,-22},{91,-22}}, color={0,0,127}));
    connect(fanMod.y1, oaFloSel.index) annotation (Line(points={{61,168},{98,168},
            {98,-42},{80,-42},{80,-34}}, color={255,127,0}));
    connect(cooEcoSta.ena, andSat.u1) annotation (Line(points={{21,-112},{30,-112},
            {30,-110},{38,-110}}, color={255,0,255}));
    connect(cooEcoSta.sat, andSat.u2) annotation (Line(points={{21,-116},{30,-116},
            {30,-118},{38,-118}}, color={255,0,255}));
    connect(cooEcoSta.ena, not1.u) annotation (Line(points={{21,-112},{32,-112},{32,
            -88},{45.2,-88}},      color={255,0,255}));
    connect(not1.y, or1.u[1]) annotation (Line(points={{54.4,-88},{64,-88},{64,
            -93.9},{68,-93.9}},   color={255,0,255}));
    connect(andSat.y, or1.u[2]) annotation (Line(points={{61,-110},{64,-110},{64,
            -98.1},{68,-98.1}},
                          color={255,0,255}));
    connect(cooEcoSta.cooEna, cooSta) annotation (Line(points={{-2,-118},{-16,-118},
            {-16,-122},{110,-122}}, color={255,0,255}));
    connect(fanMod.ven, occSta) annotation (Line(points={{38,176},{-20,176},{-20,78},
            {-70,78},{-70,198},{-120,198}}, color={255,0,255}));
    connect(onOffConCoo.y, notCoo.u)
      annotation (Line(points={{-39,-12},{-32.8,-12}}, color={255,0,255}));
    connect(notCoo.y, cooSta) annotation (Line(points={{-23.6,-12},{-16,-12},{-16,
            -122},{110,-122}}, color={255,0,255}));
    connect(swiHea.u2, fanMod.hea) annotation (Line(points={{70,118},{32,118},{32,
            84},{-18,84},{-18,168},{38,168}}, color={255,0,255}));
    connect(conHea.trigger, fanMod.hea) annotation (Line(points={{2,106},{2,98},{32,
            98},{32,84},{-18,84},{-18,168},{38,168}}, color={255,0,255}));
    connect(freProSet.y, onOffConFrePro.reference) annotation (Line(points={{-79,-134},
            {-70,-134},{-70,-144},{-62,-144}}, color={0,0,127}));
    connect(TMix, onOffConFrePro.u) annotation (Line(points={{-120,-162},{-69,-162},
            {-69,-156},{-62,-156}}, color={0,0,127}));
    connect(onOffConFrePro.y, andFre.u2) annotation (Line(points={{-39,-150},{-34,
            -150},{-34,-158.8},{-25.2,-158.8}}, color={255,0,255}));
    connect(notCoo1.y, andFre.u1) annotation (Line(points={{-31.6,-128},{-25.2,-128},
            {-25.2,-154}}, color={255,0,255}));
    connect(onOffConHea.y, notCoo1.u) annotation (Line(points={{-39,18},{-18,18},{
            -18,-118},{-50,-118},{-50,-128},{-40.8,-128}}, color={255,0,255}));
    connect(andFre.y, freSta) annotation (Line(points={{-11.4,-154},{-10,-154},{-10,
            -158},{28,-158},{28,-162},{110,-162}}, color={255,0,255}));
    connect(conFrePro.trigger, freSta) annotation (Line(points={{2,-154},{2,-158},
            {28,-158},{28,-162},{110,-162}}, color={255,0,255}));
    connect(freProSet.y, conFrePro.u_s) annotation (Line(points={{-79,-134},{-20,-134},
            {-20,-142},{-2,-142}}, color={0,0,127}));
    connect(swiFrePro.u2, freSta) annotation (Line(points={{70,148},{28,148},{28,-162},
            {110,-162}}, color={255,0,255}));
    connect(swiHea.y, swiFrePro.u3) annotation (Line(points={{93,118},{94,118},{94,
            134},{66,134},{66,140},{70,140}}, color={0,0,127}));
    connect(swiFrePro.y, yHea) annotation (Line(points={{93,148},{96,148},{96,118},
            {110,118}}, color={0,0,127}));
    connect(conFrePro.y, swiFrePro.u1) annotation (Line(points={{21,-142},{30,-142},
            {30,156},{70,156}}, color={0,0,127}));
    connect(TSup, conFrePro.u_m) annotation (Line(points={{-120,-222},{10,-222},{10,
            -154}}, color={0,0,127}));
    connect(swiOccHea.y, mulPle1.u3[1]) annotation (Line(points={{21,-50},{22,-50},
            {22,-25},{38,-25}}, color={0,0,127}));
    connect(minHea.y, swiOccHea.u1) annotation (Line(points={{-39,-50},{-32,-50},
            {-32,-42},{-2,-42}}, color={0,0,127}));
    connect(off.y, swiOccHea.u3) annotation (Line(points={{-39,198},{-36,198},{
            -36,-58},{-2,-58}}, color={0,0,127}));
    connect(swiOccHea.u2, occSta) annotation (Line(points={{-2,-50},{-20,-50},{
            -20,78},{-70,78},{-70,198},{-120,198}}, color={255,0,255}));
    connect(swiOccCoo.u2, occSta) annotation (Line(points={{-2,-80},{-20,-80},{
            -20,78},{-70,78},{-70,198},{-120,198}}, color={255,0,255}));
    connect(swiOccCoo.u3, swiOccHea.u3) annotation (Line(points={{-2,-88},{-36,
            -88},{-36,-58},{-2,-58}}, color={0,0,127}));
    connect(minCoo.y, swiOccCoo.u1) annotation (Line(points={{-39,-80},{-28,-80},
            {-28,-72},{-2,-72}}, color={0,0,127}));
    connect(swiOccCoo.y, cooEcoSta.minCooFra) annotation (Line(points={{21,-80},{
            24,-80},{24,-94},{-6,-94},{-6,-114},{-2,-114}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},
              {100,220}}),       graphics={
                                  Rectangle(
          extent={{-100,-220},{100,220}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},{100,220}})));
  end RTU_noCool;

  model FanMode_noCool "Fan mode selector"
    extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.BooleanInput ven "Ventilation"
      annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
    Modelica.Blocks.Interfaces.BooleanInput hea "Heating"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Math.BooleanToReal booIntVen(realTrue=2, realFalse=1)
      "Boolean to integer conversion for ventilation"
      annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
    Modelica.Blocks.Interfaces.IntegerOutput y1
                                      "Connector of Integer output signal"
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Math.BooleanToReal booIntHea(realTrue=3, realFalse=1)
      "Boolean to integer conversion for heating"
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    Modelica.Blocks.Math.MinMax minMax(nu=2)
      annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
    Modelica.Blocks.Math.RealToInteger reaInt "Convert real number to integer"
      annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  equation
    connect(ven, booIntVen.u)
      annotation (Line(points={{-120,80},{-82,80}}, color={255,0,255}));
    connect(hea, booIntHea.u)
      annotation (Line(points={{-120,0},{-82,0}}, color={255,0,255}));
    connect(booIntVen.y, minMax.u[1]) annotation (Line(points={{-59,80},{-40,80},
            {-40,3.5},{-8,3.5}},         color={0,0,127}));
    connect(booIntHea.y, minMax.u[2]) annotation (Line(points={{-59,0},{-34,0},
            {-34,-3.5},{-8,-3.5}},
                            color={0,0,127}));
    connect(minMax.yMax, reaInt.u)
      annotation (Line(points={{13,6},{30,6},{30,0},{38,0}}, color={0,0,127}));
    connect(reaInt.y, y1)
      annotation (Line(points={{61,0},{110,0}}, color={255,127,0}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end FanMode_noCool;

  model Cycle_Timer
    Modelica.Blocks.Interfaces.BooleanInput
                                         u_Sta annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}}),iconTransformation(
            extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.BooleanOutput
                                          y_Sta
      annotation (Placement(transformation(extent={{100,-14},{128,14}})));
    Modelica.Blocks.MathBoolean.OnDelay
                                  onDelay(delayTime=120)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(u_Sta, onDelay.u)
      annotation (Line(points={{-120,0},{-14,0}}, color={255,0,255}));
    connect(onDelay.y, y_Sta)
      annotation (Line(points={{12,0},{114,0}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
            Rectangle(
            extent={{-100,102},{100,-98}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Ellipse(extent={{-80,82},{80,-78}}, lineColor={160,160,164}),
          Line(points={{0,82},{0,62}}, color={160,160,164}),
          Line(points={{80,2},{60,2}}, color={160,160,164}),
          Line(points={{0,-78},{0,-58}}, color={160,160,164}),
          Line(points={{-80,2},{-60,2}}, color={160,160,164}),
          Line(points={{37,72},{26,52}}, color={160,160,164}),
          Line(points={{70,40},{49,28}}, color={160,160,164}),
          Line(points={{71,-35},{52,-25}}, color={160,160,164}),
          Line(points={{39,-68},{29,-49}}, color={160,160,164}),
          Line(points={{-39,-68},{-29,-50}}, color={160,160,164}),
          Line(points={{-71,-35},{-50,-24}}, color={160,160,164}),
          Line(points={{-71,39},{-54,30}}, color={160,160,164}),
          Line(points={{-38,72},{-28,53}}, color={160,160,164}),
          Line(
            points={{0,2},{-50,52}},
            thickness=0.5),
          Line(
            points={{0,2},{40,2}},
            thickness=0.5)}), Diagram(coordinateSystem(preserveAspectRatio=
              false)));
  end Cycle_Timer;

  model RTU_XRB_controls "Implements common control for RTU system"
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
      "Design air flowrate of supply fan";
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_minOA
      "Minimum outdoor air flowrate";
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_hea
      "Heating air flowrate";
    parameter Modelica.Units.SI.MassFlowRate mAir_flow_coo
      "Cooling outdoor air flowrate";
    parameter Boolean  EnableEconomizer = true "Enable economizer operation";
    parameter Modelica.Units.SI.TemperatureDifference Deadband_coo=1
      "Cooling deadband";
    parameter Modelica.Units.SI.TemperatureDifference DeadBand_hea=1
      "Heating deadband";
    Modelica.Blocks.Interfaces.BooleanInput occSta
      "Indicates occupancy or standby mode"
      annotation (Placement(transformation(extent={{-140,178},{-100,218}})));
    Modelica.Blocks.Interfaces.RealInput TSetRooHea(final unit="K", displayUnit=
          "degC")
      "Zone heating setpoint temperature" annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,138})));
    Modelica.Blocks.Interfaces.RealInput TSetRooCoo(final unit="K", displayUnit=
          "degC") "Zone cooling setpoint temperature"
                                          annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-106,76})));
    Modelica.Blocks.Interfaces.RealInput TEco(final unit="K", displayUnit="degC")
      "Economizer input temperature (e.g. outside drybulb temperature or wetbulb temperature)"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
    Modelica.Blocks.Interfaces.RealInput TRoo(final unit="K", displayUnit="degC")
                          "Zone temperature measurement"
    annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-110,16})));
    Modelica.Blocks.Interfaces.RealOutput yFan(final unit="1")
      "Control signal for fan"
      annotation (Placement(transformation(extent={{100,188},{120,208}})));
    Modelica.Blocks.Interfaces.RealOutput yHea(final unit="1")
      "Control signal for heating"
      annotation (Placement(transformation(extent={{100,108},{120,128}})));
    Modelica.Blocks.Interfaces.RealOutput yOutAirFra(final unit="1")
      "Control signal for outside air fraction"
      annotation (Placement(transformation(extent={{100,-32},{120,-12}})));
    Modelica.Blocks.Interfaces.RealOutput yCoo(final unit="1")
      "Control signal for cooling"
      annotation (Placement(transformation(extent={{104,46},{124,66}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput cooSta
      "Cooling status signal"
      annotation (Placement(transformation(extent={{100,-132},{120,-112}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput heaSta
      "Heating status signal"
      annotation (Placement(transformation(extent={{100,-92},{120,-72}})));
    Modelica.Blocks.Logical.OnOffController onOffConHea(bandwidth=DeadBand_hea)
      "Enable heating"
      annotation (Placement(transformation(extent={{-52,8},{-32,28}})));
    Modelica.Blocks.Logical.OnOffController onOffConCoo(bandwidth=Deadband_coo)
      "Enable cooling"
      annotation (Placement(transformation(extent={{-60,-22},{-40,-2}})));
    Buildings.Controls.Continuous.LimPID conHea(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=false) "Heating feedback controller"
      annotation (Placement(transformation(extent={{0,108},{20,128}})));
    Modelica.Blocks.Logical.Switch swiHea "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{72,108},{92,128}})));
    Modelica.Blocks.Logical.Switch swiCoo "Switch for turning cooling on/off"
      annotation (Placement(transformation(extent={{80,46},{100,66}})));
    Buildings.Controls.Continuous.LimPID conCoo(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_coo,
      final yMax=1,
      final yMin=0,
      final k=k_coo,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=true) "Cooling feedback controller"
      annotation (Placement(transformation(extent={{8,46},{28,66}})));
    Modelica.Blocks.Sources.Constant fanFloVen(k=mAir_flow_minOA/
          mAir_flow_nominal)
      "Fan airflow for ventilation"
      annotation (Placement(transformation(extent={{-60,158},{-40,178}})));
    Modelica.Blocks.Sources.Constant fanFloHea(k=mAir_flow_hea/mAir_flow_nominal)
      "Fan airflow for heating"
      annotation (Placement(transformation(extent={{-60,128},{-40,148}})));
    Modelica.Blocks.Sources.Constant fanFloCoo(k=mAir_flow_coo/mAir_flow_nominal)
      "Fan airflow for cooling"
      annotation (Placement(transformation(extent={{-60,98},{-40,118}})));
    Modelica.Blocks.Routing.Multiplex4 mulPle3
      "Multiplex for fan speed setpoints"
      annotation (Placement(transformation(extent={{40,188},{60,208}})));
    Modelica.Blocks.Routing.Extractor fanModSel(nin=4, index(start=1))
                                                       "Fan mode selector"
      annotation (Placement(transformation(extent={{70,188},{90,208}})));
    Modelica.Blocks.Sources.Constant off(k=0) "Off signal"
      annotation (Placement(transformation(extent={{-60,188},{-40,208}})));
    FanMode fanMod "Fan mode determination"
      annotation (Placement(transformation(extent={{40,158},{60,178}})));
    Modelica.Blocks.Sources.Constant offHea(k=0) "Off signal"
      annotation (Placement(transformation(extent={{38,68},{58,88}})));
    Modelica.Blocks.Sources.Constant offCoo(k=0) "Off signal"
      annotation (Placement(transformation(extent={{48,26},{68,46}})));
    Modelica.Blocks.Interfaces.RealInput TRet(final unit="K", displayUnit="degC")
      "Return air temperature"
      annotation (Placement(transformation(extent={{-140,-122},{-100,-82}})));
    Modelica.Blocks.Routing.Extractor oaFloSel(nin=4, index(start=1))
                                                      "OA flow selector"
      annotation (Placement(transformation(extent={{70,-32},{90,-12}})));
    Modelica.Blocks.Routing.Multiplex4 mulPle1
      "Multiplex for fan speed setpoints"
      annotation (Placement(transformation(extent={{40,-32},{60,-12}})));
    Modelica.Blocks.Sources.Constant off3(k=0) "Off signal"
      annotation (Placement(transformation(extent={{0,-2},{20,18}})));
    Modelica.Blocks.Sources.Constant full(k=1) "100% signal"
      annotation (Placement(transformation(extent={{0,-32},{20,-12}})));
    Modelica.Blocks.Sources.Constant minHea(k=mAir_flow_minOA/mAir_flow_hea)
      "Minimum OA during cooling mode"
      annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
    CooEcoSta cooEcoSta(k=k_eco, Ti=Ti_eco,
      EnableEconomizer=EnableEconomizer)
      annotation (Placement(transformation(extent={{0,-118},{20,-98}})));
    Modelica.Blocks.Sources.Constant minCoo(k=mAir_flow_minOA/mAir_flow_coo)
      "Minimum OA fraction during cooling mode"
      annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
    Modelica.Blocks.Logical.And andSat "Economizer is enabled and saturated"
      annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
    Modelica.Blocks.MathBoolean.Or or1(nu=2)
      "Economizer is enabled and saturated or economizer is not enabled"
      annotation (Placement(transformation(extent={{68,-102},{80,-90}})));
    Modelica.Blocks.Logical.Not not1
      annotation (Placement(transformation(extent={{46,-92},{54,-84}})));
    Modelica.Blocks.Logical.And andCoo
      "Economizer is enabled and saturated or not enabled, and cooling is enabled"
      annotation (Placement(transformation(extent={{70,-2},{50,18}})));
    Modelica.Blocks.Logical.Not notCoo "Not for cooling control"
      annotation (Placement(transformation(extent={{-32,-16},{-24,-8}})));
    parameter Real k_hea=0.1 "Proportional gain of heating controller";
    parameter Modelica.Units.SI.Time Ti_hea=240
      "Integral time constant of heating controller";
    parameter Real k_coo=0.1 "Proportional gain of cooling controller";
    parameter Modelica.Units.SI.Time Ti_coo=240
      "Integral time constant of cooling controller";
    parameter Real k_eco=0.75 "Proportional gain of economizer controller";
    parameter Modelica.Units.SI.Time Ti_eco=240
      "Integral time constant of economizer controller";
    Modelica.Blocks.Logical.Switch swiFrePro
      "Switch for turning freeze protection on"
      annotation (Placement(transformation(extent={{72,138},{92,158}})));
    Buildings.Controls.Continuous.LimPID conFrePro(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=false) "Freeze protection feedback controller"
      annotation (Placement(transformation(extent={{0,-152},{20,-132}})));
    Modelica.Blocks.Interfaces.RealInput TMix(final unit="K", displayUnit="degC")
      "Mixed air temperature"
      annotation (Placement(transformation(extent={{-140,-182},{-100,-142}})));
    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput freSta
      "Freeze protection status signal"
      annotation (Placement(transformation(extent={{100,-172},{120,-152}})));
    Modelica.Blocks.Sources.Constant freProSet(k=273.15 + 10)
      "Setpoint temperature for freeze protection"
      annotation (Placement(transformation(extent={{-100,-144},{-80,-124}})));
    Modelica.Blocks.Logical.OnOffController onOffConFrePro(bandwidth=1)
      "Enable freeze protection"
      annotation (Placement(transformation(extent={{-60,-160},{-40,-140}})));
    Modelica.Blocks.Logical.And andFre
      "Freeze protection and not in heating mode"
      annotation (Placement(transformation(extent={{-24,-160},{-12,-148}})));
    Modelica.Blocks.Logical.Not notCoo1
                                       "Not for cooling control"
      annotation (Placement(transformation(extent={{-40,-132},{-32,-124}})));
    Modelica.Blocks.Interfaces.RealInput TSup(final unit="K", displayUnit="degC")
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-140,-242},{-100,-202}})));
    Modelica.Blocks.Logical.Switch swiOccHea
      "Switch for turning ventilation needed during heating on/off"
      annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
    Modelica.Blocks.Logical.Switch swiOccCoo
      "Switch for turning ventilation needed during cooling on/off"
      annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
    Modelica.Blocks.Logical.OnOffController onOffConSupHeatSetPoi(bandwidth=
          1.94) "Enable freeze protection"
      annotation (Placement(transformation(extent={{36,-210},{56,-190}})));
    Modelica.Blocks.Sources.Constant UpperLimSup(k=273.15 + 32.2)
      "Setpoint temperature for freeze protection"
      annotation (Placement(transformation(extent={{-28,-194},{-8,-174}})));
    Modelica.Blocks.MathBoolean.Or or2(nu=2)
      "Economizer is enabled and saturated or economizer is not enabled"
      annotation (Placement(transformation(extent={{48,108},{60,120}})));
  equation
    connect(TSetRooHea, onOffConHea.reference) annotation (Line(points={{-120,
            138},{-78,138},{-78,24},{-54,24}},
                                           color={0,0,127}));
    connect(TRoo, onOffConHea.u) annotation (Line(points={{-110,16},{-94,16},{
            -94,12},{-54,12}},   color={0,0,127}));
    connect(TSetRooCoo, onOffConCoo.reference) annotation (Line(points={{-106,76},
            {-90,76},{-90,-6},{-62,-6}},   color={0,0,127}));
    connect(TRoo, onOffConCoo.u) annotation (Line(points={{-110,16},{-94,16},{
            -94,-18},{-62,-18}}, color={0,0,127}));
    connect(conHea.y, swiHea.u1) annotation (Line(points={{21,118},{26,118},{26,126},
            {70,126}},      color={0,0,127}));
    connect(conHea.u_s, onOffConHea.reference) annotation (Line(points={{-2,118},
            {-10,118},{-10,38},{-78,38},{-78,24},{-54,24}},
                                            color={0,0,127}));
    connect(swiCoo.y, yCoo) annotation (Line(points={{101,56},{102,56},{102,54},
            {106,54},{106,56},{114,56}},
                      color={0,0,127}));
    connect(mulPle3.y,fanModSel. u) annotation (Line(points={{61,198},{68,198}},
                                            color={0,0,127}));
    connect(fanModSel.y, yFan)
      annotation (Line(points={{91,198},{110,198}}, color={0,0,127}));
    connect(off.y, mulPle3.u1[1]) annotation (Line(points={{-39,198},{-30,198},{-30,
            207},{38,207}},     color={0,0,127}));
    connect(fanFloVen.y, mulPle3.u2[1]) annotation (Line(points={{-39,168},{-28,168},
            {-28,201},{38,201}},      color={0,0,127}));
    connect(fanFloHea.y, mulPle3.u3[1]) annotation (Line(points={{-39,138},{-26,138},
            {-26,195},{38,195}},      color={0,0,127}));
    connect(fanFloCoo.y, mulPle3.u4[1]) annotation (Line(points={{-39,108},{-24,108},
            {-24,189},{38,189}}, color={0,0,127}));
    connect(fanMod.y1, fanModSel.index)
      annotation (Line(points={{61,168},{80,168},{80,186}}, color={255,127,0}));
    connect(fanMod.coo, cooSta) annotation (Line(points={{38,160},{-16,160},{-16,-122},
            {110,-122}},       color={255,0,255}));
    connect(onOffConHea.y, fanMod.hea) annotation (Line(points={{-31,18},{-18,
            18},{-18,168},{38,168}},  color={255,0,255}));
    connect(onOffConHea.y, heaSta) annotation (Line(points={{-31,18},{-18,18},{
            -18,-68},{96,-68},{96,-82},{110,-82}},     color={255,0,255}));
    connect(offHea.y, swiHea.u3) annotation (Line(points={{59,78},{64,78},{64,
            110},{70,110}},
                      color={0,0,127}));
    connect(offCoo.y, swiCoo.u3)
      annotation (Line(points={{69,36},{64,36},{64,48},{78,48}},
                                                               color={0,0,127}));
    connect(TSetRooCoo, conCoo.u_s) annotation (Line(points={{-106,76},{-90,76},
            {-90,4},{-8,4},{-8,56},{6,56}},     color={0,0,127}));
    connect(off3.y, mulPle1.u1[1]) annotation (Line(points={{21,8},{26,8},{26,-13},
            {38,-13}},      color={0,0,127}));
    connect(mulPle1.y, oaFloSel.u)
      annotation (Line(points={{61,-22},{68,-22}}, color={0,0,127}));
    connect(full.y, mulPle1.u2[1]) annotation (Line(points={{21,-22},{26,-22},{26,
            -19},{38,-19}}, color={0,0,127}));
    connect(TRoo, conCoo.u_m) annotation (Line(points={{-110,16},{-94,16},{-94,
            42},{18,42},{18,44}},
                               color={0,0,127}));
    connect(conHea.u_m, onOffConHea.u) annotation (Line(points={{10,106},{10,86},
            {-94,86},{-94,12},{-54,12}},  color={0,0,127}));
    connect(conCoo.y, swiCoo.u1) annotation (Line(points={{29,56},{28,56},{28,
            64},{78,64}},
                      color={0,0,127}));
    connect(cooEcoSta.yFra, mulPle1.u4[1]) annotation (Line(points={{21,-108},{26,
            -108},{26,-31},{38,-31}}, color={0,0,127}));
    connect(cooEcoSta.TSetRooCoo, onOffConCoo.reference) annotation (Line(points={{-2,-98},
            {-90,-98},{-90,-6},{-62,-6}},               color={0,0,127}));
    connect(cooEcoSta.TRoo, onOffConCoo.u) annotation (Line(points={{-2,-102},{-94,
            -102},{-94,-18},{-62,-18}},     color={0,0,127}));
    connect(TEco, cooEcoSta.TEco) annotation (Line(points={{-120,-40},{-86,-40},{
            -86,-106},{-2,-106}},  color={0,0,127}));
    connect(cooEcoSta.TRet, TRet) annotation (Line(points={{-2,-110},{-62,-110},{-62,
            -102},{-120,-102}},     color={0,0,127}));
    connect(yOutAirFra, oaFloSel.y)
      annotation (Line(points={{110,-22},{91,-22}}, color={0,0,127}));
    connect(fanMod.y1, oaFloSel.index) annotation (Line(points={{61,168},{98,168},
            {98,-42},{80,-42},{80,-34}}, color={255,127,0}));
    connect(cooEcoSta.ena, andSat.u1) annotation (Line(points={{21,-112},{30,-112},
            {30,-110},{38,-110}}, color={255,0,255}));
    connect(cooEcoSta.sat, andSat.u2) annotation (Line(points={{21,-116},{30,-116},
            {30,-118},{38,-118}}, color={255,0,255}));
    connect(cooEcoSta.ena, not1.u) annotation (Line(points={{21,-112},{32,-112},{32,
            -88},{45.2,-88}},      color={255,0,255}));
    connect(not1.y, or1.u[1]) annotation (Line(points={{54.4,-88},{64,-88},{64,
            -93.9},{68,-93.9}},   color={255,0,255}));
    connect(andSat.y, or1.u[2]) annotation (Line(points={{61,-110},{64,-110},{64,
            -98.1},{68,-98.1}},
                          color={255,0,255}));
    connect(or1.y, andCoo.u2) annotation (Line(points={{80.9,-96},{98,-96},{98,
            -42},{80,-42},{80,4},{86,4},{86,0},{72,0}},    color={255,0,255}));
    connect(andCoo.u1, cooSta) annotation (Line(points={{72,8},{78,8},{78,30},{
            -8,30},{-8,-122},{110,-122}},     color={255,0,255}));
    connect(cooEcoSta.cooEna, cooSta) annotation (Line(points={{-2,-118},{-16,-118},
            {-16,-122},{110,-122}}, color={255,0,255}));
    connect(fanMod.ven, occSta) annotation (Line(points={{38,176},{-20,176},{-20,78},
            {-70,78},{-70,198},{-120,198}}, color={255,0,255}));
    connect(onOffConCoo.y, notCoo.u)
      annotation (Line(points={{-39,-12},{-32.8,-12}}, color={255,0,255}));
    connect(notCoo.y, cooSta) annotation (Line(points={{-23.6,-12},{-16,-12},{-16,
            -122},{110,-122}}, color={255,0,255}));
    connect(swiCoo.u2, andCoo.y) annotation (Line(points={{78,56},{32,56},{32,8},
            {49,8}},color={255,0,255}));
    connect(conHea.trigger, fanMod.hea) annotation (Line(points={{2,106},{2,98},{32,
            98},{32,84},{-18,84},{-18,168},{38,168}}, color={255,0,255}));
    connect(conCoo.trigger, andCoo.y) annotation (Line(points={{10,44},{10,38},
            {32,38},{32,8},{49,8}},
                            color={255,0,255}));
    connect(freProSet.y, onOffConFrePro.reference) annotation (Line(points={{-79,-134},
            {-70,-134},{-70,-144},{-62,-144}}, color={0,0,127}));
    connect(TMix, onOffConFrePro.u) annotation (Line(points={{-120,-162},{-69,-162},
            {-69,-156},{-62,-156}}, color={0,0,127}));
    connect(onOffConFrePro.y, andFre.u2) annotation (Line(points={{-39,-150},{-34,
            -150},{-34,-158.8},{-25.2,-158.8}}, color={255,0,255}));
    connect(notCoo1.y, andFre.u1) annotation (Line(points={{-31.6,-128},{-25.2,-128},
            {-25.2,-154}}, color={255,0,255}));
    connect(onOffConHea.y, notCoo1.u) annotation (Line(points={{-31,18},{-8,18},
            {-8,-120},{-40,-120},{-40,-128},{-40.8,-128}}, color={255,0,255}));
    connect(andFre.y, freSta) annotation (Line(points={{-11.4,-154},{-10,-154},{-10,
            -158},{28,-158},{28,-162},{110,-162}}, color={255,0,255}));
    connect(conFrePro.trigger, freSta) annotation (Line(points={{2,-154},{2,-158},
            {28,-158},{28,-162},{110,-162}}, color={255,0,255}));
    connect(freProSet.y, conFrePro.u_s) annotation (Line(points={{-79,-134},{-20,-134},
            {-20,-142},{-2,-142}}, color={0,0,127}));
    connect(swiFrePro.u2, freSta) annotation (Line(points={{70,148},{28,148},{28,-162},
            {110,-162}}, color={255,0,255}));
    connect(swiHea.y, swiFrePro.u3) annotation (Line(points={{93,118},{94,118},{94,
            134},{66,134},{66,140},{70,140}}, color={0,0,127}));
    connect(swiFrePro.y, yHea) annotation (Line(points={{93,148},{96,148},{96,118},
            {110,118}}, color={0,0,127}));
    connect(conFrePro.y, swiFrePro.u1) annotation (Line(points={{21,-142},{30,-142},
            {30,156},{70,156}}, color={0,0,127}));
    connect(TSup, conFrePro.u_m) annotation (Line(points={{-120,-222},{10,-222},
            {10,-154}},
                    color={0,0,127}));
    connect(swiOccHea.y, mulPle1.u3[1]) annotation (Line(points={{21,-50},{22,-50},
            {22,-25},{38,-25}}, color={0,0,127}));
    connect(minHea.y, swiOccHea.u1) annotation (Line(points={{-39,-50},{-32,-50},
            {-32,-42},{-2,-42}}, color={0,0,127}));
    connect(off.y, swiOccHea.u3) annotation (Line(points={{-39,198},{-36,198},{
            -36,-58},{-2,-58}}, color={0,0,127}));
    connect(swiOccHea.u2, occSta) annotation (Line(points={{-2,-50},{-20,-50},{
            -20,78},{-70,78},{-70,198},{-120,198}}, color={255,0,255}));
    connect(swiOccCoo.u2, occSta) annotation (Line(points={{-2,-80},{-20,-80},{
            -20,78},{-70,78},{-70,198},{-120,198}}, color={255,0,255}));
    connect(swiOccCoo.u3, swiOccHea.u3) annotation (Line(points={{-2,-88},{-36,
            -88},{-36,-58},{-2,-58}}, color={0,0,127}));
    connect(minCoo.y, swiOccCoo.u1) annotation (Line(points={{-39,-80},{-28,-80},
            {-28,-72},{-2,-72}}, color={0,0,127}));
    connect(swiOccCoo.y, cooEcoSta.minCooFra) annotation (Line(points={{21,-80},{
            24,-80},{24,-94},{-6,-94},{-6,-114},{-2,-114}}, color={0,0,127}));
    connect(TSup, onOffConSupHeatSetPoi.u) annotation (Line(points={{-120,-222},
            {-42,-222},{-42,-206},{34,-206}}, color={0,0,127}));
    connect(UpperLimSup.y, onOffConSupHeatSetPoi.reference) annotation (Line(
          points={{-7,-184},{14,-184},{14,-194},{34,-194}}, color={0,0,127}));
    connect(fanMod.hea, or2.u[1]) annotation (Line(points={{38,168},{44,168},{
            44,116.1},{48,116.1}}, color={255,0,255}));
    connect(or2.y, swiHea.u2) annotation (Line(points={{60.9,114},{66,114},{66,
            118},{70,118}}, color={255,0,255}));
    connect(onOffConSupHeatSetPoi.y, or2.u[2]) annotation (Line(points={{57,
            -200},{40,-200},{40,111.9},{48,111.9}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},
              {100,220}}),       graphics={
                                  Rectangle(
          extent={{-100,-220},{100,220}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},{100,220}})));
  end RTU_XRB_controls;

  model RTU_control_FMU "Implements common control for RTU system"


    Modelica.Blocks.Interfaces.RealInput TSetRooHea(final unit="K", displayUnit=
          "degC")
      "Zone heating setpoint temperature" annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,140})));
    Modelica.Blocks.Interfaces.RealInput TRoo(final unit="K", displayUnit="degC")
      "Zone temperature measurement"
    annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-120,20})));
    Modelica.Blocks.Interfaces.RealOutput heaSta(final unit="1")
      "Control signal for heating"
      annotation (Placement(transformation(extent={{100,92},{136,128}})));
    Buildings.Controls.Continuous.LimPID conHea(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      initType=Modelica.Blocks.Types.Init.InitialOutput,
      y_start=0,
      reset=Buildings.Types.Reset.Parameter) "Heating feedback controller"
      annotation (Placement(transformation(extent={{-58,130},{-38,150}})));
    Modelica.Blocks.Logical.Switch swiHea "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{4,86},{24,106}})));
    Modelica.Blocks.Sources.Constant offHea(k=0) "Off signal"
      annotation (Placement(transformation(extent={{-50,34},{-30,54}})));
    parameter Real k_hea=0.1 "Proportional gain of heating controller";
    parameter Modelica.Units.SI.Time Ti_hea=240
      "Integral time constant of heating controller";

    Modelica.Blocks.Interfaces.RealInput TSup(final unit="K", displayUnit="degC")
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
    Modelica.Blocks.Logical.OnOffController onOffConSupHeatSetPoi(bandwidth=0.5)
                "Enable freeze protection"
      annotation (Placement(transformation(extent={{-30,-92},{-10,-72}})));
    Modelica.Blocks.Sources.Constant UpperLimSup(k=273.15 + 32.2)
      "Setpoint temperature for freeze protection"
      annotation (Placement(transformation(extent={{-70,-76},{-50,-56}})));
    CCC_test.obsolete.HeatStage heatStage
      annotation (Placement(transformation(extent={{74,100},{94,120}})));
    Cycle_Timer cycle_Timer
      annotation (Placement(transformation(extent={{0,-24},{18,-6}})));
    Modelica.Blocks.Logical.Switch swiTim "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{44,8},{64,28}})));
    Modelica.Blocks.Logical.OnOffController onOffConHea(bandwidth=1)
      "Enable heating"
      annotation (Placement(transformation(extent={{-84,86},{-64,106}})));
    Modelica.Blocks.Logical.LessEqual LessEqual
      annotation (Placement(transformation(extent={{-28,-24},{-10,-6}})));
    Modelica.Blocks.Sources.Constant thresHea(k=0.05) "Off signal"
      annotation (Placement(transformation(extent={{-70,-32},{-50,-12}})));
    Modelica.Blocks.Logical.Switch UppLimSwi "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{40,174},{60,194}})));
    Modelica.Blocks.Logical.Not NotLim
      annotation (Placement(transformation(extent={{10,174},{22,186}})));
  equation
    connect(conHea.y, swiHea.u1) annotation (Line(points={{-37,140},{-24,140},{-24,
            104},{2,104}},  color={0,0,127}));
    connect(offHea.y, swiHea.u3) annotation (Line(points={{-29,44},{-14,44},{-14,88},
            {2,88}},  color={0,0,127}));
    connect(TSup, onOffConSupHeatSetPoi.u) annotation (Line(points={{-120,-40},{-78,
            -40},{-78,-88},{-32,-88}},        color={0,0,127}));
    connect(UpperLimSup.y, onOffConSupHeatSetPoi.reference) annotation (Line(
          points={{-49,-66},{-40,-66},{-40,-76},{-32,-76}}, color={0,0,127}));
    connect(TSetRooHea, conHea.u_s) annotation (Line(points={{-120,140},{-60,140}},
                                       color={0,0,127}));
    connect(TRoo, conHea.u_m) annotation (Line(points={{-120,20},{-70,20},{-70,72},
            {-48,72},{-48,128}},
                             color={0,0,127}));
    connect(TSetRooHea, onOffConHea.reference) annotation (Line(points={{-120,140},
            {-94,140},{-94,102},{-86,102}}, color={0,0,127}));
    connect(TRoo, onOffConHea.u) annotation (Line(points={{-120,20},{-92,20},{-92,
            90},{-86,90}}, color={0,0,127}));
    connect(onOffConHea.y, conHea.trigger) annotation (Line(points={{-63,96},{-56,
            96},{-56,128}},           color={255,0,255}));
    connect(onOffConHea.y, swiHea.u2) annotation (Line(points={{-63,96},{2,96}},
                             color={255,0,255}));
    connect(thresHea.y, LessEqual.u2) annotation (Line(points={{-49,-22},{-42,-22},
            {-42,-22.2},{-29.8,-22.2}}, color={0,0,127}));
    connect(offHea.y, UppLimSwi.u1) annotation (Line(points={{-29,44},{-14,44},{-14,
            192},{38,192}}, color={0,0,127}));
    connect(swiHea.y, UppLimSwi.u3) annotation (Line(points={{25,96},{28,96},{28,176},
            {38,176}}, color={0,0,127}));
    connect(UppLimSwi.y, LessEqual.u1) annotation (Line(points={{61,184},{66,184},
            {66,134},{34,134},{34,64},{4,64},{4,12},{-40,12},{-40,-15},{-29.8,-15}},
          color={0,0,127}));
    connect(cycle_Timer.u_Sta, LessEqual.y)
      annotation (Line(points={{-1.8,-15},{-9.1,-15}},color={255,0,255}));
    connect(swiTim.y, heatStage.uHea) annotation (Line(points={{65,18},{68,18},
            {68,110},{72,110}},
                            color={0,0,127}));
    connect(heatStage.y_Sta, heaSta) annotation (Line(points={{96,110},{118,110}},
                                 color={0,0,127}));
    connect(UppLimSwi.u2, NotLim.y) annotation (Line(points={{38,184},{26,184},
            {26,180},{22.6,180}}, color={255,0,255}));
    connect(onOffConSupHeatSetPoi.y, NotLim.u) annotation (Line(points={{-9,-82},
            {-6,-82},{-6,180},{8.8,180}}, color={255,0,255}));
    connect(cycle_Timer.y_Sta, swiTim.u2) annotation (Line(points={{19.26,-15},
            {19.26,-16},{30,-16},{30,18},{42,18}}, color={255,0,255}));
    connect(offHea.y, swiTim.u3) annotation (Line(points={{-29,44},{12,44},{12,
            10},{42,10}}, color={0,0,127}));
    connect(UppLimSwi.y, swiTim.u1) annotation (Line(points={{61,184},{66,184},
            {66,134},{34,134},{34,26},{42,26}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},
              {100,220}}),       graphics={
                                  Rectangle(
          extent={{-100,-220},{100,220}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-220},{100,220}})),
      experiment(
        StopTime=2200,
        Interval=1,
        Tolerance=1e-06));
  end RTU_control_FMU;

  model RTU_control_FMU_Delay "Implements common control for RTU system"

    parameter Real k_hea=k_hea "Proportional gain of heating controller";
    parameter Modelica.Units.SI.Time Ti_hea=Ti_hea
      "Integral time constant of heating controller";
    parameter Modelica.Units.SI.ThermodynamicTemperature maxSAT=maxSAT
      "max supply air temperature";
    parameter Real kSta1 = kSta1 "PI center line to activate stage 1";
    parameter Real kSta2 = kSta2 "PI center line to activate stage 2";
    parameter Real banSta1 = banSta1 "PI band to activate stage 1";
    parameter Real onOffConHeaBan = onOffConHeaBan "bandwidth for on off heating controller";

      parameter Real banSta2 = banSta2 "PI band to activate stage 2";

    Modelica.Blocks.Interfaces.RealInput TSetRooHea(final unit="K", displayUnit=
          "degC")
      "Zone heating setpoint temperature" annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,180})));
    Modelica.Blocks.Interfaces.RealInput TRoo(final unit="K", displayUnit="degC")
      "Zone temperature measurement"
    annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-120,60})));
    Modelica.Blocks.Interfaces.RealOutput heaSta(final unit="1")
      "Control signal for heating"
      annotation (Placement(transformation(extent={{100,40},{136,76}}),
          iconTransformation(extent={{100,40},{136,76}})));
    Buildings.Controls.Continuous.LimPID conHea(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      initType=Modelica.Blocks.Types.Init.InitialOutput,
      y_start=0,
      reset=Buildings.Types.Reset.Parameter) "Heating feedback controller"
      annotation (Placement(transformation(extent={{-58,170},{-38,190}})));
    Modelica.Blocks.Logical.Switch swiHea "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{4,120},{24,140}})));
    Modelica.Blocks.Sources.Constant offHea(k=0) "Off signal"
      annotation (Placement(transformation(extent={{-48,40},{-28,60}})));

    Modelica.Blocks.Interfaces.RealInput TSup(final unit="K", displayUnit="degC")
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Logical.OnOffController onOffConSupHeatSetPoi(bandwidth=0.5)
                "Enable freeze protection"
      annotation (Placement(transformation(extent={{-30,-4},{-10,16}})));
    Modelica.Blocks.Sources.Constant UpperLimSup(k=maxSAT)
      "Setpoint temperature for freeze protection"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    CCC_test.obsolete.HeatStage heatStage(
      kSta1=kSta1,
      kSta2=kSta2,
      banSta1=banSta1,
      banSta2=banSta2) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={-24,162})));
    Modelica.Blocks.Logical.Switch swiTim "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{44,48},{64,68}})));
    hil_flexlab_model.BaseClasses.Controls.BaseClasses.OnOffController onOffConHea(bandwidth=
         onOffConHeaBan)
      "Enable heating"
      annotation (Placement(transformation(extent={{-84,126},{-64,146}})));
    Modelica.Blocks.Logical.Switch UppLimSwi "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{40,200},{60,220}})));
    Modelica.Blocks.Logical.Not NotLim
      annotation (Placement(transformation(extent={{8,200},{20,212}})));
    Modelica.Blocks.MathBoolean.OnDelay
                                  onDelay(delayTime=120)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={14,82})));
    Modelica.Blocks.Math.RealToBoolean realToBoolean
      annotation (Placement(transformation(extent={{76,200},{96,220}})));
    Modelica.Blocks.Interfaces.BooleanOutput heaCal
      "Control signal for heating" annotation (Placement(transformation(extent={{100,88},
              {136,124}}),           iconTransformation(extent={{100,88},{136,
              124}})));
    Modelica.Blocks.Interfaces.RealOutput pre_swi1_Stage_y
      "Control signal for heating" annotation (Placement(transformation(extent={{100,146},
              {136,182}}),    iconTransformation(extent={{100,146},{136,182}})));
    Modelica.Blocks.Interfaces.RealOutput post_swi1_Stage_y
      "Control signal for heating" annotation (Placement(transformation(extent={{100,112},
              {136,148}}),   iconTransformation(extent={{100,112},{136,148}})));
    Modelica.Blocks.Interfaces.RealOutput onOff_diff_y
      "Control signal for heating" annotation (Placement(transformation(extent={{100,10},
              {136,46}}),            iconTransformation(extent={{100,10},{136,
              46}})));
    Modelica.Blocks.Interfaces.RealOutput sigPI(final unit="1")
      "PI signal for heating" annotation (Placement(transformation(extent={{100,174},
              {136,210}}), iconTransformation(extent={{100,174},{136,210}})));
  equation
    connect(offHea.y, swiHea.u3) annotation (Line(points={{-27,50},{-14,50},{
            -14,122},{2,122}},
                      color={0,0,127}));
    connect(TSup, onOffConSupHeatSetPoi.u) annotation (Line(points={{-120,0},{
            -32,0}},                          color={0,0,127}));
    connect(UpperLimSup.y, onOffConSupHeatSetPoi.reference) annotation (Line(
          points={{-59,20},{-52,20},{-52,12},{-32,12}},     color={0,0,127}));
    connect(TSetRooHea, conHea.u_s) annotation (Line(points={{-120,180},{-60,
            180}},                     color={0,0,127}));
    connect(TRoo, conHea.u_m) annotation (Line(points={{-120,60},{-70,60},{-70,110},
            {-48,110},{-48,168}},
                             color={0,0,127}));
    connect(TSetRooHea, onOffConHea.reference) annotation (Line(points={{-120,
            180},{-94,180},{-94,142},{-86,142}},
                                            color={0,0,127}));
    connect(TRoo, onOffConHea.u) annotation (Line(points={{-120,60},{-92,60},{
            -92,130},{-86,130}},
                           color={0,0,127}));
    connect(onOffConHea.y, swiHea.u2) annotation (Line(points={{-63,136},{-32,
            136},{-32,130},{2,130}},
                             color={255,0,255}));
    connect(offHea.y, UppLimSwi.u1) annotation (Line(points={{-27,50},{-14,50},
            {-14,218},{38,218}},
                            color={0,0,127}));
    connect(swiHea.y, UppLimSwi.u3) annotation (Line(points={{25,130},{28,130},
            {28,202},{38,202}},
                       color={0,0,127}));
    connect(UppLimSwi.u2, NotLim.y) annotation (Line(points={{38,210},{26,210},
            {26,206},{20.6,206}}, color={255,0,255}));
    connect(onOffConSupHeatSetPoi.y, NotLim.u) annotation (Line(points={{-9,6},
            {-6,6},{-6,206},{6.8,206}}, color={255,0,255}));
    connect(offHea.y, swiTim.u3)
      annotation (Line(points={{-27,50},{42,50}}, color={0,0,127}));
    connect(UppLimSwi.y, swiTim.u1) annotation (Line(points={{61,210},{66,210},
            {66,180},{38,180},{38,66},{42,66}}, color={0,0,127}));
    connect(onDelay.y, swiTim.u2)
      annotation (Line(points={{14,70},{14,58},{42,58}}, color={255,0,255}));
    connect(UppLimSwi.y, realToBoolean.u)
      annotation (Line(points={{61,210},{74,210}}, color={0,0,127}));
    connect(realToBoolean.y, onDelay.u) annotation (Line(points={{97,210},{98,
            210},{98,174},{66,174},{66,114},{14,114},{14,96}},  color={255,0,
            255}));
    connect(conHea.y, heatStage.uHea) annotation (Line(points={{-37,180},{-24,
            180},{-24,171.6}},
                          color={0,0,127}));
    connect(heatStage.y_Sta, swiHea.u1)
      annotation (Line(points={{-24,152.4},{-24,138},{2,138}}, color={0,0,127}));
    connect(swiTim.y, heaSta) annotation (Line(points={{65,58},{118,58}},
                   color={0,0,127}));
    connect(heaSta, heaSta)
      annotation (Line(points={{118,58},{118,58}},   color={0,0,127}));
    connect(heaCal, onOffConHea.y) annotation (Line(points={{118,106},{-32,106},
            {-32,136},{-63,136}},
                             color={255,0,255}));
    connect(post_swi1_Stage_y, swiHea.y) annotation (Line(points={{118,130},{72,
            130},{72,130},{25,130}},
                               color={0,0,127}));
    connect(onOffConHea.diff, onOff_diff_y) annotation (Line(points={{-63,131.2},
            {-56,131.2},{-56,28},{118,28}},     color={0,0,127}));
    connect(conHea.y, sigPI) annotation (Line(points={{-37,180},{12,180},{12,
            192},{118,192}},              color={0,0,127}));
    connect(pre_swi1_Stage_y, heatStage.y_Sta) annotation (Line(points={{118,
            164},{48,164},{48,148},{-24,148},{-24,152.4}}, color={0,0,127}));
    connect(onOffConHea.y, conHea.trigger) annotation (Line(points={{-63,136},{
            -56,136},{-56,168}}, color={255,0,255}));
    connect(sigPI, sigPI)
      annotation (Line(points={{118,192},{118,192}}, color={0,0,127}));
      annotation (Line(points={{118,58},{118,58}},   color={0,0,127}),
                Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,0},
              {100,220}}),       graphics={
                                  Rectangle(
          extent={{-100,0},{100,220}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,0},{100,220}})),
      experiment(
        StopTime=2200,
        Interval=1,
        Tolerance=1e-06));
  end RTU_control_FMU_Delay;

  model RTU_control_FMU_Delay_VS "Implements common control for RTU system"

    parameter Real k_hea=k_hea "Proportional gain of heating controller";
    parameter Modelica.Units.SI.Time Ti_hea=Ti_hea
      "Integral time constant of heating controller";
    parameter Modelica.Units.SI.ThermodynamicTemperature maxSAT=maxSAT
      "max supply air temperature";
    parameter Real kSta1 = kSta1 "PI center line to activate stage 1";
    parameter Real kSta2 = kSta2 "PI center line to activate stage 2";
    parameter Real banSta1 = banSta1 "PI band to activate stage 1";
    parameter Real onOffConHeaBan = onOffConHeaBan "bandwidth for on off heating controller";

      parameter Real banSta2 = banSta2 "PI band to activate stage 2";

    Modelica.Blocks.Interfaces.RealInput TSetRooHea(final unit="K", displayUnit=
          "degC")
      "Zone heating setpoint temperature" annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,180})));
    Modelica.Blocks.Interfaces.RealInput TRoo(final unit="K", displayUnit="degC")
      "Zone temperature measurement"
    annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-120,60})));
    Modelica.Blocks.Interfaces.RealOutput heaSta(final unit="1")
      "Control signal for heating"
      annotation (Placement(transformation(extent={{100,40},{136,76}}),
          iconTransformation(extent={{100,40},{136,76}})));
    Buildings.Controls.Continuous.LimPID conHea(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      initType=Modelica.Blocks.Types.Init.InitialOutput,
      y_start=0,
      reset=Buildings.Types.Reset.Parameter) "Heating feedback controller"
      annotation (Placement(transformation(extent={{-58,170},{-38,190}})));
    Modelica.Blocks.Logical.Switch swiHea "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{4,120},{24,140}})));
    Modelica.Blocks.Sources.Constant offHea(k=0) "Off signal"
      annotation (Placement(transformation(extent={{-48,40},{-28,60}})));

    Modelica.Blocks.Interfaces.RealInput TSup(final unit="K", displayUnit="degC")
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Logical.OnOffController onOffConSupHeatSetPoi(bandwidth=0.5)
                "Enable freeze protection"
      annotation (Placement(transformation(extent={{-30,-4},{-10,16}})));
    Modelica.Blocks.Sources.Constant UpperLimSup(k=maxSAT)
      "Setpoint temperature for freeze protection"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    hil_flexlab_model.BaseClasses.Controls.BaseClasses.OnOffController onOffConHea(bandwidth=
         onOffConHeaBan)
      "Enable heating"
      annotation (Placement(transformation(extent={{-84,126},{-64,146}})));
    Modelica.Blocks.Logical.Switch UppLimSwi "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{40,200},{60,220}})));
    Modelica.Blocks.Logical.Not NotLim
      annotation (Placement(transformation(extent={{8,200},{20,212}})));
    Modelica.Blocks.Interfaces.BooleanOutput heaCal
      "Control signal for heating" annotation (Placement(transformation(extent={{100,88},
              {136,124}}),           iconTransformation(extent={{100,88},{136,
              124}})));
    Modelica.Blocks.Interfaces.RealOutput pre_swi1_Stage_y
      "Control signal for heating" annotation (Placement(transformation(extent={{100,146},
              {136,182}}),    iconTransformation(extent={{100,146},{136,182}})));
    Modelica.Blocks.Interfaces.RealOutput post_swi1_Stage_y
      "Control signal for heating" annotation (Placement(transformation(extent={{100,112},
              {136,148}}),   iconTransformation(extent={{100,112},{136,148}})));
    Modelica.Blocks.Interfaces.RealOutput onOff_diff_y
      "Control signal for heating" annotation (Placement(transformation(extent={{100,10},
              {136,46}}),            iconTransformation(extent={{100,10},{136,
              46}})));
    Modelica.Blocks.Interfaces.RealOutput sigPI(final unit="1")
      "PI signal for heating" annotation (Placement(transformation(extent={{100,174},
              {136,210}}), iconTransformation(extent={{100,174},{136,210}})));
  equation
    connect(offHea.y, swiHea.u3) annotation (Line(points={{-27,50},{-14,50},{
            -14,122},{2,122}},
                      color={0,0,127}));
    connect(TSup, onOffConSupHeatSetPoi.u) annotation (Line(points={{-120,0},{
            -32,0}},                          color={0,0,127}));
    connect(UpperLimSup.y, onOffConSupHeatSetPoi.reference) annotation (Line(
          points={{-59,20},{-52,20},{-52,12},{-32,12}},     color={0,0,127}));
    connect(TSetRooHea, conHea.u_s) annotation (Line(points={{-120,180},{-60,
            180}},                     color={0,0,127}));
    connect(TRoo, conHea.u_m) annotation (Line(points={{-120,60},{-70,60},{-70,110},
            {-48,110},{-48,168}},
                             color={0,0,127}));
    connect(TSetRooHea, onOffConHea.reference) annotation (Line(points={{-120,
            180},{-94,180},{-94,142},{-86,142}},
                                            color={0,0,127}));
    connect(TRoo, onOffConHea.u) annotation (Line(points={{-120,60},{-92,60},{
            -92,130},{-86,130}},
                           color={0,0,127}));
    connect(onOffConHea.y, swiHea.u2) annotation (Line(points={{-63,136},{-32,
            136},{-32,130},{2,130}},
                             color={255,0,255}));
    connect(offHea.y, UppLimSwi.u1) annotation (Line(points={{-27,50},{-14,50},
            {-14,218},{38,218}},
                            color={0,0,127}));
    connect(swiHea.y, UppLimSwi.u3) annotation (Line(points={{25,130},{28,130},
            {28,202},{38,202}},
                       color={0,0,127}));
    connect(UppLimSwi.u2, NotLim.y) annotation (Line(points={{38,210},{26,210},
            {26,206},{20.6,206}}, color={255,0,255}));
    connect(onOffConSupHeatSetPoi.y, NotLim.u) annotation (Line(points={{-9,6},
            {-6,6},{-6,206},{6.8,206}}, color={255,0,255}));
    connect(heaSta, heaSta)
      annotation (Line(points={{118,58},{118,58}},   color={0,0,127}));
    connect(heaCal, onOffConHea.y) annotation (Line(points={{118,106},{-32,106},
            {-32,136},{-63,136}},
                             color={255,0,255}));
    connect(post_swi1_Stage_y, swiHea.y) annotation (Line(points={{118,130},{72,
            130},{72,130},{25,130}},
                               color={0,0,127}));
    connect(onOffConHea.diff, onOff_diff_y) annotation (Line(points={{-63,131.2},
            {-56,131.2},{-56,28},{118,28}},     color={0,0,127}));
    connect(conHea.y, sigPI) annotation (Line(points={{-37,180},{12,180},{12,
            192},{118,192}},              color={0,0,127}));
    connect(onOffConHea.y, conHea.trigger) annotation (Line(points={{-63,136},{
            -56,136},{-56,168}}, color={255,0,255}));
    connect(sigPI, sigPI)
      annotation (Line(points={{118,192},{118,192}}, color={0,0,127}));
    connect(swiHea.u1, conHea.y) annotation (Line(points={{2,138},{-18,138},{
            -18,180},{-37,180}}, color={0,0,127}));
    connect(conHea.y, pre_swi1_Stage_y) annotation (Line(points={{-37,180},{32,
            180},{32,164},{118,164}}, color={0,0,127}));
    connect(UppLimSwi.y, heaSta) annotation (Line(points={{61,210},{82,210},{82,
            58},{118,58}}, color={0,0,127}));
      annotation (Line(points={{118,58},{118,58}},   color={0,0,127}),
                Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,0},
              {100,220}}),       graphics={
                                  Rectangle(
          extent={{-100,0},{100,220}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,0},{100,220}})),
      experiment(
        StopTime=2200,
        Interval=1,
        Tolerance=1e-06));
  end RTU_control_FMU_Delay_VS;

  model RTU_control_FMU_Delay_Cool "Implements common control for RTU system"

    parameter Real k_hea=k_hea "Proportional gain of heating controller";
    parameter Modelica.Units.SI.Time Ti_hea=Ti_hea
      "Integral time constant of heating controller";
    parameter Modelica.Units.SI.ThermodynamicTemperature maxSAT=maxSAT
      "max supply air temperature";
    parameter Real kSta1 = kSta1 "PI center line to activate stage 1";
    parameter Real kSta2 = kSta2 "PI center line to activate stage 2";
    parameter Real banSta1 = banSta1 "PI band to activate stage 1";
    parameter Real onOffConHeaBan = onOffConHeaBan "bandwidth for on off heating controller";

      parameter Real banSta2 = banSta2 "PI band to activate stage 2";

    Modelica.Blocks.Interfaces.RealInput TSetRooHea(final unit="K", displayUnit=
          "degC")
      "Zone heating setpoint temperature" annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-120,180})));
    Modelica.Blocks.Interfaces.RealInput TRoo(final unit="K", displayUnit="degC")
      "Zone temperature measurement"
    annotation (Placement(
          transformation(
          extent={{-20,-20},{20,20}},
          origin={-120,60})));
    Modelica.Blocks.Interfaces.RealOutput heaSta(final unit="1")
      "Control signal for heating"
      annotation (Placement(transformation(extent={{100,42},{136,78}}),
          iconTransformation(extent={{100,42},{136,78}})));
    Buildings.Controls.Continuous.LimPID conHea(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_hea,
      final yMax=1,
      final yMin=0,
      final k=k_hea,
      initType=Modelica.Blocks.Types.Init.InitialOutput,
      y_start=0,
      reset=Buildings.Types.Reset.Parameter) "Heating feedback controller"
      annotation (Placement(transformation(extent={{-58,170},{-38,190}})));
    Modelica.Blocks.Logical.Switch swiHea "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{4,120},{24,140}})));
    Modelica.Blocks.Sources.Constant offHea(k=0) "Off signal"
      annotation (Placement(transformation(extent={{-48,40},{-28,60}})));

    Modelica.Blocks.Interfaces.RealInput TSup(final unit="K", displayUnit="degC")
      "Supply air temperature"
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Logical.OnOffController onOffConSupHeatSetPoi(bandwidth=0.5)
                "Enable freeze protection"
      annotation (Placement(transformation(extent={{-30,-4},{-10,16}})));
    Modelica.Blocks.Sources.Constant UpperLimSup(k=maxSAT)
      "Setpoint temperature for freeze protection"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    CCC_test.obsolete.HeatStage heatStage(
      kSta1=kSta1,
      kSta2=kSta2,
      banSta1=banSta1,
      banSta2=banSta2) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={-24,162})));
    Modelica.Blocks.Logical.Switch swiTim "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{44,48},{64,68}})));
    hil_flexlab_model.BaseClasses.Controls.BaseClasses.OnOffController onOffConHea(bandwidth=
         onOffConHeaBan)
      "Enable heating"
      annotation (Placement(transformation(extent={{-84,126},{-64,146}})));
    Modelica.Blocks.Logical.Switch UppLimSwi "Switch for turning heating on/off"
      annotation (Placement(transformation(extent={{40,200},{60,220}})));
    Modelica.Blocks.Logical.Not NotLim
      annotation (Placement(transformation(extent={{8,200},{20,212}})));
    Modelica.Blocks.MathBoolean.OnDelay
                                  onDelay(delayTime=120)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={14,82})));
    Modelica.Blocks.Math.RealToBoolean realToBoolean
      annotation (Placement(transformation(extent={{76,200},{96,220}})));
    Modelica.Blocks.Interfaces.BooleanOutput heaCal
      "Control signal for heating" annotation (Placement(transformation(extent={{100,76},
              {136,112}}),           iconTransformation(extent={{100,76},{136,
              112}})));
    Modelica.Blocks.Interfaces.RealOutput pre_swi1_Stage_y
      "Control signal for heating" annotation (Placement(transformation(extent={{100,146},
              {136,182}}),    iconTransformation(extent={{100,146},{136,182}})));
    Modelica.Blocks.Interfaces.RealOutput post_swi1_Stage_y
      "Control signal for heating" annotation (Placement(transformation(extent={{100,112},
              {136,148}}),   iconTransformation(extent={{100,112},{136,148}})));
    Modelica.Blocks.Interfaces.RealOutput onOff_diff_y
      "Control signal for heating" annotation (Placement(transformation(extent={{100,4},
              {136,40}}),            iconTransformation(extent={{100,4},{136,40}})));
    Modelica.Blocks.Interfaces.RealOutput sigPI(final unit="1")
      "PI signal for heating" annotation (Placement(transformation(extent={{100,174},
              {136,210}}), iconTransformation(extent={{100,174},{136,210}})));
    Modelica.Blocks.Interfaces.RealInput TSetRooCoo(final unit="K", displayUnit=
         "degC")  "Zone cooling setpoint temperature"
                                          annotation (Placement(transformation(
          extent={{20,20},{-20,-20}},
          rotation=180,
          origin={-112,306})));
    Modelica.Blocks.Logical.OnOffController onOffConHea1(bandwidth=DeadBand_hea)
      "Enable heating"
      annotation (Placement(transformation(extent={{-58,238},{-38,258}})));
    Buildings.Controls.Continuous.LimPID conCoo(
      controllerType=Modelica.Blocks.Types.SimpleController.PI,
      Ti=Ti_coo,
      final yMax=1,
      final yMin=0,
      final k=k_coo,
      reset=Buildings.Types.Reset.Parameter,
      reverseAction=true) "Cooling feedback controller"
      annotation (Placement(transformation(extent={{-4,316},{16,336}})));
    Modelica.Blocks.Sources.Constant offCoo(k=0) "Off signal"
      annotation (Placement(transformation(extent={{42,256},{62,276}})));
    Modelica.Blocks.Interfaces.RealOutput cooSta(final unit="1")
      "Control signal for cooling"
      annotation (Placement(transformation(extent={{102,270},{136,304}})));
    Modelica.Blocks.Logical.Switch swiCoo "Switch for turning cooling on/off"
      annotation (Placement(transformation(extent={{74,276},{94,296}})));
    CCC_test.obsolete.HeatStage heatStage1(
      kSta1=kSta1,
      kSta2=kSta2,
      banSta1=banSta1,
      banSta2=banSta2) annotation (Placement(transformation(
          extent={{-8,-8},{8,8}},
          rotation=-90,
          origin={42,322})));
  equation
    connect(offHea.y, swiHea.u3) annotation (Line(points={{-27,50},{-14,50},{
            -14,122},{2,122}},
                      color={0,0,127}));
    connect(TSup, onOffConSupHeatSetPoi.u) annotation (Line(points={{-120,0},{
            -32,0}},                          color={0,0,127}));
    connect(UpperLimSup.y, onOffConSupHeatSetPoi.reference) annotation (Line(
          points={{-59,20},{-52,20},{-52,12},{-32,12}},     color={0,0,127}));
    connect(TSetRooHea, conHea.u_s) annotation (Line(points={{-120,180},{-60,
            180}},                     color={0,0,127}));
    connect(TRoo, conHea.u_m) annotation (Line(points={{-120,60},{-70,60},{-70,110},
            {-48,110},{-48,168}},
                             color={0,0,127}));
    connect(TSetRooHea, onOffConHea.reference) annotation (Line(points={{-120,
            180},{-94,180},{-94,142},{-86,142}},
                                            color={0,0,127}));
    connect(TRoo, onOffConHea.u) annotation (Line(points={{-120,60},{-90,60},{
            -90,130},{-86,130}},
                           color={0,0,127}));
    connect(onOffConHea.y, swiHea.u2) annotation (Line(points={{-63,136},{-32,
            136},{-32,130},{2,130}},
                             color={255,0,255}));
    connect(offHea.y, UppLimSwi.u1) annotation (Line(points={{-27,50},{-14,50},
            {-14,218},{38,218}},
                            color={0,0,127}));
    connect(swiHea.y, UppLimSwi.u3) annotation (Line(points={{25,130},{28,130},
            {28,202},{38,202}},
                       color={0,0,127}));
    connect(UppLimSwi.u2, NotLim.y) annotation (Line(points={{38,210},{26,210},
            {26,206},{20.6,206}}, color={255,0,255}));
    connect(onOffConSupHeatSetPoi.y, NotLim.u) annotation (Line(points={{-9,6},
            {-6,6},{-6,206},{6.8,206}}, color={255,0,255}));
    connect(offHea.y, swiTim.u3)
      annotation (Line(points={{-27,50},{42,50}}, color={0,0,127}));
    connect(UppLimSwi.y, swiTim.u1) annotation (Line(points={{61,210},{66,210},
            {66,180},{38,180},{38,66},{42,66}}, color={0,0,127}));
    connect(onDelay.y, swiTim.u2)
      annotation (Line(points={{14,70},{14,58},{42,58}}, color={255,0,255}));
    connect(UppLimSwi.y, realToBoolean.u)
      annotation (Line(points={{61,210},{74,210}}, color={0,0,127}));
    connect(realToBoolean.y, onDelay.u) annotation (Line(points={{97,210},{98,
            210},{98,174},{66,174},{66,114},{14,114},{14,96}},  color={255,0,
            255}));
    connect(conHea.y, heatStage.uHea) annotation (Line(points={{-37,180},{-24,
            180},{-24,171.6}},
                          color={0,0,127}));
    connect(heatStage.y_Sta, swiHea.u1)
      annotation (Line(points={{-24,152.4},{-24,138},{2,138}}, color={0,0,127}));
    connect(swiTim.y, heaSta) annotation (Line(points={{65,58},{92,58},{92,60},
            {118,60}},
                   color={0,0,127}));
    connect(heaSta, heaSta)
      annotation (Line(points={{118,60},{118,60}},   color={0,0,127}));
    connect(heaCal, onOffConHea.y) annotation (Line(points={{118,94},{-32,94},{
            -32,136},{-63,136}},
                             color={255,0,255}));
    connect(post_swi1_Stage_y, swiHea.y) annotation (Line(points={{118,130},{72,
            130},{72,130},{25,130}},
                               color={0,0,127}));
    connect(onOffConHea.diff, onOff_diff_y) annotation (Line(points={{-63,131.2},
            {-56,131.2},{-56,22},{118,22}},     color={0,0,127}));
    connect(conHea.y, sigPI) annotation (Line(points={{-37,180},{12,180},{12,
            192},{118,192}},              color={0,0,127}));
    connect(pre_swi1_Stage_y, heatStage.y_Sta) annotation (Line(points={{118,
            164},{48,164},{48,148},{-24,148},{-24,152.4}}, color={0,0,127}));
    connect(onOffConHea.y, conHea.trigger) annotation (Line(points={{-63,136},{
            -56,136},{-56,168}}, color={255,0,255}));
    connect(sigPI, sigPI)
      annotation (Line(points={{118,192},{118,192}}, color={0,0,127}));
    connect(TRoo, onOffConHea1.u) annotation (Line(points={{-120,60},{-120,153},
            {-60,153},{-60,242}}, color={0,0,127}));
    connect(TSetRooCoo, onOffConHea1.reference) annotation (Line(points={{-112,
            306},{-112,279},{-60,279},{-60,254}}, color={0,0,127}));
    connect(conCoo.trigger, onOffConHea1.y) annotation (Line(points={{-2,314},{
            -14,314},{-14,248},{-37,248}}, color={255,0,255}));
    connect(TRoo, conCoo.u_m) annotation (Line(points={{-120,60},{-120,167},{6,
            167},{6,314}}, color={0,0,127}));
    connect(TSetRooCoo, conCoo.u_s) annotation (Line(points={{-112,306},{-55,
            306},{-55,326},{-6,326}}, color={0,0,127}));
    connect(offCoo.y, swiCoo.u3) annotation (Line(points={{63,266},{70,266},{70,
            278},{72,278}}, color={0,0,127}));
    connect(swiCoo.y, cooSta) annotation (Line(points={{95,286},{106,286},{106,
            287},{119,287}}, color={0,0,127}));
    connect(conCoo.y, heatStage1.uHea) annotation (Line(points={{17,326},{30,
            326},{30,331.6},{42,331.6}}, color={0,0,127}));
    connect(heatStage1.y_Sta, swiCoo.u1) annotation (Line(points={{42,312.4},{
            58,312.4},{58,294},{72,294}}, color={0,0,127}));
      annotation (Line(points={{118,58},{118,58}},   color={0,0,127}),
                Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,0},
              {100,440}}),       graphics={
                                  Rectangle(
          extent={{-100,0},{102,438}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                        Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-100,0},{100,440}})),
      experiment(
        StopTime=2200,
        Interval=1,
        Tolerance=1e-06));
  end RTU_control_FMU_Delay_Cool;

  block Controller
    "Multizone AHU controller that composes subsequences for controlling fan speed, dampers, and supply air temperature"

    parameter Real samplePeriod(
      final unit="s",
      final quantity="Time")=120
      "Sample period of component, set to the same value to the trim and respond sequence";

    parameter Boolean have_perZonRehBox=true
      "Check if there is any VAV-reheat boxes on perimeter zones"
      annotation (Dialog(group="System and building parameters"));

    parameter Boolean have_duaDucBox=false
      "Check if the AHU serves dual duct boxes"
      annotation (Dialog(group="System and building parameters"));

    parameter Boolean have_airFloMeaSta=false
      "Check if the AHU has AFMS (Airflow measurement station)"
      annotation (Dialog(group="System and building parameters"));

    // ----------- Parameters for economizer control -----------
    parameter Boolean use_enthalpy=false
      "Set to true if enthalpy measurement is used in addition to temperature measurement"
      annotation (Dialog(tab="Economizer"));

    parameter Real delta(
      final unit="s",
      final quantity="Time")=5
      "Time horizon over which the outdoor air flow measurment is averaged"
      annotation (Dialog(tab="Economizer"));

    parameter Real delTOutHis(
      final unit="K",
      final displayUnit="K",
      final quantity="TemperatureDifference")=1
      "Delta between the temperature hysteresis high and low limit"
      annotation (Dialog(tab="Economizer"));

    parameter Real delEntHis(
      final unit="J/kg",
      final quantity="SpecificEnergy")=1000
      "Delta between the enthalpy hysteresis high and low limits"
      annotation (Dialog(tab="Economizer", enable=use_enthalpy));

    parameter Real retDamPhyPosMax(
      final min=0,
      final max=1,
      final unit="1") = 1
      "Physically fixed maximum position of the return air damper"
      annotation (Dialog(tab="Economizer", group="Damper limits"));

    parameter Real retDamPhyPosMin(
      final min=0,
      final max=1,
      final unit="1") = 0
      "Physically fixed minimum position of the return air damper"
      annotation (Dialog(tab="Economizer", group="Damper limits"));

    parameter Real outDamPhyPosMax(
      final min=0,
      final max=1,
      final unit="1") = 1
      "Physically fixed maximum position of the outdoor air damper"
      annotation (Dialog(tab="Economizer", group="Damper limits"));

    parameter Real outDamPhyPosMin(
      final min=0,
      final max=1,
      final unit="1") = 0
      "Physically fixed minimum position of the outdoor air damper"
      annotation (Dialog(tab="Economizer", group="Damper limits"));

    parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeMinOut=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      "Type of controller"
      annotation (Dialog(group="Economizer PID controller"));

    parameter Real kMinOut(final unit="1")=0.05
      "Gain of controller for minimum outdoor air intake"
      annotation (Dialog(group="Economizer PID controller"));

    parameter Real TiMinOut(
      final unit="s",
      final quantity="Time")=120
      "Time constant of controller for minimum outdoor air intake"
      annotation (Dialog(group="Economizer PID controller",
        enable=controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
            or controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

    parameter Real TdMinOut(
      final unit="s",
      final quantity="Time")=0.1
      "Time constant of derivative block for minimum outdoor air intake"
      annotation (Dialog(group="Economizer PID controller",
        enable=controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
            or controllerTypeMinOut == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

    parameter Boolean use_TMix=true
      "Set to true if mixed air temperature measurement is enabled"
       annotation(Dialog(group="Economizer freeze protection"));

    parameter Boolean use_G36FrePro=false
      "Set to true to use G36 freeze protection"
      annotation(Dialog(group="Economizer freeze protection"));

    parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFre=
      Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      "Type of controller"
      annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

    parameter Real kFre(final unit="1/K") = 0.05
      "Gain for mixed air temperature tracking for freeze protection, used if use_TMix=true"
       annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

    parameter Real TiFre(
      final unit="s",
      final quantity="Time",
      final max=TiMinOut)=120
      "Time constant of controller for mixed air temperature tracking for freeze protection. Require TiFre <= TiMinOut"
       annotation(Dialog(group="Economizer freeze protection",
         enable=use_TMix
           and (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
             or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

    parameter Real TdFre(
      final unit="s",
      final quantity="Time")=0.1
      "Time constant of derivative block for freeze protection"
      annotation (Dialog(group="Economizer freeze protection",
        enable=use_TMix and
            (controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
            or controllerTypeFre == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

    parameter Real TFreSet(
       final unit="K",
       final displayUnit="degC",
       final quantity="ThermodynamicTemperature")= 279.15
      "Lower limit for mixed air temperature for freeze protection, used if use_TMix=true"
       annotation(Dialog(group="Economizer freeze protection", enable=use_TMix));

    parameter Real retDamFulOpeTim(
      final unit="s",
      final quantity="Time")=180
      "Time period to keep RA damper fully open before releasing it for minimum outdoor airflow control
    at disable to avoid pressure fluctuations"
      annotation (Dialog(tab="Economizer", group="Economizer delays at disable"));

    parameter Real disDel(
      final unit="s",
      final quantity="Time")=15
      "Short time delay before closing the OA damper at disable to avoid pressure fluctuations"
      annotation (Dialog(tab="Economizer", group="Economizer delays at disable"));

    // ----------- parameters for fan speed control  -----------
    parameter Real pIniSet(
      final unit="Pa",
      final displayUnit="Pa",
      final quantity="PressureDifference")=60
      "Initial pressure setpoint for fan speed control"
      annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

    parameter Real pMinSet(
      final unit="Pa",
      final displayUnit="Pa",
      final quantity="PressureDifference")=25
      "Minimum pressure setpoint for fan speed control"
      annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

    parameter Real pMaxSet(
      final unit="Pa",
      final displayUnit="Pa",
      final quantity="PressureDifference")=400
      "Maximum pressure setpoint for fan speed control"
      annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

    parameter Real pDelTim(
      final unit="s",
      final quantity="Time")=600
      "Delay time after which trim and respond is activated"
      annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

    parameter Integer pNumIgnReq=2
      "Number of ignored requests for fan speed control"
      annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

    parameter Real pTriAmo(
      final unit="Pa",
      final displayUnit="Pa",
      final quantity="PressureDifference")=-12.0
      "Trim amount for fan speed control"
      annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

    parameter Real pResAmo(
      final unit="Pa",
      final displayUnit="Pa",
      final quantity="PressureDifference")=15
      "Respond amount (must be opposite in to triAmo) for fan speed control"
      annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

    parameter Real pMaxRes(
      final unit="Pa",
      final displayUnit="Pa",
      final quantity="PressureDifference")=32
      "Maximum response per time interval (same sign as resAmo) for fan speed control"
      annotation (Dialog(tab="Fan speed", group="Trim and respond for reseting duct static pressure setpoint"));

    parameter Buildings.Controls.OBC.CDL.Types.SimpleController
      controllerTypeFanSpe=Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
      annotation (Dialog(group="Fan speed PID controller"));

    parameter Real kFanSpe(final unit="1")=0.1
      "Gain of fan fan speed controller, normalized using pMaxSet"
      annotation (Dialog(group="Fan speed PID controller"));

    parameter Real TiFanSpe(
      final unit="s",
      final quantity="Time")=60
      "Time constant of integrator block for fan speed"
      annotation (Dialog(group="Fan speed PID controller",
        enable=controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
            or controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

    parameter Real TdFanSpe(
      final unit="s",
      final quantity="Time")=0.1
      "Time constant of derivative block for fan speed"
      annotation (Dialog(group="Fan speed PID controller",
        enable=controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
            or controllerTypeFanSpe == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

    parameter Real yFanMax=1 "Maximum allowed fan speed"
      annotation (Dialog(group="Fan speed PID controller"));

    parameter Real yFanMin=0.1 "Lowest allowed fan speed if fan is on"
      annotation (Dialog(group="Fan speed PID controller"));

    // ----------- parameters for minimum outdoor airflow setting  -----------
    parameter Real VPriSysMax_flow(
      final unit="m3/s",
      final quantity="VolumeFlowRate")
      "Maximum expected system primary airflow at design stage"
      annotation (Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

    parameter Real peaSysPop "Peak system population"
      annotation (Dialog(tab="Minimum outdoor airflow rate", group="Nominal conditions"));

    // ----------- parameters for supply air temperature control  -----------
    parameter Real TSupSetDes(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")=285.15
      "Design coil leaving air temperature"
      annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

    parameter Real TSupSetMin(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")=285.15
      "Lowest cooling supply air temperature setpoint when the outdoor air temperature is at the
    higher value of the reset range and above. This should not be lower than the design coil leaving air temperature"
      annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

    parameter Real TSupSetMax(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")=291.15
      "Highest cooling supply air temperature setpoint. It is typically 18 degC (65 degF) in mild and dry climates, 16 degC (60 degF) or lower in humid climates"
      annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

    parameter Real TOutMin(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")=289.15
      "Lower value of the outdoor air temperature reset range. Typically value is 16 degC (60 degF)"
      annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

    parameter Real TOutMax(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")=294.15
      "Higher value of the outdoor air temperature reset range. Typically value is 21 degC (70 degF)"
      annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

    parameter Real TSupWarUpSetBac(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")=308.15
      "Supply temperature in warm up and set back mode"
      annotation (Dialog(tab="Supply air temperature", group="Temperature limits"));

    parameter Real delTimSupTem(
      final unit="s",
      final quantity="Time")=600
      "Delay timer for supply temperature control"
      annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

    parameter Integer numIgnReqSupTem=2
      "Number of ignorable requests for supply temperature control"
      annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

    parameter Real triAmoSupTem(
      final unit="K",
      final displayUnit="K",
      final quantity="TemperatureDifference")=0.1
      "Trim amount for supply temperature control"
      annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

    parameter Real resAmoSupTem(
      final unit="K",
      final displayUnit="K",
      final quantity="TemperatureDifference")=-0.2
      "Response amount for supply temperature control"
      annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

    parameter Real maxResSupTem(
      final unit="K",
      final displayUnit="K",
      final quantity="TemperatureDifference")=-0.6
      "Maximum response per time interval for supply temperature control"
      annotation (Dialog(tab="Supply air temperature", group="Trim and respond for reseting TSup setpoint"));

    parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeTSup=
        Buildings.Controls.OBC.CDL.Types.SimpleController.PI
      "Type of controller for supply air temperature signal"
      annotation (Dialog(group="Supply air temperature"));

    parameter Real kTSup(final unit="1/K")=0.05
      "Gain of controller for supply air temperature signal"
      annotation (Dialog(group="Supply air temperature"));

    parameter Real TiTSup(
      final unit="s",
      final quantity="Time")=600
      "Time constant of integrator block for supply air temperature control signal"
      annotation (Dialog(group="Supply air temperature",
        enable=controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
            or controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

    parameter Real TdTSup(
      final unit="s",
      final quantity="Time")=0.1
      "Time constant of integrator block for supply air temperature control signal"
      annotation (Dialog(group="Supply air temperature",
        enable=controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
            or controllerTypeTSup == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

    parameter Real uHeaMax(min=-0.9)=-0.25
      "Upper limit of controller signal when heating coil is off. Require -1 < uHeaMax < uCooMin < 1."
      annotation (Dialog(group="Supply air temperature"));

    parameter Real uCooMin(max=0.9)=0.25
      "Lower limit of controller signal when cooling coil is off. Require -1 < uHeaMax < uCooMin < 1."
      annotation (Dialog(group="Supply air temperature"));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")
      "Zone air temperature heating setpoint"
      annotation (Placement(transformation(extent={{-240,280},{-200,320}}),
          iconTransformation(extent={{-240,320},{-200,360}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")
      "Zone air temperature cooling setpoint"
      annotation (Placement(transformation(extent={{-240,250},{-200,290}}),
          iconTransformation(extent={{-240,290},{-200,330}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature") "Outdoor air temperature"
      annotation (Placement(transformation(extent={{-240,220},{-200,260}}),
          iconTransformation(extent={{-240,260},{-200,300}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(
      final unit="Pa",
      final displayUnit="Pa")
      "Measured duct static pressure"
      annotation (Placement(transformation(extent={{-240,190},{-200,230}}),
          iconTransformation(extent={{-240,230},{-200,270}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput sumDesZonPop(
      final min=0,
      final unit="1")
      "Sum of the design population of the zones in the group"
      annotation (Placement(transformation(extent={{-240,160},{-200,200}}),
          iconTransformation(extent={{-240,170},{-200,210}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumDesPopBreZon_flow(
      final min=0,
      final unit = "m3/s",
      final quantity = "VolumeFlowRate")
      "Sum of the population component design breathing zone flow rate"
      annotation (Placement(transformation(extent={{-240,130},{-200,170}}),
          iconTransformation(extent={{-240,140},{-200,180}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumDesAreBreZon_flow(
      final min=0,
      final unit = "m3/s",
      final quantity = "VolumeFlowRate")
      "Sum of the area component design breathing zone flow rate"
      annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
          iconTransformation(extent={{-240,110},{-200,150}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput uDesSysVenEff(
      final min=0,
      final unit = "1")
      "Design system ventilation efficiency, equals to the minimum of all zones ventilation efficiency"
      annotation (Placement(transformation(extent={{-240,70},{-200,110}}),
          iconTransformation(extent={{-240,80},{-200,120}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumUncOutAir_flow(
      final min=0,
      final unit = "m3/s",
      final quantity = "VolumeFlowRate")
      "Sum of all zones required uncorrected outdoor airflow rate"
      annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
          iconTransformation(extent={{-240,50},{-200,90}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput VSumSysPriAir_flow(
      final min=0,
      final unit = "m3/s",
      final quantity = "VolumeFlowRate")
      "System primary airflow rate, equals to the sum of the measured discharged flow rate of all terminal units"
      annotation (Placement(transformation(extent={{-240,10},{-200,50}}),
          iconTransformation(extent={{-240,20},{-200,60}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutAirFra_max(
      final min=0,
      final unit = "1")
      "Maximum zone outdoor air fraction, equals to the maximum of primary outdoor air fraction of all zones"
      annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
          iconTransformation(extent={{-240,-10},{-200,30}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")
      "Measured supply air temperature"
      annotation (Placement(transformation(extent={{-240,-50},{-200,-10}}),
          iconTransformation(extent={{-240,-70},{-200,-30}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TOutCut(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")
      "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
      annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
          iconTransformation(extent={{-240,-100},{-200,-60}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput hOut(
      final unit="J/kg",
      final quantity="SpecificEnergy") if use_enthalpy "Outdoor air enthalpy"
      annotation (Placement(transformation(extent={{-240,-110},{-200,-70}}),
          iconTransformation(extent={{-240,-130},{-200,-90}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput hOutCut(
      final unit="J/kg",
      final quantity="SpecificEnergy") if use_enthalpy
      "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
      annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
          iconTransformation(extent={{-240,-160},{-200,-120}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput VOut_flow(
      final min=0,
      final unit = "m3/s",
      final quantity = "VolumeFlowRate")
      "Measured outdoor volumetric airflow rate"
      annotation (Placement(transformation(extent={{-240,-170},{-200,-130}}),
          iconTransformation(extent={{-240,-190},{-200,-150}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealInput TMix(
      final unit="K",
      final displayUnit="degC",
      final quantity = "ThermodynamicTemperature") if use_TMix
      "Measured mixed air temperature, used for freeze protection if use_TMix=true"
      annotation (Placement(transformation(extent={{-240,-200},{-200,-160}}),
          iconTransformation(extent={{-240,-230},{-200,-190}})));

    Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
      "AHU operation mode status signal"
      annotation (Placement(transformation(extent={{-240,-230},{-200,-190}}),
          iconTransformation(extent={{-240,-270},{-200,-230}})));

    Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonTemResReq
      "Zone cooling supply air temperature reset request"
      annotation (Placement(transformation(extent={{-240,-260},{-200,-220}}),
          iconTransformation(extent={{-240,-300},{-200,-260}})));

    Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
      "Zone static pressure reset requests"
      annotation (Placement(transformation(extent={{-240,-290},{-200,-250}}),
          iconTransformation(extent={{-240,-330},{-200,-290}})));

    Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uFreProSta
     if use_G36FrePro
     "Freeze protection status, used if use_G36FrePro=true"
      annotation (Placement(transformation(extent={{-240,-320},{-200,-280}}),
          iconTransformation(extent={{-240,-360},{-200,-320}})));

    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan
      "Supply fan status, true if fan should be on"
      annotation (Placement(transformation(extent={{200,260},{240,300}}),
          iconTransformation(extent={{200,280},{240,320}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
      final min=0,
      final max=1,
      final unit="1") "Supply fan speed"
      annotation (Placement(transformation(extent={{200,190},{240,230}}),
          iconTransformation(extent={{200,220},{240,260}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
      final unit="K",
      final displayUnit="degC",
      final quantity="ThermodynamicTemperature")
      "Setpoint for supply air temperature"
      annotation (Placement(transformation(extent={{200,160},{240,200}}),
          iconTransformation(extent={{200,160},{240,200}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesUncOutAir_flow(
      final min=0,
      final unit = "m3/s",
      final quantity = "VolumeFlowRate")
      "Design uncorrected minimum outdoor airflow rate"
      annotation (Placement(transformation(extent={{200,120},{240,160}}),
        iconTransformation(extent={{200,100},{240,140}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yAveOutAirFraPlu(
      final min=0,
      final unit = "1")
      "Average outdoor air flow fraction plus 1"
      annotation (Placement(transformation(extent={{200,80},{240,120}}),
        iconTransformation(extent={{200,40},{240,80}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput VEffOutAir_flow(
      final min=0,
      final unit = "m3/s",
      final quantity = "VolumeFlowRate")
      "Effective minimum outdoor airflow setpoint"
      annotation (Placement(transformation(extent={{200,40},{240,80}}),
        iconTransformation(extent={{200,-20},{240,20}})));

    Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yReqOutAir
      "True if the AHU supply fan is on and the zone is in occupied mode"
      annotation (Placement(transformation(extent={{200,0},{240,40}}),
          iconTransformation(extent={{200,-80},{240,-40}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
      final min=0,
      final max=1,
      final unit="1")
      "Control signal for heating"
      annotation (Placement(transformation(extent={{200,-50},{240,-10}}),
          iconTransformation(extent={{200,-140},{240,-100}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
      final min=0,
      final max=1,
      final unit="1") "Control signal for cooling"
      annotation (Placement(transformation(extent={{200,-110},{240,-70}}),
          iconTransformation(extent={{200,-200},{240,-160}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetDamPos(
      final min=0,
      final max=1,
      final unit="1") "Return air damper position"
      annotation (Placement(transformation(extent={{200,-170},{240,-130}}),
          iconTransformation(extent={{200,-260},{240,-220}})));

    Buildings.Controls.OBC.CDL.Interfaces.RealOutput yOutDamPos(
      final min=0,
      final max=1,
      final unit="1") "Outdoor air damper position"
      annotation (Placement(transformation(extent={{200,-210},{240,-170}}),
          iconTransformation(extent={{200,-320},{240,-280}})));

    Buildings.Controls.OBC.CDL.Continuous.Average TZonSetPoiAve
      "Average of all zone set points"
      annotation (Placement(transformation(extent={{-160,270},{-140,290}})));

    Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan
      supFan(
      final samplePeriod=samplePeriod,
      final have_perZonRehBox=have_perZonRehBox,
      final have_duaDucBox=have_duaDucBox,
      final have_airFloMeaSta=have_airFloMeaSta,
      final iniSet=pIniSet,
      final minSet=pMinSet,
      final maxSet=pMaxSet,
      final delTim=pDelTim,
      final numIgnReq=pNumIgnReq,
      final triAmo=pTriAmo,
      final resAmo=pResAmo,
      final maxRes=pMaxRes,
      final controllerType=controllerTypeFanSpe,
      final k=kFanSpe,
      final Ti=TiFanSpe,
      final Td=TdFanSpe,
      final yFanMax=yFanMax,
      final yFanMin=yFanMin) "Supply fan controller"
      annotation (Placement(transformation(extent={{-160,200},{-140,220}})));

    Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature
      supTemSetPoi(
      final TSupWarUpSetBac=TSupWarUpSetBac,
      final samplePeriod=samplePeriod,
      final TSupSetMin=TSupSetMin,
      final TSupSetMax=TSupSetMax,
      final TSupSetDes=TSupSetDes,
      final TOutMin=TOutMin,
      final TOutMax=TOutMax,
      final delTim=delTimSupTem,
      final numIgnReq=numIgnReqSupTem,
      final triAmo=triAmoSupTem,
      final resAmo=resAmoSupTem,
      final maxRes=maxResSupTem) "Setpoint for supply temperature"
      annotation (Placement(transformation(extent={{0,170},{20,190}})));

    Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.AHU
      sysOutAirSet(final VPriSysMax_flow=VPriSysMax_flow, final peaSysPop=
          peaSysPop) "Minimum outdoor airflow setpoint"
      annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

    Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller
      eco(
      final use_enthalpy=use_enthalpy,
      final delTOutHis=delTOutHis,
      final delEntHis=delEntHis,
      final retDamFulOpeTim=retDamFulOpeTim,
      final disDel=disDel,
      final controllerTypeMinOut=controllerTypeMinOut,
      final kMinOut=kMinOut,
      final TiMinOut=TiMinOut,
      final TdMinOut=TdMinOut,
      final retDamPhyPosMax=retDamPhyPosMax,
      final retDamPhyPosMin=retDamPhyPosMin,
      final outDamPhyPosMax=outDamPhyPosMax,
      final outDamPhyPosMin=outDamPhyPosMin,
      final uHeaMax=uHeaMax,
      final uCooMin=uCooMin,
      final uOutDamMax=(uHeaMax + uCooMin)/2,
      final uRetDamMin=(uHeaMax + uCooMin)/2,
      final TFreSet=TFreSet,
      final controllerTypeFre=controllerTypeFre,
      final kFre=kFre,
      final TiFre=TiFre,
      final TdFre=TdFre,
      final delta=delta,
      final use_TMix=use_TMix,
      final use_G36FrePro=use_G36FrePro) "Economizer controller"
      annotation (Placement(transformation(extent={{140,-170},{160,-150}})));

    Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals
      val(
      final controllerType=controllerTypeTSup,
      final kTSup=kTSup,
      final TiTSup=TiTSup,
      final TdTSup=TdTSup,
      final uHeaMax=uHeaMax,
      final uCooMin=uCooMin) "AHU coil valve control"
      annotation (Placement(transformation(extent={{80,-70},{100,-50}})));

  protected
    Buildings.Controls.OBC.CDL.Continuous.Divide VOut_flow_normalized(
      u1(final unit="m3/s"),
      u2(final unit="m3/s"),
      y(final unit="1"))
      "Normalization of outdoor air flow intake by design minimum outdoor air intake"
      annotation (Placement(transformation(extent={{20,-130},{40,-110}})));

  equation
    connect(eco.yRetDamPos, yRetDamPos)
      annotation (Line(points={{161.25,-157.5},{180,-157.5},{180,-150},{220,-150}},
        color={0,0,127}));
    connect(eco.yOutDamPos, yOutDamPos)
      annotation (Line(points={{161.25,-162.5},{180,-162.5},{180,-190},{220,-190}},
        color={0,0,127}));
    connect(eco.uSupFan, supFan.ySupFan)
      annotation (Line(points={{138.75,-165},{-84,-165},{-84,217},{-138,217}},
        color={255,0,255}));
    connect(supFan.ySupFanSpe, ySupFanSpe)
      annotation (Line(points={{-138,210},{220,210}},
        color={0,0,127}));
    connect(TOut, eco.TOut)
      annotation (Line(points={{-220,240},{-60,240},{-60,-150.625},{138.75,-150.625}},
        color={0,0,127}));
    connect(eco.TOutCut, TOutCut)
      annotation (Line(points={{138.75,-152.5},{-74,-152.5},{-74,-60},{-220,-60}},
        color={0,0,127}));
    connect(eco.hOut, hOut)
      annotation (Line(points={{138.75,-154.375},{-78,-154.375},{-78,-90},{-220,-90}},
        color={0,0,127}));
    connect(eco.hOutCut, hOutCut)
      annotation (Line(points={{138.75,-155.625},{-94,-155.625},{-94,-120},{-220,-120}},
        color={0,0,127}));
    connect(eco.uOpeMod, uOpeMod)
      annotation (Line(points={{138.75,-166.875},{60,-166.875},{60,-210},{-220,-210}},
        color={255,127,0}));
    connect(supTemSetPoi.TSupSet, TSupSet)
      annotation (Line(points={{22,180},{220,180}}, color={0,0,127}));
    connect(supTemSetPoi.TOut, TOut)
      annotation (Line(points={{-2,184},{-60,184},{-60,240},{-220,240}},
        color={0,0,127}));
    connect(supTemSetPoi.uSupFan, supFan.ySupFan)
      annotation (Line(points={{-2,176},{-84,176},{-84,217},{-138,217}},
        color={255,0,255}));
    connect(supTemSetPoi.uZonTemResReq, uZonTemResReq)
      annotation (Line(points={{-2,180},{-52,180},{-52,-240},{-220,-240}},
        color={255,127,0}));
    connect(supTemSetPoi.uOpeMod, uOpeMod)
      annotation (Line(points={{-2,172},{-48,172},{-48,-210},{-220,-210}},
        color={255,127,0}));
    connect(supFan.uOpeMod, uOpeMod)
      annotation (Line(points={{-162,218},{-180,218},{-180,-210},{-220,-210}},
        color={255,127,0}));
    connect(supFan.uZonPreResReq, uZonPreResReq)
      annotation (Line(points={{-162,207},{-176,207},{-176,-270},{-220,-270}},
        color={255,127,0}));
    connect(supFan.ducStaPre, ducStaPre)
      annotation (Line(points={{-162,202},{-192,202},{-192,210},{-220,210}},
        color={0,0,127}));
    connect(supTemSetPoi.TZonSetAve, TZonSetPoiAve.y)
      annotation (Line(points={{-2,188},{-20,188},{-20,280},{-138,280}},
        color={0,0,127}));
    connect(supFan.ySupFan, ySupFan)
      annotation (Line(points={{-138,217},{60,217},{60,280},{220,280}},
        color={255,0,255}));
    connect(TZonSetPoiAve.u2, TZonCooSet)
      annotation (Line(points={{-162,274},{-180,274},{-180,270},{-220,270}},
        color={0,0,127}));
    connect(eco.TMix, TMix)
      annotation (Line(points={{138.75,-163.125},{-12,-163.125},{-12,-180},{-220,-180}},
        color={0,0,127}));
    connect(TSup, val.TSup)
      annotation (Line(points={{-220,-30},{-66,-30},{-66,-65},{78,-65}},
        color={0,0,127}));
    connect(supFan.ySupFan, val.uSupFan)
      annotation (Line(points={{-138,217},{-84,217},{-84,-55},{78,-55}},
        color={255,0,255}));
    connect(val.uTSup, eco.uTSup)
      annotation (Line(points={{102,-56},{120,-56},{120,-157.5},{138.75,-157.5}},
        color={0,0,127}));
    connect(val.yHea, yHea)
      annotation (Line(points={{102,-60},{180,-60},{180,-30},{220,-30}},
        color={0,0,127}));
    connect(val.yCoo, yCoo)
      annotation (Line(points={{102,-64},{180,-64},{180,-90},{220,-90}},
        color={0,0,127}));
    connect(supTemSetPoi.TSupSet, val.TSupSet)
      annotation (Line(points={{22,180},{60,180},{60,-60},{78,-60}},
        color={0,0,127}));
    connect(TZonHeaSet, TZonSetPoiAve.u1)
      annotation (Line(points={{-220,300},{-180,300},{-180,286},{-162,286}},
        color={0,0,127}));
    connect(eco.uFreProSta, uFreProSta)
      annotation (Line(points={{138.75,-169.375},{66,-169.375},{66,-300},{-220,-300}},
        color={255,127,0}));
    connect(eco.VOut_flow_normalized, VOut_flow_normalized.y)
      annotation (Line(points={{138.75,-159.375},{60,-159.375},{60,-120},{42,-120}},
        color={0,0,127}));
    connect(VOut_flow_normalized.u1, VOut_flow)
      annotation (Line(points={{18,-114},{-160,-114},{-160,-150},{-220,-150}},
        color={0,0,127}));
    connect(sysOutAirSet.VDesUncOutAir_flow, VDesUncOutAir_flow) annotation (Line(
          points={{-18,88},{0,88},{0,140},{220,140}}, color={0,0,127}));
    connect(sysOutAirSet.VDesOutAir_flow, VOut_flow_normalized.u2) annotation (
        Line(points={{-18,82},{0,82},{0,-126},{18,-126}}, color={0,0,127}));
    connect(sysOutAirSet.effOutAir_normalized, eco.VOutMinSet_flow_normalized)
      annotation (Line(points={{-18,75},{-4,75},{-4,-161.25},{138.75,-161.25}},
          color={0,0,127}));
    connect(supFan.ySupFan, sysOutAirSet.uSupFan) annotation (Line(points={{-138,217},
            {-84,217},{-84,73},{-42,73}}, color={255,0,255}));
    connect(uOpeMod, sysOutAirSet.uOpeMod) annotation (Line(points={{-220,-210},{-48,
            -210},{-48,71},{-42,71}}, color={255,127,0}));
    connect(sysOutAirSet.yAveOutAirFraPlu, yAveOutAirFraPlu) annotation (Line(
          points={{-18,85},{20,85},{20,100},{220,100}}, color={0,0,127}));
    connect(sysOutAirSet.VEffOutAir_flow, VEffOutAir_flow) annotation (Line(
          points={{-18,78},{20,78},{20,60},{220,60}}, color={0,0,127}));
    connect(sysOutAirSet.yReqOutAir, yReqOutAir) annotation (Line(points={{-18,
            72},{16,72},{16,20},{220,20}}, color={255,0,255}));
    connect(sysOutAirSet.sumDesZonPop, sumDesZonPop) annotation (Line(points={{-42,
            89},{-120,89},{-120,180},{-220,180}}, color={0,0,127}));
    connect(sysOutAirSet.VSumDesPopBreZon_flow, VSumDesPopBreZon_flow)
      annotation (Line(points={{-42,87},{-126,87},{-126,150},{-220,150}}, color={0,
            0,127}));
    connect(sysOutAirSet.VSumDesAreBreZon_flow, VSumDesAreBreZon_flow)
      annotation (Line(points={{-42,85},{-132,85},{-132,120},{-220,120}}, color={0,
            0,127}));
    connect(sysOutAirSet.uDesSysVenEff, uDesSysVenEff) annotation (Line(points={{-42,
            83},{-138,83},{-138,90},{-220,90}}, color={0,0,127}));
    connect(sysOutAirSet.VSumUncOutAir_flow, VSumUncOutAir_flow) annotation (Line(
          points={{-42,81},{-138,81},{-138,60},{-220,60}}, color={0,0,127}));
    connect(sysOutAirSet.VSumSysPriAir_flow, VSumSysPriAir_flow) annotation (Line(
          points={{-42,79},{-132,79},{-132,30},{-220,30}}, color={0,0,127}));
    connect(uOutAirFra_max, sysOutAirSet.uOutAirFra_max) annotation (Line(points={
            {-220,0},{-126,0},{-126,77},{-42,77}}, color={0,0,127}));

  annotation (defaultComponentName="conAHU",
      Diagram(coordinateSystem(extent={{-200,-320},{200,320}}, initialScale=0.2)),
      Icon(coordinateSystem(extent={{-200,-360},{200,360}}, initialScale=0.2),
          graphics={Rectangle(
            extent={{200,360},{-200,-360}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid), Text(
            extent={{-200,450},{200,372}},
            textString="%name",
            textColor={0,0,255}),           Text(
            extent={{-200,348},{-116,332}},
            textColor={0,0,0},
            textString="TZonHeaSet"),       Text(
            extent={{102,-48},{202,-68}},
            textColor={255,0,255},
            textString="yReqOutAir"),       Text(
            extent={{-196,-238},{-122,-258}},
            textColor={255,127,0},
            textString="uOpeMod"),          Text(
            extent={{-200,318},{-114,302}},
            textColor={0,0,0},
            textString="TZonCooSet"),       Text(
            extent={{-198,260},{-120,242}},
            textColor={0,0,0},
            textString="ducStaPre"),        Text(
            extent={{-198,288},{-162,272}},
            textColor={0,0,0},
            textString="TOut"),             Text(
            extent={{-196,110},{-90,88}},
            textColor={0,0,0},
            textString="uDesSysVenEff"),    Text(
            extent={{-196,140},{-22,118}},
            textColor={0,0,0},
            textString="VSumDesAreBreZon_flow"),
                                            Text(
            extent={{-196,170},{-20,148}},
            textColor={0,0,0},
            textString="VSumDesPopBreZon_flow"),
                                            Text(
            extent={{-196,200},{-88,182}},
            textColor={0,0,0},
            textString="sumDesZonPop"),     Text(
            extent={{-200,-42},{-154,-62}},
            textColor={0,0,0},
            textString="TSup"),             Text(
            extent={{-200,18},{-84,0}},
            textColor={0,0,0},
            textString="uOutAirFra_max"),   Text(
            extent={{-196,48},{-62,30}},
            textColor={0,0,0},
            textString="VSumSysPriAir_flow"),
                                            Text(
            extent={{-196,80},{-42,58}},
            textColor={0,0,0},
            textString="VSumUncOutAir_flow"),
                                            Text(
            extent={{-200,-162},{-126,-180}},
            textColor={0,0,0},
            textString="VOut_flow"),        Text(
            visible=use_enthalpy,
            extent={{-200,-130},{-134,-148}},
            textColor={0,0,0},
            textString="hOutCut"),          Text(
            visible=use_enthalpy,
            extent={{-200,-100},{-160,-118}},
            textColor={0,0,0},
            textString="hOut"),             Text(
            extent={{-198,-70},{-146,-86}},
            textColor={0,0,0},
            textString="TOutCut"),          Text(
            visible=use_TMix,
            extent={{-200,-200},{-154,-218}},
            textColor={0,0,0},
            textString="TMix"),             Text(
            extent={{-194,-270},{-68,-290}},
            textColor={255,127,0},
            textString="uZonTemResReq"),    Text(
            extent={{-192,-300},{-74,-320}},
            textColor={255,127,0},
            textString="uZonPreResReq"),    Text(
            visible=use_G36FrePro,
            extent={{-200,-330},{-110,-348}},
            textColor={255,127,0},
            textString="uFreProSta"),       Text(
            extent={{106,252},{198,230}},
            textColor={0,0,0},
            textString="ySupFanSpe"),       Text(
            extent={{122,192},{202,172}},
            textColor={0,0,0},
            textString="TSupSet"),          Text(
            extent={{68,72},{196,52}},
            textColor={0,0,0},
            textString="yAveOutAirFraPlu"), Text(
            extent={{48,132},{196,110}},
            textColor={0,0,0},
            textString="VDesUncOutAir_flow"),
                                            Text(
            extent={{150,-104},{200,-126}},
            textColor={0,0,0},
            textString="yHea"),             Text(
            extent={{94,-288},{200,-308}},
            textColor={0,0,0},
            textString="yOutDamPos"),       Text(
            extent={{98,-228},{198,-248}},
            textColor={0,0,0},
            textString="yRetDamPos"),       Text(
            extent={{78,14},{196,-6}},
            textColor={0,0,0},
            textString="VEffOutAir_flow"),  Text(
            extent={{120,312},{202,292}},
            textColor={255,0,255},
            textString="ySupFan"),          Text(
            extent={{150,-166},{200,-188}},
            textColor={0,0,0},
            textString="yCoo")}),
  Documentation(info="<html>
<p>
Block that is applied for multizone VAV AHU control. It outputs the supply fan status
and the operation speed, outdoor and return air damper position, supply air
temperature setpoint and the valve position of the cooling and heating coils.
It is implemented according to the ASHRAE Guideline 36, PART 5.N.
</p>
<p>
The sequence consists of five subsequences.
</p>
<h4>Supply fan speed control</h4>
<p>
The fan speed control is implemented according to PART 5.N.1. It outputs
the boolean signal <code>ySupFan</code> to turn on or off the supply fan.
In addition, based on the pressure reset request <code>uZonPreResReq</code>
from the VAV zones controller, the
sequence resets the duct pressure setpoint, and uses this setpoint
to modulate the fan speed <code>ySupFanSpe</code> using a PI controller.
See
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyFan</a>
for more detailed description.
</p>
<h4>Minimum outdoor airflow setting</h4>
<p>
According to current occupany, supply operation status <code>ySupFan</code>,
zone temperatures and the discharge air temperature, the sequence computes the
minimum outdoor airflow rate setpoint, which is used as input for the economizer control.
More detailed information can be found in
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow</a>.
</p>
<h4>Economizer control</h4>
<p>
The block outputs outdoor and return air damper position, <code>yOutDamPos</code> and
<code>yRetDamPos</code>. First, it computes the position limits to satisfy the minimum
outdoor airflow requirement. Second, it determines the availability of the economizer based
on the outdoor condition. The dampers are modulated to track the supply air temperature
loop signal, which is calculated from the sequence below, subject to the minimum outdoor airflow
requirement and economizer availability. Optionally, there is also an override for freeze protection.
See
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.Economizers.Controller</a>
for more detailed description.
</p>
<h4>Supply air temperature setpoint</h4>
<p>
Based on PART 5.N.2, the sequence first sets the maximum supply air temperature
based on reset requests collected from each zone <code>uZonTemResReq</code>. The
outdoor temperature <code>TOut</code> and operation mode <code>uOpeMod</code> are used
along with the maximum supply air temperature, for computing the supply air temperature
setpoint. See
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplyTemperature</a>
for more detailed description.
</p>
<h4>Coil valve control</h4>
<p>
The subsequence retrieves supply air temperature setpoint from previous sequence.
Along with the measured supply air temperature and the supply fan status, it
generates coil valve positions. See
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.SupplySignals</a>
</p>
</html>",
  revisions="<html>
<ul>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Changed default value of integral time for minimum outdoor air control.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>.
</li>
<li>
March 16, 2020, by Jianjun Hu:<br/>
Reimplemented to add new block for specifying the minimum outdoor airfow setpoint.
This new block avoids vector-valued calculations.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1829\">#1829</a>.
</li>
<li>
October 27, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Controller;
  annotation (Icon(graphics={
      Rectangle(
        origin={0.0,35.1488},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}}),
      Rectangle(
        origin={0.0,-34.8512},
        fillColor={255,255,255},
        extent={{-30.0,-20.1488},{30.0,20.1488}}),
      Line(
        origin={-51.25,0.0},
        points={{21.25,-35.0},{-13.75,-35.0},{-13.75,35.0},{6.25,35.0}}),
      Polygon(
        origin={-40.0,35.0},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{10.0,0.0},{-5.0,5.0},{-5.0,-5.0}}),
      Polygon(
        origin={40.0,-35.0},
        pattern=LinePattern.None,
        fillPattern=FillPattern.Solid,
        points={{-10.0,0.0},{5.0,5.0},{5.0,-5.0}}),
      Line(
        origin={51.25,0.0},
        points={{-21.25,35.0},{13.75,35.0},{13.75,-35.0},{-6.25,-35.0}})}));
end Controls;
