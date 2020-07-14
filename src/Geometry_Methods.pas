unit Geometry_Methods;

interface

uses
  Geometry_Types;

  function Sqrt(const lVar: TReal): TReal;
  function Pow(const lBase: TReal; lExp: Integer): TReal;

  function Floor(const lVal: TReal): TReal;
  function Clamp(const lVal: TReal; const lMin: TReal; const lMax: TReal): TReal;

  function Dot(const lLeft, lRight: TVec3): TReal;
  function Mag(const lVector: TVec3): TReal;
  function Norm(const lVector: TVec3): TVec3;
  function Cross(const lLeft, lRight: TVec3): TVec3;

  function Scale(const lValue: TReal; const lColor: TColor): TColor;

implementation


function Sqrt(const lVar: TReal): TReal;
var
  lCurr: TReal;
  lPrev: TReal;

begin
  lCurr := lVar;
  lPrev := 0.0;

  while (lCurr <> lPrev) do
  begin
    lPrev := lCurr;
    lCurr := 0.5 * (lCurr + lVar / lCurr);
  end;

  Result := lCurr;
end;

function Pow(const lBase: TReal; lExp: Integer): TReal;
var
  lVal: TReal;

begin
  lVal := 1.0;
  while (lExp > 0) do
  begin
    lVal := lVal * lBase;
    Dec(lExp);
  end;
  Result := lVal;
end;

function Floor(const lVal: TReal): TReal;
begin
  if (lVal >= 0.0) then
  begin
    Exit(lVal);
  end;

  Result := lVal - 1;
end;

function Clamp(const lVal: TReal; const lMin: TReal; const lMax: TReal): TReal;
begin
  if (lVal < lMin) then
  begin
    Exit(lMin);
  end;

  if (lVal > lMax) then
  begin
    Exit(lMax);
  end;

  Exit(lVal);
end;

function Dot(const lLeft, lRight: TVec3): TReal;
begin
  Result := lLeft.X * lRight.X + lLeft.Y * lRight.Y + lLeft.Z * lRight.Z;
end;

function Mag(const lVector: TVec3): TReal;
begin
  Result := Sqrt(Dot(lVector, lVector));
end;

function Norm(const lVector: TVec3): TVec3;
begin
  Result := (1.0 / Mag(lVector)) * lVector;
end;

function Cross(const lLeft, lRight: TVec3): TVec3;
begin
  Result := TVec3.Create(
    lLeft.Y * lRight.Z - lLeft.Z * lRight.Y,
    lLeft.Z * lRight.X - lLeft.X * lRight.Z,
    lLeft.X * lRight.Y - lLeft.Y * lRight.X
  );
end;

function Scale(const lValue: TReal; const lColor: TColor): TColor;
begin
  Result := TColor.Create(lValue * lColor.R, lValue * lColor.G, lValue * lColor.B);
end;

end.
