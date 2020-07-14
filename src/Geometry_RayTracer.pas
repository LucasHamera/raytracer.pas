unit Geometry_RayTracer;

interface

uses
  Utils_Types,
  Geometry_Types,
  Geometry_Methods;

type
  TRayTracer = class
  strict private
    const MAX_DEPTH = 5;

    function Point(const lWidth, lHeight: Integer; const lX, lY: Integer; const lCamera: TCamera): TVec3;
    function TraceRay(const lRay: TRay; const lScene: IScene; const lDepth: Integer): TColor;
    function Intersections(const lRay: TRay; const lScene: IScene): TOptional<TIntersection>;
    function Shade(const lIntersection: TIntersection; const lScene: IScene; const lDepth: Integer): TColor;

    function NaturalColor(const lThing: TThing; const lPos, lNorm, lRd: TVec3; lScene: IScene): TColor;
    function ReflectionColor(const lThing: TThing; const lPos, lNorm, lRd: TVec3; lScene: IScene; const lDepth: Integer): TColor;

    function AddLight(const lThing: TThing; const lPos, lNormal, lRd: TVec3; const lScene: IScene;
      const lColor: TColor; const lLight: TLigth): TColor;

    function TestRay(const lRay: TRay; const lScene: IScene): TOptional<TReal>;
  public
    procedure Render(const lScene: IScene; const lCanvas: TDynamicCanvas; const lWidth, lHeight: Integer);
  end;

implementation

uses
  System.Generics.Collections;

{ TRayTracer }

procedure TRayTracer.Render(const lScene: IScene; const lCanvas: TDynamicCanvas; const lWidth, lHeight: Integer);
var
  X,
  Y: Integer;
  lPoint: TVec3;
  lRay: TRay;
  lColor: TColor;

begin
  Y := 0;

  while (Y < lHeight)  do
  begin
    X := 0;
    while (X < lWidth) do
    begin
      lPoint := Point(lWidth, lHeight, X, Y, lScene.GetCamera());
      lRay := TRay.Create(lScene.GetCamera().Pos, lPoint);
      lColor := TraceRay(lRay, lScene, 0);
      lCanvas.SetPixel(X, Y, lColor);
      Inc(X);
    end;
    Inc(Y);
  end;
end;

function TRayTracer.Point(const lWidth, lHeight: Integer; const lX, lY: Integer; const lCamera: TCamera): TVec3;
var
  X,
  Y,
  lWidthReal,
  lHeightReal,
  lRecenterX,
  lRecenterY: TReal;

begin
  X := lX;
  Y := lY;
  lWidthReal := lWidth;
  lHeightReal := lHeight;
  lRecenterX := (X - (lWidthReal / 2.0)) / 2.0 / lWidthReal;
  lRecenterY := -(Y - (lHeightReal / 2.0)) / 2.0 / lHeightReal;
  Result := Norm(lCamera.Forward + ((lRecenterX * lCamera.Right) + (lRecenterY * lCamera.Up)));
end;

function TRayTracer.TraceRay(const lRay: TRay; const lScene: IScene; const lDepth: Integer): TColor;
var
  lIsect: TOptional<TIntersection>;

begin
  lIsect := Intersections(lRay, lScene);
  if (lIsect.HasValue) then
  begin
    Exit(Shade(lIsect.Value, lScene, lDepth))
  end;
  Result := TColor.Background;
end;

function TRayTracer.Intersections(const lRay: TRay; const lScene: IScene): TOptional<TIntersection>;
var
  lClosestDist: TReal;
  lThings: TLisT<TThing>;
  lThingIndex: Integer;
  lThing: TThing;
  lInter: TOptional<TIntersection>;

begin
  lClosestDist := MaxTReal;

  lThings := lScene.GetThings;
  for lThingIndex := 0 to lThings.Count - 1 do
  begin
    lThing := lThings.Items[lThingIndex];
    lInter := lThing.Intersect(lRay);
    if ((lInter.HasValue) AND (lInter.Value.Dist < lClosestDist)) then
    begin
      lClosestDist := lInter.Value.Dist;
      Result := lInter;
    end;
  end;
end;

function TRayTracer.Shade(const lIntersection: TIntersection; const lScene: IScene; const lDepth: Integer): TColor;
var
  lRayDir,
  lPos,
  lNormal,
  lReflectDir: TVec3;
  lNaturalColor,
  lReflectedColor: TColor;

begin
  lRayDir := lIntersection.Ray.Dir;
  lPos := (lIntersection.Dist * lRayDir) + lIntersection.Ray.Start;
  lNormal := lIntersection.Thing.Normal(lPos);
  lReflectDir := lRayDir - ( 2 * (Dot(lNormal, lRayDir) * lNormal));
  lNaturalColor := TColor.Background + NaturalColor(lIntersection.Thing, lPos, lNormal, lReflectDir, lScene);

  if (lDepth >= MAX_DEPTH)  then
  begin
    lReflectedColor := TColor.Grey;
  end
  else
  begin
    lReflectedColor := ReflectionColor(lIntersection.Thing, lPos, lNormal, lReflectDir, lScene, lDepth);
  end;

  Result := lNaturalColor + lReflectedColor;
  end;

function TRayTracer.NaturalColor(const lThing: TThing; const lPos, lNorm, lRd: TVec3; lScene: IScene): TColor;
var
  lLigths: TList<TLigth>;
  lLigthIndex: Integer;
  lLigth: TLigth;

begin
  Result := TColor.DefaultColor;
  lLigths := lScene.GetLights();
  for lLigthIndex := 0 to lLigths.Count - 1 do
  begin
    lLigth := lLigths[lLigthIndex];
    Result := AddLight(lThing, lPos, lNorm, lRd, lScene, Result, lLigth);
  end;
end;

function TRayTracer.ReflectionColor(const lThing: TThing; const lPos, lNorm, lRd: TVec3; lScene: IScene;
  const lDepth: Integer): TColor;
var
  lRay: TRay;

begin
  lRay := TRay.Create(lPos, lRd);
  Result := Scale(lThing.Surface.Reflect(lPos), TraceRay(lRay, lScene, lDepth + 1));
end;

function TRayTracer.AddLight(const lThing: TThing; const lPos, lNormal, lRd: TVec3; const lScene: IScene;
  const lColor: TColor; const lLight: TLigth): TColor;
var
  lDis,
  lIvec: TVec3;
  lNearIsect: TOptional<TReal>;
  lIsInShadow: Boolean;

  lIllum: TReal;
  lCol: TColor;
  lSpecular: TReal;
  lSurface: ISurface;
  lScolor: TColor;

begin
  lDis := lLight.Pos - lPos;
  lIvec := Norm(lDis);
  lNearIsect := TestRay(TRay.Create(lPos, lIvec), lScene);

  lIsInShadow := False;
  if (lNearIsect.HasValue) then
  begin
    lIsInShadow := lNearIsect.Value < Mag(lDis);
  end;

  if (lIsInShadow) then
  begin
    Exit(lColor);
  end;

  lIllum := Dot(lIvec, lNormal);
  lCol := TColor.DefaultColor;
  if (lIllum > 0) then
  begin
    lCol := Scale(lIllum, lLight.Col);
  end;
  lSpecular := Dot(lIvec, Norm(lRd));

  lSurface := lThing.Surface;
  if (lSpecular > 0) then
  begin
    lScolor := Scale(Pow(lSpecular, lSurface.Roughness), lLight.Col);
  end
  else
  begin
    lScolor := TColor.DefaultColor;
  end;

  Result := lColor + (lSurface.Diffuse(lPos) * lCol) + (lSurface.Specular(lPos) * lScolor);
end;

function TRayTracer.TestRay(const lRay: TRay; const lScene: IScene): TOptional<TReal>;
var
  lIsect: TOptional<TIntersection>;

begin
  lIsect := Intersections(lRay, lScene);
  if (lIsect.HasValue) then
  begin
    Result := TOptional<TReal>.Create(lIsect.Value.Dist);
  end;
end;

end.
