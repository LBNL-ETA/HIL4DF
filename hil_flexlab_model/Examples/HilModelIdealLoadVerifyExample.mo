within hil_flexlab_model.Examples;
model HilModelIdealLoadVerifyExample
  BaseClasses.HilModelIdealLoadVerify hilModelIdealLoadVerify
    annotation (Placement(transformation(extent={{36,-26},{56,-6}})));
  BaseClasses.Trc_custom_air_conditioner_ConstantFlowRate
    trc_custom_air_conditioner_ConstantFlowRate[6]
    annotation (Placement(transformation(extent={{46,38},{66,58}})));
  Modelica.Blocks.Sources.CombiTimeTable cooSetNoDf(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://hil_flexlab_model/Resources/FlexlabSchedule/cooling_baseline schedule.txt"),

    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600) "cooling schedule for demand response"
    annotation (Placement(transformation(extent={{-186,40},{-166,60}})));
  Modelica.Blocks.Sources.CombiTimeTable heaSetDR(
    tableOnFile=true,
    tableName="tab1",
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://hil_flexlab_model/Resources/FlexlabSchedule/heating_baseline schedule.txt"),

    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600) "heating schedule for demand response"
    annotation (Placement(transformation(extent={{-176,-32},{-156,-12}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(nout=6)
    annotation (Placement(transformation(extent={{-54,40},{-34,60}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(nout=6)
    annotation (Placement(transformation(extent={{-46,-40},{-26,-20}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{-126,50},{-106,70}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-116,-34},{-96,-14}})));
equation
  connect(hilModelIdealLoadVerify.TAir[1:6],
    trc_custom_air_conditioner_ConstantFlowRate.ZAT) annotation (Line(points={{
          58,-21.4833},{76,-21.4833},{76,-22},{90,-22},{90,64},{44,64},{44,54.4}},
        color={0,0,127}));
  connect(trc_custom_air_conditioner_ConstantFlowRate.port_b,
    hilModelIdealLoadVerify.port_a[1:6]) annotation (Line(points={{66.8,39},{76,
          39},{76,14},{20,14},{20,-11.4417},{35.6,-11.4417}}, color={0,127,255}));
  connect(trc_custom_air_conditioner_ConstantFlowRate.port_a,
    hilModelIdealLoadVerify.port_b[1:6]) annotation (Line(points={{45,38.8},{2,
          38.8},{2,2},{62,2},{62,-11.4417},{56.4,-11.4417}}, color={0,127,255}));
  connect(trc_custom_air_conditioner_ConstantFlowRate.TCooSet, reaScaRep.y)
    annotation (Line(points={{44,50},{-32,50}}, color={0,0,127}));
  connect(trc_custom_air_conditioner_ConstantFlowRate.THeaSet, reaScaRep1.y)
    annotation (Line(points={{44,45.4},{-16,45.4},{-16,-38},{-24,-38},{-24,-30}},
        color={0,0,127}));
  connect(cooSetNoDf.y[1], from_degC.u) annotation (Line(points={{-165,50},{
          -146,50},{-146,60},{-128,60}}, color={0,0,127}));
  connect(heaSetDR.y[1], from_degC1.u) annotation (Line(points={{-155,-22},{
          -137,-22},{-137,-24},{-118,-24}}, color={0,0,127}));
  connect(from_degC.y, reaScaRep.u) annotation (Line(points={{-105,60},{-64,60},
          {-64,50},{-56,50}}, color={0,0,127}));
  connect(from_degC1.y, reaScaRep1.u) annotation (Line(points={{-95,-24},{-70,
          -24},{-70,-32},{-48,-32},{-48,-30}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=31536000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end HilModelIdealLoadVerifyExample;
