unit EratosthenesSieve;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  Classes;

procedure CalcSieve(var Bits: TBits);

implementation

type
  TSiever = class
  private
    FBits: TBits;
    FMaxNumber: SizeInt;
    procedure SetAll(const Value: Boolean; Number: SizeInt; const Step: SizeInt);
  public
    constructor Create(var Bits: TBits);
  end;

constructor TSiever.Create(var Bits: TBits);
var
  I, Number, Step: SizeInt;
begin
  Bits.ClearAll;
  if Bits.Size < 3 then
    Exit;
  FBits := Bits;
  FMaxNumber := Bits.Size - 1;

  Bits[2] := True;
  SetAll(True, 3, 2);

  I := 3;
  while I <= Trunc(Sqrt(FMaxNumber)) do
  begin
    if Bits[I] then
    begin
      Number := Sqr(I);
      Step := I + I;
      SetAll(False, Number, Step);
    end;
    Inc(I, 2);
  end;
end;

procedure TSiever.SetAll(const Value: Boolean; Number: SizeInt; const Step: SizeInt);
begin
  while Number <= FMaxNumber do
  begin
    FBits[Number] := Value;
    Inc(Number, Step);
  end;
end;

procedure CalcSieve(var Bits: TBits);
begin
  TSiever.Create(Bits).Free;
end;

end.
