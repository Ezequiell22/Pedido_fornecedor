unit comercial.model.resource.interfaces;

interface

uses
  Data.DB;

type

  iQuery = interface
    ['{2C301581-2B46-4318-B344-E30883A1EB74}']
    function active(aValue: boolean): iQuery;
    function addParam(aParam: string; aValue: Variant): iQuery;
    function DataSet: TDataSet;
    function execSql(commit: boolean = True): iQuery;
    function open: iQuery;
    function sqlClear: iQuery;
    function sqlAdd(aValue: string): iQuery;
    function isEmpty: boolean;
    function eof: boolean;
    procedure next;
  end;

  iConexao = interface
    function Connect: TCustomConnection;
  end;

  iResource = interface
    function Conexao: iConexao;
  end;

implementation

end.
