within hil_flexlab_model.Validation;
model ZoneAirTemperatureCalibration1B

               package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
    package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);
  Test1.ThermalZones.Floor                                       floorG36_1(
    redeclare package Medium = MediumAir,
    idfName=Modelica.Utilities.Files.loadResource(
        "modelica://hil_flexlab_model/Resources/energyPlusFiles/X1-2021-V8_v2_NoInternalGain.idf"),
    epwName=Modelica.Utilities.Files.loadResource(
        "modelica://hil_flexlab_model/Resources/weatherdata/US_Berkeley_20210913.epw"),
    weaName=Modelica.Utilities.Files.loadResource(
        "modelica://hil_flexlab_model/Resources/weatherdata/US_Berkeley_20210913.mos"),
    nor(T_start(displayUnit="K") = 294.28),
    cor(T_start(displayUnit="K") = 294.91),
    sou(T_start(displayUnit="K") = 294.62))
    annotation (Placement(transformation(extent={{-60,6},{50,68}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://hil_flexlab_model/Resources/weatherdata/US_Berkeley_20210913.mos"))
    annotation (Placement(transformation(extent={{-98,62},{-78,82}})));
  Buildings.Fluid.Sources.MassFlowSource_T norFlo(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-152,46},{-132,66}})));
  Buildings.Fluid.Sources.MassFlowSource_T corFlo(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T souFlo(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{-102,-40},{-82,-20}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium = MediumAir,
      nPorts=1)
    annotation (Placement(transformation(extent={{158,48},{178,68}})));
  Buildings.Fluid.Sources.Boundary_pT bou1(redeclare package Medium = MediumAir,
      nPorts=1)
    annotation (Placement(transformation(extent={{162,8},{182,28}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(redeclare package Medium = MediumAir,
      nPorts=1)
    annotation (Placement(transformation(extent={{168,-26},{188,-6}})));
  Buildings.Fluid.Sources.Boundary_pT bou3(redeclare package Medium = MediumAir,
      nPorts=1)
    annotation (Placement(transformation(extent={{166,-58},{186,-38}})));
  Modelica.Blocks.Sources.CombiTimeTable norFloTab(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_VAV_North_Zone_Airflow_Rate.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-224,66},{-204,86}})));
  Modelica.Blocks.Sources.CombiTimeTable norTemTab(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_VAV_North_Zone_Discharge_Air_Temperature.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-222,36},{-202,56}})));
  Modelica.Blocks.Sources.CombiTimeTable corFloTab(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_VAV_Core_Zone_Airflow_Rate.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-210,-2},{-190,18}})));
  Modelica.Blocks.Sources.CombiTimeTable corTemTab(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_VAV_Core_Zone_Discharge_Air_Temperature.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-236,-44},{-216,-24}})));
  Modelica.Blocks.Sources.CombiTimeTable souFloTab(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_VAV_South_Zone_Airflow_Rate.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-170,-50},{-150,-30}})));
  Modelica.Blocks.Sources.CombiTimeTable souTemTab(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_VAV_South_Zone_Discharge_Air_Temperature.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-168,-80},{-148,-60}})));

  Modelica.Blocks.Math.Gain gain(k=1.2)
    annotation (Placement(transformation(extent={{-190,76},{-170,96}})));
  Modelica.Blocks.Math.Gain gain1(k=1.2)
    annotation (Placement(transformation(extent={{-176,14},{-156,34}})));
  Modelica.Blocks.Math.Gain gain2(k=1.2)
    annotation (Placement(transformation(extent={{-136,-36},{-116,-16}})));
  Modelica.Blocks.Sources.CombiTimeTable norRooTem(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_VAV_North_Zone_Room_Air_Temperature.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{198,54},{218,74}})));
  Modelica.Blocks.Sources.CombiTimeTable corRooTem(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_VAV_Core_Zone_Room_Air_Temperature.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{200,0},{220,20}})));
  Modelica.Blocks.Sources.CombiTimeTable souRooTem(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_VAV_South_Zone_Room_Air_Temperature.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{208,-42},{228,-22}})));
  Modelica.Blocks.Sources.CombiTimeTable OAT(
    tableOnFile=true,
    tableName="tab1",
    fileName="/home/huangwp/LBNL_work/HIL/convert_csv_to_txt/txt_files/1B_Outdoor_Air_Temperature.txt",
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    annotation (Placement(transformation(extent={{-34,-88},{-14,-68}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC
    annotation (Placement(transformation(extent={{-186,40},{-166,60}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-202,-36},{-182,-16}})));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degC2
    annotation (Placement(transformation(extent={{-132,-90},{-112,-70}})));
equation
  connect(weaDat.weaBus, floorG36_1.weaBus) annotation (Line(
      points={{-78,72},{0,72},{0,77.5385},{9.34783,77.5385}},
      color={255,204,51},
      thickness=0.5));
  connect(norFlo.ports[1], floorG36_1.portsNor[1]) annotation (Line(points={{-132,56},
          {-104,56},{-104,88},{-18.6304,88},{-18.6304,54.6462}},     color={0,127,
          255}));
  connect(bou.ports[1], floorG36_1.portsNor[2]) annotation (Line(points={{178,58},
          {184,58},{184,86},{-16.2391,86},{-16.2391,54.6462}}, color={0,127,255}));
  connect(corFlo.ports[1], floorG36_1.portsCor[1]) annotation (Line(points={{-120,10},
          {-66,10},{-66,0},{-28,0},{-28,38.4308},{-18.6304,38.4308}},     color=
         {0,127,255}));
  connect(bou1.ports[1], floorG36_1.portsCor[2]) annotation (Line(points={{182,18},
          {184,18},{184,0},{58,0},{58,-2},{-28,-2},{-28,38.4308},{-16.2391,
          38.4308}},
        color={0,127,255}));
  connect(souFlo.ports[1], floorG36_1.portsSou[1]) annotation (Line(points={{-82,-30},
          {-28,-30},{-28,0},{16,0},{16,26},{-18.6304,26},{-18.6304,19.3538}},
        color={0,127,255}));
  connect(bou2.ports[1], floorG36_1.portsSou[2]) annotation (Line(points={{188,-16},
          {190,-16},{190,2},{56,2},{56,0},{16,0},{16,28},{-16.2391,28},{
          -16.2391,19.3538}},
                     color={0,127,255}));
  connect(bou3.ports[1], floorG36_1.portsEas[2]) annotation (Line(points={{186,-48},
          {192,-48},{192,38.4308},{38.2826,38.4308}}, color={0,127,255}));
  connect(corFloTab.y[1], gain1.u)
    annotation (Line(points={{-189,8},{-189,24},{-178,24}}, color={0,0,127}));
  connect(norFloTab.y[1], gain.u) annotation (Line(points={{-203,76},{-198,76},{
          -198,86},{-192,86}}, color={0,0,127}));
  connect(souFloTab.y[1], gain2.u) annotation (Line(points={{-149,-40},{-149,-10},
          {-138,-10},{-138,-26}}, color={0,0,127}));
  connect(gain.y, norFlo.m_flow_in) annotation (Line(points={{-169,86},{-162,86},
          {-162,64},{-154,64}}, color={0,0,127}));
  connect(gain1.y, corFlo.m_flow_in) annotation (Line(points={{-155,24},{-150,24},
          {-150,18},{-142,18}}, color={0,0,127}));
  connect(gain2.y, souFlo.m_flow_in) annotation (Line(points={{-115,-26},{-108,-26},
          {-108,-22},{-104,-22}}, color={0,0,127}));
  connect(norTemTab.y[1], from_degC.u) annotation (Line(points={{-201,46},{-194,
          46},{-194,50},{-188,50}}, color={0,0,127}));
  connect(from_degC.y, norFlo.T_in) annotation (Line(points={{-165,50},{-160,50},
          {-160,60},{-154,60}}, color={0,0,127}));
  connect(from_degC1.y, corFlo.T_in) annotation (Line(points={{-181,-26},{-176,
          -26},{-176,8},{-150,8},{-150,14},{-142,14}}, color={0,0,127}));
  connect(corTemTab.y[1], from_degC1.u) annotation (Line(points={{-215,-34},{
          -210,-34},{-210,-26},{-204,-26}}, color={0,0,127}));
  connect(souTemTab.y[1], from_degC2.u) annotation (Line(points={{-147,-70},{
          -142,-70},{-142,-80},{-134,-80}}, color={0,0,127}));
  connect(from_degC2.y, souFlo.T_in) annotation (Line(points={{-111,-80},{-76,
          -80},{-76,-14},{-104,-14},{-104,-26}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=19526400,
      StopTime=22118400,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end ZoneAirTemperatureCalibration1B;
