unit Controller;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  Localization;

type
  TNetwork = (Net380V50Hz, Net400V50Hz);

procedure Run();
procedure MainFormInit();
procedure RePrintResults();
procedure ReTranslateGui();
procedure ChangeNetwork();

implementation

uses
  DriveUnits, GuiMainForm, Screws, Measurements, StrengthCalculations,
  SysUtils, Nullable, StdCtrls, Classes, Controls, IniFileUtils,
  GuiHelper, MassGeneral, ProgramInfo, Equations, Fgl, CheckNum;

type
  TArrayControlBlock = array of TControlBlock;
  TFuncInputDataError = function(const Lang: TLang): string;

  TActuatorWithControl = record
    ModelActuator: TModelActuator;
    ControlBlock: TControlBlock;
  end;
  TChoiceModelActuator = specialize TFPGMap<string, TActuatorWithControl>;
  TChoiceModelGearbox = specialize TFPGMap<string, TModelGearbox>;
  TChoiceLang = specialize TFPGMap<string, TLang>;
  TChoiceNetwork = specialize TFPGMap<string, TNetwork>;

var
  ModelOpenCloseActuators, ModelRegulActuators: TChoiceModelActuator;
  OpenCloseActuators, RegulActuators: TArrayActuator;
  ModelBevelGearboxes, ModelSpurGearboxes: TChoiceModelGearbox;
  BevelGearboxes, SpurGearboxes: TArrayGearbox;
  OpenCloseActuatorControlBlocks, RegulActuatorControlBlocks: TArrayControlBlock;
  GuiLangs, OutLangs: TChoiceLang;
  Networks: TChoiceNetwork;

procedure ReTranslateGui();
var
  Lang: TLang;
begin
  with MainForm do
  begin
    Lang := GuiLangs[ComboBoxGuiLang.Text];

    TabSheetSurf.Caption := L10nGui[0, Lang];
    Label10.Caption := L10nGui[1, Lang];
    Label7.Caption := L10nGui[2, Lang];
    GroupBox3.Caption := L10nGui[3, Lang];
    RadioButtonSurfConcrete.Caption := L10nGui[4, Lang];
    RadioButtonSurfChannel.Caption := L10nGui[5, Lang];
    RadioButtonSurfWall.Caption := L10nGui[6, Lang];

    TabSheetDeep.Caption := L10nGui[7, Lang];
    Label11.Caption := L10nGui[8, Lang];
    Label8.Caption := L10nGui[9, Lang];
    GroupBox4.Caption := L10nGui[3, Lang];
    RadioButtonDeepWall.Caption := L10nGui[6, Lang];
    RadioButtonDeepConcrete.Caption := L10nGui[10, Lang];
    RadioButtonDeepFlange.Caption := L10nGui[11, Lang];
    CheckBoxCounterFlange.Caption := L10nGui[12, Lang];
    RadioButtonDeepTwoFlange.Caption := L10nGui[13, Lang];

    TabSheetFlow.Caption := L10nGui[14, Lang];
    Label12.Caption := L10nGui[15, Lang];
    Label9.Caption := L10nGui[2, Lang];
    GroupBox2.Caption := L10nGui[3, Lang];
    RadioButtonRegulConcrete.Caption := L10nGui[16, Lang];
    RadioButtonRegulChannel.Caption := L10nGui[17, Lang];
    RadioButtonRegulWall.Caption := L10nGui[6, Lang];
    Label13.Caption := L10nGui[18, Lang];

    GroupBox6.Caption := L10nGui[19, Lang];
    Label2.Caption := L10nGui[20, Lang];
    Label3.Caption := L10nGui[21, Lang];
    Label4.Caption := L10nGui[22, Lang];
    Label6.Caption := L10nGui[23, Lang];
    GroupBox5.Caption := L10nGui[24, Lang];
    RadioButtonNonPullout.Caption := L10nGui[25, Lang];
    RadioButtonPullout.Caption := L10nGui[26, Lang];
    CheckBoxTwoScrews.Caption := L10nGui[27, Lang];

    TabSheetActuator.Caption := L10nGui[35, Lang];
    RadioButtonOpenClose.Caption := L10nGui[36, Lang];
    RadioButtonRegul.Caption := L10nGui[37, Lang];
    Label18.Caption := L10nGui[38, Lang];
    Label17.Caption := L10nGui[39, Lang];

    TabSheetGearbox.Caption := L10nGui[40, Lang];
    RadioButtonBevelGearbox.Caption := L10nGui[41, Lang];
    RadioButtonSpurGearbox.Caption := L10nGui[42, Lang];
    Label16.Caption := L10nGui[43, Lang];

    TabSheetHandWheel.Caption := L10nGui[44, Lang];
    LabelHandWheel.Caption := Format(L10nGui[45, Lang], [ToMm(HandWheels[0].Diameter),
      ToMm(HandWheels[High(HandWheels)].Diameter),
      ToMm(HandWheels[High(HandWheels)].MaxScrew)]);

    Label1.Caption := L10nGui[46, Lang];
    TabSheetOnFrame.Caption := L10nGui[47, Lang];
    Label19.Caption := L10nGui[48, Lang];

    TabSheetOnRack.Caption := L10nGui[49, Lang];
    Label21.Caption := L10nGui[50, Lang];
    Label5.Caption := L10nGui[51, Lang];
    CheckBoxRackWithoutPipeNodes.Caption := L10nGui[52, Lang];

    TabSheetOnBracket.Caption := L10nGui[53, Lang];
    Label22.Caption := L10nGui[54, Lang];
    Label20.Caption := L10nGui[51, Lang];
    CheckBoxBracketWithoutPipeNodes.Caption := L10nGui[52, Lang];

    GroupBox7.Caption := L10nGui[28, Lang];
    Label14.Caption := L10nGui[29, Lang];
    Label15.Caption := L10nGui[30, Lang];
    Label23.Caption := L10nGui[31, Lang];
    Label24.Caption := L10nGui[32, Lang];
    CheckBoxWithoutFrameNodes.Caption := L10nGui[33, Lang];
    CheckBoxThreeWedgePairs.Caption := L10nGui[34, Lang];

    ButtonRun.Caption := L10nGui[55, Lang];
  end;
  SetLangGui(Lang);
end;

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
  Result := Format('%S (%S)  %S rpm  %S kW',
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
  Items: TStringList;
begin
  Items := TStringList.Create;
  I := ComboBox.Items.Count;
  for ArrayActuator in ModelActuator do
    for Actuator in ArrayActuator do
    begin
      Items.Add(ItemActuator(Actuator, ControlBlock));
      LinearArrayActuator[I] := Actuator;
      LinearArrayControlBlocks[I] := ControlBlock;
      Inc(I);
    end;
  ComboBox.Items.AddStrings(Items, False);
  Items.Free;
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

generic procedure FillComboBoxIni<T>(const ComboBox: TComboBox;
  const Choices: specialize TFPGMap<string, T>; const InitValue: T);
var
  I, Index: Integer;
begin
  for I := 0 to Choices.Count - 1 do
    ComboBox.Items.Add(Choices.Keys[I]);

  Index := Choices.IndexOfData(InitValue);
  if Index < 0 then
    Index := 0;
  ComboBox.ItemIndex := Index;
end;

procedure ComboBoxNetworkFill();
begin
  specialize FillComboBoxIni<TNetwork>(MainForm.ComboBoxNetwork, Networks, GetNetwork);
end;

procedure ComboBoxGuiLangFill();
begin
  specialize FillComboBoxIni<TLang>(MainForm.ComboBoxGuiLang, GuiLangs, GetLangGui);
end;

procedure ComboBoxOutLangFill();
begin
  specialize FillComboBoxIni<TLang>(MainForm.ComboBoxOutLang, OutLangs, GetLangOut);
end;

procedure AddModelActuator(const ComboBox: TComboBox;
  const ModelActuators: TChoiceModelActuator; const Choice: string;
  const ModelActuator: TModelActuator; const ControlBlock: TControlBlock);
var
  Awc: TActuatorWithControl;
begin
  Awc.ModelActuator := ModelActuator;
  Awc.ControlBlock := ControlBlock;
  ModelActuators.Add(Choice, Awc);
  ComboBox.Items.Add(Choice);
end;

procedure AddModelOpenCloseActuator(const Choice: string;
  const ModelActuator: TModelActuator; const ControlBlock: TControlBlock);
begin
  AddModelActuator(MainForm.ComboBoxOpenCloseActuator, ModelOpenCloseActuators,
    Choice, ModelActuator, ControlBlock);
end;

procedure AddModelRegulActuator(const Choice: string;
  const ModelActuator: TModelActuator; const ControlBlock: TControlBlock);
begin
  AddModelActuator(MainForm.ComboBoxRegulActuator, ModelRegulActuators,
    Choice, ModelActuator, ControlBlock);
end;

procedure FillOpenCloseActuators(const ModelActuator: TModelActuator;
  const ControlBlock: TControlBlock);
begin
  ComboBoxActuatorFill(MainForm.ComboBoxOpenCloseActuator, OpenCloseActuators,
    ModelActuator, OpenCloseActuatorControlBlocks, ControlBlock);
end;

procedure FillRegulActuators(const ModelActuator: TModelActuator;
  const ControlBlock: TControlBlock);
begin
  ComboBoxActuatorFill(MainForm.ComboBoxRegulActuator, RegulActuators,
    ModelActuator, RegulActuatorControlBlocks, ControlBlock);
end;

procedure ChangeNetwork();
var
  Network: TNetwork;
  AumaSA_S215, AumaSA_S230, AumaSAR_S425, AumaSAR_S450: TModelActuator;
  OldOpenClose, OldRegul: string;
  Index: Integer;
begin
  with MainForm do
  begin
    Network := Networks[ComboBoxNetwork.Text];
    if Network = Net380V50Hz then
    begin
      AumaSA_S215 := AumaSA_S215_380V50Hz;
      AumaSA_S230 := AumaSA_S230_380V50Hz;
      AumaSAR_S425 := AumaSAR_S425_380V50Hz;
      AumaSAR_S450 := AumaSAR_S450_380V50Hz;
    end
    else if Network = Net400V50Hz then
    begin
      AumaSA_S215 := AumaSA_S215_400V50Hz;
      AumaSA_S230 := AumaSA_S230_400V50Hz;
      AumaSAR_S425 := AumaSAR_S425_400V50Hz;
      AumaSAR_S450 := AumaSAR_S450_400V50Hz;
    end;

    OldOpenClose := ComboBoxOpenCloseActuator.Text;
    OldRegul := ComboBoxRegulActuator.Text;

    { Приводы Открыть-Закрыть }
    ComboBoxOpenCloseActuator.Clear;
    ModelOpenCloseActuators.Clear;
    AddModelOpenCloseActuator(SAumaSAS215, AumaSA_S215, NoBlock);
    AddModelOpenCloseActuator(SAumaSAS215AM, AumaSA_S215, AumaAM);
    AddModelOpenCloseActuator(SAumaSAS215AC, AumaSA_S215, AumaAC);
    AddModelOpenCloseActuator(SAumaSAS230, AumaSA_S230, NoBlock);
    AddModelOpenCloseActuator(SAumaSAS230AM, AumaSA_S230, AumaAM);
    AddModelOpenCloseActuator(SAumaSAS230AC, AumaSA_S230, AumaAC);
    FillOpenCloseActuators(AumaSA_S215, NoBlock);
    FillOpenCloseActuators(AumaSA_S215, AumaAM);
    FillOpenCloseActuators(AumaSA_S215, AumaAC);
    FillOpenCloseActuators(AumaSA_S230, NoBlock);
    FillOpenCloseActuators(AumaSA_S230, AumaAM);
    FillOpenCloseActuators(AumaSA_S230, AumaAC);

    Index := ComboBoxOpenCloseActuator.Items.IndexOf(OldOpenClose);
    if Index < 0 then
      Index := 0;
    ComboBoxOpenCloseActuator.ItemIndex := Index;

    { Регулирующие приводы }
    ComboBoxRegulActuator.Clear;
    ModelRegulActuators.Clear;
    AddModelRegulActuator(SAumaSARS425, AumaSAR_S425, NoBlock);
    AddModelRegulActuator(SAumaSARS425AM, AumaSAR_S425, AumaAM);
    AddModelRegulActuator(SAumaSARS425AC, AumaSAR_S425, AumaAC);
    AddModelRegulActuator(SAumaSARS450, AumaSAR_S450, NoBlock);
    AddModelRegulActuator(SAumaSARS450AM, AumaSAR_S450, AumaAM);
    AddModelRegulActuator(SAumaSARS450AC, AumaSAR_S450, AumaAC);
    FillRegulActuators(AumaSAR_S425, NoBlock);
    FillRegulActuators(AumaSAR_S425, AumaAM);
    FillRegulActuators(AumaSAR_S425, AumaAC);
    FillRegulActuators(AumaSAR_S450, NoBlock);
    FillRegulActuators(AumaSAR_S450, AumaAM);
    FillRegulActuators(AumaSAR_S450, AumaAC);

    Index := ComboBoxRegulActuator.Items.IndexOf(OldRegul);
    if Index < 0 then
      Index := 0;
    ComboBoxRegulActuator.ItemIndex := Index;
  end;
  SetNetwork(Network);
end;

procedure MainFormInit();
var
  ScrewSet: TBuyableScrewSet;
  I: Integer;
begin
  MainForm.Caption := GetProgramTitle;
  MainForm.ActiveControl := MainForm.EditFrameWidth;
  MainForm.Constraints.MinHeight := MainForm.Height;
  MainForm.Constraints.MinWidth := MainForm.Width;

  ComboBoxGuiLangFill;
  ReTranslateGui;
  ComboBoxOutLangFill;

  ComboBoxNetworkFill;
  ChangeNetwork;

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
  Result := OutLangs[MainForm.ComboBoxOutLang.Text];
end;

function ErrorIncorrectValue(const Lang: TLang): string;
begin
  Result := L10nOut[62, Lang];
end;

function ErrorNonBevelGearboxWithTwoScrews(const Lang: TLang): string;
begin
  Result := L10nOut[74, Lang];
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

procedure CreateInputData(out InputData: TInputData; out Error: TFuncInputDataError);
const
  Delims: array [0..4] of string = ('x', 'X', 'х', 'Х', ' ');
var
  ScrewSize: array of string;
  ScrewNote, Choice: string;
  I: Integer;
  Value, AMaxWay: ValReal;
  ActuatorWithControl: TActuatorWithControl;
  IsValid: Boolean;
begin
  InputData := Default(TInputData);
  Error := nil;

  MainForm.EditFrameWidth.GetRealMinEqMaxEq(MinFrameWidth, MaxFrameWidth,
    IsValid, Value);
  if IsValid then
    InputData.FrameWidth := Metre(Value)
  else
  begin
    Error := @ErrorIncorrectValue;
    Exit;
  end;

  MainForm.EditGateHeight.GetRealMinEqMaxEq(MinGateHeight, MaxGateHeight,
    IsValid, Value);
  if IsValid then
    InputData.GateHeight := Metre(Value)
  else
  begin
    Error := @ErrorIncorrectValue;
    Exit;
  end;

  MainForm.EditFrameHeight.GetRealMinEqMaxEq(MinFrameHeight(InputData.GateHeight),
    MaxFrameHeight, IsValid, Value);
  if IsValid then
    InputData.FrameHeight := Metre(Value)
  else
  begin
    Error := @ErrorIncorrectValue;
    Exit;
  end;

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

    MainForm.EditHydrHead.GetRealMinEqMaxEq(InputData.GateHeight, MaxHydrHead,
      IsValid, Value);
    if IsValid then
      InputData.HydrHead.Value := Metre(Value)
    else
    begin
      Error := @ErrorIncorrectValue;
      Exit;
    end;

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

    MainForm.EditBethFrameTopAndGateTop.GetRealMin(0, IsValid, Value);
    if IsValid then
      InputData.BethFrameTopAndGateTop.Value := Metre(Value)
    else
    begin
      Error := @ErrorIncorrectValue;
      Exit;
    end;

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
    MainForm.EditBtwFrameTopAndGround.GetRealMin(0, IsValid, Value);
    if IsValid then
      InputData.BtwFrameTopAndDriveUnit := Metre(Value) + RackHeight
    else
    begin
      Error := @ErrorIncorrectValue;
      Exit;
    end;
    InputData.HavePipeNodes := not MainForm.CheckBoxRackWithoutPipeNodes.Checked;
  end
  else if MainForm.PageControlDriveLocation.ActivePage = MainForm.TabSheetOnBracket then
  begin
    InputData.DriveLocation := OnBracket;
    MainForm.EditBtwFrameTopAndDriveUnit.GetRealMin(0.1, IsValid, Value);
    if IsValid then
      InputData.BtwFrameTopAndDriveUnit := Metre(Value)
    else
    begin
      Error := @ErrorIncorrectValue;
      Exit;
    end;
    InputData.HavePipeNodes := not MainForm.CheckBoxBracketWithoutPipeNodes.Checked;
  end;

  if MainForm.RadioButtonNonPullout.Checked then
    InputData.IsScrewPullout := False
  else if MainForm.RadioButtonPullout.Checked then
    InputData.IsScrewPullout := True;

  { 0 для горизонтальных затворов }
  InputData.TiltAngle := PI / 2;

  MainForm.EditLiquidDensity.GetRealMin(0, IsValid, Value);
  if IsValid then
    InputData.LiquidDensity := KgPerM3(Value)
  else
  begin
    Error := @ErrorIncorrectValue;
    Exit;
  end;

  if MainForm.CheckBoxWithoutFrameNodes.Checked then
    InputData.HaveFrameNodes.Value := False;

  if MainForm.CheckBoxThreeWedgePairs.Checked then
    InputData.WedgePairsCount.Value := 3;

  if MainForm.EditWay.Text <> '' then
  begin
    AMaxWay := MaxWay(InputData.FrameHeight, InputData.GateHeight);
    MainForm.EditWay.GetRealMinMaxEq(0, AMaxWay, IsValid, Value);
    if IsValid then
      InputData.Way.Value := Metre(Value)
    else
    begin
      Error := @ErrorIncorrectValue;
      Exit;
    end;
  end;

  ScrewNote := MainForm.ComboBoxScrew.Text;
  if ScrewNote <> '' then
  begin
    ScrewSize := ScrewNote.Split(Delims);
    if Length(ScrewSize) <> 2 then
    begin
      Error := @ErrorIncorrectValue;
      Exit;
    end
    else
    begin
      MainForm.ComboBoxScrew.GetRealMin(ScrewSize[0], 0, IsValid, Value);
      if IsValid then
        InputData.ScrewDiam.Value := Mm(Value)
      else
      begin
        Error := @ErrorIncorrectValue;
        Exit;
      end;

      MainForm.ComboBoxScrew.GetRealMinMax(ScrewSize[1], 0,
        ToMm(InputData.ScrewDiam.Value / 2), IsValid, Value);
      if IsValid then
        InputData.ScrewPitch.Value := Mm(Value)
      else
      begin
        Error := @ErrorIncorrectValue;
        Exit;
      end;
    end;
  end;

  if MainForm.EditMinSpeed.Text <> '' then
  begin
    MainForm.EditMinSpeed.GetRealMinEq(0, IsValid, Value);
    if IsValid then
      InputData.RecommendMinSpeed := Rpm(Value)
    else
    begin
      Error := @ErrorIncorrectValue;
      Exit;
    end;
  end
  else
    InputData.RecommendMinSpeed := 0;

  MainForm.EditFullWays.GetRealMin(0, IsValid, InputData.FullWays);
  if not IsValid then
  begin
    Error := @ErrorIncorrectValue;
    Exit;
  end;

  if MainForm.CheckBoxTwoScrews.Checked then
  begin
    if not MainForm.RadioButtonBevelGearbox.Checked then
    begin
      Error := @ErrorNonBevelGearboxWithTwoScrews;
      Exit;
    end;
    InputData.ScrewsNumber := 2;
    GetGearboxOrModel(InputData.ModelGearbox, InputData.Gearbox);
  end
  else
    InputData.ScrewsNumber := 1;

  if MainForm.ComboBoxFrameSheet.Text <> '' then
  begin
    MainForm.ComboBoxFrameSheet.GetRealMin(0, IsValid, Value);
    if IsValid then
      InputData.FrameSheet.Value := Mm(Value)
    else
    begin
      Error := @ErrorIncorrectValue;
      Exit;
    end;
  end;

  if MainForm.ComboBoxGateSheet.Text <> '' then
  begin
    MainForm.ComboBoxGateSheet.GetRealMin(0, IsValid, Value);
    if IsValid then
      InputData.GateSheet.Value := Mm(Value)
    else
    begin
      Error := @ErrorIncorrectValue;
      Exit;
    end;
  end;
end;

function Designation(const Slg: TSlidegate; const Lang: TLang): string;
var
  DsgKind, DsgControl: string;
begin
  case Slg.SlgKind of
    Deep: DsgKind := L10nOut[3, Lang];
    Surf: DsgKind := L10nOut[2, Lang];
    else
      if Slg.InstallKind = Wall then
        DsgKind := L10nOut[5, Lang]
      else
        DsgKind := L10nOut[4, Lang]
  end;

  case Slg.DriveKind of
    OpenCloseActuator, RegulActuator:
      DsgControl := L10nOut[6, Lang];
    else
      DsgControl := L10nOut[7, Lang];
  end;

  Result := L10nOut[8, Lang] + DsgKind + DsgControl + ' ' +
    FormatFloat('0.0##', Slg.FrameWidth) + 'x' +
    FormatFloat('0.0##', Slg.FrameHeight) + '(' +
    FormatFloat('0.0##', Slg.GateHeight) + ')';
  if Slg.IsSmall then
    Result := Result + L10nOut[85, Lang];
end;

procedure OutputAumaActuator(var Put: TStringList; const Slg: TSlidegate;
  const Lang: TLang);
begin
  Put.Append(Format(L10nOut[30, Lang], [ActuatorName(Slg.Actuator, Slg.ControlBlock)]));
  if Slg.ControlBlock <> NoBlock then
    Put.Append(Format(L10nOut[55, Lang],
      [Slg.Actuator.ControlBlockNames[Slg.ControlBlock]]));
  Put.Append(Format(L10nOut[31, Lang], [ToRpm(Slg.Actuator.Speed)]));
  Put.Append(Format(L10nOut[32, Lang], [ToKw(Slg.Actuator.Power)]));
  Put.Append(Format(L10nOut[36, Lang], [Slg.Actuator.Duty]));
  Put.Append(Format(L10nOut[33, Lang], [Slg.Actuator.MinTorque,
    Slg.Actuator.MaxTorque]));
  Put.Append(Format(L10nOut[34, Lang], [Slg.Actuator.Flange]));
  Put.Append(Format(L10nOut[35, Lang], [Slg.Sleeve]));
  Put.Append(L10nOut[37, Lang]);
  if Slg.SlgKind = Flow then
    Put.Append(Format(L10nOut[64, Lang], [Slg.OpenTorque]))
  else
    Put.Append(Format(L10nOut[38, Lang], [Slg.OpenTorque, Slg.CloseTorque]));
  Put.Append(Format(L10nOut[39, Lang], [ToMin(Slg.OpenTime), Slg.OpenTime, Slg.Revs]));
  Put.Append(Format(L10nOut[40, Lang], [Slg.MinDriveUnitTemperature,
    Slg.MaxDriveUnitTemperature]));
  Put.Append(Format(L10nOut[41, Lang], [Slg.Actuator.Voltage, Slg.Actuator.Frequency]));
  Put.Append(L10nOut[42, Lang]);
  Put.Append(L10nOut[43, Lang]);
  Put.Append(L10nOut[44, Lang]);
  Put.Append(L10nOut[45, Lang]);
  Put.Append(L10nOut[46, Lang]);
  Put.Append(L10nOut[47, Lang]);
  Put.Append(L10nOut[48, Lang]);
  Put.Append(L10nOut[49, Lang]);
  Put.Append(L10nOut[50, Lang]);
  Put.Append(L10nOut[51, Lang]);
  Put.Append(L10nOut[52, Lang]);
  Put.Append(L10nOut[53, Lang]);
  Put.Append(L10nOut[54, Lang]);
  if IsMore(Slg.Actuator.Mass, 0) then
  begin
    case Slg.ControlBlock of
      NoBlock:
        Put.Append(Format(L10nOut[90, Lang], [Slg.Actuator.Mass]));
      AumaAM:
        Put.Append(Format(L10nOut[93, Lang], [Slg.Actuator.Mass, WeightAM]));
      AumaAC:
        Put.Append(Format(L10nOut[93, Lang], [Slg.Actuator.Mass, WeightAC]));
    end;
  end;
  Put.Append('');
end;

procedure OutputHandWheel(var Put: TStringList; const HandWheel: THandWheel;
  const Lang: TLang);
begin
  if HandWheel.Name = '' then
    Put.Append(Format(L10nOut[60, Lang], [ToMm(HandWheel.Diameter)]))
  else
    Put.Append(Format(L10nOut[61, Lang], [HandWheel.Name]));
  if IsMore(HandWheel.Mass, 0) then
    Put.Append(Format(L10nOut[90, Lang], [HandWheel.Mass]));
  Put.Append('');
end;

procedure OutputAumaGearbox(var Put: TStringList; const Grb: TGearbox;
  const Lang: TLang; const Sleeve: string; const ScrewsNumber: Integer;
  const NeedHandwheel: Boolean);
var
  DriveName: string;
begin
  case Grb.GearboxType of
    TGearboxType.AumaGK:
      DriveName := Format(L10nOut[58, Lang], [Grb.Brand, Grb.Name]);
    TGearboxType.AumaGST:
      DriveName := Format(L10nOut[56, Lang], [Grb.Brand, Grb.Name]);
  end;
  if ScrewsNumber > 1 then
    DriveName := DriveName + ' (x2)';
  Put.Append(DriveName);
  Put.Append(Format(L10nOut[57, Lang], [Grb.NominalRatio, Grb.Ratio]));
  if NeedHandwheel and (Grb.HandWheelDiam > 0) then
    Put.Append(Format(L10nOut[83, Lang], [ToMm(Grb.HandWheelDiam)]))
  else
    Put.Append(L10nOut[92, Lang]);
  Put.Append(Format(L10nOut[59, Lang], [Grb.MaxTorque]));
  Put.Append(Format(L10nOut[34, Lang], [Grb.Flange]));
  Put.Append(Format(L10nOut[35, Lang], [Sleeve]));
  if IsMore(Grb.Mass, 0) then
    Put.Append(Format(L10nOut[90, Lang], [Grb.Mass]));
  Put.Append('');
end;

procedure OutputRZAMGearbox(var Put: TStringList; const Grb: TGearbox;
  const Lang: TLang; const Sleeve: string; const ScrewsNumber: Integer;
  const IsScrewPullout: Boolean; const NeedHandwheel: Boolean);
var
  DriveName: string;
begin
  DriveName := Format(L10nOut[58, Lang], [Grb.Brand, Grb.Name]);
  if ScrewsNumber > 1 then
    DriveName := DriveName + ' (x2)';
  Put.Append(DriveName);
  Put.Append(Format(L10nOut[57, Lang], [Grb.NominalRatio, Grb.Ratio]));
  if NeedHandwheel and (Grb.HandWheelDiam > 0) then
    Put.Append(Format(L10nOut[83, Lang], [ToMm(Grb.HandWheelDiam)]))
  else
    Put.Append(L10nOut[92, Lang]);
  Put.Append(Format(L10nOut[59, Lang], [Grb.MaxTorque]));
  Put.Append(Format(L10nOut[34, Lang], [Grb.Flange]));
  Put.Append(Format(L10nOut[35, Lang], [Sleeve]));
  if not IsScrewPullout then
    Put.Append(L10nOut[84, Lang]);
  Put.Append(L10nOut[86, Lang]);
  Put.Append(L10nOut[87, Lang]);
  Put.Append(L10nOut[88, Lang]);
  if IsMore(Grb.Mass, 0) then
    Put.Append(Format(L10nOut[90, Lang], [Grb.Mass]));
  Put.Append('');
end;

procedure OutputRotorkGearbox(var Put: TStringList; const Grb: TGearbox;
  const Lang: TLang; const Sleeve: string; const Need2InputShaft: Boolean;
  const NeedHandwheel: Boolean);
begin
  Put.Append(Format(L10nOut[58, Lang], [Grb.Brand, Grb.Name]));
  if Need2InputShaft then
    Put.Append(Format(L10nOut[58, Lang], [Grb.Brand, Grb.Name +
      ' DUAL INPUT BEVEL GEARCASE (180)']));
  Put.Append(Format(L10nOut[57, Lang], [Grb.NominalRatio, Grb.Ratio]));
  if NeedHandwheel and (Grb.HandWheelDiam > 0) then
    Put.Append(Format(L10nOut[83, Lang], [ToMm(Grb.HandWheelDiam)]))
  else
    Put.Append(L10nOut[92, Lang]);
  Put.Append(Format(L10nOut[59, Lang], [Grb.MaxTorque]));
  Put.Append(Format(L10nOut[34, Lang], [Grb.Flange]));
  Put.Append(Format(L10nOut[35, Lang], [Sleeve]));
  if IsMore(Grb.Mass, 0) then
    Put.Append(Format(L10nOut[90, Lang], [Grb.Mass]));
  Put.Append('');
end;

procedure OutputTramecGearbox(var Put: TStringList; const Grb: TGearbox;
  const Lang: TLang; const Need2InputShaft: Boolean;
  const NeedHandwheel: Boolean);
begin
  Put.Append(Format(L10nOut[58, Lang], [Grb.Brand, Grb.Name]));
  if Need2InputShaft then
    Put.Append(Format(L10nOut[58, Lang], [Grb.Brand, Grb.Name + ' seA']));
  Put.Append(Format(L10nOut[57, Lang], [Grb.NominalRatio, Grb.Ratio]));
  if NeedHandwheel and (Grb.HandWheelDiam > 0) then
    Put.Append(Format(L10nOut[83, Lang], [ToMm(Grb.HandWheelDiam)]))
  else
    Put.Append(L10nOut[92, Lang]);
  Put.Append(Format(L10nOut[59, Lang], [Grb.MaxTorque]));
  if IsMore(Grb.Mass, 0) then
    Put.Append(Format(L10nOut[90, Lang], [Grb.Mass]));
  Put.Append('');
end;

procedure OutputScrew(var Put: TStringList; const IsRightHandedScrew: Boolean;
  const Screw: TScrew; const ThreadLength: ValReal; const Lang: TLang);
begin
  if IsRightHandedScrew then
    Put.Append(Format(L10nOut[11, Lang], [L10nOut[9, Lang], Screw.DesignationR,
      ToMm(Screw.MajorDiam), ThreadLength]))
  else
    Put.Append(Format(L10nOut[11, Lang], [L10nOut[10, Lang], Screw.DesignationL,
      ToMm(Screw.MajorDiam), ThreadLength]));
end;

procedure OutputOfficeMemo(var Put: TStringList; const Slg: TSlidegate;
  const SheetWeights: TSheetWeights; const Lang: TLang);
var
  I: Integer;
begin
  for I := 0 to SheetWeights.Count - 1 do
    Put.Append(Format(L10nOut[63, Lang], [ToMm(SheetWeights.Keys[I]),
      SheetWeights.Data[I]]));

  OutputScrew(Put, Slg.IsRightHandedScrew, Slg.Screw, Slg.ThreadLength, Lang);
  if (Slg.ScrewsNumber > 1) then
    OutputScrew(Put, Slg.IsRightHandedScrew2, Slg.Screw, Slg.ThreadLength, Lang);

  if (not Slg.IsScrewPullout) or (Slg.DriveKind = HandWheel) then
  begin
    if Slg.Nut.DesignationL = '' then
      Put.Append(L10nOut[13, Lang])
    else
    begin
      if Slg.Nut.IsSquare then
      begin
        Put.Append(Format(L10nOut[12, Lang],
          [NutDesgination(Slg.Nut, Slg.IsRightHandedScrew, Lang),
          ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.Length)]));
        if (Slg.ScrewsNumber > 1) then
          Put.Append(Format(L10nOut[12, Lang],
            [NutDesgination(Slg.Nut, Slg.IsRightHandedScrew2, Lang),
            ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.SectionSize),
            ToMm(Slg.Nut.Length)]));
      end
      else
      begin
        Put.Append(Format(L10nOut[66, Lang],
          [NutDesgination(Slg.Nut, Slg.IsRightHandedScrew, Lang),
          ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.Length)]));
        if (Slg.ScrewsNumber > 1) then
          Put.Append(Format(L10nOut[66, Lang],
            [NutDesgination(Slg.Nut, Slg.IsRightHandedScrew2, Lang),
            ToMm(Slg.Nut.SectionSize), ToMm(Slg.Nut.Length)]));
      end;
    end;
  end;

  if Slg.BronzePadCount > 0 then
    Put.Append(Format(L10nOut[14, Lang], [Slg.BronzePadCount]));

  Put.Append(Format(L10nOut[75, Lang], [Slg.SealingLength]));
  Put.Append('');
end;

function Highlight(const Line: string): string;
begin
  Result := '[ ' + Line + ' ]';
end;

function Output(const Slg: TSlidegate; const Mass: TWeights;
  const Lang: TLang): TStringList;
var
  SInstallKind, SDriveLocation, ScrewDescription: string;
  NeedGearboxHandwheel: Boolean;
begin
  Result := TStringList.Create;
  Result.Append(Designation(Slg, Lang));
  case Slg.InstallKind of
    Concrete:
      SInstallKind := L10nOut[67, Lang];
    Channel:
      SInstallKind := L10nOut[68, Lang];
    Wall:
      SInstallKind := L10nOut[69, Lang];
    Flange:
      SInstallKind := L10nOut[70, Lang];
    TwoFlange:
      SInstallKind := L10nOut[71, Lang];
  end;
  case Slg.DriveLocation of
    OnRack:
      SDriveLocation := L10nOut[80, Lang];
    OnBracket:
      SDriveLocation := L10nOut[81, Lang];
  end;
  Result.Append(SInstallKind + SDriveLocation);
  if Slg.IsScrewPullout then
    ScrewDescription := L10nOut[73, Lang]
  else
    ScrewDescription := L10nOut[72, Lang];
  if Slg.ScrewsNumber > 1 then
    ScrewDescription := ScrewDescription + ' (x2)';
  Result.Append(ScrewDescription);
  Result.Append(Format(L10nOut[0, Lang], [Slg.HydrHead]));
  Result.Append(Format(L10nOut[65, Lang], [Slg.Leakage]));
  if IsLessEq(Slg.HydrForce, Kgf(55e3)) then
    Result.Append(Format(L10nOut[1, Lang], [Mass.Total]))
  else
    Result.Append(Highlight(L10nOut[89, Lang]));
  Result.Append('');

  if Slg.Actuator <> nil then
    OutputAumaActuator(Result, Slg, Lang);
  if Slg.Gearbox <> nil then
  begin
    NeedGearboxHandwheel := (Slg.ScrewsNumber = 1) and (Slg.Gearbox.GearboxType <> TGearboxType.AumaGST);
    case Slg.Gearbox.GearboxType of
      TGearboxType.TramecR:
        OutputTramecGearbox(Result, Slg.Gearbox, Lang, Slg.GearboxNeed2InputShaft,
          NeedGearboxHandwheel);
      TGearboxType.RotorkIB:
        OutputRotorkGearbox(Result, Slg.Gearbox, Lang, Slg.Sleeve,
          Slg.GearboxNeed2InputShaft, NeedGearboxHandwheel);
      TGearboxType.MechanicRZAM:
        OutputRZAMGearbox(Result, Slg.Gearbox, Lang, Slg.Sleeve, Slg.ScrewsNumber,
          Slg.IsScrewPullout, NeedGearboxHandwheel);
      else
        OutputAumaGearbox(Result, Slg.Gearbox, Lang, Slg.Sleeve, Slg.ScrewsNumber,
          NeedGearboxHandwheel);
    end;
  end;
  if Slg.HandWheel <> nil then
    OutputHandWheel(Result, Slg.HandWheel, Lang);

  Result.Append(Highlight(L10nOut[77, Lang]));
  Result.Append('');
  Result.Append(Format(L10nOut[91, Lang], [Mass.Slidegate, Mass.Frame, Mass.Gate]));
  OutputOfficeMemo(Result, Slg, Mass.Sheet, Lang);

  Result.Append(Format(L10nOut[15, Lang], [Slg.Screw.SizeToStr,
    FormatFloat('0.#', ToMm(Slg.Screw.MinorDiam)), FormatFloat('0.0##', Slg.ScrewFoS)]));
  Result.Append(Format(L10nOut[17, Lang], [Slg.ScrewSlenderness]));
  if Slg.MinScrewInertiaMoment > 0 then
    Result.Append(Format(L10nOut[16, Lang], [ToMm4(Slg.MinScrewInertiaMoment)]));
  Result.Append(Format(L10nOut[18, Lang], [Slg.AxialForce, Slg.MaxAxialForce]));
  Result.Append(Format(L10nOut[19, Lang], [Slg.MinScrewTorque, Slg.MaxScrewTorque]));
  Result.Append('');

  if Slg.HaveFrameNodes then
    Result.Append(L10nOut[21, Lang])
  else
    Result.Append(L10nOut[22, Lang]);
  if Slg.WedgePairsCount > 0 then
    Result.Append(Format(L10nOut[23, Lang], [Slg.WedgePairsCount]));
  Result.Append(Format(L10nOut[24, Lang], [ToMm(Slg.NutAxe)]));
  if (Slg.InstallKind = Channel) or (Slg.InstallKind = Wall) then
    Result.Append(Format(L10nOut[82, Lang], [Slg.Anchor12Numbers, Slg.Anchor16Numbers]));
  Result.Append(Format(L10nOut[25, Lang], [Slg.HydrForce]));

  if Slg.IsSmall then
  begin
    Result.Append('');
    Result.Append(Highlight(L10nOut[76, Lang]));
    Result.Append('');
    Result.Append(CreateSmallSgEquations(Slg));
  end;
end;

procedure PrintResults(const Slg: TSlidegate; const Mass: TWeights;
  const SlgError: TFuncSlidegateError; const InputError: TFuncInputDataError);
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
    Text := Output(Slg, Mass, Lang).Text;
  MainForm.MemoOutput.Text := Text;
  MainForm.MemoOutput.SelStart := 0;
end;

var
  Slidegate: TSlidegate;
  SlidegateError: TFuncSlidegateError;
  InputDataError: TFuncInputDataError;
  Mass: TWeights;

procedure RePrintResults();
begin
  SetLangOut(DefineLang);
  if MainForm.MemoOutput.Text <> '' then
    PrintResults(Slidegate, Mass, SlidegateError, InputDataError);
end;

procedure Run();
var
  InputData: TInputData;
begin
  CreateInputData(InputData, InputDataError);
  if InputDataError = nil then
  begin
    CalcSlidegate(Slidegate, InputData, SlidegateError);
    CalcMass(Mass, Slidegate, InputData);
  end;
  PrintResults(Slidegate, Mass, SlidegateError, InputDataError);
end;

initialization
  Mass := Default(TWeights);
  Mass.Sheet := TSheetWeights.Create;

  SetLength(OpenCloseActuators, 1024);
  SetLength(OpenCloseActuatorControlBlocks, 1024);
  SetLength(RegulActuators, 1024);
  SetLength(RegulActuatorControlBlocks, 1024);

  ModelOpenCloseActuators := TChoiceModelActuator.Create;
  ModelRegulActuators := TChoiceModelActuator.Create;

  ModelBevelGearboxes := TChoiceModelGearbox.Create;

  ModelBevelGearboxes.Add(SAumaGK, AumaGK);
  ModelBevelGearboxes.Add(SMechanicRZAM, MechanicRZAM);
  ModelBevelGearboxes.Add(STramecR, TramecR);
  ModelBevelGearboxes.Add(SRotorkIB, RotorkIB);

  ModelSpurGearboxes := TChoiceModelGearbox.Create;

  ModelSpurGearboxes.add(SAumaGST, AumaGST);

  GuiLangs := TChoiceLang.Create;
  GuiLangs.Add('English', Eng);
  GuiLangs.Add('Українська', Ukr);
  GuiLangs.Add('Русский', Rus);

  OutLangs := TChoiceLang.Create;
  OutLangs.Add('English', Eng);
  OutLangs.Add('Українська', Ukr);
  OutLangs.Add('Русский', Rus);

  Networks := TChoiceNetwork.Create;
  Networks.Add('380 V/50 Hz', Net380V50Hz);
  Networks.Add('400 V/50 Hz', Net400V50Hz);
end.
