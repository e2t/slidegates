unit EratosthenesSieve;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  Classes;

type
  TSieve = class
  private
    FIsComposite: TBits;
    FMaxNumber: SizeInt;
    procedure SetAll(const Value: Boolean; Number: SizeInt; const Step: SizeInt);
    procedure Resize(const AMaxNumber: SizeInt);
  public
    procedure Calc;
    procedure Clear;
    property MaxNumber: SizeInt read FMaxNumber write Resize;
    function IsPrime(const Number: SizeInt): Boolean;
    constructor Create(const AMaxNumber: SizeInt);
  end;

implementation

{ False - простое, True - не простое }
constructor TSieve.Create(const AMaxNumber: SizeInt);
begin
  FIsComposite := TBits.Create;
  Resize(AMaxNumber);
end;

procedure TSieve.Calc;
var
  I, Number, Step: SizeInt;
begin
  if FMaxNumber < 2 then
    Exit;

  FIsComposite[0] := True; { 1 не является простым числом }

  I := 3;
  while I <= Trunc(Sqrt(FMaxNumber)) do
  begin
    if not FIsComposite[I div 2] then
    begin
      Number := Sqr(I);
      Step := I + I;
      SetAll(True, Number, Step);
    end;
    Inc(I, 2);
  end;
end;

procedure TSieve.Clear;
begin
  FIsComposite.ClearAll;
end;

procedure TSieve.SetAll(const Value: Boolean; Number: SizeInt; const Step: SizeInt);
begin
  while Number <= FMaxNumber do
  begin
    FIsComposite[Number div 2] := Value;
    Inc(Number, Step);
  end;
end;

procedure TSieve.Resize(const AMaxNumber: SizeInt);
begin
  FMaxNumber := AMaxNumber;
  FIsComposite.Size := (AMaxNumber + 1) div 2;
end;

function TSieve.IsPrime(const Number: SizeInt): Boolean;
begin
  if Number = 2 then
    Result := True
  else if (Number mod 2) = 0 then
    Result := False
  else
    Result := not FIsComposite[Number div 2];
end;

end.
