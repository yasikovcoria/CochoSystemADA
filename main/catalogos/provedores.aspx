<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="provedores.aspx.vb" EnableSessionState="True" Inherits="CochoSystem.provedores" %>

<!DOCTYPE html>
<% 
    ' Dim permisoModificar As String = "", permisoAgregar As String = "", permisoConsultar As String = "", permisoEliminar As String = ""
    'Dim queryPermiso As String = "EXEC [dbo].[spRevisaPermiso]'" + IdEmpresa + "', '" + sessionUsuario + "', '" + cadenaPermiso + "', 0"
    'Dim objetoPermiso As System.Data.DataView = Nothing
    'objetoPermiso = objetoClases.fnRegresaTabla(queryPermiso, "Permiso")
    'If objetoPermiso.Count <> 0 Then
    'If objetoPermiso(0)("Modificar").ToString = "0" Then
    'permisoModificar = " disabled=true "
    'End If
    'End If
    
 %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <style type="text/css">
        .botonDelete {
            background-color:red;
            text-align:left;
        }
    </style>
    <% Response.WriteFile("../js/fnGeneral.asp")%>
    <script src="../js/fnProvedor.js" type="text/javascript"></script>
    <link rel="Stylesheet" type="text/css" href="../css/formularios.css" />
    <script type="text/javascript">
        var objetoDiv = parent.document.getElementById('idFormulario');
        objetoDiv.innerHTML = '';
        var esconderFrame = 0;
        document.onclick = function () { esconderX(); }

        function esconderX() {

            if (esconderFrame == 1) {
                document.getElementById("catalogo").style.visibility = "hidden";

            }
            esconderFrame = 1;
        }
        function fnPaginarProvedor(valorPaginar) {

            var valorInicial = parseFloat(document.getElementById('idPaginaM').value);
            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = 'paginaProvedor';
            if (valorPaginar == '-1') {
                document.getElementById('idPaginaM').value = valorInicial - 1;
            } else {
                document.getElementById('idPaginaM').value = valorInicial + 1;
            }
            try {
                form1.method = 'POST';
                form1.target = 'fnProcesos';
                form1.submit();
            } catch (ex) {
                parent.alerta(ex.message);
            }

        }

        function fnAgragaCarrito() {
            if (document.getElementById('nombreProvedorM').value == '') {
                parent.alerta('Debe indicar el nombre del Provedor');
                return false;
            }
           
            var nombreProvedorM = document.getElementById('nombreProvedorM').value;
            var RFCProvedorM = document.getElementById('RFCProvedorM').value;
            var direccionProvedorM = document.getElementById('direccionProvedorM').value;
            var telefonoProvedorM = document.getElementById('telefonoProvedorM').value;
            

            document.getElementById('nombreProvedorM').setAttribute('value', nombreProvedorM);
            document.getElementById('RFCProvedorM').setAttribute('value', RFCProvedorM);
            document.getElementById('direccionProvedorM').setAttribute('value', direccionProvedorM);
            document.getElementById('telefonoProvedorM').setAttribute('value', telefonoProvedorM);
            
            fnAgregaTRDIM('0', 'Provedor', 2, true, 'M', '', false, false, false, '');

            document.getElementById('nombreProvedorM').value = ' ';
            document.getElementById('RFCProvedorM').value = ' ';
            document.getElementById('direccionProvedorM').value = ' ';
            document.getElementById('telefonoProvedorM').value = ' ';
            
        }
        function fnEnviar(accion) {

            if (accion != 'paginaProvedor' && accion != 'agregaProvedor') {
                if (document.getElementById('nombreProvedorM').value == '') {
                    parent.alerta('Debe indicar el nombre del Provedor');
                    return false;
                }
               
            }
            if (accion == 'agregaProvedor') {

                var valorCarrito = parseInt(document.getElementById('totalProvedorM').value);
                if (valorCarrito == 0) {
                    parent.alerta('Debe Agregar un Provedor al menos');
                    return false;
                }
            }

            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = accion;
            form1.method = 'POST';
            form1.target = 'fnProcesos';
            form1.submit();

        }

        
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <input type="hidden" name="accion" id="accion" />
        <input type="hidden" name="StyleTR" id="StyleTR" value="lightblue" />
        <input type="hidden" name="valorTRStyle" id="valorTRStyle" value="" />
    <table width="900">
            <tr align="center">
                <td align="center">
                    <table>
                        <tr>
                            <td style="font-size: 15px; font-weight: bold; font-family: Arial;">
                                <fieldset style="border: solid 1.5px rgba(185,186,187,0.25);">Catalogo de Provedores</fieldset>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="900" style="padding-bottom: 50px;">
            <tr>
                <td align="center">
                    <table>
                        <tr style="background-color: #399FFF; color:white; font-family: Arial; font-size: 14px; font-weight: bold;">
                            <td style="width: 200px; text-align: center;">Nombre del Provedor</td>
                            <td style="width: 200px; text-align: center;">R.F.C</td>
                            <td style="width: 200px; text-align: center;">Direccion</td>
                            <td style="width: 200px; text-align: center;">Telefono</td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr style="display: none">
                <td id="tdProvedor1" style="color: #FF0000; font-Size: 9px; font-Weight: bold;" width="20px;" align="right">&nbsp;<input name="idConsecutivoProvedorM" id="idConsecutivoProvedorM" value="ProvedorM" type="hidden">
                </td>
            </tr>
            <tr>
                <td align="center" id="tdProvedor2">
                    <table>
                        <tr>
                            <td style="width: 200px;">
                                <input style="width: 180px; font-family: Arial; font-size: 14px; font-weight: bold;" class="text" type="text" id="nombreProvedorM" name="nombreProvedorM" />
                                <input type="hidden" name="idProvedorM" id="idProvedorM" />
                            </td>
                            
                            <td style="width: 200px; text-align: center;">
                                <input style="width: 180px; font-family: Arial; font-size: 14px; font-weight: bold;" class="text"  type="text" id="RFCProvedorM" name="RFCProvedorM" /></td>
                           
                            <td style="width: 200px; text-align: center;">
                                <input style="width: 180px; font-family: Arial; font-size: 14px; font-weight: bold;" class="text"  type="text" id="direccionProvedorM" name="direccionProvedorM" /></td>
                            <td style="width: 200px; text-align: center;">
                                <input style="width: 180px; font-family: Arial; font-size: 14px; font-weight: bold;" class="text"  type="text" id="telefonoProvedorM" name="telefonoProvedorM" /></td>
                        </tr>

                    </table>
                </td>
                <td align="left">
                    <img src="../img/agregar.png" width="25" height="25" style="cursor: pointer;" title="AGREGAR" onclick="fnAgragaCarrito();" />
                </td>
            </tr>
            <tr align="center">
                <td align="center">
                    <table style="padding-left:1%;">
                        <tr align="center">
                            <td>
                                <table>
                                    <tbody id="bodyProvedorM"></tbody>
                                    <tfoot>
                                        <tr style="display: none">
                                            <td>&nbsp;<input type="hidden" name="totalProvedorM" id="totalProvedorM" value="0"></td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="center">
                    <fieldset style="border: solid 1.5px rgba(185,186,187,0.25);">
                        <legend style="font-weight: bold; font-size: 13px; font-family: sans-serif;">Opciones</legend>
                        <table>
                            <tr align="center">
                                <td>
                                    <input type="button" id="agregarM" name="agregarM" value="Agregar" onclick="fnEnviar('agregaProvedor');" class="boton_azul2" style="height:25px;"/></td>
                                <td>
                                    <input type="button" id="consultaM" name="consultaM" value="Consultar" onclick="fnEnviar('paginaProvedor');" class="boton_azul2" style="height:25px;"/></td>
                                <td>
                                    <input type="button" id="modificaM" name="modificaM" value="Modificar" onclick="fnEnviar('modificaProvedor');" class="boton_azul2" style="height:25px;"/></td>
                            </tr>
                        </table>
                    </fieldset>
                </td>
            </tr>
            <tr>
                <td>
                    <table style="padding-top: 20px;">
                        <tr>
                            <td>
                                <fieldset style="border: solid 1.5px rgba(185,186,187,0.25);">
                                    <table id="idPaginador" style="padding-top: 0px; padding-left: 27%; display: none;">
                                        <tr>
                                            <td>
                                                <fieldset style="border: solid 1.5px rgba(185,186,187,0.25); height:10px;">
                                                    <table>
                                                        <tr>
                                                            <td id="totalRegistroM" style="font-size: 10px; font-family: Arial; font-weight: bold;"></td>
                                                        </tr>
                                                    </table>
                                                </fieldset>
                                            </td>

                                            <td>
                                                <img src="../img/atras.jpg" width="30" title="Retroceder Pagina" height="20" onclick="fnPaginarProvedor('-1');" style="cursor: pointer;" />
                                            </td>

                                            <td>
                                                <fieldset style="border: solid 1.5px rgba(185,186,187,0.25); height:10px;">
                                                    <table>
                                                        <tr>

                                                            <td>
                                                                <input type="text" name="idPaginaM" id="idPaginaM" value="0" style="width: 30px; height: 15px; text-align: center; font-size: 10px; font-family: Arial; font-weight: bold;" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </fieldset>
                                            </td>
                                            <td>
                                                <img src="../img/adelante.jpg" style="cursor: pointer" title="Adelante Pagina" onclick="javascript:fnPaginarProvedor('1');" width="30" height="20" />
                                            </td>
                                            <td>
                                                <fieldset style="border: solid 1.5px rgba(185,186,187,0.25); height:10px;">
                                                    <table>
                                                        <tr>
                                                            <td id="totalPaginas" style="font-size: 10px; font-family: Arial; font-weight: bold;"></td>
                                                        </tr>
                                                    </table>
                                                </fieldset>
                                            </td>

                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <fieldset style="border: solid 1.5px rgba(185,186,187,0.25);">
                                    <table width="900">
                                        <tr>
                                            <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center; width: 200px;">Nombre Provedor</td>
                                            <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center; width: 200px;">R.F.C Provedor</td>
                                            <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center; width: 200px;">Direccion</td>
                                            <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center; width: 200px;">Telefono</td>
                                        </tr>
                                    </table>
                                </fieldset>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table id="tablaDatosM" width="900" style="border-collapse: collapse;">
                                </table>
                                <input type="hidden" id="totalElementosM" name="totalElementosM" value="0" />
                            </td>

                        </tr>
                    </table>
                </td>
            </tr>
            </table>
    </form>
        <iframe id="fnProcesos" name="fnProcesos" style="display: none; width: 100px; height: 100px; position: absolute; top: 70%;"></iframe>
        <iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border: 0 ridge; visibility: hidden; position: absolute; z-index: 65535;"></iframe>

</body>
</html>
