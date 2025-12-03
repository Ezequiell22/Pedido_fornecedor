unit comercial.model.db.migrations.seed;

interface

type
  TDbMigrationsSeed = class
  public
    procedure Apply(const AExcelPath: string);
  private
    procedure ApplyFromXlsx(const AFilePath: string);
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.StrUtils,
  System.Zip,
  System.Variants,
  System.Generics.Collections,
  Xml.XMLDoc,
  Xml.XMLIntf,
  Data.DB,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD;

procedure TDbMigrationsSeed.Apply(const AExcelPath: string);
var
  Q: iQuery;
  SL: TStringList;
  i: Integer;
  L: TArray<string>;
  fn: string;
  folder: string;
begin
  if SameText(ExtractFileExt(AExcelPath), '.xlsx') and FileExists(AExcelPath) then
  begin
    ApplyFromXlsx(AExcelPath);
    Exit;
  end;

end;
function ColIndex(const Ref: string): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(Ref) do
  begin
    if CharInSet(Ref[i], ['A'..'Z']) then
      Result := Result * 26 + (Ord(Ref[i]) - Ord('A') + 1)
    else
      Break;
  end;
  Dec(Result);
end;

function LocalName(const S: string): string;
var
  p: Integer;
begin
  p := LastDelimiter(':', S);
  if p > 0 then
    Result := Copy(S, p + 1, MaxInt)
  else
    Result := S;
end;

function FindChildByLocalName(const N: IXMLNode; const Name: string): IXMLNode;
var
  i: Integer;
begin
  Result := nil;
  if N = nil then Exit;
  for i := 0 to N.ChildNodes.Count - 1 do
    if SameText(LocalName(N.ChildNodes[i].NodeName), Name) then
      Exit(N.ChildNodes[i]);
end;

function FindChildrenByLocalName(const N: IXMLNode; const Name: string): TArray<IXMLNode>;
var
  i, k: Integer;
begin
  k := 0;
  SetLength(Result, 0);
  if N = nil then Exit;
  for i := 0 to N.ChildNodes.Count - 1 do
    if SameText(LocalName(N.ChildNodes[i].NodeName), Name) then
    begin
      Inc(k);
      SetLength(Result, k);
      Result[k-1] := N.ChildNodes[i];
    end;
end;

function LoadXmlFromZip(const Zip: TZipFile; const Path: string): IXMLDocument;
var
  idx: Integer;
  ms: TMemoryStream;
  bytes: TBytes;
begin
  Result := TXMLDocument.Create(nil);
  idx := Zip.IndexOf(Path);
  if idx < 0 then Exit;
  ms := TMemoryStream.Create;
  try
    Zip.Read(idx, bytes);
    if Length(bytes) > 0 then
    begin
      ms.WriteBuffer(bytes, Length(bytes));
      ms.Position := 0;
    end;
    ms.Position := 0;
    (Result as IXMLDocument).LoadFromStream(ms);
    (Result as IXMLDocument).Active := True;
  finally
    ms.Free;
  end;
end;

function ReadSharedStrings(const Zip: TZipFile): TArray<string>;
var
  doc: IXMLDocument;
  si, tNode: IXMLNode;
  i, j: Integer;
  parts: TArray<IXMLNode>;
begin
  doc := LoadXmlFromZip(Zip, 'xl/sharedStrings.xml');
  if doc = nil then Exit;
  SetLength(Result, doc.DocumentElement.ChildNodes.Count);
  for i := 0 to doc.DocumentElement.ChildNodes.Count - 1 do
  begin
    si := doc.DocumentElement.ChildNodes[i];
    Result[i] := '';
    parts := FindChildrenByLocalName(si, 't');
    if Length(parts) = 0 then
    begin
      tNode := FindChildByLocalName(si, 't');
      if tNode <> nil then
        Result[i] := tNode.Text;
    end
    else
    begin
      for j := 0 to Length(parts) - 1 do
        Result[i] := Result[i] + parts[j].Text;
    end;
  end;
end;

function ReadSheetRows(const Zip: TZipFile; const SheetPath: string; const Shared: TArray<string>): TArray<TArray<string>>;
var
  doc: IXMLDocument;
  worksheetNode, sheetData, rowNode, cellNode, vNode: IXMLNode;
  rIdx, cIdx, maxCol, i, j: Integer;
  rows: TList<TArray<string>>;
  rowArr: TArray<string>;
  ref, tVal, vText: string;
begin
  rows := TList<TArray<string>>.Create;
  try
    doc := LoadXmlFromZip(Zip, SheetPath);
    if (doc = nil) or (doc.DocumentElement = nil) then
    begin
      Result := nil;
      Exit;
    end;
    worksheetNode := doc.DocumentElement;
    sheetData := FindChildByLocalName(worksheetNode, 'sheetData');
    if sheetData = nil then
    begin
      Result := nil;
      Exit;
    end;
    for i := 0 to sheetData.ChildNodes.Count - 1 do
    begin
      rowNode := sheetData.ChildNodes[i];
      if not SameText(LocalName(rowNode.NodeName), 'row') then
        Continue;
      rIdx := StrToIntDef(VarToStr(rowNode.Attributes['r']), 0);
      if rIdx = 1 then
        Continue;
      maxCol := 0;
      for j := 0 to rowNode.ChildNodes.Count - 1 do
      begin
        cellNode := rowNode.ChildNodes[j];
        if not SameText(LocalName(cellNode.NodeName), 'c') then
          Continue;
        ref := VarToStr(cellNode.Attributes['r']);
        cIdx := ColIndex(ref);
        if cIdx > maxCol then maxCol := cIdx;
      end;
      SetLength(rowArr, maxCol + 1);
      for j := 0 to rowNode.ChildNodes.Count - 1 do
      begin
        cellNode := rowNode.ChildNodes[j];
        if not SameText(LocalName(cellNode.NodeName), 'c') then
          Continue;
        ref := VarToStr(cellNode.Attributes['r']);
        cIdx := ColIndex(ref);
        tVal := VarToStr(cellNode.Attributes['t']);
        vNode := FindChildByLocalName(cellNode, 'v');
        vText := '';
        if vNode <> nil then
          vText := vNode.Text;
        if SameText(tVal, 's') then
        begin
          if (Length(Shared) > 0) and (vText <> '') then
            vText := Shared[StrToIntDef(vText, 0)];
        end;
        rowArr[cIdx] := vText;
      end;
      rows.Add(rowArr);
    end;
    Result := rows.ToArray;
  finally
    rows.Free;
  end;
end;

function VStr(const S: string): Variant;
begin
  if Trim(S) = '' then
    Result := Null
  else
    Result := S;
end;

function VInt(const S: string): Variant;
var
  v: Integer;
begin
  if TryStrToInt(Trim(S), v) then
    Result := v
  else
    Result := Null;
end;

function VFloat(const S: string): Variant;
var
  f: Double;
begin
  if TryStrToFloat(Trim(S), f) then
    Result := f
  else
    Result := Null;
end;

function VDate(const S: string): Variant;
var
  f: Double;
  d: TDateTime;
begin
  if TryStrToFloat(Trim(S), f) then
  begin
    d := f;
    Result := VarFromDateTime(d);
    Exit;
  end;
  if TryStrToDate(Trim(S), d) then
    Result := VarFromDateTime(d)
  else
    Result := Null;
end;

procedure TDbMigrationsSeed.ApplyFromXlsx(const AFilePath: string);
var
  Zip: TZipFile;
  Shared: TArray<string>;
  Rows: TArray<TArray<string>>;
  Q: iQuery;
  i: Integer;
begin
  Zip := TZipFile.Create;
  try
    Zip.Open(AFilePath, zmRead);
    Shared := ReadSharedStrings(Zip);
    Q := TModelResourceQueryFD.New;

    Q.active(False).sqlClear.sqlAdd('delete from fornecedores')
    .execSql();

    Rows := ReadSheetRows(Zip, 'xl/worksheets/sheet1.xml', Shared);
    for i := 0 to Length(Rows) - 1 do
      if Length(Rows[i]) >= 7 then
        Q.active(False).sqlClear
          .sqlAdd('insert into FORNECEDORES (COD_CLIFOR, RAZAO, COD_ESTADO, FANTASIA, COD_PAIS, CLIENTE, FORNEC) values (:COD_CLIFOR, :RAZAO, :COD_ESTADO, :FANTASIA, :COD_PAIS, :CLIENTE, :FORNEC)')
          .addParam('COD_CLIFOR', VInt(Rows[i][0]))
          .addParam('RAZAO', VStr(Rows[i][1]))
          .addParam('COD_ESTADO', VStr(Rows[i][2]))
          .addParam('FANTASIA', VStr(Rows[i][3]))
          .addParam('COD_PAIS', VStr(Rows[i][4]))
          .addParam('CLIENTE', VStr(Rows[i][5]))
          .addParam('FORNEC', VStr(Rows[i][6]))
          .execSql;

    Q.active(False).sqlClear.sqlAdd('delete from PEDIDO_COMPRA')
    .execSql();

    Rows := ReadSheetRows(Zip, 'xl/worksheets/sheet3.xml', Shared);
    for i := 0 to Length(Rows) - 1 do
    begin
        Q.active(False).sqlClear
          .sqlAdd('insert into PEDIDO_COMPRA (COD_PEDIDOCOMPRA, COD_CLIFOR, COD_USUARIO, TOTAL, COD_EMPRESA, COD_FILIAL, COD_DEPARTAMENTO, COD_CENTRO_CUSTO, DT_EMISSAO, COD_CONDPAGTO, ORDEM_COMPRA, VALOR_IMPOSTOS, COD_COMPRADOR, PESO, VOLUME, COD_TIPOFRETE, DATA_PREVISTA_ENTREGA, DT_ENTREGA, TIPO_COMPRA) values (:COD_PEDIDOCOMPRA, :COD_CLIFOR, :COD_USUARIO, :TOTAL, :COD_EMPRESA, :COD_FILIAL, :COD_DEPARTAMENTO, :COD_CENTRO_CUSTO, :DT_EMISSAO, :COD_CONDPAGTO, :ORDEM_COMPRA, :VALOR_IMPOSTOS, :COD_COMPRADOR, :PESO, :VOLUME, :COD_TIPOFRETE, :DATA_PREVISTA_ENTREGA, :DT_ENTREGA, :TIPO_COMPRA)')
          .addParam('COD_PEDIDOCOMPRA', VInt(Rows[i][0]))
          .addParam('COD_CLIFOR', VInt(Rows[i][1]))
          .addParam('COD_USUARIO', VInt(Rows[i][2]))
          .addParam('TOTAL', VFloat(Rows[i][3]))
          .addParam('COD_EMPRESA', VInt(Rows[i][4]))
          .addParam('COD_FILIAL', VInt(Rows[i][5]))
          .addParam('COD_DEPARTAMENTO', VInt(Rows[i][6]))
          .addParam('COD_CENTRO_CUSTO', VInt(Rows[i][7]))
          .addParam('DT_EMISSAO', VDate(Rows[i][8]))
          .addParam('COD_CONDPAGTO', VInt(Rows[i][9]))
          .addParam('ORDEM_COMPRA', VStr(Rows[i][10]))
          .addParam('VALOR_IMPOSTOS', VFloat(Rows[i][11]))
          .addParam('COD_COMPRADOR', VInt(Rows[i][12]))
          .addParam('PESO', VFloat(Rows[i][13]))
          .addParam('VOLUME', VFloat(Rows[i][14]))
          .addParam('COD_TIPOFRETE', VInt(Rows[i][15]))
          .addParam('DATA_PREVISTA_ENTREGA', VDate(Rows[i][16]))
          .addParam('DT_ENTREGA', VDate(Rows[i][17]))
          .addParam('TIPO_COMPRA', VStr(Rows[i][18]))
          .execSql;
    end;

    Q.active(False).sqlClear.sqlAdd('delete from PEDCOMPRA_ITEM')
    .execSql();
    Rows := ReadSheetRows(Zip, 'xl/worksheets/sheet2.xml', Shared);
    for i := 0 to Length(Rows) - 1 do
      if Length(Rows[i]) >= 5 then
        Q.active(False).sqlClear
          .sqlAdd('insert into PEDCOMPRA_ITEM (COD_PEDIDOCOMPRA, COD_PRODUTO, QUANTIDADE, VL_UNITARIO, VL_TOTAL) values (:COD_PEDIDOCOMPRA, :COD_PRODUTO, :QUANTIDADE, :VL_UNITARIO, :VL_TOTAL)')
          .addParam('COD_PEDIDOCOMPRA', VInt(Rows[i][0]))
          .addParam('COD_PRODUTO', VInt(Rows[i][1]))
          .addParam('QUANTIDADE', VFloat(Rows[i][2]))
          .addParam('VL_UNITARIO', VFloat(Rows[i][3]))
          .addParam('VL_TOTAL', VFloat(Rows[i][4]))
          .execSql;
  finally
    Zip.Close;
    Zip.Free;
  end;
end;

end.

