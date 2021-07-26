unit ProgramInfo;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

function GetProgramTitle(): string;

implementation

uses
  FileInfo, SysUtils;

function GetProgramTitle(): string;
var
  Info: TFileVersionInfo;
  Versions: TStringArray;
begin
  Info := TFileVersionInfo.Create(nil);
  Info.ReadFileInfo;
  Versions := Info.VersionStrings.Values['FileVersion'].Split('.');
  Result := Format('%s v%s.%s.%s', [Info.VersionStrings.Values['FileDescription'],
    Versions[0], Versions[1], Versions[2]]);
  Info.Free;
end;

end.

