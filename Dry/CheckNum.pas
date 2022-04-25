unit CheckNum;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

const
  CompAccuracy = 1e-6;

function IsEqual(const A, B: Double; const Accuracy: Double = CompAccuracy): Boolean;
function IsMore(const Larger, Smaller: Double; const Accuracy: Double = CompAccuracy): Boolean;
function IsMoreEq(const Larger, Smaller: Double; const Accuracy: Double = CompAccuracy): Boolean;
function IsLess(const Smaller, Larger: Double; const Accuracy: Double = CompAccuracy): Boolean;
function IsLessEq(const Smaller, Larger: Double; const Accuracy: Double = CompAccuracy): Boolean;

function IsThis(const Condition: Boolean; const Message: string): Boolean;
function IsPositiveInt(const Value: Integer): Boolean;
function IsPositiveFloat(const Value: Double): Boolean;
function IsPositiveOrZeroFloat(const Value: Double): Boolean;
function IsNonZeroFloat(const Value: Double): Boolean;

implementation

uses
  Math;

function IsEqual(const A, B: Double; const Accuracy: Double = CompAccuracy): Boolean;
begin
  Result := CompareValue(A, B, Accuracy) = 0;
end;

function IsMore(const Larger, Smaller: Double; const Accuracy: Double = CompAccuracy): Boolean;
begin
  Result := CompareValue(Larger, Smaller, Accuracy) > 0;
end;

function IsMoreEq(const Larger, Smaller: Double; const Accuracy: Double = CompAccuracy): Boolean;
begin
  Result := CompareValue(Larger, Smaller, Accuracy) >= 0;
end;

function IsLess(const Smaller, Larger: Double; const Accuracy: Double = CompAccuracy): Boolean;
begin
  Result := CompareValue(Smaller, Larger, Accuracy) < 0;
end;

function IsLessEq(const Smaller, Larger: Double; const Accuracy: Double = CompAccuracy): Boolean;
begin
  Result := CompareValue(Smaller, Larger, Accuracy) <= 0;
end;

function IsThis(const Condition: Boolean; const Message: string): Boolean;
begin
  Result := Condition;
  if not Condition then
    WriteLn(Message);
end;

function IsPositiveInt(const Value: Integer): Boolean;
begin
  Result := IsThis(Value > 0, 'Ожидается целое число больше нуля.');
end;

function IsPositiveFloat(const Value: Double): Boolean;
begin
  Result := IsThis(IsMore(Value, 0), 'Ожидается число больше нуля.');
end;

function IsPositiveOrZeroFloat(const Value: Double): Boolean;
begin
  Result := IsThis(IsMoreEq(Value, 0), 'Ожидается число не меньше нуля.');
end;

function IsNonZeroFloat(const Value: Double): Boolean;
begin
  Result := IsThis(not IsEqual(Value, 0), 'Ожидается число, не равное нулю.');
end;

end.
