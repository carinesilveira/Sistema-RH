unit un_Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.Imaging.pngimage, un_CadastroFuncionario,
  un_ConsultaFuncionario, un_Resumo,
  Vcl.ExtCtrls;

type
  TFrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    mnFuncionario: TMenuItem;
    Resumo1: TMenuItem;
    Sair1: TMenuItem;
    Resumo2: TMenuItem;
    imgFundo: TImage;
    Consulta1: TMenuItem;
    Funcionrio2: TMenuItem;
    procedure Sair1Click(Sender: TObject);
    procedure mnFuncionarioclick(Sender: TObject);
    procedure Funcionrio2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Resumo2Click(Sender: TObject);
  private
    { Private declarations }
      procedure criarTelas(aTela: TformClass);
  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

procedure TFrmPrincipal.criarTelas(aTela: TformClass);
begin
  with aTela.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFrmPrincipal.mnFuncionarioclick(Sender: TObject);
begin
 with TFrmCadastroFuncionario.Create(Self) do
  try
    ds_Cadastro.DataSet.Open;
    ds_Cadastro.DataSet.Insert;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TFrmPrincipal.Resumo2Click(Sender: TObject);
begin
  criarTelas(TFrmResumo);
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  FrmCadastroFuncionario.q_Cadastro.Open();
end;

procedure TFrmPrincipal.Funcionrio2Click(Sender: TObject);
begin
  FrmCadastroFuncionario.q_Cadastro.Open();
  criarTelas(TFrmConsultaFuncionario);
end;

procedure TFrmPrincipal.Sair1Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
