<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="consultaNota.aspx.vb" EnableSessionState="True" Inherits="CochoSystem.consultaNota" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <link rel="Stylesheet" href="../css/formularios.css" type="text/css" />
    <script src="../js/fnConsultaNota.js" type="text/javascript"></script>
    <% Response.WriteFile("../js/fnGeneral.asp")%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.1/themes/base/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
        <link type="text/css" rel="stylesheet" href="../js/calendario/dhtmlgoodies_calendar.css?random=20051112" media="screen" />
    <SCRIPT type="text/javascript" src="../js/calendario/dhtmlgoodies_calendar.js?random=20060118"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                parent.document.getElementById('idFormulario').innerHTML = '';
            });

        function fnImprimeRecibo(Indice) {

            var form1 = document.getElementById('form1');
            document.getElementById('idNotaRemision').value = document.getElementById('idNotaRemisionHidden' + Indice).value;
            document.getElementById('idEmpresa').value = document.getElementById('idEmpresaHidden' + Indice).value;
            document.getElementById('FolioElectronico').value = '70';
            document.getElementById('accion').value = 'NotaRemision';
            form1.target = '_blank';
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

        $(document).ready(function () {

            var porcentajeTop = parent.document.getElementById('menuPrincipal').style.top;


            var objetoDiv = parent.document.getElementById('idFormulario');
            var botonProcesar = document.createElement('a');
            botonProcesar.className = 'btn btn-primary btn-sm';
            botonProcesar.style.width = '200px';
            botonProcesar.innerHTML = 'Buscar';
            botonProcesar.onclick = function () { window.fnPaginarNotaRemision('-0'); };

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
    <script language="javascript" type="text/javascript">
        function fnCancela(Indice) {
           
                var form1 = document.getElementById('form1');
                document.getElementById('idNotaRemision').value = document.getElementById('idNotaRemisionHidden' + Indice).value;
                document.getElementById('idEmpresa').value = document.getElementById('idEmpresaHidden' + Indice).value;
                document.getElementById('FolioElectronico').value = '70';
                document.getElementById('accion').value = 'cancelaNotaRemision';
                //document.getElementById('accion2').value = 'cancelaNotaRemision';
                form1.method = 'POST';
                form1.target = 'fnProcesos';
                form1.submit();
           

        }
        function fnLimpiar() {
            location.reload();
        }

       
        function fnPaginarNotaRemision(valorPaginar) {
            
            var valorInicial = parseFloat(document.getElementById('idPaginaM').value);
            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = 'paginaNotaRemision';
            //document.getElementById('cadenaCliente').value = fnCadenacliente();
            $('#cortinaFiltro').slideUp("slow");

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

     
     </script> 
    <link rel="Stylesheet" href="../css/bootstrap.min.css" />
</head>
<body style="background-color:transparent;">
    <form id="form1">
         <input type="hidden" name="idNotaRemision" id="idNotaRemision" value="" />
        <input type="hidden" name ="idEmpresa" id="idEmpresa" value="" />
        <input type="hidden" name ="FolioElectronico" id="FolioElectronico" value="" />
        <input type="hidden" name ="accion" id="accion" value="" />
        <input type="hidden" name ="accion2" id="accion2" value="" />
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
                
            </tr>
            <tr>
                <td>
                    <input type="text" name="fechaInicialM" id="fechaInicialM" onfocus="displayCalendar(document.forms[0].fechaInicialM, 'dd/mm/yyyy', this)" class="inputCalendario form-control input-sm" value="" />

                </td>
                <td>
                    <input type="text" name="fechaFinalM" id="fechaFinalM" onfocus="displayCalendar(document.forms[0].fechaFinalM, 'dd/mm/yyyy', this)" class="inputCalendario form-control input-sm" value="" />
                </td>
            </tr>
        </table>
        </div>
        <br />
        <table class="table table-condensed">
            <thead>
            <tr>
                <td colspan="9" align="center">
                    <table id="idPaginador" style="padding-top: 0px; display: block;">
                        <tr>
                            <td id="totalRegistroM" align="left" colspan="3"></td>
                            <td>
                                <ul class="pager">
                                    <li class="previous"><a onclick="fnPaginarNotaRemision('-1');" style="cursor:pointer;">Anterior</a></li>
                                </ul>
                            </td>
                            <td>
                                <input type="text" name="idPaginaM" id="idPaginaM" value="0" class="form-control input-sm text-center" style="width:50px;" />
                            </td>
                            <td>
                                <ul class="pager">
                                    <li class="next"><a onclick="javascript:fnPaginarNotaRemision('1');" style="cursor:pointer;">Siguiente</a></li>
                                </ul>
                            </td>
                            <td id="totalPaginas" align="right" colspan="3"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            </thead>
                <tr class="tituloTR">
                    <td>Recibo #</td>
                    <td>Monto</td>
                    <td>Cliente</td>
                    <td>Fecha Recibo</td>
                    <td>Estatus</td>
                    <td>Archivo PDF</td>
                </tr>
             <tbody id="tablaDatosM" style="border-collapse: collapse;"> </tbody>
    </table>
            <input type="hidden" id="totalElementosM" name="totalElementosM" value="0" />
    </form>

    <iframe name="fnProcesos" id="fnProcesos" style="display:none"></iframe> 
    <iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border:0 ridge;visibility:hidden; position:absolute; z-index:65535;"></iframe>

</body>
</html>
