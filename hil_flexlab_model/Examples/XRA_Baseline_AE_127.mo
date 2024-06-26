within hil_flexlab_model.Examples;
model XRA_Baseline_AE_127
  "Variable air volume flow system with terminal reheat - flexlab baseline, no leakage"
  extends Modelica.Icons.Example;

  hil_flexlab_model.Fluid.HeatHeatpumpCoolHeatpumpAuxHea_noIEC rtu(
    mAir_flow_nominal=casDat.mAir_flow_nominal,
    mAir_flow_minOA=casDat.minOAFlo,
    QHea_flow_nominal=casDat.QHea_flow_nominal,
    QCoo_flow_nominal=casDat.QCoo_flow_nominal,
    dp_nominal=casDat.dp_nominal,
    hydraulicEfficiency=casDat.hydraulicEfficiency,
    motorEfficiency=casDat.motorEfficiency,
    COP_heating=casDat.COP_heating,
    COP_cooling=casDat.COP_cooling) "Unit supplying conditioned air to space"
    annotation (Placement(transformation(extent={{252,-206},{428,26}})));
  hil_flexlab_model.BaseClasses.Controls.RTU rTU(
    mAir_flow_nominal=casDat.mAir_flow_nominal,
    mAir_flow_minOA=casDat.minOAFlo,
    mAir_flow_hea=casDat.mAir_flow_nominal,
    mAir_flow_coo=casDat.mAir_flow_nominal)
    annotation (Placement(transformation(extent={{-28,-220},{80,-6}})));
   Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=casDat.weaDatImport)
    annotation (Placement(transformation(extent={{-274,394},{-254,414}})));

  replaceable hil_flexlab_model.Data.PSP_4B_Med
                          casDat(weaDatImport=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://hil_flexlab_model/Resources/weatherdata/US_Berkeley_20210101.mos"))
    "Case study data"
    annotation (Placement(transformation(extent={{-180,82},{-160,102}})));

  Buildings.BoundaryConditions.WeatherData.Bus
                                     weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-194,280},{-174,300}})));
  CCC_test.obsolete_hil_flexlab_model.ThermalZones.FlexlabXRA flexlabXRA(lat=
        weaDat.lat)
    annotation (Placement(transformation(extent={{736,-334},{1376,352}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooHea(table=[3600*0,273.15 + 15.6;
        3600*5,273.15 + 15.6; 3600*5,273.15 + 17.8; 3600*6,273.15 + 17.8; 3600*
        6,273.15 + 19.4; 3600*7,273.15 + 19.4; 3600*7,273.15 + 21.1; 3600*22,
        273.15 + 21.1; 3600*22,273.15 + 15.6; 3600*24,273.15 + 15.6],
                                         extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-214,-114},{-194,-94}})));
  Modelica.Blocks.Sources.CombiTimeTable TSetRooCoo(table=[3600*0,273.15 + 26.7;
        3600*5,273.15 + 26.7; 3600*5,273.15 + 25.6; 3600*6,273.15 + 25.6; 3600*
        6,273.15 + 25; 3600*7,273.15 + 25; 3600*7,273.15 + 23.3; 3600*22,273.15
         + 23.3; 3600*22,273.15 + 26.7; 3600*24,273.15 + 26.7],
                                         extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-212,-144},{-192,-124}})));
equation

  connect(rTU.yFan, rtu.uFan) annotation (Line(
        points={{85.4,-16.7},{167.15,-16.7},{167.15,14.4},{243.2,14.4}},
        color={0,0,127}));
  connect(rTU.yHea, rtu.uHea) annotation (Line(
        points={{85.4,-55.6091},{179.15,-55.6091},{179.15,-20.4},{243.2,-20.4}},
        color={0,0,127}));
  connect(rTU.yCoo, rtu.uCoo) annotation (Line(
        points={{85.4,-84.7909},{164.15,-84.7909},{164.15,-55.2},{243.2,-55.2}},
        color={0,0,127}));
  connect(rTU.yOutAirFra, rtu.uEco) annotation (Line(
        points={{85.4,-123.7},{166.15,-123.7},{166.15,-90},{243.2,-90}},
        color={0,0,127}));
  connect(rtu.TMixAir, rTU.TMix) annotation (Line(
        points={{432.4,-159.6},{488,-159.6},{488,-378},{224,-378},{224,-191.791},
          {-38.8,-191.791}},
                      color={0,0,127}));
  connect(rTU.TSup, rtu.TSup) annotation (Line(
        points={{-38.8,-220.973},{498.6,-220.973},{498.6,-171.2},{432.4,-171.2}},
        color={0,0,127}));
  connect(rTU.TRet, rtu.phiRetAir) annotation (Line(
        points={{-38.8,-162.609},{-82,-162.609},{-82,-168},{-124,-168},{-124,
          -342},{476,-342},{476,-206},{432.4,-206}},
                                               color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-254,404},{-76,404},{-76,290},{-184,290}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, rtu.weaBus) annotation (Line(
      points={{-184,290},{126,290},{126,13.24},{269.6,13.24}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDryBul, rTU.TEco) annotation (Line(
      points={{-184,290},{-106,290},{-106,-132.455},{-38.8,-132.455}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(flexlabXRA.TRooAir, rTU.TRoo) annotation (Line(points={{1364.57,
          -29.8733},{1396,-29.8733},{1396,366},{-90,366},{-90,-104.245},{-38.8,
          -104.245}},
        color={0,0,127}));
  connect(flexlabXRA.weaBus, weaDat.weaBus) annotation (Line(
      points={{1158.86,47.8733},{445.43,47.8733},{445.43,404},{-254,404}},
      color={255,204,51},
      thickness=0.5));
  connect(TSetRooHea.y[1], rTU.TSetRooHea) annotation (Line(points={{-193,-104},
          {-117.5,-104},{-117.5,-45.8818},{-38.8,-45.8818}}, color={0,0,127}));
  connect(TSetRooCoo.y[1], rTU.TSetRooCoo) annotation (Line(points={{-191,-134},
          {-114,-134},{-114,-75.0636},{-38.8,-75.0636}}, color={0,0,127}));
  connect(flexlabXRA.portsCell[2], rtu.returnAir) annotation (Line(points={{990.857,
          -43.5933},{702.572,-43.5933},{702.572,-90},{428,-90}},         color=
          {0,127,255}));
  connect(flexlabXRA.portsCell[1], rtu.supplyAir) annotation (Line(points={{979.429,
          -43.5933},{705.572,-43.5933},{705.572,-43.6},{428,-43.6}},
        color={0,127,255}));
  connect(flexlabXRA.occ, rTU.occSta) annotation (Line(points={{1385.14,100.467},
          {665.57,100.467},{665.57,-16.7},{-38.8,-16.7}}, color={255,0,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-400},{1440,
            580}})),
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
See the model
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop\">
Buildings.Examples.VAVReheat.BaseClasses.PartialOpenLoop</a>
for a description of the HVAC system and the building envelope.
</p>
<p>
The control is an implementation of the control sequence
<i>VAV 2A2-21232</i> of the Sequences of Operation for
Common HVAC Systems (ASHRAE, 2006). In this control sequence, the
supply fan speed is regulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate.
The duct static pressure is adjusted
so that at least one VAV damper is 90% open. The economizer dampers
are modulated to track the setpoint for the mixed air dry bulb temperature.
Priority is given to maintain a minimum outside air volume flow rate.
In each zone, the VAV damper is adjusted to meet the room temperature
setpoint for cooling, or fully opened during heating.
The room temperature setpoint for heating is tracked by varying
the water flow rate through the reheat coil. There is also a
finite state machine that transitions the mode of operation of
the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>
<p>
A similar model but with a different control sequence can be found in
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
</html>", revisions="<html>
<ul>
<li>
April 20, 2020, by Jianjun Hu:<br/>
Exported actual VAV damper position as the measured input data for
defining duct static pressure setpoint.<br/>
This is
for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1873\">issue #1873</a>
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
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
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/ASHRAE2006.mos"
        "Simulate and plot"),
    experiment(
      StartTime=3801600,
      StopTime=6220800,
      Interval=299.999808,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end XRA_Baseline_AE_127;
