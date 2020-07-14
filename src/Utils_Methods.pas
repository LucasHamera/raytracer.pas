unit Utils_Methods;

interface

uses
  Utils_Types,
  Vcl.Graphics,
  Geometry_Types;

  procedure CanvasToBitmap(const lCanvas: TDynamicCanvas; var lImage: TBitmap);

implementation

procedure CanvasToBitmap(const lCanvas: TDynamicCanvas; var lImage: TBitmap);
var
  X,
  Y: Integer;
  lPixelsLine: PRGBTripleArray;
  lCanvasBytes: TArrayOfByte;

begin
  lImage.Width := lCanvas.Width;
  lImage.Height := lCanvas.Height;
  lImage.PixelFormat := pf24bit;

  lCanvasBytes := lCanvas.GetPixels;

  for Y := 0 to lCanvas.Height - 1 do
  begin
    lPixelsLine := lImage.ScanLine[Y];
    for X := 0 to lCanvas.Width - 1 do
    begin
      lPixelsLine[X].rgbtRed := lCanvasBytes[(Y * lCanvas.Width + X) * 3 + 0];
      lPixelsLine[X].rgbtGreen := lCanvasBytes[(Y * lCanvas.Width + X) * 3 + 1];
      lPixelsLine[X].rgbtBlue := lCanvasBytes[(Y * lCanvas.Width + X) * 3 + 2];
    end;
  end;
end;

end.
