program RayTracer.PAS;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  {$IFNDEF DEBUG}
  FastMM4,
  {$ENDIF }
  Windows,
  Vcl.Graphics,
  System.SysUtils,
  Geometry.Types in 'Geometry.Types.pas',
  Geometry.Methods in 'Geometry.Methods.pas',
  Utils.Types in 'Utils.Types.pas',
  Geometry.RayTracer in 'Geometry.RayTracer.pas',
  Scene in 'Scene.pas',
  Utils.Methods in 'Utils.Methods.pas';

const
  WIDTH = 512;
  HEIGHT = 512;

procedure StartRender(const lRayTracer: TRayTracer);
var
  lScene: IScene;
  lCanvas: TDynamicCanvas;
  lBitmap: TBitmap;
  lStartTime,
  lEndTime: Int64;

begin
  lScene := TMyScene.Create();
  lCanvas := TDynamicCanvas.Create(WIDTH, HEIGHT);
  try
    lStartTime := GetTickCount;
    lRayTracer.Render(lScene, lCanvas, WIDTH, HEIGHT);
    lEndTime := GetTickCount;

    Writeln('Ticks time - ' + IntToStr(lEndTime - lStartTime) + ' [ms]');

    lBitmap := TBitmap.Create();
    try
      CanvasToBitmap(lCanvas, lBitmap);

      lBitmap.SaveToFile('render.bmp');
    finally
      lBitmap.Free;
    end;
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
