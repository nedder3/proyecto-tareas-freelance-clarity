unit UnitLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

// Tipo de registro simple
type
  TCredencial = record
    usuario: string;
    password: string;
  end;

type

  { TFormLogin }

  TFormLogin = class(TForm)
    EditUser: TEdit;
    EditPass: TEdit;
    BtnIngresar: TButton;
    Image1: TImage;
    ImageFondo: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure BtnIngresarClick(Sender: TObject);
    procedure EditUserChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageFondoClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    // Variables globales al unit
    credencialesCorrectas: TCredencial;
  public
    // Procedures sin parámetros
    procedure inicializarCredenciales();
  end;

// Variable global
var
  FormLogin: TFormLogin;

implementation

uses UnitMain;  // AGREGAR esta línea para poder usar FormMain

{$R *.lfm}


// Procedure sin parámetros, usa variables globales
procedure TFormLogin.inicializarCredenciales();
begin
  credencialesCorrectas.usuario := 'admin';
  credencialesCorrectas.password := '123';
end;

procedure TFormLogin.BtnIngresarClick(Sender: TObject);
begin
  if ((EditUser.Text = 'admin') and (EditPass.Text = '123')) or ((EditUser.Text = 'devesa') and (EditPass.Text = 'devesa')) then
  begin
    ShowMessage('Login exitoso!');

    // OPCIÓN A: CERRAR completamente el login  no funciona porque se cierra antes de dirigirte al otro
    //Close;

    // OPCIÓN B: OCULTAR el login (se puede volver a mostrarlo)
       Hide;

    FormMain.Show;
  end
  else
  begin
    ShowMessage('Usuario/contraseña no encontrado');
    EditUser.Text := '';
    EditPass.Text := '';
    EditUser.SetFocus;
  end;
end;

procedure TFormLogin.EditUserChange(Sender: TObject);
begin

end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin

end;

procedure TFormLogin.ImageFondoClick(Sender: TObject);
begin

end;

procedure TFormLogin.Label3Click(Sender: TObject);
begin

end;

end.
