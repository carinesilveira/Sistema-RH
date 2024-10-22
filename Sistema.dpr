program Sistema;

uses
  Vcl.Forms,
  un_Principal in 'un_Principal.pas' {FrmPrincipal},
  Vcl.Themes,
  Vcl.Styles,
  un_CadastroFuncionario in 'Cadastro\un_CadastroFuncionario.pas' {FrmCadastroFuncionario},
  un_ConsultaFuncionario in 'Consulta\un_ConsultaFuncionario.pas' {FrmConsultaFuncionario},
  un_Resumo in 'un_Resumo.pas' {FrmResumo};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glow');
  Application.CreateForm(TFrmPrincipal, FrmPrincipal);
  Application.CreateForm(TFrmCadastroFuncionario, FrmCadastroFuncionario);
  Application.CreateForm(TFrmConsultaFuncionario, FrmConsultaFuncionario);
  Application.CreateForm(TFrmResumo, FrmResumo);
  Application.Run;
end.
