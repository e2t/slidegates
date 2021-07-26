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
    function GetReal(out Value: Double): Boolean;
    function GetReal(const S: string; out Value: Double): Boolean;
    function GetRealMin(out Value: Double; const MinValue: Double): Boolean;
    function GetRealMin(const S: string; out Value: Double;
      const MinValue: Double): Boolean;
    function GetRealMinEq(out Value: Double; const MinValue: Double): Boolean;
    function GetRealMinEq(const S: string; out Value: Double;
      const MinValue: Double): Boolean;
    function GetRealMax(out Value: Double; const MaxValue: Double): Boolean;
    function GetRealMax(const S: string; out Value: Double;
      const MaxValue: Double): Boolean;
    function GetRealMaxEq(out Value: Double; const MaxValue: Double): Boolean;
    function GetRealMaxEq(const S: string; out Value: Double;
      const MaxValue: Double): Boolean;
    function GetRealMinMax(out Value: Double; const MinValue, MaxValue: Double): Boolean;
    function GetRealMinMax(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMax(out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMax(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinMaxEq(out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinMaxEq(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMaxEq(out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMaxEq(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
  end;

  TEditHelper = class helper for TEdit
    function GetReal(out Value: Double): Boolean;
    function GetReal(const S: string; out Value: Double): Boolean;
    function GetRealMin(out Value: Double; const MinValue: Double): Boolean;
    function GetRealMin(const S: string; out Value: Double;
      const MinValue: Double): Boolean;
    function GetRealMinEq(out Value: Double; const MinValue: Double): Boolean;
    function GetRealMinEq(const S: string; out Value: Double;
      const MinValue: Double): Boolean;
    function GetRealMax(out Value: Double; const MaxValue: Double): Boolean;
    function GetRealMax(const S: string; out Value: Double;
      const MaxValue: Double): Boolean;
    function GetRealMaxEq(out Value: Double; const MaxValue: Double): Boolean;
    function GetRealMaxEq(const S: string; out Value: Double;
      const MaxValue: Double): Boolean;
    function GetRealMinMax(out Value: Double; const MinValue, MaxValue: Double): Boolean;
    function GetRealMinMax(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMax(out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMax(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinMaxEq(out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinMaxEq(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMaxEq(out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMaxEq(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
  end;

  TLabeledEditHelper = class helper for TLabeledEdit
    function GetReal(out Value: Double): Boolean;
    function GetReal(const S: string; out Value: Double): Boolean;
    function GetRealMin(out Value: Double; const MinValue: Double): Boolean;
    function GetRealMin(const S: string; out Value: Double;
      const MinValue: Double): Boolean;
    function GetRealMinEq(out Value: Double; const MinValue: Double): Boolean;
    function GetRealMinEq(const S: string; out Value: Double;
      const MinValue: Double): Boolean;
    function GetRealMax(out Value: Double; const MaxValue: Double): Boolean;
    function GetRealMax(const S: string; out Value: Double;
      const MaxValue: Double): Boolean;
    function GetRealMaxEq(out Value: Double; const MaxValue: Double): Boolean;
    function GetRealMaxEq(const S: string; out Value: Double;
      const MaxValue: Double): Boolean;
    function GetRealMinMax(out Value: Double; const MinValue, MaxValue: Double): Boolean;
    function GetRealMinMax(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMax(out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMax(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinMaxEq(out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinMaxEq(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMaxEq(out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
    function GetRealMinEqMaxEq(const S: string; out Value: Double;
      const MinValue, MaxValue: Double): Boolean;
  end;

implementation

uses
  SysUtils, Math, CheckNum;

type
  generic TWinControlManager<T, V> = class
    class function GetValue(const Control: T; const S: string; out Value: V): Boolean;
    class function GetValueMin(const Control: T; const S: string; out Value: V;
      const MinValue: V): Boolean;
    class function GetValueMinEq(const Control: T; const S: string;
      out Value: V; const MinValue: V): Boolean;
    class function GetValueMax(const Control: T; const S: string; out Value: V;
      const MaxValue: V): Boolean;
    class function GetValueMaxEq(const Control: T; const S: string;
      out Value: V; const MaxValue: V): Boolean;
    class function GetValueMinMax(const Control: T; const S: string;
      out Value: V; const MinValue, MaxValue: V): Boolean;
    class function GetValueMinEqMax(const Control: T; const S: string;
      out Value: V; const MinValue, MaxValue: V): Boolean;
    class function GetValueMinMaxEq(const Control: T; const S: string;
      out Value: V; const MinValue, MaxValue: V): Boolean;
    class function GetValueMinEqMaxEq(const Control: T; const S: string;
      out Value: V; const MinValue, MaxValue: V): Boolean;
  end;

  TComboBoxReal = specialize TWinControlManager<TComboBox, Double>;
  TEditReal = specialize TWinControlManager<TEdit, Double>;
  TLabeledEditReal = specialize TWinControlManager<TLabeledEdit, Double>;

{ TComboBoxHelper }

function TComboBoxHelper.GetReal(out Value: Double): Boolean;
begin
  Result := TComboBoxReal.GetValue(Self, Self.Text, Value);
end;

function TComboBoxHelper.GetReal(const S: string; out Value: Double): Boolean;
begin
  Result := TComboBoxReal.GetValue(Self, S, Value);
end;

function TComboBoxHelper.GetRealMin(out Value: Double; const MinValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMin(Self, Self.Text, Value, MinValue);
end;

function TComboBoxHelper.GetRealMin(const S: string; out Value: Double;
  const MinValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMin(Self, S, Value, MinValue);
end;

function TComboBoxHelper.GetRealMinEq(out Value: Double;
  const MinValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinEq(Self, Self.Text, Value, MinValue);
end;

function TComboBoxHelper.GetRealMinEq(const S: string; out Value: Double;
  const MinValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinEq(Self, S, Value, MinValue);
end;

function TComboBoxHelper.GetRealMax(out Value: Double; const MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMax(Self, Self.Text, Value, MaxValue);
end;

function TComboBoxHelper.GetRealMax(const S: string; out Value: Double;
  const MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMax(Self, S, Value, MaxValue);
end;

function TComboBoxHelper.GetRealMaxEq(out Value: Double;
  const MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMaxEq(Self, Self.Text, Value, MaxValue);
end;

function TComboBoxHelper.GetRealMaxEq(const S: string; out Value: Double;
  const MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMaxEq(Self, S, Value, MaxValue);
end;

function TComboBoxHelper.GetRealMinMax(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinMax(Self, Self.Text, Value, MinValue, MaxValue);
end;

function TComboBoxHelper.GetRealMinMax(const S: string; out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinMax(Self, S, Value, MinValue, MaxValue);
end;

function TComboBoxHelper.GetRealMinEqMax(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinEqMax(Self, Self.Text, Value, MinValue, MaxValue);
end;

function TComboBoxHelper.GetRealMinEqMax(const S: string; out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinEqMax(Self, S, Value, MinValue, MaxValue);
end;

function TComboBoxHelper.GetRealMinMaxEq(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinMaxEq(Self, Self.Text, Value, MinValue, MaxValue);
end;

function TComboBoxHelper.GetRealMinMaxEq(const S: string; out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinMaxEq(Self, S, Value, MinValue, MaxValue);
end;

function TComboBoxHelper.GetRealMinEqMaxEq(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinEqMaxEq(Self, Self.Text, Value, MinValue, MaxValue);
end;

function TComboBoxHelper.GetRealMinEqMaxEq(const S: string; out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TComboBoxReal.GetValueMinEqMaxEq(Self, S, Value, MinValue, MaxValue);
end;

{ TEditHelper }

function TEditHelper.GetReal(out Value: Double): Boolean;
begin
  Result := TEditReal.GetValue(Self, Self.Text, Value);
end;

function TEditHelper.GetReal(const S: string; out Value: Double): Boolean;
begin
  Result := TEditReal.GetValue(Self, S, Value);
end;

function TEditHelper.GetRealMin(out Value: Double; const MinValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMin(Self, Self.Text, Value, MinValue);
end;

function TEditHelper.GetRealMin(const S: string; out Value: Double;
  const MinValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMin(Self, S, Value, MinValue);
end;

function TEditHelper.GetRealMinEq(out Value: Double; const MinValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinEq(Self, Self.Text, Value, MinValue);
end;

function TEditHelper.GetRealMinEq(const S: string; out Value: Double;
  const MinValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinEq(Self, S, Value, MinValue);
end;

function TEditHelper.GetRealMax(out Value: Double; const MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMax(Self, Self.Text, Value, MaxValue);
end;

function TEditHelper.GetRealMax(const S: string; out Value: Double;
  const MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMax(Self, S, Value, MaxValue);
end;

function TEditHelper.GetRealMaxEq(out Value: Double; const MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMaxEq(Self, Self.Text, Value, MaxValue);
end;

function TEditHelper.GetRealMaxEq(const S: string; out Value: Double;
  const MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMaxEq(Self, S, Value, MaxValue);
end;

function TEditHelper.GetRealMinMax(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinMax(Self, Self.Text, Value, MinValue, MaxValue);
end;

function TEditHelper.GetRealMinMax(const S: string; out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinMax(Self, S, Value, MinValue, MaxValue);
end;

function TEditHelper.GetRealMinEqMax(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinEqMax(Self, Self.Text, Value, MinValue, MaxValue);
end;

function TEditHelper.GetRealMinEqMax(const S: string; out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinEqMax(Self, S, Value, MinValue, MaxValue);
end;

function TEditHelper.GetRealMinMaxEq(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinMaxEq(Self, Self.Text, Value, MinValue, MaxValue);
end;

function TEditHelper.GetRealMinMaxEq(const S: string; out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinMaxEq(Self, S, Value, MinValue, MaxValue);
end;

function TEditHelper.GetRealMinEqMaxEq(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinEqMaxEq(Self, Self.Text, Value, MinValue, MaxValue);
end;

function TEditHelper.GetRealMinEqMaxEq(const S: string; out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TEditReal.GetValueMinEqMaxEq(Self, S, Value, MinValue, MaxValue);
end;

{ TLabeledEditHelper }

function TLabeledEditHelper.GetReal(out Value: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValue(Self, Self.Text, Value);
end;

function TLabeledEditHelper.GetReal(const S: string; out Value: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValue(Self, S, Value);
end;

function TLabeledEditHelper.GetRealMin(out Value: Double;
  const MinValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMin(Self, Self.Text, Value, MinValue);
end;

function TLabeledEditHelper.GetRealMin(const S: string; out Value: Double;
  const MinValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMin(Self, S, Value, MinValue);
end;

function TLabeledEditHelper.GetRealMinEq(out Value: Double;
  const MinValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinEq(Self, Self.Text, Value, MinValue);
end;

function TLabeledEditHelper.GetRealMinEq(const S: string; out Value: Double;
  const MinValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinEq(Self, S, Value, MinValue);
end;

function TLabeledEditHelper.GetRealMax(out Value: Double;
  const MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMax(Self, Self.Text, Value, MaxValue);
end;

function TLabeledEditHelper.GetRealMax(const S: string; out Value: Double;
  const MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMax(Self, S, Value, MaxValue);
end;

function TLabeledEditHelper.GetRealMaxEq(out Value: Double;
  const MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMaxEq(Self, Self.Text, Value, MaxValue);
end;

function TLabeledEditHelper.GetRealMaxEq(const S: string; out Value: Double;
  const MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMaxEq(Self, S, Value, MaxValue);
end;

function TLabeledEditHelper.GetRealMinMax(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinMax(Self, Self.Text, Value, MinValue, MaxValue);
end;

function TLabeledEditHelper.GetRealMinMax(const S: string; out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinMax(Self, S, Value, MinValue, MaxValue);
end;

function TLabeledEditHelper.GetRealMinEqMax(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinEqMax(Self, Self.Text, Value,
    MinValue, MaxValue);
end;

function TLabeledEditHelper.GetRealMinEqMax(const S: string;
  out Value: Double; const MinValue, MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinEqMax(Self, S, Value, MinValue, MaxValue);
end;

function TLabeledEditHelper.GetRealMinMaxEq(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinMaxEq(Self, Self.Text, Value,
    MinValue, MaxValue);
end;

function TLabeledEditHelper.GetRealMinMaxEq(const S: string;
  out Value: Double; const MinValue, MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinMaxEq(Self, S, Value, MinValue, MaxValue);
end;

function TLabeledEditHelper.GetRealMinEqMaxEq(out Value: Double;
  const MinValue, MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinEqMaxEq(Self, Self.Text,
    Value, MinValue, MaxValue);
end;

function TLabeledEditHelper.GetRealMinEqMaxEq(const S: string;
  out Value: Double; const MinValue, MaxValue: Double): Boolean;
begin
  Result := TLabeledEditReal.GetValueMinEqMaxEq(Self, S, Value, MinValue, MaxValue);
end;

{ TWinControlManager }

class function TWinControlManager.GetValue(const Control: T; const S: string;
  out Value: V): Boolean;
begin
  Result := TwiceTryStrToFloat(S, Value);
  if not Result then
  begin
    Control.SetFocus;
    Control.SelectAll;
  end;
end;

class function TWinControlManager.GetValueMin(const Control: T;
  const S: string; out Value: V; const MinValue: V): Boolean;
begin
  Result := TWinControlManager.GetValue(Control, S, Value);
  if Result then
    Result := Value > MinValue;
end;

class function TWinControlManager.GetValueMinEq(const Control: T;
  const S: string; out Value: V; const MinValue: V): Boolean;
begin
  Result := TWinControlManager.GetValue(Control, S, Value);
  if Result then
    Result := Value >= MinValue;
end;

class function TWinControlManager.GetValueMax(const Control: T;
  const S: string; out Value: V; const MaxValue: V): Boolean;
begin
  Result := TWinControlManager.GetValue(Control, S, Value);
  if Result then
    Result := Value < MaxValue;
end;

class function TWinControlManager.GetValueMaxEq(const Control: T;
  const S: string; out Value: V; const MaxValue: V): Boolean;
begin
  Result := TWinControlManager.GetValue(Control, S, Value);
  if Result then
    Result := Value <= MaxValue;
end;

class function TWinControlManager.GetValueMinMax(const Control: T;
  const S: string; out Value: V; const MinValue, MaxValue: V): Boolean;
begin
  Result := TWinControlManager.GetValue(Control, S, Value);
  if Result then
    Result := (MinValue < Value) and (Value < MaxValue);
end;

class function TWinControlManager.GetValueMinEqMax(const Control: T;
  const S: string; out Value: V; const MinValue, MaxValue: V): Boolean;
begin
  Result := TWinControlManager.GetValue(Control, S, Value);
  if Result then
    Result := (MinValue <= Value) and (Value < MaxValue);
end;

class function TWinControlManager.GetValueMinMaxEq(const Control: T;
  const S: string; out Value: V; const MinValue, MaxValue: V): Boolean;
begin
  Result := TWinControlManager.GetValue(Control, S, Value);
  if Result then
    Result := (MinValue < Value) and
      (CompareValue(Value, MaxValue, CompAccuracy) <= 0);
end;

class function TWinControlManager.GetValueMinEqMaxEq(const Control: T;
  const S: string; out Value: V; const MinValue, MaxValue: V): Boolean;
begin
  Result := TWinControlManager.GetValue(Control, S, Value);
  if Result then
    Result := (MinValue <= Value) and (Value <= MaxValue);
end;

end.
