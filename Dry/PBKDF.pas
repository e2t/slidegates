unit PBKDF;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  DCPcrypt2;

function PBKDF2(pass, salt: Ansistring; Count, kLen: Integer;
  hash: TDCP_hashclass): Ansistring;

implementation

uses
  Math;

function RPad(x: string; c: Char; s: Integer): string;
var
  i: Integer;
begin
  Result := x;
  if Length(x) < s then
    for i := 1 to s - Length(x) do
      Result := Result + c;
end;

function XorBlock(s, x: Ansistring): Ansistring; inline;
var
  i: Integer;
begin
  SetLength(Result, Length(s));
  for i := 1 to Length(s) do
    Result[i] := Char(Byte(s[i]) xor Byte(x[i]));
end;

function CalcDigest(Text: string; dig: TDCP_hashclass): string;
var
  x: TDCP_hash;
begin
  x := dig.Create(nil);
  try
    x.Init;
    x.UpdateStr(Text);
    SetLength(Result, x.GetHashSize div 8);
    x.Final(Result[1]);
  finally
    x.Free;
  end;
end;

function CalcHMAC(message, key: string; hash: TDCP_hashclass): string;
const
  blocksize = 64;
begin
  // Definition RFC 2104
  if Length(key) > blocksize then
    key := CalcDigest(key, hash);
  key := RPad(key, #0, blocksize);

  Result := CalcDigest(XorBlock(key, RPad('', #$36, blocksize)) + message, hash);
  Result := CalcDigest(XorBlock(key, RPad('', #$5c, blocksize)) + Result, hash);
end;

function PBKDF1(pass, salt: Ansistring; Count: Integer;
  hash: TDCP_hashclass): Ansistring;
var
  i: Integer;
begin
  Result := pass + salt;
  for i := 0 to Count - 1 do
    Result := CalcDigest(Result, hash);
end;

function PBKDF2(pass, salt: Ansistring; Count, kLen: Integer;
  hash: TDCP_hashclass): Ansistring;

  function IntX(i: Integer): Ansistring; inline;
  begin
    Result := Char(i shr 24) + Char(i shr 16) + Char(i shr 8) + Char(i);
  end;

var
  D, I, J: Integer;
  T, F, U: Ansistring;
begin
  T := '';
  D := Ceil(kLen / (hash.GetHashSize div 8));
  for i := 1 to D do
  begin
    F := CalcHMAC(salt + IntX(i), pass, hash);
    U := F;
    for j := 2 to Count do
    begin
      U := CalcHMAC(U, pass, hash);
      F := XorBlock(F, U);
    end;
    T := T + F;
  end;
  Result := Copy(T, 1, kLen);
end;

end.
