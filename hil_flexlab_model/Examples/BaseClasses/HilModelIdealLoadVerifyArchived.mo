within hil_flexlab_model.Examples.BaseClasses;
model HilModelIdealLoadVerifyArchived
       package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
    package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);

  hil_flexlab_model.Examples.BaseClasses.Zone zone1(zoneName="G SW Apartment")
    annotation (Placement(transformation(extent={{32,-24},{52,-4}})));
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building
                 building(
    idfName=Modelica.Utilities.Files.loadResource(
        "modelica://CCC/Resources/Data/energyPlusFiles/MidriseApartmentModern_6A_USA_MN_MINNEAPOLIS_V960_v2.idf"),
    weaName=Modelica.Utilities.Files.loadResource(
        "modelica://CCC/Resources/weatherdata/USA_MN_Rochester.Intl.AP.726440_TMY3.mos"),
    epwName=Modelica.Utilities.Files.loadResource(
        "modelica://CCC/Resources/weatherdata/USA_MN_Rochester.Intl.AP.726440_TMY3.epw"),
    computeWetBulbTemperature=false)
    "Building model"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate1(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-18,-42},{2,-22}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a[27](redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{-114,36},{-94,56}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b[27](redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{94,36},{114,56}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone2(zoneName="G NW Apartment")
    annotation (Placement(transformation(extent={{32,-94},{52,-74}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate2(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-18,-112},{2,-92}})));
  Modelica.Blocks.Interfaces.RealOutput TAir[27] annotation (Placement(
        transformation(extent={{100,-72},{140,-32}}), iconTransformation(extent=
           {{100,-74},{140,-34}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone3(zoneName="Office")
    annotation (Placement(transformation(extent={{32,-152},{52,-132}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate3(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-18,-170},{2,-150}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone4(zoneName="G NE Apartment")
    annotation (Placement(transformation(extent={{34,-210},{54,-190}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate4(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-16,-228},{4,-208}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone5(zoneName="G N1 Apartment")
    annotation (Placement(transformation(extent={{36,-262},{56,-242}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate5(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.01714)
    annotation (Placement(transformation(extent={{-14,-280},{6,-260}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone6(zoneName="G N2 Apartment")
    annotation (Placement(transformation(extent={{34,-332},{54,-312}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate6(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.01714)
    annotation (Placement(transformation(extent={{-16,-350},{4,-330}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone7(zoneName="G S1 Apartment")
    annotation (Placement(transformation(extent={{28,-404},{48,-384}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate7(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.01714)
    annotation (Placement(transformation(extent={{-22,-422},{-2,-402}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone8(zoneName="G S2 Apartment")
    annotation (Placement(transformation(extent={{32,-466},{52,-446}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate8(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.01714)
    annotation (Placement(transformation(extent={{-18,-484},{2,-464}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone9(zoneName="M SW Apartment")
    annotation (Placement(transformation(extent={{30,-536},{50,-516}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate9(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-20,-554},{0,-534}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone10(zoneName="M NW Apartment")
    annotation (Placement(transformation(extent={{32,-586},{52,-566}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate10(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-18,-604},{2,-584}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone11(zoneName="M SE Apartment")
    annotation (Placement(transformation(extent={{30,-646},{50,-626}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate11(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-20,-664},{0,-644}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone12(zoneName="M NE Apartment")
    annotation (Placement(transformation(extent={{28,-694},{48,-674}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate12(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-22,-712},{-2,-692}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone13(zoneName="M N1 Apartment")
    annotation (Placement(transformation(extent={{30,-736},{50,-716}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate13(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.01714)
    annotation (Placement(transformation(extent={{-20,-754},{0,-734}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone14(zoneName="M N2 Apartment")
    annotation (Placement(transformation(extent={{26,-788},{46,-768}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate14(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.01714)
    annotation (Placement(transformation(extent={{-24,-806},{-4,-786}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone15(zoneName="M S1 Apartment")
    annotation (Placement(transformation(extent={{24,-834},{44,-814}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate15(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.01714)
    annotation (Placement(transformation(extent={{-26,-852},{-6,-832}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone16(zoneName="M S2 Apartment")
    annotation (Placement(transformation(extent={{32,-888},{52,-868}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate16(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.01714)
    annotation (Placement(transformation(extent={{-18,-906},{2,-886}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone17(zoneName="T SW Apartment")
    annotation (Placement(transformation(extent={{28,-932},{48,-912}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate17(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-22,-950},{-2,-930}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone18(zoneName="T NW Apartment")
    annotation (Placement(transformation(extent={{30,-984},{50,-964}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate18(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-20,-1002},{0,-982}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone19(zoneName="T SE Apartment")
    annotation (Placement(transformation(extent={{28,-1030},{48,-1010}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate19(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-22,-1048},{-2,-1028}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone20(zoneName="T NE Apartment")
    annotation (Placement(transformation(extent={{30,-1080},{50,-1060}})));

  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate20(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.02847)
    annotation (Placement(transformation(extent={{-20,-1098},{0,-1078}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone21(zoneName="T N1 Apartment")
    annotation (Placement(transformation(extent={{30,-1124},{50,-1104}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate21(
    A=0,
    B=0,
    C=0.224,
    D=0,
    desFloRat=0.01714)
    annotation (Placement(transformation(extent={{-20,-1142},{0,-1122}})));
  Modelica.Blocks.Interfaces.RealOutput TOut annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={2,110})));
  Buildings.BoundaryConditions.WeatherData.Bus
                                     weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-48,44},{-10,80}}),
        iconTransformation(extent={{-48,44},{-10,80}})));
equation
  connect(building.weaBus, zone1.weaBus) annotation (Line(
      points={{-120,-10},{22,-10},{22,-14},{32,-14}},
      color={255,204,51},
      thickness=0.5));
  connect(zone1.TAir, infiltration_DesignFlowRate1.zonAirTem) annotation (Line(
        points={{53,-10},{60,-10},{60,-8},{62,-8},{62,22},{-20,22},{-20,-27.8}},
        color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate1.weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-37.4},{-18.4,-37.4}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate1.infFloRat, zone1.m_flow_in) annotation (
      Line(points={{4,-32},{18,-32},{18,-21.4},{29.8,-21.4}},  color={0,0,127}));
  connect(building.weaBus,zone2. weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-84},{32,-84}},
      color={255,204,51},
      thickness=0.5));
  connect(zone2.TAir,infiltration_DesignFlowRate2. zonAirTem) annotation (Line(
        points={{53,-80},{60,-80},{60,-78},{62,-78},{62,-48},{-20,-48},{-20,-97.8}},
        color={0,0,127}));
  connect(building.weaBus,infiltration_DesignFlowRate2. weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-107.4},{-18.4,-107.4}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate2.infFloRat,zone2. m_flow_in) annotation (
      Line(points={{4,-102},{18,-102},{18,-91.4},{29.8,-91.4}},color={0,0,127}));
  connect(port_a[1], zone1.port_a) annotation (Line(points={{-104,41.1852},{
          -104,18},{26,18},{26,-5.4},{31.6,-5.4}},
                                          color={0,127,255}));
  connect(port_b[1], zone1.port_b) annotation (Line(points={{104,41.1852},{58,
          41.1852},{58,-5.2},{52.4,-5.2}},
                                  color={0,127,255}));
  connect(port_a[2], zone2.port_a) annotation (Line(points={{-104,41.5556},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-75.4},{31.6,-75.4}},
                                                              color={0,127,255}));
  connect(port_b[2], zone2.port_b) annotation (Line(points={{104,41.5556},{92,
          41.5556},{92,44},{58,44},{58,-46},{64,-46},{64,-75.2},{52.4,-75.2}},
                                                                      color={0,127,
          255}));
  connect(zone1.TAir, TAir[1]) annotation (Line(points={{53,-10},{96,-10},{96,
          -61.6296},{120,-61.6296}},
                      color={0,0,127}));
  connect(zone2.TAir, TAir[2]) annotation (Line(points={{53,-80},{60,-80},{60,
          -78},{96,-78},{96,-60.8889},{120,-60.8889}},
                                        color={0,0,127}));
  connect(building.weaBus,zone3. weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-142},{32,-142}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate3.infFloRat,zone3. m_flow_in) annotation (
      Line(points={{4,-160},{18,-160},{18,-149.4},{29.8,-149.4}},
                                                               color={0,0,127}));
  connect(zone3.TAir,infiltration_DesignFlowRate3. zonAirTem) annotation (Line(
        points={{53,-138},{60,-138},{60,-136},{62,-136},{62,-106},{-20,-106},{-20,
          -155.8}},
        color={0,0,127}));
  connect(building.weaBus,infiltration_DesignFlowRate3. weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-165.4},{-18.4,-165.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus,zone4. weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-200},{34,-200}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate4.infFloRat,zone4. m_flow_in) annotation (
      Line(points={{6,-218},{20,-218},{20,-207.4},{31.8,-207.4}},
                                                               color={0,0,127}));
  connect(zone4.TAir,infiltration_DesignFlowRate4. zonAirTem) annotation (Line(
        points={{55,-196},{62,-196},{62,-194},{64,-194},{64,-164},{-18,-164},{-18,
          -213.8}},
        color={0,0,127}));
  connect(building.weaBus,infiltration_DesignFlowRate4. weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-223.4},{-16.4,-223.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus,zone5. weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-252},{36,-252}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate5.infFloRat,zone5. m_flow_in) annotation (
      Line(points={{8,-270},{22,-270},{22,-259.4},{33.8,-259.4}},
                                                               color={0,0,127}));
  connect(zone5.TAir,infiltration_DesignFlowRate5. zonAirTem) annotation (Line(
        points={{57,-248},{64,-248},{64,-246},{66,-246},{66,-216},{-16,-216},{-16,
          -265.8}},
        color={0,0,127}));
  connect(building.weaBus,infiltration_DesignFlowRate5. weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-275.4},{-14.4,-275.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus,zone6. weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-252},{26,-252},{26,
          -322},{34,-322}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate6.infFloRat,zone6. m_flow_in) annotation (
      Line(points={{6,-340},{20,-340},{20,-329.4},{31.8,-329.4}},
                                                               color={0,0,127}));
  connect(zone6.TAir,infiltration_DesignFlowRate6. zonAirTem) annotation (Line(
        points={{55,-318},{62,-318},{62,-316},{64,-316},{64,-286},{-18,-286},{-18,
          -335.8}},
        color={0,0,127}));
  connect(building.weaBus,infiltration_DesignFlowRate6. weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-345.4},{-16.4,-345.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus,zone7. weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{28,-394}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate7.infFloRat,zone7. m_flow_in) annotation (
      Line(points={{0,-412},{14,-412},{14,-401.4},{25.8,-401.4}},
                                                               color={0,0,127}));
  connect(zone7.TAir,infiltration_DesignFlowRate7. zonAirTem) annotation (Line(
        points={{49,-390},{56,-390},{56,-388},{58,-388},{58,-358},{-24,-358},{-24,
          -407.8}},
        color={0,0,127}));
  connect(building.weaBus,infiltration_DesignFlowRate7. weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-356},{-26,-356},{-26,-396},{-32,-396},{-32,-417.4},{-22.4,-417.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus,zone8. weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{32,-456}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate8.infFloRat,zone8. m_flow_in) annotation (
      Line(points={{4,-474},{18,-474},{18,-463.4},{29.8,-463.4}},
                                                               color={0,0,127}));
  connect(zone8.TAir,infiltration_DesignFlowRate8. zonAirTem) annotation (Line(
        points={{53,-452},{60,-452},{60,-450},{62,-450},{62,-420},{-20,-420},{-20,
          -469.8}},
        color={0,0,127}));
  connect(building.weaBus,infiltration_DesignFlowRate8. weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-356},{-26,-356},{-26,-396},{-32,-396},{-32,-418},{-28,-418},{-28,
          -479.4},{-18.4,-479.4}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate9.infFloRat,zone9. m_flow_in) annotation (
      Line(points={{2,-544},{16,-544},{16,-533.4},{27.8,-533.4}},
                                                               color={0,0,127}));
  connect(zone9.TAir,infiltration_DesignFlowRate9. zonAirTem) annotation (Line(
        points={{51,-522},{58,-522},{58,-520},{60,-520},{60,-490},{-22,-490},{-22,
          -539.8}},
        color={0,0,127}));
  connect(building.weaBus,infiltration_DesignFlowRate9. weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-356},{-26,-356},{-26,-396},{-32,-396},{-32,-418},{-28,-418},{-28,
          -532},{-30,-532},{-30,-549.4},{-20.4,-549.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus,zone9. weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-526},{30,-526}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate10.infFloRat, zone10.m_flow_in)
    annotation (Line(points={{4,-594},{18,-594},{18,-583.4},{29.8,-583.4}},
        color={0,0,127}));
  connect(zone10.TAir, infiltration_DesignFlowRate10.zonAirTem) annotation (
      Line(points={{53,-572},{60,-572},{60,-570},{62,-570},{62,-540},{-20,-540},
          {-20,-589.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate10.weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-526},{20,-526},{20,-612},
          {-24,-612},{-24,-599.4},{-18.4,-599.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone10.weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-526},{20,-526},{20,-576},
          {32,-576}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate11.infFloRat, zone11.m_flow_in)
    annotation (Line(points={{2,-654},{16,-654},{16,-643.4},{27.8,-643.4}},
        color={0,0,127}));
  connect(zone11.TAir, infiltration_DesignFlowRate11.zonAirTem) annotation (
      Line(points={{51,-632},{58,-632},{58,-630},{60,-630},{60,-600},{-22,-600},
          {-22,-649.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate11.weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-526},{20,-526},{20,-612},
          {-32,-612},{-32,-659.4},{-20.4,-659.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone11.weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-526},{20,-526},{20,-636},
          {30,-636}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate12.infFloRat, zone12.m_flow_in)
    annotation (Line(points={{0,-702},{14,-702},{14,-691.4},{25.8,-691.4}},
        color={0,0,127}));
  connect(zone12.TAir, infiltration_DesignFlowRate12.zonAirTem) annotation (
      Line(points={{49,-680},{56,-680},{56,-678},{58,-678},{58,-648},{-24,-648},
          {-24,-697.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate12.weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-356},{-26,-356},{-26,-396},{-32,-396},{-32,-418},{-28,-418},{-28,
          -532},{-30,-532},{-30,-612},{-32,-612},{-32,-660},{-30,-660},{-30,-690},
          {-32,-690},{-32,-707.4},{-22.4,-707.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone12.weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-526},{20,-526},{20,-684},
          {28,-684}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate13.infFloRat, zone13.m_flow_in)
    annotation (Line(points={{2,-744},{16,-744},{16,-733.4},{27.8,-733.4}},
        color={0,0,127}));
  connect(zone13.TAir, infiltration_DesignFlowRate13.zonAirTem) annotation (
      Line(points={{51,-722},{58,-722},{58,-720},{60,-720},{60,-690},{-22,-690},
          {-22,-739.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate13.weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-526},{20,-526},{20,-612},
          {-32,-612},{-32,-660},{-30,-660},{-30,-690},{-32,-690},{-32,-749.4},{-20.4,
          -749.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone13.weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-526},{20,-526},{20,-684},
          {10,-684},{10,-726},{30,-726}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate14.infFloRat, zone14.m_flow_in)
    annotation (Line(points={{-2,-796},{12,-796},{12,-785.4},{23.8,-785.4}},
        color={0,0,127}));
  connect(zone14.TAir, infiltration_DesignFlowRate14.zonAirTem) annotation (
      Line(points={{47,-774},{54,-774},{54,-772},{56,-772},{56,-742},{-26,-742},
          {-26,-791.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate14.weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-396},{-32,-396},{
          -32,-418},{-28,-418},{-28,-532},{-30,-532},{-30,-690},{-32,-690},{-32,
          -784},{-34,-784},{-34,-801.4},{-24.4,-801.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone14.weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-346},{-22,-346},{
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-526},{20,-526},{20,-684},
          {10,-684},{10,-726},{20,-726},{20,-778},{26,-778}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate15.infFloRat, zone15.m_flow_in)
    annotation (Line(points={{-4,-842},{10,-842},{10,-831.4},{21.8,-831.4}},
        color={0,0,127}));
  connect(zone15.TAir, infiltration_DesignFlowRate15.zonAirTem) annotation (
      Line(points={{45,-820},{52,-820},{52,-818},{54,-818},{54,-788},{-28,-788},
          {-28,-837.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate15.weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-396},{-32,-396},{
          -32,-418},{-28,-418},{-28,-532},{-30,-532},{-30,-690},{-32,-690},{-32,
          -784},{-34,-784},{-34,-802},{-30,-802},{-30,-826},{-36,-826},{-36,-847.4},
          {-26.4,-847.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone15.weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-396},{-32,-396},{
          -32,-418},{-28,-418},{-28,-532},{-30,-532},{-30,-690},{-32,-690},{-32,
          -784},{-34,-784},{-34,-802},{-30,-802},{-30,-824},{24,-824}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate16.infFloRat, zone16.m_flow_in)
    annotation (Line(points={{4,-896},{18,-896},{18,-885.4},{29.8,-885.4}},
        color={0,0,127}));
  connect(zone16.TAir, infiltration_DesignFlowRate16.zonAirTem) annotation (
      Line(points={{53,-874},{60,-874},{60,-872},{62,-872},{62,-842},{-20,-842},
          {-20,-891.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate16.weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-396},{-32,-396},{
          -32,-418},{-28,-418},{-28,-532},{-30,-532},{-30,-690},{-32,-690},{-32,
          -784},{-34,-784},{-34,-802},{-30,-802},{-30,-826},{-36,-826},{-36,-848},
          {-32,-848},{-32,-901.4},{-18.4,-901.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone16.weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-396},{-32,-396},{
          -32,-418},{-28,-418},{-28,-532},{-30,-532},{-30,-690},{-32,-690},{-32,
          -784},{-34,-784},{-34,-802},{-30,-802},{-30,-824},{14,-824},{14,-878},
          {32,-878}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate17.infFloRat, zone17.m_flow_in)
    annotation (Line(points={{0,-940},{14,-940},{14,-929.4},{25.8,-929.4}},
        color={0,0,127}));
  connect(zone17.TAir, infiltration_DesignFlowRate17.zonAirTem) annotation (
      Line(points={{49,-918},{56,-918},{56,-916},{58,-916},{58,-886},{-24,-886},
          {-24,-935.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate17.weaBus) annotation (
      Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-396},{-32,-396},{
          -32,-418},{-28,-418},{-28,-532},{-30,-532},{-30,-690},{-32,-690},{-32,
          -784},{-34,-784},{-34,-802},{-30,-802},{-30,-826},{-36,-826},{-36,-848},
          {-32,-848},{-32,-945.4},{-22.4,-945.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone17.weaBus) annotation (Line(
      points={{-120,-10},{-30,-10},{-30,-166},{-26,-166},{-26,-396},{-32,-396},{
          -32,-418},{-28,-418},{-28,-532},{-30,-532},{-30,-690},{-32,-690},{-32,
          -784},{-34,-784},{-34,-802},{-30,-802},{-30,-824},{14,-824},{14,-922},
          {28,-922}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate18.infFloRat, zone18.m_flow_in)
    annotation (Line(points={{2,-992},{16,-992},{16,-981.4},{27.8,-981.4}},
        color={0,0,127}));
  connect(zone18.TAir, infiltration_DesignFlowRate18.zonAirTem) annotation (
      Line(points={{51,-970},{58,-970},{58,-968},{60,-968},{60,-938},{-22,-938},
          {-22,-987.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate18.weaBus) annotation (
      Line(
      points={{-120,-10},{-120,-12},{-32,-12},{-32,-168},{-28,-168},{-28,-396},{
          -32,-396},{-32,-420},{-28,-420},{-28,-532},{-32,-532},{-32,-784},{-36,
          -784},{-36,-804},{-32,-804},{-32,-828},{-36,-828},{-36,-848},{-32,-848},
          {-32,-997.4},{-20.4,-997.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone18.weaBus) annotation (Line(
      points={{-120,-10},{-120,-12},{-32,-12},{-32,-168},{-28,-168},{-28,-396},{
          20,-396},{20,-456},{24,-456},{24,-528},{20,-528},{20,-612},{-32,-612},
          {-32,-784},{-36,-784},{-36,-804},{-32,-804},{-32,-828},{-36,-828},{-36,
          -848},{-32,-848},{-32,-960},{16,-960},{16,-974},{30,-974}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate19.infFloRat, zone19.m_flow_in)
    annotation (Line(points={{0,-1038},{14,-1038},{14,-1027.4},{25.8,-1027.4}},
        color={0,0,127}));
  connect(zone19.TAir, infiltration_DesignFlowRate19.zonAirTem) annotation (
      Line(points={{49,-1016},{56,-1016},{56,-1014},{58,-1014},{58,-984},{-24,-984},
          {-24,-1033.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate19.weaBus) annotation (
      Line(
      points={{-120,-10},{-120,-12},{-32,-12},{-32,-168},{-28,-168},{-28,-396},{
          -32,-396},{-32,-420},{-28,-420},{-28,-532},{-32,-532},{-32,-784},{-36,
          -784},{-36,-804},{-32,-804},{-32,-828},{-36,-828},{-36,-848},{-32,-848},
          {-32,-1043.4},{-22.4,-1043.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone19.weaBus) annotation (Line(
      points={{-120,-10},{-120,-12},{-32,-12},{-32,-168},{-28,-168},{-28,-396},{
          20,-396},{20,-456},{24,-456},{24,-528},{20,-528},{20,-612},{-32,-612},
          {-32,-784},{-36,-784},{-36,-804},{-32,-804},{-32,-828},{-36,-828},{-36,
          -848},{-32,-848},{-32,-1012},{16,-1012},{16,-1020},{28,-1020}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate20.infFloRat, zone20.m_flow_in)
    annotation (Line(points={{2,-1088},{16,-1088},{16,-1077.4},{27.8,-1077.4}},
        color={0,0,127}));
  connect(zone20.TAir, infiltration_DesignFlowRate20.zonAirTem) annotation (
      Line(points={{51,-1066},{58,-1066},{58,-1064},{60,-1064},{60,-1034},{-22,-1034},
          {-22,-1083.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate20.weaBus) annotation (
      Line(
      points={{-120,-10},{-120,-12},{-32,-12},{-32,-168},{-28,-168},{-28,-396},{
          -32,-396},{-32,-420},{-28,-420},{-28,-532},{-32,-532},{-32,-784},{-36,
          -784},{-36,-804},{-32,-804},{-32,-828},{-36,-828},{-36,-848},{-32,-848},
          {-32,-1093.4},{-20.4,-1093.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone20.weaBus) annotation (Line(
      points={{-120,-10},{-120,-12},{-32,-12},{-32,-168},{-28,-168},{-28,-396},{
          20,-396},{20,-456},{24,-456},{24,-528},{20,-528},{20,-612},{-32,-612},
          {-32,-784},{-36,-784},{-36,-804},{-32,-804},{-32,-828},{-36,-828},{-36,
          -848},{-32,-848},{-32,-1056},{16,-1056},{16,-1070},{30,-1070}},
      color={255,204,51},
      thickness=0.5));
  connect(infiltration_DesignFlowRate21.infFloRat, zone21.m_flow_in)
    annotation (Line(points={{2,-1132},{16,-1132},{16,-1121.4},{27.8,-1121.4}},
        color={0,0,127}));
  connect(zone21.TAir, infiltration_DesignFlowRate21.zonAirTem) annotation (
      Line(points={{51,-1110},{58,-1110},{58,-1108},{60,-1108},{60,-1078},{-22,-1078},
          {-22,-1127.8}}, color={0,0,127}));
  connect(building.weaBus, infiltration_DesignFlowRate21.weaBus) annotation (
      Line(
      points={{-120,-10},{-120,-12},{-32,-12},{-32,-168},{-28,-168},{-28,-396},{
          -32,-396},{-32,-420},{-28,-420},{-28,-532},{-32,-532},{-32,-784},{-36,
          -784},{-36,-804},{-32,-804},{-32,-828},{-36,-828},{-36,-848},{-32,-848},
          {-32,-1137.4},{-20.4,-1137.4}},
      color={255,204,51},
      thickness=0.5));
  connect(building.weaBus, zone21.weaBus) annotation (Line(
      points={{-120,-10},{-120,-12},{-32,-12},{-32,-168},{-28,-168},{-28,-396},{
          20,-396},{20,-456},{24,-456},{24,-528},{20,-528},{20,-612},{-32,-612},
          {-32,-784},{-36,-784},{-36,-804},{-32,-804},{-32,-828},{-36,-828},{-36,
          -848},{-32,-848},{-32,-1108},{20,-1108},{20,-1114},{30,-1114}},
      color={255,204,51},
      thickness=0.5));

   connect(zone3.TAir, TAir[3]) annotation (Line(points={{53,-138},{60,-138},{
          60,-78},{96,-78},{96,-60.1481},{120,-60.1481}},
                                        color={0,0,127}));
connect(zone4.TAir, TAir[4]) annotation (Line(points={{55,-196},{60,-196},{60,-78},
          {96,-78},{96,-59.4074},{120,-59.4074}},
                                        color={0,0,127}));
connect(zone5.TAir, TAir[5]) annotation (Line(points={{57,-248},{60,-248},{60,
          -78},{96,-78},{96,-58.6667},{120,-58.6667}},
                                        color={0,0,127}));
connect(zone6.TAir, TAir[6]) annotation (Line(points={{55,-318},{60,-318},{60,
          -78},{96,-78},{96,-57.9259},{120,-57.9259}},
                                        color={0,0,127}));
connect(zone7.TAir, TAir[7]) annotation (Line(points={{49,-390},{60,-390},{60,
          -78},{96,-78},{96,-57.1852},{120,-57.1852}},
                                        color={0,0,127}));
connect(zone8.TAir, TAir[8]) annotation (Line(points={{53,-452},{60,-452},{60,
          -78},{96,-78},{96,-56.4444},{120,-56.4444}},
                                        color={0,0,127}));
connect(zone9.TAir, TAir[9]) annotation (Line(points={{51,-522},{60,-522},{60,-78},
          {96,-78},{96,-55.7037},{120,-55.7037}},
                                        color={0,0,127}));
connect(zone10.TAir, TAir[10]) annotation (Line(points={{53,-572},{60,-572},{60,
          -78},{96,-78},{96,-54.963},{120,-54.963}},
                                        color={0,0,127}));
connect(zone11.TAir, TAir[11]) annotation (Line(points={{51,-632},{60,-632},{60,
          -78},{96,-78},{96,-54.2222},{120,-54.2222}},
                                        color={0,0,127}));
connect(zone12.TAir, TAir[12]) annotation (Line(points={{49,-680},{60,-680},{60,
          -78},{96,-78},{96,-53.4815},{120,-53.4815}},
                                        color={0,0,127}));
connect(zone13.TAir, TAir[13]) annotation (Line(points={{51,-722},{60,-722},{60,
          -78},{96,-78},{96,-52.7407},{120,-52.7407}},
                                        color={0,0,127}));
connect(zone14.TAir, TAir[14]) annotation (Line(points={{47,-774},{60,-774},{60,
          -78},{96,-78},{96,-52},{120,-52}},
                                        color={0,0,127}));
connect(zone15.TAir, TAir[15]) annotation (Line(points={{45,-820},{60,-820},{60,
          -78},{96,-78},{96,-51.2593},{120,-51.2593}},
                                        color={0,0,127}));
connect(zone16.TAir, TAir[16]) annotation (Line(points={{53,-874},{60,-874},{60,
          -78},{96,-78},{96,-50.5185},{120,-50.5185}},
                                        color={0,0,127}));
connect(zone17.TAir, TAir[17]) annotation (Line(points={{49,-918},{60,-918},{60,
          -78},{96,-78},{96,-49.7778},{120,-49.7778}},
                                        color={0,0,127}));
connect(zone18.TAir, TAir[18]) annotation (Line(points={{51,-970},{60,-970},{60,
          -78},{96,-78},{96,-49.037},{120,-49.037}},
                                        color={0,0,127}));
connect(zone19.TAir, TAir[19]) annotation (Line(points={{49,-1016},{60,-1016},{60,
          -78},{96,-78},{96,-48.2963},{120,-48.2963}},
                                        color={0,0,127}));
connect(zone20.TAir, TAir[20]) annotation (Line(points={{51,-1066},{60,-1066},{
          60,-78},{96,-78},{96,-47.5556},{120,-47.5556}},
                                        color={0,0,127}));
connect(zone21.TAir, TAir[21]) annotation (Line(points={{51,-1110},{60,-1110},{
          60,-78},{96,-78},{96,-46.8148},{120,-46.8148}},
                                        color={0,0,127}));

connect(port_a[3], zone3.port_a) annotation (Line(points={{-104,41.9259},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-133.4},{31.6,-133.4}},
                                                              color={0,127,255}));
connect(port_b[3], zone3.port_b) annotation (Line(points={{104,41.9259},{92,
          41.9259},{92,44},{58,44},{58,-46},{64,-46},{64,-133.2},{52.4,-133.2}},
                                                                      color={0,127,
          255}));
connect(port_a[4], zone4.port_a) annotation (Line(points={{-104,42.2963},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-191.4},{33.6,-191.4}},
                                                              color={0,127,255}));
connect(port_b[4], zone4.port_b) annotation (Line(points={{104,42.2963},{92,
          42.2963},{92,44},{58,44},{58,-46},{64,-46},{64,-191.2},{54.4,-191.2}},
                                                                      color={0,127,
          255}));
connect(port_a[5], zone5.port_a) annotation (Line(points={{-104,42.6667},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-243.4},{35.6,-243.4}},
                                                              color={0,127,255}));
connect(port_b[5], zone5.port_b) annotation (Line(points={{104,42.6667},{92,
          42.6667},{92,44},{58,44},{58,-46},{64,-46},{64,-243.2},{56.4,-243.2}},
                                                                      color={0,127,
          255}));
connect(port_a[6], zone6.port_a) annotation (Line(points={{-104,43.037},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-313.4},{33.6,-313.4}},
                                                              color={0,127,255}));
connect(port_b[6], zone6.port_b) annotation (Line(points={{104,43.037},{92,
          43.037},{92,44},{58,44},{58,-46},{64,-46},{64,-313.2},{54.4,-313.2}},
                                                                      color={0,127,
          255}));
connect(port_a[7], zone7.port_a) annotation (Line(points={{-104,43.4074},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-385.4},{27.6,-385.4}},
                                                              color={0,127,255}));
connect(port_b[7], zone7.port_b) annotation (Line(points={{104,43.4074},{92,
          43.4074},{92,44},{58,44},{58,-46},{64,-46},{64,-385.2},{48.4,-385.2}},
                                                                      color={0,127,
          255}));
connect(port_a[8], zone8.port_a) annotation (Line(points={{-104,43.7778},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-447.4},{31.6,-447.4}},
                                                              color={0,127,255}));
connect(port_b[8], zone8.port_b) annotation (Line(points={{104,43.7778},{92,
          43.7778},{92,44},{58,44},{58,-46},{64,-46},{64,-447.2},{52.4,-447.2}},
                                                                      color={0,127,
          255}));
connect(port_a[9], zone9.port_a) annotation (Line(points={{-104,44.1481},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-517.4},{29.6,-517.4}},
                                                              color={0,127,255}));
connect(port_b[9], zone9.port_b) annotation (Line(points={{104,44.1481},{92,
          44.1481},{92,44},{58,44},{58,-46},{64,-46},{64,-517.2},{50.4,-517.2}},
                                                                      color={0,127,
          255}));
connect(port_a[10], zone10.port_a) annotation (Line(points={{-104,44.5185},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-567.4},{31.6,-567.4}},
                                                              color={0,127,255}));
connect(port_b[10], zone10.port_b) annotation (Line(points={{104,44.5185},{92,
          44.5185},{92,44},{58,44},{58,-46},{64,-46},{64,-567.2},{52.4,-567.2}},
                                                                      color={0,127,
          255}));
connect(port_a[11], zone11.port_a) annotation (Line(points={{-104,44.8889},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-627.4},{29.6,-627.4}},
                                                              color={0,127,255}));
connect(port_b[11], zone11.port_b) annotation (Line(points={{104,44.8889},{92,
          44.8889},{92,44},{58,44},{58,-46},{64,-46},{64,-627.2},{50.4,-627.2}},
                                                                      color={0,127,
          255}));
connect(port_a[12], zone12.port_a) annotation (Line(points={{-104,45.2593},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-675.4},{27.6,-675.4}},
                                                              color={0,127,255}));
connect(port_b[12], zone12.port_b) annotation (Line(points={{104,45.2593},{92,
          45.2593},{92,44},{58,44},{58,-46},{64,-46},{64,-675.2},{48.4,-675.2}},
                                                                      color={0,127,
          255}));
connect(port_a[13], zone13.port_a) annotation (Line(points={{-104,45.6296},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-717.4},{29.6,-717.4}},
                                                              color={0,127,255}));
connect(port_b[13], zone13.port_b) annotation (Line(points={{104,45.6296},{92,
          45.6296},{92,44},{58,44},{58,-46},{64,-46},{64,-717.2},{50.4,-717.2}},
                                                                      color={0,127,
          255}));
connect(port_a[14], zone14.port_a) annotation (Line(points={{-104,46},{-104,18},
          {26,18},{26,-12},{20,-12},{20,-769.4},{25.6,-769.4}},
                                                              color={0,127,255}));
connect(port_b[14], zone14.port_b) annotation (Line(points={{104,46},{92,46},{
          92,44},{58,44},{58,-46},{64,-46},{64,-769.2},{46.4,-769.2}},color={0,127,
          255}));
connect(port_a[15], zone15.port_a) annotation (Line(points={{-104,46.3704},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-815.4},{23.6,-815.4}},
                                                              color={0,127,255}));
connect(port_b[15], zone15.port_b) annotation (Line(points={{104,46.3704},{92,
          46.3704},{92,44},{58,44},{58,-46},{64,-46},{64,-815.2},{44.4,-815.2}},
                                                                      color={0,127,
          255}));
connect(port_a[16], zone16.port_a) annotation (Line(points={{-104,46.7407},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-869.4},{31.6,-869.4}},
                                                              color={0,127,255}));
connect(port_b[16], zone16.port_b) annotation (Line(points={{104,46.7407},{92,
          46.7407},{92,44},{58,44},{58,-46},{64,-46},{64,-869.2},{52.4,-869.2}},
                                                                      color={0,127,
          255}));
connect(port_a[17], zone17.port_a) annotation (Line(points={{-104,47.1111},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-913.4},{27.6,-913.4}},
                                                              color={0,127,255}));
connect(port_b[17], zone17.port_b) annotation (Line(points={{104,47.1111},{92,
          47.1111},{92,44},{58,44},{58,-46},{64,-46},{64,-913.2},{48.4,-913.2}},
                                                                      color={0,127,
          255}));
connect(port_a[18], zone18.port_a) annotation (Line(points={{-104,47.4815},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-965.4},{29.6,-965.4}},
                                                              color={0,127,255}));
connect(port_b[18], zone18.port_b) annotation (Line(points={{104,47.4815},{92,
          47.4815},{92,44},{58,44},{58,-46},{64,-46},{64,-965.2},{50.4,-965.2}},
                                                                      color={0,127,
          255}));
connect(port_a[19], zone19.port_a) annotation (Line(points={{-104,47.8519},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-1011.4},{27.6,-1011.4}},
                                                              color={0,127,255}));
connect(port_b[19], zone19.port_b) annotation (Line(points={{104,47.8519},{92,
          47.8519},{92,44},{58,44},{58,-46},{64,-46},{64,-1011.2},{48.4,-1011.2}},
                                                                      color={0,127,
          255}));
connect(port_a[20], zone20.port_a) annotation (Line(points={{-104,48.2222},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-1061.4},{29.6,-1061.4}},
                                                              color={0,127,255}));
connect(port_b[20], zone20.port_b) annotation (Line(points={{104,48.2222},{92,
          48.2222},{92,44},{58,44},{58,-46},{64,-46},{64,-1061.2},{50.4,-1061.2}},
                                                                      color={0,127,
          255}));
connect(port_a[21], zone21.port_a) annotation (Line(points={{-104,48.5926},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-1105.4},{29.6,-1105.4}},
                                                              color={0,127,255}));
connect(port_b[21], zone21.port_b) annotation (Line(points={{104,48.5926},{92,
          48.5926},{92,44},{58,44},{58,-46},{64,-46},{64,-1105.2},{50.4,-1105.2}},
                                                                      color={0,127,
          255}));

  connect(building.weaBus, weaBus) annotation (Line(
      points={{-120,-10},{-120,-12},{-108,-12},{-108,28},{-124,28},{-124,62},{
          -29,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, TOut) annotation (Line(
      points={{-28.905,62.09},{-28.905,64},{2,64},{2,110}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=86400,
      Interval=900,
      __Dymola_Algorithm="Dassl"));
end HilModelIdealLoadVerifyArchived;
