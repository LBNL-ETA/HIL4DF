within hil_flexlab_model.Examples.BaseClasses;
model HilModelIdealLoadVerify
       package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
    package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);

  hil_flexlab_model.Examples.BaseClasses.Zone zone1(zoneName="FlexLab-X3-ZoneA-Core-Zone Thermal Zone")
    annotation (Placement(transformation(extent={{32,-24},{52,-4}})));
  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building
                 building(
    idfName=Modelica.Utilities.Files.loadResource(
        "modelica://hil_flexlab_model/Resources/energyPlusFiles/X1-2021-V8_v2_NoInternalGain_SetpointModify.idf"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://hil_flexlab_model/Resources/weatherdata/US_Berkeley_20210913.mos"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://hil_flexlab_model/Resources/weatherdata/US_Berkeley_20210913.epw"),
    computeWetBulbTemperature=false)
    "Building model"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));

  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate1(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0.008572)
    annotation (Placement(transformation(extent={{-18,-42},{2,-22}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a[12](redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{-114,36},{-94,56}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b[12](redeclare package Medium =
        MediumAir)
    annotation (Placement(transformation(extent={{94,36},{114,56}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone2(zoneName="FlexLab-X3-ZoneA-North-Zone Thermal Zone")
    annotation (Placement(transformation(extent={{32,-94},{52,-74}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate2(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0.01818)
    annotation (Placement(transformation(extent={{-18,-112},{2,-92}})));
  Modelica.Blocks.Interfaces.RealOutput TAir[12] annotation (Placement(
        transformation(extent={{100,-72},{140,-32}}), iconTransformation(extent=
           {{100,-74},{140,-34}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone3(zoneName="FlexLab-X3-ZoneA-South-Zone Thermal Zone")
    annotation (Placement(transformation(extent={{32,-152},{52,-132}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate3(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0.02573)
    annotation (Placement(transformation(extent={{-18,-170},{2,-150}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone4(zoneName="FlexLab-X3-ZoneB-Core-Zone Thermal Zone")
    annotation (Placement(transformation(extent={{34,-210},{54,-190}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate4(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0.008572)
    annotation (Placement(transformation(extent={{-16,-228},{4,-208}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone5(zoneName="FlexLab-X3-ZoneB-North-Zone Thermal Zone")
    annotation (Placement(transformation(extent={{36,-262},{56,-242}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate5(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0.01761)
    annotation (Placement(transformation(extent={{-14,-280},{6,-260}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone6(zoneName="FlexLab-X3-ZoneB-South-Zone Thermal Zone")
    annotation (Placement(transformation(extent={{34,-332},{54,-312}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate6(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0.02573)
    annotation (Placement(transformation(extent={{-16,-350},{4,-330}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone7(zoneName="FlexLab-X3-ElecRoom-ZoneA Thermal Zone")
    annotation (Placement(transformation(extent={{28,-404},{48,-384}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate7(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0)
    annotation (Placement(transformation(extent={{-22,-422},{-2,-402}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone8(zoneName="FlexLab-X3-ElecRoom-ZoneB Thermal Zone")
    annotation (Placement(transformation(extent={{32,-466},{52,-446}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate8(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0)
    annotation (Placement(transformation(extent={{-18,-484},{2,-464}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone9(zoneName="FlexLab-X3-MechRoom-ZoneA Thermal Zone")
    annotation (Placement(transformation(extent={{30,-538},{50,-518}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate9(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0)
    annotation (Placement(transformation(extent={{-20,-554},{0,-534}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone10(zoneName="FlexLab-X3-MechRoom-ZoneB Thermal Zone")
    annotation (Placement(transformation(extent={{32,-586},{52,-566}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate10(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0)
    annotation (Placement(transformation(extent={{-18,-604},{2,-584}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone11(zoneName="FlexLab-X3-PlnmA Thermal Zone")
    annotation (Placement(transformation(extent={{30,-646},{50,-626}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate11(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0.08982)
    annotation (Placement(transformation(extent={{-20,-664},{0,-644}})));
  hil_flexlab_model.Examples.BaseClasses.Zone zone12(zoneName="FlexLab-X3-PlnmB Thermal Zone")
    annotation (Placement(transformation(extent={{28,-694},{48,-674}})));
  hil_flexlab_model.Examples.BaseClasses.Infiltration_DesignFlowRate infiltration_DesignFlowRate12(
    A=0,
    B=0,
    C=0.224,
    D=0,
    schFra=0.25,
    desFloRat=0.08951)
    annotation (Placement(transformation(extent={{-22,-712},{-2,-692}})));

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
  connect(port_a[1], zone1.port_a) annotation (Line(points={{-104,41.4167},{
          -104,18},{26,18},{26,-5.4},{31.6,-5.4}},
                                          color={0,127,255}));
  connect(port_b[1], zone1.port_b) annotation (Line(points={{104,41.4167},{58,
          41.4167},{58,-5.2},{52.4,-5.2}},
                                  color={0,127,255}));
  connect(port_a[2], zone2.port_a) annotation (Line(points={{-104,42.25},{-104,18},
          {26,18},{26,-12},{20,-12},{20,-75.4},{31.6,-75.4}}, color={0,127,255}));
  connect(port_b[2], zone2.port_b) annotation (Line(points={{104,42.25},{92,42.25},
          {92,44},{58,44},{58,-46},{64,-46},{64,-75.2},{52.4,-75.2}}, color={0,127,
          255}));
  connect(zone1.TAir, TAir[1]) annotation (Line(points={{53,-10},{96,-10},{96,
          -61.1667},{120,-61.1667}},
                      color={0,0,127}));
  connect(zone2.TAir, TAir[2]) annotation (Line(points={{53,-80},{60,-80},{60,-78},
          {96,-78},{96,-59.5},{120,-59.5}},
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
      Line(points={{2,-544},{16,-544},{16,-535.4},{27.8,-535.4}},
                                                               color={0,0,127}));
  connect(zone9.TAir,infiltration_DesignFlowRate9. zonAirTem) annotation (Line(
        points={{51,-524},{58,-524},{58,-520},{60,-520},{60,-490},{-22,-490},{-22,
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
          -22,-394},{18,-394},{18,-456},{22,-456},{22,-528},{30,-528}},
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

   connect(zone3.TAir, TAir[3]) annotation (Line(points={{53,-138},{60,-138},{
          60,-78},{96,-78},{96,-57.8333},{120,-57.8333}},
                                        color={0,0,127}));
connect(zone4.TAir, TAir[4]) annotation (Line(points={{55,-196},{60,-196},{60,
          -78},{96,-78},{96,-56.1667},{120,-56.1667}},
                                        color={0,0,127}));
connect(zone5.TAir, TAir[5]) annotation (Line(points={{57,-248},{60,-248},{60,-78},
          {96,-78},{96,-54.5},{120,-54.5}},
                                        color={0,0,127}));
connect(zone6.TAir, TAir[6]) annotation (Line(points={{55,-318},{60,-318},{60,
          -78},{96,-78},{96,-52.8333},{120,-52.8333}},
                                        color={0,0,127}));
connect(zone7.TAir, TAir[7]) annotation (Line(points={{49,-390},{60,-390},{60,
          -78},{96,-78},{96,-51.1667},{120,-51.1667}},
                                        color={0,0,127}));
connect(zone8.TAir, TAir[8]) annotation (Line(points={{53,-452},{60,-452},{60,-78},
          {96,-78},{96,-49.5},{120,-49.5}},
                                        color={0,0,127}));
connect(zone9.TAir, TAir[9]) annotation (Line(points={{51,-524},{60,-524},{60,
          -78},{96,-78},{96,-47.8333},{120,-47.8333}},
                                        color={0,0,127}));
connect(zone10.TAir, TAir[10]) annotation (Line(points={{53,-572},{60,-572},{60,
          -78},{96,-78},{96,-46.1667},{120,-46.1667}},
                                        color={0,0,127}));
connect(zone11.TAir, TAir[11]) annotation (Line(points={{51,-632},{60,-632},{60,
          -78},{96,-78},{96,-44.5},{120,-44.5}},
                                        color={0,0,127}));
connect(zone12.TAir, TAir[12]) annotation (Line(points={{49,-680},{60,-680},{60,
          -78},{96,-78},{96,-42.8333},{120,-42.8333}},
                                        color={0,0,127}));

connect(port_a[3], zone3.port_a) annotation (Line(points={{-104,43.0833},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-133.4},{31.6,-133.4}},
                                                              color={0,127,255}));
connect(port_b[3], zone3.port_b) annotation (Line(points={{104,43.0833},{92,
          43.0833},{92,44},{58,44},{58,-46},{64,-46},{64,-133.2},{52.4,-133.2}},
                                                                      color={0,127,
          255}));
connect(port_a[4], zone4.port_a) annotation (Line(points={{-104,43.9167},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-191.4},{33.6,-191.4}},
                                                              color={0,127,255}));
connect(port_b[4], zone4.port_b) annotation (Line(points={{104,43.9167},{92,
          43.9167},{92,44},{58,44},{58,-46},{64,-46},{64,-191.2},{54.4,-191.2}},
                                                                      color={0,127,
          255}));
connect(port_a[5], zone5.port_a) annotation (Line(points={{-104,44.75},{-104,18},
          {26,18},{26,-12},{20,-12},{20,-243.4},{35.6,-243.4}},
                                                              color={0,127,255}));
connect(port_b[5], zone5.port_b) annotation (Line(points={{104,44.75},{92,44.75},
          {92,44},{58,44},{58,-46},{64,-46},{64,-243.2},{56.4,-243.2}},
                                                                      color={0,127,
          255}));
connect(port_a[6], zone6.port_a) annotation (Line(points={{-104,45.5833},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-313.4},{33.6,-313.4}},
                                                              color={0,127,255}));
connect(port_b[6], zone6.port_b) annotation (Line(points={{104,45.5833},{92,
          45.5833},{92,44},{58,44},{58,-46},{64,-46},{64,-313.2},{54.4,-313.2}},
                                                                      color={0,127,
          255}));
connect(port_a[7], zone7.port_a) annotation (Line(points={{-104,46.4167},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-385.4},{27.6,-385.4}},
                                                              color={0,127,255}));
connect(port_b[7], zone7.port_b) annotation (Line(points={{104,46.4167},{92,
          46.4167},{92,44},{58,44},{58,-46},{64,-46},{64,-385.2},{48.4,-385.2}},
                                                                      color={0,127,
          255}));
connect(port_a[8], zone8.port_a) annotation (Line(points={{-104,47.25},{-104,18},
          {26,18},{26,-12},{20,-12},{20,-447.4},{31.6,-447.4}},
                                                              color={0,127,255}));
connect(port_b[8], zone8.port_b) annotation (Line(points={{104,47.25},{92,47.25},
          {92,44},{58,44},{58,-46},{64,-46},{64,-447.2},{52.4,-447.2}},
                                                                      color={0,127,
          255}));
connect(port_a[9], zone9.port_a) annotation (Line(points={{-104,48.0833},{-104,
          18},{26,18},{26,-12},{20,-12},{20,-519.4},{29.6,-519.4}},
                                                              color={0,127,255}));
connect(port_b[9], zone9.port_b) annotation (Line(points={{104,48.0833},{92,
          48.0833},{92,44},{58,44},{58,-46},{64,-46},{64,-519.2},{50.4,-519.2}},
                                                                      color={0,127,
          255}));
connect(port_a[10], zone10.port_a) annotation (Line(points={{-104,48.9167},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-567.4},{31.6,-567.4}},
                                                              color={0,127,255}));
connect(port_b[10], zone10.port_b) annotation (Line(points={{104,48.9167},{92,
          48.9167},{92,44},{58,44},{58,-46},{64,-46},{64,-567.2},{52.4,-567.2}},
                                                                      color={0,127,
          255}));
connect(port_a[11], zone11.port_a) annotation (Line(points={{-104,49.75},{-104,18},
          {26,18},{26,-12},{20,-12},{20,-627.4},{29.6,-627.4}},
                                                              color={0,127,255}));
connect(port_b[11], zone11.port_b) annotation (Line(points={{104,49.75},{92,49.75},
          {92,44},{58,44},{58,-46},{64,-46},{64,-627.2},{50.4,-627.2}},
                                                                      color={0,127,
          255}));
connect(port_a[12], zone12.port_a) annotation (Line(points={{-104,50.5833},{
          -104,18},{26,18},{26,-12},{20,-12},{20,-675.4},{27.6,-675.4}},
                                                              color={0,127,255}));
connect(port_b[12], zone12.port_b) annotation (Line(points={{104,50.5833},{92,
          50.5833},{92,44},{58,44},{58,-46},{64,-46},{64,-675.2},{48.4,-675.2}},
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
end HilModelIdealLoadVerify;
