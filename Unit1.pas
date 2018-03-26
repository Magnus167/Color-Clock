unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    RefImg: TImage;
    Image1: TImage;
    Timer1: TTimer;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Mins: TEdit;
    Seconds: TEdit;
    Hrs: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure Timer1Timer(Sender: TObject);
    function IntToTime(n: UInt64): string;
    procedure Button1Click(Sender: TObject);
    procedure timerDone;
    procedure MinsKeyPress(Sender: TObject; var Key: Char);
    procedure Button2Click(Sender: TObject);
    procedure MinsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SecondsClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  TimeX, TimeOrg: UInt64;
  timerState: Boolean;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Hrs.Text = '' then
    Hrs.Text := '00';
  if Mins.Text = '' then
    Mins.Text := '00';
  if Seconds.Text = '' then
    Seconds.Text := '00';

  TimeX := StrToUInt(Seconds.Text) + StrToUInt(Mins.Text) * 60 +
    StrToUInt(Hrs.Text) * 3600;

  TimeOrg := TimeX;

  Label1.Caption := IntToTime(TimeOrg);

  if Button1.Caption = 'Start' then
  begin

    if TimeX > 0 then
    begin
      timerState := true;

      Hrs.Visible := False;
      Mins.Visible := False;
      Seconds.Visible := False;
      Button1.Caption := 'Stop';
    end;

  end
  else
  begin
    Button1.Caption := 'Start';
    timerState := False;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  timerDone;
  timerState := False;
  Label1.Caption := IntToTime(TimeOrg)

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Seconds.SetFocus;
end;

procedure TForm1.FormCanResize(Sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  NewWidth := 500;
  NewHeight := 500;
  Resize := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  RefImg.Height := 1;
  RefImg.Width := 255;
  for i := 0 to 255 do
  begin
    RefImg.Canvas.Pixels[i, 0] := RGB(0 + i, 0, 255 - i);
  end;
  RefImg.Visible := False;

  Image1.Height := 500;
  Image1.Width := 500;

  TimeX := 0;
  timerState := False;

  Label1.Caption := '';
  Label1.Color := clWhite;
  Image1.Canvas.Brush.Color := clBlack;
  Image1.Canvas.FillRect(Rect(0, 0, 500, 500));

end;

function TForm1.IntToTime(n: UInt64): string;
var
  res, temp: String;
  ix: UInt64;
begin
  res := '';
  for ix := 0 to 1 do
  begin
    temp := '';
    temp := UIntToStr((n + 60) mod 60);
    if StrToInt(temp) < 10 then
      temp := '0' + temp;
    res := ':' + temp + res;
    n := n div 60;
  end;
  res := UIntToStr(n) + res;
  Result := res;
end;

procedure TForm1.MinsKeyPress(Sender: TObject; var Key: Char);
begin
  if NOT(Key in ['0' .. '9', #08, #13]) then
    Key := #0;
  if Key = #13 then
  begin
    Key := #0;
    Button1Click(Sender);
  end;

end;

procedure TForm1.MinsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Hrs.Text = '' then
    Hrs.Text := '00';
  if Mins.Text = '' then
    Mins.Text := '00';
  if Seconds.Text = '' then
    Seconds.Text := '00';

  TimeX := StrToUInt(Seconds.Text) + StrToUInt(Mins.Text) * 60 +
    StrToUInt(Hrs.Text) * 3600;

  TimeOrg := TimeX;
end;

procedure TForm1.SecondsClick(Sender: TObject);
begin
  //
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if timerState then
  begin
    Image1.Canvas.Brush.Color := RefImg.Canvas.Pixels
      [((TimeOrg - TimeX) * 255) div TimeOrg, 0];
    // Label1.Font.Color := RefImg.Canvas.Pixels[((TimeX) * 255) div TimeOrg, 0];
    Image1.Canvas.FillRect(Rect(0, 0, 500, 500));
    Inc(TimeX, -1);

    Label1.Caption := IntToTime(TimeX);
    if TimeX = 0 then
    begin

      timerState := False;
      timerDone;
    end;
  end;

end;

procedure TForm1.timerDone;
begin
  showMessage('Timer Complete');
  Button1.Caption := 'Start';
  Image1.Canvas.Brush.Color := clBlack;
  Image1.Canvas.FillRect(Rect(0, 0, 500, 500));
  Hrs.Visible := true;
  Mins.Visible := true;
  Seconds.Visible := true;
end;

end.
