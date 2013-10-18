unit Unit3;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  Unit4;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
begin
   Form4 := TForm4.Create(self);
   Form4.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if ModalResult = mrOk then
        Label1.Text := 'Returned with mrOk';

      Form4.DisposeOf;
    end);

end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  self.ModalResult := mrOk;
end;

end.
