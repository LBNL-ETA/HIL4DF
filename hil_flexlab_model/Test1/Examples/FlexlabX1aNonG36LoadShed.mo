within hil_flexlab_model.Test1.Examples;
model FlexlabX1aNonG36LoadShed
  "DR mode - Variable air volume flow system with terminal reheat and five thermal zones at Flexlab X1 cell"

  extends Modelica.Icons.Example;
  extends
    hil_flexlab_model.Test1.BaseClasses1.PartialFlexlab_Summer_2021_Test_NonG36(
    occSch(
      occupancy={0,86399},
      firstEntryOccupied=true,
      period=86400),
    flo(
      nor(T_start=294.96),
      cor(T_start=294.96),
      sou(T_start=294.96),
      idfName=Modelica.Utilities.Files.loadResource(
          "modelica://hil_flexlab_model/Resources/energyPlusFiles/X1-2021-V8_v2_NoInternalGain.idf"),
      epwName=Modelica.Utilities.Files.loadResource(
          "modelica://hil_flexlab_model/Resources/weatherdata/US_Berkeley_20210913.epw"),
      weaName=Modelica.Utilities.Files.loadResource(
          "modelica://hil_flexlab_model/Resources/weatherdata/US_Berkeley_20210913.mos"),
      ele(T_start=294.96),
      clo(T_start=294.96),
      ple(T_start=294.96)),
    weaDat(filNam=Modelica.Utilities.Files.loadResource(
          "modelica://hil_flexlab_model/Resources/weatherdata/US_Berkeley_20210913.mos")),
    souCoo(T=281.48),
    fanSup(addPowerToMedium=false),
    nor(vav(dpDamper_nominal=0.25*240)),
    cor(vav(dpDamper_nominal=0.25*240)),
    sou(vav(dpDamper_nominal=0.25*240)));

                              //,
    //  ple(T_start=294.96)));
//  extends BaseClasses.PartialOpenLoopX1aV1(min(nin=3),
//      ave(nin=3));

  parameter Modelica.Units.SI.VolumeFlowRate VPriSysMax_flow=m_flow_nominal/1.2
    "Maximum expected system primary airflow rate at design stage";
  parameter Modelica.Units.SI.VolumeFlowRate minZonPriFlo[numZon]={
      mCor_flow_nominal,mSou_flow_nominal,mNor_flow_nominal}/1.2
    "Minimum expected zone primary flow rate";
  parameter Modelica.Units.SI.Time samplePeriod=180
    "Sample period of component, set to the same value as the trim and respond that process yPreSetReq";
  parameter Modelica.Units.SI.PressureDifference dpDisRetMax=40
    "Maximum return fan discharge static pressure setpoint";

  Plants1.Controls.Controller conVAVNor(
    V_flow_nominal=mNor_flow_nominal/1.2,
    AFlo=AFloNor,
    final samplePeriod=samplePeriod,
    TiCoo=60,
    kHea=0.5,
    TiHea=60,
    TiVal=60,
    TiDam=60,
    VDisCooSetMax_flow=mNor_flow_nominal/1.2,
    VDisSetMin_flow=0.0385/1.2,
    VDisHeaSetMax_flow=0.1274/1.2,
    VDisConMin_flow=0.0385/1.2,
    dTDisZonSetMax=17,
    TDisMin=285.95) "Controller for terminal unit north zone"
    annotation (Placement(transformation(extent={{654,4},{674,24}})));
  Plants1.Controls.Controller conVAVCor(
    V_flow_nominal=mCor_flow_nominal/1.2,
    AFlo=AFloCor,
    final samplePeriod=samplePeriod,
    TiCoo=60,
    kHea=0.5,
    TiHea=60,
    TiVal=60,
    TiDam=60,
    VDisCooSetMax_flow=mCor_flow_nominal/1.2,
    VDisSetMin_flow=0.0385/1.2,
    VDisHeaSetMax_flow=0.1274/1.2,
    VDisConMin_flow=0.0385/1.2,
    dTDisZonSetMax=17,
    TDisMin=285.95) "Controller for terminal unit mid zone"
    annotation (Placement(transformation(extent={{778,104},{798,124}})));
  Plants1.Controls.Controller conVAVSou(
    V_flow_nominal=mSou_flow_nominal/1.2,
    AFlo=AFloSou,
    final samplePeriod=samplePeriod,
    TiCoo=60,
    kHea=0.5,
    TiHea=60,
    TiVal=60,
    TiDam=60,
    VDisCooSetMax_flow=mSou_flow_nominal/1.2,
    VDisSetMin_flow=0.0595/1.2,
    VDisHeaSetMax_flow=0.1274/1.2,
    VDisConMin_flow=0.0595/1.2,
    dTDisZonSetMax=17,
    TDisMin=285.95) "Controller for terminal unit south zone"
    annotation (Placement(transformation(extent={{1020,32},{1040,52}})));
  Modelica.Blocks.Routing.Multiplex3 TDis "Discharge air temperatures"
    annotation (Placement(transformation(extent={{110,276},{130,296}})));
  Modelica.Blocks.Routing.Multiplex3 VDis_flow
    "Air flow rate at the terminal boxes"
    annotation (Placement(transformation(extent={{176,242},{196,262}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum TZonResReq(nin=3)
    "Number of zone temperature requests"
    annotation (Placement(transformation(extent={{298,288},{318,308}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum PZonResReq(nin=3)
    "Number of zone pressure requests"
    annotation (Placement(transformation(extent={{300,254},{320,274}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiFreSta
    "Switch for freeze stat"
    annotation (Placement(transformation(extent={{60,-202},{80,-182}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant freStaSetPoi1(k=273.15
         + 3) "Freeze stat for heating coil"
    annotation (Placement(transformation(extent={{-40,-96},{-20,-76}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFreHeaCoi(final k=1)
    "Flow rate signal for heating coil when freeze stat is on"
    annotation (Placement(transformation(extent={{0,-192},{20,-172}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(final nout=
        numZon) "Replicate real input"
    annotation (Placement(transformation(extent={{-144,350},{-124,370}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(final nout=
        numZon) "Replicate boolean input"
    annotation (Placement(transformation(extent={{-146,316},{-126,336}})));
  BaseClasses1.ModeAndSetPoints TZonSet[numZon](
    final TZonHeaOn=fill(273.15 + 21.1, numZon),
    final TZonHeaOff=fill(THeaOff, numZon),
    TZonCooOn=fill(273.15 + 23.3, numZon),
    final TZonCooOff=fill(TCooOff, numZon)) "Zone setpoint temperature"
    annotation (Placement(transformation(extent={{-32,322},{-12,342}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Zone
    zonOutAirSet[numZon](
    final AFlo=AFlo,
    final have_occSen=fill(false, numZon),
    final have_winSen=fill(false, numZon),
    final desZonPop={0.05*AFlo[i] for i in 1:numZon},
    final minZonPriFlo=minZonPriFlo)
    "Zone level calculation of the minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{228,382},{248,402}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(final nout=
        numZon) "Replicate design uncorrected minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{480,478},{500,498}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep1(final nout=
       numZon) "Replicate signal whether the outdoor airflow is required"
    annotation (Placement(transformation(extent={{480,438},{500,458}})));
  Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.SumZone
    zonToSys(final numZon=numZon) "Sum up zone calculation output"
    annotation (Placement(transformation(extent={{274,420},{294,440}})));
  hil_flexlab_model.Test1.BaseClasses1.Controls.Controller_G36 conAHU(
    TSupSetUnocc=291.45,
    samplePeriod=samplePeriod,
    retDamPhyPosMax=0.7,
    outDamPhyPosMin=0.3,
    pIniSet=250,
    pMinSet=250,
    final pMaxSet=250,
    pDelTim=300,
    pNumIgnReq=0,
    pTriAmo=0,
    pResAmo=0,
    pMaxRes=0,
    final yFanMin=yFanMin,
    final VPriSysMax_flow=VPriSysMax_flow,
    final peaSysPop=2*sum({0.05*AFlo[i] for i in 1:numZon}),
    TSupSetMin=284.85,
    TSupSetMax=291.45,
    TSupSetDes=284.85,
    TOutMin=363.15,
    TOutMax=368.15,
    iniSetSupTem=284.85,
    maxSetSupTem=284.85,
    minSetSupTem=284.85,
    delTimSupTem=300,
    numIgnReqSupTem=0,
    triAmoSupTem=0,
    resAmoSupTem=0,
    maxResSupTem=0,
    TiTSup=60)      "AHU controller"
    annotation (Placement(transformation(extent={{360,418},{440,546}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{-124,446},{-144,466}})));
  Modelica.Blocks.Sources.CombiTimeTable cooSetDR(
    table=[0,3.3667; 5,3.3667; 5,2.2556; 6,2.2556; 6,1.7; 7,1.7; 7,0.0333; 14,
        0.0333; 14,2.2556; 18,2.2556; 18,0.0333; 22,0.0333; 22,3.3667; 24,
        3.3667],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600) "cooling schedule for demand response"
    annotation (Placement(transformation(extent={{-148,400},{-128,420}})));
  Modelica.Blocks.Sources.CombiTimeTable heaSetDR(
    table=[0,-5.5444; 5,-5.5444; 5,-3.3222; 6,-3.3222; 6,-1.6556; 7,-1.6556; 7,
        0.0111; 22,0.0111; 22,-5.5444; 24,-5.5444],
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=3600) "heating schedule for demand response"
    annotation (Placement(transformation(extent={{-142,222},{-122,242}})));
  Modelica.Blocks.Math.Add add1
    annotation (Placement(transformation(extent={{-122,270},{-142,290}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant ecoHigCut(k=273.15 + 17.78)
    "economizer high cut off temp"
    annotation (Placement(transformation(extent={{66,472},{86,492}})));
  Modelica.Blocks.Logical.Greater greater_unocc
    annotation (Placement(transformation(extent={{-278,448},{-298,468}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant ecoHigCut1(k=11)
    "economizer high cut off temp"
    annotation (Placement(transformation(extent={{-230,396},{-254,420}})));
  Modelica.Blocks.Math.Add add2(k1=-1, k2=+1)
    annotation (Placement(transformation(extent={{-204,444},{-224,464}})));
  Plants1.Controls.ExhaustDamperPositionBlock exhaustDamperPositionBlock
    annotation (Placement(transformation(extent={{-88,-92},{-68,-72}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=false)
    annotation (Placement(transformation(extent={{-292,494},{-272,514}})));
  Modelica.Blocks.Sources.IntegerConstant integerConstant[numZon](k=0)
    annotation (Placement(transformation(extent={{-206,538},{-186,558}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1
                                                         [numZon](k=false)
    annotation (Placement(transformation(extent={{-210,492},{-190,512}})));
  BaseClasses1.Eco_Enable_OAT                                         eco_Enable_OAT
    annotation (Placement(transformation(extent={{-94,-122},{-74,-102}})));
equation
  connect(fanSup.port_b, dpDisSupFan.port_a) annotation (Line(
      points={{320,-40},{320,0},{320,-10},{320,-10}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(TRooAir.y2[1], conVAVCor.TZon) annotation (Line(
      points={{511,170},{766,170},{766,114},{776,114}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSupNor.T, conVAVNor.TDis) annotation (Line(points={{695,92},{638,92},
          {638,8},{652,8}},   color={0,0,127}));
  connect(TSupCor.T, conVAVCor.TDis) annotation (Line(points={{823,94},{762,94},
          {762,108},{776,108}},
                              color={0,0,127}));
  connect(TSupSou.T, conVAVSou.TDis) annotation (Line(points={{1069,90},{1002,90},
          {1002,36},{1018,36}},     color={0,0,127}));
  connect(conVAVNor.yDam,nor.yVAV)  annotation (Line(points={{676,20},{688,20},
          {688,48},{692,48}},color={0,0,127}));
  connect(conVAVNor.yVal,nor.yVal)  annotation (Line(points={{676,15},{684,15},
          {684,32},{692,32}},   color={0,0,127}));
  connect(conVAVCor.yVal, cor.yVal) annotation (Line(points={{800,115},{808,115},
          {808,36},{820,36}},   color={0,0,127}));
  connect(conVAVCor.yDam, cor.yVAV) annotation (Line(points={{800,120},{836,120},
          {836,52},{820,52}}, color={0,0,127}));
  connect(conVAVSou.yDam, sou.yVAV) annotation (Line(points={{1042,48},{1048,48},
          {1048,44},{1066,44}},       color={0,0,127}));
  connect(conVAVSou.yVal, sou.yVal) annotation (Line(points={{1042,43},{1042,40},
          {1056,40},{1056,28},{1066,28}},
                                      color={0,0,127}));

  connect(conVAVNor.yZonTemResReq, TZonResReq.u[1]) annotation (Line(points={{676,10},
          {750,10},{750,224},{270,224},{270,295.667},{296,295.667}},     color=
          {255,127,0}));
  connect(conVAVCor.yZonTemResReq, TZonResReq.u[2]) annotation (Line(points={{800,110},
          {808,110},{808,240},{274,240},{274,298},{296,298}},        color={255,
          127,0}));
  connect(conVAVSou.yZonTemResReq, TZonResReq.u[3]) annotation (Line(points={{1042,38},
          {1054,38},{1054,216},{278,216},{278,300.333},{296,300.333}},
        color={255,127,0}));
  connect(conVAVNor.yZonPreResReq, PZonResReq.u[1]) annotation (Line(points={{676,6},
          {758,6},{758,236},{284,236},{284,261.667},{298,261.667}},      color=
          {255,127,0}));
  connect(conVAVCor.yZonPreResReq, PZonResReq.u[2]) annotation (Line(points={{800,106},
          {814,106},{814,246},{288,246},{288,264},{298,264}},        color={255,
          127,0}));
  connect(conVAVSou.yZonPreResReq, PZonResReq.u[3]) annotation (Line(points={{1042,34},
          {1060,34},{1060,224},{292,224},{292,266.333},{298,266.333}},
        color={255,127,0}));
  connect(VSupNor_flow.V_flow,conVAVNor. VDis_flow) annotation (Line(points={{695,130},
          {632,130},{632,12},{652,12}},      color={0,0,127}));
  connect(VSupCor_flow.V_flow, conVAVCor.VDis_flow) annotation (Line(points={{823,132},
          {764,132},{764,112},{776,112}},        color={0,0,127}));
  connect(VSupSou_flow.V_flow, conVAVSou.VDis_flow) annotation (Line(points={{1069,
          128},{1008,128},{1008,40},{1018,40}},      color={0,0,127}));
  connect(TSup.T,conVAVNor. TSupAHU) annotation (Line(points={{340,-29},{340,
          -20},{546,-20},{546,6},{652,6}},
                                        color={0,0,127}));
  connect(TSup.T, conVAVCor.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {764,-20},{764,106},{776,106}},    color={0,0,127}));
  connect(TSup.T, conVAVSou.TSupAHU) annotation (Line(points={{340,-29},{340,-20},
          {678,-20},{678,34},{1018,34}},   color={0,0,127}));
  connect(swiFreSta.y, gaiHeaCoi.u) annotation (Line(points={{82,-192},{88,-192},
          {88,-210},{98,-210}}, color={0,0,127}));
  connect(freSta.y, swiFreSta.u2) annotation (Line(points={{22,-92},{40,-92},{40,
          -192},{58,-192}},    color={255,0,255}));
  connect(yFreHeaCoi.y, swiFreSta.u1) annotation (Line(points={{22,-182},{40,-182},
          {40,-184},{58,-184}}, color={0,0,127}));
  connect(occSch.tNexNonOcc, reaRep.u) annotation (Line(points={{-297,-210},{-236,
          -210},{-236,360},{-146,360}}, color={0,0,127}));
  connect(occSch.occupied, booRep.u) annotation (Line(points={{-297,-216},{-232,
          -216},{-232,326},{-148,326}}, color={255,0,255}));
  connect(reaRep.y, TZonSet.tNexOcc) annotation (Line(points={{-122,360},{-78,360},
          {-78,341},{-34,341}}, color={0,0,127}));
  connect(booRep.y, TZonSet.uOcc) annotation (Line(points={{-124,326},{-80,326},
          {-80,338.025},{-34,338.025}}, color={255,0,255}));
  connect(conVAVSou.uOpeMod, TZonSet[1].yOpeMod) annotation (Line(points={{1018,32},
          {502,32},{502,325},{-10,325}},       color={255,127,0}));
  connect(conVAVCor.uOpeMod, TZonSet[1].yOpeMod) annotation (Line(points={{776,104},
          {34,104},{34,325},{-10,325}},color={255,127,0}));
  connect(conVAVNor.uOpeMod, TZonSet[1].yOpeMod) annotation (Line(points={{652,4},
          {54,4},{54,325},{-10,325}},  color={255,127,0}));
  connect(flo.TRooAir, TZonSet.TZon) annotation (Line(points={{1114.83,473},{
          1096,473},{1096,604},{-54,604},{-54,335},{-34,335}},    color={0,0,127}));
  connect(TDis.y, zonOutAirSet.TDis) annotation (Line(points={{131,286},{226,
          286},{226,389}},      color={0,0,127}));
  connect(VDis_flow.y, zonOutAirSet.VDis_flow) annotation (Line(points={{197,252},
          {226,252},{226,386}},           color={0,0,127}));
  connect(zonOutAirSet.VUncOut_flow_nominal, reaRep1.y) annotation (Line(points={{226,383},
          {216,383},{216,408},{520,408},{520,488},{502,488}},           color={0,
          0,127}));
  connect(zonOutAirSet.uReqOutAir, booRep1.y) annotation (Line(points={{226,395},
          {208,395},{208,376},{232,376},{232,368},{528,368},{528,448},{502,448}},
                                                              color={255,0,255}));
  connect(flo.TRooAir, zonOutAirSet.TZon) annotation (Line(points={{1114.83,473},
          {1096,473},{1096,608},{-56,608},{-56,392},{226,392}},    color={0,0,127}));
  connect(zonOutAirSet.yDesZonPeaOcc, zonToSys.uDesZonPeaOcc) annotation (Line(
        points={{250,401},{250,416},{272,416},{272,438}}, color={0,0,127}));
  connect(zonOutAirSet.VDesPopBreZon_flow, zonToSys.VDesPopBreZon_flow)
    annotation (Line(points={{250,398},{250,416},{272,416},{272,436}},
                                                   color={0,0,127}));
  connect(zonOutAirSet.VDesAreBreZon_flow, zonToSys.VDesAreBreZon_flow)
    annotation (Line(points={{250,395},{250,408},{272,408},{272,434}}, color={0,
          0,127}));
  connect(zonOutAirSet.yDesPriOutAirFra, zonToSys.uDesPriOutAirFra) annotation (
     Line(points={{250,392},{250,408},{272,408},{272,428}}, color={0,0,127}));
  connect(zonOutAirSet.VUncOutAir_flow, zonToSys.VUncOutAir_flow) annotation (
      Line(points={{250,389},{256,389},{256,426},{272,426}}, color={0,0,127}));
  connect(zonOutAirSet.yPriOutAirFra, zonToSys.uPriOutAirFra)
    annotation (Line(points={{250,386},{250,400},{272,400},{272,424}},
                                                   color={0,0,127}));
  connect(zonOutAirSet.VPriAir_flow, zonToSys.VPriAir_flow) annotation (Line(
        points={{250,383},{250,400},{272,400},{272,422}}, color={0,0,127}));
  connect(zonToSys.ySumDesZonPop, conAHU.sumDesZonPop) annotation (Line(points={{296,439},
          {296,522},{356,522},{356,521.529}},           color={0,0,127}));
  connect(zonToSys.VSumDesPopBreZon_flow, conAHU.VSumDesPopBreZon_flow)
    annotation (Line(points={{296,436},{298,436},{298,515.882},{356,515.882}},
        color={0,0,127}));
  connect(zonToSys.VSumDesAreBreZon_flow, conAHU.VSumDesAreBreZon_flow)
    annotation (Line(points={{296,433},{300,433},{300,510.235},{356,510.235}},
        color={0,0,127}));
  connect(zonToSys.yDesSysVenEff, conAHU.uDesSysVenEff) annotation (Line(points={{296,430},
          {302,430},{302,504.588},{356,504.588}},           color={0,0,127}));
  connect(zonToSys.VSumUncOutAir_flow, conAHU.VSumUncOutAir_flow) annotation (
      Line(points={{296,427},{303,427},{303,498.941},{356,498.941}}, color={0,0,
          127}));
  connect(zonToSys.uOutAirFra_max, conAHU.uOutAirFra_max) annotation (Line(
        points={{296,424},{302,424},{302,487.647},{356,487.647}}, color={0,0,127}));
  connect(zonToSys.VSumSysPriAir_flow, conAHU.VSumSysPriAir_flow) annotation (
      Line(points={{296,421},{304,421},{304,493.294},{356,493.294}}, color={0,0,
          127}));
  connect(TOut.y, conAHU.TOut) annotation (Line(points={{-279,180},{18.5,180},{
          18.5,538.471},{356,538.471}},
                                   color={0,0,127}));
  connect(dpDisSupFan.p_rel, conAHU.ducStaPre) annotation (Line(points={{311,0},
          {140,0},{140,532.824},{356,532.824}}, color={0,0,127}));
  connect(TSup.T, conAHU.TSup) annotation (Line(points={{340,-29},{198,-29},{
          198,472},{356,472},{356,476.353}},
                                         color={0,0,127}));
  connect(VOut1.V_flow, conAHU.VOut_flow) annotation (Line(points={{-61,-20.9},
          {-61,218},{-18,218},{-18,454},{356,454},{356,453.765}},color={0,0,127}));
  connect(TMix.T, conAHU.TMix) annotation (Line(points={{40,-29},{40,446.235},{
          356,446.235}},
                     color={0,0,127}));
  connect(TZonSet[1].yOpeMod, conAHU.uOpeMod) annotation (Line(points={{-10,325},
          {158,325},{158,438.706},{356,438.706}}, color={255,127,0}));
  connect(TZonResReq.y, conAHU.uZonTemResReq) annotation (Line(points={{320,298},
          {322,298},{322,433.059},{356,433.059}}, color={255,127,0}));
  connect(PZonResReq.y, conAHU.uZonPreResReq) annotation (Line(points={{322,264},
          {324,264},{324,427.412},{356,427.412}}, color={255,127,0}));
  connect(conAHU.ySupFanSpe, fanSup.y) annotation (Line(points={{444,530.941},{
          472,530.941},{472,-12},{310,-12},{310,-28}},
                                                   color={0,0,127}));
  connect(conAHU.VDesUncOutAir_flow, reaRep1.u) annotation (Line(points={{444,
          508.353},{447,508.353},{447,488},{478,488}},
                                              color={0,0,127}));
  connect(conAHU.yReqOutAir, booRep1.u) annotation (Line(points={{444,474.471},
          {444,448},{478,448}},color={255,0,255}));
  connect(conAHU.yAveOutAirFraPlu, zonToSys.yAveOutAirFraPlu) annotation (Line(
        points={{444,497.059},{430,497.059},{430,414},{266,414},{266,432},{272,
          432}},
        color={0,0,127}));
  connect(conAHU.yHea, swiFreSta.u3) annotation (Line(points={{444,463.176},{
          444,-240},{40,-240},{40,-200},{58,-200}},
                                                color={0,0,127}));
  connect(conAHU.yCoo, gaiCooCoi.u) annotation (Line(points={{444,451.882},{460,
          451.882},{460,-272},{80,-272},{80,-248},{98,-248}},
                                                     color={0,0,127}));
  connect(conAHU.yRetDamPos, eco.yRet) annotation (Line(points={{444,440.588},{
          444,442},{422,442},{422,202},{-16.8,202},{-16.8,-34}},
                                                             color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, conAHU.TZonCooSet) annotation (Line(points={{-10,339},
          {174,339},{174,544.118},{356,544.118}},      color={0,0,127}));
  connect(TZonSet[1].TZonHeaSet, conAHU.TZonHeaSet) annotation (Line(points={{-10,332},
          {174,332},{174,549.765},{356,549.765}},      color={0,0,127}));
  connect(conVAVNor.yDam_actual, nor.y_actual) annotation (Line(points={{652,10},
          {642,10},{642,72},{746,72},{746,56},{738,56}}, color={0,0,127}));
  connect(conVAVCor.yDam_actual, cor.y_actual) annotation (Line(points={{776,110},
          {770,110},{770,74},{924,74},{924,60},{866,60}},color={0,0,127}));
  connect(conVAVSou.yDam_actual, sou.y_actual) annotation (Line(points={{1018,38},
          {1012,38},{1012,68},{1126,68},{1126,52},{1112,52}}, color={0,0,127}));
  connect(cooSetDR.y[1], add.u2) annotation (Line(points={{-127,410},{-92,410},
          {-92,450},{-122,450}}, color={0,0,127}));
  connect(TZonSet[1].TZonCooSet, add.u1) annotation (Line(points={{-10,339},{8,
          339},{8,462},{-122,462}}, color={0,0,127}));
  connect(add.y, conVAVSou.TZonCooSet) annotation (Line(points={{-145,456},{
          -162,456},{-162,50},{1018,50}}, color={0,0,127}));
  connect(add.y, conVAVNor.TZonCooSet) annotation (Line(points={{-145,456},{
          -162,456},{-162,22},{652,22}}, color={0,0,127}));
  connect(add.y, conVAVCor.TZonCooSet) annotation (Line(points={{-145,456},{-162,
          456},{-162,122},{776,122}},      color={0,0,127}));
  connect(VSupCor_flow.V_flow, VDis_flow.u2[1]) annotation (Line(points={{823,132},
          {154,132},{154,252},{174,252}},      color={0,0,127}));
  connect(TSupCor.T, TDis.u2[1]) annotation (Line(points={{823,94},{80,94},{80,
          286},{108,286}}, color={0,0,127}));
  connect(conVAVSou.TZon, TRooAir.y1[1]) annotation (Line(points={{1018,42},{980,
          42},{980,177},{511,177}},     color={0,0,127}));
  connect(conVAVNor.TZon, TRooAir.y3[1]) annotation (Line(points={{652,14},{646,
          14},{646,163},{511,163}}, color={0,0,127}));
  connect(TSupSou.T, TDis.u1[1]) annotation (Line(points={{1069,90},{72,90},{72,
          293},{108,293}}, color={0,0,127}));
  connect(TSupNor.T, TDis.u3[1]) annotation (Line(points={{695,92},{88,92},{88,
          279},{108,279}},
                      color={0,0,127}));
  connect(VSupSou_flow.V_flow, VDis_flow.u1[1]) annotation (Line(points={{1069,128},
          {148,128},{148,259},{174,259}}, color={0,0,127}));
  connect(VSupNor_flow.V_flow, VDis_flow.u3[1]) annotation (Line(points={{695,130},
          {160,130},{160,245},{174,245}}, color={0,0,127}));
  connect(TZonSet[1].TZonHeaSet, add1.u1) annotation (Line(points={{-10,332},{
          -64,332},{-64,286},{-120,286}}, color={0,0,127}));
  connect(heaSetDR.y[1], add1.u2) annotation (Line(points={{-121,232},{-66,232},
          {-66,274},{-120,274}}, color={0,0,127}));
  connect(add1.y, conVAVNor.TZonHeaSet) annotation (Line(points={{-143,280},{
          -182,280},{-182,24},{652,24}}, color={0,0,127}));
  connect(add1.y, conVAVCor.TZonHeaSet) annotation (Line(points={{-143,280},{-182,
          280},{-182,110},{298,110},{298,124},{776,124}},      color={0,0,127}));
  connect(add1.y, conVAVSou.TZonHeaSet) annotation (Line(points={{-143,280},{
          -182,280},{-182,52},{1018,52}}, color={0,0,127}));
  connect(ecoHigCut.y, conAHU.TOutCut) annotation (Line(points={{88,482},{224,
          482},{224,470.706},{356,470.706}},
                                        color={0,0,127}));
  connect(add.y, add2.u2) annotation (Line(points={{-145,456},{-174,456},{-174,
          448},{-202,448}}, color={0,0,127}));
  connect(add2.u1, add1.y) annotation (Line(points={{-202,460},{-188,460},{-188,
          402},{-143,402},{-143,280}}, color={0,0,127}));
  connect(ecoHigCut1.y, greater_unocc.u2) annotation (Line(points={{-256.4,408},
          {-266,408},{-266,450},{-276,450}}, color={0,0,127}));
  connect(add2.y, greater_unocc.u1) annotation (Line(points={{-225,454},{-251.5,
          454},{-251.5,458},{-276,458}}, color={0,0,127}));
  connect(eco.yExh, exhaustDamperPositionBlock.ExhaustDamperPosition)
    annotation (Line(points={{-3,-34},{-3,-10},{-56,-10},{-56,-82},{-67,-82}},
        color={0,0,127}));
  connect(conAHU.yRetDamPos, exhaustDamperPositionBlock.ReturnDamperPosition)
    annotation (Line(points={{444,440.588},{448,440.588},{448,172},{-104,172},{
          -104,-82},{-90,-82}},
                           color={0,0,127}));
  connect(conAHU.u_UnOcc, greater_unocc.y) annotation (Line(points={{355.6,
          415.741},{-332,415.741},{-332,458},{-299,458}}, color={255,0,255}));
  connect(zonOutAirSet.nOcc, integerConstant.y) annotation (Line(points={{226,
          401},{188,401},{188,400},{-168,400},{-168,548},{-185,548}}, color={
          255,127,0}));
  connect(zonOutAirSet.uWin, booleanConstant1.y) annotation (Line(points={{226,
          398},{196,398},{196,396},{-178,396},{-178,502},{-189,502}}, color={
          255,0,255}));
  connect(TOut.y,eco_Enable_OAT. TOut) annotation (Line(points={{-279,180},{-96,
          180},{-96,-102}},                             color={0,0,127}));
  connect(ecoHigCut.y,eco_Enable_OAT. TOutCut) annotation (Line(points={{88,482},
          {104,482},{104,168},{-72,168},{-72,-8},{-96,-8},{-96,-24},{-104,-24},
          {-104,-72},{-112,-72},{-112,-104},{-96,-104}},          color={0,0,
          127}));
  connect(eco_Enable_OAT.OutdoorDamperPosition, eco.yOut) annotation (Line(
        points={{-73,-110.2},{-56,-110.2},{-56,-64},{-40,-64},{-40,-34},{-10,
          -34}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-320},{1400,
            640}}), graphics={Line(
          points={{508,144}},
          color={0,127,255},
          smooth=Smooth.Bezier)}),
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoopFlexlabX1a\">
BaseClasses.PartialOpenLoopFlexlabX1a</a>
for a description of the HVAC system and the building envelope.
</p>
<p>
The control is based on ASHRAE Guideline 36, and implemented
using the sequences from the library
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1\">
Buildings.Controls.OBC.ASHRAE.G36_PR1</a> for
multi-zone VAV systems with economizer. The schematic diagram of the HVAC and control
sequence is shown in the figure below.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavControlSchematics.png\" border=\"1\"/>
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
Note that this model, because of the frequent time sampling,
has longer computing time than
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>.
The reason is that the time integrator cannot make large steps
because it needs to set a time step each time the control samples
its input.
</p>
</html>", revisions="<html>
<ul>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&circ;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/Guideline36.mos"
        "Simulate and plot"),
    experiment(
      StartTime=19440000,
      StopTime=21427200,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end FlexlabX1aNonG36LoadShed;
