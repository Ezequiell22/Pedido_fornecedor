unit comercial.util.printhtml;

interface

type
  TPrintHtmlPedido = class
  public
    class function GerarHtmlPedido(aIdPedido: Integer; const aFilePath: string): string; static;
    class function GerarRelatorioPorProduto(const aFilePath: string): string;
    class function GerarRelatorioPorFornecedor(const aFilePath: string): string;
  end;

implementation

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Data.DB,
  comercial.model.resource.interfaces,
  comercial.model.resource.impl.queryFD,
  comercial.util.log;

class function TPrintHtmlPedido.GerarHtmlPedido(aIdPedido: Integer; const aFilePath: string): string;
var
  QCab, QItens: iQuery;
  SB: TStringBuilder;
begin
  QCab := TModelResourceQueryFD.New;
  QItens := TModelResourceQueryFD.New;

  QCab.active(False)
    .sqlClear
    .sqlAdd('select d.COD_PEDIDOCOMPRA, d.COD_CLIFOR, d.DT_EMISSAO, d.TOTAL,')
    .sqlAdd('       f.FANTASIA, f.RAZAO')
    .sqlAdd('  from PEDIDO_COMPRA d')
    .sqlAdd('  join FORNECEDORES f on f.COD_CLIFOR = d.COD_CLIFOR')
    .sqlAdd(' where d.COD_PEDIDOCOMPRA = :ID')
    .addParam('ID', aIdPedido)
    .open;

  if QCab.DataSet.IsEmpty then
  begin
    Result := '';
    Exit;
  end;

  QItens.active(False)
    .sqlClear
    .sqlAdd('select P.DESCRICAO, p.MARCA, i.QUANTIDADE, i.VL_UNITARIO, i.VL_TOTAL')
    .sqlAdd('  from PEDCOMPRA_ITEM i')
    .sqlAdd('  left join PRODUTO p on p.IDPRODUTO = i.COD_PRODUTO')
    .sqlAdd(' where i.COD_PEDIDOCOMPRA = :ID')
    .addParam('ID', aIdPedido)
    .open;

  SB := TStringBuilder.Create;
  try
    SB.AppendLine('<!DOCTYPE html>');
    SB.AppendLine('<html lang="pt-br">');
    SB.AppendLine('<head>');
    SB.AppendLine('<meta charset="utf-8">');
    SB.AppendLine('<title>Pedido</title>');
    SB.AppendLine('<style>');
    SB.AppendLine('body{font-family:Segoe UI, Arial, sans-serif; margin:24px; color:#222;}');
    SB.AppendLine('h1{margin:0 0 8px 0; font-size:20px;}');
    SB.AppendLine('h2{margin:16px 0 8px 0; font-size:16px;}');
    SB.AppendLine('table{border-collapse:collapse; width:100%;}');
    SB.AppendLine('thead th{background:#f5f5f5; border:1px solid #ddd; padding:8px; font-weight:600;}');
    SB.AppendLine('tbody td{border:1px solid #eee; padding:8px;}');
    SB.AppendLine('tbody tr:nth-child(even){background:#fafafa;}');
    SB.AppendLine('.section{margin-top:16px;}');
    SB.AppendLine('.text-right{ text-align:right; }');
    SB.AppendLine('.total{font-weight:bold; text-align:right; margin-top:8px;}');
    SB.AppendLine('@media print { body{margin:12mm;} }');
    SB.AppendLine('</style>');
    SB.AppendLine('</head>');
    SB.AppendLine('<body>');
    SB.AppendLine('<h1>Pedido ' + QCab.DataSet.FieldByName('COD_PEDIDOCOMPRA').AsString + '</h1>');
    SB.AppendLine('<div>Data: ' + DateTimeToStr(QCab.DataSet.FieldByName('DT_EMISSAO').AsDateTime) + '</div>');
    SB.AppendLine('<div class="section">');
    SB.AppendLine('<h2>Fornecedor</h2>');
    SB.AppendLine('<div>ID: ' + QCab.DataSet.FieldByName('COD_CLIFOR').AsString + '</div>');
    SB.AppendLine('<div>Nome fantasia: ' + QCab.DataSet.FieldByName('FANTASIA').AsString + '</div>');
    SB.AppendLine('<div>Razão social: ' + QCab.DataSet.FieldByName('RAZAO').AsString + '</div>');
    SB.AppendLine('</div>');
    SB.AppendLine('<div class="section">');
    SB.AppendLine('<h2>Itens</h2>');
    SB.AppendLine('<table>');
    SB.AppendLine('<thead><tr><th>Descrição</th><th>Marca</th><th class="text-right">Quantidade</th><th class="text-right">Unitário</th><th class="text-right">Total</th></tr></thead>');
    SB.AppendLine('<tbody>');
    QItens.DataSet.First;
    while not QItens.DataSet.Eof do
    begin
      SB.Append('<tr>');
      SB.Append('<td>' + QItens.DataSet.FieldByName('DESCRICAO').AsString + '</td>');
      SB.Append('<td>' + QItens.DataSet.FieldByName('MARCA').AsString + '</td>');
      SB.Append('<td class="text-right">' + QItens.DataSet.FieldByName('QUANTIDADE').AsString + '</td>');
      SB.Append('<td class="text-right">' + FormatFloat('0.00', QItens.DataSet.FieldByName('VL_UNITARIO').AsFloat) + '</td>');
      SB.Append('<td class="text-right">' + FormatFloat('0.00', QItens.DataSet.FieldByName('VL_TOTAL').AsFloat) + '</td>');
      SB.AppendLine('</tr>');
      QItens.DataSet.Next;
    end;
    SB.AppendLine('</tbody></table>');
    SB.AppendLine('</div>');
    SB.AppendLine('<div class="section total">Total: ' + FormatFloat('0.00', QCab.DataSet.FieldByName('TOTAL').AsFloat) + '</div>');
    SB.AppendLine('</body>');
    SB.AppendLine('</html>');

    var targetFile: string;
    var targetDir: string;
    var nameDefault: string;
    nameDefault := Format('pedido_%d_%s.html', [aIdPedido, FormatDateTime('yyyymmdd_hhnnss', Now)]);

    if aFilePath = '' then
    begin
      targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + nameDefault;
    end
    else if TDirectory.Exists(aFilePath) then
    begin
      targetDir := IncludeTrailingPathDelimiter(aFilePath);
      targetFile := targetDir + nameDefault;
    end
    else
    begin
      targetDir := ExtractFilePath(aFilePath);
      if targetDir = '' then
        targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + ExtractFileName(aFilePath);
    end;

    try
      if not TDirectory.Exists(targetDir) then
        TDirectory.CreateDirectory(targetDir);
      TFile.WriteAllText(targetFile, SB.ToString, TEncoding.UTF8);
    except
      on E: Exception do
      begin
        TLog.Error('Print HTML save failed: ' + E.ClassName + ' | ' + E.Message + ' | Path=' + targetFile);
        raise;
      end;
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

class function TPrintHtmlPedido.GerarRelatorioPorProduto( const aFilePath: string): string;
var
  Q: iQuery;
  SB: TStringBuilder;
  targetFile, targetDir, nameDefault: string;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False)
    .sqlClear
    .sqlAdd('select i.COD_Item as IDPRODUTO, i.DESCRICAO,')
    .sqlAdd('       avg(i.PRECO_UNITARIO) as PRECO_MEDIO,')
    .sqlAdd('       sum(i.QTD_PEDIDA) as QTD_TOTAL,')
    .sqlAdd('       sum(i.VALOR_TOTAL) as VALOR_TOTAL')
    .sqlAdd('  from PEDCOMPRA_ITEM i')
    .sqlAdd(' group by i.COD_Item, i.DESCRICAO')
    .open;

  SB := TStringBuilder.Create;
  try
    SB.AppendLine('<!DOCTYPE html>');
    SB.AppendLine('<html lang="pt-br">');
    SB.AppendLine('<head>');
    SB.AppendLine('<meta charset="utf-8">');
    SB.AppendLine('<title>Compras por Produto</title>');
    SB.AppendLine('<style>');
    SB.AppendLine('body{font-family:Segoe UI, Arial, sans-serif; margin:24px; color:#222;}');
    SB.AppendLine('h1{margin:0 0 8px 0; font-size:20px;}');
    SB.AppendLine('table{border-collapse:collapse; width:100%;}');
    SB.AppendLine('thead th{background:#f5f5f5; border:1px solid #ddd; padding:8px; font-weight:600;}');
    SB.AppendLine('tbody td{border:1px solid #eee; padding:8px;}');
    SB.AppendLine('tbody tr:nth-child(even){background:#fafafa;}');
    SB.AppendLine('.text-right{ text-align:right; }');
    SB.AppendLine('</style>');
    SB.AppendLine('</head>');
    SB.AppendLine('<body>');
    SB.AppendLine('<h1>Compras por Produto</h1>');

    SB.AppendLine('<table>');
    SB.AppendLine('<thead><tr><th>ID</th><th>Descrição</th><th class="text-right">Preço médio</th><th class="text-right">Quantidade total</th><th class="text-right">Valor total</th></tr></thead>');
    SB.AppendLine('<tbody>');
    Q.DataSet.First;
    while not Q.DataSet.Eof do
    begin
      SB.Append('<tr>');
      SB.Append('<td>' + Q.DataSet.FieldByName('IDPRODUTO').AsString + '</td>');
      SB.Append('<td>' + Q.DataSet.FieldByName('DESCRICAO').AsString + '</td>');
      SB.Append('<td class="text-right">' + FormatFloat('0.00', Q.DataSet.FieldByName('PRECO_MEDIO').AsFloat) + '</td>');
      SB.Append('<td class="text-right">' + Q.DataSet.FieldByName('QTD_TOTAL').AsString + '</td>');
      SB.Append('<td class="text-right">' + FormatFloat('0.00', Q.DataSet.FieldByName('VALOR_TOTAL').AsFloat) + '</td>');
      SB.AppendLine('</tr>');
      Q.DataSet.Next;
    end;
    SB.AppendLine('</tbody></table>');
    SB.AppendLine('</body>');
    SB.AppendLine('</html>');

    nameDefault := Format('compras_por_produto_%s.html', [FormatDateTime('yyyymmdd', now)]);
    if aFilePath = '' then
    begin
      targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + nameDefault;
    end
    else if TDirectory.Exists(aFilePath) then
    begin
      targetDir := IncludeTrailingPathDelimiter(aFilePath);
      targetFile := targetDir + nameDefault;
    end
    else
    begin
      targetDir := ExtractFilePath(aFilePath);
      if targetDir = '' then
        targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + ExtractFileName(aFilePath);
    end;

    try
      if not TDirectory.Exists(targetDir) then
        TDirectory.CreateDirectory(targetDir);
      TFile.WriteAllText(targetFile, SB.ToString, TEncoding.UTF8);
    except
      on E: Exception do
      begin
        TLog.Error('Print HTML ComprasPorProduto save failed: ' + E.ClassName + ' | ' + E.Message + ' | Path=' + targetFile);
        raise;
      end;
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;

class function TPrintHtmlPedido.GerarRelatorioPorFornecedor( const aFilePath: string): string;
var
  Q: iQuery;
  SB: TStringBuilder;
  targetFile, targetDir, nameDefault: string;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False)
    .sqlClear
    .sqlAdd('select f.COD_CLIFOR, f.FANTASIA, sum(i.VALOR_TOTAL) as VALOR_TOTAL')
    .sqlAdd('  from PEDIDO_COMPRA d')
    .sqlAdd('  left join FORNECEDORES f on f.COD_CLIFOR = d.COD_CLIFOR')
    .sqlAdd('  left join PEDCOMPRA_ITEM i on i.COD_PEDIDOCOMPRA = d.COD_PEDIDOCOMPRA')
    .sqlAdd(' group by f.COD_CLIFOR, f.FANTASIA')
    .open;

  SB := TStringBuilder.Create;
  try
    SB.AppendLine('<!DOCTYPE html>');
    SB.AppendLine('<html lang="pt-br">');
    SB.AppendLine('<head>');
    SB.AppendLine('<meta charset="utf-8">');
    SB.AppendLine('<title>Compras por Fornecedor</title>');
    SB.AppendLine('<style>');
    SB.AppendLine('body{font-family:Segoe UI, Arial, sans-serif; margin:24px; color:#222;}');
    SB.AppendLine('h1{margin:0 0 8px 0; font-size:20px;}');
    SB.AppendLine('table{border-collapse:collapse; width:100%;}');
    SB.AppendLine('thead th{background:#f5f5f5; border:1px solid #ddd; padding:8px; font-weight:600;}');
    SB.AppendLine('tbody td{border:1px solid #eee; padding:8px;}');
    SB.AppendLine('tbody tr:nth-child(even){background:#fafafa;}');
    SB.AppendLine('.text-right{ text-align:right; }');
    SB.AppendLine('</style>');
    SB.AppendLine('</head>');
    SB.AppendLine('<body>');
    SB.AppendLine('<h1>Compras por Fornecedor</h1>');

    SB.AppendLine('<table>');
    SB.AppendLine('<thead><tr><th>ID Fornecedor</th><th>Fantasia</th><th class="text-right">Valor total</th></tr></thead>');
    SB.AppendLine('<tbody>');
    Q.DataSet.First;
    while not Q.DataSet.Eof do
    begin
      SB.Append('<tr>');
      SB.Append('<td>' + Q.DataSet.FieldByName('COD_CLIFOR').AsString + '</td>');
      SB.Append('<td>' + Q.DataSet.FieldByName('FANTASIA').AsString + '</td>');
      SB.Append('<td class="text-right">' + FormatFloat('0.00', Q.DataSet.FieldByName('VALOR_TOTAL').AsFloat) + '</td>');
      SB.AppendLine('</tr>');
      Q.DataSet.Next;
    end;
    SB.AppendLine('</tbody></table>');
    SB.AppendLine('</body>');
    SB.AppendLine('</html>');

    nameDefault := Format('compras_por_fornecedor_%s.html', [FormatDateTime('yyyymmdd', now)]);
    if aFilePath = '' then
    begin
      targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + nameDefault;
    end
    else if TDirectory.Exists(aFilePath) then
    begin
      targetDir := IncludeTrailingPathDelimiter(aFilePath);
      targetFile := targetDir + nameDefault;
    end
    else
    begin
      targetDir := ExtractFilePath(aFilePath);
      if targetDir = '' then
        targetDir := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)) + 'reports');
      targetFile := targetDir + ExtractFileName(aFilePath);
    end;

    try
      if not TDirectory.Exists(targetDir) then
        TDirectory.CreateDirectory(targetDir);
      TFile.WriteAllText(targetFile, SB.ToString, TEncoding.UTF8);
    except
      on E: Exception do
      begin
        TLog.Error('Print HTML Fornecedor save failed: ' + E.ClassName + ' | ' + E.Message + ' | Path=' + targetFile);
        raise;
      end;
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;


end.

