unit Measurements;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

// Input
function Rpm(const RevPerMinute: Double): Double;
function Mm(const Millimeter: Double): Double;
function Kw(const Kilowatt: Double): Double;
function Nm(const NewtonMeter: Double): Double;
function Kg(const KiloGram: Double): Double;
function Mins(const Minute: Double): Double;
function Metre(const Metres: Double): Double;
function KgPerM3(const KilogramPerMetre3: Double): Double;

// Output
function ToMm(const Meter: Double): Double;
function ToMm4(const Meter4: Double): Double;
function ToKw(const Watt: Double): Double;
function ToRpm(const RevPerSec: Double): Double;
function ToMin(const Second: Double): Double;

implementation

function KgPerM3(const KilogramPerMetre3: Double): Double;  // don't convert
begin
  Result := KilogramPerMetre3;
end;

function Metre(const Metres: Double): Double;  // don't convert
begin
  Result := Metres;
end;

function Mins(const Minute: Double): Double;  // to sec
begin
  Result := Minute * 60;
end;

function Rpm(const RevPerMinute: Double): Double;  // to rev/sec
begin
  Result := RevPerMinute / 60;
end;

function Mm(const Millimeter: Double): Double;  // to meter
begin
  Result := Millimeter / 1e3;
end;

function Kw(const Kilowatt: Double): Double;  // to watt
begin
  Result := Kilowatt * 1e3;
end;

function Nm(const NewtonMeter: Double): Double;  // don't convert
begin
  Result := NewtonMeter;
end;

function Kg(const KiloGram: Double): Double;  // don't convert
begin
  Result := KiloGram;
end;

function ToMm(const Meter: Double): Double;  // to millimeter
begin
  Result := Meter * 1e3;
end;

function ToMm4(const Meter4: Double): Double;  // to millimeter^4
begin
  Result := Meter4 * 1e12;
end;

function ToKw(const Watt: Double): Double;  // to kilowatt
begin
  Result := Watt / 1e3;
end;

function ToRpm(const RevPerSec: Double): Double;  // to rev/min
begin
  Result := RevPerSec * 60;
end;

function ToMin(const Second: Double): Double;  // to minute
begin
  Result := Second / 60;
end;

end.

