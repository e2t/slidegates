unit Equations;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  StrengthCalculations;

function CreateSmallSgEquations(const Slg: TSlidegate): string;

implementation

uses
  Classes, Measurements, SysUtils;

function RoundCount(const Number: Double): Integer;
begin
  if Frac(Number) >= 0.7 then
    Result := Trunc(Number) + 1
  else
    Result := Trunc(Number);
end;

function CreateSmallSgEquations(const Slg: TSlidegate): string;
const
  HorizScrewStep = 0.1;  // 100 mm
  VertScrewStep = 0.1;   // 100 mm
var
  RollerStep: Double;
  RollerCount, HorizScrewCount, VertScrewCount: Integer;
  Lines: TStringList;
begin
  if Slg.GateHeight > Metre(1.0) then
    RollerCount := 3
  else
    RollerCount := 2;
  if Slg.IsScrewPullout then
    RollerStep := (Slg.GateHeight - Mm(95)) / (RollerCount - 1)
  else
    RollerStep := (Slg.GateHeight - Mm(162)) / (RollerCount - 1);
  HorizScrewCount := RoundCount((Slg.FrameWidth / 2 - HorizScrewStep / 2 - Mm(65)) /
    HorizScrewStep);
  VertScrewCount := RoundCount((Slg.GateHeight - Mm(26)) / VertScrewStep);

  Lines := TStringList.Create;
  Lines.Add(
    Format('"FrameWidth" = %.0Fmm  ''Ширина рамы', [ToMm(Slg.FrameWidth)]));
  Lines.Add(
    Format('"FrameHeight" = %.0Fmm  ''Высота рамы', [ToMm(Slg.FrameHeight)]));
  Lines.Add(
    Format('"GateHeight" = %.0Fmm  ''Высота щита', [ToMm(Slg.GateHeight)]));
  Lines.Add(
    Format('"RollerStep" = %.0Fmm  ''Шаг роликов', [ToMm(RollerStep)]));
  Lines.Add(
    Format('"RollerCount" = %D  ''Количество пар роликов (2 или 3)', [RollerCount]));
  Lines.Add(
    Format('"HorizScrewStep" = %.0Fmm  ''Шаг болтов уплотнения по горизонтали', [ToMm(HorizScrewStep)]));
  Lines.Add(
    Format('"HorizScrewCount" = %D  ''Количество болтов уплотнения по горизонтали в линейном массиве на одну сторону', [HorizScrewCount]));
  Lines.Add(
    Format('"VertScrewStep" = %.0Fmm  ''Шаг болтов уплотнения по вертикали', [ToMm(VertScrewStep)]));
  Lines.Add(
    Format('"VertScrewCount" = %D  ''Количество болтов уплотнения по вертикали в линейном массиве на одну сторону', [VertScrewCount]));
  Result := TrimRight(Lines.Text);
  Lines.Free;
end;


end.
