<%@ Page Language="vb" EnableEventValidation="false" ViewStateEncryptionMode="Never" EnableViewStateMac="false" AutoEventWireup="false" CodeBehind="consultaFactura.aspx.vb" Inherits="CochoSystem.consultaFactura" %>

<!DOCTYPE html>

<% 
'Dim objetoPermiso As System.Data.DataView = Nothing
'
'Dim permisoModificar As String = "", permisoAgregar As String = "", permisoConsultar As String = "", permisoEliminar As String = ""
'Dim queryPermiso As String = "EXEC [dbo].[spRevisaPermiso]'" + IdEmpresa + "', '" + sessionUsuario + "', '" + cadenaPermiso + "', 0"
'Response.Write(queryPermiso)
'objetoPermiso = objetoClases.fnRegresaTabla(queryPermiso, "Permiso")
'If objetoPermiso.Count <> 0 Then
'If objetoPermiso(0)("Eliminar").ToString = "0" Then
'permisoEliminar = " var permisoCancelar = 1 ; "
'Else
'permisoEliminar = " var permisoCancelar = 0 ; "
'End If

'End If

%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.1/themes/base/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
    <link type="text/css" rel="stylesheet" href="../js/calendario/dhtmlgoodies_calendar.css?random=20051112" media="screen" />
    <script type="text/javascript" src="../js/calendario/dhtmlgoodies_calendar.js?random=20060118"></script>

    <script src="../js/fnConsultaFactura.js" type="text/javascript"></script>
    <script type="text/javascript" src="../framework/lib/alertify.js"></script>
    <link rel="stylesheet" href="../framework/themes/alertify.core.css" />
    <link rel="stylesheet" href="../framework/themes/alertify.default.css" />


    <link rel="Stylesheet" href="../css/formularios.css" type="text/css" />
    <% Response.WriteFile("../js/fnGeneral.asp")%>
    <script type="text/javascript">

        $(document).ready(function () {
            parent.document.getElementById('idFormulario').innerHTML = '';
        });

        var valorPassword;
        var indice2;

        function fnImprimeRecibo(Indice) {

            var form1 = document.getElementById('form1');
            document.getElementById('idFactura').value = document.getElementById('idFacturaHidden' + Indice).value;
            document.getElementById('idEmpresa').value = document.getElementById('idEmpresaHidden' + Indice).value;
            document.getElementById('FolioElectronico').value = document.getElementById('tipoFolioHidden' + Indice).value;
            document.getElementById('accion').value = 'factura';
            form1.target = '_blank';
            form1.method = 'POST';

            form1.submit();
        }

        function download(dataurl, filename) {
            var a = document.createElement("a");
            a.href = dataurl;
            a.setAttribute("download", filename);
            var b = document.createEvent("MouseEvents");
            b.initEvent("click", false, true);
            a.dispatchEvent(b);

            document.getElementById('accion2').value = '';

            return false;
        }


        function fnEnviaCorreo(Indice) {
            var form1 = document.getElementById('form1');
            document.getElementById('idFactura').value = document.getElementById('idFacturaHidden' + Indice).value;
            document.getElementById('idEmpresa').value = document.getElementById('idEmpresaHidden' + Indice).value;
            document.getElementById('FolioElectronico').value = document.getElementById('tipoFolioHidden' + Indice).value;
            document.getElementById('accion').value = '';
            document.getElementById('accion2').value = 'enviarFactura';
            form1.target = 'fnProcesos';
            form1.method = 'POST';
            form1.submit();
        }
        function fnImprimeXML(Indice) {

            var form1 = document.getElementById('form1');
            document.getElementById('idFactura').value = document.getElementById('idFacturaHidden' + Indice).value;
            document.getElementById('idEmpresa').value = document.getElementById('idEmpresaHidden' + Indice).value;
            document.getElementById('FolioElectronico').value = document.getElementById('tipoFolioHidden' + Indice).value;
            document.getElementById('accion').value = '';
            document.getElementById('accion2').value = 'generaXML';
            form1.target = 'fnProcesos';
            form1.method = 'POST';
            form1.submit();

        }
        function resizeIFrame(idFrame) {

            var the_height = document.getElementById(idFrame).contentWindow.document.body.scrollHeight;
            var the_width = document.getElementById(idFrame).contentWindow.document.body.scrollWidth;
            document.getElementById(idFrame).width = the_width;
            document.getElementById(idFrame).height = the_height;
        }

        function fnObtenPosicionInput(element) {

            var iframe = document.getElementById('catalogo');

            if (typeof element == "string")
                element = document.getElementById(element)

            if (!element) return { top: 0, left: 0 };

            var y = 0;
            var x = 0;
            while (element.offsetParent) {
                x += element.offsetLeft;
                y += element.offsetTop;
                element = element.offsetParent;
            }


            iframe.style.posLeft = x;
            iframe.style.posTop = y + 22;

        }
        var esconderFrame = 0;
        document.onclick = function () { esconderX(); }

        function esconderX() {

            if (esconderFrame == 1) {
                document.getElementById("catalogo").style.visibility = "hidden";

            }
            esconderFrame = 1;
        }

    </script>
    <script language="javascript" type="text/javascript">
        var permisoCancelar = 0;
        function fnCancela2(Indice, confirmacion) {



            if (permisoCancelar == 0) {

                if (confirmacion == 'adamian2018') {
                    var form1 = document.getElementById('form1');
                    document.getElementById('idFactura').value = document.getElementById('idFacturaHidden' + Indice).value;
                    document.getElementById('idEmpresa').value = document.getElementById('idEmpresaHidden' + Indice).value;
                    document.getElementById('FolioElectronico').value = document.getElementById('tipoFolioHidden' + Indice).value;
                    document.getElementById('accion').value = '';
                    document.getElementById('accion2').value = 'cancelaFactura';
                    form1.method = 'POST';
                    form1.target = 'fnProcesos';
                    form1.submit();
                } else {
                    alerta('La contraseña introducida es incorrecta');
                    //alert('La contraseña introducida es incorrecta');

                    return false;
                }
            } else {

                alerta('Usted no tiene permiso para cancelar Facturas');
                return false;
            }

        }
        function fnLimpiar() {
            location.reload();
        }

        function fnElimina(indice) {
            var form1 = document.getElementById('form1');
            var numeroFactura = document.getElementById('numeroFacturaM' + indice).value;
            var IdEmpresa = document.getElementById('IdEmpresaM' + indice).value;
            var folioElectronico = document.getElementById('folioElectronicoM' + indice).value;

            document.getElementById('idFactura').value = numeroFactura;
            document.getElementById('idEmpresa').value = IdEmpresa;
            document.getElementById('FolioElectronico').value = folioElectronico;
            document.getElementById('accion2').value = 'EliminaFactura';
            form1.method = 'POST';
            form1.target = 'XML';
            form1.submit();
        }
        function fnAgregaCliente() {
            var nombreCliente = document.getElementById('clienteFacturaM').value;
            var idNombreCliente = document.getElementById('idClienteFacturaM').value;

            document.getElementById('clienteFacturaM').setAttribute('value', nombreCliente);
            document.getElementById('idClienteFacturaM').setAttribute('value', idNombreCliente);

            fnAgregaTRDIM('0', 'Factura', 2, false, 'M', '', false, false, false, '');
            document.getElementById('clienteFacturaM').value = '';
            document.getElementById('idClienteFacturaM').value = '';

        }
        function fnPaginarFactura(valorPaginar) {

            var valorInicial = parseFloat(document.getElementById('idPaginaM').value);
            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = 'paginaFactura';
            document.getElementById('cadenaCliente').value = fnCadenacliente();
            $('#cortinaFiltro').slideUp("slow");
            //document.getElementById('trPaginadorOculto').style.display = 'block';

            if (valorPaginar == '-1') {
                document.getElementById('idPaginaM').value = valorInicial - 1;
            } else {
                document.getElementById('idPaginaM').value = valorInicial + 1;
            }
            if (valorPaginar == '-0') {
                document.getElementById('idPaginaM').value = '1';
            }

            try {
                form1.method = 'POST';
                form1.target = 'fnProcesos';
                form1.submit();
            } catch (ex) {
                alert(ex.message);
            }

        }
        function fnCadenacliente() {
            var forma = document.getElementById('form1');
            var cadenacliente = '';
            var separadorCadena = '';
            for (i = 0; i < forma.length; i++) {
                var tempobj = forma.elements[i];
                if (tempobj.id.substring(0, 16) == 'idClienteFactura' && tempobj.id != 'idClienteFacturaM') {
                    cadenacliente = cadenacliente + tempobj.value + '|';
                }


            }
            return cadenacliente;
        }
        function fnRecogeValor() {
            valorPassword = document.getElementById('alertify-text').value;
            return valorPassword;
        }
        $(document).ready(function () {

            //var porcentajeTop = parent.document.getElementById('menuPrincipal').style.top;


            var objetoDiv = parent.document.getElementById('idFormulario');
            var botonProcesar = document.createElement('a');
            botonProcesar.className = 'btn btn-default btn-sm';
            botonProcesar.style.width = '260px';
            botonProcesar.innerHTML = 'Buscar';
            botonProcesar.onclick = function () { window.fnPaginarFactura('-0'); };

            var botonLimpiar = document.createElement('a');
            botonLimpiar.className = 'btn btn-default btn-sm';
            botonLimpiar.style.width = '260px';
            botonLimpiar.style.paddingTop = '5px';
            botonLimpiar.innerText = 'Limpiar';
            botonLimpiar.onclick = function () { window.fnLimpiar('form1') };

            var botonImprimir = document.createElement('a');
            botonImprimir.className = 'btn btn-default btn-sm';
            botonImprimir.style.width = '200px';
            botonImprimir.style.paddingTop = '5px';
            botonImprimir.innerText = 'Imprimir';
            botonImprimir.onclick = function () { window.fnEnviar('imprimir') };

            var espacio = document.createElement('br');
            var espacio2 = document.createElement('br');
            var espacio3 = document.createElement('br');
            var espacio4 = document.createElement('br');
            var espacio5 = document.createElement('br');

            objetoDiv.innerHTML = '';

            objetoDiv.appendChild(botonProcesar);
            objetoDiv.appendChild(espacio);
            //objetoDiv.appendChild(espacio2);
            objetoDiv.appendChild(botonLimpiar);
            objetoDiv.appendChild(espacio3);
            //objetoDiv.appendChild(espacio4);
            //objetoDiv.appendChild(botonImprimir);


        });

        function fnAgregaComplementoPago(idComplemento) {
            alert('Generar Complemento pago');
        }


    </script>
    <link rel="Stylesheet" href="../css/bootstrap.min.css" />
</head>
<body style="background-color: transparent;">
    <form id="form1">
        <input type="hidden" name="idFactura" id="idFactura" value="" />
        <input type="hidden" name="idEmpresa" id="idEmpresa" value="" />
        <input type="hidden" name="FolioElectronico" id="FolioElectronico" value="" />
        <input type="hidden" name="accion" id="accion" value="" />
        <input type="hidden" name="accion2" id="accion2" value="" />
        <input type="hidden" name="pagina" id="pagina" value="" />
        <input type="hidden" name="cadenaCliente" id="cadenaCliente" value="" />
        <input type="hidden" name="StyleTR" id="StyleTR" value="lightblue" />
        <input type="hidden" name="valorTRStyle" id="valorTRStyle" value="" />

        <div id="cortinaFiltro" align="center">
            <table border="0" cellpadding="10" cellspacing="15">
                <tr align="center">
                    <td>
                        <span>Fecha Inicial</span>
                    </td>

                    <td>
                        <span>Fecha Final</span>
                    </td>
                    <td>Razon Social
                    </td>
                </tr>
                <tr>
                    <td>
                        <input type="text" name="fechaInicialM" id="fechaInicialM" onfocus="displayCalendar(document.forms[0].fechaInicialM, 'dd/mm/yyyy', this)" class="inputCalendario form-control input-sm" value="" />

                    </td>
                    <td>
                        <input type="text" name="fechaFinalM" id="fechaFinalM" onfocus="displayCalendar(document.forms[0].fechaFinalM, 'dd/mm/yyyy', this)" class="inputCalendario form-control input-sm" value="" />
                    </td>
                    <td>
                        <input name="nombreEmpresaM" id="nombreEmpresaM" class="form-control input-sm"
                            onkeydown="javascript:fnObtenPosicionInput('nombreEmpresaM');catalogo.verificaCatalogo('TipoFolio','nombreEmpresaM','IdEmpresaM','catalogo',50,300,100,'AND?TIFIdTipoFolio&IN(100)','',event,10,false,false,false,'parent');"
                            onblur="javascript:if(this.value=='') {document.getElementById('IdEmpresaM').value='';}" onchange="if(this.value=='') {document.getElementById('IdEmpresaM').value='';}" />
                        <input type="hidden" id="IdEmpresaM" name="IdEmpresaM" />
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="3">
                        <table>
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td align="right" id="tdFactura1"><strong>Cliente</strong></td>
                                            <td valign="bottom" align="left" id="tdFactura2">
                                                <input name="clienteFacturaM" id="clienteFacturaM" class="form-control input-sm" style="width: 300px;"
                                                    onkeydown="javascript:fnObtenPosicionInput('clienteFacturaM');catalogo.verificaCatalogo('Cliente','clienteFacturaM','idClienteFacturaM','catalogo',50,300,100,'','',event,10,false,false,false,'parent');"
                                                    onblur="javascript:if(this.value=='') {document.getElementById('idClienteFacturaM').value='';}" onchange="if(this.value=='') {document.getElementById('idClienteFacturaM').value='';}" />
                                                <input type="hidden" id="idClienteFacturaM" name="idClienteFacturaM" value="" />
                                            </td>
                                            <td align="left">
                                                <input type="button" name="agregaTR" id="agregaTR" class="btn btn-info" style="height: 30px;" onclick="fnAgregaCliente();" value="OK" />
                                            </td>
                                        </tr>
                                        <tbody id="bodyFacturaM">
                                        </tbody>
                                        <tfoot>
                                            <tr style="display: none">
                                                <td>&nbsp;<input type="hidden" name="totalFacturaM" id="totalFacturaM" value="0"></td>
                                            </tr>
                                        </tfoot>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <div>
            <table class="table table-hover">
                <thead>
                    <tr id="trPaginadorOculto">
                        <td colspan="8">
                            <table id="idPaginador" style="padding-top: 0px; padding-left: 25%; display: block;">
                                <tr>
                                    <td id="totalRegistroM" align="center" colspan="3"></td>
                                    <td>
                                        <ul class="pager">
                                            <li class="previous"><a onclick="fnPaginarFactura('-1');" style="cursor: pointer;">Anterior</a></li>
                                        </ul>
                                    </td>
                                    <td>
                                        <input type="text" name="idPaginaM" id="idPaginaM" value="0" class="form-control input-sm text-center" style="width: 50px;" />
                                    </td>
                                    <td>
                                        <ul class="pager">
                                            <li class="next"><a onclick="javascript:fnPaginarFactura('1');" style="cursor: pointer;">Siguiente</a></li>
                                        </ul>
                                    </td>
                                    <td id="totalPaginas" align="right" colspan="3"></td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </thead>
                <tr class="table" style="text-align:center;">
                    <td>Recibo #</td>
                    <td>Monto</td>
                    <td>Cliente</td>
                    <td>Fecha Recibo</td>
                    <td>Estatus UUID</td>
                    <td>XML</td>
                    <td>PDF</td>
                    <td>MAIL</td>
                </tr>
                <tbody id="tablaDatosM" class="table table-hover"></tbody>
            </table>
        </div>
        <input type="hidden" id="totalElementosM" name="totalElementosM" value="0" />

    </form>

    <iframe name="fnProcesos" id="fnProcesos" style="display: none"></iframe>
    <iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border: 0 ridge; visibility: hidden; position: absolute; z-index: 65535;"></iframe>

</body>
<script type="text/javascript">

    function alerta(texto) {
        //un alert
        alertify.alert(texto, function () {
        });
    }

    function fnCancela(valor2) {
        //un prompt

        //alerta('Esta opcion ya no se encuentra disponible debido a los nuevos lineamientos del SAT.');
        //return false;

        indice2 = valor2;

        var valor = alertify.prompt("Ingrese su Contraseña para Cancelar:", function (e, str) {
            if (e) {

                alertify.success("Has pulsado '" + alertify.labels.ok + "'' e introducido: " + str);
            } else {
                alertify.error("Has pulsado '" + alertify.labels.cancel + "'");
            }

        });


        return false;
    }
</script>
</html>
