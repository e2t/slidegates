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

procedure CalcMass(out Mass: Double; out SheetWeights: TSheetWeights;
  const Slg: TSlidegate);
procedure UpdateSheetWeight(var SheetWeights: TSheetWeights; const S, Weight: Double);
function CalcPipeMass(const MajorDiam, Thickness, Length: Double): Double;

implementation

uses MassWedge, MassFlow, MathUtils;

function CalcPipeMass(const MajorDiam, Thickness, Length: Double): Double;
begin
  Result := Length * RingSectorArea(MajorDiam, MajorDiam - 2 * Thickness, 2 * Pi) *
    SteelDensity;
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

procedure CalcMass(out Mass: Double; out SheetWeights: TSheetWeights;
  const Slg: TSlidegate);
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
  SheetWeights := TSheetWeights.Create;
  if Slg.SlgKind = Flow then
    CalcMassFlow(Mass, SheetWeights, Slg)
  else
    CalcMassWedged(Mass, SheetWeights, Slg);
  if Slg.DriveLocation <> OnFrame then
  begin
    PipeMass := CalcPipeMass(Slg.Screw.MajorDiam, PipeThickness,
      Slg.BtwFrameTopAndDriveUnit);
    if Slg.DriveLocation = OnRack then
    begin
      Mass := Mass + PipeMass + MassRack;
      UpdateSheetWeight(SheetWeights, RackThickness, MassRack);
    end
    else if Slg.DriveLocation = OnBracket then
    begin
      Mass := Mass + PipeMass + BracketMass;
      UpdateSheetWeight(SheetWeights, BracketThickness, BracketMass);
    end;
  end;
end;

end.
