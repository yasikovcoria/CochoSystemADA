<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="opcionSat.aspx.vb" Inherits="CochoSystem.opcionSat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<link rel="Stylesheet" type="text/css" href="../css/formularios.css" />
     <script type="text/javascript" src="../framework/lib/alertify.js"></script>
		<link rel="stylesheet" href="../framework/themes/alertify.core.css" />
		<link rel="stylesheet" href="../framework/themes/alertify.default.css" />

    <title></title>
    <script type="text/javascript">
        function fnEnviar() {
            var formaPago = document.getElementById('formaPagoM').value;
            var metodoPago = document.getElementById('metodoPagoM').value;
            var cuentaPago = document.getElementById('numeroCtaM').value;
            var condicionPago = document.getElementById('condicionPagoM').value;

            if (formaPago == '') {
                alerta('Debe seleccionar la Forma de Pago');
                return false;
            }
            if (metodoPago == '') {
                alerta('Debe seleccionar el metodo de Pago');
                return false;
            }

            window.close();
            window.opener.fnEnviar(formaPago, metodoPago, cuentaPago, condicionPago);
                    }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <fieldset style="padding-bottom:20px; padding-left:10px;box-shadow: 
		0 5px 15px 1px rgba(0, 0, 0, 0.8), 
		0 0 200px 1px rgba(255, 255, 255, 0.5); border:solid 1px; border-color:darkblue; background-color:lightblue;"><legend>OPCIONES SAT</legend>
     <table style="position:relative;  width:300px;  overflow:hidden;  left: 50px; top: 10px; height: 100px;">
            
            <tr style="font-family:Arial"><td style="font-size:12px; font-weight:bold;">Forma de Pago SAT: </td>
                <td >
                    <select id="formaPagoM" name="formaPagoM" runat="server" style="width:150px; font-family:Arial; font-size:12px; font-weight:bold;">
                        <option value="">Seleccione una opcion</option>
                        <option value="Pago en una sola exhibición" >Pago en una sola exhibición</option>
                        <option value="Pago en parcialidades">Pago en parcialidades</option>
                        <option value="número de parcialidad pagada contra el total de parcialidades">número de parcialidad pagada contra el total de parcialidades</option>
                        <option value="Parcialidad 1 de">Parcialidad 1 de</option>
                    </select>

                </td>
                </tr>
            <tr style="font-family:Arial;">
                <td style=" font-family:Arial; font-size:12px; font-weight:bold;">Metodo de Pago SAT:</td>
                <td>
                    <select id="metodoPagoM" name="metodoPagoM" runat="server" style="width:150px; font-family:Arial; font-size:12px; font-weight:bold;">
                        <option value="">Seleccione una opcion</option>
                        <option value="Efectivo">Efectivo</option>
                        <option value="No Identificado">No Identificado</option>
                        <option value="Cheque">Cheque</option>
                        <option value="Tarjeta de crédito">Tarjeta de crédito</option>
                        <option value="Tarjeta de debito">Tarjeta de debito</option>
                        <option value="Transferencia">Transferencia</option>
                        <option value="Deposito">Deposito</option>
                    </select>
                </td>
                </tr>
            <tr style="font-family:Arial">
                <td style=" font-family:Arial; font-size:12px; font-weight:bold;">Cta: </td>
                <td><input style="width:148px;  font-family:Arial; font-size:12px; font-weight:bold;" type="text" runat="server" id="numeroCtaM" name="numeroCtaM" value="" /></td>

            </tr>
               <tr style="font-family:Arial">
                  <td style=" font-family:Arial; font-size:12px; font-weight:bold;">Condicion de Pago:</td>
                <td>
                    <select id="condicionPagoM" name="condicionPagoM" runat="server" style="width:150px;  font-family:Arial; font-size:12px; font-weight:bold;">
                        <option value="">Seleccione una opcion</option>
                        <option value="Contado">Contado</option>
                        <option value="Crédito">Crédito</option>

                    </select>
                </td>
               </tr>

            
        </table>

        </fieldset>
        <br />
    <center><input class="boton_azul2" style="width:110px; height:25px;" type="button" id="enviar" name="enviar" value="Agregar Datos" onclick="javascript: fnEnviar();" />   </center>
    </form>

</body>
     <script type="text/javascript">
         function alerta(texto) {
             //un alert
             alertify.alert(texto, function () {
             });
         }
    </script>
</html>
