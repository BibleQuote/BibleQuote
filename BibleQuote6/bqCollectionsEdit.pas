unit bqCollectionsEdit;

interface

uses
  Windows, Messages, SysUtils, Variants,  ExtCtrls, TntForms, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees;

type
  TbqCollectionsEditor = class(TtntForm)
    vstCollections: TVirtualStringTree;
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
