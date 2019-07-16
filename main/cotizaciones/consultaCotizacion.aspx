<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="consultaCotizacion.aspx.vb" Inherits="CochoSystem.consultaCotizacion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.1/themes/base/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
        <link type="text/css" rel="stylesheet" href="../js/calendario/dhtmlgoodies_calendar.css?random=20051112" media="screen" />
    <SCRIPT type="text/javascript" src="../js/calendario/dhtmlgoodies_calendar.js?random=20060118"></script>

    <script type="text/javascript" src="../js/fnCotizacion.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="Stylesheet" type="text/css" href="../css/formularios.css" />
    <script type="text/javascript">
        var objetoDiv = parent.document.getElementById('idFormulario');
        objetoDiv.innerHTML = '';

        function fnConsulta() {
            document.getElementById('accion').value = 'consultaCotizacion';
            var form1 = document.getElementById('form1');
            form1.method = 'POST';
            form1.target = 'fnProcesos';
            form1.submit();
        }

        function fnImprimeCotizacion(idElemnto) {
            document.getElementById('accion').value = 'imprimeCot';
            document.getElementById('numeroCot').value = document.getElementById('idCotizacion' + idElemnto).value;
            var form1 = document.getElementById('form1');
            form1.method = 'POST';
            form1.target = '_blank';
            form1.submit();
        }

        var esconderFrame = 0;
        document.onclick = function () { esconderX(); }

        function esconderX() {

            if (esconderFrame == 1) {
                document.getElementById("catalogo").style.visibility = "hidden";

            }
            esconderFrame = 1;
        }
        function resizeIFrame(idFrame) {

            var the_height = document.getElementById(idFrame).contentWindow.document.body.scrollHeight;
            var the_width = document.getElementById(idFrame).contentWindow.document.body.scrollWidth;
            document.getElementById(idFrame).width = the_width;
            document.getElementById(idFrame).height = the_height;
        }

        function fnLimpiaTabla(idTablaDatos, totalElementos) {

            var tablaDatos = document.getElementById(idTablaDatos);
            try {
                while (tablaDatos.hasChildNodes()) {
                    tablaDatos.removeChild(tablaDatos.firstChild);
                }
                document.getElementById(totalElementos).value = '0';
            } catch (ex) {
                parent.alerta(ex.message);
            }
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

        $(function ($) {
            $.datepicker.regional['es'] = {
                closeText: 'Cerrar',
                prevText: '<Ant',
                nextText: 'Sig>',
                currentText: 'Hoy',
                monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
                monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'],
                dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
                dayNamesShort: ['Dom', 'Lun', 'Mar', 'Mié', 'Juv', 'Vie', 'Sáb'],
                dayNamesMin: ['Do', 'Lu', 'Ma', 'Mi', 'Ju', 'Vi', 'Sá'],
                weekHeader: 'Sm',
                dateFormat: 'dd/mm/yy',
                firstDay: 1,
                isRTL: false,
                showMonthAfterYear: false,
                yearSuffix: ''
            };
            $.datepicker.setDefaults($.datepicker.regional['es']);
        });

        $(function () {

            $("#fechaInicialM").datepicker();
            $("#fechaFinalM").datepicker();

        });

        function fnPaginarCotizacion(valorPaginar) {
            if (document.getElementById('IdEmpresaM').value == '') {
                alert('Debe Seleccionar el nombre de cotizacion.');
                return false;
            }


            var valorInicial = parseFloat(document.getElementById('idPaginaM').value);
            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = 'consultaCotizacion';
            $('#cortinaFiltro').slideUp("slow");

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

        function fnLimpiar() {
            location.reload();
        }

        $(document).ready(function () {

            var porcentajeTop = parent.document.getElementById('menuPrincipal').style.top;


            var objetoDiv = parent.document.getElementById('idFormulario');
            var botonProcesar = document.createElement('a');
            botonProcesar.className = 'btn btn-primary btn-sm';
            botonProcesar.style.width = '200px';
            botonProcesar.innerHTML = 'Buscar';
            botonProcesar.onclick = function () { window.fnPaginarCotizacion('-0'); };

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
        
    </script>
         <link rel="Stylesheet" href="../css/bootstrap.min.css" />
    <title></title>
</head>
<body style="padding:10px; background-color:transparent;">
    <form id="form1" runat="server">
        <input type="hidden" id="accion" name="accion" />
        <input type="hidden" id="numeroCot" name="numeroCot" />
        
         <input type="hidden" name="StyleTR" id="StyleTR" value="lightblue" />
        <input type="hidden" name="valorTRStyle" id="valorTRStyle" value="" />
        <div id="cortinaFiltro" align="center">
        <table border="0" cellpadding="10" cellspacing="15">
             <tr align="center">
                 <td>
                     Nombre Cotizacion
                 </td>                
            </tr>
            <tr>
                <td>
                    <input name="nombreEmpresaM" id="nombreEmpresaM" class="form-control input-sm" style="width:300px;"
                                                onkeydown="javascript:fnObtenPosicionInput('nombreEmpresaM');catalogo.verificaCatalogo('Empresa','nombreEmpresaM','IdEmpresaM','catalogo',50,300,100,'','',event,10,false,false,false,'parent');"
                                                onblur="javascript:if(this.value=='') {document.getElementById('IdEmpresaM').value='';}" onchange="if(this.value=='') {document.getElementById('IdEmpresaM').value='';}" />
                <input type="hidden" id="IdEmpresaM" name="IdEmpresaM" />
                </td>
            </tr>
        </table>
        </div>

        <table class="table table-condensed">
            <thead>
            <tr>
                <td colspan="9" align="center">
                    <table id="idPaginador" style="padding-top: 0px; display: block;">
                        <tr>
                            <td id="totalRegistroM" align="left" colspan="3"></td>
                            <td>
                                <ul class="pager">
                                    <li class="previous"><a onclick="fnPaginarCotizacion('-1');" style="cursor:pointer;">Anterior</a></li>
                                </ul>
                            </td>
                            <td>
                                <input type="text" name="idPaginaM" id="idPaginaM" value="0" class="form-control input-sm text-center" style="width:50px;" />
                            </td>
                            <td>
                                <ul class="pager">
                                    <li class="next"><a onclick="javascript:fnPaginarCotizacion('1');" style="cursor:pointer;">Siguiente</a></li>
                                </ul>
                            </td>
                            <td id="totalPaginas" align="right" colspan="3"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            </thead>
                <tr class="tituloTR">
                    <td>Numero Cotizacion</td>
                    <td>Nombre Cliente</td>
                    <td>Monto Cotizado</td>
                    <td>Fecha Cotizacion</td>
                    <td>PDF</td>
                </tr>
             <tbody id="tablaDatosM" style="border-collapse: collapse;" align="center"> </tbody>
    </table>
        <input type="hidden" id="totalElementosM" name="totalElementosM" value="0" />
    </form>
    <iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border:0 ridge;visibility:hidden; position:absolute; z-index:65535;"></iframe>
        <iframe id="fnProcesos" name="fnProcesos" style="display:none; width:100px; height:100px; position:absolute; top:70%;"></iframe>

</body>
</html>
