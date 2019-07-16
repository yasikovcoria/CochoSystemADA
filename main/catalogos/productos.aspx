<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="productos.aspx.vb" AspCompat="true" EnableSessionState="True" EnableViewStateMac="false" Inherits="CochoSystem.productos" %>

<!DOCTYPE html>

<% 
    Dim objetoPermiso As System.Data.DataView = Nothing

    Dim permisoModificar As String = "", permisoAgregar As String = "", permisoConsultar As String = "", permisoEliminar As String = ""

    Dim styloBotonPermiso As String = ""
    Dim queryPermiso As String = "EXEC [dbo].[spRevisaPermiso]'" + IdEmpresa + "', '" + IdUsuarioPermiso + "', '" + cadenaPermiso + "', 0"
    'Response.Write(queryPermiso)
    objetoPermiso = objetoClases.fnRegresaTabla(queryPermiso, "Permiso")


    If objetoPermiso.Count <> 0 Then
        If objetoPermiso(0)("Modificar").ToString = "0" Then
            permisoModificar = " disabled=true "
            styloBotonPermiso = "background-color:lightgray;"
        End If
        If objetoPermiso(0)("Agregar").ToString = "0" Then
            permisoAgregar = " disabled=true "
        End If
    Else
        permisoModificar = " disabled=true "
        permisoAgregar = " disabled=true "
        styloBotonPermiso = "background-color:lightgray;"
    End If
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <style type="text/css">
        .botonDelete {
            background-color: red;
            text-align: left;
        }
        body {
        filter: alpha(opacity=80);
        }
    </style>
    <% Response.WriteFile("../js/fnGeneral.asp")%>
    <script src="../js/fnProductos.js" type="text/javascript"></script>
    <link rel="Stylesheet" type="text/css" href="../css/formularios.css" />
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.1/themes/base/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
    <script src="../js/fnConsultaFactura.js" type="text/javascript"></script>
    <link type="text/css" rel="stylesheet" href="../js/calendario/dhtmlgoodies_calendar.css?random=20051112" media="screen" />
    <SCRIPT type="text/javascript" src="../js/calendario/dhtmlgoodies_calendar.js?random=20060118"></script>

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

        $(document).ready(function () {



            //var porcentajeTop = parent.document.getElementById('menuPrincipal').style.top;

            var anchoDiv = parent.document.getElementsByClassName('row');
            

            var objetoDiv = parent.document.getElementById('idFormulario');
            objetoDiv.className = 'row col-sm-3 col-md-3';
            var botonProcesar = document.createElement('a');
            botonProcesar.className = 'btn btn-default btn-sm';
            botonProcesar.style.width = '265px';
            botonProcesar.innerHTML = 'Agregar';
            botonProcesar.onclick = function () { window.fnEnviar('agregaProducto') };


            var botonModificar = document.createElement('a');
            botonModificar.className = 'btn btn-default btn-sm';
            botonModificar.style.width = '265px';
            botonModificar.style.paddingTop = '10px';
            botonModificar.innerText = 'Modificar';
            botonModificar.onclick = function () { window.fnEnviar('modificaProducto') };




            var botonBuscar = document.createElement('a');
            botonBuscar.className = 'btn btn-default btn-sm';
            botonBuscar.style.width = '265px';
            botonBuscar.style.padding = '10px;';
            botonBuscar.innerText = 'Buscar';
            botonBuscar.onclick = function () { window.fnEnviar('paginaProducto') };

            var espacio = document.createElement('br');
            var espacio2 = document.createElement('br');
            var espacio3 = document.createElement('br');
            var espacio4 = document.createElement('br');
            var espacio5 = document.createElement('br');

            objetoDiv.innerHTML = '';

            //objetoDiv.appendChild(botonProcesar);
            objetoDiv.appendChild(espacio);
            //objetoDiv.appendChild(espacio2);
            objetoDiv.appendChild(botonBuscar);
            objetoDiv.appendChild(espacio3);
            //objetoDiv.appendChild(espacio4);
            objetoDiv.appendChild(botonModificar);

        });


        function fnAgragaCarrito() {
            if (document.getElementById('nombreProductoM').value == '') {
                parent.mainFrame.alerta('Debe indicar el nombre del producto');
                return false;
            }


            var nombrePproducto = document.getElementById('nombreProductoM').value;
            var modelo = document.getElementById('modeloProductoM').value;
            var color = document.getElementById('colorProductoM').value;
            var talla = document.getElementById('tallaProductoM').value;
            var fecha = document.getElementById('fechaProductoM').value;
            var precioCompra = document.getElementById('precioCompraProductoM').value;
            var precioPublico = document.getElementById('precioPublicoProductoM').value;



            var cantidadProducto = document.getElementById('cantidadProductoM').value;
            var valorUnidad = document.getElementById('nombreUnidadProductoM').value;
            var idValorUnidad = document.getElementById('idUnidadProductoM').value;


            document.getElementById('nombreProductoM').setAttribute('value', nombrePproducto);
            document.getElementById('modeloProductoM').setAttribute('value', modelo);
            document.getElementById('colorProductoM').setAttribute('value', color);
            document.getElementById('tallaProductoM').setAttribute('value', talla);
            document.getElementById('fechaProductoM').setAttribute('value', fecha);
            document.getElementById('precioCompraProductoM').setAttribute('value', precioCompra);
            document.getElementById('precioPublicoProductoM').setAttribute('value', precioPublico);

            document.getElementById('cantidadProductoM').setAttribute('value', cantidadProducto);
            document.getElementById('nombreUnidadProductoM').setAttribute('value', valorUnidad);
            document.getElementById('idUnidadProductoM').setAttribute('value', idValorUnidad);


            fnAgregaTRDIM('0', 'Producto', 10, false, 'M', '', false, false, false, '');


            document.getElementById('nombreProductoM').value = '';
            document.getElementById('cantidadProductoM').value = '';
            document.getElementById('nombreUnidadProductoM').value = '';
            document.getElementById('idUnidadProductoM').value = '';
            document.getElementById('modeloProductoM').value = '';
            document.getElementById('colorProductoM').value = '';
            document.getElementById('tallaProductoM').value = '';
            document.getElementById('fechaProductoM').value = '';
            document.getElementById('precioCompraProductoM').value = '';
            document.getElementById('precioPublicoProductoM').value = '';


        }
        function fnEnviar(accion) {

            if (accion != 'paginaProducto' && accion != 'agregaProducto') {
                if (document.getElementById('nombreProductoM').value == '') {
                    parent.alerta('Debe indicar el nombre del producto');
                    return false;
                }

            }
            if (accion == 'agregaProducto') {

                var valorCarrito = parseInt(document.getElementById('totalProductoM').value);
                if (valorCarrito == 0) {
                    parent.alerta('Debe Agregar un Producto al menos');
                    return false;
                }
            }

            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = accion;
            form1.method = 'POST';
            form1.target = 'fnProcesos';
            form1.submit();


        }



        function fnCargaProducto(idElemento) {

            var tdCantidad = document.getElementById('cantidaProducto');
            tdCantidad.innerText = 'Cantidad Agregar';

            var idMarcaProducto = document.getElementById('idproductoHidden' + idElemento).value;
            var marcaProducto = document.getElementById('nombreProductoHidden' + idElemento).value;
            var unidadProucto = document.getElementById('unidadProductoHidden' + idElemento).value;
            var idUnidadProducto = document.getElementById('idUnidadProductoHidden' + idElemento).value;
            var unidadProducto = document.getElementById('unidadProductoHidden' + idElemento).value;
            var modeloProducto = document.getElementById('modeloProductoHidden' + idElemento).value;
            var colorProducto = document.getElementById('colorProductoHidden' + idElemento).value;
            var tallaProducto = document.getElementById('tallaProductoHidden' + idElemento).value;
            var fechaProducto = document.getElementById('fechaProductoHidden' + idElemento).value;
            var precioCompra = document.getElementById('precioCompraProductoHidden' + idElemento).value;
            var precioPublico = document.getElementById('precioProductoHidden' + idElemento).value;
            var cantidad = document.getElementById('CantidadProductoHidden' + idElemento).value;
            var claveSAT = document.getElementById('claveSatProductoHidden' + idElemento).value;


            precioCompra = precioCompra.replace(",", "");
            precioPublico = precioPublico.replace(",", "");
            cantidad = cantidad.replace(",", "");

            document.getElementById('nombreProductoM').value = marcaProducto;
            document.getElementById('idProductoM').value = idMarcaProducto;
            document.getElementById('nombreUnidadProductoM').value = unidadProucto;
            document.getElementById('idUnidadProductoM').value = idUnidadProducto;
            document.getElementById('modeloProductoM').value = modeloProducto;
            document.getElementById('colorProductoM').value = colorProducto;
            document.getElementById('tallaProductoM').value = tallaProducto;
            document.getElementById('fechaProductoM').value = fechaProducto;
            document.getElementById('precioCompraProductoM').value = precioCompra;
            document.getElementById('precioPublicoProductoM').value = precioPublico;
            document.getElementById('cantidadProductoM').value = '0';
            document.getElementById('claveSATProductoM').value = claveSAT;


        }

    </script>
    <script src="../js/shortcut.js" type="text/javascript"></script>
    <link rel="Stylesheet" href="../css/bootstrap.min.css" />
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
    <script type="text/javascript">
        shortcut.add("Enter", function () {
            fnEnviar('buscar');
        });



        function fnFecha(indice) {

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
                $("#fechaProducto" + indice).datepicker();
            });
        }




    </script>
</head>
<body style="background-color:transparent;">
    <form id="form1" role="form">
        <input type="hidden" name="accion" id="accion" />
        <input type="hidden" name="StyleTR" id="StyleTR" value="lightblue" />
        <input type="hidden" name="valorTRStyle" id="valorTRStyle" value="" />
        <input type="hidden" name="idUsuario" id="idUsuario" value="" />

        <div class="table-responsive">
            
            <table class="table table-hover">

                <tr>
                    <td colspan="6" align="center">
                        <table id="idPaginador" style="padding-left:13em; display: none;" >
                            <thead>
                                <tr>
                                <td id="totalRegistroM" align="left"></td>
                                <td>
                                <ul class="pager">
                                    <li class="previous"><a onclick="fnPaginar('-1');" style="cursor:pointer;">Anterior</a></li>
                                </ul>
                            </td>
                            <td>
                                <input type="text" name="idPaginaM" id="idPaginaM" value="0" class="form-control input-sm text-center" style="width:50px;" />
                            </td>
                            <td>
                                <ul class="pager">
                                    <li class="next"><a onclick="javascript:fnPaginar('1');" style="cursor:pointer;">Siguiente</a></li>
                                </ul>
                            </td>
                                
                                <td id="totalPaginas" align="right"></td>
                                </tr>
                            </thead>
                        </table>

                    </td>
                </tr>
                    <tr align="center" style="background-color:rgba(135, 226, 104, 0.70);">
                        <td>Producto</td>
                        <td>Clave SAT</td>
                        <td>Unidad SAT</td>
                        <td style="display:none">Modelo</td>
                        <td style="display:none">Observaciones</td>
                        <td style="display:none">Talla</td>
                        <td>Fecha</td>
                        <td>P. Compra</td>
                        <td>P. Publico</td>
                        <td id="cantidaProducto">Cantidad</td>
                    </tr>
                <tr align="center">

                    <td id="tdProducto1">

                        <input type="text" class="form-control input-sm" id="nombreProductoM"  name="nombreProductoM" />
                        <input type="hidden" name="idProductoM" id="idProductoM" />
                    </td>
                    <td id="tdProducto2">
                        <input type="text" class="form-control input-sm" id="claveSATProductoM" disabled="disabled" name="claveSATProductoM" />
                    </td>

                    <td id="tdProducto3">
                        <div style="width: 170px">
                            <input  name="nombreUnidadProductoM" id="nombreUnidadProductoM"  placeholder="Unidad SAT" type="text" class="form-control input-sm" maxlength="100" style="font-family: Arial; width: 120px; font-size: 10px; font-weight: bold;"
                                onkeydown="javascript:fnObtenPosicionInput('nombreUnidadProductoM');catalogo.verificaCatalogo('UnidadSATCfdi','nombreUnidadProductoM','idUnidadProductoM','catalogo',50,300,100,'','',event,10,false,false,false,'parent');"
                                onblur="javascript:if(this.value=='') {document.getElementById('idUnidadProductoM').value='';}" onchange="if(this.value=='') {document.getElementById('idUnidadProductoM').value='';}" />
                            <input type="hidden" name="idUnidadProductoM" id="idUnidadProductoM" value="" />

                        </div>
                    </td>

                    <td id="tdProducto4" style="display:none">
                        <input type="text" class="form-control input-sm" id="modeloProductoM" name="modeloProductoM" /></td>
                    <td id="tdProducto5" style="display:none">
                        <input type="text" class="form-control input-sm" id="colorProductoM" name="colorProductoM" /></td>
                    <td id="tdProducto6"  style="display:none">
                        <input type="text" class="form-control input-sm" id="tallaProductoM" name="tallaProductoM" /></td>
                    <td id="tdProducto7">
                        <input onfocus="displayCalendar(document.forms[0].fechaProductoM, 'dd/mm/yyyy', this)" class="form-control input-sm" type="text" id="fechaProductoM" name="fechaProductoM" /></td>
                    <td id="tdProducto8">
                        
                            
                            <input type="number" min="0" step="0.1" data-number-to-fixed="2" data-number-stepfactor="1000" style="width:100px; height:30px;" class="form-control currency" id="precioCompraProductoM" name="precioCompraProductoM" />
                        
                    </td>
                    <td id="tdProducto9">
                        <input type="number" min="0" step="0.1" data-number-to-fixed="2" data-number-stepfactor="100" style="width:100px; height:30px;" class="form-control currency" id="precioPublicoProductoM" name="precioPublicoProductoM" /></td>
                    <td id="tdProducto10">
                        <input type="text" class="form-control input-sm" id="cantidadProductoM" name="cantidadProductoM" /></td>

                    <td>
                        <img src="../img/agregar.png" width="25" height="25" style="cursor: pointer;" title="AGREGAR" onclick="fnAgragaCarrito();" />
                    </td>
                </tr>


                <tbody id="bodyProductoM" ></tbody>
                <tfoot>
                    <tr style="display: none">
                        <td>&nbsp;<input type="hidden" name="totalProductoM" id="totalProductoM" value="0"></td>
                    </tr>
                </tfoot>

                
                <tr style="display:none">
                    <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center;">Marca</td>
                    <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center;">Unidad</td>
                    <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center; display: none" >Modelo</td>
                    <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center; display: none">Color</td>
                    <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center; display: none">Talla</td>
                    <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center; ">Fecha</td>
                    <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center;">P. Compra</td>
                    <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center;">P. Publico</td>
                    <td style="font-size: 14px; font-weight: bold; border: solid 0.1px; border-color: lightblue; text-align: center;">Cantidad</td>
                </tr>

                <tbody id="tablaDatosM" class="table-bordered">
                </tbody>
                <input type="hidden" id="totalElementosM" name="totalElementosM" value="0" />

            </table>
                
        </div>






    </form>
    <iframe id="fnProcesos" name="fnProcesos" style="display: none; width: 100px; height: 100px; position: absolute; top: 70%;"></iframe>
    <iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border: 0 ridge; visibility: hidden; position: absolute; z-index: 65535;"></iframe>
</body>
</html>
