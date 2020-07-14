unit Geometry_Types;

interface

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
    fPos: TVec3;
    fForward: TVec3;

  public
    constructor Create(const lPos, lForward: TVec3);

    property Pos: TVec3 read fPos;
    property Forward: TVec3 read fForward;
  end;

  TLigth = record
  strict private
    fPos: TVec3;
    fCol: TVec3;

  public
    constructor Create(const lPos, lCol: TVec3);

    property Pos: TVec3 read fPos;
    property Col: TVec3 read fCol;
  end;

  TSurface = record
  type
    TDiffuseFunc = reference to function(const lVector: TVec3): TColor;
    TSpecularFunc = reference to function(const lVector: TVec3): TColor;
    TReflectDiffuseFunc = reference to function(const lVector: TVec3): TReal;

  strict private
    fDiffuse: TDiffuseFunc;
    fSpecular: TSpecularFunc;
    fReflect: TReflectDiffuseFunc;
    fRoughness: Integer;

  public
    constructor Create(const lDiffuse: TDiffuseFunc; const lSpecular: TSpecularFunc;
                       const lReflect: TReflectDiffuseFunc; const lRoughness: Integer);

    property Diffuse: TDiffuseFunc read fDiffuse;
    property Specular: TSpecularFunc read fSpecular;
    property Reflect: TReflectDiffuseFunc read fReflect;
    property Roughness: Integer read fRoughness;
  end;

implementation

uses
  Geometry_Methods;

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

constructor TRay.Create(const lPos, lForward: TVec3);
begin
  fPos := lPos;
  fForward := lForward;
end;

{ TLigth }

constructor TLigth.Create(const lPos, lCol: TVec3);
begin
  fPos := lPos;
  fCol := lCol;
end;

constructor TSurface.Create(const lDiffuse: TDiffuseFunc; const lSpecular: TSpecularFunc;
                   const lReflect: TReflectDiffuseFunc; const lRoughness: Integer);
begin
  fDiffuse := lDiffuse;
  fSpecular := lSpecular;
  fReflect := lReflect;
  fRoughness := lRoughness;
end;

end.
