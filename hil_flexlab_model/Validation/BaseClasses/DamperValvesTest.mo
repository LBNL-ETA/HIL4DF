within hil_flexlab_model.Validation.BaseClasses;
block DamperValvesTest
  "Output signals for controlling VAV reheat box damper and valve position"

  parameter Real dTDisZonSetMax(
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=11
    "Zone maximum discharge air temperature above heating setpoint";
  parameter Real TDisMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=283.15
    "Lowest discharge air temperature";

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeVal=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Valve"));

  parameter Real kVal(final unit="1/K")=0.5
    "Gain of controller for valve control"
    annotation(Dialog(group="Valve"));

  parameter Real TiVal(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for valve control"
    annotation(Dialog(group="Valve",
    enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdVal(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for valve control"
    annotation (Dialog(group="Valve",
      enable=controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeVal == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Boolean have_pressureIndependentDamper = true
    "True: the VAV damper is pressure independent (with built-in flow controller)"
    annotation(Dialog(group="Damper"));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeDam=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Damper"));

  parameter Real kDam(final unit="1")=0.5
    "Gain of controller for damper control"
    annotation(Dialog(group="Damper"));

  parameter Real TiDam(
    final unit="s",
    final quantity="Time")=300
    "Time constant of integrator block for damper control"
    annotation(Dialog(group="Damper",
    enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdDam(
    final unit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for damper control"
    annotation (Dialog(group="Damper",
      enable=controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeDam == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real V_flow_nominal(
    final unit="m3/s",
    final quantity="VolumeFlowRate",
    final min=1E-10)
    "Nominal volume flow rate, used to normalize control error"
    annotation(Dialog(group="Damper"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0,
    final max=1,
    final unit="1")
    "Heating control signal"
    annotation (Placement(transformation(extent={{-360,-160},{-320,-120}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature from central air handler"
    annotation (Placement(transformation(extent={{-360,-50},{-320,-10}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating setpoint temperature"
    annotation (Placement(transformation(extent={{-360,-80},{-320,-40}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-360,110},{-320,150}}),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-40,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-360,-370},{-320,-330}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaVal(
    final min=0,
    final max=1,
    final unit="1")
    "Reheater valve position"
    annotation (Placement(transformation(extent={{320,-40},{360,0}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4 "Logical not"
    annotation (Placement(transformation(extent={{-202,120},{-182,140}})));
  Buildings.Controls.OBC.CDL.Reals.Line conTDisHeaSet
    "Discharge air temperature for heating"
    annotation (Placement(transformation(extent={{-120,-82},{-100,-62}})));
  Buildings.Controls.Continuous.LimPID         conVal(
    final controllerType=controllerTypeVal,
    final k=kVal,
    final Ti=TiVal,
    final Td=TdVal,
    final yMax=1,
    final yMin=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    reset=Buildings.Types.Reset.Parameter)
    "Hot water valve controller"
    annotation (Placement(transformation(extent={{34,-90},{54,-70}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer2(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
public
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer3(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-260,-110},{-240,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conHal(
    final k=0.5) "Constant real value"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));
  Buildings.Obsolete.Controls.OBC.CDL.Continuous.AddParameter addPar(final p=
        dTDisZonSetMax, final k=1) "Maximum heating discharge temperature"
    annotation (Placement(transformation(extent={{-260,-70},{-240,-50}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys3(
    final uHigh=0.05,
    final uLow=0.01)
    "Check if heating control signal is greater than 0"
    annotation (Placement(transformation(extent={{-260,-220},{-240,-200}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys4(
    final uLow=TDisMin - 0.1,
    final uHigh=TDisMin + 0.1)
    "Check if discharge air temperature is greater than lowest discharge air temperature"
    annotation (Placement(transformation(extent={{-240,120},{-220,140}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol2(duration=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-222,-220},{-202,-200}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel3(delayTime=600)
    "Check if the true input holds for certain time"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isUno "Output true if the operation mode is unoccupied"
    annotation (Placement(transformation(extent={{220,-322},{240,-302}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant unOcc(final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.unoccupied)
    "Constant signal for unoccupied mode"
    annotation (Placement(transformation(extent={{170,-322},{190,-302}})));
  Buildings.Controls.OBC.CDL.Reals.Switch watValPosUno
    "Output hot water valve position"
    annotation (Placement(transformation(extent={{280,-30},{300,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant lowDisAirTem(
    final k=TDisMin)
    "Lowest allowed discharge air temperature"
    annotation (Placement(transformation(extent={{-68,-108},{-48,-88}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi6
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 "Logical not"
    annotation (Placement(transformation(extent={{-68,-64},{-48,-44}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3 "Logical not"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi3
    "Output hot water valve position in case of low discharge air temperature"
    annotation (Placement(transformation(extent={{104,-82},{124,-62}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6 "Negation of input signal"
    annotation (Placement(transformation(extent={{-40,-192},{-20,-172}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Check if it is not in heating mode and the discharge temperature is not too low"
    annotation (Placement(transformation(extent={{20,-56},{40,-36}})));

  Buildings.Controls.OBC.CDL.Logical.Not not5 "Negation of input signal"
    annotation (Placement(transformation(extent={{180,-238},{200,-218}})));
equation
  connect(uHea, hys3.u)
    annotation (Line(points={{-340,-140},{-280,-140},{-280,-210},{-262,-210}},
      color={0,0,127}));
  connect(conZer3.y, conTDisHeaSet.x1)
    annotation (Line(points={{-238,-100},{-220,-100},{-220,-64},{-122,-64}},
      color={0,0,127}));
  connect(TSup, conTDisHeaSet.f1)
    annotation (Line(points={{-340,-30},{-160,-30},{-160,-68},{-122,-68}},
      color={0,0,127}));
  connect(uHea, conTDisHeaSet.u)
    annotation (Line(points={{-340,-140},{-140,-140},{-140,-72},{-122,-72}},
      color={0,0,127}));
  connect(conHal.y, conTDisHeaSet.x2)
    annotation (Line(points={{-178,-100},{-160,-100},{-160,-76},{-122,-76}},
      color={0,0,127}));
  connect(addPar.y, conTDisHeaSet.f2)
    annotation (Line(points={{-238,-60},{-136,-60},{-136,-80},{-122,-80}},
      color={0,0,127}));
  connect(THeaSet, addPar.u)
    annotation (Line(points={{-340,-60},{-262,-60}}, color={0,0,127}));
  connect(TDis, hys4.u)
    annotation (Line(points={{-340,130},{-242,130}},
      color={0,0,127}));
  connect(hys4.y, not4.u)
    annotation (Line(points={{-218,130},{-204,130}}, color={255,0,255}));
  connect(hys3.y, truHol2.u)
    annotation (Line(points={{-238,-210},{-224,-210}}, color={255,0,255}));
  connect(conVal.u_m, TDis) annotation (Line(points={{44,-92},{44,-124},{-308,-124},
          {-308,130},{-340,130}}, color={0,0,127}));
  connect(unOcc.y, isUno.u1)
    annotation (Line(points={{192,-312},{218,-312}}, color={255,127,0}));
  connect(isUno.u2, uOpeMod) annotation (Line(points={{218,-320},{200,-320},{200,
          -350},{-340,-350}}, color={255,127,0}));
  connect(isUno.y, watValPosUno.u2) annotation (Line(points={{242,-312},{266,-312},
          {266,-20},{278,-20}}, color={255,0,255}));
  connect(conZer2.y, watValPosUno.u1) annotation (Line(points={{-58,8},{-20,8},{
          -20,-12},{278,-12}},  color={0,0,127}));
  connect(watValPosUno.y, yHeaVal)
    annotation (Line(points={{302,-20},{340,-20}}, color={0,0,127}));
  connect(truHol2.y, or2.u2) annotation (Line(points={{-200,-210},{-88,-210},{-88,
          -62},{-70,-62}},     color={255,0,255}));
  connect(truDel3.y, not3.u)
    annotation (Line(points={{-138,130},{-122,130}}, color={255,0,255}));
  connect(not3.y, or2.u1) annotation (Line(points={{-98,130},{-88,130},{-88,-54},
          {-70,-54}}, color={255,0,255}));
  connect(or2.y, swi6.u2) annotation (Line(points={{-46,-54},{-40,-54},{-40,-80},
          {-32,-80}}, color={255,0,255}));
  connect(conTDisHeaSet.y, swi6.u1)
    annotation (Line(points={{-98,-72},{-32,-72}}, color={0,0,127}));
  connect(swi6.u3, lowDisAirTem.y) annotation (Line(points={{-32,-88},{-40,-88},
          {-40,-98},{-46,-98}}, color={0,0,127}));
  connect(swi3.y, watValPosUno.u3) annotation (Line(points={{126,-72},{200,-72},
          {200,-28},{278,-28}}, color={0,0,127}));
  connect(truHol2.y, not6.u) annotation (Line(points={{-200,-210},{-60,-210},{-60,
          -182},{-42,-182}}, color={255,0,255}));
  connect(not6.y, and1.u2) annotation (Line(points={{-18,-182},{0,-182},{0,-54},
          {18,-54}},color={255,0,255}));
  connect(and1.y, swi3.u2) annotation (Line(points={{42,-46},{64,-46},{64,-72},{
          102,-72}}, color={255,0,255}));
  connect(conVal.y, swi3.u3)
    annotation (Line(points={{55,-80},{102,-80}},   color={0,0,127}));
  connect(swi3.u1, conZer2.y) annotation (Line(points={{102,-64},{76,-64},{76,-12},
          {-20,-12},{-20,8},{-58,8}}, color={0,0,127}));
  connect(not3.y, and1.u1) annotation (Line(points={{-98,130},{0,130},{0,-46},{18,
          -46}}, color={255,0,255}));
  connect(not4.y, truDel3.u)
    annotation (Line(points={{-180,130},{-162,130}}, color={255,0,255}));
  connect(swi6.y, conVal.u_s)
    annotation (Line(points={{-8,-80},{32,-80}},   color={0,0,127}));

  connect(isUno.y, not5.u) annotation (Line(points={{242,-312},{246,-312},{246,
          -192},{178,-192},{178,-228}}, color={255,0,255}));
  connect(conVal.trigger, not5.y) annotation (Line(points={{36,-92},{40,-92},{
          40,-260},{224,-260},{224,-228},{202,-228}}, color={255,0,255}));
annotation (
  defaultComponentName="damVal",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-320,-360},{320,360}}),
        graphics={
        Rectangle(
          extent={{-298,-22},{158,-118}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,158},{158,102}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,72},{158,-4}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-298,-162},{158,-338}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-52,42},{154,0}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in deadband state"),
        Text(
          extent={{88,-26},{150,-44}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Valve control"),
        Text(
          extent={{-44,-164},{154,-200}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Active airflow setpoint
in heating state")}),
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,68},{-62,54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-98,88},{-62,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMin_flow"),
        Text(
          extent={{-98,-76},{-60,-90}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{-98,-54},{-62,-66}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMin_flow"),
        Text(
          extent={{-98,44},{-70,38}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,102},{-80,96}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-100,-18},{-80,-24}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uHea"),
        Text(
          extent={{-100,2},{-76,-4}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="THeaSet"),
        Text(
          extent={{-100,24},{-80,16}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-11.5,3.5},{11.5,-3.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis",
          origin={-41.5,-89.5},
          rotation=90),
        Text(
          extent={{-100,-36},{-80,-42}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          visible=not have_pressureIndependentDamper,
          extent={{-11.5,4.5},{11.5,-4.5}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          origin={39.5,-85.5},
          rotation=90,
          textString="VDis_flow"),
        Text(
          extent={{72,44},{98,34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yDam",
          horizontalAlignment=TextAlignment.Right),
        Text(
          extent={{66,-34},{98,-48}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yHeaVal"),
        Line(points={{-50,64},{-50,-48},{62,-48}}, color={95,95,95}),
        Line(
          points={{-50,14},{-26,-18},{-2,-18},{-2,-22},{14,-22},{14,-16},{62,48}},
          color={0,0,255},
          thickness=0.5),
        Line(
          points={{-2,-22},{-2,-48}},
          color={215,215,215},
          pattern=LinePattern.Dash),
        Line(
          points={{-26,-18},{-26,36}},
          color={215,215,215},
          pattern=LinePattern.Dash),
        Line(
          points={{-26,36},{-50,36}},
          color={95,95,95},
          thickness=0.5),
        Line(
          points={{-26,36},{-2,-48}},
          color={95,95,95},
          thickness=0.5),
    Polygon(
      points={{-64,-58},{-42,-52},{-42,-64},{-64,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{-2,-58},{-60,-58}}, color={95,95,95}),
    Line(points={{16,-58},{78,-58}},  color={95,95,95}),
    Polygon(
      points={{80,-58},{58,-52},{58,-64},{80,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{60,88},{98,76}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VDisSet_flow"),
        Text(
          extent={{60,-74},{98,-86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="TDisHeaSet"),
        Text(
          extent={{-98,-96},{-78,-102}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uOpeMod")}),
  Documentation(info="<html>
<p>
This sequence sets the damper and valve position for VAV reheat terminal unit.
The implementation is according to ASHRAE Guideline 36 (G36), PART 5.E.6. The
calculation is done following the steps below.
</p>
<ol>
<li>
<p>
When the zone state is cooling (<code>uCoo>0</code>), then the cooling loop output
<code>uCoo</code> shall be mapped to the airflow
setpoint from the cooling minimum <code>VActCooMin_flow</code> to the cooling maximum
<code>VActCooMax_flow</code> airflow setpoints. The hot water valve is closed (<code>yHeaVal=0</code>)
unless the discharge air temperature <code>TDis</code> is below the minimum
setpoint (10 &deg;C).</p>
</li>
<li>
<p>If supply air temperature <code>TSup</code> from the AHU is greater than
room temperature <code>TZon</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</p>
</li>
<li>
<p>
When the zone state is Deadband (<code>uCoo=0</code> and <code>uHea=0</code>), then
the active airflow setpoint shall be the minimum airflow setpoint <code>VActMin_flow</code>.
Hot water valve is closed unless the discharge air temperature is below the minimum
setpoint (10 &deg;C).
</p>
</li>
<li>
<p>
When the zone state is Heating (<code>uHea>0</code>), then
the heating loop shall maintain space temperature at the heating setpoint
as follows:</p>
<ul>
<li>From 0-50%, the heating loop output <code>uHea</code> shall reset the
discharge temperature setpoint from current AHU SAT setpoint <code>TSup</code>
to a maximum of <code>dTDisZonSetMax</code> above space temperature setpoint. The airflow
setpoint shall be the heating minimum <code>VActHeaMin_flow</code>.</li>
<li>From 50-100%, if the discharge air temperature <code>TDis</code> is
greater than room temperature plus 2.8 Kelvin, the heating loop output <code>uHea</code>
shall reset the airflow setpoint from the heating minimum airflow setpoint
<code>VActHeaMin_flow</code> to the heating maximum airflow setpoint
<code>VActHeaMax_flow</code>.</li>
</ul>
</li>
<li>
<p>The hot water valve (or modulating electric heating coil) shall be modulated
to maintain the discharge temperature at setpoint.
</p>
</li>
<li>
<p>
The VAV damper shall be modulated by a control loop to maintain the measured
airflow at the active setpoint.
</p>
</li>
</ol>

<p>The sequences of controlling damper and valve position for VAV reheat terminal
unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper and valve control for VAV reheat terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Reheat/DamperValves.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
April 18, 2020, by Jianjun Hu:<br/>
Added option to check if the VAV damper is pressure independent.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">#1873</a>.
</li>
<li>
March 11, 2020, by Jianjun Hu:<br/>
Replaced multisum block with add blocks, replaced gain block used for normalization
with division block.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1830\">#1830</a>.
</li>
<li>
September 10, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end DamperValvesTest;
