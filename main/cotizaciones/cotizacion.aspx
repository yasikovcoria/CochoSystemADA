<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="cotizacion.aspx.vb" Inherits="CochoSystem.cotizacion" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head >
<script src="../js/JQuery.js" type="text/javascript"></script>
    
    <script src="../js/fnFunciones.js" type="text/javascript"></script>
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.1/themes/base/jquery-ui.css" />
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.1/jquery-ui.js"></script>
        <link rel="Stylesheet" type="text/css" href="../css/formularios.css" />
    <link type="text/css" rel="stylesheet" href="../js/calendario/dhtmlgoodies_calendar.css?random=20051112" media="screen" />
	<SCRIPT type="text/javascript" src="../js/calendario/dhtmlgoodies_calendar.js?random=20060118"></script>
    <% Response.WriteFile("../js/fnGeneral.asp")%>
    
    <script type="text/javascript">

        $(document).ready(function () {
            parent.document.getElementById('idFormulario').innerHTML = '';
        });
        var esconderFrame = 0;
        document.onclick = function () { esconderX(); }

        function esconderX() {

            if (esconderFrame == 1) {
                document.getElementById("catalogo").style.visibility = "hidden";

            }
            esconderFrame = 1;
        }

        function fnImprimeRecibo(idEmpresa, numeroCotizacion, tipoFolio) {

            var form1 = document.getElementById('form1');

            document.getElementById('idCotizacion').value = numeroCotizacion;
            document.getElementById('idEmpresa').value = idEmpresa;
            document.getElementById('FolioElectronico').value = tipoFolio;
            document.getElementById('accion').value = 'Cotizacion';
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


        function fnEnviar() {

            if (confirm('Estas seguro que la informacion es correcta??')) {
                document.getElementById('accion').value = 'generaCotizacion';
                var form1 = document.getElementById('form1');
                form1.method = 'POST';
                form1.target = 'fnProcesos';
                form1.submit();
            }

        }

        function fnConsecutivoRecibo(TipoFolio) {

            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = 'consecutivoRecibo';
            form1.method = 'POST';
            form1.target = 'fnProcesos';
            form1.submit();

        }

        function fnTotalImporte(idElementoCalculo) {

            precioVenta = document.getElementById('precioCotizacion' + idElementoCalculo).value;
            cantidadVenta = document.getElementById('cantidadCotizacion' + idElementoCalculo).value;

            importeVenta = (precioVenta * cantidadVenta).toFixed(2);

            if (precioVenta == '0') {
                document.getElementById('importeCotizacion' + idElementoCalculo).value = '0';

            } else {
                document.getElementById('importeCotizacion' + idElementoCalculo).value = parseFloat(importeVenta).toFixed(2);


            }

        }


        function fnAgragaCarrito() {
            var valorCantidad = document.getElementById('cantidadCotizacionM').value;
            var valorUnidad = document.getElementById('idUnidadCotizacionM').value;
            var valorNombreUnidad = document.getElementById('nombreUnidadCotizacionM').value;
            var valorDescripcion = document.getElementById('descripcionCotizacionM').value;
            var valorPrecio = document.getElementById('precioCotizacionM').value;
            var valorImporte = document.getElementById('importeCotizacionM').value;
            var idDescripcion = document.getElementById('idDescripcionCotizacionM').value;
            var nombreDescripcion = document.getElementById('nombredescripcionCotizacionM').value;

            document.getElementById('cantidadCotizacionM').setAttribute('value', valorCantidad);
            document.getElementById('descripcionCotizacionM').setAttribute('value', valorDescripcion);
            document.getElementById('idUnidadCotizacionM').setAttribute('value', valorUnidad);
            document.getElementById('nombreUnidadCotizacionM').setAttribute('value', valorNombreUnidad);
            document.getElementById('precioCotizacionM').setAttribute('value', valorPrecio);
            document.getElementById('importeCotizacionM').setAttribute('value', valorImporte);
            document.getElementById('idDescripcionCotizacionM').setAttribute('value', idDescripcion);
            document.getElementById('nombredescripcionCotizacionM').setAttribute('value', nombreDescripcion);

            fnAgregaTRDIM('0', 'Cotizacion', 5, false, 'M', '', false, false, false, '');
            fnSumaTotalCotizacion('Cotizacion', '');


            document.getElementById('cantidadCotizacionM').value = '0';
            document.getElementById('descripcionCotizacionM').value = '';
            document.getElementById('idUnidadCotizacionM').value = '';
            document.getElementById('nombreUnidadCotizacionM').value = '';
            document.getElementById('precioCotizacionM').value = '0.00';
            document.getElementById('importeCotizacionM').value = '0.00';
            document.getElementById('nombredescripcionCotizacionM').value = '';
            document.getElementById('idDescripcionCotizacionM').value = '';

        }

        function fnChecaIva4() {
            var banderaChek;
            var bandera5Millar;
            bandera5Millar = document.getElementById('retencion5').checked;
            banderaChek = document.getElementById('retencionIsr').checked;
            if (banderaChek == true || bandera5Millar) {
                parent.alerta('Esta Opcion no aplica');
                document.getElementById('retencionIva4').checked = false;
            }
        }

        function fnRet5() {
            var baderaRet5 = document.getElementById('retencion5').checked;
            if (baderaRet5 == true) {
                fnSumaTotalCotizacion('Cotizacion', 'RET5');
            } else {

                fnSumaTotalCotizacion('Cotizacion', 'LIMPIA5');
            }
        }

        function fnRetieneIsr() {
            var banderaCheked;
            banderaCheked = document.getElementById('retencionIva').checked;
            if (banderaCheked == true) {
                document.getElementById('retencionIsr').checked = true;
                fnSumaTotalCotizacion('Cotizacion', 'ISR');


            } else {
                document.getElementById('retencionIsr').checked = false;
                fnSumaTotalCotizacion('Cotizacion', 'LIMPIAISR');
            }

        }

        function fnSumaTotalCotizacion(idEnviado, opcion) {

            //Cotizacion
            //Factura
            var totalCotizacion = 0;
            var forma = document.getElementById('form1');
            for (i = 0; i < forma.length; i++) {
                var tempobj = forma.elements[i];
                if (tempobj.id.substring(0, 17) == 'importe' + idEnviado + '' && tempobj.id != 'importe' + idEnviado + 'M') {
                    totalCotizacion += parseFloat(tempobj.value.toString().replace(/\$|\,|\%/g, ''));
                }
            }


            var ivaCotizacion = (totalCotizacion * (16 / 100));
            var totalCotizacionM = ivaCotizacion + totalCotizacion;
            document.getElementById('subTotalM').value = totalCotizacion.toFixed(2);
            document.getElementById('ivaM').value = ivaCotizacion.toFixed(2);
            document.getElementById('totalFacM').value = totalCotizacionM.toFixed(2);

            if (opcion == 'ISR') {
                var RetencionISR = (totalCotizacion * (10 / 100));
                var RetencionIVA = (totalCotizacion * (10.67 / 100));
                document.getElementById('ivaRetM').value = RetencionIVA.toFixed(2);
                document.getElementById('isrRetM').value = RetencionISR.toFixed(2);
                document.getElementById('totalFacM').value = (totalCotizacionM - RetencionISR - RetencionIVA).toFixed(2);
            }
            if (opcion == 'LIMPIAISR') {
                document.getElementById('ivaRetM').value = '0.00';
                document.getElementById('isrRetM').value = '0.00';
            }
            if (opcion == 'RET5') {
                var valorRetencionIVA = parseFloat(document.getElementById('ivaRetM').value);
                var valorRetencionISR = parseFloat(document.getElementById('isrRetM').value);
                var valorRET5 = (totalCotizacionM * (5 / 100));
                document.getElementById('ret5M').value = valorRET5.toFixed(2);
                document.getElementById('totalFacM').value = (totalCotizacionM - valorRetencionIVA - valorRetencionISR - valorRET5).toFixed(2);
            }

            if (opcion == 'LIMPIA5') {
                var valorRetencionIVA = parseFloat(document.getElementById('ivaRetM').value);
                var valorRetencionISR = parseFloat(document.getElementById('isrRetM').value);
                document.getElementById('ivaRetM').value = valorRetencionIVA.toFixed(2);
                document.getElementById('isrRetM').value = valorRetencionISR.toFixed(2);
                document.getElementById('ret5M').value = '0.00';
                document.getElementById('totalFacM').value = (totalCotizacionM - valorRetencionIVA - valorRetencionISR).toFixed(2);

            }


        }
        function fnOpcionSAT() {
            var nueva_ventana = window.open('opcionSat.aspx', 'Opciones SAT', 'width=400px,height=300px,top=200px,left=400px,menubar=yes,resizable=no,location=no,scrollbars=no,status=no,toolbar=no');
        }
        function fnLimpiaCotizacion() {
            var form1 = document.getElementById('form1');
            document.getElementById('cantidadCotizacionM').value = '';
            document.getElementById('nombreUnidadCotizacionM').value = '';
            document.getElementById('precioCotizacionM').value = '';
            document.getElementById('importeCotizacionM').value = '';

            form1.reset();
        }
        function fnRetornaPrecio(idSeparar) {
            var objetoProducto = document.getElementById('idDescripcionCotizacion' + idSeparar).value;
            var precioProducto = objetoProducto.split("|");
            document.getElementById('precioCotizacion' + idSeparar).value = precioProducto[0];
            document.getElementById('descripcionCotizacion' + idSeparar).value = precioProducto[1];
            document.getElementById('idProductoCotizacion' + idSeparar).value = precioProducto[2];
        }


        $(document).ready(function () {



            var porcentajeTop = parent.document.getElementById('menuPrincipal').style.top;


            var objetoDiv = parent.document.getElementById('idFormulario');
            var botonProcesar = document.createElement('a');
            botonProcesar.className = 'btn btn-primary btn-sm';
            botonProcesar.style.width = '200px';
            botonProcesar.innerHTML = 'Procesar';
            botonProcesar.onclick = function () { window.fnEnviar(); };

            var botonLimpiar = document.createElement('a');
            botonLimpiar.className = 'btn btn-primary btn-sm';
            botonLimpiar.style.width = '200px';
            botonLimpiar.style.paddingTop = '5px';
            botonLimpiar.innerText = 'Limpiar';
            botonLimpiar.onclick = function () { window.fnLimpiar('form1') };


            var espacio = document.createElement('br');
            var espacio2 = document.createElement('br');
            var espacio3 = document.createElement('br');
            var espacio4 = document.createElement('br');
            var espacio5 = document.createElement('br');

            objetoDiv.innerHTML = '';

            objetoDiv.appendChild(botonProcesar);
            objetoDiv.appendChild(espacio);
            objetoDiv.appendChild(botonLimpiar);
            

        });
        function fnLimpiar() {
            location.reload(true);
        }
    </script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link rel="Stylesheet" href="../css/bootstrap.min.css" />
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
</head>
<body style="padding:5px; background-color:transparent;">
    <form id="form1" role="form">
        <input type="hidden" id="accion" name="accion" value="" />
        <input type="hidden" id="IdclienteM"  name="IdclienteM" value="0" />
        <input type="hidden" name="idCotizacion" id="idCotizacion" value="" />
        <input type="hidden" name ="idEmpresa" id="idEmpresa" value="" />
        <input type="hidden" name ="FolioElectronico" id="FolioElectronico" value="" />
        <input type="hidden" name="pagina" id="pagina" value="" />
        <table class="table">

            <tr >
                <td>
                    <label class="control-label">Tipo de Recibo</label>
                    <input name="nombreTipoFolioM" id="nombreTipoFolioM" value="" type="text" class="form-control input-sm" maxlength="100" onkeydown="javascript:fnObtenPosicionInput('nombreTipoFolioM');catalogo.verificaCatalogo('TipoFolio','nombreTipoFolioM','tipoFolioM','catalogo',50,300,100,'AND?TIFIdTipoFolio&IN(70,2)','parent.fnConsecutivoRecibo(campoIdCombo);',event,10,false,false,false,'parent');"
                        onblur="javascript:if(this.value=='') {document.getElementById('tipoFolioM').value='';}" onchange="if(this.value=='') {document.getElementById('tipoFolioM').value='';}" />
                    <input type="hidden" id="tipoFolioM" name="tipoFolioM" value="" />

                </td>
                <td>
                    <label class="control-label">Fecha</label>
                    <input type="text" id="fechaReciboM" name="fechaReciboM" onfocus="displayCalendar(document.forms[0].fechaReciboM, 'dd/mm/yyyy', this)" class="form-control input-sm" />
                </td>
                <td>
                    <label class="control-label">Folio</label>
                    <input type="text" class="form-control input-sm" id="numeroReciboM" name="numeroReciboM" value="" />
                </td>

                <td>
                    <label class="control-label">Cliente</label>
                    <input name="clienteM" id="clienteM" type="text" class="form-control input-sm"
                        onkeydown="javascript:fnObtenPosicionInput('clienteM');catalogo.verificaCatalogo('Cliente','clienteM','IdclienteM','catalogo',50,300,100,'','',event,10,false,false,false,'');"
                        onblur="javascript:if(this.value=='') {document.getElementById('IdclienteM').value='';}" onchange="if(this.value=='') {document.getElementById('IdclienteM').value='';}" />
                   
                </td>


            </tr>
        </table>
        <table class="table" >
             <thead class="tituloTR" align="center">
               <tr>
                <td>Cantidad</td>
                <td >Unidad</td>
                <td >Descripcion</td>
                <td >Precio $</td>
                <td>Importe $</td>
                 <td>Opcion</td>
              </tr>
            </thead>
            <tr align="center">
                <td id="tdCotizacion1">
                    <input type="text" class="form-control input-sm" id="cantidadCotizacionM" name="cantidadCotizacionM" value="" />
                </td>
                <td id="tdCotizacion2">
                    <input name="nombreUnidadCotizacionM" id="nombreUnidadCotizacionM" value="" type="text" class="form-control input-sm" maxlength="100"
                        onkeydown="javascript:fnObtenPosicionInput('nombreUnidadCotizacionM');catalogo.verificaCatalogo('UnidadSAT','nombreUnidadCotizacionM','idUnidadCotizacionM','catalogo',50,300,100,'','',event,10,false,false,false,'parent');"
                        onblur="javascript:if(this.value=='') {document.getElementById('idUnidadCotizacionM').value='';}" onchange="if(this.value=='') {document.getElementById('idUnidadCotizacionM').value='';}" />
                    <input type="hidden" id="idUnidadCotizacionM" name="idUnidadCotizacionM" value="" />
                </td>
                <td id="tdCotizacion3">
                    <input name="nombredescripcionCotizacionM" id="nombredescripcionCotizacionM" class="form-control input-sm" value="" type="text" maxlength="100"
                        onkeydown="javascript:fnObtenPosicionInput('nombredescripcionCotizacionM');catalogo.verificaCatalogo('Producto','nombredescripcionCotizacionM','idDescripcionCotizacionM','catalogo',50,300,100,'','parent.fnRetornaPrecio(\'M\');parent.fnTotalImporte(\'M\');parent.fnSumaTotalCotizacion(\'Cotizacion\',\'\');',event,10,false,false,false,'parent');"
                        onblur="javascript:if(this.value=='') {document.getElementById('idDescripcionCotizacionM').value='';}" onchange="if(this.value=='') {document.getElementById('idDescripcionCotizacionM').value='';}" />

                    <input type="hidden" id="idDescripcionCotizacionM" name="idDescripcionCotizacionM" value="" />
                    <input type="hidden" id="descripcionCotizacionM" name="descripcionCotizacionM" value="" />
                    <input type="hidden" id="idProductoCotizacionM" name="idProductoCotizacionM" value="" />

                </td>
                <td align="center" id="tdCotizacion4">
                    
                        <input type="text" class="form-control input-sm" style="width: 80%;"  onblur="fnTotalImporte('M');fnSumaTotalCotizacion('Cotizacion','');" id="precioCotizacionM" name="precioCotizacionM" value="0" />
                   
                    </td>
                <td align="center" id="tdCotizacion5">
                    <input type="text" class="form-control input-sm" style="width: 80%;" onblur="fnSumaTotalCotizacion('Cotizacion','');" id="importeCotizacionM" name="importeCotizacionM" value="0" /></td>
                <td>
                    <img src="../img/agregar.png" alt="Agregar el Registro" onclick="javascript:fnAgragaCarrito();" style="height: 25px; width: 25px; cursor: pointer" /></td>
            </tr>
            <tbody id="bodyCotizacionM">

            </tbody>
            <tfoot>
                <tr style="display: none">
                    <td>&nbsp;<input type="hidden" name="totalCotizacionM" id="totalCotizacionM" value="0"></td>
                </tr>
            </tfoot>

            <tr>
                <td></td>
                <td></td>
                <td></td>
                
                <td colspan="2">
                    <table class="table table-bordered">
                        <tr>
                            <td align="right" style="font-family: Arial; font-size: 12px; font-weight: bold;">SUBTOTAL</td>
                            <td align="right">
                                <div class="input-group">
                                    <span class="input-group-addon">$</span>
                                    <input style="width: 120px;" type="text" id="subTotalM" name="subTotalM" class="form-control input-sm" value="0" />
                                </div>
                            </td>
                        </tr>
                        <tr >
                            <td align="right" style="font-family: Arial; font-size: 12px; font-weight: bold;">I.V.A 16%</td>
                            <td align="right">
                                <div class="input-group">
                                    <span class="input-group-addon">$</span>
                                    <input style="width: 120px" type="text" id="ivaM" name="ivaM" class="form-control input-sm" value="0" />
                                </div>
                            </td>
                        </tr>
                        <tr  id="rentencionIVA" style="display: none;">
                            <td align="right" style="font-family: Arial; font-size: 12px; font-weight: bold;">RET I.V.A</td>
                            <td align="left">
                                        <input style="width: 120px" type="text" id="ivaRetM" class="form-control input-sm" name="ivaRetM" value="0" /></td>
                        </tr>
                        <tr  style="display: none;">
                            <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">RET I.S.R</td>
                            <td>
                                        <input style="width: 120px" type="text" id="isrRetM" class="form-control input-sm" name="isrRetM" value="0" /></td>
                        </tr>
                        <tr style="display: none;">
                            <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">RET 5%</td>
                            <td>
                                <input type="text" style="width: 120px" id="ret5M" class="form-control input-sm" name="ret5M" value="0" />

                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="font-family: Arial; font-size: 12px; font-weight: bold;">TOTAL</td>
                            <td align="right">
                                <div class="input-group">
                                    <span class="input-group-addon">$</span>
                                    <input style="width: 120px" type="text" id="totalFacM" class="form-control input-sm" name="totalFacM" value="0" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>

                <td align="left" colspan="6" style="display: none">
                    <table width="100%">
                        <tr style="display: none;">
                            <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Retención Iva:</td>
                            <td>
                                <input type="checkbox" id="retencionIva" onclick="javascript: fnRetieneIsr();" name="retencionIva" /></td>
                        </tr>
                        <tr style="display: none;">
                            <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Retención ISR: </td>
                            <td>
                                <input type="checkbox" id="retencionIsr" name="retencionIsr" /></td>
                        </tr>
                        <tr style="display: none;">
                            <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Retención Iva 4%: </td>
                            <td>
                                <input type="checkbox" id="retencionIva4" onclick="javascript: fnChecaIva4();" name="retencionIva4" /></td>
                        </tr>
                        <tr style="display: none;">
                            <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Retención 5 Al Millar: </td>
                            <td>
                                <input type="checkbox" onclick="fnRet5();" id="retencion5" name="retencion5" /></td>
                        </tr>
                        <tr>
                            <td align="left" colspan="2">
                                <input type="button" id="enviar" name="enviar" value="Procesar" onclick="javascript: fnEnviar();" class="boton_azul2" style="height: 25px; width: 110px;" /></td>

                        </tr>

                    </table>
                </td>

            </tr>
        </table>
        <input type="hidden" id="formaPagoM"  name="formaPagoM" value="" /> 
        <input type="hidden" id="metodoPagoM" name="metodoPagoM" value="" />
        <input type="hidden" id="numeroCtaM" name="numeroCtaM" value="" />
        <input type="hidden" id="condicionPagoM" name="condicionPagoM" value="" />
        
        
 </form>
    <iframe id="fnProcesos" name="fnProcesos" style="position:absolute; top:80%; display:none; width:100px; height:100px;"></iframe>
<iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border:0 ridge;visibility:hidden; position:absolute; z-index:65535;"></iframe>
       
        </body>
</html>