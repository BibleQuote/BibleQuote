unit bqCollectionsEdit;

interface

uses
  Windows, Messages, SysUtils, Variants,  TntStdCtrls, ExtCtrls, TntForms, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees;

type
  TbqCollectionsEditor = class(TtntForm)
    vdtCollectionBookList: TVirtualDrawTree;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  bqCollectionsEditor: TbqCollectionsEditor;

implementation

{$R *.dfm}

end.
