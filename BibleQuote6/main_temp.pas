unit main_temp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, TntForms,
  Dialogs, StdCtrls, Htmlview, Menus, TntMenus, ExtCtrls, TntExtCtrls, ComCtrls,
  TntComCtrls, TntDialogs, TntStdCtrls, ToolWin;

type
  TForm1 = class(TTntForm)
    TntPageControl1: TTntPageControl;
    TntTabSheet1: TTntTabSheet;
    TntTabSheet2: TTntTabSheet;
    TntSplitter1: TTntSplitter;
    TntMainMenu1: TTntMainMenu;
    TntPanel1: TTntPanel;
    TntPanel2: TTntPanel;
    TntPageControl2: TTntPageControl;
    TntTabSheet3: TTntTabSheet;
    HTMLViewer1: THTMLViewer;
    File1: TTntMenuItem;
    Open1: TTntMenuItem;
    TabsFavorite: TTntPageControl;
    TabFavorite1: TTntTabSheet;
    TabFavorite2: TTntTabSheet;
    TabFavorite3: TTntTabSheet;
    TabFavorite4: TTntTabSheet;
    COPY1: TTntMenuItem;
    OpenDialog1: TOpenDialog;
    procedure Open1Click(Sender: TObject);
    procedure TntButton1Click(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure COPY1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.COPY1Click(Sender: TObject);
begin
  Form1.Caption := HTMLViewer1.SelText;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    HTMLViewer1.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.TntButton1Click(Sender: TObject);
begin
  Form1.Caption := HTMLViewer1.SelText;
end;

procedure TForm1.TntFormShow(Sender: TObject);
begin
  TabsFavorite.ActivePageIndex := -1;
end;

end.
