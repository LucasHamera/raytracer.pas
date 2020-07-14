unit Geometry.Types;

interface

uses
  Utils.Types,
  System.Generics.Collections;

const
  MaxTReal = 340282346638528859811704183484516925440.0;

type
  TReal = Single;

  TVec3 = record
  strict private
    fX: TReal;
    fY: TReal;
    fZ: TReal;

  public
    property X: TReal read fX;
    property Y: TReal read fY;
    property Z: TReal read fZ;

    constructor Create(const lX, lY, lZ: TReal);

    class operator Add(const lLeft, lRight: TVec3): TVec3;
    class operator Subtract(const lLeft, lRight: TVec3): TVec3;
    class operator Multiply(const lValue: TReal; lRight: TVec3): TVec3;
  end;

  TColor = record
  strict private
    fR: TReal;
    fG: TReal;
    fB: TReal;

  public
    constructor Create(const lR, lG, lB: TReal);

    property R: TReal read fR;
    property G: TReal read fG;
    property B: TReal read fB;

    class operator Add(const lLeft, lRight: TColor): TColor;
    class operator Subtract(const lLeft, lRight: TColor): TColor;
    class operator Multiply(const lLeft, lRight: TColor): TColor;

    class function White(): TColor; static;
    class function Grey(): TColor; static;
    class function Black(): TColor; static;
    class function Background(): TColor; static;
    class function DefaultColor(): TColor; static;
  end;

  TCamera = record
  strict private
    fPos: TVec3;
    fForward: TVec3;
    fRight: TVec3;
    fUp: TVec3;

  public
    constructor Create(const lPos, lLookAt: TVec3);

    property Pos: TVec3 read fPos;
    property Forward: TVec3 read fForward;
    property Right: TVec3 read fRight;
    property Up: TVec3 read fUp;
  end;

  TRay = record
  strict private
    fStart: TVec3;
    fDir: TVec3;

  public
    constructor Create(const lStart, lDir: TVec3);

    property Start: TVec3 read fStart;
    property Dir: TVec3 read fDir;
  end;

  TLigth = record
  strict private
    fPos: TVec3;
    fCol: TColor;

  public
    constructor Create(const lPos: TVec3; const lCol: TColor);

    property Pos: TVec3 read fPos;
    property Col: TColor read fCol;
  end;

  ISurface = interface
  ['{5C7CD2DD-33D2-4DA6-9CBC-9CF9A2B78EBC}']
    function Diffuse(const lPos: TVec3): TColor;
    function Specular(const lPos: TVec3): TColor;
    function Reflect(const lPos: TVec3): TReal;
    function Roughness(): Integer;
  end;

  TShiny = class(TInterfacedObject, ISurface)
  public
    function Diffuse(const lPos: TVec3): TColor;
    function Specular(const lPos: TVec3): TColor;
    function Reflect(const lPos: TVec3): TReal;
    function Roughness(): Integer;
  end;

  TCheckerboard = class(TInterfacedObject, ISurface)
  public
    function Diffuse(const lPos: TVec3): TColor;
    function Specular(const lPos: TVec3): TColor;
    function Reflect(const lPos: TVec3): TReal;
    function Roughness(): Integer;
  end;

  TThing = class;

  IScene = interface
    ['{C74F236D-2B79-4B1A-B452-9F9AF90EB997}']
    function GetThings(): TList<TThing>;
    function GetLights(): TList<TLigth>;
    function GetCamera(): TCamera;
  end;

  IHitable = interface
    ['{2FBFBFC3-FA85-4160-8CB6-673E7A20283D}']

  end;

  TIntersection = record
  strict private
    fThing: TThing;
    fRay: TRay;
    fDist: TReal;

  public
    constructor Create(const lThing: TThing; const lRay: TRay; const lDist: TReal);

    property Thing: TThing read fThing;
    property Ray: TRay read fRay;
    property Dist: TReal read fDist;
  end;

  TThing = class abstract
    function Intersect(const lRay: TRay) : TOptional<TIntersection>; virtual; abstract;
    function Normal(const lPos: TVec3): TVec3; virtual; abstract;
    function Surface(): ISurface; virtual; abstract;
  end;

  TArrayOfByte = array of Byte;

  TDynamicCanvas = class
  strict private
    fWidth: Integer;
    fHeight: Integer;
    fBuffer: TArrayOfByte;

  public
    constructor Create(const lWidth: Integer;const lHeight: Integer);

    procedure SetPixel(const lX, lY: Integer; const lColor: TColor);
    function GetPixels(): TArrayOfByte;

    property Width: Integer read fWidth;
    property Height: Integer read fHeight;
  end;

  TPlane = class(TThing)
  strict private
    fNorm: TVec3;
    fOffset: TReal;
    fSurface: ISurface;

  public
    constructor Create(const lNorm: TVec3; lOffset: TReal; lSurface: ISurface);

    function Intersect(const lRay: TRay): TOptional<TIntersection>; override;
    function Normal(const lPos: TVec3): TVec3;  override;
    function Surface(): ISurface;  override;
  end;

  TSphere = class(TThing)
  strict private
    fCentre: TVec3;
    fRadius: TReal;
    fSurface: ISurface;

  public
    constructor Create(const lCentre: TVec3; lRadius: TReal; lSurface: ISurface);

    function Intersect(const lRay: TRay): TOptional<TIntersection>; override;
    function Normal(const lPos: TVec3): TVec3;  override;
    function Surface(): ISurface;  override;
  end;

implementation

uses
  Geometry.Methods;

{ TVec3 }

constructor TVec3.Create(const lX, lY, lZ: TReal);
begin
  fX := lX;
  fY := lY;
  fZ := lZ;
end;

class operator TVec3.Add(const lLeft, lRight: TVec3): TVec3;
begin
  Result := TVec3.Create(lLeft.X + lRight.X, lLeft.Y + lRight.Y, lLeft.Z + lRight.Z);
end;

class operator TVec3.Subtract(const lLeft, lRight: TVec3): TVec3;
begin
  Result := TVec3.Create(lLeft.X - lRight.X, lLeft.Y - lRight.Y, lLeft.Z - lRight.Z);
end;

class operator TVec3.Multiply(const lValue: TReal; lRight: TVec3): TVec3;
begin
  Result := TVec3.Create(lValue * lRight.X, lValue * lRight.Y, lValue * lRight.Z);
end;

{ TColor }

constructor TColor.Create(const lR, lG, lB: TReal);
begin
  fR := lR;
  fG := lG;
  fB := lB;
end;

class operator TColor.Add(const lLeft, lRight: TColor): TColor;
begin
  Result := TColor.Create(lLeft.R + lRight.R, lLeft.G + lRight.G, lLeft.B + lRight.B);
end;

class operator TColor.Subtract(const lLeft, lRight: TColor): TColor;
begin
  Result := TColor.Create(lLeft.R - lRight.R, lLeft.G - lRight.G, lLeft.B - lRight.B);
end;

class operator TColor.Multiply(const lLeft, lRight: TColor): TColor;
begin
  Result := TColor.Create(lLeft.R * lRight.R, lLeft.G * lRight.G, lLeft.B * lRight.B);
end;

class function TColor.White(): TColor;
begin
  Result := TColor.Create(1.0, 1.0, 1.0);
end;
class function TColor.Grey(): TColor;
begin
  Result := TColor.Create(0.5, 0.5, 0.5);
end;

class function TColor.Black(): TColor;
begin
  Result := TColor.Create(0, 0, 0);
end;

class function TColor.Background(): TColor;
begin
  Result := Result.Black;
end;

class function TColor.DefaultColor(): TColor;
begin
  Result := Result.Black;
end;

{ TColor }

constructor TCamera.Create(const lPos, lLookAt: TVec3);
begin
  fPos := lPos;
  fForward := Norm(lLookAt - lPos);
  fRight := 1.5 * Norm(Cross(fForward, TVec3.Create(0.0, -1.0, 0.0)));
  fUp := 1.5 * Norm(Cross(fForward, fRight));
end;

{ TRay }

constructor TRay.Create(const lStart, lDir: TVec3);
begin
  fStart := lStart;
  fDir := lDir;
end;

{ TLigth }

constructor TLigth.Create(const lPos: TVec3; const lCol: TColor);
begin
  fPos := lPos;
  fCol := lCol;
end;

{ TShiny }

function TShiny.Diffuse(const lPos: TVec3): TColor;
begin
  Result := TColor.White;
end;

function TShiny.Specular(const lPos: TVec3): TColor;
begin
  Result := TColor.Grey;
end;

function TShiny.Reflect(const lPos: TVec3): TReal;
begin
  Result := 0.7;
end;

function TShiny.Roughness(): Integer;
begin
  Result := 250;
end;

{ TCheckerboard }

function TCheckerboard.Diffuse(const lPos: TVec3): TColor;
begin
  if ((Round(Floor(lPos.Z) + Floor(lPos.X)) mod 2) <> 0) then
  begin
    Exit(TColor.White);
  end;
  Exit(TColor.Black);
end;

function TCheckerboard.Specular(const lPos: TVec3): TColor;
begin
  Result := TColor.White;
end;

function TCheckerboard.Reflect(const lPos: TVec3): TReal;
begin
  if ((Round(Floor(lPos.Z) + Floor(lPos.X)) mod 2) <> 0) then
  begin
    Exit(0.1);
  end;
  Exit(0.7);
end;

function TCheckerboard.Roughness(): Integer;
begin
  Result := 150;
end;

{ TIntersection }

constructor TIntersection.Create(const lThing: TThing; const lRay: TRay; const lDist: TReal);
begin
  fThing := lThing;
  fRay := lRay;
  fDist := lDist;
end;

{ TDynamicCanvas }

constructor TDynamicCanvas.Create(const lWidth: Integer;const lHeight: Integer);
begin
  fWidth := lWidth;
  fHeight := lHeight;
  SetLength(fBuffer, 3 * lWidth * lHeight);
end;

procedure TDynamicCanvas.SetPixel(const lX, lY: Integer; const lColor: TColor);
begin
  fBuffer[(lY * fWidth + lX) * 3 + 0] := Round(Clamp(lColor.R, 0.0, 1.0) * 255.0);
  fBuffer[(lY * fWidth + lX) * 3 + 1] := Round(Clamp(lColor.G, 0.0, 1.0) * 255.0);
  fBuffer[(lY * fWidth + lX) * 3 + 2] := Round(Clamp(lColor.B, 0.0, 1.0) * 255.0);
end;

function TDynamicCanvas.GetPixels(): TArrayOfByte;
begin
  Result := fBuffer;
end;

{ TPlane }

constructor TPlane.Create(const lNorm: TVec3; lOffset: TReal; lSurface: ISurface);
begin
  fNorm := lNorm;
  fOffset := lOffset;
  fSurface := lSurface;
end;

function TPlane.Intersect(const lRay: TRay): TOptional<TIntersection>;
var
  lDenom: TReal;
  lDist: TReal;

begin
  Result.Clear();
  lDenom := Dot(fNorm, lRay.Dir);
  if (lDenom > 0.0) then
  begin
    Exit;
  end;

  lDist := (Dot(fNorm, lRay.Start) + fOffset) / (-lDenom);
  Result := TOptional<TIntersection>.Create(
    TIntersection.Create(Self, lRay, lDist)
  );
end;

function TPlane.Normal(const lPos: TVec3): TVec3;
begin
  Result := fNorm;
end;

function TPlane.Surface(): ISurface;
begin
  Result := fSurface;
end;

{ TPlane }

constructor TSphere.Create(const lCentre: TVec3; lRadius: TReal; lSurface: ISurface);
begin
  fCentre := lCentre;
  fRadius := lRadius;
  fSurface := lSurface;
end;

function TSphere.Intersect(const lRay: TRay): TOptional<TIntersection>;
var
  lEo: TVec3;
  lV: TReal;
  lDist,
  lDisc: TReal;

begin
  Result.Clear();
  lEo := fCentre - lRay.Start;
  lV := Dot(lEo, lRay.Dir);
  lDist := 0.0;

  if (lV >= 0.0) then
  begin
    lDisc := fRadius - (Dot(lEo, lEo) - lV * lV);
    if (lDisc >= 0.0) then
    begin
      lDist := lV - Sqrt(lDisc);
    end;
  end;

  if (lDist <> 0) then
  begin
    Result := TOptional<TIntersection>.Create(
      TIntersection.Create(Self, lRay, lDist)
    );
  end;
end;

function TSphere.Normal(const lPos: TVec3): TVec3;
begin
  Result := Norm(lPos - fCentre);
end;

function TSphere.Surface(): ISurface;
begin
  Result := fSurface;
end;

end.
