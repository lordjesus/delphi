unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Data.DBXInterBase, Data.FMTBcd, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.EngExt, Fmx.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope, Data.DB, Data.SqlExpr, FMX.StdCtrls, FMX.Edit, FMX.ListBox,
  FMX.Layouts, System.IOUtils, DrawUnit, DataUnit, FMX.ListView.Types, FMX.ListView;

type
  TCustomItemData = class(TListBoxItemData)
  private
    mId: Integer;
  public
    property Id: Integer read mId write mId;
  end;

   TId = class
  private
    mId: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    property Id: Integer read mId write mId;
  end;

  TMainForm = class(TForm)
    ListBox1: TListBox;
    ListBoxHeader1: TListBoxHeader;
    SearchBox1: TSearchBox;
    Label1: TLabel;
    SQLConnection1: TSQLConnection;
    SQLDataSet1: TSQLDataSet;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    Button1: TButton;
    LinkFillControlToField2: TLinkFillControlToField;
    SQLDataSet2: TSQLDataSet;
    procedure SQLConnection1BeforeConnect(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListBox2ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
  private
    { Private declarations }
  public
    { Public declarations }
    CurrentId: Integer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

procedure TMainForm.Button1Click(Sender: TObject);
begin
  DrawForm := TDrawForm.Create(self);
  DrawForm.Show();
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  list: TStrings;
  s1, s2: String;
  id: TId;
  ListBoxItem: TListBoxItem;
  ItemData: TCustomItemData;
begin
   ListBox1.BeginUpdate;
   ListBox1.Items.Clear;
   while not SQLDataSet2.Eof do
   begin
      ListBoxItem := TListBoxItem.Create(ListBox1);
      ItemData := TCustomItemData.Create(ListBoxItem);
      ItemData.Detail := SQLDataSet2.FieldByName('ADDR1').AsString;
      ItemData.Text := SQLDataSet2.FieldByName('COMPANY').AsString;
      ItemData.Id := SQLDataSet2.FieldByName('CUSTNO').AsInteger;
      ListBoxItem.ItemData := ItemData;
      id := TId.Create;
      id.Id := SQLDataSet2.FieldByName('CUSTNO').AsInteger;
   //   ListBox2.Items.AddObject(SQLDataSet2.FieldByName('COMPANY').AsString, id);
      ListBoxItem.Parent := ListBox1;
      SQLDataSet2.Next;
   end;
   ListBox1.EndUpdate;
end;

procedure TMainForm.ListBox2ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
begin

  ShowMessage(Item.Text + ', ' + Item.ItemData.Detail);

end;

procedure TMainForm.ListBox1ItemClick(const Sender: TCustomListBox;
  const Item: TListBoxItem);
  var id: TId;
  ItemData: TCustomItemData;
begin
 // id := TId(ListBox2.Items.Objects[ListBox2.ItemIndex]);
  ItemData := TCustomItemData(Item.ItemData);
  CurrentId := ItemData.Id;
  DataForm := TDataForm.Create(self, CurrentId);
  DataForm.Show();

//  ShowMessage('Id: ' + IntToStr(ItemData.Id));

end;

procedure TMainForm.SQLConnection1BeforeConnect(Sender: TObject);
begin
  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
   SQLConnection1.Params.Values['Database'] :=
      TPath.Combine(TPath.GetDocumentsPath, 'dbdemos.gdb');
  {$ENDIF}
end;

{ TId }

constructor TId.Create;
begin
  Id := 0;
end;

destructor TId.Destroy;
begin

  inherited;
end;

end.
