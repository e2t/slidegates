unit GuiMainForm;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    ButtonRun: TButton;
    CheckBoxTwoScrews: TCheckBox;
    CheckBoxCounterFlange: TCheckBox;
    CheckBoxWithoutFrameNodes: TCheckBox;
    CheckBoxThreeWedgePairs: TCheckBox;
    CheckBoxRackWithoutPipeNodes: TCheckBox;
    CheckBoxBracketWithoutPipeNodes: TCheckBox;
    ComboBoxGuiLang: Tcombobox;
    ComboBoxOutLang: Tcombobox;
    ComboBoxNetwork: TComboBox;
    ComboBoxRegulActuator: TComboBox;
    ComboBoxBevelGearbox: TComboBox;
    ComboBoxFrameSheet: TComboBox;
    ComboBoxGateSheet: TComboBox;
    ComboBoxSpurGearbox: TComboBox;
    ComboBoxOpenCloseActuator: TComboBox;
    ComboBoxScrew: TComboBox;
    EditBtwFrameTopAndGround: TEdit;
    EditBtwFrameTopAndDriveUnit: TEdit;
    EditFullWays: TEdit;
    EditMinSpeed: TEdit;
    EditFrameWidth: TEdit;
    EditFrameHeight: TEdit;
    EditGateHeight: TEdit;
    EditLiquidDensity: TEdit;
    EditBethFrameTopAndGateTop: TEdit;
    EditHydrHead: TEdit;
    EditWay: TEdit;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    Label1: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label5: TLabel;
    LabelHandWheel: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MemoOutput: TMemo;
    PageControlDriveLocation: TPageControl;
    PageControlDriveKind: TPageControl;
    PageControlSlgKind: TPageControl;
    Panel1: TPanel;
    RadioButtonOpenClose: TRadioButton;
    RadioButtonRegulConcrete: TRadioButton;
    RadioButtonRegulChannel: TRadioButton;
    RadioButtonRegulWall: TRadioButton;
    RadioButtonBevelGearbox: TRadioButton;
    RadioButtonSurfConcrete: TRadioButton;
    RadioButtonSurfChannel: TRadioButton;
    RadioButtonSurfWall: TRadioButton;
    RadioButtonDeepWall: TRadioButton;
    RadioButtonDeepConcrete: TRadioButton;
    RadioButtonDeepFlange: TRadioButton;
    RadioButtonDeepTwoFlange: TRadioButton;
    RadioButtonSpurGearbox: TRadioButton;
    RadioButtonNonPullout: TRadioButton;
    RadioButtonRegul: TRadioButton;
    RadioButtonPullout: TRadioButton;
    TabSheetOnFrame: TTabSheet;
    TabSheetOnRack: TTabSheet;
    TabSheetOnBracket: TTabSheet;
    TabSheetActuator: TTabSheet;
    TabSheetGearbox: TTabSheet;
    TabSheetHandWheel: TTabSheet;
    TabSheetSurf: TTabSheet;
    TabSheetDeep: TTabSheet;
    TabSheetFlow: TTabSheet;
    procedure ButtonRunClick(Sender: TObject);
    procedure ComboBoxGuiLangChange(Sender: TObject);
    procedure ComboBoxNetworkChange(Sender: TObject);
    procedure ComboBoxOutLangChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

uses
  Controller, LCLType;

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  MainFormInit();
end;

procedure TMainForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = Chr(VK_RETURN) then
    Run();
end;

procedure TMainForm.ButtonRunClick(Sender: TObject);
begin
  Run();
end;

procedure Tmainform.ComboBoxGuiLangChange(Sender: TObject);
begin
  ReTranslateGui;
end;

procedure TMainForm.ComboBoxNetworkChange(Sender: TObject);
begin
  ChangeNetwork;
end;

procedure Tmainform.ComboBoxOutLangChange(Sender: TObject);
begin
  RePrintResults;
end;

end.
