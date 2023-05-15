unit IniFileUtils;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  INIFiles, Localization, Fgl, Controller;

function GetLangGui: TLang;
function GetLangOut: TLang;
procedure SetLangGui(const Lang: TLang);
procedure SetLangOut(const Lang: TLang);
function GetNetwork: TNetwork;
procedure SetNetwork(const Network: TNetwork);

implementation

type
  TLangKeys = specialize TFPGMap<string, TLang>;
  TNetworkKeys = specialize TFPGMap<string, TNetwork>;

const
  IniFileName = 'Slidegate.ini';
  IniSection = 'MainWindow';
  IniLangGui = 'LangGui';
  IniLangOut = 'LangOut';
  IniNetwork = 'Network';

var
  IniFile: TIniFile;

generic function GetKey<T>(const Ident: string;
  Keys: specialize TFPGMap<string, T>): T;
var
  Key: string;
  Index: Integer;
begin
  Key := IniFile.ReadString(IniSection, Ident, Keys.Keys[0]);
  Index := Keys.IndexOf(Key);
  if Index < 0 then
    Index := 0;
  Result := Keys.Data[Index];
end;

generic procedure SetKey<T>(const Ident: string; const Value: T;
  Keys: specialize TFPGMap<string, T>);
var
  Key: string;
  Index: Integer;
begin
  Index := Keys.IndexOfData(Value);
  if Index < 0 then
    Exit;
  Key := Keys.Keys[Index];
  IniFile.WriteString(IniSection, Ident, Key);
end;

var
  LangKeys: TLangKeys;
  NetworkKeys: TNetworkKeys;

function GetLangGui: TLang;
begin
  Result := specialize GetKey<TLang>(IniLangGui, LangKeys);
end;

function GetLangOut: TLang;
begin
  Result := specialize GetKey<TLang>(IniLangOut, LangKeys);
end;

procedure SetLangGui(const Lang: TLang);
begin
  specialize SetKey<TLang>(IniLangGui, Lang, LangKeys);
end;

procedure SetLangOut(const Lang: TLang);
begin
  specialize SetKey<TLang>(IniLangOut, Lang, LangKeys);
end;

function GetNetwork: TNetwork;
begin
  Result := specialize GetKey<TNetwork>(IniNetwork, NetworkKeys);
end;

procedure SetNetwork(const Network: TNetwork);
begin
  specialize SetKey<TNetwork>(IniNetwork, Network, NetworkKeys);
end;

initialization
  IniFile := TIniFile.Create(IniFileName);

  LangKeys := TLangKeys.Create;
  LangKeys.Add('Ukr', Ukr);
  LangKeys.Add('Rus', Rus);
  LangKeys.Add('Eng', Eng);

  NetworkKeys := TNetworkKeys.Create;
  NetworkKeys.Add('380V/50Hz', Net380V50Hz);
  NetworkKeys.Add('400V/50Hz', Net400V50Hz);
end.
