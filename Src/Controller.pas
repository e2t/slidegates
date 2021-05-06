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
  GuiHelper, MassGeneral, FileInfo;

type
  TArrayControlBlock = array of TControlBlock;
  TFuncInputDataError = function(const Lang: TLang): string;

var
  OpenCloseActuators, RegulActuators: TArrayActuator;
  BevelGearboxes, SpurGearboxes: TArrayGearbox;
  OpenCloseActuatorControlBlocks, RegulActuatorControlBlocks: TArrayControlBlock;

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

function GetProgramTitle(): string;
var
  Info: TFileVersionInfo;
  Versions: TStringArray;
begin
  Info := TFileVersionInfo.Create(nil);
  Info.ReadFileInfo;
  Versions := Info.VersionStrings.Values['FileVersion'].Split('.');
  Result := Format('%s v%s.%s.%s', [Info.VersionStrings.Values['FileDescription'],
    Versions[0], Versions[1], Versions[2]]);
  Info.Free;
end;

procedure MainFormInit();
var
  ScrewSet: TBuyableScrewSet;
begin
  MainForm.Caption := GetProgramTitle;
  MainForm.ActiveControl := MainForm.EditFrameWidth;

  // Приводы Открыть-Закрыть
  SetLength(OpenCloseActuators, 1024);
  SetLength(OpenCloseActuatorControlBlocks, 1024);
  MainForm.ComboBoxOpenCloseActuator.Items.Add(SAumaSAS215);
  MainForm.ComboBoxOpenCloseActuator.Items.Add(SAumaSAS215AM);
  MainForm.ComboBoxOpenCloseActuator.Items.Add(SAumaSAS215AC);
  MainForm.ComboBoxOpenCloseActuator.Items.Add(SAumaSAS230);
  MainForm.ComboBoxOpenCloseActuator.Items.Add(SAumaSAS230AM);
  MainForm.ComboBoxOpenCloseActuator.Items.Add(SAumaSAS230AC);
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

  // Регулирующие приводы
  SetLength(RegulActuators, 1024);
  SetLength(RegulActuatorControlBlocks, 1024);
  MainForm.ComboBoxRegulActuator.Items.Add(SAumaSARS425);
  MainForm.ComboBoxRegulActuator.Items.Add(SAumaSARS425AM);
  MainForm.ComboBoxRegulActuator.Items.Add(SAumaSARS425AC);
  MainForm.ComboBoxRegulActuator.Items.Add(SAumaSARS450);
  MainForm.ComboBoxRegulActuator.Items.Add(SAumaSARS450AM);
  MainForm.ComboBoxRegulActuator.Items.Add(SAumaSARS450AC);
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

  // Угловые редукторы
  SetLength(BevelGearboxes, 1024);
  MainForm.ComboBoxBevelGearbox.Items.Add(SAumaGK);
  ComboBoxGearboxFill(MainForm.ComboBoxBevelGearbox, BevelGearboxes,
    AumaGK);
  MainForm.ComboBoxBevelGearbox.ItemIndex := 0;
  SetLength(BevelGearboxes, MainForm.ComboBoxBevelGearbox.Items.Count);

  // Цилиндрические редукторы
  SetLength(SpurGearboxes, 1024);
  MainForm.ComboBoxSpurGearbox.Items.Add(SAumaGST);
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

function CreateInputData(out InputData: TInputData): TFuncInputDataError;
var
  ScrewSize: array of string;
  ScrewNote: string;
  I: Integer;
  Value, AMaxWay: Double;
begin
  InputData := Default(TInputData);
  Result := nil;

  if MainForm.EditFrameWidth.GetRealMin(Value, 0) then
    InputData.FrameWidth := Metre(Value)
  else
    Exit(@ErrorIncorrectValue);

  if MainForm.EditGateHeight.GetRealMin(Value, 0) then
    InputData.GateHeight := Metre(Value)
  else
    Exit(@ErrorIncorrectValue);

  if MainForm.EditFrameHeight.GetRealMin(Value,
    MinFrameHeight(InputData.GateHeight)) then
    InputData.FrameHeight := Metre(Value)
  else
    Exit(@ErrorIncorrectValue);

  // Типы затворов и способы установки
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

    if MainForm.EditHydrHead.GetRealMinEq(Value, InputData.GateHeight) then
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

  // Тип управления (приводы)
  if MainForm.PageControlDriveKind.ActivePage = MainForm.TabSheetActuator then
  begin
    if MainForm.RadioButtonOpenClose.Checked then
    begin
      InputData.DriveKind := OpenCloseActuator;
      case MainForm.ComboBoxOpenCloseActuator.Text of
        SAumaSAS215:
        begin
          InputData.ModelActuator := AumaSADutyS215;
          InputData.ControlBlock := NoBlock;
        end;
        SAumaSAS215AM:
        begin
          InputData.ModelActuator := AumaSADutyS215;
          InputData.ControlBlock := AumaAM;
        end;
        SAumaSAS215AC:
        begin
          InputData.ModelActuator := AumaSADutyS215;
          InputData.ControlBlock := AumaAC;
        end;
        SAumaSAS230:
        begin
          InputData.ModelActuator := AumaSADutyS230;
          InputData.ControlBlock := NoBlock;
        end;
        SAumaSAS230AM:
        begin
          InputData.ModelActuator := AumaSADutyS230;
          InputData.ControlBlock := AumaAM;
        end;
        SAumaSAS230AC:
        begin
          InputData.ModelActuator := AumaSADutyS230;
          InputData.ControlBlock := AumaAC;
        end;
        else
        begin
          I := MainForm.ComboBoxOpenCloseActuator.ItemIndex;
          InputData.Actuator := OpenCloseActuators[I];
          InputData.ControlBlock := OpenCloseActuatorControlBlocks[I];
        end;
      end;
    end
    else if MainForm.RadioButtonRegul.Checked then
    begin
      InputData.DriveKind := RegulActuator;
      case MainForm.ComboBoxRegulActuator.Text of
        SAumaSARS425:
        begin
          InputData.ModelActuator := AumaSARDutyS425;
          InputData.ControlBlock := NoBlock;
        end;
        SAumaSARS425AM:
        begin
          InputData.ModelActuator := AumaSARDutyS425;
          InputData.ControlBlock := AumaAM;
        end;
        SAumaSARS425AC:
        begin
          InputData.ModelActuator := AumaSARDutyS425;
          InputData.ControlBlock := AumaAC;
        end;
        SAumaSARS450:
        begin
          InputData.ModelActuator := AumaSARDutyS450;
          InputData.ControlBlock := NoBlock;
        end;
        SAumaSARS450AM:
        begin
          InputData.ModelActuator := AumaSARDutyS450;
          InputData.ControlBlock := AumaAM;
        end;
        SAumaSARS450AC:
        begin
          InputData.ModelActuator := AumaSARDutyS450;
          InputData.ControlBlock := AumaAC;
        end;
        else
        begin
          I := MainForm.ComboBoxRegulActuator.ItemIndex;
          InputData.Actuator := RegulActuators[I];
          InputData.ControlBlock := RegulActuatorControlBlocks[I];
        end;
      end;
    end;
  end
  else if MainForm.PageControlDriveKind.ActivePage = MainForm.TabSheetGearbox then
  begin
    if MainForm.RadioButtonBevelGearbox.Checked then
    begin
      InputData.DriveKind := BevelGearbox;
      case MainForm.ComboBoxBevelGearbox.Text of
        SAumaGK:
          InputData.ModelGearbox := AumaGK;
        else
          InputData.Gearbox :=
            BevelGearboxes[MainForm.ComboBoxBevelGearbox.ItemIndex];
      end;
    end
    else if MainForm.RadioButtonSpurGearbox.Checked then
    begin
      InputData.DriveKind := SpurGearbox;
      case MainForm.ComboBoxSpurGearbox.Text of
        SAumaGST:
          InputData.ModelGearbox := AumaGST;
        else
          InputData.Gearbox :=
            SpurGearboxes[MainForm.ComboBoxSpurGearbox.ItemIndex];
      end;
    end;
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

  InputData.TiltAngle := PI / 2;
  // 0 для горизонтальных затворов
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
    ScrewSize := ScrewNote.Split(['x', 'X', 'х', 'Х', ' ']);
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
    InputData.FullWays := Value  // безразмерная величина
  else
    Exit(@ErrorIncorrectValue);
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
    Put.Append(Format(L10n[64, Lang], [Slg.Torque]))
  else
    Put.Append(Format(L10n[38, Lang], [Slg.Torque, Slg.CloseTorque]));
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
end;

procedure OutputHandWheel(var Put: TStringList; const HandWheel: THandWheel;
  const Lang: TLang);
begin
  if HandWheel = nil then
    Put.Append(L10n[60, Lang])
  else
    Put.Append(Format(L10n[61, Lang], [HandWheel.Name]));
end;

procedure OutputAumaGearbox(var Put: TStringList; const Grb: TGearbox;
  const Lang: TLang; const Sleeve: string);
begin
  if Grb.GearboxType = TGearboxType.AumaGK then
    Put.Append(Format(L10n[56, Lang], [Grb.Brand, Grb.Name]))
  else if Grb.GearboxType = TGearboxType.AumaGST then
    Put.Append(Format(L10n[58, Lang], [Grb.Brand, Grb.Name]));
  Put.Append(Format(L10n[57, Lang], [Grb.Ratio]));
  Put.Append(Format(L10n[59, Lang], [Grb.MaxTorque]));
  Put.Append(Format(L10n[34, Lang], [Grb.Flange]));
  Put.Append(Format(L10n[35, Lang], [Sleeve]));
end;

function Output(const Slg: TSlidegate; const Mass: Double;
  const SheetWeights: TSheetWeights; const Lang: TLang): TStringList;
var
  I: Integer;
  NutDesignation: string;
begin
  Result := TStringList.Create;
  Result.Append(Designation(Slg, Lang));
  Result.Append(Format(L10n[0, Lang], [Slg.HydrHead]));
  Result.Append(Format(L10n[1, Lang], [Mass]));
  Result.Append('');

  for I := 0 to SheetWeights.Count - 1 do
    Result.Append(Format(L10n[63, Lang], [ToMm(SheetWeights.Keys[I]),
      SheetWeights.Data[I]]));
  if Slg.IsRightHandedScrew then
    Result.Append(Format(L10n[11, Lang], [L10n[9, Lang], Slg.Screw.DesignationR,
      ToMm(Slg.Screw.MajorDiam), Slg.ThreadLength]))
  else
    Result.Append(Format(L10n[11, Lang], [L10n[10, Lang], Slg.Screw.DesignationL,
      ToMm(Slg.Screw.MajorDiam), Slg.ThreadLength]));

  if (not Slg.IsScrewPullout) or (Slg.DriveKind = HandWheel) then
  begin
    if Slg.Nut.DesignationL = '' then
      Result.Append(L10n[13, Lang])
    else
    begin
      if Slg.IsRightHandedScrew then
        NutDesignation := Slg.Nut.DesignationR
      else
        NutDesignation := Slg.Nut.DesignationL;
      if Slg.Nut.IsSquare then
        Result.Append(Format(L10n[12, Lang], [NutDesignation,
          ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.Length)]))
      else
        Result.Append(Format(L10n[66, Lang], [NutDesignation,
          ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.Length)]));
    end;
  end;

  if Slg.BronzeWedgeStripLength > 0 then
    Result.Append(Format(L10n[14, Lang], [Slg.BronzeWedgeStrip,
      ToMm(Slg.BronzeWedgeStripLength)]));

  Result.Append('');

  case Slg.DriveKind of
    OpenCloseActuator, RegulActuator:
      case Slg.Actuator.ActuatorType of
        AumaSA, AumaSAR:
          OutputAumaActuator(Result, Slg, Lang);
        else
          Assert(False, 'Неизвестный тип электропривода');
      end;

    BevelGearbox, SpurGearbox:
      case Slg.Gearbox.GearboxType of
        TGearboxType.AumaGK, TGearboxType.AumaGST:
          OutputAumaGearbox(Result, Slg.Gearbox, Lang, Slg.Sleeve);
        else
          Assert(False, 'Неизвестный тип редуктора');
      end;

    HandWheel:
      OutputHandWheel(Result, Slg.HandWheel, Lang);

    else
      Assert(False, 'Неизвестный вид управления');
  end;
  Result.Append('');

  Result.Append(Format(L10n[15, Lang], [Slg.Screw.SizeToStr, Slg.ScrewFoS]));
  Result.Append(Format(L10n[17, Lang], [Slg.ScrewSlenderness]));
  if Slg.MinScrewInertiaMoment > 0 then
    Result.Append(Format(L10n[16, Lang], [ToMm4(Slg.MinScrewInertiaMoment)]));
  Result.Append(Format(L10n[18, Lang], [Slg.AxialForce]));
  Result.Append(Format(L10n[19, Lang], [Slg.Torque]));
  Result.Append('');

  if Slg.HaveFrameNodes then
    Result.Append(L10n[21, Lang])
  else
    Result.Append(L10n[22, Lang]);
  if Slg.WedgePairsCount > 0 then
    Result.Append(Format(L10n[23, Lang], [Slg.WedgePairsCount]));
  Result.Append(Format(L10n[24, Lang], [ToMm(Slg.NutAxe)]));
  Result.Append('');

  Result.Append(Format(L10n[25, Lang], [Slg.HydrForce]));
  Result.Append(Format(L10n[65, Lang], [Slg.Leakage]));
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

end.

