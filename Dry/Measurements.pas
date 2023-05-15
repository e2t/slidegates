unit Measurements;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

{ Input }
function Rpm(const RevPerMinute: ValReal): ValReal;
function Mm(const Millimeter: ValReal): ValReal;
function Kw(const Kilowatt: ValReal): ValReal;
function Watt(const AWatt: ValReal): ValReal;
function Nm(const NewtonMeter: ValReal): ValReal;
function Kg(const KiloGram: ValReal): ValReal;
function Kgf(const KiloGramForce: ValReal): ValReal;
function Minute(const AMinute: ValReal): ValReal;
function Metre(const Metres: ValReal): ValReal;
function KgPerM3(const KilogramPerMetre3: ValReal): ValReal;
function kN(const KiloNewton: ValReal): ValReal;
function MPa(const MegaPascals: ValReal): ValReal;
function Deg(const Degrees: ValReal): ValReal;
function LitrePerSec(const Lps: ValReal): ValReal;

{ Output }
function ToMm(const Meter: ValReal): ValReal;
function ToMm4(const Meter4: ValReal): ValReal;
function ToKw(const Watt: ValReal): ValReal;
function ToRpm(const RevPerSec: ValReal): ValReal;
function ToMin(const Second: ValReal): ValReal;
function ToKgf(const Newton: ValReal): ValReal;
function ToTonf(const Newton: ValReal): ValReal;
function ToDeg(const Radians: ValReal): ValReal;
function ToPct(const Value: ValReal): ValReal;
function ToMPa(const Pascals: ValReal): ValReal;

implementation

uses
  Math, MathUtils;

function KgPerM3(const KilogramPerMetre3: ValReal): ValReal;  { don't convert }
begin
  Result := KilogramPerMetre3;
end;

function Metre(const Metres: ValReal): ValReal;  { don't convert }
begin
  Result := Metres;
end;

function Minute(const AMinute: ValReal): ValReal;  { to sec }
begin
  Result := AMinute * 60;
end;

function Rpm(const RevPerMinute: ValReal): ValReal;  { to rev/sec }
begin
  Result := RevPerMinute / 60;
end;

function Mm(const Millimeter: ValReal): ValReal;  { to meter }
begin
  Result := Millimeter / 1e3;
end;

function Kw(const Kilowatt: ValReal): ValReal;  { to watt }
begin
  Result := Kilowatt * 1e3;
end;

function Watt(const AWatt: ValReal): ValReal;
begin
  Result := AWatt;
end;

function Nm(const NewtonMeter: ValReal): ValReal;  { don't convert }
begin
  Result := NewtonMeter;
end;

function Kg(const KiloGram: ValReal): ValReal;  { don't convert }
begin
  Result := KiloGram;
end;

function Kgf(const KiloGramForce: ValReal): ValReal;  { to newtons }
begin
  Result := KiloGramForce * GravAcc;
end;

function MPa(const MegaPascals: ValReal): ValReal;  { to Pascal }
begin
  Result := MegaPascals * 1e6;
end;

function Deg(const Degrees: ValReal): ValReal;  { to Radians }
begin
  Result := DegToRad(Degrees);
end;

function ToMm(const Meter: ValReal): ValReal;  { to millimeter }
begin
  Result := Meter * 1e3;
end;

function ToMm4(const Meter4: ValReal): ValReal;  { to millimeter^4 }
begin
  Result := Meter4 * 1e12;
end;

function ToKw(const Watt: ValReal): ValReal;  { to kilowatt }
begin
  Result := Watt / 1e3;
end;

function ToRpm(const RevPerSec: ValReal): ValReal;  { to rev/min }
begin
  Result := RevPerSec * 60;
end;

function ToMin(const Second: ValReal): ValReal;  { to minute }
begin
  Result := Second / 60;
end;

function ToKgf(const Newton: ValReal): ValReal;
begin
  Result := Newton / GravAcc;
end;

function ToTonf(const Newton: ValReal): ValReal;
begin
  Result := Newton / GravAcc / 1e3;
end;

function ToDeg(const Radians: ValReal): ValReal;
begin
  Result := RadToDeg(Radians);
end;

function ToPct(const Value: ValReal): ValReal;
begin
  Result := Value * 100;
end;

function LitrePerSec(const Lps: ValReal): ValReal;
begin
  Result := Lps / 1e3;
end;

function kN(const KiloNewton: ValReal): ValReal; { to newton }
begin
  Result := KiloNewton * 1e3;
end;

function ToMPa(const Pascals: ValReal): ValReal;
begin
  Result := Pascals / 1e6;
end;

end.
