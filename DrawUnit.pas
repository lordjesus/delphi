  unit DrawUnit;

  interface

  uses
    System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
    FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects, System.UIConsts,
    FMX.StdCtrls, FMX.Gestures, FMX.Platform, Generics.Collections;

  type
    TDraw = class
    private
      fpath: TPathData;
      fId: Integer;
      fName: String;
    public
      constructor Create;
      destructor Destroy; override;
      property Path: TPathData read fpath write fpath;
      property Id: Integer read fId write fId;
      property Name: String read fName write fName;
    end;

    TDrawForm = class(TForm)
      GestureManager1: TGestureManager;
      Label1: TLabel;
      Button1: TButton;
    Panel1: TPanel;
    Image1: TImage;
      procedure Image1Gesture(Sender: TObject; const EventInfo: TGestureEventInfo;
        var Handled: Boolean);
      procedure Image1Click(Sender: TObject);
      procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
        Shift: TShiftState; X, Y: Single);
      procedure FormCreate(Sender: TObject);
      procedure Button1Click(Sender: TObject);
    private
      { Private declarations }
      oldDist: integer;
      ClickGestureInfo: TGestureEventInfo;
    function ClearGestureInfo: TGestureEventInfo;
      const CLICK_ID = 42;
      procedure DrawFromList(image: TImage);
      procedure TranslateDraw(tx, ty: single);
      procedure ScaleDraw(dist: single; midPoint: TPointF);
    function CheckPointInRoom(point: TPointF) : Boolean;

    public
      { Public declarations }
      DrawList: TList<TDraw>;
      LastPosition: TPointF;
      FirstTouch: Boolean;
    end;

  var
    DrawForm: TDrawForm;

  implementation

    procedure DrawOnImage(image: TImage; start: TPointF);
    var
     Path: TPathData;
    begin
     // Path.Data := 'm40,40 L40,100 100,100 100,40 z';

       // draw on TImage.Bitmap
       Path := TPathData.Create;
      // Path.Data := 'm40,40 L40,100 100,100 100,40 z';
       Path.MoveTo(start);
       Path.LineTo(PointF(start.X, start.Y - 100));
       Path.LineTo(PointF(start.X - 100, start.Y - 100));
       Path.LineTo(PointF(start.X - 100, start.Y));
       Path.ClosePath;

       image.Bitmap.SetSize(Trunc(image.Width), Trunc(image.Height));
       image.Bitmap.Canvas.BeginScene;
       image.Bitmap.Canvas.Clear(claAliceblue);
       image.Bitmap.Canvas.Stroke.Color := claBlack;
       image.Bitmap.Canvas.Fill.Color := claYellow;

       image.Bitmap.Canvas.FillPath(Path, 1);
       image.Bitmap.Canvas.DrawPath(Path, 1);

       image.Bitmap.Canvas.EndScene;
    end;
  {$R *.fmx}

  procedure TDrawForm.FormCreate(Sender: TObject);
  var Path: TPathData;
    start: TPointF;
    draw: TDraw;
  begin

    FirstTouch := true;
    Image1.Bitmap.SetSize(Trunc(Image1.Width * 1.34), Trunc(Image1.Height * 1.34));

   // Image1.Bitmap.SetSize(Trunc(Image1.Width), Trunc(Image1.Height));
    DrawList := TList<TDraw>.Create;

    Path := TPathData.Create;
    start := PointF(100,100);
    Path.MoveTo(start);
    Path.LineTo(PointF(start.X, start.Y - 100));
    Path.LineTo(PointF(start.X - 100, start.Y - 100));
    Path.LineTo(PointF(start.X - 100, start.Y));
    Path.ClosePath;
    draw := TDraw.Create;
    draw.fpath := Path;
    draw.Id := 1;
    draw.Name := 'Kontor';
    DrawList.Add(draw);

    Path := TPathData.Create;
    start := PointF(200,200);
    Path.MoveTo(start);
    Path.LineTo(PointF(start.X, start.Y - 100));
    Path.LineTo(PointF(start.X - 100, start.Y - 100));
    Path.LineTo(PointF(start.X - 100, start.Y));
    Path.ClosePath;
    draw := TDraw.Create;
    draw.fpath := Path;
    draw.Id := 2;
    draw.Name := 'Møderum';
    DrawList.Add(draw);

    Path := TPathData.Create;
    start := PointF(400,400);
    Path.MoveTo(start);
    Path.LineTo(PointF(start.X, start.Y - 100));
    Path.LineTo(PointF(start.X - 100, start.Y - 100));
    Path.LineTo(PointF(start.X - 100, start.Y));
    Path.ClosePath;
    draw := TDraw.Create;
    draw.fpath := Path;
    draw.Id := 3;
    draw.Name := 'Toilet';
    DrawList.Add(draw);

    Label1.Text := IntToStr(DrawList.Count);
     DrawFromList(Image1);
  end;

  procedure TDrawForm.Button1Click(Sender: TObject);
  var draw: TDraw;
  matrix: TMatrix;
  begin

  end;

  procedure TDrawForm.DrawFromList(image: TImage);
  var draw: TDraw;
  begin

    image.Bitmap.Canvas.BeginScene;
    image.Bitmap.Canvas.Clear(claBlue);
    image.Bitmap.Canvas.Stroke.Color := claBlack;
    image.Bitmap.Canvas.Fill.Color := claYellow;
    for draw in DrawList do
    begin
      image.Bitmap.Canvas.FillPath(draw.fpath, 1);
      image.Bitmap.Canvas.DrawPath(draw.fpath, 1);
    end;
    image.Bitmap.Canvas.EndScene;
  end;

  procedure TDrawForm.Image1Click(Sender: TObject);
  var
    P: TPointF;
  begin
    if (ClickGestureInfo.GestureID = CLICK_ID) then
    begin
      CheckPointInRoom(ClickGestureInfo.Location);
      ClickGestureInfo:= ClearGestureInfo;
    end;
  end;

  procedure TDrawForm.Image1Gesture(Sender: TObject;
    const EventInfo: TGestureEventInfo; var Handled: Boolean);
    var tx, ty, scale: single;
  begin
   // DrawOnImage(Image1, EventInfo.Location);
   // Label1.Text := ('Finger: ' + FloatToStr(EventInfo.Location.X) + '; ' +
   //   FloatToStr(EventInfo.Location.Y));
   // ShowMessage('Finger: ' + FloatToStr(EventInfo.Location.X) + ',' + FloatToStr(EventInfo.Location.Y));
   case EventInfo.GestureID of
     igiPan : begin
       tx := EventInfo.Location.X - LastPosition.X;
       ty := EventInfo.Location.Y - LastPosition.Y ;
       LastPosition := EventInfo.Location;
       TranslateDraw(tx, ty);
       if (TInteractiveGestureFlag.gfBegin in EventInfo.Flags) then
        Label1.Text := 'gfBegin, inertia: ' + FloatToStr(EventInfo.InertiaVector.X) + '; ' + FloatToStr(EventInfo.InertiaVector.Y);
       if (TInteractiveGestureFlag.gfInertia in EventInfo.Flags) then
        Label1.Text := 'gfInertia';
       if (TInteractiveGestureFlag.gfEnd in EventInfo.Flags) then
        Label1.Text := 'gfEnd, inertia: ' + FloatToStr(EventInfo.InertiaVector.X) + '; ' + FloatToStr(EventInfo.InertiaVector.Y);
     end;
     igiZoom : begin
       // Zoom code here
       if (TInteractiveGestureFlag.gfBegin in EventInfo.Flags) then
       begin
          oldDist := EventInfo.Distance;
       end
       else
       begin
          scale := (EventInfo.Distance) / (oldDist);
//          Label1.Text := 'Scale: ' + FloatToStr(scale);
          Label1.Text := 'Inertia: ' + FloatToStr(EventInfo.InertiaVector.X) + '; ' + FloatToStr(EventInfo.InertiaVector.Y);
          oldDist := EventInfo.Distance;
          ScaleDraw(scale, EventInfo.Location);
       end;


//       Label1.Text := 'Distance: ' + FloatToStr(EventInfo.Distance) +
//       ', Location: (' + FloatToStr(EventInfo.Location.X) + '; ' + FloatToStr(EventInfo.Location.Y) + ')' +
//       ', TapLocation: ' + FloatToStr(EventInfo.TapLocation.X) + '; ' + FloatToStr(EventInfo.TapLocation.Y) + ')';
//


//       Image1.Bitmap.Canvas.BeginScene;
//       Image1.Bitmap.Canvas.DrawLine(EventInfo.Location, PointF(EventInfo.Location.X + 5, EventInfo.Location.Y + 5), 1);
//       Image1.Bitmap.Canvas.EndScene;
     end;
   end;



  end;

  procedure TDrawForm.TranslateDraw(tx: single; ty: single);
  var draw: TDraw;
  begin
    for draw in DrawList do
    begin
      draw.fpath.Translate(tx, ty);
    end;
    DrawFromList(Image1);
  end;

  function TDrawForm.ClearGestureInfo: TGestureEventInfo;
  begin
    FillChar(Result, SizeOf(Result), #0);
  end;

  function TDrawForm.CheckPointInRoom(point: TPointF) : Boolean;
  var draw: TDraw;
  bounds: TRectF;
  begin
    result := false;
    for draw in DrawList do
      begin
        bounds := draw.fpath.GetBounds;
        if bounds.Contains(point) then
        begin
          result := true;
          ShowMessage('Id: ' + IntToStr(draw.Id) + ', Name: ' + draw.Name);
        end;
      end;
  end;

  procedure TDrawForm.ScaleDraw(dist: single; midPoint: TPointF);
  var draw: TDraw;
  matrix: TMatrix;
  begin
    for draw in DrawList do
    begin
      draw.fpath.Translate(-midPoint.X, -midPoint.Y);
      draw.fpath.Scale(dist, dist);
      draw.fpath.Translate(midPoint.X, midPoint.Y);

      // Try to use draw.fpath.ApplyMatrix instead

    end;
    DrawFromList(Image1);

   // Label1.Text := 'Distance: ' + FloatToStr(dist) + ', Angle: ' + FloatToStr(angle);
  end;

  procedure TDrawForm.Image1MouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Single);
  begin
    //Label1.Text := ('Finger: ' + FloatToStr(X) + '; ' + FloatToStr(Y));
   // DrawOnImage(Image1, PointF(X, Y));
   LastPosition := PointF(X, Y);
   ClickGestureInfo.GestureID := CLICK_ID;
   ClickGestureInfo.Location := PointF(X, Y);

  end;

  { TDraw }

  constructor TDraw.Create;
  begin
    fpath := TPathData.Create;
  end;

  destructor TDraw.Destroy;
  begin
    fpath.Free;
  end;

  end.
