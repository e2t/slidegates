unit StrengthCalculations;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  Nullable, DriveUnits, Screws, Localization;

type
  TSlgKind = (Surf, Deep, Flow);
  TDriveKind = (OpenCloseActuator, RegulActuator, BevelGearbox, SpurGearbox, HandWheel);
  TInstallKind = (Concrete, Channel, Wall, Flange, TwoFlange);
  TDriveLocation = (OnFrame, OnRack, OnBracket);

  TInputData = record
    FrameWidth: Double;
    GateHeight: Double;
    HydrHead: TNullableReal;
    SlgKind: TSlgKind;
    DriveKind: TDriveKind;
    InstallKind: TInstallKind;
    IsFrameClosed: Boolean;
    DriveLocation: TDriveLocation;
    IsScrewPullout: Boolean;
    TiltAngle: Double;
    LiquidDensity: Double;
    HaveFixedGate: Boolean;
    FrameHeight: Double;
    HaveFrameNodes: TNullableBool;
    WedgePairsCount: TNullableInt;
    Way: TNullableReal;
    ScrewDiam: TNullableReal;
    ScrewPitch: TNullableReal;
    Actuator: TActuator;
    Gearbox: TGearbox;
    BethFrameTopAndGateTop: TNullableReal;
    ModelGearbox: TModelGearbox;
    ModelActuator: TModelActuator;
    ControlBlock: TControlBlock;
    RecommendMinSpeed: Double;
    FullWays: Double;
    HaveCounterFlange: Boolean;
    BtwFrameTopAndDriveUnit: Double;
    HavePipeNodes: Boolean;
  end;

  TSlidegate = record
    FrameWidth: Double;
    GateHeight: Double;
    HydrHead: Double;
    IsScrewPullout: Boolean;
    SlgKind: TSlgKind;
    DriveKind: TDriveKind;
    LiquidDensity: Double;
    InstallKind: TInstallKind;
    IsFrameClosed: Boolean;
    DriveLocation: TDriveLocation;
    HaveFixedGate: Boolean;
    WedgePairsCount: Integer;
    IsRightHandedScrew: Boolean;
    FrameHeight: Double;
    Way: Double;
    BethFrameTopAndGateTop: Double;
    HaveFrameNodes: Boolean;
    HydrForce: Double;
    ScrewLength: Double;
    ThreadLength: Double;
    MinAxialForce: Double;
    MinScrewInertiaMoment: Double;
    MinScrewMinorDiam: Double;
    MinTorque: Double;
    Screw: TScrew;
    Nut: TNut;
    Actuator: TActuator;
    Gearbox: TGearbox;
    HandWheel: THandWheel;
    Revs: Double;
    Sleeve: string;
    OpenTime: Double;
    Torque: Double;
    CloseTorque: Double;
    AxialForce: Double;
    NutAxe: Double;
    ScrewFoS: Double;
    ScrewSlenderness: Double;
    BronzeWedgeStrip: string;
    BronzeWedgeStripLength: Double;
    MinSpeed: Double;
    ControlBlock: TControlBlock;
    MinDriveUnitTemperature: Double;
    MaxDriveUnitTemperature: Double;
    Leakage: Double;
    HaveCounterFlange: Boolean;
    HavePipeNodes: Boolean;
    BtwFrameTopAndDriveUnit: Double;
    IsSmall: Boolean;
  end;

  TFuncSlidegateError = function(const Slg: TSlidegate; const Lang: TLang): string;

function CalcSlidegate(out Slg: TSlidegate;
  const InputData: TInputData): TFuncSlidegateError;

function MinFrameHeight(const GateHeight: Double): Double;
function MaxWay(const FrameHeight, GateHeight: Double): Double;

const
  RackHeight = 0.76;  // m

implementation

uses
  SysUtils, Math, Measurements;

const
  TopBalkHeight = 0.2;  // Metre
  GravAcc = 9.80665;  // Metre/sec2
  ScrewElast = 2.1e11;  // Pa
  ScrewMju = 0.7;  // перешел с 1.0  - 10.01.2019
  ScrewFricAngle = 0.148889947609;  // atan(0.15)
  DeltaOpen = 5.0;  // N*Metre
  LimitShearStress = 75e6;  // Pa
  SpecificLeakage = 0.02;  // l/m/s
  MaxPulloutScrew = 0.04;  // Tr40
  { Перешел с 2.35 - 10.01.2019
    Перешел с 1.95 - 23.04.2021 }
  RecommendFoS = 1.45;

function CalcWedgePairsCount(const HydrHead: Double; const FrameWidth: Double;
  const GateHeight: Double): Integer;
begin
  if (HydrHead >= 4) and ((FrameWidth >= 1.9) or (GateHeight >= 1.9)) then
    Result := 3
  else
    Result := 2;
end;

function CalcOptimalFrameHeight(const GateHeight, Way: Double): Double;
begin
  Result := MinFrameHeight(GateHeight) + Way;
end;

function MinFrameHeight(const GateHeight: Double): Double;
begin
  Result := GateHeight + TopBalkHeight;
end;

function MaxWay(const FrameHeight, GateHeight: Double): Double;
begin
  Result := FrameHeight - MinFrameHeight(GateHeight);
end;

function CalcWay(const FrameHeight, GateHeight: Double): Double;
begin
  Result := MaxWay(FrameHeight, GateHeight);
  if Result > GateHeight then
    Result := GateHeight;
end;

function CalcMinimalFrameHeightForNodes(const GateHeight, Way: Double): Double;
begin
  Result := GateHeight + Way + 0.5;
end;

(* The force F is given by (approximately)
        F = 10HA where F is in units of kN
H is the maximum differential head at the centre of the door – metres.
This should be the worst case which could occur.
A is the door area in square metres *)
function CalcHydrForce(const FrameWidth: Double; const GateHeight: Double;
  const HydrHead: Double; const LiquidDensity: Double): Double;
var
  HeadCentre: Double;
begin
  HeadCentre := HydrHead - GateHeight / 2;
  Result := (LiquidDensity * GravAcc) * HeadCentre * (FrameWidth * GateHeight);
end;

(* The normal operating force of the penstock P can be taken as first
approximation as
        P = 0.5F kN where F is defined above *)
function CalcMinAxialForce(const HydrForce: Double): Double;
begin
  Result := 0.5 * HydrForce;
end;

function CalcScrewLength(const HaveFrameNodes, IsScrewPullout, HavePipeNodes: Boolean;
  const FrameHeight, Way, GateHeight, BtwFrameTopAndDriveUnit: Double;
  const DriveLocation: TDriveLocation): Double;
var
  NormalLength: Double;
begin
  if HaveFrameNodes then
    NormalLength := Way + 0.05
  else
    NormalLength := FrameHeight - GateHeight;

  if (DriveLocation <> OnFrame) and IsScrewPullout and (not HavePipeNodes) then
    Result := Max(NormalLength, BtwFrameTopAndDriveUnit)
  else
    Result := NormalLength;
end;

function CaclThreadLength(const FrameHeight, Way, GateHeight: Double;
  const Nut: TNut; const IsScrewPullout: Boolean): Double;
const
  MaxThreadLength = 6.0;
var
  WorkLength: Double;
begin
  WorkLength := FrameHeight - GateHeight;
  if (WorkLength - Way) > 1.0 then
    WorkLength := Way;

  if IsScrewPullout then
    Result := WorkLength + 0.2  // 200 мм над рамой
  else
    Result := WorkLength + Nut.Length + 0.05;  // 50 мм запас

  if Result > MaxThreadLength then
    Result := MaxThreadLength;
end;

// Return minimal rod inertia moment by axial force and its elasticity
// 0.5 <= mju <= 2.0
function CalcMinInertiaMoment(const AxialForce: Double; const FoS: Double;
  const RodLength: Double; const RodElast: Double; const Mju: Double): Double;
begin
  Result := AxialForce * FoS * (Mju * RodLength / Pi) ** 2 / RodElast;
end;

// The calculation of cross-section diameter by its moment of inertia.
function CalcDiamByInertiaMoment(const MomentIner: Double): Double;
begin
  Result := (MomentIner * 64 / Pi) ** 0.25;
end;

function CalcScrewTorque(const AxialForce: Double; const Screw: TScrew): Double;
begin
  Result := AxialForce * Tan(ScrewFricAngle + Screw.ThreadAngle) *
    Screw.PitchDiam / 2;
end;

// Return axial inertia moment of circular section by its diameter
function CalcCircleAxialInertiaMoment(const Diam: Double): Double;
begin
  Result := Pi * Diam ** 4 / 64;
end;

// Calculation factor of safity in screw by axial force
function CalcFoS(const ScrewMinorDiam: Double; const ScrewLength: Double;
  const ScrewElast: Double; const AxialForce: Double; const Mju: Double): Double;
begin
  Result := CalcCircleAxialInertiaMoment(ScrewMinorDiam) * ScrewElast /
    AxialForce / (Mju * ScrewLength / Pi) ** 2;
end;

function CalcAxialForce(const Torque: Double; const Screw: TScrew): Double;
begin
  Result := 2 * Torque / Tan(ScrewFricAngle + Screw.ThreadAngle) / Screw.PitchDiam;
end;

function ChooseScrewByMinDiam(var Screw: TScrew; var Nut: TNut;
  const MinRod: Double; const IsScrewPullout: Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;
  I := 0;
  while (I <= High(StdScrews)) and (not Result) do
  begin
    if StdScrews[I].Screw.MinorDiam >= MinRod then
    begin
      Screw := StdScrews[I].Screw;
      Nut := GetNut(StdScrews[I], IsScrewPullout);
      Result := True;
    end;
    Inc(I);
  end;
end;

function ChooseScrewByPitchDiam(var Screw: TScrew; var Nut: TNut;
  const MinAxialForce, MinTorque, MaxTorque, ScrewLength: Double;
  const IsScrewPullout: Boolean): Boolean;
var
  I: Integer;
  Torque, AxialForce, FoS: Double;
begin
  Result := False;
  I := 0;
  while (I <= High(StdScrews)) and (not Result) do
  begin
    Torque := CalcScrewTorque(MinAxialForce, StdScrews[I].Screw);
    if Torque <= MaxTorque then
    begin
      if Torque < MinTorque then
        Torque := MinTorque;
      AxialForce := CalcAxialForce(Torque, StdScrews[I].Screw);
      FoS := CalcFoS(StdScrews[I].Screw.MinorDiam, ScrewLength, ScrewElast,
        AxialForce, ScrewMju);
      if FoS >= RecommendFoS then
      begin
        Screw := StdScrews[I].Screw;
        Nut := GetNut(StdScrews[I], IsScrewPullout);
        Result := True;
      end;
    end;
    Inc(I);
  end;
end;

procedure ChooseScrewByMatch(var Screw: TScrew; var Nut: TNut;
  const MajorDiam, Pitch: Double; const IsScrewPullout: Boolean);
var
  I: Integer;
  IsStdFound: Boolean;
begin
  IsStdFound := False;
  I := 0;
  while (I <= High(StdScrews)) and (not IsStdFound) do
  begin
    if (StdScrews[I].Screw.MajorDiam = MajorDiam) and
      (StdScrews[I].Screw.Pitch = Pitch) then
    begin
      Screw := StdScrews[I].Screw;
      Nut := GetNut(StdScrews[I], IsScrewPullout);
      IsStdFound := True;
    end;
    Inc(I);
  end;
  if not IsStdFound then
  begin
    Screw := ScrewTr(MajorDiam, Pitch);
    Nut := SelfMadeNut(MajorDiam);
  end;
end;

function ChooseGearbox(var Gearbox: TGearbox; const RequiredTorque: Double;
  const IsScrewPullout: Boolean; const Screw: TScrew;
  const ModelGearbox: array of TArrayGearbox): Boolean;
var
  I: Integer;
begin
  Result := False;
  I := 0;
  while (I <= High(ModelGearbox)) and (not Result) do
  begin
    if ModelGearbox[I, 0].MaxTorque >= RequiredTorque then
      if (not IsScrewPullout) or (ModelGearbox[I, 0].MaxScrew >= Screw.MajorDiam) then
      begin
        Gearbox := ModelGearbox[I, 0];
        Result := True;
      end;
    Inc(I);
  end;
end;

procedure CalcActuatorTemperatureRange(var MinTemperature, MaxTemperature: Double;
  const Actuator: TActuator; const ControlBlock: TControlBlock);
begin
  case Actuator.ActuatorType of
    AumaSA:
    begin
      if ControlBlock = NoBlock then
      begin
        MinTemperature := -40;
        MaxTemperature := 80;
      end
      else if ControlBlock = AumaAM then
      begin
        MinTemperature := -40;
        MaxTemperature := 70;
      end
      else if ControlBlock = AumaAC then
      begin
        MinTemperature := -25;
        MaxTemperature := 70;
      end;
    end;

    AumaSAR:
    begin
      if ControlBlock = NoBlock then
      begin
        MinTemperature := -40;
        MaxTemperature := 60;
      end
      else if ControlBlock = AumaAM then
      begin
        MinTemperature := -40;
        MaxTemperature := 60;
      end
      else if ControlBlock = AumaAC then
      begin
        MinTemperature := -25;
        MaxTemperature := 60;
      end;
    end;

    else
      Assert(False, 'Неизвестный тип привода');
  end;
end;

function CalcMinSpeed(const Revs: Double; const Duty: string;
  const FullWays: Double): Double;
var
  OpenTimeForFullWays: Double;
begin
  case Duty of
    S215, S425:
      OpenTimeForFullWays := Mins(12);  // sec
    S230, S450:
      OpenTimeForFullWays := Mins(27);  // sec
    else
      Assert(False, 'Неизвестный режим работы');
  end;
  Result := Revs / OpenTimeForFullWays * FullWays;
end;

function ChooseActuator(var Actuator: TActuator; const RequiredTorque: Double;
  const IsScrewPullout: Boolean; const Screw: TScrew;
  const ModelActuator: array of TArrayActuator; const SlgKind: TSlgKind;
  const MinSpeed: Double; const RecommendMinSpeed: Double): Boolean;
var
  I, J: Integer;
  IsSpeedNormal: Boolean;
begin
  Result := False;
  if SlgKind = Flow then
    I := 2  // from 10.2
  else
    I := 1;  // from 07.6
  while (I <= High(ModelActuator)) and (not Result) do
  begin
    J := 0;
    IsSpeedNormal := False;
    while (J <= High(ModelActuator[I])) and (not IsSpeedNormal) do
    begin
      if (ModelActuator[I, J].Speed >= MinSpeed) and
        (ModelActuator[I, J].MaxTorque >= RequiredTorque) then
        if (not IsScrewPullout) or (ModelActuator[I, J].MaxScrew >= Screw.MajorDiam) then
        begin
          Actuator := ModelActuator[I, J];
          Result := True;
          if Actuator.Speed >= RecommendMinSpeed then
            IsSpeedNormal := True;
        end;
      Inc(J);
    end;
    Inc(I);
  end;
end;

function ChooseHandWheel(var HandWheel: THandWheel;
  const RequiredTorque: Double): Boolean;
var
  I: Integer;
begin
  Result := False;
  I := 0;
  while (I <= High(HandWheels)) and (not Result) do
  begin
    if HandWheels[I].MaxTorque >= RequiredTorque then
      //IF (NOT IsScrewPullout) OR (ModelActuator[I, J].MaxScrew >= Screw.MajorDiam) THEN
    begin
      HandWheel := HandWheels[I];
      Result := True;
    end;
    Inc(I);
  end;
end;

function CalcSleeve(const IsScrewPullout: Boolean): string;
begin
  if IsScrewPullout then
    Result := A
  else
    Result := B1;
end;

function CalcNutAxe(const AxialForce: Double): Double;
const
  AxesNumber = 2;
  HoleDiam = 0.010;  // M10 into the axe
begin
  Result := (4 * AxialForce / AxesNumber / Pi / LimitShearStress +
    HoleDiam ** 2) ** 0.5;
end;

// Для полного круга Angle = 2 * Pi
function CalcAreaCircleOfDiam(const Diam: Double; const Angle: Double): Double;
begin
  Result := Angle * Diam ** 2 / 8;
end;

function CalcSlendernessRatio(const ScrewLength: Double; const RodDiam: Double): Double;
begin
  Result := ScrewLength / (RodDiam / 4);
end;

function CalcLeakage(const Kind: TSlgKind; const FrameWidth, GateHeight: Double): Double;
var
  SealingPerimeter: Double;
begin
  if Kind = Deep then
    SealingPerimeter := GateHeight * 2 + FrameWidth * 2
  else
    SealingPerimeter := GateHeight * 2 + FrameWidth;
  Result := SpecificLeakage * SealingPerimeter * 60;  // l/min
end;

function ErrorCantChooseScrew(const Slg: TSlidegate; const Lang: TLang): string;
begin
  if Slg.MinScrewMinorDiam > 0 then
    Result := L10n[20, Lang] + ' ' + Format(L10n[26, Lang],
      [ToMm(Slg.MinScrewMinorDiam)])
  else
    Result := L10n[20, Lang];
end;

function ErrorCantChooseGearbox(const Slg: TSlidegate; const Lang: TLang): string;
begin
  Result := Format(L10n[27, Lang], [Slg.MinTorque]);
end;

function ErrorCantChooseActuator(const Slg: TSlidegate; const Lang: TLang): string;
begin
  Result := Format(L10n[28, Lang], [Slg.MinTorque, ToRpm(Slg.MinSpeed)]);
end;

function CalcSlidegate(out Slg: TSlidegate;
  const InputData: TInputData): TFuncSlidegateError;
begin
  Slg := Default(TSlidegate);
  Result := nil;

  Slg.FrameWidth := InputData.FrameWidth;
  Slg.GateHeight := InputData.GateHeight;
  Slg.FrameHeight := InputData.FrameHeight;
  Assert(Slg.FrameHeight >= MinFrameHeight(Slg.GateHeight),
    'Слишком низкая рама');

  Slg.IsScrewPullout := InputData.IsScrewPullout;
  Slg.SlgKind := InputData.SlgKind;
  Slg.DriveKind := InputData.DriveKind;
  Slg.LiquidDensity := InputData.LiquidDensity;
  Slg.InstallKind := InputData.InstallKind;
  Slg.IsFrameClosed := InputData.IsFrameClosed;
  Slg.DriveLocation := InputData.DriveLocation;
  Slg.HaveFixedGate := InputData.HaveFixedGate;
  Slg.ControlBlock := InputData.ControlBlock;
  Slg.HaveCounterFlange := InputData.HaveCounterFlange;
  Slg.HavePipeNodes := InputData.HavePipeNodes;
  Slg.BtwFrameTopAndDriveUnit := InputData.BtwFrameTopAndDriveUnit;

  Slg.IsSmall := (Slg.SlgKind = Surf) and (Slg.FrameWidth <= 1.5) and
    (Slg.GateHeight <= 1.5);

  if InputData.HydrHead.HasValue then
    Slg.HydrHead := InputData.HydrHead.Value
  else
    Slg.HydrHead := Slg.GateHeight;

  Slg.Leakage := CalcLeakage(Slg.SlgKind, Slg.FrameWidth, Slg.GateHeight);

  if Slg.SlgKind = Flow then
    Slg.WedgePairsCount := 0
  else if InputData.WedgePairsCount.HasValue then
    Slg.WedgePairsCount := InputData.WedgePairsCount.Value
  else
    Slg.WedgePairsCount := CalcWedgePairsCount(Slg.HydrHead, Slg.FrameWidth,
      Slg.GateHeight);

  Slg.IsRightHandedScrew := Slg.SlgKind = Flow;


  if InputData.Way.HasValue then
  begin
    Slg.Way := InputData.Way.Value;
    Assert(Slg.Way <= MaxWay(Slg.FrameHeight, Slg.GateHeight),
      'Слишком большой ход щита');
  end
  else
    Slg.Way := CalcWay(Slg.FrameHeight, Slg.GateHeight);

  if InputData.BethFrameTopAndGateTop.HasValue then
    Slg.BethFrameTopAndGateTop := InputData.BethFrameTopAndGateTop.Value
  else
    Slg.BethFrameTopAndGateTop := Slg.FrameHeight - Slg.GateHeight;

  if Slg.FrameHeight < CalcMinimalFrameHeightForNodes(Slg.GateHeight, Slg.Way) then
    Slg.HaveFrameNodes := False
  else if InputData.HaveFrameNodes.HasValue then
    Slg.HaveFrameNodes := InputData.HaveFrameNodes.Value
  else
    Slg.HaveFrameNodes := True;

  if (Slg.SlgKind <> Flow) and (not Slg.IsSmall) then
  begin
    Slg.BronzeWedgeStrip := '22x12';
    Slg.BronzeWedgeStripLength := 0.055 * Slg.WedgePairsCount * 2;
  end;

  Slg.Sleeve := CalcSleeve(Slg.IsScrewPullout);

  Slg.HydrForce := CalcHydrForce(Slg.FrameWidth, Slg.GateHeight,
    Slg.HydrHead, Slg.LiquidDensity);

  Slg.ScrewLength := CalcScrewLength(Slg.HaveFrameNodes, Slg.IsScrewPullout,
    Slg.HavePipeNodes, Slg.FrameHeight, Slg.Way, Slg.GateHeight,
    Slg.BtwFrameTopAndDriveUnit, Slg.DriveLocation);

  Slg.MinAxialForce := CalcMinAxialForce(Slg.HydrForce);

  if InputData.ScrewDiam.HasValue and InputData.ScrewPitch.HasValue then
    ChooseScrewByMatch(Slg.Screw, Slg.Nut, InputData.ScrewDiam.Value,
      InputData.ScrewPitch.Value, Slg.IsScrewPullout)
  else if ((Slg.DriveKind = OpenCloseActuator) or (Slg.DriveKind = RegulActuator)) and
    (InputData.Actuator <> nil) then
  begin
    if not ChooseScrewByPitchDiam(Slg.Screw, Slg.Nut, Slg.MinAxialForce,
      InputData.Actuator.MinTorque, InputData.Actuator.MaxTorque,
      Slg.ScrewLength, Slg.IsScrewPullout) then
      Exit(@ErrorCantChooseScrew);
  end
  else
  begin
    Slg.MinScrewInertiaMoment :=
      CalcMinInertiaMoment(Slg.MinAxialForce, RecommendFoS,
      Slg.ScrewLength, ScrewElast, ScrewMju);
    Slg.MinScrewMinorDiam := CalcDiamByInertiaMoment(Slg.MinScrewInertiaMoment);
    if not ChooseScrewByMinDiam(Slg.Screw, Slg.Nut, Slg.MinScrewMinorDiam,
      Slg.IsScrewPullout) then
      Exit(@ErrorCantChooseScrew);
  end;

  Slg.ThreadLength := CaclThreadLength(Slg.FrameHeight, Slg.Way,
    Slg.GateHeight, Slg.Nut, Slg.IsScrewPullout);

  Slg.MinTorque := CalcScrewTorque(Slg.MinAxialForce, Slg.Screw);
  Slg.Revs := Slg.Way / Slg.Screw.Pitch;

  case Slg.DriveKind of
    BevelGearbox, SpurGearbox:
    begin
      if InputData.Gearbox <> nil then
        Slg.Gearbox := InputData.Gearbox
      else if not ChooseGearbox(Slg.Gearbox, Slg.MinTorque,
        Slg.IsScrewPullout, Slg.Screw, InputData.ModelGearbox) then
        Exit(@ErrorCantChooseGearbox);
      Slg.Torque := Slg.MinTorque;
      Slg.CloseTorque := Slg.MinTorque;
    end;

    OpenCloseActuator, RegulActuator:
    begin
      if InputData.Actuator <> nil then
      begin
        Slg.MinSpeed := CalcMinSpeed(Slg.Revs, InputData.Actuator.Duty,
          InputData.FullWays);
        Slg.Actuator := InputData.Actuator;
      end
      else
      begin
        Slg.MinSpeed := CalcMinSpeed(Slg.Revs, InputData.ModelActuator[0, 0].Duty,
          InputData.FullWays);
        if not ChooseActuator(Slg.Actuator, Slg.MinTorque + DeltaOpen,
          Slg.IsScrewPullout, Slg.Screw, InputData.ModelActuator,
          Slg.SlgKind, Slg.MinSpeed, InputData.RecommendMinSpeed) then
          Exit(@ErrorCantChooseActuator);
      end;
      Slg.OpenTime := Slg.Revs / Slg.Actuator.Speed;
      if Slg.SlgKind = Flow then
      begin
        Slg.Torque := Max(Slg.Actuator.MinTorque, Slg.MinTorque);
        Slg.CloseTorque := Slg.Torque;
      end
      else
      begin
        Slg.Torque := Max(Slg.Actuator.MinTorque, Slg.MinTorque) + DeltaOpen;
        Slg.CloseTorque := Slg.Torque - DeltaOpen;
      end;
      CalcActuatorTemperatureRange(Slg.MinDriveUnitTemperature,
        Slg.MaxDriveUnitTemperature, Slg.Actuator, Slg.ControlBlock);
    end;
    else
    begin
      if (not Slg.IsScrewPullout) or
        // Slg.Screw.MajorDiam <= MaxPulloutScrew
        (CompareValue(Slg.Screw.MajorDiam, MaxPulloutScrew, 1e-6) <= 0) then
        ChooseHandWheel(Slg.HandWheel, Slg.MinTorque);
      Slg.Torque := Slg.MinTorque;
      Slg.CloseTorque := Slg.MinTorque;
    end;
  end;

  Slg.AxialForce := CalcAxialForce(Slg.CloseTorque, Slg.Screw);

  Slg.NutAxe := CalcNutAxe(Slg.AxialForce);

  Slg.ScrewFoS := CalcFoS(Slg.Screw.MinorDiam, Slg.ScrewLength,
    ScrewElast, Slg.AxialForce, ScrewMju);

  Slg.ScrewSlenderness := CalcSlendernessRatio(Slg.ScrewLength, Slg.Screw.MinorDiam);
end;

end.
