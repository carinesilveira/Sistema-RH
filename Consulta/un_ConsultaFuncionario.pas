unit un_ConsultaFuncionario;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  un_CadastroFuncionario,
  FireDAC.Comp.Client;

type
  TFrmConsultaFuncionario = class(TForm)
    pnlFundo: TPanel;
    pnlCadastro: TPanel;
    pnlBotoes: TPanel;
    btnNovo: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;
    gridItens: TDBGrid;
    Panel1: TPanel;
    Label1: TLabel;
    CBCAMPOS: TComboBox;
    edt_pesquisa: TEdit;
    btnPesquisar: TButton;
    DS_CADASTRO: TDataSource;
    DS_CARGO: TDataSource;
    procedure btnNovoClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCadastroForm: TFrmCadastroFuncionario;

    function GetCadastroForm: TFrmCadastroFuncionario;
    function VerificarDadosParaConsulta: Boolean;
    procedure ExibirMensagem(const Msg: string; Tipo: Integer);
    procedure ConfigurarConsulta;
    procedure AtualizarConsulta;
  public
    { Public declarations }
  end;

var
  FrmConsultaFuncionario: TFrmConsultaFuncionario;

implementation

{$R *.dfm}

function TFrmConsultaFuncionario.GetCadastroForm: TFrmCadastroFuncionario;
begin
  if not Assigned(FCadastroForm) then
    FCadastroForm := TFrmCadastroFuncionario.Create(Self);

  Result := FCadastroForm;
end;

procedure TFrmConsultaFuncionario.FormCreate(Sender: TObject);
begin
  CBCAMPOS.Items.Clear;
  CBCAMPOS.Items.Add('Nome');
  CBCAMPOS.Items.Add('Cargo');
  CBCAMPOS.ItemIndex := 0;

  //Inicializar form de cadastro
  FCadastroForm := nil;
end;

procedure TFrmConsultaFuncionario.FormDestroy(Sender: TObject);
begin
  // Liberar o formulário de cadastro se estiver alocado
  if Assigned(FCadastroForm) then
  begin
    FCadastroForm.Free;
    FCadastroForm := nil;
  end;
end;

procedure TFrmConsultaFuncionario.ConfigurarConsulta;
begin
  GetCadastroForm;

  DS_CADASTRO.DataSet := FCadastroForm.Q_CADASTRO;
  DS_CARGO.DataSet := FCadastroForm.Q_CARGO;

  if not FCadastroForm.Q_CARGO.Active then
    FCadastroForm.Q_CARGO.Open;
end;

procedure TFrmConsultaFuncionario.AtualizarConsulta;
begin
  btnPesquisarClick(nil);
end;

function TFrmConsultaFuncionario.VerificarDadosParaConsulta: Boolean;
begin
  Result := False;

  if Trim(edt_pesquisa.Text) = '' then
  begin
    ExibirMensagem('Digite um termo para pesquisa!', MB_ICONEXCLAMATION);
    edt_pesquisa.SetFocus;
    Exit;
  end;

  if DS_CADASTRO.DataSet <> nil then
  begin
    if DS_CADASTRO.State in dsEditModes then
    begin
      ExibirMensagem('Não é possível realizar consultas no modo de Inserção ou Edição!', MB_ICONEXCLAMATION);
      Exit;
    end;
  end;

  Result := True;
end;

procedure TFrmConsultaFuncionario.ExibirMensagem(const Msg: string; Tipo: Integer);
begin
  Application.MessageBox(PChar(Msg), 'Aviso', Tipo);
end;

procedure TFrmConsultaFuncionario.btnEditarClick(Sender: TObject);
var
  IdFuncionario: Integer;
begin
  if (DS_CADASTRO.DataSet = nil) or DS_CADASTRO.DataSet.IsEmpty then
  begin
    ExibirMensagem('Nenhum registro para editar!', MB_ICONWARNING);
    Exit;
  end;

  try
    IdFuncionario := DS_CADASTRO.DataSet.FieldByName('ID_FUNC').AsInteger;

    with GetCadastroForm do
    begin
      Q_CADASTRO.Close;
      Q_CADASTRO.SQL.Clear;
      Q_CADASTRO.SQL.Add('SELECT ID_FUNC,F.NOME, F.ENDERECO, F.ADMISSAO, F.SALARIO, F.CARGO, C.CAR_NOME');
      Q_CADASTRO.SQL.Add('FROM FUNCIONARIOS F');
      Q_CADASTRO.SQL.Add('INNER JOIN CARGOS C ON F.CARGO = C.ID_CARGO');
      Q_CADASTRO.SQL.Add('WHERE F.ID_FUNC = :ID');
      Q_CADASTRO.ParamByName('ID').AsInteger := IdFuncionario;
      Q_CADASTRO.Open;

      if not Q_CARGO.Active then
        Q_CARGO.Open;

      Q_CADASTRO.Edit;

      ShowModal;
    end;

    AtualizarConsulta;

  except
    on E: Exception do
      ExibirMensagem('Erro ao editar registro: ' + E.Message, MB_ICONERROR);
  end;
end;

procedure TFrmConsultaFuncionario.btnExcluirClick(Sender: TObject);
var
  DeleteQuery: TFDQuery;
  IdFuncionario: Integer;
begin
  if (DS_CADASTRO.DataSet = nil) or DS_CADASTRO.DataSet.IsEmpty then
  begin
    ExibirMensagem('Não há registros para excluir!', MB_ICONWARNING);
    Exit;
  end;

  if Application.MessageBox('Deseja realmente excluir o registro?', 'Atenção!',
                           MB_ICONWARNING + MB_YESNO) = mrYes then
  begin
    try
      IdFuncionario := DS_CADASTRO.DataSet.FieldByName('ID_FUNC').AsInteger;

      //Garantir instância do formulário de cadastro
      DeleteQuery := TFDQuery.Create(Self);
      try
        DeleteQuery.Connection := GetCadastroForm.Conexao;

        GetCadastroForm.Conexao.StartTransaction;
        try
          DeleteQuery.SQL.Text := 'DELETE FROM FUNCIONARIOS WHERE ID_FUNC = :ID';
          DeleteQuery.ParamByName('ID').AsInteger := IdFuncionario;
          DeleteQuery.ExecSQL;

          GetCadastroForm.Conexao.Commit;
          ExibirMensagem('Registro excluído com sucesso!', MB_ICONINFORMATION);

          AtualizarConsulta;
        except
          on E: Exception do
          begin
            GetCadastroForm.Conexao.Rollback;
            raise;
          end;
        end;
      finally
        DeleteQuery.Free;
      end;
    except
      on E: Exception do
        ExibirMensagem('Erro ao excluir o registro: ' + E.Message, MB_ICONERROR);
    end;
  end;
end;

procedure TFrmConsultaFuncionario.btnNovoClick(Sender: TObject);
begin
  try
    with GetCadastroForm do
    begin
      Q_CADASTRO.Close;
      Q_CADASTRO.SQL.Clear;
      Q_CADASTRO.SQL.Add('SELECT ID_FUNC,F.NOME, F.ENDERECO, F.ADMISSAO, F.SALARIO, F.CARGO, C.CAR_NOME');
      Q_CADASTRO.SQL.Add('FROM FUNCIONARIOS F');
      Q_CADASTRO.SQL.Add('INNER JOIN CARGOS C ON F.CARGO = C.ID_CARGO');
      Q_CADASTRO.SQL.Add('WHERE 1=0');
      Q_CADASTRO.Open;

      // Garantir que a query de cargos esteja aberta
      if not Q_CARGO.Active then
        Q_CARGO.Open;

      Q_CADASTRO.Insert;

      ShowModal;
    end;

    AtualizarConsulta;

  except
    on E: Exception do
      ExibirMensagem('Erro ao criar novo registro: ' + E.Message, MB_ICONERROR);
  end;
end;

procedure TFrmConsultaFuncionario.btnPesquisarClick(Sender: TObject);
begin
//  if not VerificarDadosParaConsulta then
//    Exit;

  try
    ConfigurarConsulta;

    with GetCadastroForm do
    begin
      Q_CADASTRO.Close;
      Q_CADASTRO.SQL.Clear;
      Q_CADASTRO.SQL.Add('SELECT ID_FUNC, F.NOME, F.ENDERECO, F.ADMISSAO, F.SALARIO, F.CARGO, C.CAR_NOME');
      Q_CADASTRO.SQL.Add('FROM FUNCIONARIOS F');
      Q_CADASTRO.SQL.Add('INNER JOIN CARGOS C ON F.CARGO = C.ID_CARGO');

      case CBCAMPOS.ItemIndex of
        0: // Nome
        begin
          Q_CADASTRO.SQL.Add('WHERE UPPER(F.NOME) LIKE :PNOME');
          Q_CADASTRO.ParamByName('PNOME').AsString := '%' + UpperCase(edt_pesquisa.Text) + '%';
        end;

        1: // Cargo
        begin
          Q_CADASTRO.SQL.Add('WHERE UPPER(C.CAR_NOME) LIKE :PCARGO');
          Q_CADASTRO.ParamByName('PCARGO').AsString := '%' + UpperCase(edt_pesquisa.Text) + '%';
        end;
      end;

      Q_CADASTRO.Open;
    end;

    if FCadastroForm.Q_CADASTRO.IsEmpty then
      ExibirMensagem('Nenhum registro encontrado!', MB_ICONEXCLAMATION);

  except
    on E: Exception do
      ExibirMensagem('Erro ao pesquisar: ' + E.Message, MB_ICONERROR);
  end;
end;

procedure TFrmConsultaFuncionario.FormShow(Sender: TObject);
begin
  ConfigurarConsulta;
end;

end.
