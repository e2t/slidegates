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

function CalcMassFrame(const Slg: TSlidegate): Double;
var
  //Вес рамы без направляющих.
  PureFrame: Double;
  //Вес одной направляющей.
  Lead: Double;
  //Неподвижный щит.
  FixedGate: Double;
begin
  if Slg.InstallKind = Wall then
  begin
    PureFrame := 30 * Slg.FrameWidth + 21 * Slg.FrameHeight + 9.1;
    Lead := 8 * Slg.GateHeight + 1;
    Result := PureFrame + 2 * Lead + 1;
  end
  else
  begin
    PureFrame := 26.01 * Slg.FrameWidth + 17.6 * Slg.FrameHeight - 5.018;
    FixedGate := 32 * Slg.FrameWidth * Slg.GateHeight + 8.2 * Slg.GateHeight - 0.1;
    Lead := 3.25 * Slg.GateHeight - 0.31;
    Result := PureFrame + FixedGate + 2 * Lead + 1.5;
  end;
  Assert(Result > 0);
end;

function CalcMassGate(const Slg: TSlidegate): Double;
begin
  Result := 112 * Slg.FrameWidth * Slg.GateHeight - 23 * Slg.FrameWidth -
    61 * Slg.GateHeight + 10;
  Assert(Result > 0);
end;

function MassScrew(const Slg: TSlidegate): Double;
begin
  Result := 5.66 * Slg.ScrewLength + 0.816;
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
  SgMass := MassGate + MassFrame + MassScrew(Slg) * Slg.ScrewsNumber + 3;

  UpdateSheetWeight(SheetWeights, Des.GateSheet.S, MassGate);
  UpdateSheetWeight(SheetWeights, Des.FrameSheet.S, MassFrame);
end;

end.
