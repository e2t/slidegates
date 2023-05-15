unit MassFlow;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses MassGeneral, StrengthCalculations;

procedure CalcMassFlow(var Mass: TWeights; const Slg: TSlidegate;
  const InputData: TInputData);

implementation

type
  TFlowDesign = record
    GateSheet, FrameSheet: TSheetMetal;
  end;

var
  StdFrameSheet, StdGateSheet: TSheetMetal;

procedure CalcFlowDesign(out Des: TFlowDesign; const InputData: TInputData);
begin
  Des := Default(TFlowDesign);

  if InputData.FrameSheet.HasValue then
    SetSheetMetal(Des.FrameSheet, InputData.FrameSheet.Value)
  else
    Des.FrameSheet := StdFrameSheet;

  if InputData.GateSheet.HasValue then
    SetSheetMetal(Des.GateSheet, InputData.GateSheet.Value)
  else
    Des.GateSheet := StdGateSheet;
end;

function CalcMassFrame(const Slg: TSlidegate): ValReal;
var
  { Вес рамы без направляющих. }
  PureFrame: ValReal;
  { Вес одной направляющей. }
  Lead: ValReal;
  { Неподвижный щит. }
  FixedGate: ValReal;
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

function CalcMassGate(const Slg: TSlidegate): ValReal;
begin
  Result := 112 * Slg.FrameWidth * Slg.GateHeight - 23 * Slg.FrameWidth -
    61 * Slg.GateHeight + 10;
  Assert(Result > 0);
end;

function MassScrew(const Slg: TSlidegate): ValReal;
begin
  Result := 5.66 * Slg.ScrewLength + 0.816;
end;

procedure CalcMassFlow(var Mass: TWeights; const Slg: TSlidegate;
  const InputData: TInputData);
var
  Des: TFlowDesign;
begin
  CalcFlowDesign(Des, InputData);
  Mass.Gate := CalcMassGate(Slg) * Des.GateSheet.S / StdGateSheet.S;
  Mass.Frame := CalcMassFrame(Slg) * Des.FrameSheet.S / StdFrameSheet.S;
  Mass.Slidegate := Mass.Gate + Mass.Frame + MassScrew(Slg) * Slg.ScrewsNumber + 3;

  UpdateSheetWeight(Mass.Sheet, Des.GateSheet.S, Mass.Gate);
  UpdateSheetWeight(Mass.Sheet, Des.FrameSheet.S, Mass.Frame);
end;

initialization
  StdFrameSheet := StdSheet[3];  { 5mm }
  StdGateSheet := StdSheet[3];  { 5mm }
end.
