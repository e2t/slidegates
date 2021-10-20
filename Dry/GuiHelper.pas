unit GuiHelper;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  StdCtrls, ExtCtrls, StrConvert;

type
  TComboBoxHelper = class helper for TComboBox
    procedure GetReal(out IsValid: Boolean; out Value: Double);
    procedure GetReal(const S: string; out IsValid: Boolean; out Value: Double);
    procedure GetRealMin(const MinValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMin(const S: string; const MinValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEq(const MinValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMinEq(const S: string; const MinValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMax(const MaxValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMax(const S: string; const MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMaxEq(const MaxValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMaxEq(const S: string; const MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMax(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMax(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMax(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMax(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMaxEq(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMaxEq(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMaxEq(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMaxEq(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);

    procedure GetInt(out IsValid: Boolean; out Value: Integer);
    procedure GetInt(const S: string; out IsValid: Boolean; out Value: Integer);
    procedure GetIntMin(const MinValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMin(const S: string; const MinValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEq(const MinValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMinEq(const S: string; const MinValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMax(const MaxValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMax(const S: string; const MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMaxEq(const MaxValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMaxEq(const S: string; const MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMax(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMax(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMax(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMax(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMaxEq(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMaxEq(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMaxEq(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMaxEq(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
  end;


  TEditHelper = class helper for TEdit
    procedure GetReal(out IsValid: Boolean; out Value: Double);
    procedure GetReal(const S: string; out IsValid: Boolean; out Value: Double);
    procedure GetRealMin(const MinValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMin(const S: string; const MinValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEq(const MinValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMinEq(const S: string; const MinValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMax(const MaxValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMax(const S: string; const MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMaxEq(const MaxValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMaxEq(const S: string; const MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMax(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMax(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMax(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMax(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMaxEq(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMaxEq(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMaxEq(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMaxEq(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);

    procedure GetInt(out IsValid: Boolean; out Value: Integer);
    procedure GetInt(const S: string; out IsValid: Boolean; out Value: Integer);
    procedure GetIntMin(const MinValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMin(const S: string; const MinValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEq(const MinValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMinEq(const S: string; const MinValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMax(const MaxValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMax(const S: string; const MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMaxEq(const MaxValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMaxEq(const S: string; const MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMax(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMax(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMax(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMax(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMaxEq(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMaxEq(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMaxEq(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMaxEq(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
  end;

  TLabeledEditHelper = class helper for TLabeledEdit
    procedure GetReal(out IsValid: Boolean; out Value: Double);
    procedure GetReal(const S: string; out IsValid: Boolean; out Value: Double);
    procedure GetRealMin(const MinValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMin(const S: string; const MinValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEq(const MinValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMinEq(const S: string; const MinValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMax(const MaxValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMax(const S: string; const MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMaxEq(const MaxValue: Double; out IsValid: Boolean;
      out Value: Double);
    procedure GetRealMaxEq(const S: string; const MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMax(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMax(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMax(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMax(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMaxEq(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinMaxEq(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMaxEq(const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);
    procedure GetRealMinEqMaxEq(const S: string; const MinValue, MaxValue: Double;
      out IsValid: Boolean; out Value: Double);

    procedure GetInt(out IsValid: Boolean; out Value: Integer);
    procedure GetInt(const S: string; out IsValid: Boolean; out Value: Integer);
    procedure GetIntMin(const MinValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMin(const S: string; const MinValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEq(const MinValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMinEq(const S: string; const MinValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMax(const MaxValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMax(const S: string; const MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMaxEq(const MaxValue: Integer; out IsValid: Boolean;
      out Value: Integer);
    procedure GetIntMaxEq(const S: string; const MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMax(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMax(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMax(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMax(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMaxEq(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinMaxEq(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMaxEq(const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
    procedure GetIntMinEqMaxEq(const S: string; const MinValue, MaxValue: Integer;
      out IsValid: Boolean; out Value: Integer);
  end;

type
  generic TWinControlManager<T, V> = class
    FConvert:
    procedure(const S: string; out IsNumber: Boolean; out Value: V); static;

    class procedure GetValue(const Control: T; const S: string;
      out IsValid: Boolean; out Value: V);
    class procedure GetValueMin(const Control: T; const S: string;
      const MinValue: V; out IsValid: Boolean; out Value: V);
    class procedure GetValueMinEq(const Control: T; const S: string;
      const MinValue: V; out IsValid: Boolean; out Value: V);
    class procedure GetValueMax(const Control: T; const S: string;
      const MaxValue: V; out IsValid: Boolean; out Value: V);
    class procedure GetValueMaxEq(const Control: T; const S: string;
      const MaxValue: V; out IsValid: Boolean; out Value: V);
    class procedure GetValueMinMax(const Control: T; const S: string;
      const MinValue, MaxValue: V; out IsValid: Boolean; out Value: V);
    class procedure GetValueMinEqMax(const Control: T; const S: string;
      const MinValue, MaxValue: V; out IsValid: Boolean; out Value: V);
    class procedure GetValueMinMaxEq(const Control: T; const S: string;
      const MinValue, MaxValue: V; out IsValid: Boolean; out Value: V);
    class procedure GetValueMinEqMaxEq(const Control: T; const S: string;
      const MinValue, MaxValue: V; out IsValid: Boolean; out Value: V);
    class procedure SelectIncorrectInput(const Control: T);
  end;

  TComboBoxReal = specialize TWinControlManager<TComboBox, Double>;
  TComboBoxInt = specialize TWinControlManager<TComboBox, Integer>;
  TEditReal = specialize TWinControlManager<TEdit, Double>;
  TEditInt = specialize TWinControlManager<TEdit, Integer>;
  TLabeledEditReal = specialize TWinControlManager<TLabeledEdit, Double>;
  TLabeledEditInt = specialize TWinControlManager<TLabeledEdit, Integer>;

implementation

uses
  SysUtils, Math, CheckNum;

{ TComboBoxHelper }

procedure TComboBoxHelper.GetReal(out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValue(Self, Self.Text, IsValid, Value);
end;

procedure TComboBoxHelper.GetReal(const S: string; out IsValid: Boolean;
  out Value: Double);
begin
  TComboBoxReal.GetValue(Self, S, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMin(const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMin(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMin(const S: string; const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMin(Self, S, MinValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinEq(const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinEq(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinEq(const S: string; const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinEq(Self, S, MinValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMax(const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMax(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMax(const S: string; const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMax(Self, S, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMaxEq(const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMaxEq(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMaxEq(const S: string; const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMaxEq(Self, S, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinMax(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinMax(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinEqMax(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinEqMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinEqMax(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinEqMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinMaxEq(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinMaxEq(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinEqMaxEq(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinEqMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetRealMinEqMaxEq(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TComboBoxReal.GetValueMinEqMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetInt(out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValue(Self, Self.Text, IsValid, Value);
end;

procedure TComboBoxHelper.GetInt(const S: string; out IsValid: Boolean;
  out Value: Integer);
begin
  TComboBoxInt.GetValue(Self, S, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMin(const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMin(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMin(const S: string; const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMin(Self, S, MinValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinEq(const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinEq(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinEq(const S: string; const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinEq(Self, S, MinValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMax(const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMax(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMax(const S: string; const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMax(Self, S, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMaxEq(const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMaxEq(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMaxEq(const S: string; const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMaxEq(Self, S, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinMax(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinMax(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinEqMax(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinEqMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinEqMax(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinEqMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinMaxEq(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinMaxEq(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinEqMaxEq(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinEqMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TComboBoxHelper.GetIntMinEqMaxEq(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TComboBoxInt.GetValueMinEqMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

{ TEditHelper }

procedure TEditHelper.GetReal(out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValue(Self, Self.Text, IsValid, Value);
end;

procedure TEditHelper.GetReal(const S: string; out IsValid: Boolean;
  out Value: Double);
begin
  TEditReal.GetValue(Self, S, IsValid, Value);
end;

procedure TEditHelper.GetRealMin(const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMin(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMin(const S: string; const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMin(Self, S, MinValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinEq(const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinEq(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinEq(const S: string; const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinEq(Self, S, MinValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMax(const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMax(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMax(const S: string; const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMax(Self, S, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMaxEq(const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMaxEq(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMaxEq(const S: string; const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMaxEq(Self, S, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinMax(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinMax(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinEqMax(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinEqMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinEqMax(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinEqMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinMaxEq(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinMaxEq(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinEqMaxEq(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinEqMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetRealMinEqMaxEq(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TEditReal.GetValueMinEqMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetInt(out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValue(Self, Self.Text, IsValid, Value);
end;

procedure TEditHelper.GetInt(const S: string; out IsValid: Boolean;
  out Value: Integer);
begin
  TEditInt.GetValue(Self, S, IsValid, Value);
end;

procedure TEditHelper.GetIntMin(const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMin(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMin(const S: string; const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMin(Self, S, MinValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinEq(const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinEq(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinEq(const S: string; const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinEq(Self, S, MinValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMax(const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMax(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMax(const S: string; const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMax(Self, S, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMaxEq(const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMaxEq(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMaxEq(const S: string; const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMaxEq(Self, S, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinMax(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinMax(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinEqMax(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinEqMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinEqMax(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinEqMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinMaxEq(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinMaxEq(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinEqMaxEq(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinEqMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TEditHelper.GetIntMinEqMaxEq(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TEditInt.GetValueMinEqMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

{ TLabeledEditHelper }

procedure TLabeledEditHelper.GetReal(out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValue(Self, Self.Text, IsValid, Value);
end;

procedure TLabeledEditHelper.GetReal(const S: string; out IsValid: Boolean;
  out Value: Double);
begin
  TLabeledEditReal.GetValue(Self, S, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMin(const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMin(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMin(const S: string; const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMin(Self, S, MinValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinEq(const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinEq(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinEq(const S: string; const MinValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinEq(Self, S, MinValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMax(const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMax(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMax(const S: string; const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMax(Self, S, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMaxEq(const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMaxEq(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMaxEq(const S: string; const MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMaxEq(Self, S, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinMax(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinMax(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinEqMax(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinEqMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinEqMax(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinEqMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinMaxEq(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinMaxEq(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinEqMaxEq(const MinValue, MaxValue: Double;
  out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinEqMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetRealMinEqMaxEq(const S: string;
  const MinValue, MaxValue: Double; out IsValid: Boolean; out Value: Double);
begin
  TLabeledEditReal.GetValueMinEqMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetInt(out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValue(Self, Self.Text, IsValid, Value);
end;

procedure TLabeledEditHelper.GetInt(const S: string; out IsValid: Boolean;
  out Value: Integer);
begin
  TLabeledEditInt.GetValue(Self, S, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMin(const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMin(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMin(const S: string; const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMin(Self, S, MinValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinEq(const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinEq(Self, Self.Text, MinValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinEq(const S: string; const MinValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinEq(Self, S, MinValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMax(const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMax(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMax(const S: string; const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMax(Self, S, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMaxEq(const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMaxEq(Self, Self.Text, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMaxEq(const S: string; const MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMaxEq(Self, S, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinMax(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinMax(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinEqMax(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinEqMax(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinEqMax(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinEqMax(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinMaxEq(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinMaxEq(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinEqMaxEq(const MinValue, MaxValue: Integer;
  out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinEqMaxEq(Self, Self.Text, MinValue, MaxValue, IsValid, Value);
end;

procedure TLabeledEditHelper.GetIntMinEqMaxEq(const S: string;
  const MinValue, MaxValue: Integer; out IsValid: Boolean; out Value: Integer);
begin
  TLabeledEditInt.GetValueMinEqMaxEq(Self, S, MinValue, MaxValue, IsValid, Value);
end;

{ TWinControlManager }

class procedure TWinControlManager.GetValue(const Control: T; const S: string;
  out IsValid: Boolean; out Value: V);
var
  IsNumber: Boolean;
begin
  FConvert(S, IsNumber, Value);
  IsValid := IsNumber;

  if not IsValid then
    TWinControlManager.SelectIncorrectInput(Control);
end;

class procedure TWinControlManager.GetValueMin(const Control: T;
  const S: string; const MinValue: V; out IsValid: Boolean; out Value: V);
var
  IsNumber: Boolean;
begin
  FConvert(S, IsNumber, Value);
  if IsNumber then
    IsValid := Value > MinValue
  else
    IsValid := False;

  if not IsValid then
    TWinControlManager.SelectIncorrectInput(Control);
end;

class procedure TWinControlManager.GetValueMinEq(const Control: T;
  const S: string; const MinValue: V; out IsValid: Boolean; out Value: V);
var
  IsNumber: Boolean;
begin
  FConvert(S, IsNumber, Value);
  if IsNumber then
    IsValid := Value >= MinValue
  else
    IsValid := False;

  if not IsValid then
    TWinControlManager.SelectIncorrectInput(Control);
end;

class procedure TWinControlManager.GetValueMax(const Control: T;
  const S: string; const MaxValue: V; out IsValid: Boolean; out Value: V);
var
  IsNumber: Boolean;
begin
  FConvert(S, IsNumber, Value);
  if IsNumber then
    IsValid := Value < MaxValue
  else
    IsValid := False;

  if not IsValid then
    TWinControlManager.SelectIncorrectInput(Control);
end;

class procedure TWinControlManager.GetValueMaxEq(const Control: T;
  const S: string; const MaxValue: V; out IsValid: Boolean; out Value: V);
var
  IsNumber: Boolean;
begin
  FConvert(S, IsNumber, Value);
  if IsNumber then
    IsValid := Value <= MaxValue
  else
    IsValid := False;

  if not IsValid then
    TWinControlManager.SelectIncorrectInput(Control);
end;

class procedure TWinControlManager.GetValueMinMax(const Control: T;
  const S: string; const MinValue, MaxValue: V; out IsValid: Boolean; out Value: V);
var
  IsNumber: Boolean;
begin
  FConvert(S, IsNumber, Value);
  if IsNumber then
    IsValid := (MinValue < Value) and (Value < MaxValue)
  else
    IsValid := False;

  if not IsValid then
    TWinControlManager.SelectIncorrectInput(Control);
end;

class procedure TWinControlManager.GetValueMinEqMax(const Control: T;
  const S: string; const MinValue, MaxValue: V; out IsValid: Boolean; out Value: V);
var
  IsNumber: Boolean;
begin
  FConvert(S, IsNumber, Value);
  if IsNumber then
    IsValid := (MinValue <= Value) and (Value < MaxValue)
  else
    IsValid := False;

  if not IsValid then
    TWinControlManager.SelectIncorrectInput(Control);
end;

class procedure TWinControlManager.GetValueMinMaxEq(const Control: T;
  const S: string; const MinValue, MaxValue: V; out IsValid: Boolean; out Value: V);
var
  IsNumber: Boolean;
begin
  FConvert(S, IsNumber, Value);
  if IsNumber then
    IsValid := (MinValue < Value) and
      (CompareValue(Value, MaxValue, CompAccuracy) <= 0)
  else
    IsValid := False;

  if not IsValid then
    TWinControlManager.SelectIncorrectInput(Control);
end;

class procedure TWinControlManager.GetValueMinEqMaxEq(const Control: T;
  const S: string; const MinValue, MaxValue: V; out IsValid: Boolean; out Value: V);
var
  IsNumber: Boolean;
begin
  FConvert(S, IsNumber, Value);
  if IsNumber then
    IsValid := (MinValue <= Value) and (Value <= MaxValue)
  else
    IsValid := False;

  if not IsValid then
    TWinControlManager.SelectIncorrectInput(Control);
end;

class procedure TWinControlManager.SelectIncorrectInput(const Control: T);
begin
  Control.SetFocus;
end;

initialization
  TComboBoxReal.FConvert := @ConvertStrToFloat;
  TComboBoxInt.FConvert := @ConvertStrToInt;
  TEditReal.FConvert := @ConvertStrToFloat;
  TEditInt.FConvert := @ConvertStrToInt;
  TLabeledEditReal.FConvert := @ConvertStrToFloat;
  TLabeledEditInt.FConvert := @ConvertStrToInt;
end.
