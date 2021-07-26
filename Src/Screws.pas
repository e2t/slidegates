unit Screws;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses
  Localization;

type
  TNut = record
    DesignationR: string;
    DesignationL: string;
    SectionSize: Double;
    Length: Double;
    IsSquare: Boolean;
  end;

  TScrew = record
    MajorDiam: Double;
    PitchDiam: Double;
    MinorDiam: Double;
    Pitch: Double;
    SizeToStr: string;
    DesignationR: string;
    DesignationL: string;
    ThreadAngle: Double;
  end;

  TBuyableScrewSet = record
    Screw: TScrew;
    NutForPullout: TNut;
    NutForFixed: TNut;
  end;

var
  StdScrews: array [0..9] of TBuyableScrewSet;

function SelfMadeNut(const MajorScrewDiam: Double): TNut;
function ScrewTr(const MajorDiam, Pitch: Double): TScrew;
function GetNut(const StdScrew: TBuyableScrewSet; const IsScrewPullout: Boolean): TNut;
function NutDesgination(const Nut: TNut; const IsRightHanded: Boolean;
  const Lang: TLang): string;

implementation

uses
  SysUtils, MathUtils, Measurements;

function CreateScrew(const MajorDiam, PitchDiam, MinorDiam, Pitch: Double;
  const SizeToStr, DesignationR, DesignationL: string): TScrew;
begin
  Result.MajorDiam := MajorDiam;
  Result.PitchDiam := PitchDiam;
  Result.MinorDiam := MinorDiam;
  Result.Pitch := Pitch;
  Result.SizeToStr := SizeToStr;
  Result.DesignationR := DesignationR;
  Result.DesignationL := DesignationL;
  Result.ThreadAngle := Arctan(Pitch / Pi / PitchDiam);
end;

function ScrewTr(const MajorDiam, Pitch: Double): TScrew;
var
  ASizeToStr: string;
begin
  ASizeToStr := FloatToStr(ToMm(MajorDiam)) + 'x' + FloatToStr(ToMm(Pitch));
  Result := CreateScrew(MajorDiam, MajorDiam - Pitch / 2, MajorDiam -
    Pitch, Pitch, ASizeToStr, 'Tr' + ASizeToStr, 'Tr' + ASizeToStr + 'LH');
end;

function CreateNut(const DesignationR, DesignationL: string;
  const SectionSize, Length: Double): TNut;
begin
  Result.DesignationR := DesignationR;
  Result.DesignationL := DesignationL;
  Result.SectionSize := SectionSize;
  Result.Length := Length;
end;

function RoundNut(const DesignationR, DesignationL: string;
  const SectionSize, Length: Double): TNut;
begin
  Result := CreateNut(DesignationR, DesignationL, SectionSize, Length);
  Result.IsSquare := False;
end;

function SquareNut(const DesignationR, DesignationL: string;
  const SectionSize, Length: Double): TNut;
begin
  Result := CreateNut(DesignationR, DesignationL, SectionSize, Length);
  Result.IsSquare := True;
end;

function SelfMadeNut(const MajorScrewDiam: Double): TNut;
const
  RoundBase = 0.01;  // 10 mm
var
  RodFactor: Double;
begin
  if MajorScrewDiam <= Mm(42) then
    RodFactor := 2
  else if MajorScrewDiam <= Mm(52) then
    RodFactor := 1.8
  else if MajorScrewDiam <= Mm(62) then
    RodFactor := 1.67
  else if MajorScrewDiam <= Mm(72) then
    RodFactor := 1.57
  else
    RodFactor := 1.5;
  Result := RoundNut('', '', RoundMultiple(MajorScrewDiam * RodFactor, RoundBase),
    RoundMultiple(MajorScrewDiam * 2, RoundBase));
end;

function GetNut(const StdScrew: TBuyableScrewSet; const IsScrewPullout: Boolean): TNut;
begin
  if IsScrewPullout then
    Result := StdScrew.NutForPullout
  else
    Result := StdScrew.NutForFixed;
end;

function NutDesgination(const Nut: TNut; const IsRightHanded: Boolean;
  const Lang: TLang): string;
begin
  if IsRightHanded then
    Result := Nut.DesignationR + L10n[78, Lang]
  else
    Result := Nut.DesignationL + L10n[79, Lang];
end;

initialization
  StdScrews[0].Screw := ScrewTr(Mm(30), Mm(6));
  StdScrews[0].NutForPullout := RoundNut('HBD 30 A R', 'HBD 30 A L', Mm(60), Mm(60));
  StdScrews[0].NutForFixed := SquareNut('Tr30x6', 'Tr30x6LH', Mm(50), Mm(60));

  StdScrews[1].Screw := ScrewTr(Mm(40), Mm(7));
  StdScrews[1].NutForPullout := RoundNut('HBD 40 A R', 'HBD 40 A L', Mm(80), Mm(80));
  StdScrews[1].NutForFixed := SquareNut('Tr40x7', 'Tr40x7LH', Mm(60), Mm(70));

  StdScrews[2].Screw := ScrewTr(Mm(50), Mm(8));
  StdScrews[2].NutForPullout := RoundNut('HBD 50 A R', 'HBD 50 A L', Mm(90), Mm(100));
  StdScrews[2].NutForFixed := SquareNut('Tr50x8', 'Tr50x8LH', Mm(70), Mm(90));

  StdScrews[3].Screw := ScrewTr(Mm(60), Mm(9));
  StdScrews[3].NutForPullout := RoundNut('HBD 60 A R', 'HBD 60 A L', Mm(100), Mm(120));
  StdScrews[3].NutForFixed := StdScrews[3].NutForPullout;

  StdScrews[4].Screw := ScrewTr(Mm(70), Mm(10));
  StdScrews[4].NutForPullout := RoundNut('HBD 70 A R', 'HBD 70 A L', Mm(110), Mm(140));
  StdScrews[4].NutForFixed := StdScrews[4].NutForPullout;

  StdScrews[5].Screw := ScrewTr(Mm(80), Mm(10));
  StdScrews[5].NutForPullout := RoundNut('HBD 80 A R', 'HBD 80 A L', Mm(120), Mm(160));
  StdScrews[5].NutForFixed := StdScrews[5].NutForPullout;

  StdScrews[6].Screw := ScrewTr(Mm(90), Mm(12));
  StdScrews[6].NutForPullout := SelfMadeNut(Mm(90));
  StdScrews[6].NutForFixed := StdScrews[6].NutForPullout;

  StdScrews[7].Screw := ScrewTr(Mm(100), Mm(12));
  StdScrews[7].NutForPullout := SelfMadeNut(Mm(100));
  StdScrews[7].NutForFixed := StdScrews[7].NutForPullout;

  StdScrews[8].Screw := ScrewTr(Mm(110), Mm(12));
  StdScrews[8].NutForPullout := SelfMadeNut(Mm(110));
  StdScrews[8].NutForFixed := StdScrews[8].NutForPullout;

  StdScrews[9].Screw := ScrewTr(Mm(120), Mm(14));
  StdScrews[9].NutForPullout := SelfMadeNut(Mm(120));
  StdScrews[9].NutForFixed := StdScrews[9].NutForPullout;
end.
