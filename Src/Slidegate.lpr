program Slidegate;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  GuiMainForm,
  DriveUnits,
  Screws,
  StrengthCalculations,
  Localization,
  Controller,
  MassWedge,
  MassFlow,
  ProgramInfo,
  Equations,
  Anchors;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Title := 'Slidegate';
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
