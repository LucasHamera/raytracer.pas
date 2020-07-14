program RayTracer.PAS;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Geometry_Types in 'Geometry_Types.pas',
  Geometry_Methods in 'Geometry_Methods.pas',
  Utils_Types in 'Utils_Types.pas',
  Geometry_RayTracer in 'Geometry_RayTracer.pas';

var
  lRayTracer: TRayTracer;

begin
  try
    lRayTracer := TRayTracer.Create();
    try

    finally
      lRayTracer.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
