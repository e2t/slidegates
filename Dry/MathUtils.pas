unit MathUtils;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

function RoundMath(const Value: Double): Integer;
function RoundMultiple(const Value, Base: Double): Double;
function CeilMultiple(const Value, Base: Double): Double;
function RingSectorArea(const MajorDiam, MinorDiam, Angle: Double): Double;
function CircleSectorArea(const Diam, Angle: Double): Double;
function CircleSectorDiam(const Area, Angle: Double): Double;

implementation

uses Math;

function RoundMath(const Value: Double): Integer;
begin
  Result := Trunc(Value + 0.5);
end;

function RoundMultiple(const Value, Base: Double): Double;
begin
  Result := Round(Value / Base) * Base;
end;

function CeilMultiple(const Value, Base: Double): Double;
begin
  Result := Ceil(Value / Base) * Base;
end;

function CircleSectorArea(const Diam, Angle: Double): Double;
begin
  Result := Angle / 8 * Sqr(Diam);
end;

function CircleSectorDiam(const Area, Angle: Double): Double;
begin
  Result := Sqrt(8 * Area / Angle);
end;

function RingSectorArea(const MajorDiam, MinorDiam, Angle: Double): Double;
begin
  Result := Angle / 8 * (Sqr(MajorDiam) - Sqr(MinorDiam));
end;

end.

