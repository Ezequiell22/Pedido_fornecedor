unit comercial.util.printhtml;

interface

type
  TPrintHtmlPedido = class
  public
    class function GerarHtmlPedido(aIdPedido: Integer; const aFilePath: string): string; static;
    class function GerarRelatorioTopProdutos(aDtIni, aDtFim: TDateTime; const aFilePath: string): string;
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

class function TPrintHtmlPedido.GerarRelatorioTopProdutos(aDtIni, aDtFim: TDateTime; const aFilePath: string): string;
var
  Q: iQuery;
  SB: TStringBuilder;
  targetFile, targetDir, nameDefault: string;
begin
  Q := TModelResourceQueryFD.New;
  Q.active(False)
    .sqlClear
    .sqlAdd('select * from SP_TOP_PRODUTOS_VENDIDOS(:DTINI, :DTFIM)')
    .addParam('DTINI', aDtIni)
    .addParam('DTFIM', aDtFim)
    .open;

  SB := TStringBuilder.Create;
  try
    SB.AppendLine('<!DOCTYPE html>');
    SB.AppendLine('<html lang="pt-br">');
    SB.AppendLine('<head>');
    SB.AppendLine('<meta charset="utf-8">');
    SB.AppendLine('<title>Top Produtos Vendidos</title>');
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
    SB.AppendLine('<h1>Top Produtos Vendidos</h1>');
    SB.AppendLine('<div>Período: ' + FormatDateTime('dd/mm/yyyy', aDtIni) + ' a ' + FormatDateTime('dd/mm/yyyy', aDtFim) + '</div>');
    SB.AppendLine('<table>');
    SB.AppendLine('<thead><tr><th>ID</th><th>Descrição</th><th class="text-right">Quantidade</th></tr></thead>');
    SB.AppendLine('<tbody>');
    Q.DataSet.First;
    while not Q.DataSet.Eof do
    begin
      SB.Append('<tr>');
      SB.Append('<td>' + Q.DataSet.FieldByName('IDPRODUTO').AsString + '</td>');
      SB.Append('<td>' + Q.DataSet.FieldByName('DESCRICAO').AsString + '</td>');
      SB.Append('<td class="text-right">' + Q.DataSet.FieldByName('QTD').AsString + '</td>');
      SB.AppendLine('</tr>');
      Q.DataSet.Next;
    end;
    SB.AppendLine('</tbody></table>');
    SB.AppendLine('</body>');
    SB.AppendLine('</html>');

    nameDefault := Format('top_produtos_%s_%s.html', [FormatDateTime('yyyymmdd', aDtIni), FormatDateTime('yyyymmdd', aDtFim)]);
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
        TLog.Error('Print HTML TopProdutos save failed: ' + E.ClassName + ' | ' + E.Message + ' | Path=' + targetFile);
        raise;
      end;
    end;
    Result := SB.ToString;
  finally
    SB.Free;
  end;
end;


end.
