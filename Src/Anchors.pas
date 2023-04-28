unit Anchors;

{$MODE OBJFPC}
{$LONGSTRINGS ON}
{$ASSERTIONS ON}
{$RANGECHECKS ON}
{$BOOLEVAL OFF}

interface

type
  TAnchor = record
    Diameter: ValReal;
    RecomendTensionLoad: ValReal;
    RecomendShearLoad: ValReal;
  end;

var
  Mungo: array [0..1] of TAnchor;

implementation

uses
  Measurements;

initialization
  Mungo[0].Diameter := Mm(12);
  Mungo[0].RecomendTensionLoad := kN(11.91);
  Mungo[0].RecomendShearLoad := kN(16.11);

  Mungo[1].Diameter := Mm(16);
  Mungo[1].RecomendTensionLoad := kN(14.29);
  Mungo[1].RecomendShearLoad := kN(30.08);
end.

