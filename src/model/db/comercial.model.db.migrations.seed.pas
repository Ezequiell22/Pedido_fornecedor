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
  if DirectoryExists(AExcelPath) then
    folder := AExcelPath
  else
    folder := ExtractFilePath(AExcelPath);
  Q := TModelResourceQueryFD.New;
  SL := TStringList.Create;
  try
    fn := IncludeTrailingPathDelimiter(folder) + 'FORNECEDORES.csv';
    if FileExists(fn) then
    begin
      SL.LoadFromFile(fn);
      for i := 1 to SL.Count - 1 do
      begin
        L := SplitString(SL[i], ';');
        if Length(L) = 1 then
          L := SplitString(SL[i], ',');
        if Length(L) >= 7 then
          Q.active(False).sqlClear
            .sqlAdd('insert into FORNECEDORES (COD_CLIFOR, RAZAO, COD_ESTADO, FANTASIA, COD_PAIS, CLIENTE, FORNEC) values (:COD_CLIFOR, :RAZAO, :COD_ESTADO, :FANTASIA, :COD_PAIS, :CLIENTE, :FORNEC)')
            .addParam('COD_CLIFOR', L[0])
            .addParam('RAZAO', L[1])
            .addParam('COD_ESTADO', L[2])
            .addParam('FANTASIA', L[3])
            .addParam('COD_PAIS', L[4])
            .addParam('CLIENTE', L[5])
            .addParam('FORNEC', L[6])
            .execSql;
      end;
    end;

    fn := IncludeTrailingPathDelimiter(folder) + 'PEDIDO_COMPRA.csv';
    if FileExists(fn) then
    begin
      SL.LoadFromFile(fn);
      for i := 1 to SL.Count - 1 do
      begin
        L := SplitString(SL[i], ';');
        if Length(L) = 1 then
          L := SplitString(SL[i], ',');
        if Length(L) >= 19 then
          Q.active(False).sqlClear
            .sqlAdd('insert into PEDIDO_COMPRA (COD_PEDIDOCOMPRA, COD_CLIFOR, COD_USUARIO, TOTAL, COD_EMPRESA, COD_FILIAL, COD_DEPARTAMENTO, COD_CENTRO_CUSTO, DT_EMISSAO, COD_CONDPAGTO, ORDEM_COMPRA, VALOR_IMPOSTOS, COD_COMPRADOR, PESO, VOLUME, COD_TIPOFRETE, DATA_PREVISTA_ENTREGA, DT_ENTREGA, TIPO_COMPRA) values (:COD_PEDIDOCOMPRA, :COD_CLIFOR, :COD_USUARIO, :TOTAL, :COD_EMPRESA, :COD_FILIAL, :COD_DEPARTAMENTO, :COD_CENTRO_CUSTO, :DT_EMISSAO, :COD_CONDPAGTO, :ORDEM_COMPRA, :VALOR_IMPOSTOS, :COD_COMPRADOR, :PESO, :VOLUME, :COD_TIPOFRETE, :DATA_PREVISTA_ENTREGA, :DT_ENTREGA, :TIPO_COMPRA)')
            .addParam('COD_PEDIDOCOMPRA', L[0])
            .addParam('COD_CLIFOR', L[1])
            .addParam('COD_USUARIO', L[2])
            .addParam('TOTAL', L[3])
            .addParam('COD_EMPRESA', L[4])
            .addParam('COD_FILIAL', L[5])
            .addParam('COD_DEPARTAMENTO', L[6])
            .addParam('COD_CENTRO_CUSTO', L[7])
            .addParam('DT_EMISSAO', L[8])
            .addParam('COD_CONDPAGTO', L[9])
            .addParam('ORDEM_COMPRA', L[10])
            .addParam('VALOR_IMPOSTOS', L[11])
            .addParam('COD_COMPRADOR', L[12])
            .addParam('PESO', L[13])
            .addParam('VOLUME', L[14])
            .addParam('COD_TIPOFRETE', L[15])
            .addParam('DATA_PREVISTA_ENTREGA', L[16])
            .addParam('DT_ENTREGA', L[17])
            .addParam('TIPO_COMPRA', L[18])
            .execSql;
      end;
    end;

    fn := IncludeTrailingPathDelimiter(folder) + 'PEDCOMPRA_ITEM.csv';
    if FileExists(fn) then
    begin
      SL.LoadFromFile(fn);
      for i := 1 to SL.Count - 1 do
      begin
        L := SplitString(SL[i], ';');
        if Length(L) = 1 then
          L := SplitString(SL[i], ',');
        if Length(L) >= 19 then
          Q.active(False).sqlClear
            .sqlAdd('insert into PEDCOMPRA_ITEM (COD_PEDIDOCOMPRA, COD_PRODUTO, QUANTIDADE, VL_UNITARIO, VL_TOTAL, COD_EMPRESA, COD_FILIAL, COD_DEPARTAMENTO, COD_CENTRO_CUSTO, DESCONTO, ACRESCIMO, IPI, VALOR_IPI, PESO, VOLUME, SEQUENCIA, DT_INCLUSAO, DT_SOLICITADA, DT_RECEBIDA) values (:COD_PEDIDOCOMPRA, :COD_PRODUTO, :QUANTIDADE, :VL_UNITARIO, :VL_TOTAL, :COD_EMPRESA, :COD_FILIAL, :COD_DEPARTAMENTO, :COD_CENTRO_CUSTO, :DESCONTO, :ACRESCIMO, :IPI, :VALOR_IPI, :PESO, :VOLUME, :SEQUENCIA, :DT_INCLUSAO, :DT_SOLICITADA, :DT_RECEBIDA)')
            .addParam('COD_PEDIDOCOMPRA', L[0])
            .addParam('COD_PRODUTO', L[1])
            .addParam('QUANTIDADE', L[2])
            .addParam('VL_UNITARIO', L[3])
            .addParam('VL_TOTAL', L[4])
            .addParam('COD_EMPRESA', L[5])
            .addParam('COD_FILIAL', L[6])
            .addParam('COD_DEPARTAMENTO', L[7])
            .addParam('COD_CENTRO_CUSTO', L[8])
            .addParam('DESCONTO', L[9])
            .addParam('ACRESCIMO', L[10])
            .addParam('IPI', L[11])
            .addParam('VALOR_IPI', L[12])
            .addParam('PESO', L[13])
            .addParam('VOLUME', L[14])
            .addParam('SEQUENCIA', L[15])
            .addParam('DT_INCLUSAO', L[16])
            .addParam('DT_SOLICITADA', L[17])
            .addParam('DT_RECEBIDA', L[18])
            .execSql;
      end;
    end;
  finally
    SL.Free;
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

    Rows := ReadSheetRows(Zip, 'xl/worksheets/sheet1.xml', Shared);
    for i := 0 to Length(Rows) - 1 do
      if Length(Rows[i]) >= 7 then
        Q.active(False).sqlClear
          .sqlAdd('insert into FORNECEDORES (COD_CLIFOR, RAZAO, COD_ESTADO, FANTASIA, COD_PAIS, CLIENTE, FORNEC) values (:COD_CLIFOR, :RAZAO, :COD_ESTADO, :FANTASIA, :COD_PAIS, :CLIENTE, :FORNEC)')
          .addParam('COD_CLIFOR', Rows[i][0])
          .addParam('RAZAO', Rows[i][1])
          .addParam('COD_ESTADO', Rows[i][2])
          .addParam('FANTASIA', Rows[i][3])
          .addParam('COD_PAIS', Rows[i][4])
          .addParam('CLIENTE', Rows[i][5])
          .addParam('FORNEC', Rows[i][6])
          .execSql;

    Rows := ReadSheetRows(Zip, 'xl/worksheets/sheet3.xml', Shared);
    for i := 0 to Length(Rows) - 1 do
      if Length(Rows[i]) >= 19 then
        Q.active(False).sqlClear
          .sqlAdd('insert into PEDIDO_COMPRA (COD_PEDIDOCOMPRA, COD_CLIFOR, COD_USUARIO, TOTAL, COD_EMPRESA, COD_FILIAL, COD_DEPARTAMENTO, COD_CENTRO_CUSTO, DT_EMISSAO, COD_CONDPAGTO, ORDEM_COMPRA, VALOR_IMPOSTOS, COD_COMPRADOR, PESO, VOLUME, COD_TIPOFRETE, DATA_PREVISTA_ENTREGA, DT_ENTREGA, TIPO_COMPRA) values (:COD_PEDIDOCOMPRA, :COD_CLIFOR, :COD_USUARIO, :TOTAL, :COD_EMPRESA, :COD_FILIAL, :COD_DEPARTAMENTO, :COD_CENTRO_CUSTO, :DT_EMISSAO, :COD_CONDPAGTO, :ORDEM_COMPRA, :VALOR_IMPOSTOS, :COD_COMPRADOR, :PESO, :VOLUME, :COD_TIPOFRETE, :DATA_PREVISTA_ENTREGA, :DT_ENTREGA, :TIPO_COMPRA)')
          .addParam('COD_PEDIDOCOMPRA', Rows[i][0])
          .addParam('COD_CLIFOR', Rows[i][1])
          .addParam('COD_USUARIO', Rows[i][2])
          .addParam('TOTAL', Rows[i][3])
          .addParam('COD_EMPRESA', Rows[i][4])
          .addParam('COD_FILIAL', Rows[i][5])
          .addParam('COD_DEPARTAMENTO', Rows[i][6])
          .addParam('COD_CENTRO_CUSTO', Rows[i][7])
          .addParam('DT_EMISSAO', Rows[i][8])
          .addParam('COD_CONDPAGTO', Rows[i][9])
          .addParam('ORDEM_COMPRA', Rows[i][10])
          .addParam('VALOR_IMPOSTOS', Rows[i][11])
          .addParam('COD_COMPRADOR', Rows[i][12])
          .addParam('PESO', Rows[i][13])
          .addParam('VOLUME', Rows[i][14])
          .addParam('COD_TIPOFRETE', Rows[i][15])
          .addParam('DATA_PREVISTA_ENTREGA', Rows[i][16])
          .addParam('DT_ENTREGA', Rows[i][17])
          .addParam('TIPO_COMPRA', Rows[i][18])
          .execSql;

    Rows := ReadSheetRows(Zip, 'xl/worksheets/sheet2.xml', Shared);
    for i := 0 to Length(Rows) - 1 do
      if Length(Rows[i]) >= 19 then
        Q.active(False).sqlClear
          .sqlAdd('insert into PEDCOMPRA_ITEM (COD_PEDIDOCOMPRA, COD_PRODUTO, QUANTIDADE, VL_UNITARIO, VL_TOTAL, COD_EMPRESA, COD_FILIAL, COD_DEPARTAMENTO, COD_CENTRO_CUSTO, DESCONTO, ACRESCIMO, IPI, VALOR_IPI, PESO, VOLUME, SEQUENCIA, DT_INCLUSAO, DT_SOLICITADA, DT_RECEBIDA) values (:COD_PEDIDOCOMPRA, :COD_PRODUTO, :QUANTIDADE, :VL_UNITARIO, :VL_TOTAL, :COD_EMPRESA, :COD_FILIAL, :COD_DEPARTAMENTO, :COD_CENTRO_CUSTO, :DESCONTO, :ACRESCIMO, :IPI, :VALOR_IPI, :PESO, :VOLUME, :SEQUENCIA, :DT_INCLUSAO, :DT_SOLICITADA, :DT_RECEBIDA)')
          .addParam('COD_PEDIDOCOMPRA', Rows[i][0])
          .addParam('COD_PRODUTO', Rows[i][1])
          .addParam('QUANTIDADE', Rows[i][2])
          .addParam('VL_UNITARIO', Rows[i][3])
          .addParam('VL_TOTAL', Rows[i][4])
          .addParam('COD_EMPRESA', Rows[i][5])
          .addParam('COD_FILIAL', Rows[i][6])
          .addParam('COD_DEPARTAMENTO', Rows[i][7])
          .addParam('COD_CENTRO_CUSTO', Rows[i][8])
          .addParam('DESCONTO', Rows[i][9])
          .addParam('ACRESCIMO', Rows[i][10])
          .addParam('IPI', Rows[i][11])
          .addParam('VALOR_IPI', Rows[i][12])
          .addParam('PESO', Rows[i][13])
          .addParam('VOLUME', Rows[i][14])
          .addParam('SEQUENCIA', Rows[i][15])
          .addParam('DT_INCLUSAO', Rows[i][16])
          .addParam('DT_SOLICITADA', Rows[i][17])
          .addParam('DT_RECEBIDA', Rows[i][18])
          .execSql;
  finally
    Zip.Close;
    Zip.Free;
  end;
end;

end.

