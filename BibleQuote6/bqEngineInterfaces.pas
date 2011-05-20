unit bqEngineInterfaces;

interface
uses Dict;
type
  TBibleQuoteStateEntries=(bqsDictionariesLoading,bqsDictionariesLoaded,
        bqsDictionariesListCreating, bqsDictionariesListCreated,
        bqsVerseListEngineInitializing,bqsVerseListEngineInitialized
  );
  TBibleQuoteState=set of TBibleQuoteStateEntries;
  IbqEngineDicTraits=interface
 ['{14ED0EC0-45FE-1FD6-F1F0-424EADE47A66}']
  function AddDictionary(aDictionary:TDict):Cardinal;
  function DictionariesCount():Cardinal;
  function GetDictionary(aIndex:Cardinal):TDict;
  end;
  IbqEngineAsyncTraits=interface
 ['{14ED0EC0-45FE-1FD6-F1F0-514ED4347A80}']
  procedure AsyncStateCompleted(state:TBibleQuoteStateEntries; res:HRESULT);
  end;

implementation

end.
