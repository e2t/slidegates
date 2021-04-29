unit MassWedge;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

uses MassGeneral, StrengthCalculations;

procedure CalcMassWedged(out SgMass: Double; var SheetWeights: TSheetWeights;
  const Slg: TSlidegate);

implementation

uses MathUtils, Screws, Measurements, Math;

type
  TWedgedDesign = record
    GateSheet: TSheetMetal;
    GateShelf, GateDepth, GateWidth: Double;

    EdgeSheet: TSheetMetal;
    EdgeDepth, HorizEdgeWidth: Double;
    HorizEdgesCount, VertEdgesCount: Integer;

    CoverShelf, CoverDepth: Double;

    FrameSheet: TSheetMetal;
    FrameShelf, FrameDepth: Double;
    ClosedFrameEdgeHeight: Double;

    BigPipeLength, BigPipeDiam: Double;
  end;

const
  TopBalkShelf = 0.05;  // 50 mm
  WallFlangeS = 0.008;  // 8 mm
  PipeFlangeS = 0.02;  // 20 mm

function CalcGateSheet(const Slg: TSlidegate): TSheetMetal;
var
  MaxSizeFor3mm: Double;
begin
  if Slg.HydrHead < 3 then
    MaxSizeFor3mm := Metre(1)
  else
    MaxSizeFor3mm := Metre(0.8);
  if (Slg.FrameWidth <= MaxSizeFor3mm) and (Slg.GateHeight <= MaxSizeFor3mm) then
    Result := StdSheet[1]   // 3 mm
  else if (Slg.FrameWidth <= 1.6) and (Slg.GateHeight <= 1.6) then
    Result := StdSheet[2]   // 4 mm
  else if (Slg.FrameWidth <= 2.5) and (Slg.GateHeight <= 2.5) then
    Result := StdSheet[3]   // 5 mm
  else
    Result := StdSheet[4];  // 6 mm
end;

function FrameSheet(const Slg: TSlidegate; const GateSheet: TSheetMetal): TSheetMetal;
begin
  if (Slg.FrameWidth <= 1.25) and (Slg.GateHeight <= 1.25) and
    (Slg.FrameHeight <= 3.0) then
    Result := StdSheet[2]   // 4 mm
  else if (Slg.FrameWidth <= 2.5) and (Slg.GateHeight <= 2.5) and
    (Slg.FrameHeight <= 6.0) then
    Result := StdSheet[3]   // 5 mm
  else
    Result := StdSheet[4];  // 6 mm
  if Result.S < GateSheet.S then
    Result := GateSheet;
end;

function EdgeSheet(const Slg: TSlidegate; const GateSheet: TSheetMetal): TSheetMetal;
var
  I: Integer;
begin
  if (Slg.HydrHead >= 8) then
  begin
    I := 0;
    while (I < High(StdSheet) - 1) and (StdSheet[I].S <> GateSheet.S) do
      Inc(I);
    Result := StdSheet[I + 1];
  end
  else
    Result := GateSheet;
end;

function GateWidth(const Slg: TSlidegate; const FrameSheet: TSheetMetal): Double;
const
  GapByOneSide = 0.01;  // 10 мм = ограничитель 8 мм + зазор 2 мм
begin
  Result := Slg.FrameWidth - 2 * (FrameSheet.S + GapByOneSide);
end;

function CalcHorizEdgeWidth(const GateSheet: TSheetMetal;
  const GateWidth: Double): Double;
const
  GapByOneSide = 0.001;  // 1 мм
begin
  Result := GateWidth - 2 * (GateSheet.S + GapByOneSide);
end;

function HorizEdgeArea(const Des: TWedgedDesign): Double;
var
  HemV, HemH: Double;
begin
  HemV := Des.GateDepth - 2 * Des.GateSheet.S - 0.001;  // 1 mm gap
  HemH := Des.GateShelf - Des.GateSheet.S;
  Result := (Des.HorizEdgeWidth - 2 * HemH - Des.EdgeDepth + HemV) *
    (Des.EdgeDepth - HemV) + HemV * Des.HorizEdgeWidth - Des.CoverShelf * Des.CoverDepth;
end;

function CalcEdgeHeight(const Slg: TSlidegate; const GateSheet: TSheetMetal;
  const CoverShelf: Double): Double;
const
  K2 = 0.002;  // 2 mm on every meter of hydr. head above gate
  RoundBase = 0.005;  // 5 mm
begin
  Result := CeilMultiple(CoverShelf + 0.015   // 15 mm above cover
    + K2 * (Slg.HydrHead - Slg.GateHeight) + GateSheet.S, RoundBase) - GateSheet.S;
end;

function HorizEdgesCount(const Slg: TSlidegate): Integer;
begin
  case Slg.SlgKind of
    Surf:
      Result := 1 + RoundMath(Slg.GateHeight / 0.32);
    Deep:
      Result := 1 + RoundMath(Slg.GateHeight / 0.25);
    else
      Assert(False, 'Неправильный тип затвора');
      // только для клиновых затворов
  end;
end;

function VertEdgeArea(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
begin
  Result := Slg.GateHeight * Des.EdgeDepth;
end;

function CalcClosedFrameEdgeHeight(const Slg: TSlidegate;
  const BigPipeDiam: Double): Double;
begin
  Result := Slg.FrameHeight - BigPipeDiam - 0.1;  // 100 mm from bellow to bigpipe
end;

function FrameHorizEdgeCount(const Slg: TSlidegate; const Des: TWedgedDesign): Integer;
begin
  if Slg.IsFrameClosed then
    Result := RoundMath(Des.ClosedFrameEdgeHeight / 0.3)
  else
    Result := 0;
end;

function FrameVertEdgeCount(const Slg: TSlidegate): Integer;
begin
  // 1 edge on every 0.5 meter
  if Slg.IsFrameClosed then
    Result := RoundMath((Slg.FrameWidth - 0.5) / 0.5)
  else
    Result := 0;
end;

function VertEdgesCount(const Slg: TSlidegate; const GateWidth: Double): Integer;
var
  K: Integer;
begin
  if Slg.IsScrewPullout then
    K := 2
  else
    K := 1;
  case Slg.SlgKind of
    Surf:
      Result := K * RoundMath(GateWidth / 2.5);
    Deep:
      Result := K * RoundMath(GateWidth);
    else
      Assert(False, 'Неправильный тип затвора');
      // только для клиновых затворов
  end;
end;

procedure CalcWedgedDesign(out Des: TWedgedDesign; const Slg: TSlideGate);
var
  MinGateDepth, CoverShelf1, CoverShelf2: Double;
const
  // 11 мм - Расстояние от стенки щита до рамы (в зоне уплотнения)
  DistCompress = 0.011;
  // 3.5 mm - on every meter hydr. head above gate
  K1 = 0.0035;
  // 9 mm - minimal difference between size of gate's shelf and size of gate's depth
  MinDiff = 0.009;
  // 10 мм - Side distance between gate and frame including limiter = 2 + 8
  DistLimiter = 0.010;
  // 15 mm - толщина клина
  WedgeWidth = 0.015;
  // 9 мм - зазор между клиньями
  WedgesGap = 0.009;
  // 45 мм - пространство от щита до рамы в зоне клиньев
  DistBtwWedges = 0.045;
  // Distance between centre of frame and ax of nut = 10 - 9
  DiffCentres = 0.001;
  // Inside distance between nut and cover of gate
  DiffSide = 0.001;
begin
  Des := Default(TWedgedDesign);

  Des.GateSheet := CalcGateSheet(Slg);
  Des.EdgeSheet := EdgeSheet(Slg, Des.GateSheet);
  Des.FrameSheet := FrameSheet(Slg, Des.GateSheet);
  Des.EdgeSheet := Des.GateSheet;
  Des.GateShelf := CeilMultiple(Des.GateSheet.S + Des.GateSheet.R +
    WedgeWidth * Slg.WedgePairsCount + WedgesGap * (Slg.WedgePairsCount - 1), Mm(2));

  MinGateDepth := CeilMultiple(Des.GateShelf + MinDiff + K1 *
    (Slg.HydrHead - Slg.GateHeight), Mm(1));
  Des.FrameDepth := CeilMultiple(MinGateDepth + DistCompress +
    DistBtwWedges + Des.FrameSheet.S * 2, Mm(5));

  Des.GateDepth := Des.FrameDepth - Des.FrameSheet.S * 2 - DistBtwWedges -
    DistCompress;
  Des.FrameShelf := CeilMultiple(Des.FrameSheet.S + DistLimiter +
    Des.GateShelf, Mm(5));

  CoverShelf1 := Des.FrameDepth / 2 - Des.FrameSheet.S - DistCompress -
    Des.GateSheet.S;
  if Slg.InstallKind = TwoFlange then
    CoverShelf1 := CoverShelf1 - Mm(9);
  CoverShelf2 := DiffCentres + Slg.Nut.SectionSize / 2 + DiffSide + Des.GateSheet.S;
  Des.CoverShelf := CeilMultiple(CoverShelf1 + CoverShelf2, Mm(1));

  Des.CoverDepth := Slg.Nut.SectionSize + 2 * (DiffSide + Des.GateSheet.S);
  Des.GateWidth := GateWidth(Slg, Des.FrameSheet);
  Des.EdgeDepth := CalcEdgeHeight(Slg, Des.GateSheet, Des.CoverShelf);
  Des.HorizEdgeWidth := CalcHorizEdgeWidth(Des.GateSheet, Des.GateWidth);
  Des.HorizEdgesCount := HorizEdgesCount(Slg);
  Des.VertEdgesCount := VertEdgesCount(Slg, Des.GateWidth);

  case Slg.InstallKind of
    Flange, TwoFlange:
    begin
      Des.BigPipeLength := 0.3;
      Des.BigPipeDiam := Slg.FrameWidth - 0.24;
    end
    else
    begin
      Des.BigPipeLength := 0;
      Des.BigPipeDiam := 0;
    end
  end;
  Des.ClosedFrameEdgeHeight := CalcClosedFrameEdgeHeight(Slg, Des.BigPipeDiam);
end;

// only 90 degrees
function SheetRadiusArea(const Sheet: TSheetMetal): Double;
begin
  Result := RingSectorArea((Sheet.S + Sheet.R) * 2, Sheet.R * 2, Pi / 2);
end;

function SheetMetalArea(const Sheet: TSheetMetal; const Sides: array of Double): Double;
var
  FlatLength: Double;
  SidesCount, I: Integer;
begin
  SidesCount := High(Sides) + 1;
  FlatLength := Sides[0];
  for I := 1 to SidesCount - 1 do
    FlatLength := FlatLength + Sides[I] - 2 * (Sheet.S + Sheet.R);
  Result := FlatLength * Sheet.S + (SidesCount - 1) * SheetRadiusArea(Sheet);
end;

// TODO: адаптировать для глубинных. Сейчас годится только для поверхностных.
function CalcBracketsMass(const Slg: TSlidegate): Double;
const
  BracketMass = 0.32;
begin
  if Slg.GateHeight >= 1.0 then
    Result := BracketMass * 16
  else
    Result := BracketMass * 12;
end;

// The crossbar for the top sealing in the deep slidegates.
function Bar4DeepMass(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
const
  Gap = 0.01;  // indent 10 mm at both sides
  Height = 0.135;  // 135 mm height of channel
var
  Shelf: Double;
begin
  if Slg.SlgKind = Deep then
  begin
    // 50 mm ledge, 8 mm thickness of flange
    Shelf := 0.05 - 0.008 + Des.FrameSheet.S;
    Result := (SheetMetalArea(Des.FrameSheet, [Shelf, Height, Shelf + 0.004]) *
      (Slg.FrameWidth - 2 * Gap) - 2 * (Height - 2 * Des.FrameSheet.S) *
      (Des.FrameShelf - Gap) * Des.FrameSheet.S) * SteelDensity;
  end
  else
    Result := 0;
end;

function MassHorizChannelWithPlast(const Slg: TSlidegate;
  const Des: TWedgedDesign): Double;
begin
  // at 20 mm narrower of the frame, at 1 mm less of the channel (gap)
  Result := SheetMetalArea(Des.FrameSheet, [TopBalkShelf, Des.FrameDepth -
    2 * Des.FrameSheet.S - 0.001, TopBalkShelf]) * (Slg.FrameWidth - 0.02) *
    SteelDensity;
end;

function MassMiddleScrewSupport(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
begin
  if Slg.HaveFrameNodes then
    Result := MassHorizChannelWithPlast(Slg, Des)
  else
    Result := 0;
end;

function MassHorizChannelWoPlastic(const Slg: TSlidegate;
  const Des: TWedgedDesign): Double;
begin
  // at 20 mm narrower of the frame, at 20 mm below of the channel
  Result := SheetMetalArea(Des.FrameSheet, [TopBalkShelf, Des.FrameDepth -
    0.02, TopBalkShelf]) * (Slg.FrameWidth - 0.02) * SteelDensity;
end;

// The crossbar in the very high frames.
function MassCrossbar(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
var
  Height: Double;
begin
  if Slg.HaveFrameNodes then
    Height := 2 * Slg.GateHeight
  else if Slg.SlgKind = Deep then
    Height := Slg.GateHeight
  else
    Height := 0;
  Result := MassHorizChannelWoPlastic(Slg, Des) * Floor((Slg.FrameHeight - Height) / 3);
end;

// square flanges s8, 100 mm from below, 140 mm from above
function MassWallFlange(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
begin
  Result := (Slg.FrameWidth * (0.1 + 0.14) + (Slg.GateHeight - 0.1 - 0.14) *
    2 * Des.FrameShelf) * WallFlangeS * SteelDensity;
end;

// round flanges s20, difference of the diameters 200 mm
function MassPipeFlange(const Des: TWedgedDesign): Double;
begin
  Result := (RingSectorArea(Des.BigPipeDiam + 0.2, Des.BigPipeDiam, 2 * Pi) *
    PipeFlangeS) * SteelDensity;
end;

// Масса пары вертикальных ребер закрытой рамы (с обеих сторон).
function MassFrameVertEdge(const Des: TWedgedDesign): Double;
var
  H: Double;
begin
  H := TopBalkShelf * 2;
  Result := H * Des.ClosedFrameEdgeHeight * Des.FrameSheet.S * SteelDensity;
end;

// Масса кольцевого горизонтального ребра закрытой рамы (со всех сторон).
function MassFrameHorizEdge(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
var
  H: Double;
begin
  H := TopBalkShelf * 2;
  Result := ((Slg.FrameWidth + H) * (Des.FrameDepth + H) - Slg.FrameWidth *
    Des.FrameDepth) * Des.FrameSheet.S * SteelDensity;
end;

function MassCap(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
begin
  // 50 mm of the top balk
  if Slg.IsFrameClosed then
    Result := (Slg.FrameWidth + 0.1) * (Des.FrameDepth + 0.1) *
      Des.FrameSheet.S * SteelDensity
  else
    Result := 0;
end;

function MassSegment(const Slg: TSlidegate; const Des: TWedgedDesign;
  const Height: Double): Double;
begin
  Result := ((Height + Des.BigPipeDiam / 2) * (Slg.FrameWidth - 2 * Des.FrameShelf) -
    CircleSectorArea(Des.BigPipeDiam, Pi)) * Des.FrameSheet.S * SteelDensity;
end;

function MassTopSegment(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
var
  Height: Double;
begin
  if Slg.IsFrameClosed then
    Height := Slg.FrameHeight - 0.1 - Des.BigPipeDiam
  else
    Height := 0.1;
  Result := MassSegment(Slg, Des, Height);
end;

function MassBottomSegment(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
const
  Height = 0.1;  // 100 mm from below to bigpipe
begin
  Result := MassSegment(Slg, Des, Height);
end;

function MassBigPipe(const Des: TWedgedDesign): Double;
begin
  Result := CalcPipeMass(Des.BigPipeDiam, Des.FrameSheet.S, Des.BigPipeLength);
end;

function MassTopChannel(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
begin
  // at 20 mm narrower of the frame, at 20 mm below of the channel
  if Slg.IsScrewPullout then
    Result := MassHorizChannelWithPlast(Slg, Des)
  else
    Result := MassHorizChannelWoPlastic(Slg, Des);
end;

// The bottom support-corner.
function MassSmallBottom(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
begin
  Result := SheetMetalArea(Des.FrameSheet, [0.035, 0.05 - Des.FrameSheet.S]) *
    Slg.FrameWidth * SteelDensity;
end;

function MassBottom(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
const
  SealingHeight = 0.075;  // 75 mm height seal pressing
var
  TopShelf: Double;  // верхняя полка нижней опоры
  DeletedArea: Double;
begin
  // 35 mm top shelf by default, 46+s for the flange to wall,
  // don't exists with bigpipe
  if Des.BigPipeLength > 0 then
    TopShelf := 0
  else
  begin
    if Slg.InstallKind = Wall then
      TopShelf := 0.046 + Des.FrameSheet.S
    else
      TopShelf := 0.035;
  end;
  DeletedArea := SheetMetalArea(Des.FrameSheet, [SealingHeight, TopShelf]);
  // 50 mm bottom shelf, 5 mm indent at channel
  Result := SteelDensity * (SheetMetalArea(Des.FrameSheet,
    [0.05, Des.FrameDepth + 0.005, SealingHeight + Des.FrameSheet.S, TopShelf]) *
    Slg.FrameWidth - DeletedArea * Des.FrameSheet.S);
end;

function MassChannel(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
var
  FlangeShelfArea: Double;
begin
  if Slg.InstallKind = Wall then
    // 46 mm ledge of flange, 150 mm internal height of flange
    FlangeShelfArea := (0.046 + Des.FrameSheet.S) * (Slg.GateHeight - 0.15)
  else
    FlangeShelfArea := 0;
  Result := SteelDensity * (SheetMetalArea(Des.FrameSheet,
    [Des.FrameShelf, Des.FrameDepth, Des.FrameShelf]) * Slg.FrameHeight +
    FlangeShelfArea * Des.FrameSheet.S);
end;

function CalcMassVertEdge(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
begin
  Result := VertEdgeArea(Slg, Des) * Des.EdgeSheet.S * SteelDensity;
end;

function MassCover(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
begin
  Result := Slg.GateHeight * SteelDensity * SheetMetalArea(Des.GateSheet,
    [Des.CoverShelf, Des.CoverDepth, Des.CoverShelf]);
end;

function CalcMassHorizEdge(const Des: TWedgedDesign): Double;
begin
  Result := Des.EdgeSheet.S * SteelDensity * HorizEdgeArea(Des);
end;

function MassWall(const Slg: TSlidegate; const Des: TWedgedDesign): Double;
begin
  Result := SheetMetalArea(Des.GateSheet, [Des.GateShelf, Des.GateDepth,
    Des.GateWidth, Des.GateDepth, Des.GateShelf]) * Slg.GateHeight * SteelDensity;
end;

procedure CalcMassGate(out MassGate: Double; var SheetWeights: TSheetWeights;
  const Slg: TSlidegate; const Des: TWedgedDesign);
var
  EdgesMass, GateWallMass, MassHorizEdge, MassVertEdge, CoverMass: Double;
begin
  GateWallMass := MassWall(Slg, Des);
  MassHorizEdge := CalcMassHorizEdge(Des);
  MassVertEdge := CalcMassVertEdge(Slg, Des);
  EdgesMass := Des.HorizEdgesCount * MassHorizEdge + Des.VertEdgesCount * MassVertEdge;
  CoverMass := MassCover(Slg, Des);
  MassGate := GateWallMass + EdgesMass + CoverMass;

  UpdateSheetWeight(SheetWeights, Des.GateSheet.S, GateWallMass + CoverMass);
  UpdateSheetWeight(SheetWeights, Des.EdgeSheet.S, EdgesMass);
end;

procedure CalcMassFrame(out MassFrame: Double; var SheetWeights: TSheetWeights;
  const Slg: TSlidegate; const Des: TWedgedDesign);
var
  SidesCount: Integer;
  MassFlanges, MainMass: Double;
begin
  if Slg.InstallKind = Wall then
  begin
    MassFlanges := MassWallFlange(Slg, Des);
    UpdateSheetWeight(SheetWeights, WallFlangeS, MassFlanges);
  end
  else if (Slg.InstallKind = Flange) or (Slg.InstallKind = TwoFlange) then
  begin
    if Slg.InstallKind = Flange then
      SidesCount := 1
    else if Slg.InstallKind = TwoFlange then
      SidesCount := 2;
    MassFlanges := MassPipeFlange(Des) * SidesCount;
    if Slg.HaveCounterFlange then
      MassFlanges := MassFlanges * 2;
    UpdateSheetWeight(SheetWeights, PipeFlangeS, MassFlanges);
  end;

  MainMass := MassChannel(Slg, Des) * 2 + MassBottom(Slg, Des) +
    MassTopChannel(Slg, Des) + Bar4DeepMass(Slg, Des) +
    MassMiddleScrewSupport(Slg, Des) + MassCrossbar(Slg, Des) +
    MassSmallBottom(Slg, Des);
  if Des.BigPipeLength > 0 then
    MainMass := MainMass + (MassBigPipe(Des) + MassBottomSegment(Slg, Des) +
      MassTopSegment(Slg, Des)) * SidesCount;
  if Slg.IsFrameClosed then
    MainMass := MainMass + MassCap(Slg, Des) + MassFrameHorizEdge(Slg, Des) *
      FrameHorizEdgeCount(Slg, Des) + MassFrameVertEdge(Des) *
      FrameVertEdgeCount(Slg);
  if Slg.InstallKind = Channel then
    MainMass := MainMass + CalcBracketsMass(Slg);
  UpdateSheetWeight(SheetWeights, Des.FrameSheet.S, MainMass);

  MassFrame := MainMass;
  if (Slg.InstallKind = Wall) or (Slg.InstallKind = Flange) or
    (Slg.InstallKind = TwoFlange) then
    MassFrame := MassFrame + MassFlanges;
end;

function MassScrew(const Slg: TSlidegate): Double;
const
  MassPlate = 3.0;
  BearingHouseMass = 4.0;
  NutHeight = 0.1;
  AboveTheFrame = 0.1;
var
  SectionArea, RodLength: Double;
  BearingHouseCount: Integer;
begin
  SectionArea := CircleSectorArea(Slg.Screw.MajorDiam, 2 * Pi);
  // общая длина винта
  RodLength := Slg.FrameHeight - Slg.GateHeight + NutHeight + AboveTheFrame;
  if Slg.IsScrewPullout then
    BearingHouseCount := 0
  else
  begin
    if Slg.DriveLocation = OnFrame then
      BearingHouseCount := 1
    else
      BearingHouseCount := 2;
  end;
  Result := SectionArea * RodLength * SteelDensity + MassPlate +
    BearingHouseMass * BearingHouseCount;
  //writeln(result);
end;

procedure CalcMassWedged(out SgMass: Double; var SheetWeights: TSheetWeights;
  const Slg: TSlidegate);
var
  Des: TWedgedDesign;
  MassGate, MassFrame: Double;
begin
  CalcWedgedDesign(Des, Slg);
  CalcMassGate(MassGate, SheetWeights, Slg, Des);
  CalcMassFrame(MassFrame, SheetWeights, Slg, Des);
  //writeln(MassGate);
  //writeln(MassFrame);
  //writeln(MassScrew(Slg));
  SgMass := MassGate + MassFrame + MassScrew(Slg);
end;

end.
