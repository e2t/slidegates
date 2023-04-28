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

function RoundMath(const Value: ValReal): Integer;
function RoundMultiple(const Value, Base: ValReal): ValReal;
function CeilMultiple(const Value, Base: ValReal): ValReal;
function RingSectorArea(const MajorDiam, MinorDiam, Angle: ValReal): ValReal;
function RingAxialInertiaMoment(const MajorDiam, MinorDiam: ValReal): ValReal;
function RingInertiaRadius(const MajorDiam, MinorDiam: ValReal): ValReal;
function RingTorsionResistanceMoment(const MajorDiam, MinorDiam: ValReal): ValReal;
function CircleSectorArea(const Diam, Angle: ValReal): ValReal;
function CircleSectorDiam(const Area, Angle: ValReal): ValReal;
function CircleAxialInertiaMoment(const Diam: ValReal): ValReal;
function CircleInertiaRadius(const Diam: ValReal): ValReal;
function CircleTorsionResistanceMoment(const Diam: ValReal): ValReal;

implementation

uses Math;

function RoundMath(const Value: ValReal): Integer;
begin
  Result := Trunc(Value + 0.5);
end;

function RoundMultiple(const Value, Base: ValReal): ValReal;
begin
  Result := Round(Value / Base) * Base;
end;

function CeilMultiple(const Value, Base: ValReal): ValReal;
begin
  Result := Ceil(Value / Base) * Base;
end;

function CircleSectorArea(const Diam, Angle: ValReal): ValReal;
begin
  Result := Angle / 8 * Sqr(Diam);
end;

function CircleSectorDiam(const Area, Angle: ValReal): ValReal;
begin
  Result := Sqrt(8 * Area / Angle);
end;

function RingSectorArea(const MajorDiam, MinorDiam, Angle: ValReal): ValReal;
begin
  Result := Angle / 8 * (Sqr(MajorDiam) - Sqr(MinorDiam));
end;

function RingAxialInertiaMoment(const MajorDiam, MinorDiam: ValReal): ValReal;
begin
  Result := Pi * (IntPower(MajorDiam, 4) - IntPower(MinorDiam, 4)) / 64;
end;

function RingInertiaRadius(const MajorDiam, MinorDiam: ValReal): ValReal;
begin
  Result := Sqrt(Sqr(MajorDiam) + Sqr(MinorDiam)) / 4;
end;

function CircleInertiaRadius(const Diam: ValReal): ValReal;
begin
  Result := Diam / 4;
end;

function CircleAxialInertiaMoment(const Diam: ValReal): ValReal;
begin
  Result := Pi * IntPower(Diam, 4) / 64;
end;

function RingTorsionResistanceMoment(const MajorDiam, MinorDiam: ValReal): ValReal;
var
  A: ValReal;
begin
  A := MinorDiam / MajorDiam;
  Result := Pi * IntPower(MajorDiam, 3) / 16 * (1 - IntPower(A, 4));
end;

function CircleTorsionResistanceMoment(const Diam: ValReal): ValReal;
begin
  Result := Pi * IntPower(Diam, 3) / 16;
end;

end.
