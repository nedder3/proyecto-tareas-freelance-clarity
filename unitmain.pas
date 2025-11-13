unit UnitMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;
const
  max_tareas = 50;

//TIPOS
type
  TEstado = (pendiente, completo);
  TPrioridad = (alta, media, baja);

  TTarea = record
    cliente: string;
    tipoTrabajo: string;
    monto: real;
    estado: TEstado;
    prioridad: TPrioridad;
  end;

  TArrayTareas = array[1..max_tareas] of TTarea;

type

  { TFormMain }

  TFormMain = class(TForm)
    BtnOrganizarPrioridad: TButton;
    BtnCambiarEstado: TButton;
    BtnEliminarTarea: TButton;
    BtnSalir: TButton;
    //Zona variables de Ingreso
    EditCliente: TEdit;
    EditTipo: TEdit;
    EditMonto: TEdit;
    ComboEstado: TComboBox;
    ComboPrioridad: TComboBox;
    BtnAgregar: TButton;
    ImageFondoMain: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;

    //Zona de variable Visualización (memo)
    MemoLista: TMemo;

    //Zona de Información
    LabelTotalCobrado: TLabel;
    LabelTotalPendiente: TLabel;
    LabelCantTareas: TLabel;

    //Zona de Botones
    BtnMostrarTodas: TButton;
    BtnBuscarCliente: TButton;
    BtnBuscarTipo: TButton;
    BtnCalcularTotales: TButton;
    TLCliente: TLabel;
    TLEstado: TLabel;
    TLMonto: TLabel;
    TLPrioridad: TLabel;
    TLTipoTrabajo: TLabel;

    procedure BtnAgregarClick(Sender: TObject);
    procedure BtnCambiarEstadoClick(Sender: TObject);
    procedure BtnMostrarTodasClick(Sender: TObject);
    procedure BtnBuscarClienteClick(Sender: TObject);
    procedure BtnBuscarTipoClick(Sender: TObject);
    procedure BtnCalcularTotalesClick(Sender: TObject);
    procedure BtnOrganizarPrioridadClick(Sender: TObject);
    procedure BtnEliminarTareaClick(Sender: TObject);
    procedure BtnSalirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImageFondoMainClick(Sender: TObject);
    procedure MemoListaChange(Sender: TObject);

  private
    //PROCEDURES - sin parámetros
    procedure actualizarListaTareas();
    procedure calcularTotales();
    procedure limpiarCampos();
    procedure precargarTareasDemo(); // agrego pre cargar
  public
  end;

//VARIABLES GLOBALES
var
  FormMain: TFormMain;
  tareas: TArrayTareas;     //Array global
  cantTareas: integer;      //Contador global
  tareaSeleccionada: integer; //inicializacion tareas seleccionadas

implementation

{$R *.lfm}

//FUNCIONES HELPER  - IDÉNTICAS a consola
function estadoAString(estado: TEstado): string;
begin
  if estado = completo then
    estadoAString := 'COMPLETO'
  else
    estadoAString := 'PENDIENTE';
end;

//funcion que convierte a cadena un tipo estado
function stringAEstado(estadoStr: string): TEstado;
begin
  if estadoStr = 'Completo' then
    stringAEstado := completo
  else
    stringAEstado := pendiente;
end;

//funcion que convierte la prioridad que es un enum a un string
function prioridadAString(prioridad: TPrioridad): string;
begin
  case prioridad of
    alta: prioridadAString := 'ALTA';
    media: prioridadAString := 'MEDIA';
    baja: prioridadAString := 'BAJA';
  end;
end;

//PROCEDURES ADAPTADOS A GUI  (graphic user interface)
procedure TFormMain.actualizarListaTareas();
var
  i: integer;
begin
  //esta linea limpia todo el memo
  MemoLista.Lines.Clear;
  MemoLista.Lines.Add('--- LISTA DE TAREAS (' + IntToStr(cantTareas) + ') ---');

  for i := 1 to cantTareas do
  begin
    MemoLista.Lines.Add(Format('%d. %s - %s - $%.2f - %s - %s',
      [i, tareas[i].cliente, tareas[i].tipoTrabajo, tareas[i].monto,
       estadoAString(tareas[i].estado), prioridadAString(tareas[i].prioridad)]));
  end;
end;

//procedimiento que calcula los totales
procedure TFormMain.calcularTotales();
var
  i: integer;
  totalCobrado, totalPendiente: real;
begin
  totalCobrado := 0;
  totalPendiente := 0;

  for i := 1 to cantTareas do
  begin
    if tareas[i].estado = completo then
      totalCobrado := totalCobrado + tareas[i].monto
    else
      totalPendiente := totalPendiente + tareas[i].monto;
  end;

  LabelCantTareas.Caption := 'Tareas: ' + IntToStr(cantTareas);
  LabelTotalCobrado.Caption := 'Cobrado: $' + FormatFloat('0.00', totalCobrado);
  LabelTotalPendiente.Caption := 'Pendiente: $' + FormatFloat('0.00', totalPendiente);
end;

//procedimiento que limpia los campos
procedure TFormMain.limpiarCampos();
begin
  EditCliente.Text := '';
  EditTipo.Text := '';
  EditMonto.Text := '';
  ComboEstado.ItemIndex := 0;
  ComboPrioridad.ItemIndex := 1;
  EditCliente.SetFocus;
end;

//procedimiento para precargar tareas
procedure TFormMain.precargarTareasDemo();
begin
  cantTareas := 25;

  with tareas[1] do begin cliente:= 'Gonzalez Perez'; tipoTrabajo:= 'Desarrollo web'; monto:=200; estado:=pendiente; prioridad:=alta; end;
  with tareas[2] do begin cliente:= 'Gonzalez Perez'; tipoTrabajo:= 'Analisis'; monto:=500; estado:= pendiente; prioridad:= baja; end;
  with tareas[3] do begin cliente:= 'Gonzalez Perez'; tipoTrabajo:= 'Analisis'; monto:=200; estado:= pendiente; prioridad:= alta; end;
  with tareas[4] do begin cliente:= 'Gonzalez Perez'; tipoTrabajo:= 'Pruebas'; monto:=750; estado:= completo; prioridad:= media; end;
  with tareas[5] do begin cliente:= 'Gonzalez Perez'; tipoTrabajo:= 'Planificacion'; monto:=500; estado:= completo; prioridad:= alta; end;

  with tareas[6] do begin cliente:= 'Perez Garcia'; tipoTrabajo:= 'Planificacion'; monto:=850; estado:= pendiente; prioridad:= media; end;
  with tareas[7] do begin cliente:= 'Perez Garcia'; tipoTrabajo:= 'Analisis'; monto:=530; estado:= pendiente; prioridad:= baja; end;
  with tareas[8] do begin cliente:= 'Perez Garcia'; tipoTrabajo:= 'Desarrollo web'; monto:=500; estado:= completo; prioridad:= alta; end;
  with tareas[9] do begin cliente:= 'Perez Garcia'; tipoTrabajo:= 'Mantenimiento'; monto:=350; estado:= pendiente; prioridad:= media; end;
  with tareas[10] do begin cliente:= 'Perez Garcia'; tipoTrabajo:= 'Pruebas'; monto:=200; estado:= completo; prioridad:= baja; end;

  with tareas[11] do begin cliente:= 'Perez Gonzalez'; tipoTrabajo:= 'Mantenimiento'; monto:=150; estado:= pendiente; prioridad:= media; end;
  with tareas[12] do begin cliente:= 'Perez Gonzalez'; tipoTrabajo:= 'Desarrollo web'; monto:=850; estado:= pendiente; prioridad:= alta; end;
  with tareas[13] do begin cliente:= 'Perez Gonzalez'; tipoTrabajo:= 'Analisis'; monto:=650; estado:= completo; prioridad:= media; end;
  with tareas[14] do begin cliente:= 'Perez Gonzalez'; tipoTrabajo:= 'Planificacion'; monto:=900; estado:=completo; prioridad:= baja; end;
  with tareas[15] do begin cliente:= 'Perez Gonzalez'; tipoTrabajo:= 'Pruebas'; monto:=950; estado:= completo; prioridad:= media; end;

  with tareas[16] do begin cliente:= 'Gonzalez Garcia'; tipoTrabajo:= 'Analisis'; monto:=950; estado:=completo; prioridad:=baja; end;
  with tareas[17] do begin cliente:= 'Gonzalez Garcia'; tipoTrabajo:= 'Desarrollo web'; monto:=850; estado:=pendiente; prioridad:=alta; end;
  with tareas[18] do begin cliente:= 'Gonzalez Garcia'; tipoTrabajo:= 'Mantenimiento'; monto:=650; estado:=pendiente; prioridad:= media; end;
  with tareas[19] do begin cliente:= 'Gonzalez Garcia'; tipoTrabajo:= 'Pruebas'; monto:=560; estado:=completo; prioridad:=baja; end;
  with tareas[20] do begin cliente:= 'Gonzalez Garcia'; tipoTrabajo:= 'Planificacion'; monto:=261; estado:=completo; prioridad:=media; end;

  with tareas[21] do begin cliente:= 'Garcia Gonzalez'; tipoTrabajo:= 'Pruebas'; monto:=531; estado:=pendiente; prioridad:=baja; end;
  with tareas[22] do begin cliente:= 'Garcia Gonzalez'; tipoTrabajo:= 'Analisis'; monto:=864; estado:=pendiente; prioridad:=alta; end;
  with tareas[23] do begin cliente:= 'Garcia Gonzalez'; tipoTrabajo:= 'Planificacion'; monto:=781; estado:=pendiente; prioridad:=alta; end;
  with tareas[24] do begin cliente:= 'Garcia Gonzalez'; tipoTrabajo:= 'Desarrollo web'; monto:=451; estado:=pendiente; prioridad:=media; end;
  with tareas[25] do begin cliente:= 'Garcia Gonzalez'; tipoTrabajo:= 'Mantenimiento'; monto:=523; estado:=pendiente; prioridad:=baja; end;
end;

//EVENTOS QUE LLAMAN A PROCEDURES
procedure TFormMain.FormShow(Sender: TObject);
begin
  //INICIALIZACIÓN  de tareas globales
  //cantTareas := 0;
 // precargarTareasDemo();   esto iria en el create que esta mas arriba
  ComboEstado.ItemIndex := 0;
  ComboPrioridad.ItemIndex := 1;
  calcularTotales();
  actualizarListaTareas();
end;

procedure TFormMain.ImageFondoMainClick(Sender: TObject);
begin

end;

procedure TFormMain.MemoListaChange(Sender: TObject);
begin

end;

//funcionalidad del boton de agregar tareas
procedure TFormMain.BtnAgregarClick(Sender: TObject);
var
  monto: real;
begin
  //VALIDACIONES
  if EditCliente.Text = '' then
  begin
    ShowMessage('Ingrese cliente');
    Exit;
  end;

  //aca intentamos convertir lo que ingresamos en la caja monto en cadena a numerico, y si falla lo intenta de nuevo
  //pero el programa no se corta

  try
    monto := StrToFloat(EditMonto.Text);
  except
    ShowMessage('Monto inválido');
    Exit;
  end;

  if monto < 0 then
  begin
    ShowMessage('Monto no puede ser negativo');
    Exit;
  end;

  //AGREGAR Al arreglo (Memo)
  cantTareas := cantTareas + 1;
  tareas[cantTareas].cliente := EditCliente.Text;
  tareas[cantTareas].tipoTrabajo := EditTipo.Text;
  tareas[cantTareas].monto := monto;
  tareas[cantTareas].estado := stringAEstado(ComboEstado.Text);

  case ComboPrioridad.Text of
    'Alta': tareas[cantTareas].prioridad := alta;
    'Media': tareas[cantTareas].prioridad := media;
    'Baja': tareas[cantTareas].prioridad := baja;
  end;

  //ACTUALIZAR INTERFAZ (memo ,labels contadores)
  actualizarListaTareas();
  calcularTotales();
  limpiarCampos();

  ShowMessage('Tarea agregada exitosamente!');
end;

procedure TFormMain.BtnCambiarEstadoClick(Sender: TObject);

          //logica para cambiar estado completo a incompleto AAAAAAAHHHHHH
  var
  numeroTareaStr: string;
  numeroTarea: integer;
begin
  if cantTareas = 0 then
  begin
    ShowMessage('No hay tareas para modificar');
    Exit;
  end;

  //InputBox simple
  numeroTareaStr := InputBox(
    'Cambiar Estado de Tarea',
    Format('Ingresa el número de tarea (1 a %d):', [cantTareas]),
    '1'
  );

                    //Validación
  try
    numeroTarea := StrToInt(numeroTareaStr);
  except
    ShowMessage('Error: Ingresa un número válido');
    Exit;
  end;

  if (numeroTarea < 1) or (numeroTarea > cantTareas) then
  begin
    ShowMessage(Format('Error: El número debe estar entre 1 y %d', [cantTareas]));
    Exit;
  end;

  // Cambio bidireccional  de estado pendiente a completo y viceversa
  if tareas[numeroTarea].estado = pendiente then
  begin
    tareas[numeroTarea].estado := completo;
    ShowMessage(Format(
      'Tarea %d marcada como COMPLETA:' + sLineBreak +
      '%s - %s - $%.2f',
      [numeroTarea, tareas[numeroTarea].cliente,
       tareas[numeroTarea].tipoTrabajo, tareas[numeroTarea].monto]
    ));
  end
  else
  begin
    tareas[numeroTarea].estado := pendiente;
    ShowMessage(Format(
      'Tarea %d marcada como PENDIENTE:' + sLineBreak +
      '%s - %s - $%.2f',
      [numeroTarea, tareas[numeroTarea].cliente,
       tareas[numeroTarea].tipoTrabajo, tareas[numeroTarea].monto]
    ));
  end;

  //Actualizar todo
  actualizarListaTareas();
  calcularTotales();
end;



procedure TFormMain.BtnMostrarTodasClick(Sender: TObject);
begin
  actualizarListaTareas();
end;

//procedimiento de buscar clientes (boton)
procedure TFormMain.BtnBuscarClienteClick(Sender: TObject);
var
  clienteBuscado: string;
  i, encontradas: integer;
begin
clienteBuscado := InputBox('Buscar por cliente', 'Ingrese nombre del cliente:', '');

  if clienteBuscado = '' then Exit;

  MemoLista.Lines.Clear;
  encontradas := 0;
  MemoLista.Lines.Add('--- TAREAS DE: ' + clienteBuscado + ' ---');

  for i := 1 to cantTareas do
  begin
    if tareas[i].cliente = clienteBuscado then
    begin
      MemoLista.Lines.Add(Format('%d. %s - $%.2f - %s',
        [i, tareas[i].tipoTrabajo, tareas[i].monto, estadoAString(tareas[i].estado)]));
      encontradas := encontradas + 1;
    end;
  end;

  if encontradas = 0 then
    MemoLista.Lines.Add('No se encontraron tareas para este cliente');
end;

//procedimiento  para buscar por tipo trabajo
procedure TFormMain.BtnBuscarTipoClick(Sender: TObject);
var
  tipoBuscado: string;
  i, encontradas: integer;
begin
  tipoBuscado := InputBox('Buscar por tipo', 'Ingrese tipo de trabajo:', '');

  if tipoBuscado = '' then Exit;

  MemoLista.Lines.Clear;
  encontradas := 0;
  MemoLista.Lines.Add('--- TAREAS DE TIPO: ' + tipoBuscado + ' ---');

  for i := 1 to cantTareas do
  begin
    if tareas[i].tipoTrabajo = tipoBuscado then
    begin
      MemoLista.Lines.Add(Format('%d. %s - $%.2f - %s',
        [i, tareas[i].cliente, tareas[i].monto, estadoAString(tareas[i].estado)]));
      encontradas := encontradas + 1;
    end;
  end;

  if encontradas = 0 then
    MemoLista.Lines.Add('No se encontraron tareas de este tipo');
end;
//procedimiento del boton calcular totales
procedure TFormMain.BtnCalcularTotalesClick(Sender: TObject);
begin
  calcularTotales();
  ShowMessage('Totales actualizados');
end;

//procedimiento para organizar por prioridad
procedure TFormMain.BtnOrganizarPrioridadClick(Sender: TObject);

  var
  i: integer;
begin
  if cantTareas = 0 then
  begin
    ShowMessage('No hay tareas para organizar');
    Exit;
  end;

  MemoLista.Lines.Clear;
    MemoLista.Lines.Add('--- LISTA DE TAREAS (' + IntToStr(cantTareas) + ') ---');
  //MemoLista.Lines.Add('=== ORDENADO POR PRIORIDAD (Alta → Media → Baja) ===');

  // PRIMERO: Mostrar tareas con PRIORIDAD ALTA
  for i := 1 to cantTareas do
  begin
    if tareas[i].prioridad = alta then
    begin
      MemoLista.Lines.Add(Format('%d. %s - %s - $%.2f - %s - %s',
        [i, tareas[i].cliente, tareas[i].tipoTrabajo, tareas[i].monto,
         estadoAString(tareas[i].estado), prioridadAString(tareas[i].prioridad)]));
    end;
  end;

  // SEGUNDO: Mostrar tareas con PRIORIDAD MEDIA
  for i := 1 to cantTareas do
  begin
    if tareas[i].prioridad = media then
    begin
      MemoLista.Lines.Add(Format('%d. %s - %s - $%.2f - %s - %s',
        [i, tareas[i].cliente, tareas[i].tipoTrabajo, tareas[i].monto,
         estadoAString(tareas[i].estado), prioridadAString(tareas[i].prioridad)]));
    end;
  end;

  // TERCERO: Mostrar tareas con PRIORIDAD BAJA
  for i := 1 to cantTareas do
  begin
    if tareas[i].prioridad = baja then
    begin
      MemoLista.Lines.Add(Format('%d. %s - %s - $%.2f - %s - %s',
        [i, tareas[i].cliente, tareas[i].tipoTrabajo, tareas[i].monto,
         estadoAString(tareas[i].estado), prioridadAString(tareas[i].prioridad)]));
    end;
  end;


end;

//elimino tarea seleccionando primero y luego la quito por corrimiento
procedure TFormMain.BtnEliminarTareaClick(Sender: TObject);
  var
  numeroTareaStr: string;
  numeroTarea, i: integer;
  inputResult: Boolean;
begin
  if cantTareas = 0 then
  begin
    ShowMessage('No hay tareas para eliminar');
    Exit;
  end;

  //Paso 1: InputQuery para el número
  numeroTareaStr := '1';  // Valor por defecto
  inputResult := InputQuery(
    'Eliminar Tarea',
    Format('Ingresa el número de tarea a eliminar (1 a %d):', [cantTareas]),
    numeroTareaStr
  );

  //Cancelar = Sale inmediatamente
  if not inputResult then
    Exit;

  //Paso 2: Validaciones del número
  try
    numeroTarea := StrToInt(numeroTareaStr);
  except
    ShowMessage('Error: Ingresa un número válido');
    Exit;
  end;

  if (numeroTarea < 1) or (numeroTarea > cantTareas) then
  begin
    ShowMessage(Format('Error: El número debe estar entre 1 y %d', [cantTareas]));
    Exit;
  end;

  //Paso 3: CONFIRMACIÓN antes de eliminar
  if MessageDlg(
    'Confirmar Eliminación',
    Format('¿Estás seguro de eliminar la tarea %d?' + sLineBreak +
           'Cliente: %s' + sLineBreak +
           'Trabajo: %s' + sLineBreak +
           'Monto: $%.2f' + sLineBreak +
           'Estado: %s' + sLineBreak +
           'Prioridad: %s',
           [numeroTarea,
            tareas[numeroTarea].cliente,
            tareas[numeroTarea].tipoTrabajo,
            tareas[numeroTarea].monto,
            estadoAString(tareas[numeroTarea].estado),
            prioridadAString(tareas[numeroTarea].prioridad)]),
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
  begin
    ShowMessage('Eliminación cancelada por el usuario');
    Exit;
  end;

  //Paso 4: Eliminación con corrimiento
  for i := numeroTarea to cantTareas - 1 do
    tareas[i] := tareas[i + 1];

  cantTareas := cantTareas - 1;
  actualizarListaTareas();
  calcularTotales();

  ShowMessage('Tarea eliminada exitosamente');
end;
            //procedimiento para salir del programa y cerrar la sesion
procedure TFormMain.BtnSalirClick(Sender: TObject);
begin
  if MessageDlg(
    'Salir del Organizador Freelance',
    '¿Finalizar sesión y salir del programa?' + sLineBreak +
    Format('Tareas activas: %d', [cantTareas]),
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    ShowMessage('Sesión finalizada con éxito!' + sLineBreak +
                'Gracias por usar Clarity®');
    Application.Terminate;
  end;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
   //PRECARGAR las tareas demo UNA SOLA VEZ al crear el form
  precargarTareasDemo();

  //Actualizar la interfaz
  actualizarListaTareas();
  calcularTotales();

  //Configurar combobox
  ComboEstado.ItemIndex := 0;
  ComboPrioridad.ItemIndex := 1;
end;

end.
