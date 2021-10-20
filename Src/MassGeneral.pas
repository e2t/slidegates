unit MassGeneral;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses fgl, StrengthCalculations;

type
  TSheetWeights = specialize TFPGMap<Double, Double>;

  TWeights = record
    Sheet: TSheetWeights;
    Total, Frame, Gate: Double;
  end;

  TSheetMetal = record
    S, R: Double;
  end;

const
  StdSheet: array [0..5] of TSheetMetal = (
    (S: 0.002; R: 0.00247),
    (S: 0.003; R: 0.00234),
    (S: 0.004; R: 0.00378),
    (S: 0.005; R: 0.00620),
    (S: 0.006; R: 0.00739),
    (S: 0.008; R: 0.01123));

procedure CalcMass(var Mass: TWeights; const Slg: TSlidegate; const InputData: TInputData);
procedure UpdateSheetWeight(var SheetWeights: TSheetWeights; const S, Weight: Double);
function CalcPipeMass(const MajorDiam, Thickness, Length: Double): Double;
procedure ClearWeights(var Mass: TWeights);
procedure SetSheetMetal(out SheetMetal: TSheetMetal; const S: Double);

implementation

uses MassWedge, MassFlow, MathUtils, CheckNum;

function CalcPipeMass(const MajorDiam, Thickness, Length: Double): Double;
begin
  Result := Length * RingSectorArea(MajorDiam, MajorDiam - 2 * Thickness, 2 * Pi) *
    SteelDensity;
end;

procedure SetSheetMetal(out SheetMetal: TSheetMetal; const S: Double);
var
  I: Integer;
  IsFound: Boolean;
begin
  I := 0;
  IsFound := False;
  while (I <= High(StdSheet)) and not IsFound do
  begin
    IsFound := IsEqual(StdSheet[I].S, S);
    if IsFound then
      SheetMetal := StdSheet[I];
    Inc(I);
  end;
  if not IsFound then
  begin
    SheetMetal.S := S;
    SheetMetal.R := S;  { R = S }
  end;
end;

procedure UpdateSheetWeight(var SheetWeights: TSheetWeights; const S, Weight: Double);
var
  I: Integer;
begin
  I := SheetWeights.IndexOf(S);
  if I >= 0 then
    SheetWeights.Data[I] := SheetWeights.Data[I] + Weight
  else
    SheetWeights.Add(S, Weight);
end;

procedure CalcMass(var Mass: TWeights; const Slg: TSlidegate; const InputData: TInputData);
const
  RackThickness = 0.004;
  BracketThickness = 0.005;

  { промежуточная труба: диаметр винта х 3 мм }
  PipeThickness = 0.003;
  MassRack = 9;  { kg }
  BracketMass = 4;  { kg }
var
  PipeMass: Double;
begin
  ClearWeights(Mass);
  if Slg.SlgKind = Flow then
    CalcMassFlow(Mass, Slg, InputData)
  else
    CalcMassWedged(Mass, Slg, InputData);
  if Slg.DriveLocation <> OnFrame then
  begin
    PipeMass := CalcPipeMass(Slg.Screw.MajorDiam, PipeThickness,
      Slg.BtwFrameTopAndDriveUnit);
    if Slg.DriveLocation = OnRack then
    begin
      Mass.Total := Mass.Total + PipeMass + MassRack;
      UpdateSheetWeight(Mass.Sheet, RackThickness, MassRack);
    end
    else if Slg.DriveLocation = OnBracket then
    begin
      Mass.Total := Mass.Total + PipeMass + BracketMass;
      UpdateSheetWeight(Mass.Sheet, BracketThickness, BracketMass);
    end;
  end;
end;

procedure ClearWeights(var Mass: TWeights);
begin
  Mass.Sheet.Clear;
  Mass.Frame := 0;
  Mass.Gate := 0;
  Mass.Total := 0;
end;

end.
