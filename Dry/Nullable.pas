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
    FHasValue: Boolean;
    procedure SetValue(const Value: T);
    function GetValue(): T;
  public
    property HasValue: Boolean read FHasValue;
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
  FHasValue := True;
end;

function TNullable.GetValue(): T;
begin
  Assert(FHasValue);
  Result := FValue;
end;

end.
