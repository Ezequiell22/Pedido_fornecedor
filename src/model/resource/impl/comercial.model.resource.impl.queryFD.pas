unit comercial.model.resource.impl.queryFD;

interface

uses
  Data.DB,
  System.SysUtils,
  FireDAC.Comp.Client,
  FireDAC.Stan.Param,
  comercial.model.resource.impl.factory,
  comercial.model.resource.interfaces,
  comercial.util.log;

type
  TModelResourceQueryFD = class(TInterfacedObject, iQuery)
  private
    FQuery: TFDQuery;
    FConexao: iConexao;
    FConnection: TCustomConnection;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: iQuery;
    function active(aValue: boolean): iQuery;
    function addParam(aParam: string; aValue: Variant): iQuery;
    function DataSet: TDataSet;
    function execSql(commit: Boolean = True): iQuery;
    function open: iQuery;
    function sqlClear: iQuery;
    function sqlAdd(aValue: string): iQuery;
    function isEmpty: boolean;
    function eof: boolean;
    procedure next;
  end;

implementation

function TModelResourceQueryFD.active(aValue: boolean): iQuery;
begin
  Result := Self;
  FQuery.Active := aValue;
end;

function TModelResourceQueryFD.addParam(aParam: string; aValue: Variant): iQuery;
begin
  Result := Self;
  FQuery.ParamByName(aParam).Value := aValue;
end;

constructor TModelResourceQueryFD.Create;
begin
  FQuery := TFDQuery.Create(nil);
  FConexao := TResource.New.Conexao;
  FConnection := FConexao.Connect;
  FQuery.Connection := TFDConnection(FConnection);
end;

function TModelResourceQueryFD.DataSet: TDataSet;
begin
  Result := FQuery;
end;

destructor TModelResourceQueryFD.Destroy;
begin
  FQuery.Free;
  inherited;
end;

function TModelResourceQueryFD.eof: boolean;
begin
  Result := FQuery.Eof;
end;

function TModelResourceQueryFD.execSql(commit: Boolean = True): iQuery;
begin
  Result := Self;
  try
    FQuery.ExecSQL;
  except
    on E: Exception do
    begin
      TLog.Error('SQL Exec: ' + FQuery.SQL.Text + ' | ' + E.ClassName + ' | ' + E.Message);
      raise Exception.Create(E.Message);
    end;
  end;
end;

function TModelResourceQueryFD.isEmpty: boolean;
begin
  Result := FQuery.IsEmpty;
end;

class function TModelResourceQueryFD.New: iQuery;
begin
  Result := Self.Create;
end;

procedure TModelResourceQueryFD.next;
begin
  FQuery.Next;
end;

function TModelResourceQueryFD.open: iQuery;
begin
  try
    FQuery.Open;
  except
    on E: Exception do
    begin
      TLog.Error('SQL Open: ' + FQuery.SQL.Text + ' | ' + E.ClassName + ' | ' + E.Message);
      raise;
    end;
  end;
end;

function TModelResourceQueryFD.sqlAdd(aValue: string): iQuery;
begin
  Result := Self;
  FQuery.SQL.Add(aValue);
end;

function TModelResourceQueryFD.sqlClear: iQuery;
begin
  Result := Self;
  FQuery.SQL.Clear;
end;

end.
