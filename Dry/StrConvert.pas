unit StrConvert;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

procedure ConvertStrToFloat(const S: string; out IsValid: Boolean; out Value: ValReal);
procedure ConvertStrToInt(const S: string; out IsValid: Boolean; out Value: Integer);
function FStr(const Value: ValReal; Prec: Byte = 3): string;
procedure UTF8OverWrite(const Source: string; var S: string; const StartCharIndex: PtrInt);
function UTF8FirstLetterUpperCase(const S: string): string;

implementation

uses
  LazUTF8, SysUtils;

const
  TrueDefaultFormatSettings: TFormatSettings = (
    CurrencyFormat: 1;
    NegCurrFormat: 5;
    ThousandSeparator: ',';
    DecimalSeparator: '.';
    CurrencyDecimals: 2;
    DateSeparator: '-';
    TimeSeparator: ':';
    ListSeparator: ',';
    CurrencyString: '$';
    ShortDateFormat: 'd/m/y';
    LongDateFormat: 'dd" "mmmm" "yyyy';
    TimeAMString: 'AM';
    TimePMString: 'PM';
    ShortTimeFormat: 'hh:nn';
    LongTimeFormat: 'hh:nn:ss';
    ShortMonthNames: ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
    'Aug', 'Sep', 'Oct', 'Nov', 'Dec');
    LongMonthNames: ('January', 'February', 'March', 'April', 'May',
    'June', 'July', 'August', 'September', 'October', 'November', 'December');
    ShortDayNames: ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
    LongDayNames: ('Sunday', 'Monday', 'Tuesday', 'Wednesday',
    'Thursday', 'Friday', 'Saturday');
    TwoDigitYearCenturyWindow: 50; );

function FStr(const Value: ValReal; Prec: Byte = 3): string;
const
  IntPart = '#,##0';
var
  FracPart: string;
begin
  case Prec of
    0: FracPart := '';
    1: FracPart := '.#';
    2: FracPart := '.##';
    3: FracPart := '.###';
    4: FracPart := '.####';
    5: FracPart := '.#####';
    6: FracPart := '.######';
    else
      raise Exception.Create('Too much precision');
  end;
  Result := FormatFloat(IntPart + FracPart, Value);
end;

procedure ConvertStrToFloat(const S: string; out IsValid: Boolean; out Value: ValReal);
begin
  IsValid := TryStrToFloat(S, Value);
  if not IsValid then
    IsValid := TryStrToFloat(S, Value, TrueDefaultFormatSettings);
end;

procedure ConvertStrToInt(const S: string; out IsValid: Boolean; out Value: Integer);
begin
  IsValid := TryStrToInt(S, Value);
end;

function UTF8FirstLetterUpperCase(const S: string): string;
var
  FirstLetter: string;
begin
  FirstLetter := UTF8Copy(S, 1, 1);
  Result := Format('%s%s', [UTF8UpperCase(FirstLetter),
    UTF8Copy(S, 2, UTF8LengthFast(S) - 1)]);
end;

procedure UTF8OverWrite(const Source: string; var S: string; const StartCharIndex: PtrInt);
var
  CharCount: Integer;
begin
  CharCount := UTF8LengthFast(Source);
  UTF8Delete(S, StartCharIndex, CharCount);
  UTF8Insert(Source, S, StartCharIndex);
end;

end.
