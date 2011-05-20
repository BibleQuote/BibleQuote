unit bqCollectionsEdit;

interface

uses
  Windows, Messages, SysUtils, Variants,  TntStdCtrls, ExtCtrls, TntForms, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, VirtualTrees;

type
  TbqCollectionsEditor = class(TtntForm)
    vstCollections: TVirtualStringTree;
    lbl1: TTntLabel;
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
