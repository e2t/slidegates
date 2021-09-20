unit Controller;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

procedure Run();
procedure MainFormInit();
procedure RePrintResults();

implementation

uses
  DriveUnits, GuiMainForm, Screws, Measurements, StrengthCalculations,
  Localization, SysUtils, Nullable, StdCtrls, Classes, Controls,
  GuiHelper, MassGeneral, ProgramInfo, Equations, Fgl;

type
  TArrayControlBlock = array of TControlBlock;
  TFuncInputDataError = function(const Lang: TLang): string;

  TActuatorWithControl = record
    ModelActuator: TModelActuator;
    ControlBlock: TControlBlock;
  end;
  TChoiceModelActuator = specialize TFPGMap<string, TActuatorWithControl>;
  TChoiceModelGearbox = specialize TFPGMap<string, TModelGearbox>;

var
  ModelOpenCloseActuators, ModelRegulActuators: TChoiceModelActuator;
  OpenCloseActuators, RegulActuators: TArrayActuator;
  ModelBevelGearboxes, ModelSpurGearboxes: TChoiceModelGearbox;
  BevelGearboxes, SpurGearboxes: TArrayGearbox;
  OpenCloseActuatorControlBlocks, RegulActuatorControlBlocks: TArrayControlBlock;
  LabelHandWheelText: string;

function ActuatorName(const Actuator: TActuator;
  const ControlBlock: TControlBlock): string;
var
  ControlBlockName: string;
begin
  if ControlBlock <> NoBlock then
    ControlBlockName := ' / ' + Actuator.ControlBlockNames[ControlBlock];
  Result := Actuator.Brand + ' ' + Actuator.Name + ControlBlockName;
end;

function ItemActuator(const Actuator: TActuator;
  const ControlBlock: TControlBlock): string;
begin
  Result := Format('%S (%S)  %S об/мин  %S кВт',
    [ActuatorName(Actuator, ControlBlock), Actuator.Duty,
    FormatFloat('0.###', ToRpm(Actuator.Speed)), FormatFloat('0.0##',
    ToKw(Actuator.Power))]);
end;

function ItemGearbox(const Gearbox: TGearbox): string;
begin
  Result := Format('%S %S  (ratio=%S)', [Gearbox.Brand, Gearbox.Name,
    FormatFloat('0.###', Gearbox.Ratio)]);
end;

procedure ComboBoxActuatorFill(const ComboBox: TComboBox;
  var LinearArrayActuator: TArrayActuator; const ModelActuator: TModelActuator;
  var LinearArrayControlBlocks: TArrayControlBlock; const ControlBlock: TControlBlock);
var
  ArrayActuator: TArrayActuator;
  Actuator: TActuator;
  I: Integer;
begin
  for ArrayActuator in ModelActuator do
    for Actuator in ArrayActuator do
    begin
      ComboBox.Items.Add(ItemActuator(Actuator, ControlBlock));
      I := ComboBox.Items.Count - 1;
      LinearArrayActuator[I] := Actuator;
      LinearArrayControlBlocks[I] := ControlBlock;
    end;
end;

procedure ComboBoxGearboxFill(const ComboBox: TComboBox;
  var LinearArrayGearbox: TArrayGearbox; const ModelGearbox: TModelGearbox);
var
  ArrayGearbox: TArrayGearbox;
  Gearbox: TGearbox;
  I: Integer;
begin
  for ArrayGearbox in ModelGearbox do
    for Gearbox in ArrayGearbox do
    begin
      ComboBox.Items.Add(ItemGearbox(Gearbox));
      I := ComboBox.Items.Count - 1;
      LinearArrayGearbox[I] := Gearbox;
    end;
end;

procedure MainFormInit();
var
  ScrewSet: TBuyableScrewSet;
  I: Integer;
begin
  MainForm.Caption := GetProgramTitle;
  MainForm.ActiveControl := MainForm.EditFrameWidth;
  MainForm.LabelHandWheel.Caption := LabelHandWheelText;

  { Приводы Открыть-Закрыть }
  for I := 0 to ModelOpenCloseActuators.Count - 1 do
    MainForm.ComboBoxOpenCloseActuator.Items.Add(ModelOpenCloseActuators.Keys[I]);

  SetLength(OpenCloseActuators, 1024);
  SetLength(OpenCloseActuatorControlBlocks, 1024);
  ComboBoxActuatorFill(MainForm.ComboBoxOpenCloseActuator, OpenCloseActuators,
    AumaSADutyS215, OpenCloseActuatorControlBlocks, NoBlock);
  ComboBoxActuatorFill(MainForm.ComboBoxOpenCloseActuator, OpenCloseActuators,
    AumaSADutyS215, OpenCloseActuatorControlBlocks, AumaAM);
  ComboBoxActuatorFill(MainForm.ComboBoxOpenCloseActuator, OpenCloseActuators,
    AumaSADutyS215, OpenCloseActuatorControlBlocks, AumaAC);
  ComboBoxActuatorFill(MainForm.ComboBoxOpenCloseActuator, OpenCloseActuators,
    AumaSADutyS230, OpenCloseActuatorControlBlocks, NoBlock);
  ComboBoxActuatorFill(MainForm.ComboBoxOpenCloseActuator, OpenCloseActuators,
    AumaSADutyS230, OpenCloseActuatorControlBlocks, AumaAM);
  ComboBoxActuatorFill(MainForm.ComboBoxOpenCloseActuator, OpenCloseActuators,
    AumaSADutyS230, OpenCloseActuatorControlBlocks, AumaAC);
  MainForm.ComboBoxOpenCloseActuator.ItemIndex := 0;
  SetLength(OpenCloseActuators, MainForm.ComboBoxOpenCloseActuator.Items.Count);
  SetLength(OpenCloseActuatorControlBlocks,
    MainForm.ComboBoxOpenCloseActuator.Items.Count);

  { Регулирующие приводы }
  for I := 0 to ModelRegulActuators.Count - 1 do
    MainForm.ComboBoxRegulActuator.Items.Add(ModelRegulActuators.Keys[I]);

  SetLength(RegulActuators, 1024);
  SetLength(RegulActuatorControlBlocks, 1024);
  ComboBoxActuatorFill(MainForm.ComboBoxRegulActuator, RegulActuators,
    AumaSARDutyS425, RegulActuatorControlBlocks, NoBlock);
  ComboBoxActuatorFill(MainForm.ComboBoxRegulActuator, RegulActuators,
    AumaSARDutyS425, RegulActuatorControlBlocks, AumaAM);
  ComboBoxActuatorFill(MainForm.ComboBoxRegulActuator, RegulActuators,
    AumaSARDutyS425, RegulActuatorControlBlocks, AumaAC);
  ComboBoxActuatorFill(MainForm.ComboBoxRegulActuator, RegulActuators,
    AumaSARDutyS450, RegulActuatorControlBlocks, NoBlock);
  ComboBoxActuatorFill(MainForm.ComboBoxRegulActuator, RegulActuators,
    AumaSARDutyS450, RegulActuatorControlBlocks, AumaAM);
  ComboBoxActuatorFill(MainForm.ComboBoxRegulActuator, RegulActuators,
    AumaSARDutyS450, RegulActuatorControlBlocks, AumaAC);
  MainForm.ComboBoxRegulActuator.ItemIndex := 0;
  SetLength(RegulActuators, MainForm.ComboBoxRegulActuator.Items.Count);
  SetLength(RegulActuatorControlBlocks, MainForm.ComboBoxRegulActuator.Items.Count);

  { Угловые редукторы }
  for I := 0 to ModelBevelGearboxes.Count - 1 do
    MainForm.ComboBoxBevelGearbox.Items.Add(ModelBevelGearboxes.Keys[I]);

  SetLength(BevelGearboxes, 1024);
  ComboBoxGearboxFill(MainForm.ComboBoxBevelGearbox, BevelGearboxes,
    AumaGK);
  ComboBoxGearboxFill(MainForm.ComboBoxBevelGearbox, BevelGearboxes,
    TramecR);
  MainForm.ComboBoxBevelGearbox.ItemIndex := 0;
  SetLength(BevelGearboxes, MainForm.ComboBoxBevelGearbox.Items.Count);

  { Цилиндрические редукторы }
  for I := 0 to ModelSpurGearboxes.Count - 1 do
    MainForm.ComboBoxSpurGearbox.Items.Add(ModelSpurGearboxes.Keys[I]);

  SetLength(SpurGearboxes, 1024);
  ComboBoxGearboxFill(MainForm.ComboBoxSpurGearbox, SpurGearboxes,
    AumaGST);
  MainForm.ComboBoxSpurGearbox.ItemIndex := 0;
  SetLength(SpurGearboxes, MainForm.ComboBoxSpurGearbox.Items.Count);

  for ScrewSet in StdScrews do
    MainForm.ComboBoxScrew.Items.Add(ScrewSet.Screw.SizeToStr);
end;

function DefineLang(): TLang;
begin
  if MainForm.RadioButtonLangRus.Checked then
    Result := Rus
  else if MainForm.RadioButtonLangEng.Checked then
    Result := Eng;
end;

function ErrorIncorrectValue(const Lang: TLang): string;
begin
  Result := L10n[62, Lang];
end;

function ErrorNonBevelGearboxWithTwoScrews(const Lang: TLang): string;
begin
  Result := L10n[74, Lang];
end;

procedure GetGearboxOrModel(var ModelGearbox: TModelGearbox; var Gearbox: TGearbox);
var
  Choice: string;
begin
  if MainForm.RadioButtonBevelGearbox.Checked then
  begin
    Choice := MainForm.ComboBoxBevelGearbox.Text;
    if not ModelBevelGearboxes.TryGetData(Choice, ModelGearbox) then
      Gearbox := BevelGearboxes[MainForm.ComboBoxBevelGearbox.ItemIndex];
  end
  else if MainForm.RadioButtonSpurGearbox.Checked then
  begin
    Choice := MainForm.ComboBoxSpurGearbox.Text;
    if not ModelSpurGearboxes.TryGetData(Choice, ModelGearbox) then
      Gearbox := SpurGearboxes[MainForm.ComboBoxSpurGearbox.ItemIndex];
  end;
end;

function CreateInputData(out InputData: TInputData): TFuncInputDataError;
const
  Delims: array [0..4] of string = ('x', 'X', 'х', 'Х', ' ');
var
  ScrewSize: array of string;
  ScrewNote, Choice: string;
  I: Integer;
  Value, AMaxWay: Double;
  ActuatorWithControl: TActuatorWithControl;
begin
  InputData := Default(TInputData);
  Result := nil;

  if MainForm.EditFrameWidth.GetRealMinEqMaxEq(Value, MinFrameWidth, MaxFrameWidth) then
    InputData.FrameWidth := Metre(Value)
  else
    Exit(@ErrorIncorrectValue);

  if MainForm.EditGateHeight.GetRealMinEqMaxEq(Value, MinGateHeight, MaxGateHeight) then
    InputData.GateHeight := Metre(Value)
  else
    Exit(@ErrorIncorrectValue);

  if MainForm.EditFrameHeight.GetRealMinEqMaxEq(Value,
    MinFrameHeight(InputData.GateHeight), MaxFrameHeight) then
    InputData.FrameHeight := Metre(Value)
  else
    Exit(@ErrorIncorrectValue);

  { Типы затворов и способы установки }
  if MainForm.PageControlSlgKind.ActivePage = MainForm.TabSheetSurf then
  begin
    InputData.SlgKind := Surf;
    if MainForm.RadioButtonSurfChannel.Checked then
      InputData.InstallKind := Channel
    else if MainForm.RadioButtonSurfConcrete.Checked then
      InputData.InstallKind := Concrete
    else if MainForm.RadioButtonSurfWall.Checked then
      InputData.InstallKind := Wall;
  end
  else if MainForm.PageControlSlgKind.ActivePage = MainForm.TabSheetDeep then
  begin
    InputData.SlgKind := Deep;

    if MainForm.EditHydrHead.GetRealMinEqMaxEq(Value, InputData.GateHeight,
      MaxHydrHead) then
      InputData.HydrHead.Value := Metre(Value)
    else
      Exit(@ErrorIncorrectValue);

    if MainForm.RadioButtonDeepConcrete.Checked then
      InputData.InstallKind := Concrete
    else if MainForm.RadioButtonDeepWall.Checked then
      InputData.InstallKind := Wall
    else
    begin
      if MainForm.RadioButtonDeepFlange.Checked then
        InputData.InstallKind := Flange
      else if MainForm.RadioButtonDeepTwoFlange.Checked then
      begin
        InputData.InstallKind := TwoFlange;
        InputData.IsFrameClosed := True;
      end;
      InputData.HaveCounterFlange := MainForm.CheckBoxCounterFlange.Checked;
    end;
  end
  else if MainForm.PageControlSlgKind.ActivePage = MainForm.TabSheetFlow then
  begin
    InputData.SlgKind := Flow;

    if MainForm.EditBethFrameTopAndGateTop.GetRealMin(Value, 0) then
      InputData.BethFrameTopAndGateTop.Value := Metre(Value)
    else
      Exit(@ErrorIncorrectValue);

    if MainForm.RadioButtonRegulChannel.Checked then
    begin
      InputData.InstallKind := Channel;
      InputData.HaveFixedGate := True;
    end
    else if MainForm.RadioButtonRegulConcrete.Checked then
    begin
      InputData.InstallKind := Concrete;
      InputData.HaveFixedGate := True;
    end
    else if MainForm.RadioButtonRegulWall.Checked then
    begin
      InputData.InstallKind := Wall;
      InputData.HaveFixedGate := False;
    end;
  end;

  { Тип управления (приводы) }
  if MainForm.PageControlDriveKind.ActivePage = MainForm.TabSheetActuator then
  begin
    if MainForm.RadioButtonOpenClose.Checked then
    begin
      InputData.DriveKind := OpenCloseActuator;
      Choice := MainForm.ComboBoxOpenCloseActuator.Text;
      if ModelOpenCloseActuators.TryGetData(Choice, ActuatorWithControl) then
      begin
        InputData.ModelActuator := ActuatorWithControl.ModelActuator;
        InputData.ControlBlock := ActuatorWithControl.ControlBlock;
      end
      else
      begin
        I := MainForm.ComboBoxOpenCloseActuator.ItemIndex;
        InputData.Actuator := OpenCloseActuators[I];
        InputData.ControlBlock := OpenCloseActuatorControlBlocks[I];
      end;
    end
    else if MainForm.RadioButtonRegul.Checked then
    begin
      InputData.DriveKind := RegulActuator;
      Choice := MainForm.ComboBoxRegulActuator.Text;
      if ModelRegulActuators.TryGetData(Choice, ActuatorWithControl) then
      begin
        InputData.ModelActuator := ActuatorWithControl.ModelActuator;
        InputData.ControlBlock := ActuatorWithControl.ControlBlock;
      end
      else
      begin
        I := MainForm.ComboBoxRegulActuator.ItemIndex;
        InputData.Actuator := RegulActuators[I];
        InputData.ControlBlock := RegulActuatorControlBlocks[I];
      end;
    end;
  end
  else if MainForm.PageControlDriveKind.ActivePage = MainForm.TabSheetGearbox then
  begin
    if MainForm.RadioButtonBevelGearbox.Checked then
      InputData.DriveKind := BevelGearbox
    else if MainForm.RadioButtonSpurGearbox.Checked then
      InputData.DriveKind := SpurGearbox;
    GetGearboxOrModel(InputData.ModelGearbox, InputData.Gearbox);
  end
  else if MainForm.PageControlDriveKind.ActivePage = MainForm.TabSheetHandWheel then
    InputData.DriveKind := HandWheel;

  if MainForm.PageControlDriveLocation.ActivePage = MainForm.TabSheetOnFrame then
    InputData.DriveLocation := OnFrame
  else if MainForm.PageControlDriveLocation.ActivePage = MainForm.TabSheetOnRack then
  begin
    InputData.DriveLocation := OnRack;
    if MainForm.EditBtwFrameTopAndGround.GetRealMin(Value, 0) then
      InputData.BtwFrameTopAndDriveUnit := Metre(Value) + RackHeight
    else
      Exit(@ErrorIncorrectValue);
    InputData.HavePipeNodes := not MainForm.CheckBoxRackWithoutPipeNodes.Checked;
  end
  else if MainForm.PageControlDriveLocation.ActivePage = MainForm.TabSheetOnBracket then
  begin
    InputData.DriveLocation := OnBracket;
    if MainForm.EditBtwFrameTopAndDriveUnit.GetRealMin(Value, 0.1) then
      InputData.BtwFrameTopAndDriveUnit := Metre(Value)
    else
      Exit(@ErrorIncorrectValue);
    InputData.HavePipeNodes := not MainForm.CheckBoxBracketWithoutPipeNodes.Checked;
  end;

  if MainForm.RadioButtonNonPullout.Checked then
    InputData.IsScrewPullout := False
  else if MainForm.RadioButtonPullout.Checked then
    InputData.IsScrewPullout := True;

  { 0 для горизонтальных затворов }
  InputData.TiltAngle := PI / 2;

  if MainForm.EditLiquidDensity.GetRealMin(Value, 0) then
    InputData.LiquidDensity := KgPerM3(Value)
  else
    Exit(@ErrorIncorrectValue);

  if MainForm.CheckBoxWithoutFrameNodes.Checked then
    InputData.HaveFrameNodes.Value := False;

  if MainForm.CheckBoxThreeWedgePairs.Checked then
    InputData.WedgePairsCount.Value := 3;

  if MainForm.EditWay.Text <> '' then
  begin
    AMaxWay := MaxWay(InputData.FrameHeight, InputData.GateHeight);
    if MainForm.EditWay.GetRealMinMaxEq(Value, 0, AMaxWay) then
      InputData.Way.Value := Metre(Value)
    else
      Exit(@ErrorIncorrectValue);
  end;

  ScrewNote := MainForm.ComboBoxScrew.Text;
  if ScrewNote <> '' then
  begin
    ScrewSize := ScrewNote.Split(Delims);
    if Length(ScrewSize) <> 2 then
      Exit(@ErrorIncorrectValue)
    else
    begin
      if MainForm.ComboBoxScrew.GetRealMin(ScrewSize[0], Value, 0) then
        InputData.ScrewDiam.Value := Mm(Value)
      else
        Exit(@ErrorIncorrectValue);

      if MainForm.ComboBoxScrew.GetRealMinMax(ScrewSize[1], Value,
        0, ToMm(InputData.ScrewDiam.Value / 2)) then
        InputData.ScrewPitch.Value := Mm(Value)
      else
        Exit(@ErrorIncorrectValue);
    end;
  end;

  if (MainForm.EditMinSpeed.Text <> '') then
  begin
    if MainForm.EditMinSpeed.GetRealMinEq(Value, 0) then
      InputData.RecommendMinSpeed := Rpm(Value)
    else
      Exit(@ErrorIncorrectValue);
  end
  else
    InputData.RecommendMinSpeed := 0;

  if MainForm.EditFullWays.GetRealMin(Value, 0) then
    InputData.FullWays := Value  { безразмерная величина }
  else
    Exit(@ErrorIncorrectValue);

  if MainForm.CheckBoxTwoScrews.Checked then
  begin
    if not MainForm.RadioButtonBevelGearbox.Checked then
      Exit(@ErrorNonBevelGearboxWithTwoScrews);
    InputData.ScrewsNumber := 2;
    GetGearboxOrModel(InputData.ModelGearbox, InputData.Gearbox);
  end
  else
    InputData.ScrewsNumber := 1;
end;

function Designation(const Slg: TSlidegate; const Lang: Integer): string;
var
  DsgKind, DsgControl: string;
begin
  case Slg.SlgKind of
    Deep: DsgKind := L10n[3, Lang];
    Surf: DsgKind := L10n[2, Lang];
    else
      if Slg.InstallKind = Wall then
        DsgKind := L10n[5, Lang]
      else
        DsgKind := L10n[4, Lang]
  end;

  case Slg.DriveKind of
    OpenCloseActuator, RegulActuator:
      DsgControl := L10n[6, Lang];
    else
      DsgControl := L10n[7, Lang];
  end;

  Result := L10n[8, Lang] + DsgKind + DsgControl + ' ' +
    FormatFloat('0.0##', Slg.FrameWidth) + 'x' +
    FormatFloat('0.0##', Slg.FrameHeight) + '(' +
    FormatFloat('0.0##', Slg.GateHeight) + ')';
  if Slg.IsSmall then
    Result := Result + L10n[85, Lang];
end;

procedure OutputAumaActuator(var Put: TStringList; const Slg: TSlidegate;
  const Lang: TLang);
begin
  Put.Append(Format(L10n[30, Lang], [ActuatorName(Slg.Actuator, Slg.ControlBlock)]));
  if Slg.ControlBlock <> NoBlock then
    Put.Append(Format(L10n[55, Lang],
      [Slg.Actuator.ControlBlockNames[Slg.ControlBlock]]));
  Put.Append(Format(L10n[31, Lang], [ToRpm(Slg.Actuator.Speed)]));
  Put.Append(Format(L10n[32, Lang], [ToKw(Slg.Actuator.Power)]));
  Put.Append(Format(L10n[36, Lang], [Slg.Actuator.Duty]));
  Put.Append(Format(L10n[33, Lang], [Slg.Actuator.MinTorque, Slg.Actuator.MaxTorque]));
  Put.Append(Format(L10n[34, Lang], [Slg.Actuator.Flange]));
  Put.Append(Format(L10n[35, Lang], [Slg.Sleeve]));
  Put.Append(L10n[37, Lang]);
  if Slg.SlgKind = Flow then
    Put.Append(Format(L10n[64, Lang], [Slg.OpenTorque]))
  else
    Put.Append(Format(L10n[38, Lang], [Slg.OpenTorque, Slg.CloseTorque]));
  Put.Append(Format(L10n[39, Lang], [ToMin(Slg.OpenTime), Slg.OpenTime, Slg.Revs]));
  Put.Append(Format(L10n[40, Lang], [Slg.MinDriveUnitTemperature,
    Slg.MaxDriveUnitTemperature]));
  Put.Append(L10n[41, Lang]);
  Put.Append(L10n[42, Lang]);
  Put.Append(L10n[43, Lang]);
  Put.Append(L10n[44, Lang]);
  Put.Append(L10n[45, Lang]);
  Put.Append(L10n[46, Lang]);
  Put.Append(L10n[47, Lang]);
  Put.Append(L10n[48, Lang]);
  Put.Append(L10n[49, Lang]);
  Put.Append(L10n[50, Lang]);
  Put.Append(L10n[51, Lang]);
  Put.Append(L10n[52, Lang]);
  Put.Append(L10n[53, Lang]);
  Put.Append(L10n[54, Lang]);
  Put.Append('');
end;

procedure OutputHandWheel(var Put: TStringList; const HandWheel: THandWheel;
  const Lang: TLang);
begin
  if HandWheel.Name = '' then
    Put.Append(Format(L10n[60, Lang], [ToMm(HandWheel.Diameter)]))
  else
    Put.Append(Format(L10n[61, Lang], [HandWheel.Name]));
  Put.Append('');
end;

procedure OutputAumaGearbox(var Put: TStringList; const Grb: TGearbox;
  const Lang: TLang; const Sleeve: string; const ScrewsNumber: Integer);
var
  DriveName: string;
begin
  case Grb.GearboxType of
    TGearboxType.AumaGK, TGearboxType.MechanicRZAM:
      DriveName := Format(L10n[58, Lang], [Grb.Brand, Grb.Name]);
    TGearboxType.AumaGST:
      DriveName := Format(L10n[56, Lang], [Grb.Brand, Grb.Name]);
  end;
  if ScrewsNumber > 1 then
    DriveName := DriveName + ' (x2)';
  Put.Append(DriveName);
  Put.Append(Format(L10n[57, Lang], [Grb.NominalRatio, Grb.Ratio]));
  if Grb.HandWheelDiam > 0 then
    Put.Append(Format(L10n[83, Lang], [ToMm(Grb.HandWheelDiam)]));
  Put.Append(Format(L10n[59, Lang], [Grb.MaxTorque]));
  Put.Append(Format(L10n[34, Lang], [Grb.Flange]));
  Put.Append(Format(L10n[35, Lang], [Sleeve]));
  Put.Append('');
end;

procedure OutputRotorkGearbox(var Put: TStringList; const Grb: TGearbox;
  const Lang: TLang; const Sleeve: string; const Need2InputShaft: Boolean);
begin
  Put.Append(Format(L10n[58, Lang], [Grb.Brand, Grb.Name]));
  if Need2InputShaft then
    Put.Append(Format(L10n[58, Lang], [Grb.Brand, Grb.Name +
      ' DUAL INPUT BEVEL GEARCASE (180)']));
  Put.Append(Format(L10n[57, Lang], [Grb.NominalRatio, Grb.Ratio]));
  if Grb.HandWheelDiam > 0 then
    Put.Append(Format(L10n[83, Lang], [ToMm(Grb.HandWheelDiam)]));
  Put.Append(Format(L10n[59, Lang], [Grb.MaxTorque]));
  Put.Append(Format(L10n[34, Lang], [Grb.Flange]));
  Put.Append(Format(L10n[35, Lang], [Sleeve]));
  Put.Append('');
end;

procedure OutputTramecGearbox(var Put: TStringList; const Grb: TGearbox;
  const Lang: TLang; const Need2InputShaft: Boolean);
begin
  Put.Append(Format(L10n[58, Lang], [Grb.Brand, Grb.Name]));
  if Need2InputShaft then
    Put.Append(Format(L10n[58, Lang], [Grb.Brand, Grb.Name + ' seA']));
  Put.Append(Format(L10n[57, Lang], [Grb.NominalRatio, Grb.Ratio]));
  if Grb.HandWheelDiam > 0 then
    Put.Append(Format(L10n[83, Lang], [ToMm(Grb.HandWheelDiam)]));
  Put.Append(Format(L10n[59, Lang], [Grb.MaxTorque]));
  Put.Append('');
end;

procedure OutputScrew(var Put: TStringList; const IsRightHandedScrew: Boolean;
  const Screw: TScrew; const ThreadLength: Double; const Lang: TLang);
begin
  if IsRightHandedScrew then
    Put.Append(Format(L10n[11, Lang], [L10n[9, Lang], Screw.DesignationR,
      ToMm(Screw.MajorDiam), ThreadLength]))
  else
    Put.Append(Format(L10n[11, Lang], [L10n[10, Lang], Screw.DesignationL,
      ToMm(Screw.MajorDiam), ThreadLength]));
end;

procedure OutputOfficeMemo(var Put: TStringList; const Slg: TSlidegate;
  const SheetWeights: TSheetWeights; const Lang: TLang);
var
  I: Integer;
begin
  for I := 0 to SheetWeights.Count - 1 do
    Put.Append(Format(L10n[63, Lang], [ToMm(SheetWeights.Keys[I]),
      SheetWeights.Data[I]]));

  OutputScrew(Put, Slg.IsRightHandedScrew, Slg.Screw, Slg.ThreadLength, Lang);
  if (Slg.ScrewsNumber > 1) then
    OutputScrew(Put, Slg.IsRightHandedScrew2, Slg.Screw, Slg.ThreadLength, Lang);

  if (not Slg.IsScrewPullout) or (Slg.DriveKind = HandWheel) then
  begin
    if Slg.Nut.DesignationL = '' then
      Put.Append(L10n[13, Lang])
    else
    begin
      if Slg.Nut.IsSquare then
      begin
        Put.Append(Format(L10n[12, Lang],
          [NutDesgination(Slg.Nut, Slg.IsRightHandedScrew, Lang),
          ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.Length)]));
        if (Slg.ScrewsNumber > 1) then
          Put.Append(Format(L10n[12, Lang],
            [NutDesgination(Slg.Nut, Slg.IsRightHandedScrew2, Lang),
            ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.SectionSize),
            ToMm(Slg.Nut.Length)]));
      end
      else
      begin
        Put.Append(Format(L10n[66, Lang],
          [NutDesgination(Slg.Nut, Slg.IsRightHandedScrew, Lang),
          ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.Length)]));
        if (Slg.ScrewsNumber > 1) then
          Put.Append(Format(L10n[66, Lang],
            [NutDesgination(Slg.Nut, Slg.IsRightHandedScrew2, Lang),
            ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.Length)]));
      end;
    end;
  end;

  if Slg.BronzeWedgeStripLength > 0 then
    Put.Append(Format(L10n[14, Lang], [Slg.BronzeWedgeStrip,
      ToMm(Slg.BronzeWedgeStripLength)]));

  Put.Append(Format(L10n[75, Lang], [Slg.SealingLength]));
  Put.Append('');
end;

function Header(const Line: string): string;
begin
  Result := '[ ' + Line + ' ]' + LineEnding;
end;

function Output(const Slg: TSlidegate; const Mass: Double;
  const SheetWeights: TSheetWeights; const Lang: TLang): TStringList;
var
  SInstallKind, SDriveLocation, ScrewDescription: string;
begin
  Result := TStringList.Create;
  Result.Append(Designation(Slg, Lang));
  case Slg.InstallKind of
    Concrete:
      SInstallKind := L10n[67, Lang];
    Channel:
      SInstallKind := L10n[68, Lang];
    Wall:
      SInstallKind := L10n[69, Lang];
    Flange:
      SInstallKind := L10n[70, Lang];
    TwoFlange:
      SInstallKind := L10n[71, Lang];
  end;
  case Slg.DriveLocation of
    OnRack:
      SDriveLocation := L10n[80, Lang];
    OnBracket:
      SDriveLocation := L10n[81, Lang];
  end;
  Result.Append(SInstallKind + SDriveLocation);
  if Slg.IsScrewPullout then
    ScrewDescription := L10n[73, Lang]
  else
    ScrewDescription := L10n[72, Lang];
  if Slg.ScrewsNumber > 1 then
    ScrewDescription := ScrewDescription + ' (x2)';
  Result.Append(ScrewDescription);
  Result.Append(Format(L10n[0, Lang], [Slg.HydrHead]));
  Result.Append(Format(L10n[1, Lang], [Mass]));
  Result.Append(Format(L10n[65, Lang], [Slg.Leakage]));
  Result.Append('');

  if Slg.Actuator <> nil then
    OutputAumaActuator(Result, Slg, Lang);
  if Slg.Gearbox <> nil then
  begin
    if Slg.Gearbox.GearboxType = TGearboxType.TramecR then
      OutputTramecGearbox(Result, Slg.Gearbox, Lang, Slg.GearboxNeed2InputShaft)
    else if Slg.Gearbox.GearboxType = TGearboxType.RotorkIB then
      OutputRotorkGearbox(Result, Slg.Gearbox, Lang, Slg.Sleeve,
        Slg.GearboxNeed2InputShaft)
    else
      OutputAumaGearbox(Result, Slg.Gearbox, Lang, Slg.Sleeve, Slg.ScrewsNumber);
  end;
  if Slg.HandWheel <> nil then
    OutputHandWheel(Result, Slg.HandWheel, Lang);

  Result.Append(Header(L10n[77, Lang]));
  OutputOfficeMemo(Result, Slg, SheetWeights, Lang);

  Result.Append(Format(L10n[15, Lang], [Slg.Screw.SizeToStr,
    FormatFloat('0.#', ToMm(Slg.Screw.MinorDiam)), FormatFloat('0.0##', Slg.ScrewFoS)]));
  Result.Append(Format(L10n[17, Lang], [Slg.ScrewSlenderness]));
  if Slg.MinScrewInertiaMoment > 0 then
    Result.Append(Format(L10n[16, Lang], [ToMm4(Slg.MinScrewInertiaMoment)]));
  Result.Append(Format(L10n[18, Lang], [Slg.AxialForce, Slg.MaxAxialForce]));
  Result.Append(Format(L10n[19, Lang], [Slg.MinScrewTorque, Slg.MaxScrewTorque]));
  Result.Append('');

  if Slg.HaveFrameNodes then
    Result.Append(L10n[21, Lang])
  else
    Result.Append(L10n[22, Lang]);
  if Slg.WedgePairsCount > 0 then
    Result.Append(Format(L10n[23, Lang], [Slg.WedgePairsCount]));
  Result.Append(Format(L10n[24, Lang], [ToMm(Slg.NutAxe)]));
  if (Slg.InstallKind = Channel) or (Slg.InstallKind = Wall) then
    Result.Append(Format(L10n[82, Lang], [Slg.Anchor12Numbers, Slg.Anchor16Numbers]));
  Result.Append(Format(L10n[25, Lang], [Slg.HydrForce]));

  if Slg.IsSmall then
  begin
    Result.Append('');
    Result.Append(Header(L10n[76, Lang]));
    Result.Append(CreateSmallSgEquations(Slg));
  end;
end;

procedure PrintResults(const Slg: TSlidegate; const Mass: Double;
  const SheetWeights: TSheetWeights; const SlgError: TFuncSlidegateError;
  const InputError: TFuncInputDataError);
var
  Lang: TLang;
  Text: string;
begin
  Lang := DefineLang;
  if InputError <> nil then
    Text := InputError(Lang)
  else if SlgError <> nil then
    Text := SlgError(Slg, Lang)
  else
    Text := Output(Slg, Mass, SheetWeights, Lang).Text;
  MainForm.MemoOutput.Text := Text;
  MainForm.MemoOutput.SelStart := 0;
end;

var
  Slidegate: TSlidegate;
  Mass: Double;
  SlidegateError: TFuncSlidegateError;
  InputDataError: TFuncInputDataError;
  SheetWeights: TSheetWeights;

procedure RePrintResults();
begin
  if MainForm.MemoOutput.Text <> '' then
    PrintResults(Slidegate, Mass, SheetWeights, SlidegateError, InputDataError);
end;

procedure Run();
var
  InputData: TInputData;
begin
  InputDataError := CreateInputData(InputData);
  if InputDataError = nil then
  begin
    SlidegateError := CalcSlidegate(Slidegate, InputData);
    CalcMass(Mass, SheetWeights, Slidegate);
  end;
  PrintResults(Slidegate, Mass, SheetWeights, SlidegateError, InputDataError);
end;

var
  ActuatorWithControl: TActuatorWithControl;

initialization
  ModelOpenCloseActuators := TChoiceModelActuator.Create;

  ActuatorWithControl.ModelActuator := AumaSADutyS215;
  ActuatorWithControl.ControlBlock := NoBlock;
  ModelOpenCloseActuators.Add(SAumaSAS215, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSADutyS215;
  ActuatorWithControl.ControlBlock := AumaAM;
  ModelOpenCloseActuators.Add(SAumaSAS215AM, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSADutyS215;
  ActuatorWithControl.ControlBlock := AumaAC;
  ModelOpenCloseActuators.Add(SAumaSAS215AC, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSADutyS230;
  ActuatorWithControl.ControlBlock := NoBlock;
  ModelOpenCloseActuators.Add(SAumaSAS230, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSADutyS230;
  ActuatorWithControl.ControlBlock := AumaAM;
  ModelOpenCloseActuators.Add(SAumaSAS230AM, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSADutyS230;
  ActuatorWithControl.ControlBlock := AumaAC;
  ModelOpenCloseActuators.Add(SAumaSAS230AC, ActuatorWithControl);

  ModelRegulActuators := TChoiceModelActuator.Create;

  ActuatorWithControl.ModelActuator := AumaSARDutyS425;
  ActuatorWithControl.ControlBlock := NoBlock;
  ModelRegulActuators.Add(SAumaSARS425, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSARDutyS425;
  ActuatorWithControl.ControlBlock := AumaAM;
  ModelRegulActuators.Add(SAumaSARS425AM, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSARDutyS425;
  ActuatorWithControl.ControlBlock := AumaAC;
  ModelRegulActuators.Add(SAumaSARS425AC, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSARDutyS450;
  ActuatorWithControl.ControlBlock := NoBlock;
  ModelRegulActuators.Add(SAumaSARS450, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSARDutyS450;
  ActuatorWithControl.ControlBlock := AumaAM;
  ModelRegulActuators.Add(SAumaSARS450AM, ActuatorWithControl);

  ActuatorWithControl.ModelActuator := AumaSARDutyS450;
  ActuatorWithControl.ControlBlock := AumaAC;
  ModelRegulActuators.Add(SAumaSARS450AC, ActuatorWithControl);

  ModelBevelGearboxes := TChoiceModelGearbox.Create;

  ModelBevelGearboxes.Add(SAumaGK, AumaGK);
  ModelBevelGearboxes.Add(SMechanicRZAM, MechanicRZAM);
  ModelBevelGearboxes.Add(STramecR, TramecR);
  ModelBevelGearboxes.Add(SRotorkIB, RotorkIB);

  ModelSpurGearboxes := TChoiceModelGearbox.Create;

  ModelSpurGearboxes.add(SAumaGST, AumaGST);

  LabelHandWheelText := Format(
    'Покупные штурвалы Ø%.0F...%.0F можно использовать:'
    + LineEnding +
    '— при невысоком крутящем моменте,'
    + LineEnding +
    '— с невыдвижными винтами любых размеров,' +
    LineEnding +
    '— с выдвижными винтами диаметром не более %.0F мм.'
    + LineEnding +
    'В остальных случаях необходимо использовать двуплечую рукоятку собственного изготовления.',
    [ToMm(HandWheels[0].Diameter), ToMm(HandWheels[High(HandWheels)].Diameter),
    ToMm(HandWheels[High(HandWheels)].MaxScrew)]);
end.
