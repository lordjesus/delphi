unit DataUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, Data.FMTBcd,
  Data.DBXInterBase, Data.DB, Data.SqlExpr, FMX.StdCtrls, FMX.Edit, FMX.ListBox,
  FMX.Layouts, System.IOUtils;

type
  TDataForm = class(TForm)
    ListBox1: TListBox;
    ListBoxHeader1: TListBoxHeader;
    SearchBox1: TSearchBox;
    Label1: TLabel;
    SQLConnection1: TSQLConnection;
    SQLDataSet1: TSQLDataSet;
    procedure FormCreate(Sender: TObject);
    procedure SQLConnection1BeforeConnect(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fCustomerId: Integer;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; aCustomerId: Integer);
  end;

var
  DataForm: TDataForm;

implementation

{$R *.fmx}

constructor TDataForm.Create(aOwner: TComponent; aCustomerId: Integer);
begin
  fCustomerId := aCustomerId;
  inherited Create(aOwner);

end;

procedure TDataForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SQLConnection1.Close;

end;

procedure TDataForm.FormCreate(Sender: TObject);
var
ListBoxItem: TListBoxItem;
  ItemData: TListBoxItemData;
begin
//  SQLDataSet1.CommandText := 'SELECT SHIPTOCONTACT, ITEMSTOTAL, AMOUNTPAID ' +
  //                           'FROM ORDERS WHERE CUSTNO = 1351';
 // SQLDataSet1.Open;
  ListBox1.BeginUpdate;
   ListBox1.Items.Clear;
   SQLDataSet1.Close;
   SQLDataSet1.CommandText := 'select ORDERNO, SHIPVIA, AMOUNTPAID, ITEMSTOTAL from ORDERS ' +
      'where CUSTNO = ' + IntToStr(fCustomerId);
      SQLDataSet1.Open;
   while not SQLDataSet1.Eof do
  begin
      ListBoxItem := TListBoxItem.Create(ListBox1);
      ItemData := TListBoxItemData.Create(ListBoxItem);
      ItemData.Detail := 'Total items: ' +
        SQLDataSet1.FieldByName('ITEMSTOTAL').AsString + ', Amount paid: ' +
        SQLDataSet1.FieldByName('AMOUNTPAID').AsString + ', Deliverd by: ' +
        SQLDataSet1.FieldByName('SHIPVIA').AsString;
      ItemData.Text := 'Order no.: ' + SQLDataSet1.FieldByName('ORDERNO').AsString;
      ListBoxItem.ItemData := ItemData;
   //   ListBox2.Items.AddObject(SQLDataSet2.FieldByName('COMPANY').AsString, id);
      ListBoxItem.Parent := ListBox1;
      SQLDataSet1.Next;
   end;
   ListBox1.EndUpdate;
end;

procedure TDataForm.SQLConnection1BeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
   SQLConnection1.Params.Values['Database'] :=
      TPath.Combine(TPath.GetDocumentsPath, 'dbdemos.gdb');
  {$ENDIF}
end;

end.
