unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Data.DBXInterBase, Data.DB, Data.SqlExpr, FMX.StdCtrls, FMX.Edit, FMX.ListBox,
  FMX.Layouts, Data.FMTBcd, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, System.IOUtils, Unit3;

type
  TForm2 = class(TForm)
    ListBox1: TListBox;
    ListBoxHeader1: TListBoxHeader;
    SearchBox1: TSearchBox;
    Label1: TLabel;
    SQLConnection1: TSQLConnection;
    SQLDataSet1: TSQLDataSet;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    Button1: TButton;
    Label2: TLabel;
    LinkPropertyToFieldTag: TLinkPropertyToField;
    procedure SQLConnection1BeforeConnect(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.Button1Click(Sender: TObject);
var
   aResult: Integer;
begin
   Form3 := TForm3.Create(self);
   Form3.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if ModalResult = mrOk then
        Label2.Text := 'Returned with mrOk';

      Form3.Free;
    end);

end;

procedure TForm2.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
var
  aId: integer;
begin
  aId := Item.Index;
  ShowMessage('Index is ' + IntToStr(aId) + ', CUSTNO is ' + Item.Detail + ', Company is ' + Item.Text);
end;

procedure TForm2.SQLConnection1BeforeConnect(Sender: TObject);
begin
   {$IF DEFINED(iOS) or DEFINED(ANDROID)}
   SQLConnection1.Params.Values['Database'] :=
      TPath.Combine(TPath.GetDocumentsPath, 'dbdemos.gdb');
  {$ENDIF}
end;

end.
