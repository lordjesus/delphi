unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Layouts, FMX.ListBox, FMX.Edit, Data.DBXInterBase, Data.DB, Data.SqlExpr,
  Data.FMTBcd;

type
  TForm1 = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Edit1: TEdit;
    ListBoxHeader1: TListBoxHeader;
    SearchBox1: TSearchBox;
    Label1: TLabel;
    SQLConnection1: TSQLConnection;
    SQLDataSet1: TSQLDataSet;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
    Suits : array[1..4] of String;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  rand : Integer;
begin
  if Edit1.Text <> '' then
  begin
    ListBox1.Items.Add(Edit1.Text);
  end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
   Suits[1] := 'Hearts';
   Suits[2] := 'Diamonds';
   Suits[3] := 'Clubs';
   Suits[4] := 'Spades';
end;

procedure TForm1.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin
   ShowMessage(Item.Text);
end;

end.
