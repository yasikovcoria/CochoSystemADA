<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="salidasAlmacen.aspx.vb" Inherits="CochoSystem.salidasAlmacen" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <% Response.WriteFile("../js/fnGeneral.asp")%>
    <link type="text/css" rel="stylesheet" href="../js/calendario/dhtmlgoodies_calendar.css?random=20051112" media="screen" />
    <script type="text/javascript" src="../js/calendario/dhtmlgoodies_calendar.js?random=20060118"></script>
    <link type="text/css" rel="Stylesheet" href="../css/formularios.css" media="screen" />
    <script type="text/javascript" src="../js/jQuery.js"></script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Salidas del Almacen</title>
    <script type="text/javascript">
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
        function fnLimpiar(miForm) {
            location.reload(true);
        }
        $(document).ready(function () {

            var porcentajeTop = parent.document.getElementById('menuPrincipal').style.top;


            var objetoDiv = parent.document.getElementById('idFormulario');
            var botonProcesar = document.createElement('a');
            botonProcesar.className = 'btn btn-primary btn-sm';
            botonProcesar.style.width = '200px';
            botonProcesar.innerHTML = 'Buscar';
            botonProcesar.onclick = function () { window.fnEnviar('Buscar') };

            var botonLimpiar = document.createElement('a');
            botonLimpiar.className = 'btn btn-primary btn-sm';
            botonLimpiar.style.width = '200px';
            botonLimpiar.style.paddingTop = '5px';
            botonLimpiar.innerText = 'Limpiar';
            botonLimpiar.onclick = function () { window.fnLimpiar('form1') };

            var botonImprimir = document.createElement('a');
            botonImprimir.className = 'btn btn-primary btn-sm';
            botonImprimir.style.width = '200px';
            botonImprimir.style.paddingTop = '5px';
            botonImprimir.innerText = 'Imprimir';
            botonImprimir.onclick = function () { window.fnEnviar('generaReporte') };

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
            objetoDiv.appendChild(botonImprimir);


        });
        function fnAgrega() {
            var fechaInicial = $('#fechaInicialProductoM').val();
            var fechaFinal = $('#fechaFinalProductoM').val();
            var nombreProducto = $('#nombreProductoM').val();
            var idProducto = $('#idNombreProductoM').val();


            $('#fechaInicialProductoM').attr('value', fechaInicial);
            $('#fechaFinalProductoM').attr('value', fechaFinal);
            $('#nombreProductoM').attr('value', nombreProducto);
            $('#idNombreProductoM').attr('value', idProducto);

            fnAgregaTRDIM('0', 'Producto', 1, false, 'M', '', false, false, false, '');
            $('#nombreProductoM').val('');
            $('#idNombreProductoM').val('');
            //document.getElementById('nombreProductoM').value = '';
            //document.getElementById('idNombreProductoM').value = '';

            //var td = document.createElement('td');
            //td.style.paddingTop = '';
        }

        function fnSeparaProducto(idSeparar) {
            var objetoProducto = document.getElementById('idNombreProducto' + idSeparar).value;
            var arregloProducto = objetoProducto.split("|");
            document.getElementById('idProducto' + idSeparar).value = arregloProducto[2];
        }

        function fnEnviar(accion) {

            if (accion == 'Buscar') {
                var forma = document.getElementById('form1');
                var cadenaConsulta = '';
                var separadorCadena = '|';
                cadenaConsulta = $('#fechaInicialProductoM').val() + '|' + $('#fechaFinalProductoM').val()+'|';
                for (i = 0; i < forma.length; i++) {
                    var tempobj = forma.elements[i];
                    if (tempobj.id.substring(0, 10) == 'idProducto' && tempobj.id != 'idProductoM') {
                        cadenaConsulta = cadenaConsulta + tempobj.value + '' + separadorCadena;
                    }
                 }
                $('#cadenaConsultaM').attr('value', cadenaConsulta);
                //$('#cortinaFiltroM').slideUp("slow");
            }

            $('#accion').val(accion);
            var form1 = document.getElementById('form1');
            form1.method = 'POST';
            form1.target = 'fnProcesos';
            form1.submit();


        }
    </script>
    <link rel="Stylesheet" href="../css/bootstrap.min.css" />
</head>
<body style="background-color: transparent;">
    <form id="form1">
        <input type="hidden" name="accion" id="accion" />
        <input type="hidden" name="nombreRPT" id="nombreRPT" value="salidasAlmacen.rpt" />
        <input type="hidden" name="rutaRecibo" id="rutaRecibo" value="" />
        <div id="cortinaFiltroM">
            
                <table border="0" cellpadding="10" cellspacing="15">
                    <thead align="center" style="font-weight: bold;">
                        <tr>
                            <td>
                                <label for="fechaM">Fecha Inicial</label></td>
                            <td>
                                <label for="fechaFinal">Fecha Final</label></td>
                        </tr>
                    </thead>
                    <tr>
                        <td align="center" style="padding-right: 10px;">
                            <input type="text" name="fechaInicialProductoM" class="inputCalendario form-control input-sm" id="fechaInicialProductoM" onfocus="displayCalendar(document.forms[0].fechaInicialProductoM, 'dd/mm/yyyy', this)" />
                        </td>
                        <td align="center">
                            <input type="text" name="fechaFinalProductoM" id="fechaFinalProductoM" class="inputCalendario form-control input-sm" onfocus="displayCalendar(document.forms[0].fechaFinalProductoM, 'dd/mm/yyyy', this)" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="center" style="padding-top:5px;"><strong>Productos</strong></td>
                    </tr>
                    <tr>
                        <td style="padding-top: 5px;" colspan="3" align="center" id="tdProducto1">
                            <input type="text" name="nombreProductoM" id="nombreProductoM" class="form-control input-sm" onkeydown="javascript:fnObtenPosicionInput('nombreProductoM');catalogo.verificaCatalogo('Producto','nombreProductoM','idNombreProductoM','catalogo',50,300,100,'','parent.fnSeparaProducto(\'M\');',event,10,false,false,false,'parent');"
                                onblur="javascript:if(this.value=='') {document.getElementById('idNombreProductoM').value='';}" onchange="if(this.value=='') {document.getElementById('idNombreProductoM').value='';}" />
                            <input type="hidden" id="idNombreProductoM" name="idNombreProductoM" />
                            <input type="hidden" id="idProductoM" name="idProductoM" />
                        </td>
                        <td style="padding-top: 5px;">
                            <input type="button" class="btn btn-info" style="height: 30px;" onclick="fnAgrega();" value="Ok" />
                        </td>
                    </tr>
                    <tbody id="bodyProductoM"></tbody>
                    <tfoot>
                        <tr style="display: none">
                            <td>&nbsp;<input type="hidden" name="totalProductoM" id="totalProductoM" value="0"></td>
                        </tr>
                    </tfoot>
                </table>
        </div>
         <input type="hidden" name="cadenaConsultaM" id="cadenaConsultaM" />
    </form>
    <iframe id="fnProcesos" name="fnProcesos" style="display: none; width: 100px; height: 100px; position: absolute; top: 70%;"></iframe>
    <iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border: 0 ridge; visibility: hidden; position: absolute; z-index: 65535;"></iframe>
</body>
</html>
