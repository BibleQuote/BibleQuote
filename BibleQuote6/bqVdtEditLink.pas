unit bqVdtEditLink;

interface
uses Classes,Windows,messages, VirtualTrees,Graphics;
type
  IVDTInfo=interface
    procedure GetTextInfo(tree:TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const AFont: TFont; var R: TRect;
      var Text: UnicodeString);
    procedure SetNodeText(tree:TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const Text: UnicodeString);
  end;
  TbqVTEdit=class(TVTEdit)
  end;
  TbqVDTEditLink = class(TStringEditLink, IVTEditLink)
  private
    //FEdit: TbqVTEdit;                  // A normal custom edit control.
    procedure SetEdit(const Value: TbqVTEdit);
  protected
    mVDTInfo:IVDTInfo;
//    FTree: TVirtualDrawTree; // A back reference to the tree calling.
//    FNode: PVirtualNode;             // The node to be edited.
//    FColumn: TColumnIndex;           // The column of the node.
//    FAlignment: TAlignment;
//    FTextBounds: TRect;              // Smallest rectangle around the text.
//    FStopping: Boolean;              // Set to True when the edit link requests stopping the edit action.
  public
    constructor Create(vdtInfo:IVDTInfo);
    destructor Destroy; override;

    function BeginEdit: Boolean; override; stdcall;
    function CancelEdit: Boolean; override; stdcall;
//    property Edit: TbqVTEdit read FEdit write SetEdit;
    function EndEdit: Boolean; override; stdcall;
    function GetBounds: TRect; override; stdcall;
    function PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; override; stdcall;
    procedure ProcessMessage(var Message: TMessage); override; stdcall;
    procedure SetBounds(R: TRect); override; stdcall;
  end;

implementation
uses Forms,Controls;
//----------------- TbqVDTEditLink ------------------------------------------------------------------------------------

constructor TbqVDTEditLink.Create(vdtInfo:IVDTInfo);

begin
 inherited Create();
  mVDTInfo:=vdtInfo;

end;

//----------------------------------------------------------------------------------------------------------------------

destructor TbqVDTEditLink.Destroy;

begin
inherited;
mVDTInfo:=nil;
end;

//----------------------------------------------------------------------------------------------------------------------

function TbqVDTEditLink.BeginEdit: Boolean;

// Notifies the edit link that editing can start now. descendants may cancel node edit
// by returning False.

begin
  Result := not FStopping;
  if Result then
  begin
    FEdit.Show;
    FEdit.SelectAll;
    FEdit.SetFocus;
    TbqVTEdit(FEdit).AutoAdjustSize;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TbqVDTEditLink.SetEdit(const Value: TbqVTEdit);

begin
  if Assigned(FEdit) then
    FEdit.Free;
  FEdit := Value;
end;

//----------------------------------------------------------------------------------------------------------------------

function TbqVDTEditLink.CancelEdit: Boolean;

begin
  Result := not FStopping;
  if Result then
  begin
    FStopping := True;
    FEdit.Hide;
    FTree.CancelEditNode;
    TbqVTEdit(FEdit).FLink := nil;
    TbqVTEdit(FEdit).FRefLink := nil;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TbqVDTEditLink.EndEdit: Boolean;

begin
  Result := not FStopping;
  if Result then
  try
    FStopping := True;
    if FEdit.Modified then
    ;
    mVDTInfo.SetNodeText( TVirtualDrawTree(FTree) , FNode, FColumn, TbqVTEdit(FEdit).Text);
///      FTree.Text[FNode, FColumn] := FEdit.Text;
    FEdit.Hide;
    TbqVTEdit(FEdit).FLink := nil;
    TbqVTEdit(FEdit).FRefLink := nil;
  except
    FStopping := False;
    raise;
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

function TbqVDTEditLink.GetBounds: TRect;

begin
  Result := FEdit.BoundsRect;
end;

//----------------------------------------------------------------------------------------------------------------------

function TbqVDTEditLink.PrepareEdit(Tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;

// Retrieves the true text bounds from the owner tree.

var
  Text: UnicodeString;

begin
  Result := Tree is TVirtualDrawTree;
  if Result then
  begin
    FTree := TCustomVirtualStringTree ( Tree );
    FNode := Node;
    FColumn := Column;
    // Initial size, font and text of the node.
    mVDTInfo.GetTextInfo(TVirtualDrawTree(FTree), Node, Column, TbqVTEdit(FEdit).Font, FTextBounds, Text);
   TbqVTEdit(FEdit).Font.Color := clWindowText;
    FEdit.Parent := Tree;
    TbqVTEdit(FEdit).RecreateWnd;
    FEdit.HandleNeeded;
    FEdit.Text := Text;

    if Column <= NoColumn then
    begin
      FEdit.BidiMode := FTree.BidiMode;
      FAlignment := TVirtualDrawTree(FTree).Alignment;
    end
    else
    begin
      FEdit.BidiMode := TVirtualDrawTree(FTree).Header.Columns[Column].BidiMode;
      FAlignment := TVirtualDrawTree(FTree).Header.Columns[Column].Alignment;
    end;

    if FEdit.BidiMode <> bdLeftToRight then
      ChangeBidiModeAlignment(FAlignment);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TbqVDTEditLink.ProcessMessage(var Message: TMessage);

begin
  FEdit.WindowProc(Message);
end;

//----------------------------------------------------------------------------------------------------------------------

procedure TbqVDTEditLink.SetBounds(R: TRect);

// Sets the outer bounds of the edit control and the actual edit area in the control.

var
  Offset: Integer;

begin
  if not FStopping then
  begin
    with R do
    begin
      // Set the edit's bounds but make sure there's a minimum width and the right border does not
      // extend beyond the parent's left/right border.
      if Left < 0 then
        Left := 0;
      if Right - Left < 30 then
      begin
        if FAlignment = taRightJustify then
          Left := Right - 30
        else
          Right := Left + 30;
      end;
      if Right > FTree.ClientWidth then
        Right := FTree.ClientWidth;
      FEdit.BoundsRect := R;

      // The selected text shall exclude the text margins and be centered vertically.
      // We have to take out the two pixel border of the edit control as well as a one pixel "edit border" the
      // control leaves around the (selected) text.
      R := FEdit.ClientRect;
      Offset := 2;
      if tsUseThemes in FTree.TreeStates then
        Inc(Offset);
      InflateRect(R, -TVirtualDrawTree(FTree).TextMargin + Offset, Offset);
      if not (vsMultiline in FNode.States) then
        OffsetRect(R, 0, FTextBounds.Top - FEdit.Top);

      SendMessage(FEdit.Handle, EM_SETRECTNP, 0, Integer(@R));
    end;
  end;
end;
end.
