unit MassGeneral;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses fgl, StrengthCalculations;

type
  TSheetWeights = specialize TFPGMap<ValReal, ValReal>;

  TWeights = record
    Sheet: TSheetWeights;
    Total, Slidegate, Frame, Gate, PipeFlanges: ValReal;
  end;

  TSheetMetal = record
    S, R: ValReal;
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
procedure UpdateSheetWeight(var SheetWeights: TSheetWeights; const S, Weight: ValReal);
function CalcPipeMass(const MajorDiam, Thickness, Length: ValReal): ValReal;
procedure ClearWeights(var Mass: TWeights);
procedure SetSheetMetal(out SheetMetal: TSheetMetal; const S: ValReal);

implementation

uses MassWedge, MassFlow, MathUtils, CheckNum, DriveUnits, Measurements;

function CalcPipeMass(const MajorDiam, Thickness, Length: ValReal): ValReal;
begin
  Result := Length * RingSectorArea(MajorDiam, MajorDiam - 2 * Thickness, 2 * Pi) *
    SteelDensity;
end;

procedure SetSheetMetal(out SheetMetal: TSheetMetal; const S: ValReal);
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

procedure UpdateSheetWeight(var SheetWeights: TSheetWeights; const S, Weight: ValReal);
var
  I: Integer;
begin
  I := SheetWeights.IndexOf(S);
  if I >= 0 then
    SheetWeights.Data[I] := SheetWeights.Data[I] + Weight
  else
    SheetWeights.Add(S, Weight);
end;

procedure CalcRackAndBracketWeight(out Rack, Bracket: ValReal; const Slg: TSlidegate);
const
  StdRackWeight = 9;      { Вес стойки для F16 и ниже }
  F25RackWeight = 22;     { Вес стойки для F25 }
  StdBracketWeight = 11;  { Вес кронштейна для F16 и ниже }
  F25BracketWeight = 30;  { Вес кронштейна для F25 }
begin
  Rack := StdRackWeight;
  Bracket := StdBracketWeight;

  if Slg.Gearbox <> nil then
  begin
    case Slg.Gearbox.Flange of
      F07, F10, F14, F16:
      else
      begin
        Rack := F25RackWeight;
        Bracket := F25BracketWeight;
      end;
    end;
  end
  else if Slg.Actuator <> nil then
  begin
    case Slg.Actuator.Flange of
      F07, F10, F14, F16:
      else
      begin
        Rack := F25RackWeight;
        Bracket := F25BracketWeight;
      end
    end;
  end;
end;

procedure CalcPipe(out PipeDiam, PipeS: ValReal; const Slg: TSlidegate);
const
  MaxStress = 80e6;
var
  InnerDiam, TorsionStress, MaxTorque: ValReal;
begin
  PipeDiam := Slg.Screw.MajorDiam;
  PipeS := Mm(3);

  if Slg.Actuator = nil then
  begin
    MaxTorque := Slg.MaxScrewTorque;
  end
  else if Slg.ScrewsNumber = 1 then
  begin
    MaxTorque := Slg.Actuator.MaxTorque;
  end
  else
  begin
    MaxTorque := Slg.Actuator.MaxTorque * Slg.Gearbox.Ratio / Slg.ScrewsNumber;
  end;
  InnerDiam := PipeDiam - 2 * PipeS;
  TorsionStress := MaxTorque / RingTorsionResistanceMoment(PipeDiam, InnerDiam);
  if IsMore(TorsionStress, MaxStress) then
    PipeS := Mm(4);
end;

function CalcSupportsWeight(const Slg: TSlidegate): ValReal;
const
  ApproxPitch = 2.0; {m}
  SupportWeight = 4.26;
var
  SupportCount: Integer;
begin
  SupportCount := Round(Slg.BtwFrameTopAndDriveUnit / ApproxPitch) - 1;
  if SupportCount < 0 then
    SupportCount := 0;
  Result := SupportCount * SupportWeight;
end;

procedure CalcMass(var Mass: TWeights; const Slg: TSlidegate; const InputData: TInputData);
const
  Tails = 11; { общий вес приварной муфты и хвостовика }
var
  Rack, Bracket, PipeDiam, PipeThickness, PipeMass: ValReal;
begin
  ClearWeights(Mass);
  if Slg.SlgKind = Flow then
    CalcMassFlow(Mass, Slg, InputData)
  else
    CalcMassWedged(Mass, Slg, InputData);
  Mass.Total := Mass.Slidegate;

  if Slg.HaveCounterFlange then
  begin
    Mass.Total := Mass.Total + Mass.PipeFlanges;
    UpdateSheetWeight(Mass.Sheet, PipeFlangeS, Mass.PipeFlanges);
  end;

  if Slg.DriveLocation <> OnFrame then
  begin
    CalcPipe(PipeDiam, PipeThickness, Slg);
    PipeMass := Tails + CalcPipeMass(PipeDiam, PipeThickness, Slg.BtwFrameTopAndDriveUnit);
    Mass.Total := Mass.Total + CalcSupportsWeight(Slg) + PipeMass;

    CalcRackAndBracketWeight(Rack, Bracket, Slg);
    if Slg.DriveLocation = OnRack then
    begin
      Mass.Total := Mass.Total + (Rack + Bracket) * Slg.ScrewsNumber;
    end
    else if Slg.DriveLocation = OnBracket then
    begin
      Mass.Total := Mass.Total + Bracket * Slg.ScrewsNumber;
    end;
  end;
end;

procedure ClearWeights(var Mass: TWeights);
begin
  Mass.Sheet.Clear;
  Mass.PipeFlanges := 0;
  Mass.Frame := 0;
  Mass.Gate := 0;
  Mass.Slidegate := 0;
  Mass.Total := 0;
end;

end.
