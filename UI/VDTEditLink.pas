unit VDTEditLink;

interface

uses Classes, Windows, messages, VirtualTrees, Graphics, Forms, Controls,
  StdCtrls;

type
  IVDTInfo = interface
    procedure GetTextInfo(tree: TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const AFont: TFont; var R: TRect; var Text: string);
    procedure SetNodeText(tree: TVirtualDrawTree; Node: PVirtualNode; Column: TColumnIndex; const Text: string);
  end;

  TbqVTEdit = class(TVTEdit)
  private
    procedure DispatchToGrandparent(var Message: TMessage);
  protected
    procedure WMDestroy(var Message: TWMDestroy); message WM_DESTROY;
    procedure CMExit(var Message: TMessage); message CM_EXIT;
  end;

  TbqVDTEditLink = class(TStringEditLink, IVTEditLink)
  private
    procedure SetEdit(const Value: TbqVTEdit);
  protected
    mVDTInfo: IVDTInfo;

  public
    constructor Create(vdtInfo: IVDTInfo);
    destructor Destroy; override;

    function BeginEdit: Boolean; override; stdcall;
    function CancelEdit: Boolean; override; stdcall;
    function EndEdit: Boolean; override; stdcall;
    function GetBounds: TRect; override; stdcall;
    function PrepareEdit(tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean; override; stdcall;
    procedure ProcessMessage(var Message: TMessage); override; stdcall;
    procedure SetBounds(R: TRect); override; stdcall;
  end;

implementation

{ TbqVDTEditLink }
constructor TbqVDTEditLink.Create(vdtInfo: IVDTInfo);
type
  PClass = ^TClass;
begin
  inherited Create();
  PClass(Edit)^ := TbqVTEdit;
  mVDTInfo := vdtInfo;
end;

destructor TbqVDTEditLink.Destroy;

begin
  inherited;
  mVDTInfo := nil;
end;

// Notifies the edit link that editing can start now. descendants may cancel node edit
// by returning False.
function TbqVDTEditLink.BeginEdit: Boolean;
begin
  Result := not FStopping;
  if Result then
  begin
    Edit.Show;
    Edit.SelectAll;
    Edit.SetFocus;
    TbqVTEdit(Edit).AutoAdjustSize;
  end;
end;

procedure TbqVDTEditLink.SetEdit(const Value: TbqVTEdit);
begin
  if Assigned(Edit) then
    Edit.Free;
  Edit := Value;
end;

function TbqVDTEditLink.CancelEdit: Boolean;
begin
  Result := not FStopping;
  if Result then
  begin
    FStopping := True;
    Edit.Hide;
    FTree.CancelEditNode;
    TbqVTEdit(Edit).FLink := nil;
    TbqVTEdit(Edit).FRefLink := nil;
  end;
end;

function TbqVDTEditLink.EndEdit: Boolean;
begin
  Result := not FStopping;
  if Result then
    try
      FStopping := True;
      if Edit.Modified then;
      mVDTInfo.SetNodeText(TVirtualDrawTree(FTree), FNode, FColumn, TbqVTEdit(Edit).Text);
      Edit.Hide;
      TbqVTEdit(Edit).FLink := nil;
      TbqVTEdit(Edit).FRefLink := nil;
    except
      FStopping := False;
      raise;
    end;
end;

function TbqVDTEditLink.GetBounds: TRect;
begin
  Result := Edit.BoundsRect;
end;

// Retrieves the true text bounds from the owner tree.
function TbqVDTEditLink.PrepareEdit(tree: TBaseVirtualTree; Node: PVirtualNode; Column: TColumnIndex): Boolean;
var
  Text: string;
begin
  Result := tree is TVirtualDrawTree;
  if Result then
  begin
    FTree := TCustomVirtualStringTree(tree);
    FNode := Node;
    FColumn := Column;
    // Initial size, font and text of the node.
    mVDTInfo.GetTextInfo(TVirtualDrawTree(FTree), Node, Column, TbqVTEdit(Edit).Font, FTextBounds, Text);
    TbqVTEdit(Edit).Font.Color := clWindowText;
    Edit.Parent := tree;
    TbqVTEdit(Edit).RecreateWnd;
    Edit.HandleNeeded;
    Edit.Text := Text;
    if Column <= NoColumn then
    begin
      Edit.BidiMode := FTree.BidiMode;
      FAlignment := TVirtualDrawTree(FTree).Alignment;
    end
    else
    begin
      Edit.BidiMode := TVirtualDrawTree(FTree).Header.Columns[Column].BidiMode;
      FAlignment := TVirtualDrawTree(FTree).Header.Columns[Column].Alignment;
    end;

    if Edit.BidiMode <> bdLeftToRight then
      ChangeBidiModeAlignment(FAlignment);
  end;
end;

procedure TbqVDTEditLink.ProcessMessage(var Message: TMessage);
begin
  Edit.WindowProc(Message);
end;

// Sets the outer bounds of the edit control and the actual edit area in the control.
procedure TbqVDTEditLink.SetBounds(R: TRect);
var
  lOffset: Integer;
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
      Edit.BoundsRect := R;

      // The selected text shall exclude the text margins and be centered vertically.
      // We have to take out the two pixel border of the edit control as well as a one pixel "edit border" the
      // control leaves around the (selected) text.
      R := Edit.ClientRect;
      lOffset := 2;
      if tsUseThemes in FTree.TreeStates then
        Inc(lOffset);
      InflateRect(R, -TVirtualDrawTree(FTree).TextMargin + lOffset, lOffset);
      if not(vsMultiline in FNode.States) then
        OffsetRect(R, 0, FTextBounds.Top - Edit.Top);

      SendMessage(Edit.Handle, EM_SETRECTNP, 0, Integer(@R));
    end;
  end;
end;

{ TbqVTEdit }

procedure TbqVTEdit.DispatchToGrandparent(var Message: TMessage);
var
  oldClass: TClass;
type
  PClass = ^TClass;
begin
  // prevent message handling in the base class
  oldClass := PClass(Self)^;
  try
    // handle message in grandparent class (TCustomEdit)
    PClass(Self)^ := TCustomEdit;
    Self.Dispatch(Message);
  finally
    PClass(Self)^ := oldClass;
  end;
end;

procedure TbqVTEdit.CMExit(var Message: TMessage);
var
  parentTree: TBaseVirtualTree;
begin
  DispatchToGrandparent(Message);

  if (Parent is TBaseVirtualTree) then
  begin
    parentTree := TBaseVirtualTree(Parent);
    if (parentTree.IsEditing) then
      parentTree.EndEditNode();
  end;
end;

procedure TbqVTEdit.WMDestroy(var Message: TWMDestroy);
begin
  DispatchToGrandparent(TMessage(Message));
end;

end.
