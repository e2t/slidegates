unit IniFileUtils;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  INIFiles, Localization, Fgl;

function GetLangGui: TLang;
function GetLangOut: TLang;
procedure SetLangGui(const Lang: TLang);
procedure SetLangOut(const Lang: TLang);

implementation

type
  TLangKeys = specialize TFPGMap<string, TLang>;

const
  IniFileName = 'Slidegate.ini';
  IniSection = 'MainWindow';
  IniLangGui = 'LangGui';
  IniLangOut = 'LangOut';

var
  IniFile: TIniFile;
  LangKeys: TLangKeys;

function GetLang(const Ident: string): TLang;
var
  Key: string;
  Index: Integer;
begin
  Key := IniFile.ReadString(IniSection, Ident, LangKeys.Keys[0]);
  Index := LangKeys.IndexOf(Key);
  if Index < 0 then
    Index := 0;
  Result := LangKeys.Data[Index];
end;

procedure SetLang(const Ident: string; const Lang: TLang);
var
  Key: string;
  Index: Integer;
begin
  Index := LangKeys.IndexOfData(Lang);
  if Index < 0 then
    Exit;
  Key := LangKeys.Keys[Index];
  IniFile.WriteString(IniSection, Ident, Key);
end;

function GetLangGui: TLang;
begin
  Result := GetLang(IniLangGui);
end;

function GetLangOut: TLang;
begin
  Result := GetLang(IniLangOut);
end;

procedure SetLangGui(const Lang: TLang);
begin
  SetLang(IniLangGui, Lang);
end;

procedure SetLangOut(const Lang: TLang);
begin
  SetLang(IniLangOut, Lang);
end;

initialization
  IniFile := TIniFile.Create(IniFileName);

  LangKeys := TLangKeys.Create;
  LangKeys.Add('Ukr', Ukr);
  LangKeys.Add('Rus', Rus);
  LangKeys.Add('Eng', Eng);
end.
