program Project1;

uses
  Vcl.Forms,
  ColTimer in '..\ColorTimer\ColTimer.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
