unit EquationUtils;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

type
  TFuncCheckRoot = function(const X: Double): Boolean;
  TRoots = array of Double;

procedure PrintAndCheckRoots(const Roots: TRoots; const CheckRoot: TFuncCheckRoot);

implementation

uses
  SysUtils;

procedure PrintAndCheckRoots(const Roots: TRoots; const CheckRoot: TFuncCheckRoot);
var
  I: Integer;
begin
  if Length(Roots) > 0 then
    for I := Low(Roots) to High(Roots) do
    begin
      Write(Format('x%d = %g', [I + 1, Roots[I]]));
      if CheckRoot(Roots[I]) then
        WriteLn('  CHECKED')
      else
        WriteLn;
    end
  else
    WriteLn('Нет корней');
end;

end.
