unit EratosthenesSieve;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  Math;

type
  TEightBits = bitpacked array [0..7] of Boolean;
  TBitArray = array of TEightBits;

  TEratosthenesSieve = class
  private
    FBitArray: TBitArray;
    FMaxNumber: Integer;
    procedure SetBit(const Index: SizeInt; const Value: Boolean);
  public
    property MaxNumber: Integer read FMaxNumber;
    function IsPrime(const Index: SizeInt): Boolean;  // GetBit
    constructor Create(const AMaxNumber: SizeInt);
  end;

implementation

constructor TEratosthenesSieve.Create(const AMaxNumber: SizeInt);
var
  I, J: SizeInt;
begin
  FMaxNumber := AMaxNumber;
  SetLength(FBitArray, Ceil((FMaxNumber + 1) / 8));
  FBitArray[0, 0] := False;  // 0 - не является простым числом.
  if FMaxNumber = 0 then
    Exit;
  FBitArray[0, 1] := False;  // 1 - не является простым числом.
  if FMaxNumber = 1 then
    Exit;
  FBitArray[0, 2] := True;   // 2 - простое число.
  if FMaxNumber = 2 then
    Exit;
  FBitArray[0, 3] := True;   // 3 - простое число.
  if FMaxNumber = 3 then
    Exit;

  I := 4;
  while I < FMaxNumber do
  begin
    SetBit(I, False);
    SetBit(I + 1, True);
    Inc(I, 2);
  end;
  if I = FMaxNumber then
    SetBit(I, False);

  I := 3;
  while I <= Trunc(Sqrt(FMaxNumber)) do
  begin
    if IsPrime(I) then
    begin
      J := I * I;
      while J <= FMaxNumber do
      begin
        SetBit(J, False);
        Inc(J, I);
      end;
    end;
    Inc(I, 2);
  end;
end;

procedure TEratosthenesSieve.SetBit(const Index: SizeInt; const Value: Boolean);
begin
  FBitArray[Index div 8, Index mod 8] := Value;
end;

function TEratosthenesSieve.IsPrime(const Index: SizeInt): Boolean;
begin
  Result := FBitArray[Index div 8, Index mod 8];
end;

end.
