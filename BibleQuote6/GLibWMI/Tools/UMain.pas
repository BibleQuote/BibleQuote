unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, DB, DBClient, Grids, DBGrids, DBCtrls,
  StdCtrls, Buttons, ActnList, Placemnt;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    cds: TClientDataSet;
    ds: TDataSource;
    cdsPropName: TStringField;
    cdsType: TStringField;
    ActionList1: TActionList;
    ActionGrabarClase: TAction;
    ActionLoadClase: TAction;
    FormStorage1: TFormStorage;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel4: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel6: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Grid: TDBGrid;
    DBNavigator1: TDBNavigator;
    BitBtn1: TBitBtn;
    edtClassID: TEdit;
    Button1: TButton;
    Button2: TButton;
    edtClassName: TEdit;
    tsDefClass: TTabSheet;
    Panel3: TPanel;
    Panel5: TPanel;
    PageControl2: TPageControl;
    tsClass: TTabSheet;
    mmClass: TMemo;
    tsClearProc: TTabSheet;
    mmClearProc: TMemo;
    tsCompClass: TTabSheet;
    mmCompClass: TMemo;
    Label3: TLabel;
    edtClassID2: TEdit;
    Button3: TButton;
    Button4: TButton;
    BitBtn2: TBitBtn;
    mmDefClass: TMemo;
    tsFillProp: TTabSheet;
    mmFillProp: TMemo;
    StatusBar1: TStatusBar;
    Label4: TLabel;
    edtwww: TEdit;
    tsCab: TTabSheet;
    mmCabecera: TMemo;
    Label5: TLabel;
    edtDesc: TEdit;
    tsCabImpl: TTabSheet;
    mmCambImpl: TMemo;
    tsOther: TTabSheet;
    mmOther: TMemo;
    tsAll: TTabSheet;
    mmComponente: TMemo;
    TabSheet5: TTabSheet;
    mmEnumerado: TMemo;
    Panel7: TPanel;
    Button5: TButton;
    Button6: TButton;
    edtPropiedad: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edtTipo: TEdit;
    cbIncluteHex: TCheckBox;
    cdsenum: TBooleanField;
    cdsarray: TBooleanField;
    tsPropProcs: TTabSheet;
    mmPropProcs: TMemo;
    TabSheet7: TTabSheet;
    mmEnumConst: TMemo;
    TabSheet8: TTabSheet;
    Label8: TLabel;
    edtFuentes: TEdit;
    Panel8: TPanel;
    Button7: TButton;
    SaveDialog1: TSaveDialog;
    Panel9: TPanel;
    Button8: TButton;
    mmEnumGet: TMemo;
    mmEnumImpl: TMemo;
    cbLimpiarGenerar: TCheckBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure ActionGrabarClaseExecute(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure GridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private

    FFileName:String;

    procedure _Log(AMsg:string);
    function _GetEmptyTypeAsString(StrType:string):string;
    function _GetTypeAsString(StrType:string; AsArray:boolean=False): string;

    procedure _GenerarCabecera();
    procedure _GenerarCabeceraImpl();
    procedure _GenerarDefinicionClase();
    procedure _GenerarClearProc();
    procedure _GeneraDefCompClass();
    procedure _GeneraFillProps();
    procedure _GeneraPropsProcs();
    procedure _GenerarOtherProcs();

    function __ClassID():string;         // TBios
    function __ClassName():string;       // TBiosInfo
    function __GetCompName():string;     // CBiosInfo
    function __GetDesc():string;         // Permite obtener mediante WMI información de la BIOS del ordenador
    function __GetWWW():string;          // http://msdn.microsoft.com/en-us/library/aa394358(VS.85).aspx
    function __GetMyWeb():string;        // Neftali web
    function __GetClassName():string;     // Win32_BIOS
    function __GetClassProps():string;    // TBIOSProperies
    function __GetPrivateProps: string;   // FBIOSProperies
    function __GetPublicProps: string;    // BIOSProperies


    function sp(numSpaces:integer):string;
  public
    { Public declarations }
  end;

const
  DATA_DIRNAME = 'Data';
  CHAR_TWOPOINTS = ':';
  CHAR_COMMAPOINT = ';';
  CHAR_SPACE = ' ';

  TYPE_STRING_NULL = 'STR_EMPTY';
  TYPE_INTEGER_NULL = '0';
  TYPE_BOOLEAN_NULL = 'False';
  STR_EMPTY = '';

// Constantes para los enumerados
const
  STR_CONT_ENUM   = '// {CONST_ENUM}';
  STR_GET_ENUM    = '// {GET_ENUM}';
  STR_IMPL_ENUM   = '// {IMPL_ENUM}';

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  StrUtils;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  _GenerarCabecera();
  _GenerarCabeceraImpl();
  _GenerarDefinicionClase();
  _GenerarClearProc();
  _GeneraDefCompClass();
  _GeneraFillProps();
  _GenerarOtherProcs();
  _GeneraPropsProcs();


  // Juntarlos TODOS
  mmComponente.Clear;
  mmComponente.Lines.AddStrings(mmCabecera.Lines);
  mmComponente.Lines.AddStrings(mmClass.Lines);
  mmComponente.Lines.AddStrings(mmCompClass.Lines);
  mmComponente.Lines.AddStrings(mmCambImpl.Lines);
  mmComponente.Lines.AddStrings(mmClearProc.Lines);
  mmComponente.Lines.AddStrings(mmOther.Lines);
  mmComponente.Lines.AddStrings(mmPropProcs.Lines);
  mmComponente.Lines.AddStrings(mmFillProp.Lines);




end;

function TForm1.sp(numSpaces: integer): string;
begin
  Result := DupeString(' ', numSpaces);
end;

procedure TForm1._GenerarDefinicionClase();
var
  i:integer;
  Str:string;
  propField:string;
  arrTipo, StrTipo, iTipo:string;

  TSPrivate, TSPublic, TSPublished:TStrings;
begin

  mmClass.Clear;
  TSPrivate := TStringList.Create();
  TSPublic := TStringList.Create();
  TSPublished := TStringList.Create();

  mmClass.Lines.Add(sp(2) + '//: Clase para definir las propiedades del componente.');
  mmClass.Lines.Add(sp(2) + __GetClassProps + ' = class(TPersistent)');
  mmClass.Lines.Add(sp(2) + 'private');

  cds.First;
  while not (cds.eof) do begin
    StrTipo := cds.FieldByName('Type').AsString;
    iTipo := StrTipo;

    StrTipo := _GetTypeAsString(StrTipo);

    // Es un Array
    if (cds.FieldByName('array').AsBoolean) then begin

      arrTipo := _GetTypeAsString(iTipo, True);

      // Propiedad array
      propField := 'F' + cdsPropName.AsString;
      Str := propField + CHAR_TWOPOINTS + arrTipo + CHAR_COMMAPOINT;
      mmClass.Lines.Add(sp(4) + Str);
      // Propiedad Count
      propField := 'F' + cdsPropName.AsString + 'Count';
      Str := propField + CHAR_TWOPOINTS + 'integer' + CHAR_COMMAPOINT;
      mmClass.Lines.Add(sp(4) + Str);
      // Propiedad AsString
      propField := 'F' + cdsPropName.AsString + 'AsString';
      Str := propField + CHAR_TWOPOINTS + 'string' + CHAR_COMMAPOINT;
      mmClass.Lines.Add(sp(4) + Str);

      TSPrivate.Add(sp(4) + 'function Get' + cdsPropName.AsString +
                    '(index: integer): ' + StrTipo + ';');

      TSPublic.Add(sp(4) + 'property ' + cdsPropName.AsString + '[index:integer]:' +
                  StrTipo +
                  ' read Get' + cdsPropName.AsString + ';');
      TSPublic.Add(sp(4) + 'property ' + cdsPropName.AsString + 'Count:integer' +
                  ' read ' + 'F' + cdsPropName.AsString + 'Count' +
                  ' stored False;');
    end
    else begin

      propField := 'F' + cdsPropName.AsString;
      Str := propField + CHAR_TWOPOINTS + StrTipo + CHAR_COMMAPOINT;
      mmClass.Lines.Add(sp(4) + Str);

      // enumerado?
      if (cds.FieldByName('enum').AsBoolean) then begin
        // enumerado como string
        propField := 'F' + {edtClassID.Text +} cdsPropName.AsString + 'AsString';
        Str := propField + CHAR_TWOPOINTS + 'string' + CHAR_COMMAPOINT;
        mmClass.Lines.Add(sp(4) + Str);
      end;
    end; // array

    cds.Next;
  end;

  mmClass.Lines.Add(sp(2) + 'private');
  mmClass.Lines.AddStrings(TSPrivate);

  mmClass.Lines.Add(sp(2) + 'public');
  mmClass.Lines.AddStrings(TSPublic);

  // añadir la marca para procedimientos de enumerados
  mmClass.Lines.Add(STR_EMPTY);
  mmClass.Lines.Add(STR_GET_ENUM);
  mmClass.Lines.Add(STR_EMPTY);

  mmClass.Lines.Add(sp(2) + 'published');
  mmClass.Lines.AddStrings(TSPublished);

  cds.First;
  while not (cds.eof) do begin

    StrTipo := cds.FieldByName('Type').AsString;

    StrTipo := _GetTypeAsString(StrTipo);
//    if (StrTipo = 'datetime') then begin
//      StrTipo := 'TDateTime';
//    end;
//    if (StrTipo = 'uint16') then begin
//      StrTipo := 'Integer';
//    end;

    // Es un Array
    if (cds.FieldByName('array').AsBoolean) then begin
      propField := 'F' + cdsPropName.AsString;
      Str := 'property ' + cdsPropName.AsString + 'AsString' + CHAR_TWOPOINTS +
        'string' +
        ' read ' + propField + 'AsString write ' + propField + 'AsString' +
        ' stored False;';
      mmClass.Lines.Add(sp(4) + Str);
    end
    else begin
      propField := 'F' + cdsPropName.AsString;
      Str := 'property ' + cdsPropName.AsString + CHAR_TWOPOINTS +
        StrTipo +
        ' read ' + propField + ' write ' + propField + ' stored False;';
      mmClass.Lines.Add(sp(4) + Str);
    end;

    // enumerado?
    if (cds.FieldByName('enum').AsBoolean) then begin
      // enumerado as String
      propField := 'F' + cdsPropName.AsString + 'AsString';
      Str := 'property ' + cdsPropName.AsString + 'AsString' + CHAR_TWOPOINTS +
        {StrTipo}'string' +
        ' read ' + 'Get' + cdsPropName.AsString + 'AsString ' + 
        ' write ' + 'F' + cdsPropName.AsString + 'AsString stored False;';
        //' write ' + propField + ' stored False;';
      mmClass.Lines.Add(sp(4) + Str);
    end;
    
    cds.Next;
  end;

  mmClass.Lines.Add(sp(2) + 'end;');
  TSPrivate.Free;
  FreeAndNil(TSPublic);
  FreeAndNil(TSPublished);

end;

procedure TForm1.ActionGrabarClaseExecute(Sender: TObject);
var
  path:string;
begin
  path := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) +
        DATA_DIRNAME;
  path := IncludeTrailingBackslash(path) + edtClassID.Text + '_' + edtClassName.Text +
          '.xml';

  // Grabar
  cds.SaveToFile(path, dfXML);

  _Log(Format('Grabado el fichero: %s',[path]));

end;

procedure TForm1._GeneraPropsProcs();
var
  StrTipo:string;
  Str:String;
begin

  mmPropProcs.Clear;

  cds.First;
  while not (cds.eof) do begin

    if (cdsarray.AsBoolean) then begin

      StrTipo := cdsType.AsString;
      StrTipo := _GetTypeAsString(StrTipo);

      mmPropProcs.Lines.Add('// Acceso a los elementos de la propiedad <' + cdsPropName.AsString +'>');

      Str := 'function ' + __GetClassProps() + '.Get' + cdsPropName.AsString +
             '(index: integer):' + StrTipo + ';';

      mmPropProcs.Lines.Add(Str);
      mmPropProcs.Lines.Add('begin');
      mmPropProcs.Lines.Add(sp(2) + 'if (index >= Self.F' + cdsPropName.AsString + 'Count) then begin');
      mmPropProcs.Lines.Add(sp(4) + 'Index := Self.F' + cdsPropName.AsString + 'Count - 1;');
      mmPropProcs.Lines.Add(sp(2) + 'end;');
      mmPropProcs.Lines.Add(sp(2) + 'Result := Self.F' + cdsPropName.AsString + '[index];');
      mmPropProcs.Lines.Add('end;');
      mmPropProcs.Lines.Add(' ');
    end; // array
    cds.Next;
  end;

end;



procedure TForm1._GenerarClearProc();
var
  i:Integer;
  str, StrType:string;
  propField:string;
begin

  mmClearProc.Clear;

  mmClearProc.Lines.Add('// Limpiar las propiedades');
  mmClearProc.Lines.Add('procedure ' + __ClassName + '.ClearProps;');
  mmClearProc.Lines.Add('begin');
  mmClearProc.Lines.Add('');

  mmClearProc.Lines.Add('  inherited;');

  mmClearProc.Lines.Add('');

  cds.First;
  while not (cds.eof) do begin

    propField := 'F' + cdsPropName.AsString;
    StrType := _GetEmptyTypeAsString(cds.FieldByName('type').AsString);

    if (cdsarray.AsBoolean) then begin
      // Añadir las otras
      Str := 'Self.' + edtClassID.Text + 'Properties.' + propField +
             'Count := 0;';
      mmClearProc.Lines.Add(sp(2) + Str);
      Str := 'Self.' + edtClassID.Text + 'Properties.' + propField +
             'AsString := STR_EMPTY;';
      mmClearProc.Lines.Add(sp(2) + Str);
      Str := 'SetLength(Self.' + edtClassID.Text + 'Properties.' + propField + ',0);';
      mmClearProc.Lines.Add(sp(2) + Str);
    end
    else begin
      Str := 'Self.' + edtClassID.Text + 'Properties.' + propField +
             ' := ' + StrType + ';';

      mmClearProc.Lines.Add(sp(2) + Str);
    end;
    cds.Next;
  end;


  mmClearProc.Lines.Add('');
  mmClearProc.Lines.Add('end;');

end;


function TForm1._GetTypeAsString(StrType:string; AsArray:boolean=False): string;
begin

  // ini
  Result := StrType;

  if (AnsiCompareText(StrType,'datetime')=0) then begin
    Result := 'TDateTime';
  end
  else if (AnsiCompareText(StrType, 'uint16')=0) or
          (AnsiCompareText(StrType, 'sint16')=0) then begin
    Result := 'Integer';
  end
  else if (AnsiCompareText(StrType, 'uint32')=0) then begin
    Result := 'Longword';
  end
  else if (AnsiCompareText(StrType, 'uint64')=0) or
          (AnsiCompareText(StrType, 'sint64')=0) then begin
    Result := 'Int64';
  end
  else if (AnsiCompareText(StrType, 'real64')=0) then begin
    Result := 'Extended';
  end
  else if (AnsiCompareText(StrType, 'uint8')=0) then begin
    Result := 'byte';
  end;

  // Es un Array
  if (AsArray) then begin
    if (AnsiCompareText(StrType, 'string')=0) then begin
      Result := 'TArrString';
    end
    else if (AnsiCompareText(StrType, 'uint16')=0) then begin
      Result := 'TArrInteger';
    end;
  end;


end;


function TForm1._GetEmptyTypeAsString(StrType:string): string;
begin

  if (AnsiCompareText(StrType, 'string') = 0) then begin
    Result := TYPE_STRING_NULL;
  end
  else if (AnsiCompareText(StrType, 'uint16') = 0) then begin
    Result := TYPE_INTEGER_NULL;
  end
  else if (AnsiCompareText(StrType, 'uint32') = 0) or
          (AnsiCompareText(StrType, 'uint64') = 0) or
          (AnsiCompareText(StrType, 'sint64')=0) then begin
    Result := TYPE_INTEGER_NULL;
  end
  else if (AnsiCompareText(StrType, 'sint16') = 0) or
          (AnsiCompareText(StrType, 'uint8') = 0) then begin
    Result := TYPE_INTEGER_NULL;
  end
  else if (AnsiCompareText(StrType, 'real64') = 0) then begin
    Result := TYPE_INTEGER_NULL;
  end
  else if (AnsiCompareText(StrType, 'Boolean') = 0) then begin
    Result := TYPE_BOOLEAN_NULL;
  end
  else if (AnsiCompareText(StrType, 'datetime') = 0) then begin
    Result := TYPE_INTEGER_NULL;
  end
  else begin
    Result := '<Tipo ' + StrType + ' no definido>';
  end;

end;

procedure TForm1.Button2Click(Sender: TObject);
var
  path:string;
begin
  path := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) +
        DATA_DIRNAME;
  path := IncludeTrailingBackslash(path) + edtClassID.Text + '_' + edtClassName.Text +
          '.xml';

  // Grabar
  cds.LoadFromFile(path);

  // Cargar el otro sio es diferentes?
  if (AnsiCompareText(edtClassID.Text, edtClassID2.Text) = 0) then begin
    // nada => son iguales
  end
  else begin
    edtClassID2.Text := edtClassID.Text;
    Button3Click(Self);
  end;

end;

procedure TForm1._GeneraFillProps;
var
  StrTipo:string;
begin


  mmFillProp.Clear;

  mmFillProp.Lines.Add('//: Rellenar las propiedades del componente.');
  mmFillProp.Lines.Add('procedure ' + __ClassName() + '.FillProperties(AIndex: integer);');
  mmFillProp.Lines.Add('var');
  mmFillProp.Lines.Add(sp(2) + 's:string;');
  mmFillProp.Lines.Add(sp(2) + 'i:Integer;');
  mmFillProp.Lines.Add(sp(2) + 'd:TDateTime;');
  mmFillProp.Lines.Add(sp(2) + 'v:variant;');
  mmFillProp.Lines.Add(sp(2) + 'vType:TWMIGenericPropType;');
  mmFillProp.Lines.Add(sp(2) + 'vArr:TArrVariant;');
  mmFillProp.Lines.Add(sp(2) + 'vNull:boolean;');

  mmFillProp.Lines.Add(sp(2) + 'vp:' + __GetClassProps + ';');    
  mmFillProp.Lines.Add('begin');
  mmFillProp.Lines.Add('');

  mmFillProp.Lines.Add(sp(2) + '// Llamar al heredado (importante)');
  mmFillProp.Lines.Add(sp(2) + 'inherited;');
  mmFillProp.Lines.Add('');
  mmFillProp.Lines.Add(sp(2) + '// Rellenar propiedades...');
  mmFillProp.Lines.Add(sp(2) + 'vp := Self.' + __GetPublicProps + ';');

  cds.First;
  while not (cds.eof) do begin

    mmFillProp.Lines.Add('');
    mmFillProp.Lines.Add(sp(2) + 'GetWMIPropertyValue(Self, ' + QuotedStr(cdsPropName.AsString) + ', v, vNull);');
    StrTipo := cdsType.AsString;

    if (cdsarray.AsBoolean) then begin
      mmFillProp.Lines.Add(sp(2) + 'vp.F' + cdsPropName.AsString + 'AsString := ' +
                          'VariantStrValue(v, vNull);');
    end;

    // Segun el tipo
    if (StrTipo = 'string') then begin
      // vp.PortConnectorCaption := VariantStrValue(v, vNull);
      mmFillProp.Lines.Add(sp(2) + 'vp.F' + cdsPropName.AsString + ' := VariantStrValue(v, vNull);');
    end
    else if (StrTipo = 'datetime') then begin
      // vp.PortConnectorCaption := EncodeDate(StrToInt(Copy(v, 1, 4)),StrToInt(Copy(v, 5, 2)),StrToInt(Copy(v, 7, 2)));
      mmFillProp.Lines.Add(sp(2) + 'if not vNull then begin');
      mmFillProp.Lines.Add(sp(4) + 'vp.F' + cdsPropName.AsString +
        ' := EncodeDate(StrToInt(Copy(v, 1, 4)),StrToInt(Copy(v, 5, 2)),StrToInt(Copy(v, 7, 2)));');
      mmFillProp.Lines.Add(sp(2) + 'end;');
    end
    else if (AnsicompareText(StrTipo,'uint16')=0) or (AnsicompareText(StrTipo,'uint32')=0) or
            (AnsicompareText(StrTipo,'uint64')=0) or (AnsicompareText(StrTipo,'sint16')=0) or
            (AnsicompareText(StrTipo,'uint8')=0) or (AnsicompareText(StrTipo,'sint64')=0) then begin
      // vp.PortConnectorCaption := VariantIntegerValue(v, vNull);
      mmFillProp.Lines.Add(sp(2) + 'vp.F' + cdsPropName.AsString + ' := VariantIntegerValue(v, vNull);');
    end
    else if (AnsicompareText(StrTipo,'real64')=0) then begin
      // vp.PortConnectorCaption := VariantFloatValue(v, vNull);
      mmFillProp.Lines.Add(sp(2) + 'vp.F' + cdsPropName.AsString + ' := VariantFloatValue(v, vNull);');
    end
    else if (AnsicompareText(StrTipo,'boolean')=0) then begin
      // vp.PortConnectorCaption := VariantBooleanValue(v, vNull);
      mmFillProp.Lines.Add(sp(2) + 'vp.F' + cdsPropName.AsString + ' := VariantBooleanValue(v, vNull);');
    end
    else begin
      mmFillProp.Lines.Add(
        sp(2) + ' ==> Tipo: ' + StrTipo + ' no definido en <_GeneraFillProps>');
    end;


    // Siguiente
    cds.Next;
  end;

  mmFillProp.Lines.Add('');
  mmFillProp.Lines.Add('end;');

  // Constante para la Implementacion de los procedimientos de enumerados
  mmFillProp.Lines.Add('');
  mmFillProp.Lines.Add(STR_IMPL_ENUM);


  mmFillProp.Lines.Add('');
  mmFillProp.Lines.Add('end.');

end;

procedure TForm1._GeneraDefCompClass();
var
  i:integer;
  Str:string;
  propField:string;
begin

  mmCompClass.Clear;

  mmCompClass.Lines.Add('  ');  
  mmCompClass.Lines.Add(sp(2) + '//: Implementación para el acceso vía WMI a la clase ' + edtClassName.Text);
  mmCompClass.Lines.Add(sp(2) + __ClassName() +  ' = class(TWMIBase)');
  mmCompClass.Lines.Add(sp(2) + 'private');
  mmCompClass.Lines.Add(sp(4) + 'fConnected:boolean;');
  mmCompClass.Lines.Add(sp(4) + __GetPrivateProps + ': ' + __GetClassProps +';');
  mmCompClass.Lines.Add(sp(2) + 'protected');

  mmCompClass.Lines.Add(sp(4) + '//: Rellenar las propiedades.');
  mmCompClass.Lines.Add(sp(4) + 'procedure FillProperties(AIndex:integer); override;');
  mmCompClass.Lines.Add(sp(4) + '// propiedad Active');
  mmCompClass.Lines.Add(sp(4) + 'procedure SetActive(const Value: Boolean); override;');
  mmCompClass.Lines.Add(sp(4) + '//: Clase para el componente.');
  mmCompClass.Lines.Add(sp(4) + 'function GetWMIClass():string; override;');
  mmCompClass.Lines.Add(sp(4) + '//: Obtener el root.');
  mmCompClass.Lines.Add(sp(4) + 'function GetWMIRoot():string; override;');
  mmCompClass.Lines.Add(sp(4) + '//: Limpiar las propiedades');
  mmCompClass.Lines.Add(sp(4) + 'procedure ClearProps(); override;');

  mmCompClass.Lines.Add(sp(2) + 'public');

  mmCompClass.Lines.Add(sp(4) + '// redefinido el constructor');
  mmCompClass.Lines.Add(sp(4) + 'constructor Create(AOwner: TComponent); override;');
  mmCompClass.Lines.Add(sp(4) + '//: destructor');
  mmCompClass.Lines.Add(sp(4) + 'destructor Destroy; override;');
  mmCompClass.Lines.Add(sp(2) + 'published');

  mmCompClass.Lines.Add(sp(4) + '// propiedades de la ' + edtClassID.Text);
  mmCompClass.Lines.Add(sp(4) + 'property ' + edtClassID.Text + 'Properties:T' + edtClassID.Text +
                        'Properties read F' + edtClassID.Text + 'Properties write F' + edtClassID.Text +
                        'Properties;');

  mmCompClass.Lines.Add(sp(2) + 'end;');

  // Marca para las constantes de los enumerados
  mmCompClass.Lines.Add(STR_EMPTY);
  mmCompClass.Lines.Add(STR_CONT_ENUM);
  mmCompClass.Lines.Add(STR_EMPTY);


{

  mmClass.Clear;

  mmClass.Lines.Add(sp(2) + 'T' + edtClassID.Text + 'Properties = class(TPersistent)');
  mmClass.Lines.Add(sp(2) + 'private');

  cds.First;
  while not (cds.eof) do begin
    propField := 'F' + edtClassID.Text + cdsPropName.AsString;
    Str := propField + CHAR_TWOPOINTS +
           cds.FieldByName('Type').AsString + CHAR_COMMAPOINT;
    mmClass.Lines.Add(sp(4) + Str);
    cds.Next;
  end;

  mmClass.Lines.Add(sp(2) + 'published');

  cds.First;
  while not (cds.eof) do begin
    propField := 'F' + edtClassID.Text + cdsPropName.AsString;
    Str := 'property ' + edtClassID.Text + cdsPropName.AsString + CHAR_TWOPOINTS +
      cds.FieldByName('Type').AsString +
      ' read ' + propField + ' write ' + propField + ' store False;';
    mmClass.Lines.Add(sp(4) + Str);
    cds.Next;
  end;

  mmClass.Lines.Add(sp(2) + 'end;');
}

end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  i, j:integer;
  Str:String;
  TS:TStrings;
  IsArray:Boolean;
begin


  edtClassID.Text := edtClassID2.Text;
  edtClassName.Text := 'Win32_' + edtClassID2.Text;

  if not (cds.Active) then begin
    cds.Open;
  end;

  // Borrar
  cds.First;
  while (not cds.Eof) do begin
    cds.Delete;
  end;


  TS := TStringList.Create();
  try

    // Lineas
    for i := 0 to (mmDefClass.Lines.Count - 1) do begin
      Str := Trim(mmDefClass.Lines[i]);
      Str := AnsiReplaceText(Str, ';', '');

      mmDefClass.Lines[i] := Str;

      j := AnsiPos('[]', Str);

      // no es un array?
      if (j = 0) then begin

        isArray := False;

      end
      else begin
        Str := AnsiReplaceText(Str, '[]', STR_EMPTY);
        isArray := True;
      end;


        TS.Delimiter := ' ';
        TS.DelimitedText := Str;
        try
          cds.Append;
          cdsarray.Value := isArray;
          cdsPropName.Value := TS[1];
          cdsType.Value := TS[0];
          cdsenum.Value := False;
          cds.Post;
        except
          // Nada  ==> continuar
          cds.Cancel;
        end;


    end;

    PageControl1.ActivePageIndex := 0;

  finally
    TS.Free;
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  path:string;
  str:string;
begin
  path := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) +
        DATA_DIRNAME;
  path := IncludeTrailingBackslash(path) + edtClassID2.Text + '_ClassDef' +
          '.ini';

  // Grabar
  mmDefClass.Lines.LoadFromFile(path);
  Str := mmDefClass.Lines[0];
  edtDesc.Text := Str;
  mmDefClass.Lines.Delete(0);
  Str := mmDefClass.Lines[0];
  edtWWW.Text := Str;
  mmDefClass.Lines.Delete(0);


end;

procedure TForm1.Button4Click(Sender: TObject);
var
  path:string;
begin
  path := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName)) +
        DATA_DIRNAME;
  path := IncludeTrailingBackslash(path) + edtClassID2.Text + '_ClassDef' +
          '.ini';

  // Grabar
  mmDefClass.Lines.Insert(0, edtwww.Text);
  mmDefClass.Lines.Insert(0, edtDesc.Text);
  mmDefClass.Lines.SaveToFile(path);
  mmDefClass.Lines.Delete(0);
  mmDefClass.Lines.Delete(0);
  _Log('Grabado con exito ' + path);
end;



procedure TForm1._Log(AMsg: string);
begin
  StatusBar1.SimpleText := AMsg;
end;

procedure TForm1._GenerarCabecera;
const
  CHAR_CRLF = #13#10;
var
  Str:string;
begin

  Str :=
  '{ ' + CHAR_CRLF +

  Format('%s  Component Version 1.8b - Suite GLib ',[__ClassName]) + CHAR_CRLF +
  'Copyright (©) 2009,  by Germán Estévez (Neftalí) ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  Format('  %s',[__GetDesc]) + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  'Utilización/Usage: ' + CHAR_CRLF +
  '  Basta con "soltar" el componente y activarlo. ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '  Place the component in the form and active it. ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '  MSDN Info: ' + CHAR_CRLF +
  Format('  %s ',[__GetWWW]) + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '========================================================================= ' + CHAR_CRLF +
  'IMPORTANTE PROGRAMADORES: Por favor, si tienes comentarios, mejoras, ampliaciones, ' + CHAR_CRLF +
  '  errores y/o cualquier otro tipo de sugerencia envíame un mail a: ' + CHAR_CRLF +
  '  german_ral@hotmail.com ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  'IMPORTANT PROGRAMMERS: please, if you have comments, improvements, enlargements, ' + CHAR_CRLF +
  'errors and/or any another type of suggestion send a mail to: ' + CHAR_CRLF +
  'german_ral@hotmail.com ' + CHAR_CRLF +
  '========================================================================= ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '@author Germán Estévez (Neftalí) ' + CHAR_CRLF +
  Format('@web  %s',[__GetMyWeb]) + CHAR_CRLF +
  '@cat Package GLib ' + CHAR_CRLF +
  '} ' + CHAR_CRLF +
  Format('unit %s; ',[__GetCompName]) + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '{ ' + CHAR_CRLF +
  '========================================================================= ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  Format('  %s.pas ',[__ClassName]) + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '  Componente ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '======================================================================== ' + CHAR_CRLF +
  '  Historia de las Versiones ' + CHAR_CRLF +
  '------------------------------------------------------------------------ ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  Format('  %s    * Creación. ',[FormatDateTime('dd/mm/yyyy', now())]) + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '========================================================================= ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '  Errores detectados no corregidos ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '========================================================================= ' + CHAR_CRLF +
  '} ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '//========================================================================= ' + CHAR_CRLF +
  '// ' + CHAR_CRLF +
  '// I N T E R F A C E ' + CHAR_CRLF +
  '// ' + CHAR_CRLF +
  '//========================================================================= ' + CHAR_CRLF +
  'interface ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  'uses ' + CHAR_CRLF +
  '  Classes, Controls, CWMIBase; ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  'type ';

  mmCabecera.Lines.Text := Str;

end;

function TForm1.__ClassID(): string;
begin
  Result := 'T' + edtClassID.Text;
end;

function TForm1.__GetDesc: string;
begin
  Result := edtDesc.Text;
end;

function TForm1.__GetWWW: string;
begin
  Result := edtWWW.Text;
end;

function TForm1.__GetClassProps: string;
begin
  Result := __ClassID() + 'Properties';  //TPortConnectorProperties
end;

function TForm1.__GetPrivateProps: string;
begin
  Result := 'F' + edtClassID.Text + 'Properties';  //FPortConnectorProperties
end;

function TForm1.__GetPublicProps(): string;
begin
  Result := edtClassID.Text + 'Properties';  //PortConnectorProperties
end;



function TForm1.__GetClassName: string;
begin
  Result := edtClassName.Text;
end;

function TForm1.__GetMyWeb: string;
begin
  Result := 'http://neftali.clubDelphi.com   -  http://neftali-mirror.site11.com/'
end;

function TForm1.__GetCompName: string;
begin
  Result := 'C' + edtClassID.Text + 'Info';
end;

function TForm1.__ClassName(): string;
begin
  Result := 'T' + edtClassID.Text + 'Info';
end;

procedure TForm1._GenerarCabeceraImpl();
const
  CHAR_CRLF = #13#10;
var
  Str:string;
begin

  Str :=
  '    ' + CHAR_CRLF +
  '//========================================================================= ' + CHAR_CRLF +
  '// ' + CHAR_CRLF +
  '// I M P L E M E N T A T I O N ' + CHAR_CRLF +
  '// ' + CHAR_CRLF +
  '//========================================================================= ' + CHAR_CRLF +
  'implementation ' + CHAR_CRLF +
  '  ' + CHAR_CRLF +
  'uses ' + CHAR_CRLF +
  '  {Generales} Forms, Types, Windows, SysUtils, ' + CHAR_CRLF +
  '  {GLib} UProcedures, UConstantes, Dialogs; ' + CHAR_CRLF +
  ' ' + CHAR_CRLF +
  '  ' + CHAR_CRLF +
  Format('{ %s } ',[__ClassID]) + CHAR_CRLF +
  '{-------------------------------------------------------------------------------} ';

  mmCambImpl.Lines.Text := Str;
end;




procedure TForm1._GenerarOtherProcs();
const
  CHAR_CRLF = #13#10;
var
  Str:string;
  bEnum:Boolean;
begin

  mmOther.Clear;

  Str :=
    '//: Constructor del componente ' + CHAR_CRLF +
    'constructor ' + __ClassName + '.Create(AOwner: TComponent); ' + CHAR_CRLF +
    'begin ' + CHAR_CRLF +
    '  inherited; ' + CHAR_CRLF +
    ' ' + CHAR_CRLF +
    '  Self.' + __GetPrivateProps() + ' := ' + __GetClassProps() + '.Create(); ' + CHAR_CRLF +
    '  Self.MSDNHelp := ' + QuotedStr(__GetWWW()) + ';' + CHAR_CRLF +
    'end; ' + CHAR_CRLF +
    ' ' + CHAR_CRLF +
    '// destructor del componente ' + CHAR_CRLF +
    'destructor ' + __ClassName + '.Destroy(); ' + CHAR_CRLF +
    'begin ' + CHAR_CRLF +
    ' ' + CHAR_CRLF +
    '  // liberar ' + CHAR_CRLF +
    '  FreeAndNil(Self.' + __GetPrivateProps() + '); ' + CHAR_CRLF +
    ' ' + CHAR_CRLF +
    '  inherited; ' + CHAR_CRLF +
    'end; ' + CHAR_CRLF +
    ' ' + CHAR_CRLF +
    '// Obtener la clase ' + CHAR_CRLF +
    'function ' + __ClassName + '.GetWMIClass(): string; ' + CHAR_CRLF +
    'begin ' + CHAR_CRLF +
    '  Result := ' + QuotedStr(__GetClassName()) + CHAR_CRLF +
    'end; ' + CHAR_CRLF +
    ' ' + CHAR_CRLF +
    '// Obtener Root ' + CHAR_CRLF +
    'function ' + __ClassName + '.GetWMIRoot(): string; ' + CHAR_CRLF +
    'begin ' + CHAR_CRLF +
    '  Result := STR_CIM2_ROOT; ' + CHAR_CRLF +
    'end; ' + CHAR_CRLF +
    ' ' + CHAR_CRLF +
    '// Active ' + CHAR_CRLF +
    'procedure ' + __ClassName + '.SetActive(const Value: Boolean); ' + CHAR_CRLF +
    'begin ' + CHAR_CRLF +
    '  // método heredado ' + CHAR_CRLF +
    '  inherited; ' + CHAR_CRLF +
    'end; ';

  mmOther.Lines.Text := Str;
  Str := STR_EMPTY;

  // procedimientos para enumerados
  cds.First;
  while not (cds.eof) do begin
    bEnum := cds.FieldByName('enum').AsBoolean;

    // enumerado?
    if (benum) then begin
      Str :=
        '  ' + CHAR_CRLF +
        '//: Recuperar la propiedad  <' + cdsPropName.AsString + 'AsString>' + CHAR_CRLF +
        'function ' + __ClassName + '.' + 'Get' + cdsPropName.AsString + 'AsString():string;' + CHAR_CRLF +
        'begin ' + CHAR_CRLF +
        '  Result := ' + QuotedStr('Not implemented yet') + ';' + CHAR_CRLF +
        'end;' + CHAR_CRLF +
        '  ';
    end;
    cds.Next;
  end;

  mmOther.Lines.Add(Str);

end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i, j, value:Integer;
  str:string;
  TS:TStrings;
  values:boolean;
  valor, LastOK:boolean;
begin

  TS := TStringList.Create();
  TS.AddStrings(mmEnumerado.Lines);
  mmEnumerado.Clear;
  Values := False;
  Valor := true;

  try
    for i := 0 to (TS.Count - 1) do begin
      Str := Trim(TS[i]);

      if (i = 0) then begin
        edtPropiedad.Text := Str;
      end
      else if (AnsiPos('Data type:', Str) <> 0) then begin
        Str := AnsiReplaceText(Str, 'Data type:', STR_EMPTY);
        edtTipo.Text := Trim(Str);
      end
      else if (i > 1) and (not values) then begin
        // Avanzar
        if (AnsiPos('Value	Meaning', Str) = 0) then begin
          // nada
        end
        else begin
          Values := True;
        end;
      end
      else if (Str = STR_EMPTY) then begin
        // nada
      end
      else begin
        if (valor) then begin

          if (cbIncluteHex.Checked) then begin
            Str := Trim(Str);
            j := AnsiPos('(0x', Str);
          end
          else begin
            j := 10;
          end;

          if (j > 0) then begin
            Str := Copy(Str, 1, j-1);

            mmEnumerado.Lines.Add({' -->' +} Str);
            Valor := False;
          end
          else begin
            mmEnumerado.Lines[mmEnumerado.Lines.Count - 1] :=
              mmEnumerado.Lines[mmEnumerado.Lines.Count - 1] + '. ' + Str;
          end;
        end
        else begin
          // STRING
          mmEnumerado.Lines.Add(Str);
          valor := True;
        end;
      end;
    end;

  finally
    FreeAndNil(TS);
  end;

  Exit;

  LastOK := False;

  // Corregir los que tienen más de una línea de texto
  for i := 0 to (mmEnumerado.Lines.Count - 1) do begin

    Str := Trim(mmEnumerado.Lines[i]);
    try
      Value := StrToInt(Str);
      LastOK := True;
    except
      if (LastOK = False) then begin
        mmEnumerado.Lines[i-1] := mmEnumerado.Lines[i-1] + '. ' + Str;
        mmEnumerado.Lines[i] := '  ';
      end;

      // error
      LastOK := False;
    end;

  end;




  

end;

procedure TForm1.Button6Click(Sender: TObject);
var
  i:Integer;
  str, tmpValue:string;
begin

  // limpiar los memos
  if (cbLimpiarGenerar.Checked) then begin
    mmEnumConst.Clear;
    mmEnumGet.Clear;
    mmEnumImpl.Clear;
  end;

  mmEnumConst.Lines.Add('// Constantes para la propiedad ' + edtPropiedad.Text);
  mmEnumConst.Lines.Add('const');

  for i := 0 to (mmEnumerado.Lines.Count-1) do begin

    if (not Odd(i)) then begin
      tmpValue := Trim(mmEnumerado.Lines[i]);
      Str := 'ENUM_STRING_' + UpperCase(edtPropiedad.Text) + '_' +
        tmpValue + ' = ' +
        QuotedStr(mmEnumerado.Lines[i + 1]) + ';';

      mmEnumConst.Lines.Add(sp(2) + Str);
    end;
  end;

  mmEnumConst.Lines.Add('');

  // Procedimiento para la propiedad
  mmEnumGet.Lines.Add(sp(4) + '// Obtener la propiedad <' + edtPropiedad.Text +
      '> como string');
  mmEnumGet.Lines.Add(sp(4) + 'function Get' + edtPropiedad.Text + 'AsString():string;');
//  mmEnumGet.Lines.Add(sp(4));


  // Propiedad
//  mmEnum.Lines.Add('property ' + edtPropiedad.Text + 'AsString:string read '+
//                   'Get' + edtPropiedad.Text + 'AsString write ' +
//                   'F' + edtPropiedad.Text + 'AsString stored False;');
//  mmEnum.Lines.Add('');


  // Implementación
  mmEnumImpl.Lines.Add('');
  mmEnumImpl.Lines.Add('// Obtener la propiedad como string');
  mmEnumImpl.Lines.Add('function ' + __GetClassProps +
        '.Get' + edtPropiedad.Text + 'AsString():string;');
  mmEnumImpl.Lines.Add('begin');
  mmEnumImpl.Lines.Add(sp(2) + 'case F' + edtPropiedad.Text + ' of' );

  for i := 0 to (mmEnumerado.Lines.Count-1) do begin
    if (not Odd(i)) then begin
      tmpValue := Trim(mmEnumerado.Lines[i]);
      Str := tmpValue + ': Result := ' +
             'ENUM_STRING_' + UpperCase(edtPropiedad.Text) + '_' + tmpValue + ';';

      mmEnumImpl.Lines.Add(sp(4) + Str);
    end;
  end;

  mmEnumImpl.Lines.Add(sp(2) + 'else');
  mmEnumImpl.Lines.Add(sp(4) + 'Result := STR_EMPTY;');
  mmEnumImpl.Lines.Add(sp(2) + 'end;');
  mmEnumImpl.Lines.Add('end;');


end;

procedure TForm1.GridDrawColumnCell(Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  Check: Integer; 
  R: TRect; 
begin 
  if (Column.FieldName = 'enum') or (Column.FieldName = 'array') then begin
    Grid.Canvas.FillRect(Rect);
    Check := 0;

    if (cds.FindField(Column.FieldName).AsBoolean) then begin
      Check := DFCS_CHECKED;
    end;

    R:=Rect;
    InflateRect(R,-2,-2); //Disminuye el tamaño del CheckBox
    DrawFrameControl(Grid.Canvas.Handle,R,DFC_BUTTON, DFCS_BUTTONCHECK or Check);
  end;


end;

procedure TForm1.FormShow(Sender: TObject);
begin

  // Ocultar pesañas
//  tsDefClass.TabVisible := False;
  tsClass.TabVisible := False;
  tsClearProc.TabVisible := False;
  tsCab.TabVisible := False;
  tsCompClass.TabVisible := False;
  tsCabImpl.TabVisible := False;
  tsFillProp.TabVisible := False;
  tsOther.TabVisible := False;
  tsPropProcs.TabVisible := False;

end;

procedure TForm1.Button7Click(Sender: TObject);
var
  fName:string;
begin
  fName := IncludeTrailingPathDelimiter(edtFuentes.Text) +
    __GetCompName + '.pas';
  SaveDialog1.FileName := fName;
  SaveDialog1.InitialDir := edtFuentes.Text;
  SaveDialog1.Execute;
  Self.FFileName := SaveDialog1.FileName;

  mmComponente.Lines.SaveToFile(Self.FFileName);
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  TS:TStrings;
  i, j:Integer;
  Str1, Str2:string;
  b:Boolean;
begin


  //TS := TStringList.Create;
  TS := mmComponente.Lines;

  try

//    if FileExists(Self.FFileName) then begin
//      TS.LoadFromFile(Self.FFileName);
//    end
//    else begin
//      Self.FFileName := IncludeTrailingPathDelimiter(edtFuentes.Text) +
//                        __GetCompName + '.pas';
//      if not FileExists(Self.FFileName) then begin
//        Exit;
//        MessageDlg(Format('No se encuentra el fichero de Codigo <%s>.',[FFileName]), mtWarning, [mbOK], 0);
//      end;
//      TS.LoadFromFile(Self.FFileName);
//    end;

    // Buscar los procedimientos de Get
    for i := 0 to (TS.Count - 1) do begin
      Str1 := TS[i];
      // ha encontrado la marca para el procedimiento?
      Str1 := Trim(Str1);
      j := AnsiPos(STR_GET_ENUM, Str1);

      // encontrada?
      if (j <> 0) then begin
        // Añadir las cadenas
        TS.Insert(i, mmEnumGet.Lines.Text);
        Break;
      end;
    end;

    // Buscar las constantes
    for i := 0 to (TS.Count - 1) do begin
      Str1 := TS[i];
      // ha encontrado la marca para el procedimiento?
      Str1 := Trim(Str1);
      j := AnsiPos(STR_CONT_ENUM, Str1);

      // encontrada?
      if (j <> 0) then begin
        // Añadir las cadenas
        TS.Insert(i, mmEnumConst.Lines.Text);
        Break;
      end;
    end;

    // Buscar las implementaciones de los eumerados
    for i := 0 to (TS.Count - 1) do begin
      Str1 := TS[i];
      // ha encontrado la marca para el procedimiento?
      Str1 := Trim(Str1);
      j := AnsiPos(STR_IMPL_ENUM, Str1);

      // encontrada?
      if (j <> 0) then begin
        // Añadir las cadenas
        TS.Insert(i, mmEnumImpl.Lines.Text);
        Break;
      end;
    end;


  finally
//    FreeAndNil(TS);
  end;


end;

end.
