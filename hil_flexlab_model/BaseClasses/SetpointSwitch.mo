within hil_flexlab_model.BaseClasses;
model SetpointSwitch
  Modelica.Blocks.Interfaces.IntegerInput u
    annotation (Placement(transformation(extent={{-140,52},{-100,92}})));
  Modelica.Blocks.Interfaces.RealInput u1
    annotation (Placement(transformation(extent={{-140,-4},{-100,36}})));
  Modelica.Blocks.Interfaces.RealInput u2
    annotation (Placement(transformation(extent={{-140,-56},{-100,-16}})));
  Modelica.Blocks.Interfaces.RealInput u3
    annotation (Placement(transformation(extent={{-140,-106},{-100,-66}})));
  Modelica.Blocks.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  //y = abs(u);
  y = if u==2 then u2 else if u==3 then u3 else u1;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SetpointSwitch;
