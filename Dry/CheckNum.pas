unit CheckNum;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

const
  CompAccuracy = 1e-6;

function IsThis(const Condition: Boolean; const Message: string): Boolean;
function IsPositiveInt(const Value: Integer): Boolean;
function IsPositiveFloat(const Value: Double): Boolean;

implementation

function IsThis(const Condition: Boolean; const Message: string): Boolean;
begin
  Result := Condition;
  if not Condition then
    WriteLn(Message);
end;

function IsPositiveInt(const Value: Integer): Boolean;
begin
  Result := IsThis(Value > 0,
    'Ожидается целое число больше нуля.');
end;

function IsPositiveFloat(const Value: Double): Boolean;
begin
  Result := IsThis(Value > 0, 'Ожидается число больше нуля.');
end;

end.
