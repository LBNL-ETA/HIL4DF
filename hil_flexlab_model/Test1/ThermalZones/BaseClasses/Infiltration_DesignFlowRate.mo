within hil_flexlab_model.Test1.ThermalZones.BaseClasses;
model Infiltration_DesignFlowRate
    parameter Real A=0 "A parameter";
    parameter Real B=0 "B parameter";
    parameter Real C=0.224 "C parameter";
    parameter Real D=0 "D parameter";
    parameter Real schFra=1 "schedule fraction";
    parameter Modelica.Units.SI.VolumeFlowRate desFloRat "design infiltration air flow rate";
    parameter Modelica.Units.SI.Density airDen=1.2 "air density";

  Modelica.Blocks.Interfaces.RealInput zonAirTem "zone air temperature"
    annotation (Placement(transformation(extent={{-140,22},{-100,62}})));
  Modelica.Blocks.Interfaces.RealOutput infFloRat
    "infiltration flow rate in kg/s"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-126,-74},{-86,-34}}),
                                                     iconTransformation(extent={{-114,
            -64},{-94,-44}})));
protected
  Modelica.Blocks.Interfaces.RealOutput TDryBul
    annotation (Placement(transformation(extent={{100,42},{140,82}})));
  Modelica.Blocks.Interfaces.RealOutput winSpe
    annotation (Placement(transformation(extent={{100,-88},{140,-48}})));
equation
  infFloRat = airDen*desFloRat*schFra*(A+B*abs(zonAirTem-TDryBul)+C*winSpe+D*winSpe^2);

  connect(weaBus.TDryBul, TDryBul) annotation (Line(
      points={{-105.9,-53.9},{94,-53.9},{94,62},{120,62}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.winSpe, winSpe) annotation (Line(
      points={{-105.9,-53.9},{94,-53.9},{94,-68},{120,-68}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Infiltration_DesignFlowRate;
