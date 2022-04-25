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
    ScrewsNumber: Integer;
    FrameSheet: TNullableReal;
    GateSheet: TNullableReal;
  end;

  TSlidegate = record
    ThreadLength: Double;
    MinScrewTorque: Double;
    MaxScrewTorque: Double;
    OpenTorque: Double;
    CloseTorque: Double;
    OpenTime: Double;
    Revs: Double;
    Gearbox: TGearbox;
    HandWheel: THandWheel;
    MinSpeed: Double;
    Actuator: TActuator;
    MaxDriveUnitTemperature: Double;
    MinDriveUnitTemperature: Double;
    ScrewFoS: Double;
    Screw: TScrew;
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
    IsRightHandedScrew2: Boolean;
    FrameHeight: Double;
    Way: Double;
    BethFrameTopAndGateTop: Double;
    HaveFrameNodes: Boolean;
    HydrForce: Double;
    ScrewLength: Double;
    MinScrewInertiaMoment: Double;
    MinScrewMinorDiam: Double;
    Nut: TNut;
    Sleeve: string;
    NutAxe: Double;
    ScrewSlenderness: Double;
    BronzeWedgeStrip: string;
    BronzeWedgeStripLength: Double;
    ControlBlock: TControlBlock;
    Leakage: Double;
    HaveCounterFlange: Boolean;
    HavePipeNodes: Boolean;
    BtwFrameTopAndDriveUnit: Double;
    IsSmall: Boolean;
    ScrewsNumber: Integer;
    GearboxNeed2InputShaft: Boolean;
    SealingLength: Double;
    Anchor12Numbers: Integer;
    Anchor16Numbers: Integer;
    AxialForce: Double;
    MaxAxialForce: Double;
  end;

  TFuncSlidegateError = function(const Slg: TSlidegate; const Lang: TLang): string;

procedure CalcSlidegate(out Slg: TSlidegate; const InputData: TInputData;
  out Error: TFuncSlidegateError);

function MinFrameHeight(const GateHeight: Double): Double;
function MaxWay(const FrameHeight, GateHeight: Double): Double;

const
  RackHeight = 0.76;  { m }
  SteelDensity = 8000;  { kg/m3 }

  MinFrameWidth = 0.3;
  MaxFrameWidth = 4;

  MinGateHeight = 0.3;
  MaxGateHeight = 4;

  MaxFrameHeight = 15.0;
  MaxHydrHead = 15.0;

implementation

uses
  SysUtils, Math, Measurements, CheckNum, Anchors, MathUtils;

const
  TopBalkHeight = 0.2;  { Metre }
  ScrewElast = SteelElast;
  ScrewFriction = 0.12;
  WedgeFriction = 0.12;
  SealingFriction = 0.5;
  DeltaOpen = 5.0;  { N*Metre }
  LimitShearStress = LimitShearStressAISI304;
  SpecificLeakage = 0.02;  { l/m/s }

  { Перешел с 1.0  - 10.01.2019 }
  ScrewMju = 0.7;

  { 45 кг по ГОСТ 21752-76 }
  MaxHandForce = 45 * GravAcc;

  { 2 кг/см уплотнения }
  SealingCompress = 2 * GravAcc / 0.01;

  { Момент привода на 15% больше расчетного. }
  ActuatorTorqueReserve = 1.15;

  { Перешел с 2.35 - 10.01.2019
    Перешел с 1.95 - 23.04.2021
    Перешел с 1.5  - 06.09.2021 }
  RecommendFoS = 1.26;

var
  ScrewFricAngle, WedgeFricAngle: Double;

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

{ The force F is given by (approximately)
        F = 10HA where F is in units of kN
  H is the maximum differential head at the centre of the door – metres.
  This should be the worst case which could occur.
  A is the door area in square metres }
function CalcHydrForce(const FrameWidth: Double; const GateHeight: Double;
  const HydrHead: Double; const LiquidDensity: Double): Double;
var
  HeadCentre: Double;
begin
  HeadCentre := HydrHead - GateHeight / 2;
  Result := (LiquidDensity * GravAcc) * HeadCentre * (FrameWidth * GateHeight);
end;

function CalcClosingAxialForce(const HydrForce, SealingLength: Double;
  const SlgKind: TSlgKind; const ScrewsNumber: Integer;
  const FrameWidth, GateHeight: Double): Double;
const
  { Условная толщина щита }
  CondThickness = 0.008;
var
  SealingForce, WedgeAngle, ApproxGateWeight: Double;
begin
  SealingForce := SealingLength * SealingCompress;
  if SlgKind = Flow then
    WedgeAngle := 0
  else
    WedgeAngle := DegToRad(15);
  ApproxGateWeight := SteelDensity * GravAcc * CondThickness * FrameWidth * GateHeight;
  Result := SealingFriction * SealingForce + (SealingForce + HydrForce) *
    Tan(WedgeFricAngle + WedgeAngle) - ApproxGateWeight;
  Result := Result / ScrewsNumber;
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

function CalcThreadLength(const FrameHeight, Way, GateHeight: Double;
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
    { 200 мм над рамой }
    Result := WorkLength + 0.2
  else
    { 50 мм запас }
    Result := WorkLength + Nut.Length + 0.05;

  if Result > MaxThreadLength then
    Result := MaxThreadLength;
end;

{ Return minimal rod inertia moment by axial force and its elasticity
  0.5 <= mju <= 2.0 }
function CalcMinInertiaMoment(const AxialForce: Double; const FoS: Double;
  const RodLength: Double): Double;
begin
  Result := AxialForce * FoS * (ScrewMju * RodLength / Pi) ** 2 / ScrewElast;
end;

{ The calculation of cross-section diameter by its moment of inertia. }
function CalcDiamByInertiaMoment(const MomentIner: Double): Double;
begin
  Result := (MomentIner * 64 / Pi) ** 0.25;
end;

function CalcScrewTorque(const AxialForce: Double; const Screw: TScrew;
  const BearingDiam, SlidingCoeff: Double): Double;
begin
  Result := AxialForce * Tan(ScrewFricAngle + Screw.ThreadAngle) *
    Screw.PitchDiam / 2 + SlidingCoeff * AxialForce * ScrewFriction * BearingDiam / 2;
end;

function CalcMaxScrewTorque(const Screw: TScrew;
  const RodLength, BearingDiam, SlidingCoeff: Double): Double;
var
  InertiaMoment, MaxAxialForce: Double;
begin
  InertiaMoment := Pi * Screw.MinorDiam ** 4 / 64;
  MaxAxialForce := InertiaMoment * ScrewElast / RecommendFoS /
    (ScrewMju * RodLength / Pi) ** 2;
  Result := CalcScrewTorque(MaxAxialForce, Screw, BearingDiam, SlidingCoeff);
end;

{ Return axial inertia moment of circular section by its diameter }
function CalcCircleAxialInertiaMoment(const Diam: Double): Double;
begin
  Result := Pi * Diam ** 4 / 64;
end;

{ Calculation factor of safity in screw by axial force }
function CalcFoS(const ScrewMinorDiam: Double; const ScrewLength: Double;
  const ScrewElast: Double; const AxialForce: Double; const Mju: Double): Double;
begin
  Result := CalcCircleAxialInertiaMoment(ScrewMinorDiam) * ScrewElast * Sqr(Pi) /
    AxialForce / Sqr(Mju * ScrewLength);
end;

function CalcAxialForce(const Torque: Double; const Screw: TScrew;
  const BearingDiam, SlidingCoeff: Double): Double;
begin
  Result := 2 * Torque / (Screw.PitchDiam * Tan(ScrewFricAngle + Screw.ThreadAngle) +
    SlidingCoeff * ScrewFriction * BearingDiam);
end;

procedure SetScrewAndNut(var Screw: TScrew; var Nut: TNut; const Index: Integer;
  const IsScrewPullout: Boolean);
begin
  Screw := StdScrews[Index].Screw;
  Nut := GetNut(StdScrews[Index], IsScrewPullout);
end;

function ChooseScrewByMinDiam(var Screw: TScrew; var Nut: TNut;
  const MinRod: Double; const IsScrewPullout: Boolean): Integer;
const
  NotFound = -1;
var
  I: Integer;
begin
  Result := NotFound;
  I := 0;
  while (I <= High(StdScrews)) and (Result = NotFound) do
  begin
    if StdScrews[I].Screw.MinorDiam >= MinRod then
    begin
      SetScrewAndNut(Screw, Nut, I, IsScrewPullout);
      Result := I;
    end;
    Inc(I);
  end;
end;

function ChooseGearbox(var Gearbox: TGearbox; const RequiredTorque: Double;
  const IsScrewPullout: Boolean; const Screw: TScrew;
  const ModelGearbox: TModelGearbox; const Need2InputShaft: Boolean): Boolean;
var
  I, J: Integer;
begin
  Result := False;
  I := 0;
  while (I <= High(ModelGearbox)) and (not Result) do
  begin
    J := 0;
    while (J <= High(ModelGearbox[I])) and (not Result) do
    begin
      if (ModelGearbox[I, J].MaxTorque >= RequiredTorque) and
        ((not IsScrewPullout) or
        (CompareValue(ModelGearbox[I, J].MaxScrew, Screw.MajorDiam, CompAccuracy) >=
        0)) and ((not Need2InputShaft) or ModelGearbox[I, J].CanHave2InputShaft) then
      begin
        Gearbox := ModelGearbox[I, J];
        Result := True;
      end;
      Inc(J);
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
      OpenTimeForFullWays := Minute(12);
    S230, S450:
      OpenTimeForFullWays := Minute(27);
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
    { from 10.2 }
    I := 2
  else
    { from 07.6 }
    I := 1;
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

function CalcHandWheelDiam(const RequiredTorque, HandForce: Double): Double;
begin
  Result := 2 * RequiredTorque / HandForce;
end;

function TryChooseHandWheelByDiam(const Diam, ScrewDiam: Double;
  const IsScrewPullout: Boolean; const DriveKind: TDriveKind;
  const ScrewsNumber: Integer): THandWheel;
var
  I: Integer;
  IsThroughWheel: Boolean;
begin
  Result := nil;
  IsThroughWheel := IsScrewPullout and (DriveKind = HandWheel) and (ScrewsNumber = 1);
  I := 0;
  while (I <= High(HandWheels)) and (Result = nil) do
  begin
    if (CompareValue(Diam, HandWheels[I].Diameter, CompAccuracy) <= 0) then
      if (not IsThroughWheel) or
        (CompareValue(ScrewDiam, HandWheels[I].MaxScrew, CompAccuracy) <= 0) then
        Result := HandWheels[I];
    Inc(I);
  end;
end;

procedure ChooseHandWheel(var HandWheel: THandWheel; const RequiredTorque: Double;
  const IsScrewPullout: Boolean; const ScrewDiam: Double;
  const DriveKind: TDriveKind; const ScrewsNumber: Integer);
var
  MinDiam: Double;
begin
  MinDiam := CalcHandWheelDiam(RequiredTorque, MaxHandForce);
  HandWheel := TryChooseHandWheelByDiam(MinDiam, ScrewDiam, IsScrewPullout,
    DriveKind, ScrewsNumber);
  if HandWheel = nil then
    { двуплечая рукоятка }
    HandWheel := THandWheel.Create('', '', MinDiam, Nm(0), 1, Kg(0), Mm(0));
end;

function CalcSleeve(const IsScrewPullout: Boolean): string;
begin
  if IsScrewPullout then
    Result := A
  else
    Result := B1;
end;

function CalcNutAxe(const AxialForce, Torque, ShaftDiam: Double): Double;
const
  AxesNumber = 2;
var
  P1, P2, PRes: Double;
begin
  P1 := AxialForce / AxesNumber;
  P2 := Torque * 2 / ShaftDiam / AxesNumber;
  PRes := Sqrt(Sqr(P1) + Sqr(P2));
  Result := Sqrt(4 * PRes / Pi / LimitShearStress);
end;

{ Для полного круга Angle = 2 * Pi }
function CalcAreaCircleOfDiam(const Diam: Double; const Angle: Double): Double;
begin
  Result := Angle * Sqr(Diam) / 8;
end;

function CalcSlendernessRatio(const ScrewLength: Double; const RodDiam: Double): Double;
begin
  Result := ScrewLength / CircleInertiaRadius(RodDiam);
end;

{ Участвует в силовом расчете (не добавлять запас). }
function CalcSealingLength(const Kind: TSlgKind;
  const FrameWidth, GateHeight: Double): Double;
begin
  if Kind = Deep then
    Result := GateHeight * 2 + FrameWidth * 2
  else
    Result := GateHeight * 2 + FrameWidth;
end;

function CalcLeakage(const SealingLength: Double): Double;
begin
  Result := SpecificLeakage * SealingLength * 60;  { l/min }
end;

function ErrorCantChooseScrew(const Slg: TSlidegate; const Lang: TLang): string;
begin
  if Slg.MinScrewMinorDiam > 0 then
    Result := L10nOut[20, Lang] + ' ' + Format(L10nOut[26, Lang],
      [ToMm(Slg.MinScrewMinorDiam)])
  else
    Result := L10nOut[20, Lang];
end;

function ErrorCantChooseGearbox(const Slg: TSlidegate; const Lang: TLang): string;
begin
  Result := Format(L10nOut[27, Lang], [Slg.MinScrewTorque]);
end;

function ErrorCantChooseActuator(const Slg: TSlidegate; const Lang: TLang): string;
begin
  Result := Format(L10nOut[28, Lang], [Slg.MinScrewTorque, ToRpm(Slg.MinSpeed)]);
end;

function CalcAnchorsNumberByTension(const Force: Double; const Anchor: TAnchor): Integer;
begin
  Result := Ceil(Force / Anchor.RecomendTensionLoad);
end;

function CalcMaxScrewTorqueByHand(const HandWheelDiam, Ratio, HandForce: Double;
  const ScrewsNumber: Integer): Double;
begin
  Result := HandForce * HandWheelDiam / 2 * Ratio / ScrewsNumber;
end;

function DetectHaveFriction(const IsSmall, IsScrewPullout: Boolean;
  const DriveKind: TDriveKind): Boolean;
begin
  if IsScrewPullout then
    Result := DriveKind = HandWheel
  else
    Result := IsSmall;
end;

function CalcHandForce(const Torque, Diam: Double): Double;
begin
  Result := 2 * Torque / Diam;
end;

function CalcIsSmall(const SlgKind: TSlgKind;
  const FrameWidth, GateHeight, ScrewDiam: Double): Boolean;
begin
  Result := (SlgKind = Surf) and (FrameWidth <= 1.5) and (GateHeight <= 1.5) and
    (ScrewDiam <= Mm(30));
end;

procedure CalcScrewAndDrive(var Slg: TSlidegate; const InputData: TInputData;
  out Error: TFuncSlidegateError);
var
  MinActuatorTorque, BearingDiam, SlidingCoeff: Double;
begin
  Error := nil;

  Slg.IsSmall := CalcIsSmall(Slg.SlgKind, Slg.FrameWidth, Slg.GateHeight,
    Slg.Screw.MajorDiam);
  Slg.ThreadLength := CalcThreadLength(Slg.FrameHeight, Slg.Way,
    Slg.GateHeight, Slg.Nut, Slg.IsScrewPullout);
  BearingDiam := 1.5 * Slg.Screw.MajorDiam;
  if DetectHaveFriction(Slg.IsSmall, Slg.IsScrewPullout, Slg.DriveKind) then
    SlidingCoeff := 1
  else
    SlidingCoeff := 0.1;
  Slg.MinScrewTorque := CalcScrewTorque(Slg.AxialForce, Slg.Screw,
    BearingDiam, SlidingCoeff);
  Slg.Revs := Slg.Way / Slg.Screw.Pitch;

  if Slg.ScrewsNumber > 1 then
  begin
    if (Slg.Gearbox = nil) and not ChooseGearbox(Slg.Gearbox,
      Slg.MinScrewTorque, Slg.IsScrewPullout, Slg.Screw, InputData.ModelGearbox,
      Slg.GearboxNeed2InputShaft) then
    begin
      Error := @ErrorCantChooseGearbox;
      Exit;
    end;
    Slg.Revs := Slg.Revs * Slg.GearBox.Ratio;
  end;

  case Slg.DriveKind of
    BevelGearbox, SpurGearbox:
    begin
      if (Slg.Gearbox = nil) and not ChooseGearbox(Slg.Gearbox,
        Slg.MinScrewTorque, Slg.IsScrewPullout, Slg.Screw, InputData.ModelGearbox,
        Slg.GearboxNeed2InputShaft) then
      begin
        Error := @ErrorCantChooseGearbox;
        Exit;
      end;
      Slg.CloseTorque := Slg.MinScrewTorque / Slg.Gearbox.Ratio * Slg.ScrewsNumber;
      Slg.OpenTorque := Slg.CloseTorque;

      if (Slg.ScrewsNumber > 1) or (Slg.Gearbox.HandWheelDiam <= 0) then
      begin
        ChooseHandWheel(Slg.HandWheel, Slg.CloseTorque, Slg.IsScrewPullout,
          Slg.Screw.MajorDiam, Slg.DriveKind, Slg.ScrewsNumber);
        Slg.MaxScrewTorque := CalcMaxScrewTorqueByHand(Slg.HandWheel.Diameter,
          Slg.Gearbox.Ratio, MaxHandForce, Slg.ScrewsNumber);
      end
      else { один редуктор со своим штурвалом }
        Slg.MaxScrewTorque := Max(CalcMaxScrewTorqueByHand(Slg.Gearbox.HandWheelDiam,
          Slg.Gearbox.Ratio, Kgf(20), Slg.ScrewsNumber), Slg.MinScrewTorque);
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

        if Slg.ScrewsNumber > 1 then
          MinActuatorTorque :=
            Slg.MinScrewTorque * ActuatorTorqueReserve / Slg.Gearbox.Ratio *
            Slg.ScrewsNumber
        else
          MinActuatorTorque := Slg.MinScrewTorque * ActuatorTorqueReserve;

        if not ChooseActuator(Slg.Actuator, MinActuatorTorque +
          DeltaOpen, Slg.IsScrewPullout, Slg.Screw, InputData.ModelActuator,
          Slg.SlgKind, Slg.MinSpeed, InputData.RecommendMinSpeed) then
        begin
          Error := @ErrorCantChooseActuator;
          Exit;
        end;
      end;
      Slg.OpenTime := Slg.Revs / Slg.Actuator.Speed;
      Slg.CloseTorque := Max(Slg.Actuator.MinTorque, MinActuatorTorque);
      if Slg.SlgKind = Flow then
        Slg.OpenTorque := Slg.CloseTorque
      else
        Slg.OpenTorque := Slg.CloseTorque + DeltaOpen;
      if Slg.ScrewsNumber > 1 then
        Slg.MaxScrewTorque := Slg.CloseTorque * Slg.Gearbox.Ratio / Slg.ScrewsNumber
      else
        Slg.MaxScrewTorque := Slg.CloseTorque;
      CalcActuatorTemperatureRange(Slg.MinDriveUnitTemperature,
        Slg.MaxDriveUnitTemperature, Slg.Actuator, Slg.ControlBlock);
    end;

    else { штурвалы }
    begin
      if Slg.ScrewsNumber > 1 then
      begin
        ChooseHandWheel(Slg.HandWheel, Slg.MinScrewTorque, False,
          Slg.Screw.MajorDiam, Slg.DriveKind, Slg.ScrewsNumber);
        Slg.CloseTorque := Slg.MinScrewTorque / Slg.Gearbox.Ratio * Slg.ScrewsNumber;
        Slg.MaxScrewTorque := CalcMaxScrewTorqueByHand(Slg.HandWheel.Diameter,
          Slg.Gearbox.Ratio, MaxHandForce, Slg.ScrewsNumber);
      end
      else
      begin
        ChooseHandWheel(Slg.HandWheel, Slg.MinScrewTorque, Slg.IsScrewPullout,
          Slg.Screw.MajorDiam, Slg.DriveKind, Slg.ScrewsNumber);
        Slg.CloseTorque := Slg.MinScrewTorque;
        Slg.MaxScrewTorque := CalcMaxScrewTorqueByHand(Slg.HandWheel.Diameter,
          1, MaxHandForce, Slg.ScrewsNumber);
      end;
      Slg.OpenTorque := Slg.CloseTorque;
    end;
  end;

  Slg.MaxAxialForce := CalcAxialForce(Slg.MaxScrewTorque, Slg.Screw,
    BearingDiam, SlidingCoeff);
  Slg.ScrewFoS := RoundMultiple(CalcFoS(Slg.Screw.MinorDiam, Slg.ScrewLength,
    ScrewElast, Slg.MaxAxialForce, ScrewMju), 0.01);
end;

procedure CheckEnlargedScrew(var Slg: TSlidegate; const Raw: TSlidegate;
  const InputData: TInputData; StdScrewIndex: Integer);
var
  Error: TFuncSlidegateError;
  IsFounded: Boolean;
  Tmp: TSlidegate;
begin
  repeat
    IsFounded := False;
    if StdScrewIndex < High(StdScrews) then
    begin
      Tmp := Raw;
      Inc(StdScrewIndex);
      SetScrewAndNut(Tmp.Screw, Tmp.Nut, StdScrewIndex, Tmp.IsScrewPullout);
      CalcScrewAndDrive(Tmp, InputData, Error);
      IsFounded := (Error = nil) and
        (CompareValue(Tmp.ScrewFoS, RecommendFoS, CompAccuracy) >= 0);
      if IsFounded then
        Slg := Tmp;
    end;
  until IsFounded;
end;

procedure CheckReducedScrew(var Slg: TSlidegate; const Raw: TSlidegate;
  const InputData: TInputData; StdScrewIndex: Integer);
var
  Error: TFuncSlidegateError;
  IsFounded: Boolean;
  Tmp: TSlidegate;
begin
  repeat
    IsFounded := False;
    if StdScrewIndex > 0 then
    begin
      Tmp := Raw;
      Dec(StdScrewIndex);
      SetScrewAndNut(Tmp.Screw, Tmp.Nut, StdScrewIndex, Tmp.IsScrewPullout);
      CalcScrewAndDrive(Tmp, InputData, Error);
      IsFounded := (Error = nil) and
        (CompareValue(Tmp.ScrewFoS, RecommendFoS, CompAccuracy) >= 0);
      if IsFounded then
        Slg := Tmp;
    end;
  until not IsFounded;
end;

function CalcAnchorsNumberByShear(const Force: Double; const Anchor: TAnchor): Integer;
begin
  Result := Ceil(Force / Anchor.RecomendShearLoad);
end;

procedure CalcSlidegate(out Slg: TSlidegate; const InputData: TInputData;
  out Error: TFuncSlidegateError);
var
  Raw: TSlidegate;
  StdScrewIndex: Integer;
begin
  Slg := Default(TSlidegate);
  Error := nil;

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
  Slg.ScrewsNumber := InputData.ScrewsNumber;
  Slg.Gearbox := InputData.Gearbox;

  Slg.GearboxNeed2InputShaft :=
    (Slg.ScrewsNumber > 1) and (Slg.DriveKind <> OpenCloseActuator) and
    (Slg.DriveKind <> RegulActuator);

  if InputData.HydrHead.HasValue then
    Slg.HydrHead := InputData.HydrHead.Value
  else
    Slg.HydrHead := Slg.GateHeight;

  Slg.SealingLength := CalcSealingLength(Slg.SlgKind, Slg.FrameWidth, Slg.GateHeight);
  Slg.Leakage := CalcLeakage(Slg.SealingLength);

  if Slg.SlgKind = Flow then
    Slg.WedgePairsCount := 0
  else if InputData.WedgePairsCount.HasValue then
    Slg.WedgePairsCount := InputData.WedgePairsCount.Value
  else
    Slg.WedgePairsCount := CalcWedgePairsCount(Slg.HydrHead, Slg.FrameWidth,
      Slg.GateHeight);

  Slg.IsRightHandedScrew := Slg.SlgKind = Flow;
  { TODO: if Tramec then 1 = 2 }
  if Slg.ScrewsNumber > 1 then
    Slg.IsRightHandedScrew2 := not Slg.IsRightHandedScrew;

  if InputData.Way.HasValue then
  begin
    Slg.Way := InputData.Way.Value;
    Assert(CompareValue(Slg.Way, MaxWay(Slg.FrameHeight, Slg.GateHeight),
      CompAccuracy) <= 0, 'Слишком большой ход щита');
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

  Slg.Sleeve := CalcSleeve(Slg.IsScrewPullout);

  Slg.HydrForce := CalcHydrForce(Slg.FrameWidth, Slg.GateHeight,
    Slg.HydrHead, Slg.LiquidDensity);

  Slg.ScrewLength := CalcScrewLength(Slg.HaveFrameNodes, Slg.IsScrewPullout,
    Slg.HavePipeNodes, Slg.FrameHeight, Slg.Way, Slg.GateHeight,
    Slg.BtwFrameTopAndDriveUnit, Slg.DriveLocation);

  Slg.AxialForce := CalcClosingAxialForce(Slg.HydrForce, Slg.SealingLength,
    Slg.SlgKind, Slg.ScrewsNumber, Slg.FrameWidth, Slg.GateHeight);

  if InputData.ScrewDiam.HasValue and InputData.ScrewPitch.HasValue then
    ChooseScrewByMatch(Slg.Screw, Slg.Nut, InputData.ScrewDiam.Value,
      InputData.ScrewPitch.Value, Slg.IsScrewPullout)
  else
  begin
    Slg.MinScrewInertiaMoment :=
      CalcMinInertiaMoment(Slg.AxialForce, RecommendFoS, Slg.ScrewLength);
    Slg.MinScrewMinorDiam := CalcDiamByInertiaMoment(Slg.MinScrewInertiaMoment);
    StdScrewIndex := ChooseScrewByMinDiam(Slg.Screw, Slg.Nut,
      Slg.MinScrewMinorDiam, Slg.IsScrewPullout);
    if StdScrewIndex < 0 then
    begin
      Error := @ErrorCantChooseScrew;
      Exit;
    end;

    (* if ((Slg.DriveKind = OpenCloseActuator) or (Slg.DriveKind = RegulActuator)) and
      (InputData.Actuator <> nil) then
    begin
      if not ChooseScrewByPitchDiam(Slg.Screw, Slg.Nut, Slg.Gearbox,
        Slg.AxialForce, InputData.Actuator.MinTorque, InputData.Actuator.MaxTorque,
        Slg.ScrewLength, Slg.IsScrewPullout, Slg.ScrewsNumber,
        InputData.ModelGearbox, Slg.GearboxNeed2InputShaft) then
        Exit(@ErrorCantChooseScrew);
    end
    else if ((Slg.DriveKind = BevelGearbox) or (Slg.DriveKind = SpurGearbox)) and
      (InputData.Gearbox <> nil) then
    begin
      if not ChooseScrewByPitchDiam(Slg.Screw, Slg.Nut, Slg.Gearbox,
        Slg.AxialForce, 0, InputData.Gearbox.MaxTorque, Slg.ScrewLength,
        Slg.IsScrewPullout, Slg.ScrewsNumber, InputData.ModelGearbox,
        Slg.GearboxNeed2InputShaft) then
        Exit(@ErrorCantChooseScrew);
    end; *)
  end;

  Raw := Slg;
  CalcScrewAndDrive(Slg, InputData, Error);
  if Error <> nil then
    Exit;
  if not (InputData.ScrewDiam.HasValue and InputData.ScrewPitch.HasValue) then
  begin
    if Slg.ScrewFoS > RecommendFoS then
      CheckReducedScrew(Slg, Raw, InputData, StdScrewIndex)
    else if Slg.ScrewFoS < RecommendFoS then
      CheckEnlargedScrew(Slg, Raw, InputData, StdScrewIndex);
  end;

  if (Slg.SlgKind <> Flow) and (not Slg.IsSmall) then
  begin
    Slg.BronzeWedgeStrip := '22x12';
    Slg.BronzeWedgeStripLength := 0.055 * Slg.WedgePairsCount * 2;
  end;

  Slg.NutAxe := CalcNutAxe(Slg.MaxAxialForce, Slg.MaxScrewTorque, Slg.Screw.MinorDiam);
  Slg.ScrewSlenderness := CalcSlendernessRatio(Slg.ScrewLength, Slg.Screw.MinorDiam);
  if Slg.InstallKind = Wall then
  begin
    Slg.Anchor12Numbers := CalcAnchorsNumberByTension(Slg.HydrForce, Mungo[0]);
    Slg.Anchor16Numbers := CalcAnchorsNumberByTension(Slg.HydrForce, Mungo[1]);
  end
  else if Slg.InstallKind = Channel then
  begin
    Slg.Anchor12Numbers := CalcAnchorsNumberByShear(Slg.HydrForce, Mungo[0]);
    Slg.Anchor16Numbers := CalcAnchorsNumberByShear(Slg.HydrForce, Mungo[1]);
  end;
end;

initialization
  ScrewFricAngle := ArcTan(ScrewFriction);
  WedgeFricAngle := ArcTan(WedgeFriction);
end.
