unit Nullable;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

type
  generic TNullable<T> = object
  protected
    FValue: T;
    procedure SetValue(const Value: T);
    function GetValue(): T;
  public
    HasValue: Boolean;
    property Value: T read GetValue write SetValue;
  end;

  TNullableInt = specialize TNullable<Integer>;
  TNullableReal = specialize TNullable<Double>;
  TNullableBool = specialize TNullable<Boolean>;
  TNullableStr = specialize TNullable<string>;
  TNullableChar = specialize TNullable<Char>;

implementation

procedure TNullable.SetValue(const Value: T);
begin
  FValue := Value;
  HasValue := True;
end;

function TNullable.GetValue(): T;
begin
  Assert(HasValue);
  Result := FValue;
end;

end.
