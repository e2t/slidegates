unit DriveUnits;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses Fgl;

type
  TActuatorType = (AumaSA, AumaSAR);
  {$PUSH} {$SCOPEDENUMS ON}
  TGearboxType = (AumaGK, AumaGST, TramecR, MechanicRZAM, RotorkIB);
  {$POP}
  TControlBlock = (NoBlock, AumaAM, AumaAC);
  TControlBlockNames = specialize TFPGMap<TControlBlock, string>;

  TControl = class
    abstract
    Brand: string;
    Name: string;
    MaxTorque: Double;
    Ratio: Double;
    Mass: Double;
    MaxScrew: Double;
    constructor Create(const ABrand: string; const AName: string;
      const AMaxTorque: Double; const ARatio: Double; const AMass: Double;
      const AMaxScrew: Double);
  end;

  THandWheel = class(TControl)
    Diameter: Double;
    constructor Create(const ABrand: string; const AName: string;
      const ADiameter: Double; const AMaxTorque: Double; const ARatio: Double;
      const AMass: Double; const AMaxScrew: Double);
  end;

  TDriveUnit = class abstract(TControl)
    Flange: string;
    constructor Create(const ABrand: string; const AName: string;
      const AMaxTorque: Double; const ARatio: Double; const AMass: Double;
      const AFlange: string; const AMaxScrew: Double);
  end;

  TActuator = class(TDriveUnit)
    Speed: Double;
    MinTorque: Double;
    Power: Double;
    Duty: string;
    ControlBlockNames: TControlBlockNames;
    ActuatorType: TActuatorType;
    constructor Create(const ABrand: string; const AActuatorType: TActuatorType;
      const AName: string; const AMaxTorque: Double; const ARatio: Double;
      const AMass: Double; const AFlange: string; const AMaxScrew: Double;
      const ASpeed: Double; const AMinTorque: Double; const APower: Double;
      const ADuty: string);
    constructor CreateAuma(const AActuatorType: TActuatorType;
      const AName: string; const AMaxTorque: Double; const ARatio: Double;
      const AMass: Double; const AFlange: string; const AMaxScrew: Double;
      const ASpeed: Double; const AMinTorque: Double; const APower: Double;
      const ADuty: string; const ControlAM: string; const ControlAC: string);
  end;

  TGearbox = class(TDriveUnit)
    GearboxType: TGearboxType;
    CanHave2InputShaft: Boolean;
    HandWheelDiam: Double;
    NominalRatio: Double;
    constructor Create(const ABrand: string; const AGearboxType: TGearboxType;
      const AName: string; const AMaxTorque: Double; const ANominalRatio: Double;
      const ARatio: Double; const AMass: Double; const AFlange: string;
      const AMaxScrew: Double; const ACanHave2InputShaft: Boolean;
      const AHandWheelDiam: Double);
  end;

  TArrayActuator = array of TActuator;
  TArrayGearbox = array of TGearbox;
  TModelActuator = array of TArrayActuator;
  TModelGearbox = array of TArrayGearbox;

const
  A = 'A';
  B1 = 'B1';
  S215 = 'S2-15 min';
  S230 = 'S2-30 min';
  S425 = 'S4-25%';
  S450 = 'S4-50%';
  SAM = ' + AM (АUMA МATIC)';
  SAC = ' + AC (АUMATIC)';

  SAuma = 'AUMA';
  SAumaSAS215 = 'AUMA SA (S2-15min)';
  SAumaSAS215AM = 'AUMA SA (S2-15min)' + SAM;
  SAumaSAS215AC = 'AUMA SA (S2-15min)' + SAC;
  SAumaSAS230 = 'AUMA SA (S2-30min)';
  SAumaSAS230AM = 'AUMA SA (S2-30min)' + SAM;
  SAumaSAS230AC = 'AUMA SA (S2-30min)' + SAC;
  SAumaSARS425 = 'AUMA SAR (S4-25%)';
  SAumaSARS425AM = 'AUMA SAR (S4-25%)' + SAM;
  SAumaSARS425AC = 'AUMA SAR (S4-25%)' + SAC;
  SAumaSARS450 = 'AUMA SAR (S4-50%)';
  SAumaSARS450AM = 'AUMA SAR (S4-50%)' + SAM;
  SAumaSARS450AC = 'AUMA SAR (S4-50%)' + SAC;
  SAumaGK = 'AUMA GK';
  SAumaGST = 'AUMA GST';

  STramec = 'Tramec';
  STramecR = 'Tramec R';

  SMechanic = 'ООО «МИП „Механик“»';
  SMechanicRZAM = 'ООО «МИП „Механик“» РЗАМ';

  SRotork = 'Rotork';
  SRotorkIB = 'Rotork IB';

var
  AumaSADutyS215, AumaSADutyS230: TModelActuator;
  AumaSARDutyS425, AumaSARDutyS450: TModelActuator;
  AumaGK, TramecR, MechanicRZAM, RotorkIB: TModelGearbox;
  AumaGST: TModelGearbox;
  HandWheels: array [0..2] of THandWheel;

implementation

uses
  Measurements;

constructor TControl.Create(const ABrand: string; const AName: string;
  const AMaxTorque: Double; const ARatio: Double; const AMass: Double;
  const AMaxScrew: Double);
begin
  Brand := ABrand;
  Name := AName;
  MaxTorque := AMaxTorque;
  Ratio := ARatio;
  Mass := AMass;
  MaxScrew := AMaxScrew;
end;

constructor THandWheel.Create(const ABrand: string; const AName: string;
  const ADiameter: Double; const AMaxTorque: Double; const ARatio: Double;
  const AMass: Double; const AMaxScrew: Double);
begin
  inherited Create(ABrand, AName, AMaxTorque, ARatio, AMass, AMaxScrew);
  Diameter := ADiameter;
end;

constructor TDriveUnit.Create(const ABrand: string; const AName: string;
  const AMaxTorque: Double; const ARatio: Double; const AMass: Double;
  const AFlange: string; const AMaxScrew: Double);
begin
  inherited Create(ABrand, AName, AMaxTorque, ARatio, AMass, AMaxScrew);
  Flange := AFlange;
end;

constructor TActuator.Create(const ABrand: string; const AActuatorType: TActuatorType;
  const AName: string; const AMaxTorque: Double; const ARatio: Double;
  const AMass: Double; const AFlange: string; const AMaxScrew: Double;
  const ASpeed: Double; const AMinTorque: Double; const APower: Double;
  const ADuty: string);
begin
  inherited Create(ABrand, AName, AMaxTorque, ARatio,
    AMass, AFlange, AMaxScrew);
  Speed := ASpeed;
  MinTorque := AMinTorque;
  Power := APower;
  Duty := ADuty;
  ControlBlockNames := TControlBlockNames.Create;
  ActuatorType := AActuatorType;
end;

constructor TActuator.CreateAuma(const AActuatorType: TActuatorType;
  const AName: string; const AMaxTorque: Double; const ARatio: Double;
  const AMass: Double; const AFlange: string; const AMaxScrew: Double;
  const ASpeed: Double; const AMinTorque: Double; const APower: Double;
  const ADuty: string; const ControlAM: string; const ControlAC: string);
begin
  Create(SAuma, AActuatorType, AName, AMaxTorque, ARatio, AMass,
    AFlange, AMaxScrew, ASpeed,
    AMinTorque, APower, ADuty);
  ControlBlockNames[AumaAM] := ControlAM;
  ControlBlockNames[AumaAC] := ControlAC;
end;

constructor TGearbox.Create(const ABrand: string; const AGearboxType: TGearboxType;
  const AName: string; const AMaxTorque: Double; const ANominalRatio: Double;
  const ARatio: Double; const AMass: Double; const AFlange: string;
  const AMaxScrew: Double; const ACanHave2InputShaft: Boolean;
  const AHandWheelDiam: Double);
begin
  inherited Create(ABrand, AName, AMaxTorque, ARatio, AMass, AFlange, AMaxScrew);
  GearboxType := AGearboxType;
  CanHave2InputShaft := ACanHave2InputShaft;
  HandWheelDiam := AHandWheelDiam;
  NominalRatio := ANominalRatio;
  Assert(NominalRatio >= Ratio);
end;

const
  SA072 = 'SA 07.2';
  SA076 = 'SA 07.6';
  SA102 = 'SA 10.2';
  SA142 = 'SA 14.2';
  SA146 = 'SA 14.6';
  SA162 = 'SA 16.2';
  SA251 = 'SA 25.1';
  SA301 = 'SA 30.1';
  SA351 = 'SA 35.1';
  SA401 = 'SA 40.1';
  SA481 = 'SA 48.1';

  SAR072 = 'SAR 07.2';
  SAR076 = 'SAR 07.6';
  SAR102 = 'SAR 10.2';
  SAR142 = 'SAR 14.2';
  SAR146 = 'SAR 14.6';
  SAR162 = 'SAR 16.2';
  SAR251 = 'SAR 25.1';
  SAR301 = 'SAR 30.1';

  GK102 = 'GK 10.2';
  GK142 = 'GK 14.2';
  GK146 = 'GK 14.6';
  GK162 = 'GK 16.2';
  GK252 = 'GK 25.2';
  GK302 = 'GK 30.2';
  GK352 = 'GK 35.2';
  GK402 = 'GK 40.2';

  GST101 = 'GST 10.1';
  GST141 = 'GST 14.1';
  GST145 = 'GST 14.5';
  GST161 = 'GST 16.1';
  GST251 = 'GST 25.1';
  GST301 = 'GST 30.1';
  GST351 = 'GST 35.1';
  GST401 = 'GST 40.1';

  IBN5 = 'IBN5';
  IBN7 = 'IBN7';
  IBN9 = 'IBN9';
  IBN11 = 'IBN11';
  IBN13 = 'IBN13';
  IBN14 = 'IBN14';

  RZAM500 = 'РЗАМ-С-500';
  RZAM1000 = 'РЗАМ-С-1000';
  RZAM2500 = 'РЗАМ-С-2500';
  RZAMS210000 = 'РЗАМ-С2-10000';

  F07 = 'F07';
  F10 = 'F10';
  F14 = 'F14';
  F16 = 'F16';
  F25 = 'F25';
  F30 = 'F30';
  F35 = 'F35';
  F40 = 'F40';
  F48 = 'F48';

  AM011 = 'AM 01.1';
  AM021 = 'AM 02.1';
  AC012 = 'AC 01.2';
{ AC 01.1 - не выпускается (Рудакова, 02.04.2020) }

var
  AumaSA072DutyS215: array [0..11] of TActuator;
  AumaSA072DutyS230: array [0..11] of TActuator;

  AumaSA076DutyS215: array [0..11] of TActuator;
  AumaSA076DutyS230: array [0..11] of TActuator;

  AumaSA102DutyS215: array [0..11] of TActuator;
  AumaSA102DutyS230: array [0..11] of TActuator;

  AumaSA142DutyS215: array [0..11] of TActuator;
  AumaSA142DutyS230: array [0..11] of TActuator;

  AumaSA146DutyS215: array [0..11] of TActuator;
  AumaSA146DutyS230: array [0..11] of TActuator;

  AumaSA162DutyS215: array [0..11] of TActuator;
  AumaSA162DutyS230: array [0..11] of TActuator;

  AumaSA251DutyS215: array [0..9] of TActuator;
  AumaSA251DutyS230: array [0..9] of TActuator;

  AumaSA301DutyS215: array [0..9] of TActuator;
  AumaSA301DutyS230: array [0..9] of TActuator;

  AumaSA351DutyS215: array [0..7] of TActuator;
  AumaSA351DutyS230: array [0..7] of TActuator;

  AumaSA401DutyS215: array [0..6] of TActuator;
  AumaSA401DutyS230: array [0..6] of TActuator;

  AumaSA481DutyS215: array [0..4] of TActuator;
  AumaSA481DutyS230: array [0..4] of TActuator;

  AumaSAR072DutyS425: array [0..9] of TActuator;
  AumaSAR072DutyS450: array [0..9] of TActuator;

  AumaSAR076DutyS425: array [0..9] of TActuator;
  AumaSAR076DutyS450: array [0..9] of TActuator;

  AumaSAR102DutyS425: array [0..9] of TActuator;
  AumaSAR102DutyS450: array [0..9] of TActuator;

  AumaSAR142DutyS425: array [0..9] of TActuator;
  AumaSAR142DutyS450: array [0..9] of TActuator;

  AumaSAR146DutyS425: array [0..9] of TActuator;
  AumaSAR146DutyS450: array [0..9] of TActuator;

  AumaSAR162DutyS425: array [0..9] of TActuator;
  AumaSAR162DutyS450: array [0..9] of TActuator;

  AumaSAR251DutyS425: array [0..3] of TActuator;
  AumaSAR251DutyS450: array [0..3] of TActuator;

  AumaSAR301DutyS425: array [0..3] of TActuator;
  AumaSAR301DutyS450: array [0..3] of TActuator;

  AumaGK102: array [0..1] of TGearbox;
  AumaGK142: array [0..1] of TGearbox;
  AumaGK146: array [0..1] of TGearbox;
  AumaGK162: array [0..1] of TGearbox;
  AumaGK252: array [0..1] of TGearbox;
  AumaGK302: array [0..1] of TGearbox;
  AumaGK352: array [0..1] of TGearbox;
  AumaGK402: array [0..1] of TGearbox;

  AumaGST101: array [0..2] of TGearbox;
  AumaGST141: array [0..2] of TGearbox;
  AumaGST145: array [0..2] of TGearbox;
  AumaGST161: array [0..2] of TGearbox;
  AumaGST251: array [0..2] of TGearbox;
  AumaGST301: array [0..2] of TGearbox;
  AumaGST351: array [0..2] of TGearbox;
  AumaGST401: array [0..2] of TGearbox;

  TramecR19: array [0..0] of TGearbox;
  TramecR24: array [0..0] of TGearbox;
  TramecR28: array [0..0] of TGearbox;
  TramecR38: array [0..0] of TGearbox;
  TramecR48: array [0..0] of TGearbox;

  MechanicRZAM500: array [0..1] of TGearbox;
  MechanicRZAM1000: array [0..1] of TGearbox;
  MechanicRZAM2500: array [0..0] of TGearbox;
  MechanicRZAMS210000: array [0..1] of TGearbox;

  RotorkIB5: array [0..3] of TGearbox;
  RotorkIB7: array [0..2] of TGearbox;
  RotorkIB9: array [0..2] of TGearbox;
  RotorkIB11: array [0..1] of TGearbox;
  RotorkIB13: array [0..1] of TGearbox;
  RotorkIB14: array [0..1] of TGearbox;

initialization
  SetLength(AumaSADutyS215, 11);
  SetLength(AumaSADutyS230, 11);
  SetLength(AumaSARDutyS425, 8);
  SetLength(AumaSARDutyS450, 8);
  SetLength(AumaGK, 8);
  SetLength(AumaGST, 8);
  SetLength(TramecR, 5);
  SetLength(MechanicRZAM, 4);
  SetLength(RotorkIB, 6);

  AumaSA072DutyS215[0] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(19), F07, Mm(26), Rpm(4), Nm(10), Kw(0.02), S215, AM011, AC012);
  AumaSA072DutyS215[1] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(19), F07, Mm(26), Rpm(5.6), Nm(10), Kw(0.02), S215, AM011, AC012);
  AumaSA072DutyS215[2] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(19), F07, Mm(26), Rpm(8), Nm(10), Kw(0.04), S215, AM011, AC012);
  AumaSA072DutyS215[3] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(19), F07, Mm(26), Rpm(11), Nm(10), Kw(0.04), S215, AM011, AC012);
  AumaSA072DutyS215[4] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(19), F07, Mm(26), Rpm(16), Nm(10), Kw(0.06), S215, AM011, AC012);
  AumaSA072DutyS215[5] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(19), F07, Mm(26), Rpm(22), Nm(10), Kw(0.06), S215, AM011, AC012);
  AumaSA072DutyS215[6] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(20), F10, Mm(30), Rpm(32), Nm(10), Kw(0.1), S215, AM011, AC012);
  AumaSA072DutyS215[7] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(20), F10, Mm(30), Rpm(45), Nm(10), Kw(0.1), S215, AM011, AC012);
  AumaSA072DutyS215[8] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(20), F10, Mm(30), Rpm(63), Nm(10), Kw(0.2), S215, AM011, AC012);
  AumaSA072DutyS215[9] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(20), F10, Mm(30), Rpm(90), Nm(10), Kw(0.2), S215, AM011, AC012);
  AumaSA072DutyS215[10] := TActuator.CreateAuma(AumaSA, SA072, Nm(30),
    1, Kg(20), F10, Mm(30), Rpm(125), Nm(10), Kw(0.3), S215, AM011, AC012);
  AumaSA072DutyS215[11] := TActuator.CreateAuma(AumaSA, SA072, Nm(25),
    1, Kg(20), F10, Mm(30), Rpm(180), Nm(10), Kw(0.3), S215, AM011, AC012);

  AumaSA072DutyS230[0] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(19), F07, Mm(26), Rpm(4), Nm(10), Kw(0.01), S230, AM011, AC012);
  AumaSA072DutyS230[1] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(19), F07, Mm(26), Rpm(5.6), Nm(10), Kw(0.01), S230, AM011, AC012);
  AumaSA072DutyS230[2] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(19), F07, Mm(26), Rpm(8), Nm(10), Kw(0.03), S230, AM011, AC012);
  AumaSA072DutyS230[3] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(19), F07, Mm(26), Rpm(11), Nm(10), Kw(0.03), S230, AM011, AC012);
  AumaSA072DutyS230[4] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(19), F07, Mm(26), Rpm(16), Nm(10), Kw(0.04), S230, AM011, AC012);
  AumaSA072DutyS230[5] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(19), F07, Mm(26), Rpm(22), Nm(10), Kw(0.04), S230, AM011, AC012);
  AumaSA072DutyS230[6] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(20), F10, Mm(30), Rpm(32), Nm(10), Kw(0.07), S230, AM011, AC012);
  AumaSA072DutyS230[7] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(20), F10, Mm(30), Rpm(45), Nm(10), Kw(0.07), S230, AM011, AC012);
  AumaSA072DutyS230[8] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(20), F10, Mm(30), Rpm(63), Nm(10), Kw(0.14), S230, AM011, AC012);
  AumaSA072DutyS230[9] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(20), F10, Mm(30), Rpm(90), Nm(10), Kw(0.14), S230, AM011, AC012);
  AumaSA072DutyS230[10] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(20), F10, Mm(30), Rpm(125), Nm(10), Kw(0.21), S230, AM011, AC012);
  AumaSA072DutyS230[11] := TActuator.CreateAuma(AumaSA, SA072, Nm(20),
    1, Kg(20), F10, Mm(30), Rpm(180), Nm(10), Kw(0.21), S230, AM011, AC012);

  AumaSA076DutyS215[0] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(19), F07, Mm(26), Rpm(4), Nm(20), Kw(0.03), S215, AM011, AC012);
  AumaSA076DutyS215[1] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(19), F07, Mm(26), Rpm(5.6), Nm(20), Kw(0.03), S215, AM011, AC012);
  AumaSA076DutyS215[2] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(19), F07, Mm(26), Rpm(8), Nm(20), Kw(0.06), S215, AM011, AC012);
  AumaSA076DutyS215[3] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(19), F07, Mm(26), Rpm(11), Nm(20), Kw(0.06), S215, AM011, AC012);
  AumaSA076DutyS215[4] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(19), F07, Mm(26), Rpm(16), Nm(20), Kw(0.12), S215, AM011, AC012);
  AumaSA076DutyS215[5] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(19), F07, Mm(26), Rpm(22), Nm(20), Kw(0.12), S215, AM011, AC012);
  AumaSA076DutyS215[6] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(21), F10, Mm(30), Rpm(32), Nm(20), Kw(0.2), S215, AM011, AC012);
  AumaSA076DutyS215[7] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(21), F10, Mm(30), Rpm(45), Nm(20), Kw(0.2), S215, AM011, AC012);
  AumaSA076DutyS215[8] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(21), F10, Mm(30), Rpm(63), Nm(20), Kw(0.4), S215, AM011, AC012);
  AumaSA076DutyS215[9] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(21), F10, Mm(30), Rpm(90), Nm(20), Kw(0.4), S215, AM011, AC012);
  AumaSA076DutyS215[10] := TActuator.CreateAuma(AumaSA, SA076, Nm(60),
    1, Kg(21), F10, Mm(30), Rpm(125), Nm(20), Kw(0.5), S215, AM011, AC012);
  AumaSA076DutyS215[11] := TActuator.CreateAuma(AumaSA, SA076, Nm(50),
    1, Kg(21), F10, Mm(30), Rpm(180), Nm(20), Kw(0.5), S215, AM011, AC012);

  AumaSA076DutyS230[0] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(19), F07, Mm(26), Rpm(4), Nm(20), Kw(0.02), S230, AM011, AC012);
  AumaSA076DutyS230[1] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(19), F07, Mm(26), Rpm(5.6), Nm(20), Kw(0.02), S230, AM011, AC012);
  AumaSA076DutyS230[2] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(19), F07, Mm(26), Rpm(8), Nm(20), Kw(0.04), S230, AM011, AC012);
  AumaSA076DutyS230[3] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(19), F07, Mm(26), Rpm(11), Nm(20), Kw(0.04), S230, AM011, AC012);
  AumaSA076DutyS230[4] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(19), F07, Mm(26), Rpm(16), Nm(20), Kw(0.08), S230, AM011, AC012);
  AumaSA076DutyS230[5] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(19), F07, Mm(26), Rpm(22), Nm(20), Kw(0.08), S230, AM011, AC012);
  AumaSA076DutyS230[6] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(21), F10, Mm(30), Rpm(32), Nm(20), Kw(0.14), S230, AM011, AC012);
  AumaSA076DutyS230[7] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(21), F10, Mm(30), Rpm(45), Nm(20), Kw(0.14), S230, AM011, AC012);
  AumaSA076DutyS230[8] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(21), F10, Mm(30), Rpm(63), Nm(20), Kw(0.28), S230, AM011, AC012);
  AumaSA076DutyS230[9] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(21), F10, Mm(30), Rpm(90), Nm(20), Kw(0.28), S230, AM011, AC012);
  AumaSA076DutyS230[10] := TActuator.CreateAuma(AumaSA, SA076, Nm(40),
    1, Kg(21), F10, Mm(30), Rpm(125), Nm(20), Kw(0.35), S230, AM011, AC012);
  AumaSA076DutyS230[11] := TActuator.CreateAuma(AumaSA, SA076, Nm(30),
    1, Kg(21), F10, Mm(30), Rpm(180), Nm(20), Kw(0.35), S230, AM011, AC012);

  AumaSA102DutyS215[0] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(23), F10, Mm(40), Rpm(4), Nm(40), Kw(0.06), S215, AM011, AC012);
  AumaSA102DutyS215[1] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(23), F10, Mm(40), Rpm(5.6), Nm(40), Kw(0.06), S215, AM011, AC012);
  AumaSA102DutyS215[2] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(23), F10, Mm(40), Rpm(8), Nm(40), Kw(0.12), S215, AM011, AC012);
  AumaSA102DutyS215[3] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(23), F10, Mm(40), Rpm(11), Nm(40), Kw(0.12), S215, AM011, AC012);
  AumaSA102DutyS215[4] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(23), F10, Mm(40), Rpm(16), Nm(40), Kw(0.25), S215, AM011, AC012);
  AumaSA102DutyS215[5] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(23), F10, Mm(40), Rpm(22), Nm(40), Kw(0.25), S215, AM011, AC012);
  AumaSA102DutyS215[6] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(25), F10, Mm(40), Rpm(32), Nm(40), Kw(0.4), S215, AM011, AC012);
  AumaSA102DutyS215[7] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(25), F10, Mm(40), Rpm(45), Nm(40), Kw(0.4), S215, AM011, AC012);
  AumaSA102DutyS215[8] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(26), F10, Mm(40), Rpm(63), Nm(40), Kw(0.7), S215, AM011, AC012);
  AumaSA102DutyS215[9] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(26), F10, Mm(40), Rpm(90), Nm(40), Kw(0.7), S215, AM011, AC012);
  AumaSA102DutyS215[10] := TActuator.CreateAuma(AumaSA, SA102, Nm(120),
    1, Kg(26), F10, Mm(40), Rpm(125), Nm(40), Kw(1), S215, AM011, AC012);
  AumaSA102DutyS215[11] := TActuator.CreateAuma(AumaSA, SA102, Nm(100),
    1, Kg(26), F10, Mm(40), Rpm(180), Nm(40), Kw(1), S215, AM011, AC012);

  AumaSA102DutyS230[0] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(23), F10, Mm(40), Rpm(4), Nm(40), Kw(0.04), S230, AM011, AC012);
  AumaSA102DutyS230[1] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(23), F10, Mm(40), Rpm(5.6), Nm(40), Kw(0.04), S230, AM011, AC012);
  AumaSA102DutyS230[2] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(23), F10, Mm(40), Rpm(8), Nm(40), Kw(0.08), S230, AM011, AC012);
  AumaSA102DutyS230[3] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(23), F10, Mm(40), Rpm(11), Nm(40), Kw(0.08), S230, AM011, AC012);
  AumaSA102DutyS230[4] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(23), F10, Mm(40), Rpm(16), Nm(40), Kw(0.17), S230, AM011, AC012);
  AumaSA102DutyS230[5] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(23), F10, Mm(40), Rpm(22), Nm(40), Kw(0.17), S230, AM011, AC012);
  AumaSA102DutyS230[6] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(25), F10, Mm(40), Rpm(32), Nm(40), Kw(0.28), S230, AM011, AC012);
  AumaSA102DutyS230[7] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(25), F10, Mm(40), Rpm(45), Nm(40), Kw(0.28), S230, AM011, AC012);
  AumaSA102DutyS230[8] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(26), F10, Mm(40), Rpm(63), Nm(40), Kw(0.5), S230, AM011, AC012);
  AumaSA102DutyS230[9] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(26), F10, Mm(40), Rpm(90), Nm(40), Kw(0.5), S230, AM011, AC012);
  AumaSA102DutyS230[10] := TActuator.CreateAuma(AumaSA, SA102, Nm(90),
    1, Kg(26), F10, Mm(40), Rpm(125), Nm(40), Kw(0.7), S230, AM011, AC012);
  AumaSA102DutyS230[11] := TActuator.CreateAuma(AumaSA, SA102, Nm(70),
    1, Kg(26), F10, Mm(40), Rpm(180), Nm(40), Kw(0.7), S230, AM011, AC012);

  AumaSA142DutyS215[0] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(47), F14, Mm(55), Rpm(4), Nm(100), Kw(0.12), S215, AM021, AC012);
  AumaSA142DutyS215[1] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(47), F14, Mm(55), Rpm(5.6), Nm(100), Kw(0.12), S215, AM021, AC012);
  AumaSA142DutyS215[2] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(47), F14, Mm(55), Rpm(8), Nm(100), Kw(0.25), S215, AM021, AC012);
  AumaSA142DutyS215[3] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(47), F14, Mm(55), Rpm(11), Nm(100), Kw(0.25), S215, AM021, AC012);
  AumaSA142DutyS215[4] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(48), F14, Mm(55), Rpm(16), Nm(100), Kw(0.45), S215, AM021, AC012);
  AumaSA142DutyS215[5] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(48), F14, Mm(55), Rpm(22), Nm(100), Kw(0.45), S215, AM021, AC012);
  AumaSA142DutyS215[6] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(51), F14, Mm(55), Rpm(32), Nm(100), Kw(0.75), S215, AM021, AC012);
  AumaSA142DutyS215[7] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(51), F14, Mm(55), Rpm(45), Nm(100), Kw(0.75), S215, AM021, AC012);
  AumaSA142DutyS215[8] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(52), F14, Mm(55), Rpm(63), Nm(100), Kw(1.4), S215, AM021, AC012);
  AumaSA142DutyS215[9] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(52), F14, Mm(55), Rpm(90), Nm(100), Kw(1.4), S215, AM021, AC012);
  AumaSA142DutyS215[10] := TActuator.CreateAuma(AumaSA, SA142, Nm(250),
    1, Kg(52), F14, Mm(55), Rpm(125), Nm(100), Kw(1.8), S215, AM021, AC012);
  AumaSA142DutyS215[11] := TActuator.CreateAuma(AumaSA, SA142, Nm(200),
    1, Kg(52), F14, Mm(55), Rpm(180), Nm(100), Kw(1.8), S215, AM021, AC012);

  AumaSA142DutyS230[0] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(47), F14, Mm(55), Rpm(4), Nm(100), Kw(0.08), S230, AM021, AC012);
  AumaSA142DutyS230[1] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(47), F14, Mm(55), Rpm(5.6), Nm(100), Kw(0.08), S230, AM021, AC012);
  AumaSA142DutyS230[2] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(47), F14, Mm(55), Rpm(8), Nm(100), Kw(0.18), S230, AM021, AC012);
  AumaSA142DutyS230[3] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(47), F14, Mm(55), Rpm(11), Nm(100), Kw(0.18), S230, AM021, AC012);
  AumaSA142DutyS230[4] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(48), F14, Mm(55), Rpm(16), Nm(100), Kw(0.3), S230, AM021, AC012);
  AumaSA142DutyS230[5] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(48), F14, Mm(55), Rpm(22), Nm(100), Kw(0.3), S230, AM021, AC012);
  AumaSA142DutyS230[6] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(51), F14, Mm(55), Rpm(32), Nm(100), Kw(0.5), S230, AM021, AC012);
  AumaSA142DutyS230[7] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(51), F14, Mm(55), Rpm(45), Nm(100), Kw(0.5), S230, AM021, AC012);
  AumaSA142DutyS230[8] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(52), F14, Mm(55), Rpm(63), Nm(100), Kw(1), S230, AM021, AC012);
  AumaSA142DutyS230[9] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(52), F14, Mm(55), Rpm(90), Nm(100), Kw(1), S230, AM021, AC012);
  AumaSA142DutyS230[10] := TActuator.CreateAuma(AumaSA, SA142, Nm(180),
    1, Kg(52), F14, Mm(55), Rpm(125), Nm(100), Kw(1.3), S230, AM021, AC012);
  AumaSA142DutyS230[11] := TActuator.CreateAuma(AumaSA, SA142, Nm(140),
    1, Kg(52), F14, Mm(55), Rpm(180), Nm(100), Kw(1.3), S230, AM021, AC012);

  AumaSA146DutyS215[0] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(49), F14, Mm(55), Rpm(4), Nm(200), Kw(0.2), S215, AM021, AC012);
  AumaSA146DutyS215[1] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(49), F14, Mm(55), Rpm(5.6), Nm(200), Kw(0.2), S215, AM021, AC012);
  AumaSA146DutyS215[2] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(49), F14, Mm(55), Rpm(8), Nm(200), Kw(0.4), S215, AM021, AC012);
  AumaSA146DutyS215[3] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(49), F14, Mm(55), Rpm(11), Nm(200), Kw(0.4), S215, AM021, AC012);
  AumaSA146DutyS215[4] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(50), F14, Mm(55), Rpm(16), Nm(200), Kw(0.8), S215, AM021, AC012);
  AumaSA146DutyS215[5] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(50), F14, Mm(55), Rpm(22), Nm(200), Kw(0.8), S215, AM021, AC012);
  AumaSA146DutyS215[6] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(57), F14, Mm(55), Rpm(32), Nm(200), Kw(1.6), S215, AM021, AC012);
  AumaSA146DutyS215[7] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(57), F14, Mm(55), Rpm(45), Nm(200), Kw(1.6), S215, AM021, AC012);
  AumaSA146DutyS215[8] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(57), F14, Mm(55), Rpm(63), Nm(200), Kw(3), S215, AM021, AC012);
  AumaSA146DutyS215[9] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(57), F14, Mm(55), Rpm(90), Nm(200), Kw(3), S215, AM021, AC012);
  AumaSA146DutyS215[10] := TActuator.CreateAuma(AumaSA, SA146, Nm(500),
    1, Kg(57), F14, Mm(55), Rpm(125), Nm(200), Kw(3.3), S215, AM021, AC012);
  AumaSA146DutyS215[11] := TActuator.CreateAuma(AumaSA, SA146, Nm(400),
    1, Kg(57), F14, Mm(55), Rpm(180), Nm(200), Kw(3.3), S215, AM021, AC012);

  AumaSA146DutyS230[0] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(49), F14, Mm(55), Rpm(4), Nm(200), Kw(0.14), S230, AM021, AC012);
  AumaSA146DutyS230[1] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(49), F14, Mm(55), Rpm(5.6), Nm(200), Kw(0.14), S230, AM021, AC012);
  AumaSA146DutyS230[2] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(49), F14, Mm(55), Rpm(8), Nm(200), Kw(0.3), S230, AM021, AC012);
  AumaSA146DutyS230[3] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(49), F14, Mm(55), Rpm(11), Nm(200), Kw(0.3), S230, AM021, AC012);
  AumaSA146DutyS230[4] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(50), F14, Mm(55), Rpm(16), Nm(200), Kw(0.6), S230, AM021, AC012);
  AumaSA146DutyS230[5] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(50), F14, Mm(55), Rpm(22), Nm(200), Kw(0.6), S230, AM021, AC012);
  AumaSA146DutyS230[6] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(57), F14, Mm(55), Rpm(32), Nm(200), Kw(1), S230, AM021, AC012);
  AumaSA146DutyS230[7] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(57), F14, Mm(55), Rpm(45), Nm(200), Kw(1), S230, AM021, AC012);
  AumaSA146DutyS230[8] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(57), F14, Mm(55), Rpm(63), Nm(200), Kw(2), S230, AM021, AC012);
  AumaSA146DutyS230[9] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(57), F14, Mm(55), Rpm(90), Nm(200), Kw(2), S230, AM021, AC012);
  AumaSA146DutyS230[10] := TActuator.CreateAuma(AumaSA, SA146, Nm(360),
    1, Kg(57), F14, Mm(55), Rpm(125), Nm(200), Kw(2.3), S230, AM021, AC012);
  AumaSA146DutyS230[11] := TActuator.CreateAuma(AumaSA, SA146, Nm(290),
    1, Kg(57), F14, Mm(55), Rpm(180), Nm(200), Kw(2.3), S230, AM021, AC012);

  AumaSA162DutyS215[0] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(75), F16, Mm(75), Rpm(4), Nm(400), Kw(0.4), S215, AM021, AC012);
  AumaSA162DutyS215[1] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(75), F16, Mm(75), Rpm(5.6), Nm(400), Kw(0.4), S215, AM021, AC012);
  AumaSA162DutyS215[2] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(75), F16, Mm(75), Rpm(8), Nm(400), Kw(0.8), S215, AM021, AC012);
  AumaSA162DutyS215[3] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(75), F16, Mm(75), Rpm(11), Nm(400), Kw(0.8), S215, AM021, AC012);
  AumaSA162DutyS215[4] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(75), F16, Mm(75), Rpm(16), Nm(400), Kw(1.5), S215, AM021, AC012);
  AumaSA162DutyS215[5] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(75), F16, Mm(75), Rpm(22), Nm(400), Kw(1.5), S215, AM021, AC012);
  AumaSA162DutyS215[6] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(86), F16, Mm(75), Rpm(32), Nm(400), Kw(3), S215, AM021, AC012);
  AumaSA162DutyS215[7] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(86), F16, Mm(75), Rpm(45), Nm(400), Kw(3), S215, AM021, AC012);
  AumaSA162DutyS215[8] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(91), F16, Mm(75), Rpm(63), Nm(400), Kw(5), S215, AM021, AC012);
  AumaSA162DutyS215[9] := TActuator.CreateAuma(AumaSA, SA162, Nm(1000),
    1, Kg(91), F16, Mm(75), Rpm(90), Nm(400), Kw(5), S215, AM021, AC012);
  AumaSA162DutyS215[10] := TActuator.CreateAuma(AumaSA, SA162, Nm(800),
    1, Kg(91), F16, Mm(75), Rpm(125), Nm(400), Kw(6), S215, AM021, AC012);
  AumaSA162DutyS215[11] := TActuator.CreateAuma(AumaSA, SA162, Nm(800),
    1, Kg(91), F16, Mm(75), Rpm(180), Nm(400), Kw(6), S215, AM021, AC012);

  AumaSA162DutyS230[0] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(75), F16, Mm(75), Rpm(4), Nm(400), Kw(0.3), S230, AM021, AC012);
  AumaSA162DutyS230[1] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(75), F16, Mm(75), Rpm(5.6), Nm(400), Kw(0.3), S230, AM021, AC012);
  AumaSA162DutyS230[2] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(75), F16, Mm(75), Rpm(8), Nm(400), Kw(0.6), S230, AM021, AC012);
  AumaSA162DutyS230[3] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(75), F16, Mm(75), Rpm(11), Nm(400), Kw(0.6), S230, AM021, AC012);
  AumaSA162DutyS230[4] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(75), F16, Mm(75), Rpm(16), Nm(400), Kw(1), S230, AM021, AC012);
  AumaSA162DutyS230[5] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(75), F16, Mm(75), Rpm(22), Nm(400), Kw(1), S230, AM021, AC012);
  AumaSA162DutyS230[6] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(86), F16, Mm(75), Rpm(32), Nm(400), Kw(2), S230, AM021, AC012);
  AumaSA162DutyS230[7] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(86), F16, Mm(75), Rpm(45), Nm(400), Kw(2), S230, AM021, AC012);
  AumaSA162DutyS230[8] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(91), F16, Mm(75), Rpm(63), Nm(400), Kw(3.5), S230, AM021, AC012);
  AumaSA162DutyS230[9] := TActuator.CreateAuma(AumaSA, SA162, Nm(710),
    1, Kg(91), F16, Mm(75), Rpm(90), Nm(400), Kw(3.5), S230, AM021, AC012);
  AumaSA162DutyS230[10] := TActuator.CreateAuma(AumaSA, SA162, Nm(570),
    1, Kg(91), F16, Mm(75), Rpm(125), Nm(400), Kw(4), S230, AM021, AC012);
  AumaSA162DutyS230[11] := TActuator.CreateAuma(AumaSA, SA162, Nm(570),
    1, Kg(91), F16, Mm(75), Rpm(180), Nm(400), Kw(4), S230, AM021, AC012);

  AumaSA251DutyS215[0] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(150), F25, Mm(95), Rpm(4), Nm(630), Kw(1.1), S215, AM021, AC012);
  AumaSA251DutyS215[1] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(150), F25, Mm(95), Rpm(5.6), Nm(630), Kw(1.1), S215, AM021, AC012);
  AumaSA251DutyS215[2] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(150), F25, Mm(95), Rpm(8), Nm(630), Kw(3), S215, AM021, AC012);
  AumaSA251DutyS215[3] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(150), F25, Mm(95), Rpm(11), Nm(630), Kw(3), S215, AM021, AC012);
  AumaSA251DutyS215[4] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(150), F25, Mm(95), Rpm(16), Nm(630), Kw(4), S215, AM021, AC012);
  AumaSA251DutyS215[5] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(150), F25, Mm(95), Rpm(22), Nm(630), Kw(4), S215, AM021, AC012);
  AumaSA251DutyS215[6] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(160), F25, Mm(95), Rpm(32), Nm(630), Kw(7.5), S215, AM021, AC012);
  AumaSA251DutyS215[7] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(160), F25, Mm(95), Rpm(45), Nm(630), Kw(7.5), S215, AM021, AC012);
  AumaSA251DutyS215[8] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(160), F25, Mm(95), Rpm(63), Nm(630), Kw(15), S215, AM021, AC012);
  AumaSA251DutyS215[9] := TActuator.CreateAuma(AumaSA, SA251, Nm(2000),
    1, Kg(160), F25, Mm(95), Rpm(90), Nm(630), Kw(15), S215, AM021, AC012);

  AumaSA251DutyS230[0] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(150), F25, Mm(95), Rpm(4), Nm(630), Kw(0.75), S230, AM021, AC012);
  AumaSA251DutyS230[1] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(150), F25, Mm(95), Rpm(5.6), Nm(630), Kw(0.75), S230, AM021, AC012);
  AumaSA251DutyS230[2] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(150), F25, Mm(95), Rpm(8), Nm(630), Kw(2.2), S230, AM021, AC012);
  AumaSA251DutyS230[3] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(150), F25, Mm(95), Rpm(11), Nm(630), Kw(2.2), S230, AM021, AC012);
  AumaSA251DutyS230[4] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(150), F25, Mm(95), Rpm(16), Nm(630), Kw(3), S230, AM021, AC012);
  AumaSA251DutyS230[5] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(150), F25, Mm(95), Rpm(22), Nm(630), Kw(3), S230, AM021, AC012);
  AumaSA251DutyS230[6] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(160), F25, Mm(95), Rpm(32), Nm(630), Kw(5.5), S230, AM021, AC012);
  AumaSA251DutyS230[7] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(160), F25, Mm(95), Rpm(45), Nm(630), Kw(5.5), S230, AM021, AC012);
  AumaSA251DutyS230[8] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(160), F25, Mm(95), Rpm(63), Nm(630), Kw(11), S230, AM021, AC012);
  AumaSA251DutyS230[9] := TActuator.CreateAuma(AumaSA, SA251, Nm(1400),
    1, Kg(160), F25, Mm(95), Rpm(90), Nm(630), Kw(11), S230, AM021, AC012);

  AumaSA301DutyS215[0] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(190), F30, Mm(115), Rpm(4), Nm(1250), Kw(2.2), S215, AM021, AC012);
  AumaSA301DutyS215[1] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(190), F30, Mm(115), Rpm(5.6), Nm(1250), Kw(2.2), S215, AM021, AC012);
  AumaSA301DutyS215[2] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(190), F30, Mm(115), Rpm(8), Nm(1250), Kw(5.5), S215, AM021, AC012);
  AumaSA301DutyS215[3] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(190), F30, Mm(115), Rpm(11), Nm(1250), Kw(5.5), S215, AM021, AC012);
  AumaSA301DutyS215[4] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(190), F30, Mm(115), Rpm(16), Nm(1250), Kw(7.5), S215, AM021, AC012);
  AumaSA301DutyS215[5] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(190), F30, Mm(115), Rpm(22), Nm(1250), Kw(7.5), S215, AM021, AC012);
  AumaSA301DutyS215[6] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(260), F30, Mm(115), Rpm(32), Nm(1250), Kw(15), S215, AM021, AC012);
  AumaSA301DutyS215[7] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(260), F30, Mm(115), Rpm(45), Nm(1250), Kw(15), S215, AM021, AC012);
  AumaSA301DutyS215[8] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(260), F30, Mm(115), Rpm(63), Nm(1250), Kw(30), S215, AM021, AC012);
  AumaSA301DutyS215[9] := TActuator.CreateAuma(AumaSA, SA301, Nm(4000),
    1, Kg(260), F30, Mm(115), Rpm(90), Nm(1250), Kw(30), S215, AM021, AC012);

  AumaSA301DutyS230[0] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(190), F30, Mm(115), Rpm(4), Nm(1250), Kw(1.5), S230, AM021, AC012);
  AumaSA301DutyS230[1] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(190), F30, Mm(115), Rpm(5.6), Nm(1250), Kw(1.5), S230, AM021, AC012);
  AumaSA301DutyS230[2] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(190), F30, Mm(115), Rpm(8), Nm(1250), Kw(4), S230, AM021, AC012);
  AumaSA301DutyS230[3] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(190), F30, Mm(115), Rpm(11), Nm(1250), Kw(4), S230, AM021, AC012);
  AumaSA301DutyS230[4] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(190), F30, Mm(115), Rpm(16), Nm(1250), Kw(5.5), S230, AM021, AC012);
  AumaSA301DutyS230[5] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(190), F30, Mm(115), Rpm(22), Nm(1250), Kw(5.5), S230, AM021, AC012);
  AumaSA301DutyS230[6] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(260), F30, Mm(115), Rpm(32), Nm(1250), Kw(11), S230, AM021, AC012);
  AumaSA301DutyS230[7] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(260), F30, Mm(115), Rpm(45), Nm(1250), Kw(11), S230, AM021, AC012);
  AumaSA301DutyS230[8] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(260), F30, Mm(115), Rpm(63), Nm(1250), Kw(22), S230, AM021, AC012);
  AumaSA301DutyS230[9] := TActuator.CreateAuma(AumaSA, SA301, Nm(2800),
    1, Kg(260), F30, Mm(115), Rpm(90), Nm(1250), Kw(22), S230, AM021, AC012);

  AumaSA351DutyS215[0] := TActuator.CreateAuma(AumaSA, SA351, Nm(8000),
    1, Kg(410), F35, Mm(155), Rpm(4), Nm(2500), Kw(4), S215, AM021, AC012);
  AumaSA351DutyS215[1] := TActuator.CreateAuma(AumaSA, SA351, Nm(8000),
    1, Kg(410), F35, Mm(155), Rpm(5.6), Nm(2500), Kw(4), S215, AM021, AC012);
  AumaSA351DutyS215[2] := TActuator.CreateAuma(AumaSA, SA351, Nm(8000),
    1, Kg(410), F35, Mm(155), Rpm(8), Nm(2500), Kw(7.5), S215, AM021, AC012);
  AumaSA351DutyS215[3] := TActuator.CreateAuma(AumaSA, SA351, Nm(8000),
    1, Kg(410), F35, Mm(155), Rpm(11), Nm(2500), Kw(7.5), S215, AM021, AC012);
  AumaSA351DutyS215[4] := TActuator.CreateAuma(AumaSA, SA351, Nm(8000),
    1, Kg(410), F35, Mm(155), Rpm(16), Nm(2500), Kw(15), S215, AM021, AC012);
  AumaSA351DutyS215[5] := TActuator.CreateAuma(AumaSA, SA351, Nm(8000),
    1, Kg(410), F35, Mm(155), Rpm(22), Nm(2500), Kw(15), S215, AM021, AC012);
  AumaSA351DutyS215[6] := TActuator.CreateAuma(AumaSA, SA351, Nm(8000),
    1, Kg(425), F35, Mm(155), Rpm(32), Nm(2500), Kw(30), S215, AM021, AC012);
  AumaSA351DutyS215[7] := TActuator.CreateAuma(AumaSA, SA351, Nm(8000),
    1, Kg(425), F35, Mm(155), Rpm(45), Nm(2500), Kw(30), S215, AM021, AC012);

  AumaSA351DutyS230[0] := TActuator.CreateAuma(AumaSA, SA351, Nm(5700),
    1, Kg(410), F35, Mm(155), Rpm(4), Nm(2500), Kw(3), S230, AM021, AC012);
  AumaSA351DutyS230[1] := TActuator.CreateAuma(AumaSA, SA351, Nm(5700),
    1, Kg(410), F35, Mm(155), Rpm(5.6), Nm(2500), Kw(3), S230, AM021, AC012);
  AumaSA351DutyS230[2] := TActuator.CreateAuma(AumaSA, SA351, Nm(5700),
    1, Kg(410), F35, Mm(155), Rpm(8), Nm(2500), Kw(5.5), S230, AM021, AC012);
  AumaSA351DutyS230[3] := TActuator.CreateAuma(AumaSA, SA351, Nm(5700),
    1, Kg(410), F35, Mm(155), Rpm(11), Nm(2500), Kw(5.5), S230, AM021, AC012);
  AumaSA351DutyS230[4] := TActuator.CreateAuma(AumaSA, SA351, Nm(5700),
    1, Kg(410), F35, Mm(155), Rpm(16), Nm(2500), Kw(11), S230, AM021, AC012);
  AumaSA351DutyS230[5] := TActuator.CreateAuma(AumaSA, SA351, Nm(5700),
    1, Kg(410), F35, Mm(155), Rpm(22), Nm(2500), Kw(11), S230, AM021, AC012);
  AumaSA351DutyS230[6] := TActuator.CreateAuma(AumaSA, SA351, Nm(5700),
    1, Kg(425), F35, Mm(155), Rpm(32), Nm(2500), Kw(14), S230, AM021, AC012);
  AumaSA351DutyS230[7] := TActuator.CreateAuma(AumaSA, SA351, Nm(5700),
    1, Kg(425), F35, Mm(155), Rpm(45), Nm(2500), Kw(14), S230, AM021, AC012);

  AumaSA401DutyS215[0] := TActuator.CreateAuma(AumaSA, SA401, Nm(16000), 1,
    Kg(510), F40, Mm(175), Rpm(4), Nm(5000), Kw(7.5), S215, AM021, AC012);
  AumaSA401DutyS215[1] := TActuator.CreateAuma(AumaSA, SA401, Nm(16000), 1,
    Kg(510), F40, Mm(175), Rpm(5.6), Nm(5000), Kw(7.5), S215, AM021, AC012);
  AumaSA401DutyS215[2] := TActuator.CreateAuma(AumaSA, SA401, Nm(16000), 1,
    Kg(510), F40, Mm(175), Rpm(8), Nm(5000), Kw(15), S215, AM021, AC012);
  AumaSA401DutyS215[3] := TActuator.CreateAuma(AumaSA, SA401, Nm(16000), 1,
    Kg(510), F40, Mm(175), Rpm(11), Nm(5000), Kw(15), S215, AM021, AC012);
  AumaSA401DutyS215[4] := TActuator.CreateAuma(AumaSA, SA401, Nm(16000), 1,
    Kg(510), F40, Mm(175), Rpm(16), Nm(5000), Kw(30), S215, AM021, AC012);
  AumaSA401DutyS215[5] := TActuator.CreateAuma(AumaSA, SA401, Nm(16000), 1,
    Kg(510), F40, Mm(175), Rpm(22), Nm(5000), Kw(30), S215, AM021, AC012);
  AumaSA401DutyS215[6] := TActuator.CreateAuma(AumaSA, SA401, Nm(14000), 1,
    Kg(510), F40, Mm(175), Rpm(32), Nm(5000), Kw(30), S215, AM021, AC012);

  AumaSA401DutyS230[0] := TActuator.CreateAuma(AumaSA, SA401, Nm(11200), 1,
    Kg(510), F40, Mm(175), Rpm(4), Nm(5000), Kw(5.5), S230, AM021, AC012);
  AumaSA401DutyS230[1] := TActuator.CreateAuma(AumaSA, SA401, Nm(11200), 1,
    Kg(510), F40, Mm(175), Rpm(5.6), Nm(5000), Kw(5.5), S230, AM021, AC012);
  AumaSA401DutyS230[2] := TActuator.CreateAuma(AumaSA, SA401, Nm(11200), 1,
    Kg(510), F40, Mm(175), Rpm(8), Nm(5000), Kw(11), S230, AM021, AC012);
  AumaSA401DutyS230[3] := TActuator.CreateAuma(AumaSA, SA401, Nm(11200), 1,
    Kg(510), F40, Mm(175), Rpm(11), Nm(5000), Kw(11), S230, AM021, AC012);
  AumaSA401DutyS230[4] := TActuator.CreateAuma(AumaSA, SA401, Nm(11200), 1,
    Kg(510), F40, Mm(175), Rpm(16), Nm(5000), Kw(22), S230, AM021, AC012);
  AumaSA401DutyS230[5] := TActuator.CreateAuma(AumaSA, SA401, Nm(11200), 1,
    Kg(510), F40, Mm(175), Rpm(22), Nm(5000), Kw(22), S230, AM021, AC012);
  AumaSA401DutyS230[6] := TActuator.CreateAuma(AumaSA, SA401, Nm(9800),
    1, Kg(510), F40, Mm(175), Rpm(32), Nm(5000), Kw(22), S230, AM021, AC012);

  AumaSA481DutyS215[0] := TActuator.CreateAuma(AumaSA, SA481, Nm(32000), 1,
    Kg(750), F48, Mm(175), Rpm(4), Nm(10000), Kw(15), S215, AM021, AC012);
  AumaSA481DutyS215[1] := TActuator.CreateAuma(AumaSA, SA481, Nm(32000), 1,
    Kg(750), F48, Mm(175), Rpm(5.6), Nm(10000), Kw(15), S215, AM021, AC012);
  AumaSA481DutyS215[2] := TActuator.CreateAuma(AumaSA, SA481, Nm(32000), 1,
    Kg(750), F48, Mm(175), Rpm(8), Nm(10000), Kw(30), S215, AM021, AC012);
  AumaSA481DutyS215[3] := TActuator.CreateAuma(AumaSA, SA481, Nm(32000), 1,
    Kg(750), F48, Mm(175), Rpm(11), Nm(10000), Kw(30), S215, AM021, AC012);
  AumaSA481DutyS215[4] := TActuator.CreateAuma(AumaSA, SA481, Nm(32000), 1,
    Kg(750), F48, Mm(175), Rpm(16), Nm(10000), Kw(45), S215, AM021, AC012);

  AumaSA481DutyS230[0] := TActuator.CreateAuma(AumaSA, SA481, Nm(22400), 1,
    Kg(750), F48, Mm(175), Rpm(4), Nm(10000), Kw(11), S230, AM021, AC012);
  AumaSA481DutyS230[1] := TActuator.CreateAuma(AumaSA, SA481, Nm(22400), 1,
    Kg(750), F48, Mm(175), Rpm(5.6), Nm(10000), Kw(11), S230, AM021, AC012);
  AumaSA481DutyS230[2] := TActuator.CreateAuma(AumaSA, SA481, Nm(22400), 1,
    Kg(750), F48, Mm(175), Rpm(8), Nm(10000), Kw(22), S230, AM021, AC012);
  AumaSA481DutyS230[3] := TActuator.CreateAuma(AumaSA, SA481, Nm(22400), 1,
    Kg(750), F48, Mm(175), Rpm(11), Nm(10000), Kw(22), S230, AM021, AC012);
  AumaSA481DutyS230[4] := TActuator.CreateAuma(AumaSA, SA481, Nm(22400), 1,
    Kg(750), F48, Mm(175), Rpm(16), Nm(10000), Kw(30), S230, AM021, AC012);

  AumaSAR072DutyS425[0] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(19), F07, Mm(26), Rpm(4), Nm(15), Kw(0.02), S425, AM011, AC012);
  AumaSAR072DutyS425[1] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(19), F07, Mm(26), Rpm(5.6), Nm(15), Kw(0.02), S425, AM011, AC012);
  AumaSAR072DutyS425[2] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(19), F07, Mm(26), Rpm(8), Nm(15), Kw(0.04), S425, AM011, AC012);
  AumaSAR072DutyS425[3] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(19), F07, Mm(26), Rpm(11), Nm(15), Kw(0.04), S425, AM011, AC012);
  AumaSAR072DutyS425[4] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(19), F07, Mm(26), Rpm(16), Nm(15), Kw(0.06), S425, AM011, AC012);
  AumaSAR072DutyS425[5] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(19), F07, Mm(26), Rpm(22), Nm(15), Kw(0.06), S425, AM011, AC012);
  AumaSAR072DutyS425[6] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(20), F10, Mm(30), Rpm(32), Nm(15), Kw(0.1), S425, AM011, AC012);
  AumaSAR072DutyS425[7] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(20), F10, Mm(30), Rpm(45), Nm(15), Kw(0.1), S425, AM011, AC012);
  AumaSAR072DutyS425[8] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(20), F10, Mm(30), Rpm(63), Nm(15), Kw(0.2), S425, AM011, AC012);
  AumaSAR072DutyS425[9] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(30), 1, Kg(20), F10, Mm(30), Rpm(90), Nm(15), Kw(0.2), S425, AM011, AC012);

  AumaSAR072DutyS450[0] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(19), F07, Mm(26), Rpm(4), Nm(15), Kw(0.01), S450, AM011, AC012);
  AumaSAR072DutyS450[1] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(19), F07, Mm(26), Rpm(5.6), Nm(15), Kw(0.01), S450, AM011, AC012);
  AumaSAR072DutyS450[2] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(19), F07, Mm(26), Rpm(8), Nm(15), Kw(0.03), S450, AM011, AC012);
  AumaSAR072DutyS450[3] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(19), F07, Mm(26), Rpm(11), Nm(15), Kw(0.03), S450, AM011, AC012);
  AumaSAR072DutyS450[4] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(19), F07, Mm(26), Rpm(16), Nm(15), Kw(0.04), S450, AM011, AC012);
  AumaSAR072DutyS450[5] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(19), F07, Mm(26), Rpm(22), Nm(15), Kw(0.04), S450, AM011, AC012);
  AumaSAR072DutyS450[6] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(20), F10, Mm(30), Rpm(32), Nm(15), Kw(0.07), S450, AM011, AC012);
  AumaSAR072DutyS450[7] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(20), F10, Mm(30), Rpm(45), Nm(15), Kw(0.07), S450, AM011, AC012);
  AumaSAR072DutyS450[8] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(20), F10, Mm(30), Rpm(63), Nm(15), Kw(0.14), S450, AM011, AC012);
  AumaSAR072DutyS450[9] := TActuator.CreateAuma(AumaSAR, SAR072,
    Nm(20), 1, Kg(20), F10, Mm(30), Rpm(90), Nm(15), Kw(0.14), S450, AM011, AC012);

  AumaSAR076DutyS425[0] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(20), F07, Mm(26), Rpm(4), Nm(30), Kw(0.03), S425, AM011, AC012);
  AumaSAR076DutyS425[1] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(20), F07, Mm(26), Rpm(5.6), Nm(30), Kw(0.03), S425, AM011, AC012);
  AumaSAR076DutyS425[2] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(20), F07, Mm(26), Rpm(8), Nm(30), Kw(0.06), S425, AM011, AC012);
  AumaSAR076DutyS425[3] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(20), F07, Mm(26), Rpm(11), Nm(30), Kw(0.06), S425, AM011, AC012);
  AumaSAR076DutyS425[4] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(20), F07, Mm(26), Rpm(16), Nm(30), Kw(0.12), S425, AM011, AC012);
  AumaSAR076DutyS425[5] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(20), F07, Mm(26), Rpm(22), Nm(30), Kw(0.12), S425, AM011, AC012);
  AumaSAR076DutyS425[6] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(21), F10, Mm(30), Rpm(32), Nm(30), Kw(0.2), S425, AM011, AC012);
  AumaSAR076DutyS425[7] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(21), F10, Mm(30), Rpm(45), Nm(30), Kw(0.2), S425, AM011, AC012);
  AumaSAR076DutyS425[8] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(21), F10, Mm(30), Rpm(63), Nm(30), Kw(0.4), S425, AM011, AC012);
  AumaSAR076DutyS425[9] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(60), 1, Kg(21), F10, Mm(30), Rpm(90), Nm(30), Kw(0.4), S425, AM011, AC012);

  AumaSAR076DutyS450[0] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(20), F07, Mm(26), Rpm(4), Nm(30), Kw(0.02), S450, AM011, AC012);
  AumaSAR076DutyS450[1] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(20), F07, Mm(26), Rpm(5.6), Nm(30), Kw(0.02), S450, AM011, AC012);
  AumaSAR076DutyS450[2] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(20), F07, Mm(26), Rpm(8), Nm(30), Kw(0.04), S450, AM011, AC012);
  AumaSAR076DutyS450[3] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(20), F07, Mm(26), Rpm(11), Nm(30), Kw(0.04), S450, AM011, AC012);
  AumaSAR076DutyS450[4] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(20), F07, Mm(26), Rpm(16), Nm(30), Kw(0.08), S450, AM011, AC012);
  AumaSAR076DutyS450[5] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(20), F07, Mm(26), Rpm(22), Nm(30), Kw(0.08), S450, AM011, AC012);
  AumaSAR076DutyS450[6] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(21), F10, Mm(30), Rpm(32), Nm(30), Kw(0.14), S450, AM011, AC012);
  AumaSAR076DutyS450[7] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(21), F10, Mm(30), Rpm(45), Nm(30), Kw(0.14), S450, AM011, AC012);
  AumaSAR076DutyS450[8] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(21), F10, Mm(30), Rpm(63), Nm(30), Kw(0.28), S450, AM011, AC012);
  AumaSAR076DutyS450[9] := TActuator.CreateAuma(AumaSAR, SAR076,
    Nm(40), 1, Kg(21), F10, Mm(30), Rpm(90), Nm(30), Kw(0.28), S450, AM011, AC012);

  AumaSAR102DutyS425[0] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(22), F10, Mm(40), Rpm(4), Nm(60), Kw(0.06), S425, AM011, AC012);
  AumaSAR102DutyS425[1] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(22), F10, Mm(40), Rpm(5.6), Nm(60), Kw(0.06), S425, AM011, AC012);
  AumaSAR102DutyS425[2] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(22), F10, Mm(40), Rpm(8), Nm(60), Kw(0.12), S425, AM011, AC012);
  AumaSAR102DutyS425[3] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(22), F10, Mm(40), Rpm(11), Nm(60), Kw(0.12), S425, AM011, AC012);
  AumaSAR102DutyS425[4] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(22), F10, Mm(40), Rpm(16), Nm(60), Kw(0.25), S425, AM011, AC012);
  AumaSAR102DutyS425[5] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(22), F10, Mm(40), Rpm(22), Nm(60), Kw(0.25), S425, AM011, AC012);
  AumaSAR102DutyS425[6] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(25), F10, Mm(40), Rpm(32), Nm(60), Kw(0.4), S425, AM011, AC012);
  AumaSAR102DutyS425[7] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(25), F10, Mm(40), Rpm(45), Nm(60), Kw(0.4), S425, AM011, AC012);
  AumaSAR102DutyS425[8] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(25), F10, Mm(40), Rpm(63), Nm(60), Kw(0.7), S425, AM011, AC012);
  AumaSAR102DutyS425[9] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(120), 1, Kg(25), F10, Mm(40), Rpm(90), Nm(60), Kw(0.7), S425, AM011, AC012);

  AumaSAR102DutyS450[0] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(22), F10, Mm(40), Rpm(4), Nm(60), Kw(0.04), S450, AM011, AC012);
  AumaSAR102DutyS450[1] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(22), F10, Mm(40), Rpm(5.6), Nm(60), Kw(0.04), S450, AM011, AC012);
  AumaSAR102DutyS450[2] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(22), F10, Mm(40), Rpm(8), Nm(60), Kw(0.08), S450, AM011, AC012);
  AumaSAR102DutyS450[3] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(22), F10, Mm(40), Rpm(11), Nm(60), Kw(0.08), S450, AM011, AC012);
  AumaSAR102DutyS450[4] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(22), F10, Mm(40), Rpm(16), Nm(60), Kw(0.17), S450, AM011, AC012);
  AumaSAR102DutyS450[5] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(22), F10, Mm(40), Rpm(22), Nm(60), Kw(0.17), S450, AM011, AC012);
  AumaSAR102DutyS450[6] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(25), F10, Mm(40), Rpm(32), Nm(60), Kw(0.28), S450, AM011, AC012);
  AumaSAR102DutyS450[7] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(25), F10, Mm(40), Rpm(45), Nm(60), Kw(0.28), S450, AM011, AC012);
  AumaSAR102DutyS450[8] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(25), F10, Mm(40), Rpm(63), Nm(60), Kw(0.5), S450, AM011, AC012);
  AumaSAR102DutyS450[9] := TActuator.CreateAuma(AumaSAR, SAR102,
    Nm(90), 1, Kg(25), F10, Mm(40), Rpm(90), Nm(60), Kw(0.5), S450, AM011, AC012);

  AumaSAR142DutyS425[0] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(44), F14, Mm(55), Rpm(4), Nm(120), Kw(0.12), S425, AM021, AC012);
  AumaSAR142DutyS425[1] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(44), F14, Mm(55), Rpm(5.6), Nm(120), Kw(0.12), S425, AM021, AC012);
  AumaSAR142DutyS425[2] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(44), F14, Mm(55), Rpm(8), Nm(120), Kw(0.25), S425, AM021, AC012);
  AumaSAR142DutyS425[3] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(44), F14, Mm(55), Rpm(11), Nm(120), Kw(0.25), S425, AM021, AC012);
  AumaSAR142DutyS425[4] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(48), F14, Mm(55), Rpm(16), Nm(120), Kw(0.45), S425, AM021, AC012);
  AumaSAR142DutyS425[5] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(48), F14, Mm(55), Rpm(22), Nm(120), Kw(0.45), S425, AM021, AC012);
  AumaSAR142DutyS425[6] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(48), F14, Mm(55), Rpm(32), Nm(120), Kw(0.75), S425, AM021, AC012);
  AumaSAR142DutyS425[7] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(48), F14, Mm(55), Rpm(45), Nm(120), Kw(0.75), S425, AM021, AC012);
  AumaSAR142DutyS425[8] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(48), F14, Mm(55), Rpm(63), Nm(120), Kw(1.4), S425, AM021, AC012);
  AumaSAR142DutyS425[9] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(250), 1, Kg(48), F14, Mm(55), Rpm(90), Nm(120), Kw(1.4), S425, AM021, AC012);

  AumaSAR142DutyS450[0] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(44), F14, Mm(55), Rpm(4), Nm(120), Kw(0.08), S450, AM021, AC012);
  AumaSAR142DutyS450[1] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(44), F14, Mm(55), Rpm(5.6), Nm(120), Kw(0.08), S450, AM021, AC012);
  AumaSAR142DutyS450[2] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(44), F14, Mm(55), Rpm(8), Nm(120), Kw(0.18), S450, AM021, AC012);
  AumaSAR142DutyS450[3] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(44), F14, Mm(55), Rpm(11), Nm(120), Kw(0.18), S450, AM021, AC012);
  AumaSAR142DutyS450[4] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(48), F14, Mm(55), Rpm(16), Nm(120), Kw(0.3), S450, AM021, AC012);
  AumaSAR142DutyS450[5] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(48), F14, Mm(55), Rpm(22), Nm(120), Kw(0.3), S450, AM021, AC012);
  AumaSAR142DutyS450[6] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(48), F14, Mm(55), Rpm(32), Nm(120), Kw(0.5), S450, AM021, AC012);
  AumaSAR142DutyS450[7] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(48), F14, Mm(55), Rpm(45), Nm(120), Kw(0.5), S450, AM021, AC012);
  AumaSAR142DutyS450[8] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(48), F14, Mm(55), Rpm(63), Nm(120), Kw(1), S450, AM021, AC012);
  AumaSAR142DutyS450[9] := TActuator.CreateAuma(AumaSAR, SAR142,
    Nm(180), 1, Kg(48), F14, Mm(55), Rpm(90), Nm(120), Kw(1), S450, AM021, AC012);

  AumaSAR146DutyS425[0] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(46), F14, Mm(55), Rpm(4), Nm(250), Kw(0.2), S425, AM021, AC012);
  AumaSAR146DutyS425[1] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(46), F14, Mm(55), Rpm(5.6), Nm(250), Kw(0.2), S425, AM021, AC012);
  AumaSAR146DutyS425[2] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(46), F14, Mm(55), Rpm(8), Nm(250), Kw(0.4), S425, AM021, AC012);
  AumaSAR146DutyS425[3] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(46), F14, Mm(55), Rpm(11), Nm(250), Kw(0.4), S425, AM021, AC012);
  AumaSAR146DutyS425[4] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(53), F14, Mm(55), Rpm(16), Nm(250), Kw(0.8), S425, AM021, AC012);
  AumaSAR146DutyS425[5] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(53), F14, Mm(55), Rpm(22), Nm(250), Kw(0.8), S425, AM021, AC012);
  AumaSAR146DutyS425[6] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(53), F14, Mm(55), Rpm(32), Nm(250), Kw(1.6), S425, AM021, AC012);
  AumaSAR146DutyS425[7] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(53), F14, Mm(55), Rpm(45), Nm(250), Kw(1.6), S425, AM021, AC012);
  AumaSAR146DutyS425[8] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(53), F14, Mm(55), Rpm(63), Nm(250), Kw(3), S425, AM021, AC012);
  AumaSAR146DutyS425[9] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(500), 1, Kg(53), F14, Mm(55), Rpm(90), Nm(250), Kw(3), S425, AM021, AC012);

  AumaSAR146DutyS450[0] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(46), F14, Mm(55), Rpm(4), Nm(250), Kw(0.14), S450, AM021, AC012);
  AumaSAR146DutyS450[1] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(46), F14, Mm(55), Rpm(5.6), Nm(250), Kw(0.14), S450, AM021, AC012);
  AumaSAR146DutyS450[2] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(46), F14, Mm(55), Rpm(8), Nm(250), Kw(0.3), S450, AM021, AC012);
  AumaSAR146DutyS450[3] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(46), F14, Mm(55), Rpm(11), Nm(250), Kw(0.3), S450, AM021, AC012);
  AumaSAR146DutyS450[4] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(53), F14, Mm(55), Rpm(16), Nm(250), Kw(0.6), S450, AM021, AC012);
  AumaSAR146DutyS450[5] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(53), F14, Mm(55), Rpm(22), Nm(250), Kw(0.6), S450, AM021, AC012);
  AumaSAR146DutyS450[6] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(53), F14, Mm(55), Rpm(32), Nm(250), Kw(1), S450, AM021, AC012);
  AumaSAR146DutyS450[7] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(53), F14, Mm(55), Rpm(45), Nm(250), Kw(1), S450, AM021, AC012);
  AumaSAR146DutyS450[8] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(53), F14, Mm(55), Rpm(63), Nm(250), Kw(2), S450, AM021, AC012);
  AumaSAR146DutyS450[9] := TActuator.CreateAuma(AumaSAR, SAR146,
    Nm(360), 1, Kg(53), F14, Mm(55), Rpm(90), Nm(250), Kw(2), S450, AM021, AC012);

  AumaSAR162DutyS425[0] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(67), F16, Mm(75), Rpm(4), Nm(500), Kw(0.4), S425, AM021, AC012);
  AumaSAR162DutyS425[1] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(67), F16, Mm(75), Rpm(5.6), Nm(500), Kw(0.4), S425, AM021, AC012);
  AumaSAR162DutyS425[2] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(67), F16, Mm(75), Rpm(8), Nm(500), Kw(0.8), S425, AM021, AC012);
  AumaSAR162DutyS425[3] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(67), F16, Mm(75), Rpm(11), Nm(500), Kw(0.8), S425, AM021, AC012);
  AumaSAR162DutyS425[4] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(67), F16, Mm(75), Rpm(16), Nm(500), Kw(1.5), S425, AM021, AC012);
  AumaSAR162DutyS425[5] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(67), F16, Mm(75), Rpm(22), Nm(500), Kw(1.5), S425, AM021, AC012);
  AumaSAR162DutyS425[6] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(79), F16, Mm(75), Rpm(32), Nm(500), Kw(3), S425, AM021, AC012);
  AumaSAR162DutyS425[7] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(79), F16, Mm(75), Rpm(45), Nm(500), Kw(3), S425, AM021, AC012);
  AumaSAR162DutyS425[8] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(82), F16, Mm(75), Rpm(63), Nm(500), Kw(5), S425, AM021, AC012);
  AumaSAR162DutyS425[9] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(1000), 1, Kg(82), F16, Mm(75), Rpm(90), Nm(500), Kw(5), S425, AM021, AC012);

  AumaSAR162DutyS450[0] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(67), F16, Mm(75), Rpm(4), Nm(500), Kw(0.3), S450, AM021, AC012);
  AumaSAR162DutyS450[1] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(67), F16, Mm(75), Rpm(5.6), Nm(500), Kw(0.3), S450, AM021, AC012);
  AumaSAR162DutyS450[2] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(67), F16, Mm(75), Rpm(8), Nm(500), Kw(0.6), S450, AM021, AC012);
  AumaSAR162DutyS450[3] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(67), F16, Mm(75), Rpm(11), Nm(500), Kw(0.6), S450, AM021, AC012);
  AumaSAR162DutyS450[4] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(67), F16, Mm(75), Rpm(16), Nm(500), Kw(1), S450, AM021, AC012);
  AumaSAR162DutyS450[5] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(67), F16, Mm(75), Rpm(22), Nm(500), Kw(1), S450, AM021, AC012);
  AumaSAR162DutyS450[6] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(79), F16, Mm(75), Rpm(32), Nm(500), Kw(2), S450, AM021, AC012);
  AumaSAR162DutyS450[7] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(79), F16, Mm(75), Rpm(45), Nm(500), Kw(2), S450, AM021, AC012);
  AumaSAR162DutyS450[8] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(82), F16, Mm(75), Rpm(63), Nm(500), Kw(3.5), S450, AM021, AC012);
  AumaSAR162DutyS450[9] := TActuator.CreateAuma(AumaSAR, SAR162,
    Nm(710), 1, Kg(82), F16, Mm(75), Rpm(90), Nm(500), Kw(3.5), S450, AM021, AC012);

  AumaSAR251DutyS425[0] := TActuator.CreateAuma(AumaSAR, SAR251,
    Nm(2000), 1, Kg(150), F25, Mm(95), Rpm(4), Nm(1000), Kw(1.1), S425, AM021, AC012);
  AumaSAR251DutyS425[1] := TActuator.CreateAuma(AumaSAR, SAR251,
    Nm(2000), 1, Kg(150), F25, Mm(95), Rpm(5.6), Nm(1000), Kw(1.1), S425, AM021, AC012);
  AumaSAR251DutyS425[2] := TActuator.CreateAuma(AumaSAR, SAR251,
    Nm(2000), 1, Kg(150), F25, Mm(95), Rpm(8), Nm(1000), Kw(3), S425, AM021, AC012);
  AumaSAR251DutyS425[3] := TActuator.CreateAuma(AumaSAR, SAR251,
    Nm(2000), 1, Kg(150), F25, Mm(95), Rpm(11), Nm(1000), Kw(3), S425, AM021, AC012);

  AumaSAR251DutyS450[0] := TActuator.CreateAuma(AumaSAR, SAR251,
    Nm(1400), 1, Kg(150), F25, Mm(95), Rpm(4), Nm(1000), Kw(0.75), S450, AM021, AC012);
  AumaSAR251DutyS450[1] := TActuator.CreateAuma(AumaSAR, SAR251,
    Nm(1400), 1, Kg(150), F25, Mm(95), Rpm(5.6), Nm(1000), Kw(0.75), S450, AM021, AC012);
  AumaSAR251DutyS450[2] := TActuator.CreateAuma(AumaSAR, SAR251,
    Nm(1400), 1, Kg(150), F25, Mm(95), Rpm(8), Nm(1000), Kw(2.2), S450, AM021, AC012);
  AumaSAR251DutyS450[3] := TActuator.CreateAuma(AumaSAR, SAR251,
    Nm(1400), 1, Kg(150), F25, Mm(95), Rpm(11), Nm(1000), Kw(2.2), S450, AM021, AC012);

  AumaSAR301DutyS425[0] := TActuator.CreateAuma(AumaSAR, SAR301,
    Nm(4000), 1, Kg(190), F30, Mm(115), Rpm(4), Nm(2000), Kw(2.2), S425, AM021, AC012);
  AumaSAR301DutyS425[1] := TActuator.CreateAuma(AumaSAR, SAR301,
    Nm(4000), 1, Kg(190), F30, Mm(115), Rpm(5.6), Nm(2000), Kw(2.2), S425, AM021, AC012);
  AumaSAR301DutyS425[2] := TActuator.CreateAuma(AumaSAR, SAR301,
    Nm(4000), 1, Kg(190), F30, Mm(115), Rpm(8), Nm(2000), Kw(5.5), S425, AM021, AC012);
  AumaSAR301DutyS425[3] := TActuator.CreateAuma(AumaSAR, SAR301,
    Nm(4000), 1, Kg(190), F30, Mm(115), Rpm(11), Nm(2000), Kw(5.5), S425, AM021, AC012);

  AumaSAR301DutyS450[0] := TActuator.CreateAuma(AumaSAR, SAR301,
    Nm(2800), 1, Kg(190), F30, Mm(115), Rpm(4), Nm(2000), Kw(1.5), S450, AM021, AC012);
  AumaSAR301DutyS450[1] := TActuator.CreateAuma(AumaSAR, SAR301,
    Nm(2800), 1, Kg(190), F30, Mm(115), Rpm(5.6), Nm(2000), Kw(1.5), S450, AM021, AC012);
  AumaSAR301DutyS450[2] := TActuator.CreateAuma(AumaSAR, SAR301,
    Nm(2800), 1, Kg(190), F30, Mm(115), Rpm(8), Nm(2000), Kw(4), S450, AM021, AC012);
  AumaSAR301DutyS450[3] := TActuator.CreateAuma(AumaSAR, SAR301,
    Nm(2800), 1, Kg(190), F30, Mm(115), Rpm(11), Nm(2000), Kw(4), S450, AM021, AC012);

  AumaSADutyS215[0] := AumaSA072DutyS215;
  AumaSADutyS215[1] := AumaSA076DutyS215;
  AumaSADutyS215[2] := AumaSA102DutyS215;
  AumaSADutyS215[3] := AumaSA142DutyS215;
  AumaSADutyS215[4] := AumaSA146DutyS215;
  AumaSADutyS215[5] := AumaSA162DutyS215;
  AumaSADutyS215[6] := AumaSA251DutyS215;
  AumaSADutyS215[7] := AumaSA301DutyS215;
  AumaSADutyS215[8] := AumaSA351DutyS215;
  AumaSADutyS215[9] := AumaSA401DutyS215;
  AumaSADutyS215[10] := AumaSA481DutyS215;

  AumaSADutyS230[0] := AumaSA072DutyS230;
  AumaSADutyS230[1] := AumaSA076DutyS230;
  AumaSADutyS230[2] := AumaSA102DutyS230;
  AumaSADutyS230[3] := AumaSA142DutyS230;
  AumaSADutyS230[4] := AumaSA146DutyS230;
  AumaSADutyS230[5] := AumaSA162DutyS230;
  AumaSADutyS230[6] := AumaSA251DutyS230;
  AumaSADutyS230[7] := AumaSA301DutyS230;
  AumaSADutyS230[8] := AumaSA351DutyS230;
  AumaSADutyS230[9] := AumaSA401DutyS230;
  AumaSADutyS230[10] := AumaSA481DutyS230;

  AumaSARDutyS425[0] := AumaSAR072DutyS425;
  AumaSARDutyS425[1] := AumaSAR076DutyS425;
  AumaSARDutyS425[2] := AumaSAR102DutyS425;
  AumaSARDutyS425[3] := AumaSAR142DutyS425;
  AumaSARDutyS425[4] := AumaSAR146DutyS425;
  AumaSARDutyS425[5] := AumaSAR162DutyS425;
  AumaSARDutyS425[6] := AumaSAR251DutyS425;
  AumaSARDutyS425[7] := AumaSAR301DutyS425;

  AumaSARDutyS450[0] := AumaSAR072DutyS450;
  AumaSARDutyS450[1] := AumaSAR076DutyS450;
  AumaSARDutyS450[2] := AumaSAR102DutyS450;
  AumaSARDutyS450[3] := AumaSAR142DutyS450;
  AumaSARDutyS450[4] := AumaSAR146DutyS450;
  AumaSARDutyS450[5] := AumaSAR162DutyS450;
  AumaSARDutyS450[6] := AumaSAR251DutyS450;
  AumaSARDutyS450[7] := AumaSAR301DutyS450;

  AumaGK102[0] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK102,
    Nm(120), 1, 0.9, Kg(8.5), F10, Mm(40), False, Mm(315));
  AumaGK102[1] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK102,
    Nm(120), 2, 1.8, Kg(8.5), F10, Mm(40), False, Mm(200));

  AumaGK142[0] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK142,
    Nm(250), 2, 1.8, Kg(15), F14, Mm(57), False, Mm(315));
  AumaGK142[1] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK142,
    Nm(250), 2.8, 2.5, Kg(15), F14, Mm(57), False, Mm(200));

  AumaGK146[0] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK146,
    Nm(500), 2.8, 2.5, Kg(15), F14, Mm(57), False, Mm(400));
  AumaGK146[1] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK146,
    Nm(500), 4, 3.6, Kg(15), F14, Mm(57), False, Mm(315));

  AumaGK162[0] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK162,
    Nm(1000), 4, 3.6, Kg(25), F16, Mm(75), False, Mm(500));
  AumaGK162[1] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK162,
    Nm(1000), 5.6, 5, Kg(25), F16, Mm(75), False, Mm(400));

  AumaGK252[0] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK252,
    Nm(2000), 5.6, 5, Kg(60), F25, Mm(95), False, Mm(630));
  AumaGK252[1] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK252,
    Nm(2000), 8, 7.2, Kg(60), F25, Mm(95), False, Mm(500));

  AumaGK302[0] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK302,
    Nm(4000), 8, 7.2, Kg(110), F30, Mm(115), False, Mm(800));
  AumaGK302[1] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK302,
    Nm(4000), 11, 9.9, Kg(110), F30, Mm(115), False, Mm(800));

  AumaGK352[0] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK352,
    Nm(8000), 11, 9.9, Kg(190), F35, Mm(155), False, Mm(800));
  AumaGK352[1] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK352,
    Nm(8000), 16, 14.4, Kg(190), F35, Mm(155), False, Mm(800));

  AumaGK402[0] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK402,
    Nm(16000), 16, 14.4, Kg(250), F40, Mm(175), False, Mm(800));
  AumaGK402[1] := TGearbox.Create(SAuma, TGearboxType.AumaGK, GK402,
    Nm(16000), 22, 19.8, Kg(250), F40, Mm(175), False, Mm(800));

  AumaGK[0] := AumaGK102;
  AumaGK[1] := AumaGK142;
  AumaGK[2] := AumaGK146;
  AumaGK[3] := AumaGK162;
  AumaGK[4] := AumaGK252;
  AumaGK[5] := AumaGK302;
  AumaGK[6] := AumaGK352;
  AumaGK[7] := AumaGK402;

  AumaGST101[0] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST101,
    Nm(120), 1, 0.9, Kg(14), F10, Mm(40), True, Mm(200));
  AumaGST101[1] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST101,
    Nm(120), 1.4, 1.3, Kg(14), F10, Mm(40), True, Mm(200));
  AumaGST101[2] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST101,
    Nm(120), 2, 1.8, Kg(14), F10, Mm(40), True, Mm(200));

  AumaGST141[0] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST141,
    Nm(250), 1.4, 1.3, Kg(26), F14, Mm(57), True, Mm(315));
  AumaGST141[1] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST141,
    Nm(250), 2, 1.8, Kg(26), F14, Mm(57), True, Mm(315));
  AumaGST141[2] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST141,
    Nm(250), 2.8, 2.5, Kg(26), F14, Mm(57), True, Mm(250));

  AumaGST145[0] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST145,
    Nm(500), 2, 1.8, Kg(26), F14, Mm(57), True, Mm(315));
  AumaGST145[1] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST145,
    Nm(500), 2.8, 2.5, Kg(26), F14, Mm(57), True, Mm(315));
  AumaGST145[2] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST145,
    Nm(500), 4, 3.6, Kg(26), F14, Mm(57), True, Mm(315));

  AumaGST161[0] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST161,
    Nm(1000), 2.8, 2.5, Kg(40), F16, Mm(75), True, Mm(400));
  AumaGST161[1] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST161,
    Nm(1000), 4, 3.6, Kg(40), F16, Mm(75), True, Mm(400));
  AumaGST161[2] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST161,
    Nm(1000), 5.6, 5, Kg(40), F16, Mm(75), True, Mm(400));

  AumaGST251[0] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST251,
    Nm(2000), 4, 3.6, Kg(82), F25, Mm(95), True, Mm(500));
  AumaGST251[1] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST251,
    Nm(2000), 5.6, 5, Kg(82), F25, Mm(95), True, Mm(500));
  AumaGST251[2] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST251,
    Nm(2000), 8, 7.2, Kg(82), F25, Mm(95), True, Mm(500));

  AumaGST301[0] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST301,
    Nm(4000), 5.6, 5, Kg(115), F30, Mm(115), True, Mm(500));
  AumaGST301[1] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST301,
    Nm(4000), 8, 7.2, Kg(115), F30, Mm(115), True, Mm(500));
  AumaGST301[2] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST301,
    Nm(4000), 11, 9.9, Kg(115), F30, Mm(115), True, Mm(500));

  AumaGST351[0] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST351,
    Nm(8000), 8, 7.2, Kg(195), F35, Mm(155), True, Mm(500));
  AumaGST351[1] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST351,
    Nm(8000), 11, 9.9, Kg(195), F35, Mm(155), True, Mm(500));
  AumaGST351[2] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST351,
    Nm(8000), 16, 14.4, Kg(195), F35, Mm(155), True, Mm(500));

  AumaGST401[0] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST401,
    Nm(16000), 11, 9.9, Kg(255), F40, Mm(175), True, Mm(500));
  AumaGST401[1] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST401,
    Nm(16000), 16, 14.4, Kg(255), F40, Mm(175), True, Mm(500));
  AumaGST401[2] := TGearbox.Create(SAuma, TGearboxType.AumaGST, GST401,
    Nm(16000), 22, 19.8, Kg(255), F40, Mm(175), True, Mm(500));

  AumaGST[0] := AumaGST101;
  AumaGST[1] := AumaGST141;
  AumaGST[2] := AumaGST145;
  AumaGST[3] := AumaGST161;
  AumaGST[4] := AumaGST251;
  AumaGST[5] := AumaGST301;
  AumaGST[6] := AumaGST351;
  AumaGST[7] := AumaGST401;

  { R A 19 C 1 E B7 FLS
    R A 19 C 1 F B7 FLS
    R A 19 C 1 E B7 FLS seA }

  TramecR19[0] := TGearbox.Create(STramec, TGearboxType.TramecR,
    'R A 19 C 1 E B7 FLS', Nm(35), 1, 1, Kg(8.5), '', Mm(0), True, 0);
  TramecR24[0] := TGearbox.Create(STramec, TGearboxType.TramecR,
    'R A 24 C 1 E B7 FLS', Nm(73), 1, 1, Kg(14), '', Mm(0), True, 0);
  TramecR28[0] := TGearbox.Create(STramec, TGearboxType.TramecR,
    'R A 28 C 1 E B7 FLS', Nm(146), 1, 1, Kg(23), '', Mm(0), True, 0);
  TramecR38[0] := TGearbox.Create(STramec, TGearboxType.TramecR,
    'R A 38 C 1 E B7 FLS', Nm(291), 1, 1, Kg(38), '', Mm(0), True, 0);
  TramecR48[0] := TGearbox.Create(STramec, TGearboxType.TramecR,
    'R A 48 C 1 E B7 FLS', Nm(596), 1, 1, Kg(62), '', Mm(0), True, 0);

  TramecR[0] := TramecR19;
  TramecR[1] := TramecR24;
  TramecR[2] := TramecR28;
  TramecR[3] := TramecR38;
  TramecR[4] := TramecR48;

  MechanicRZAM500[0] := TGearbox.Create(SMechanic, TGearboxType.MechanicRZAM,
    RZAM500, Nm(250), 6, 4.2, Kg(8), F10, Mm(45), False, Mm(300));
  MechanicRZAM500[1] := TGearbox.Create(SMechanic, TGearboxType.MechanicRZAM,
    RZAM500, Nm(500), 7, 4.8, Kg(8), F14, Mm(45), False, Mm(500));

  MechanicRZAM1000[0] := TGearbox.Create(SMechanic, TGearboxType.MechanicRZAM,
    RZAM1000, Nm(800), 12, 7.8, Kg(11), F16, Mm(60), False, Mm(500));
  MechanicRZAM1000[1] := TGearbox.Create(SMechanic, TGearboxType.MechanicRZAM,
    RZAM1000, Nm(1000), 17, 9.8, Kg(11), F16, Mm(60), False, Mm(500));

  MechanicRZAM2500[0] := TGearbox.Create(SMechanic, TGearboxType.MechanicRZAM,
    RZAM2500, Nm(1500), 35, 13.8, Kg(28), F25, Mm(80), False, Mm(500));

  MechanicRZAMS210000[0] := TGearbox.Create(SMechanic, TGearboxType.MechanicRZAM,
    RZAMS210000, Nm(4000), 154, 65.4, Kg(88), F30, Mm(110), False, Mm(300));
  MechanicRZAMS210000[1] := TGearbox.Create(SMechanic, TGearboxType.MechanicRZAM,
    RZAMS210000, Nm(10000), 330, 92, Kg(91), F35, Mm(110), False, Mm(500));

  MechanicRZAM[0] := MechanicRZAM500;
  MechanicRZAM[1] := MechanicRZAM1000;
  MechanicRZAM[2] := MechanicRZAM2500;
  MechanicRZAM[3] := MechanicRZAMS210000;

  RotorkIB5[0] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN5, Nm(306), 2, 1.7, Kg(20), F14, Mm(55), True, 0);
  RotorkIB5[1] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN5, Nm(678), 3, 2.55, Kg(20), F14, Mm(55), True, 0);
  RotorkIB5[2] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN5, Nm(678), 4, 3.4, Kg(20), F14, Mm(55), True, 0);
  RotorkIB5[3] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN5, Nm(542), 6, 5.1, Kg(20), F14, Mm(55), True, 0);

  RotorkIB7[0] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN7, Nm(1355), 3, 2.55, Kg(35), F16, Mm(73), True, 0);
  RotorkIB7[1] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN7, Nm(1355), 4, 3.4, Kg(35), F16, Mm(73), True, 0);
  RotorkIB7[2] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN7, Nm(1084), 6, 5.1, Kg(35), F16, Mm(73), True, 0);

  RotorkIB9[0] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN9, Nm(2033), 3, 2.55, Kg(70), F25, Mm(86), True, 0);
  RotorkIB9[1] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN9, Nm(2033), 4, 3.4, Kg(70), F25, Mm(86), True, 0);
  RotorkIB9[2] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN9, Nm(1627), 6, 5.1, Kg(70), F25, Mm(86), True, 0);

  RotorkIB11[0] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN11, Nm(4067), 4, 3.4, Kg(125), F30, Mm(100), True, 0);
  RotorkIB11[1] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN11, Nm(4067), 6, 5.1, Kg(125), F30, Mm(100), True, 0);

  RotorkIB13[0] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN13, Nm(8135), 6, 5.1, Kg(200), F35, Mm(120), True, 0);
  RotorkIB13[1] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN13, Nm(8135), 8, 6.8, Kg(200), F35, Mm(120), True, 0);

  RotorkIB14[0] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN14, Nm(8135), 6, 5.1, Kg(342), F40, Mm(150), True, 0);
  RotorkIB14[1] := TGearbox.Create(SRotork, TGearboxType.RotorkIB,
    IBN14, Nm(8135), 8, 6.8, Kg(342), F40, Mm(150), True, 0);

  RotorkIB[0] := RotorkIB5;
  RotorkIB[1] := RotorkIB7;
  RotorkIB[2] := RotorkIB9;
  RotorkIB[3] := RotorkIB11;
  RotorkIB[4] := RotorkIB13;
  RotorkIB[5] := RotorkIB14;

  HandWheels[0] := THandWheel.Create('', 'Ø315', 0.315, Nm(0), 1, Kg(5.9), Mm(20));
  HandWheels[1] := THandWheel.Create('', 'Ø400', 0.4, Nm(0), 1, Kg(10), Mm(30));
  HandWheels[2] := THandWheel.Create('', 'Ø500', 0.5, Nm(0), 1, Kg(15), Mm(40));
end.
