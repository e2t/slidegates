unit MathUtils;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

const
  GravAcc = 9.80665;  { Metre/sec2 }
  SteelElast = 2.0e11;  { Pa }
  LimitShearStressAISI304 = 60e6;  { Pa }

function RoundMath(const Value: Double): Integer;
function RoundMultiple(const Value, Base: Double): Double;
function CeilMultiple(const Value, Base: Double): Double;
function RingSectorArea(const MajorDiam, MinorDiam, Angle: Double): Double;
function RingAxialInertiaMoment(const MajorDiam, MinorDiam: Double): Double;
function RingInertiaRadius(const MajorDiam, MinorDiam: Double): Double;
function RingTorsionResistanceMoment(const MajorDiam, MinorDiam: Double): Double;
function CircleSectorArea(const Diam, Angle: Double): Double;
function CircleSectorDiam(const Area, Angle: Double): Double;
function CircleAxialInertiaMoment(const Diam: Double): Double;
function CircleInertiaRadius(const Diam: Double): Double;
function CircleTorsionResistanceMoment(const Diam: Double): Double;

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

function RingAxialInertiaMoment(const MajorDiam, MinorDiam: Double): Double;
begin
  Result := Pi * (IntPower(MajorDiam, 4) - IntPower(MinorDiam, 4)) / 64;
end;

function RingInertiaRadius(const MajorDiam, MinorDiam: Double): Double;
begin
  Result := Sqrt(Sqr(MajorDiam) + Sqr(MinorDiam)) / 4;
end;

function CircleInertiaRadius(const Diam: Double): Double;
begin
  Result := Diam / 4;
end;

function CircleAxialInertiaMoment(const Diam: Double): Double;
begin
  Result := Pi * IntPower(Diam, 4) / 64;
end;

function RingTorsionResistanceMoment(const MajorDiam, MinorDiam: Double): Double;
var
  A: Double;
begin
  A := MinorDiam / MajorDiam;
  Result := Pi * IntPower(MajorDiam, 3) / 16 * (1 - IntPower(A, 4));
end;

function CircleTorsionResistanceMoment(const Diam: Double): Double;
begin
  Result := Pi * IntPower(Diam, 3) / 16;
end;

end.
