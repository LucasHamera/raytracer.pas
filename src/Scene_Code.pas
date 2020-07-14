unit Scene_Code;

interface

uses
  Geometry_Types,
  System.Generics.Collections;

type
  TMyScene = class(TInterfacedObject, IScene)
  strict private
    fThings: TList<TThing>;
    fLights: TLisT<TLigth>;
    fCamera: TCamera;

    procedure InitData();

  public
    constructor Create();
    destructor Destroy(); override;

    function GetThings(): TList<TThing>;
    function GetLights(): TList<TLigth>;
    function GetCamera(): TCamera;
  end;

implementation

constructor TMyScene.Create();
begin
  fThings := TList<TThing>.Create();
  fLights := TLisT<TLigth>.Create();

  InitData();
end;

destructor TMyScene.Destroy();
begin

end;

function TMyScene.GetThings(): TList<TThing>;
begin
  Result := fThings;
end;

function TMyScene.GetLights(): TList<TLigth>;
begin
  Result := fLights;
end;

function TMyScene.GetCamera(): TCamera;
begin
  Result := fCamera;
end;

procedure TMyScene.InitData();
begin
  fCamera := TCamera.Create(TVec3.Create(3.0, 2.0, 4.0), TVec3.Create(-1.0, 0.5, 0.0));

  fThings.Add(TPlane.Create(TVec3.Create(0.0, 1.0, 0.0), 0.0, TCheckerboard.Create));
  fThings.Add(TSphere.Create(TVec3.Create(0.0, 1.0, -0.25), 1.0, TShiny.Create));
  fThings.Add(TSphere.Create(TVec3.Create(-1.0, 0.5, 1.5), 0.5, TShiny.Create));

  fLights.Add(TLigth.Create(TVec3.Create(-2.0, 2.5, 0.0), TColor.Create(0.49, 0.07, 0.07)));
  fLights.Add(TLigth.Create(TVec3.Create(1.5, 2.5, 1.5), TColor.Create(0.07, 0.07, 0.49)));
  fLights.Add(TLigth.Create(TVec3.Create(1.5, 2.5, -1.5), TColor.Create(0.07, 0.49, 0.071)));
  fLights.Add(TLigth.Create(TVec3.Create(0.0, 3.5, 0.0), TColor.Create(0.21, 0.21, 0.35)));
end;

end.
