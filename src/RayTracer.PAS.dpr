program RayTracer.PAS;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Geometry_Types in 'Geometry_Types.pas',
  Geometry_Methods in 'Geometry_Methods.pas',
  Utils_Types in 'Utils_Types.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
