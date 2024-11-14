within hil_flexlab_model.Test1.BaseClasses1;
model fanSupPow
  parameter Real a0=0 "Parameter a0";
  parameter Real a1=0 "Parameter a1";
  parameter Real a2=0 "Parameter a2";
  parameter Real a3=0 "Parameter a3";
  parameter Real a4=0 "Parameter a4";
  parameter Real a5=0 "Parameter a5";
  Modelica.Blocks.Interfaces.RealInput supDucStaPre
    "supply_duct_static_pressure"
    annotation (Placement(transformation(extent={{-140,-66},{-100,-26}})));
  Modelica.Blocks.Interfaces.RealInput supFanVolFlo
    "supply_fan_volumetric_flow"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  y = a0 + a1 * supFanVolFlo + a2 * supDucStaPre + a3 * supFanVolFlo^2 + a4*
    supDucStaPre^2 + a5*supFanVolFlo*supDucStaPre;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end fanSupPow;
