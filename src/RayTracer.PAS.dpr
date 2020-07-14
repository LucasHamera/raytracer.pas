program RayTracer.PAS;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Geometry_Types in 'Geometry_Types.pas',
  Geometry_Methods in 'Geometry_Methods.pas',
  Utils_Types in 'Utils_Types.pas',
  Geometry_RayTracer in 'Geometry_RayTracer.pas',
  Scene_Code in 'Scene_Code.pas';

const
  WIDTH = 512;
  HEIGHT = 512;

procedure StartRender(const lRayTracer: TRayTracer);
var
  lScene: IScene;
  lCanvas: TDynamicCanvas;

begin
  lScene := TMyScene.Create();
  lCanvas := TDynamicCanvas.Create(WIDTH, HEIGHT);
  try
    lRayTracer.Render(lScene, lCanvas, WIDTH, HEIGHT);
  finally
    lCanvas.Free;
  end;
end;

var
  lRayTracer: TRayTracer;

begin
  try
    lRayTracer := TRayTracer.Create();
    try
      StartRender(lRayTracer);
    finally
      lRayTracer.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
