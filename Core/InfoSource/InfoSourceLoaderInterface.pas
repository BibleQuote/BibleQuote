unit InfoSourceLoaderInterface;

interface

uses InfoSource;

type

  IInfoSourceLoader = interface
    ['{2FE3B472-F513-4AFC-B562-686E48B13C0F}']
    procedure LoadInfoSource(aFileEntryPath: String; aInfoSource: TInfoSource);
  end;

implementation

end.
