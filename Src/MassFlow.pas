unit MassFlow;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses MassGeneral, StrengthCalculations;

procedure CalcMassFlow(out SgMass: Double; var SheetWeights: TSheetWeights;
  const Slg: TSlidegate);

implementation

uses Math;

type
  TFlowDesign = record
    GateSheet, FrameSheet: TSheetMetal;
  end;

procedure CalcFlowDesign(out Des: TFlowDesign);
begin
  Des := Default(TFlowDesign);

  Des.FrameSheet := StdSheet[3];  // 5mm
  Des.GateSheet := StdSheet[3];  // 5mm
end;

function MassFixedGate(const Slg: TSlidegate): Double;
var
  SteelDensityMm3: Double;
begin
  SteelDensityMm3 := SteelDensity / 1e9;
  Result := (Slg.FrameHeight * 1e3 - Slg.BethFrameTopAndGateTop *
    1e3 - Slg.GateHeight * 1e3 - 40) * (Slg.FrameWidth * 1e3 - 170) *
    5 * SteelDensityMm3 + (0.008 * Slg.FrameWidth * 1e3 - 0.001);
end;

function CalcMassFrame(const Slg: TSlidegate): Double;
var
  BottomBeamMass, StandMass, TopCornerMass: Double;
  TopBeamMass: Double;  // верх./пром. балка
begin
  BottomBeamMass := 0.012 * Slg.FrameWidth * 1e3 - 2.103;
  StandMass := 0.012 * Slg.FrameHeight * 1e3 - 0.016;
  TopBeamMass := 0.007 * Slg.FrameWidth * 1e3 - 1.242;
  TopCornerMass := 0.005 * Slg.FrameWidth * 1e3 - 0.806;
  Result := BottomBeamMass + StandMass * 2 + TopBeamMass * 2 +
    TopCornerMass + 4 + (0.004 * (Slg.FrameHeight * 1e3 -
    Slg.BethFrameTopAndGateTop * 1e3) - 0.26) * 2;
  if Slg.HaveFixedGate then
    Result := Result + MassFixedGate(Slg);
end;

function CalcMassGate(const Slg: TSlidegate): Double;
begin
  Result := (4.058e-5 * Slg.FrameWidth * 1e3 * Slg.GateHeight * 1e3 +
    -5.059e-3 * Slg.FrameWidth * 1e3 - 0.00419 * Slg.GateHeight * 1e3) +
    (0.003 * Slg.GateHeight * 1e3 - 0.033) * Round(Slg.FrameWidth * 1e3 / 300) +
    (0.003 * Slg.FrameWidth * 1e3 - 0.61) * Floor(Slg.GateHeight * 1e3 / 300);
end;

function MassScrew(const Slg: TSlidegate): Double;
begin
  Result := 0.011 * Slg.BethFrameTopAndGateTop * 1e3 + 1.756;
end;

procedure CalcMassFlow(out SgMass: Double; var SheetWeights: TSheetWeights;
  const Slg: TSlidegate);
var
  Des: TFlowDesign;
  MassGate, MassFrame: Double;
begin
  CalcFlowDesign(Des);
  MassGate := CalcMassGate(Slg);
  MassFrame := CalcMassFrame(Slg);
  SgMass := MassGate + MassFrame + MassScrew(Slg);

  UpdateSheetWeight(SheetWeights, Des.GateSheet.S, MassGate);
  UpdateSheetWeight(SheetWeights, Des.FrameSheet.S, MassFrame);
end;

end.


