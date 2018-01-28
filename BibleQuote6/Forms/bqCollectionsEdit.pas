unit bqCollectionsEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, VirtualTrees;

type
  TbqCollectionsEditor = class(TForm)
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
