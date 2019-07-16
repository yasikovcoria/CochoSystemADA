<%@ Page Language="vb" AspCompat="true" EnableViewStateMac="false" AutoEventWireup="false" CodeBehind="factura.aspx.vb" Inherits="CochoSystem.factura" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1">
    <script src="../js/JQuery.js" type="text/javascript"></script>
    <script src="../js/fnFunciones.js" type="text/javascript"></script>
    <link rel="Stylesheet" type="text/css" href="../css/formularios.css" />
    <link rel="stylesheet" type="text/css" href="../css/estiloAutoComplete.css" />
    <% Response.WriteFile("../js/fnGeneral.asp")%>
    <script type="text/javascript" src="../framework/lib/alertify.js"></script>
    <link rel="stylesheet" href="../framework/themes/alertify.core.css" />
    <link rel="stylesheet" href="../framework/themes/alertify.default.css" />

    <script type="text/javascript">

        $(document).ready(function () {
            parent.document.getElementById('idFormulario').innerHTML = '';
        });

        var esconderFrame = 0;
        document.onclick = function () { esconderX(); }

        function esconderX() {

            if (esconderFrame == 1) {

                document.getElementById("catalogo").style.visibility = "hidden";
                //$("#catalogo").slideUp("slow");
            }
            esconderFrame = 1;
        }

        function fnImprimeRecibo(idEmpresa, numeroFactura, tipoFolio) {

            var form1 = document.getElementById('form1');

            document.getElementById('idFactura').value = numeroFactura;
            document.getElementById('idEmpresa').value = idEmpresa;
            document.getElementById('FolioElectronico').value = tipoFolio;
            document.getElementById('accion').value = 'factura';
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
                element = document.getElementById(element);

            if (!element) return { top: 0, left: 0 };

            var y = 0;
            var x = 0;
            while (element.offsetParent) {

                x += element.offsetLeft;
                y += element.offsetTop;
                element = element.offsetParent;
            }
            $(iframe).offset.left = x;
            $(iframe).offset.top = y + 18;
            //iframe.style.posLeft = x;
            //iframe.style.posTop = y + 22;
            //$(iframe).show();

        }

        function fnMuestraOpcionSAT() {
            document.getElementById('botonOpcionSATM').click();
        }


        function fnEnviar() {

            var formaPago = document.getElementById('formaPagoM').value;
            var metodoPago = document.getElementById('metodoPagoM').value;
            var cuentaPago = document.getElementById('numeroCtaM').value;
            var condicionPago = document.getElementById('condicionPagoM').value;


            if (formaPago == '') {
                alerta('Debe seleccionar la Forma de Pago');
                return false;
            }
            
            document.getElementById('cierraOpcionSATM').click();
            document.getElementById('opcionesSAT').innerText = 'Opciones SAT Aplicadas';

            if (document.getElementById('tipoFolioM').value == '') {
                alerta('No ha seleccionado el tipo de factura a generar');
                return false;
            }
            if (document.getElementById('IdclienteM').value == '') {
                alerta('No ha seleccionado ningun cliente');
                return false;
            }

            if (confirm('Estas seguro que la informacion a facturar es correcta??')) {
                document.getElementById('accion').value = 'generaFactura';
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


            precioVenta = document.getElementById('precioFactura' + idElementoCalculo).value;
            cantidadVenta = document.getElementById('cantidadFactura' + idElementoCalculo).value;

            importeVenta = (precioVenta * cantidadVenta).toFixed(2);
            if (precioVenta == '0') {
                document.getElementById('importeFactura' + idElementoCalculo).value = '0';

            } else {
                document.getElementById('importeFactura' + idElementoCalculo).value = parseFloat(importeVenta).toFixed(2);
            }

        }


        function fnAgragaCarrito() {
            var valorCantidad = document.getElementById('cantidadFacturaM').value;
            var claveSAT = document.getElementById('claveSATFacturaM').value;
            var valorUnidad = document.getElementById('idUnidadFacturaM').value;
            var valorNombreUnidad = document.getElementById('nombreUnidadFacturaM').value;
            var valorDescripcion = document.getElementById('descripcionFacturaM').value;
            var valorPrecio = document.getElementById('precioFacturaM').value;
            var valorImporte = document.getElementById('importeFacturaM').value;
            var idDescripcion = document.getElementById('idDescripcionFacturaM').value;
            var nombreDescripcion = document.getElementById('nombredescripcionFacturaM').value;
            var claveImpuestoSAT = document.getElementById('claveImpuestoFacturaM').value;
            var montoImpuestoConcepto = document.getElementById('importeImpuestoFacturaM').value;

            if (valorCantidad == '') {
                parent.alerta('No ha indicado la cantidad.');
                document.getElementById('cantidadFacturaM').focus();
                return false;
            }
            if (valorUnidad == '') {
                parent.alerta('No ha seleccionado el tipo de unidad.');
                document.getElementById('nombreUnidadFacturaM').focus();
                return false;
            }
            if (valorDescripcion == '') {
                parent.alerta('Debe indicar la descripcion de su producto / Servicio.');
                document.getElementById('descripcionFacturaM').focus();
                return false;
            }


            document.getElementById('cantidadFacturaM').setAttribute('value', valorCantidad);
            document.getElementById('claveSATFacturaM').setAttribute('value', claveSAT);
            document.getElementById('descripcionFacturaM').setAttribute('value', valorDescripcion);
            document.getElementById('idUnidadFacturaM').setAttribute('value', valorUnidad);
            document.getElementById('nombreUnidadFacturaM').setAttribute('value', valorNombreUnidad);
            document.getElementById('precioFacturaM').setAttribute('value', valorPrecio);
            document.getElementById('importeFacturaM').setAttribute('value', valorImporte);
            document.getElementById('idDescripcionFacturaM').setAttribute('value', idDescripcion);
            document.getElementById('nombredescripcionFacturaM').setAttribute('value', nombreDescripcion);
            document.getElementById('claveImpuestoFacturaM').setAttribute('value', claveImpuestoSAT);
            document.getElementById('importeImpuestoFacturaM').setAttribute('value', montoImpuestoConcepto);

            fnAgregaTRDIM('0', 'Factura', 7, false, 'M', '', false, false, false, '');
            fnSumaTotalFactura('Factura', 'M');


            document.getElementById('cantidadFacturaM').value = '0';
            document.getElementById('claveSATFacturaM').value = '';
            document.getElementById('descripcionFacturaM').value = ' ';
            document.getElementById('idUnidadFacturaM').value = ' ';
            document.getElementById('nombreUnidadFacturaM').value = ' ';
            document.getElementById('precioFacturaM').value = '0.00';
            document.getElementById('importeFacturaM').value = '0.00';
            document.getElementById('nombredescripcionFacturaM').value = ' ';
            document.getElementById('idDescripcionFacturaM').value = ' ';
            document.getElementById('claveImpuestoFacturaM').value = ' ';
            document.getElementById('importeImpuestoFacturaM').value = '0';

        }

        function fnChecaIva4() {
            var banderaChek;
            var bandera5Millar;
            bandera5Millar = document.getElementById('retencion5').checked;
            banderaChek = document.getElementById('retencionIsr').checked;
            if (banderaChek == true || bandera5Millar) {
                alerta('Esta Opcion no aplica');
                document.getElementById('retencionIva4').checked = false;
            }
        }

        function fnRet5() {
            var baderaRet5 = document.getElementById('retencion5').checked;
            if (baderaRet5 == true) {
                fnSumaTotalFactura('Factura', 'RET5');
            } else {

                fnSumaTotalFactura('Factura', 'LIMPIA5');
            }
        }

        function fnRetieneIsr() {
            var banderaCheked;
            banderaCheked = document.getElementById('retencionIva').checked;
            if (banderaCheked == true) {
                document.getElementById('retencionIsr').checked = true;
                fnSumaTotalFactura('Factura', 'ISR');


            } else {
                document.getElementById('retencionIsr').checked = false;
                fnSumaTotalFactura('Factura', 'LIMPIAISR');
            }

        }

        function fnSumaTotalFactura(idEnviado, opcion) {

            var totalFactura = 0;
            var forma = document.getElementById('form1');
            for (i = 0; i < forma.length; i++) {
                var tempobj = forma.elements[i];
                if (tempobj.id.substring(0, 14) == 'importe' + idEnviado + '' && tempobj.id != 'importe' + idEnviado + 'M') {
                    totalFactura += parseFloat(tempobj.value.toString().replace(/\$|\,|\%/g, ''));

                }
            }

            var importeConceptoFactura = parseFloat(document.getElementById('importeFactura' + opcion).value);
            var ivaConcepto = (importeConceptoFactura * (16 / 100));
            document.getElementById('importeImpuestoFactura' + opcion).value = ivaConcepto.toFixed(2);

            var ivaFactura = (totalFactura * (16 / 100));
            var totalFacturaM = ivaFactura + totalFactura;
            document.getElementById('subTotalM').value = totalFactura.toFixed(2);
            document.getElementById('ivaM').value = ivaFactura.toFixed(2);
            document.getElementById('totalFacM').value = totalFacturaM.toFixed(2);

            if (opcion == 'ISR') {
                var RetencionISR = (totalFactura * (10 / 100));
                var RetencionIVA = (totalFactura * (10.67 / 100));
                document.getElementById('ivaRetM').value = RetencionIVA.toFixed(2);
                document.getElementById('isrRetM').value = RetencionISR.toFixed(2);
                document.getElementById('totalFacM').value = (totalFacturaM - RetencionISR - RetencionIVA).toFixed(2);
            }
            if (opcion == 'LIMPIAISR') {
                document.getElementById('ivaRetM').value = '0.00';
                document.getElementById('isrRetM').value = '0.00';
            }
            if (opcion == 'RET5') {
                var valorRetencionIVA = parseFloat(document.getElementById('ivaRetM').value);
                var valorRetencionISR = parseFloat(document.getElementById('isrRetM').value);
                var valorRET5 = (totalFacturaM * (5 / 100));
                document.getElementById('ret5M').value = valorRET5.toFixed(2);
                document.getElementById('totalFacM').value = (totalFacturaM - valorRetencionIVA - valorRetencionISR - valorRET5).toFixed(2);
            }

            if (opcion == 'LIMPIA5') {
                var valorRetencionIVA = parseFloat(document.getElementById('ivaRetM').value);
                var valorRetencionISR = parseFloat(document.getElementById('isrRetM').value);
                document.getElementById('ivaRetM').value = valorRetencionIVA.toFixed(2);
                document.getElementById('isrRetM').value = valorRetencionISR.toFixed(2);
                document.getElementById('ret5M').value = '0.00';
                document.getElementById('totalFacM').value = (totalFacturaM - valorRetencionIVA - valorRetencionISR).toFixed(2);

            }


        }
        function fnCFDIRelacion() {
            var trCfdi = document.getElementById('trCfdiRelacion');
            var botonCFDIRelacion = document.getElementById('botonRelacionCFDIM');
            botonCFDIRelacion.click();
            trCfdi.style.display = 'Block';
        }

        function fnOpcionSAT() {
            var nueva_ventana = window.open('opcionSat.aspx', 'Opciones SAT', 'width=400px,height=300px,top=200px,left=400px,menubar=yes,resizable=no,location=no,scrollbars=no,status=no,toolbar=no');
        }
        function fnLimpiaFactura() {
            var form1 = document.getElementById('form1');
            document.getElementById('cantidadFacturaM').value = '';
            document.getElementById('nombreUnidadFacturaM').value = '';
            document.getElementById('precioFacturaM').value = '';
            document.getElementById('importeFacturaM').value = '';

            form1.reset();
        }
        function fnRetornaTimbre(idSeparar) {
            var objetoTimbre = document.getElementById('timbreFiscalCFDI' + idSeparar).value;
            var valorTimbre = objetoTimbre.split("|");
            document.getElementById('tdCFDI2').innerText = valorTimbre[0];
            //document.getElementById('timbreCFDIM').setAttribute('value', valorTimbre[0]);
            document.getElementById('tdCFDI3').innerText = '' + valorTimbre[1] + '';
            document.getElementById('tdCFDI4').innerText = '$ ' + valorTimbre[2] + '';


        }
        function fnAgragaTimbre() {
            var objetoTimbre = document.getElementById('timbreFiscalCFDIM').value;
            var valorTimbre = objetoTimbre.split("|");

            var valorCantidad = document.getElementById('tdCFDI2').innerText;
            alert(valorTimbre[3]);
            document.getElementById('numeroCFDIM').setAttribute('value', valorTimbre[3]);
            //document.getElementById('timbreCFDIM').setAttribute('value', valorCantidad);

            fnAgregaTRDIM('0', 'CFDI', 4, false, 'M', '', false, false, false, '');
            document.getElementById('tdCFDI2').innerText = '';
            document.getElementById('tdCFDI3').innerText = '';
            document.getElementById('tdCFDI4').innerText = '';
            document.getElementById('numeroCFDIM').value = '';
            var totalTimbre = parseInt(document.getElementById('totalCFDIM').value);
            var indiceTimbre = totalTimbre - 1;
            document.getElementById('numeroCFDI' + indiceTimbre).setAttribute('disabled', 'yes');

        }


        function fnRetornaPrecio(idSeparar) {
            var objetoProducto = document.getElementById('idDescripcionFactura' + idSeparar).value;
            var precioProducto = objetoProducto.split("|");
            document.getElementById('precioFactura' + idSeparar).value = precioProducto[0];
            document.getElementById('descripcionFactura' + idSeparar).value = precioProducto[1];
            document.getElementById('claveSATFactura' + idSeparar).value = precioProducto[3];
            document.getElementById('claveImpuestoFactura' + idSeparar).value = precioProducto[4];

        }

        $(document).ready(function () {



            //var porcentajeTop = parent.document.getElementById('menuPrincipal').style.top;


            var objetoDiv = parent.document.getElementById('idFormulario');
            var botonProcesar = document.createElement('button');
            botonProcesar.className = 'btn btn-default btn-sm';
            botonProcesar.style.width = '260px';
            botonProcesar.innerHTML = 'Generar Factura';
            botonProcesar.onclick = function () { window.fnMuestraOpcionSAT() };



            var espacio = document.createElement('br');
            var espacio2 = document.createElement('br');
            var espacio3 = document.createElement('br');
            var espacio4 = document.createElement('br');
            var espacio5 = document.createElement('br');

            objetoDiv.innerHTML = '';

            objetoDiv.appendChild(botonProcesar);
            objetoDiv.appendChild(espacio);


        });


        function fnRevisaCheck(elemento) {
            if (document.getElementById(elemento).checked == true) {
                document.getElementById(elemento).value = '1';
            } else {
                document.getElementById(elemento).value = '0';
            }
        }

    </script>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <link rel="Stylesheet" href="../css/bootstrap.min.css" />
    <script type="text/javascript" src="../js/bootstrap.min.js"></script>
</head>
<body style="padding: 5px; background-color: transparent;">
    <form id="form1">
        <input type="hidden" id="accion" name="accion" value="" />
        <input type="hidden" id="IdclienteM" name="IdclienteM" value="" />
        <input type="hidden" name="idFactura" id="idFactura" value="" />
        <input type="hidden" name="idEmpresa" id="idEmpresa" value="" />
        <input type="hidden" name="FolioElectronico" id="FolioElectronico" value="" />
        <input type="hidden" name="pagina" id="pagina" value="" />
        <table class="table">

            <tr>
                <td>
                    <table>
                        <tr>
                            <td>
                                <label class="control-label">Tipo de Recibo: </label>
                            </td>
                            <td>
                                <input name="nombreTipoReciboM" id="nombreTipoReciboM" type="text" class="form-control input-sm" maxlength="100"
                                    onkeydown="javascript:fnObtenPosicionInput('nombreTipoReciboM');catalogo.verificaCatalogo('TipoFolio','nombreTipoReciboM','tipoFolioM','catalogo',50,300,100,'AND?TIFIdTipoFolio&IN(100,101)','parent.fnConsecutivoRecibo(campoIdCombo);',event,10,false,false,false,'');"
                                    onblur="javascript:if(this.value=='') {document.getElementById('nombreTipoReciboM').value='';}" onchange="if(this.value=='') {document.getElementById('tipoFolioM').value='';}" />
                                <input type="hidden" id="tipoFolioM" name="tipoFolioM" value="" /></td>
                        </tr>
                    </table>
                </td>
                <td>
                    <table>
                        <tr>
                            <td><label class="control-label">Por Cobrar </label></td>
                            <td> &nbsp;&nbsp; <input type="checkbox" class="form-check-input" value="0" name="porCobrarM" id="porCobrarM" onclick="javascript: fnRevisaCheck('porCobrarM');" /></td>
                        </tr>
                    </table>
                </td>
                <td align="center">
                    <table>
                        <tr>
                            <td>
                                <label class="control-label" align="left">Folio: </label>
                            </td>
                            <td>
                                <input type="text" class="form-control input-sm" id="numeroReciboM" name="numeroReciboM" /></td>
                        </tr>
                    </table>
                </td>
                <td align="left">
                    <table width="100%">
                        <tr>
                            <td>
                                <label class="control-label" style="text-align: left;">Cliente: </label>
                            </td>
                            <td>
                                <input name="nombreCuentaP" id="nombreCuentaP" type="text" class="form-control input-sm" maxlength="100"
                                    onkeydown="javascript:fnObtenPosicionInput('nombreCuentaP');catalogo.verificaCatalogo('Cliente','nombreCuentaP','IdclienteM','catalogo',50,300,100,'','parent.fnCFDIRelacion();',event,10,false,false,false,'');"
                                    onblur="javascript:if(this.value=='') {document.getElementById('idCuentaPadre').value='';}" onchange="if(this.value=='') {document.getElementById('IdclienteM').value='';}" /></td>
                        </tr>
                    </table>
                </td>

            </tr>
            <tr style="display: block;" id="trCfdiRelacion">
                <td>
                    <button type="button" id="botonRelacionCFDIM" style="display: block;" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#miModal">
                        Abre Relacion
                    </button>
                </td>
                <td align="right">
                    <table width="100%">
                        <tr>
                            <td>
                                <button type="button" id="botonOpcionSATM" style="display: block;" class="btn btn-primary btn-sm" data-toggle="modal" data-target="#miModal2">
                        Opciones SAT
                    </button>
                            </td>
                        </tr>
                    </table>
                    
                </td>
            </tr>
        </table>
        <table class="table">
            <thead class="table table-bordered" align="center">
                <tr style="background-color:rgba(135, 226, 104, 0.70);">
                    <td>Cantidad</td>
                    <td>CaveSAT 3.3</td>
                    <td>Unidad 3.3</td>
                    <td>Descripcion 3.3</td>
                    <td>Precio</td>
                    <td>Importe</td>
                    <td>Impuesto</td>
                    <td>Opcion</td>
                </tr>
            </thead>

            <tr>
                <td id="tdFactura1">
                    <input type="text" class="form-control input-sm" id="cantidadFacturaM" name="cantidadFacturaM" value="" />
                </td>
                <td id="tdFactura2">
                    <input type="text" class="form-control input-sm" id="claveSATFacturaM" style="text-align: center;" name="claveSATFacturaM" value="" readonly="true" />
                </td>
                <td id="tdFactura3">
                    <input name="nombreUnidadFacturaM" id="nombreUnidadFacturaM" value="" type="text" class="form-control input-sm" maxlength="100"
                        onkeydown="javascript:fnObtenPosicionInput('nombreUnidadCotizacionM');catalogo.verificaCatalogo('UnidadSATCfdi','nombreUnidadFacturaM','idUnidadFacturaM','catalogo',50,300,100,'','',event,10,false,false,false,'parent');"
                        onkeypress="javascript:fnObtenPosicionInput('nombreUnidadCotizacionM');catalogo.verificaCatalogo('UnidadSATCfdi','nombreUnidadFacturaM','idUnidadFacturaM','catalogo',50,300,100,'','',event,10,false,false,false,'parent');"
                        onblur="javascript:if(this.value=='') {document.getElementById('idUnidadFacturaM').value='';}" onchange="if(this.value=='') {document.getElementById('idUnidadFacturaM').value='';}" />
                    <input type="hidden" id="idUnidadFacturaM" name="idUnidadFacturaM" value="" />
                </td>

                <td id="tdFactura4">
                    <input name="nombredescripcionFacturaM" id="nombredescripcionFacturaM" class="form-control input-sm" value="" type="text" maxlength="1000"
                        onkeydown="javascript:fnObtenPosicionInput('nombredescripcionFacturaM');catalogo.verificaCatalogo('ProductoSAT','nombredescripcionFacturaM','idDescripcionFacturaM','catalogo',50,300,100,'','parent.fnRetornaPrecio(\'M\');parent.fnTotalImporte(\'M\');parent.fnSumaTotalFactura(\'Factura\',\'\');',event,10,false,false,false,'parent');"
                        onkeypress="javascript:fnObtenPosicionInput('nombredescripcionFacturaM');catalogo.verificaCatalogo('ProductoSAT','nombredescripcionFacturaM','idDescripcionFacturaM','catalogo',50,300,100,'','parent.fnRetornaPrecio(\'M\');parent.fnTotalImporte(\'M\');parent.fnSumaTotalFactura(\'Factura\',\'\');',event,10,false,false,false,'parent');"
                        onblur="javascript:if(this.value=='') {document.getElementById('idDescripcionFacturaM').value='';}" onchange="if(this.value=='') {document.getElementById('idDescripcionFacturaM').value='';}" />

                    <input type="hidden" id="idDescripcionFacturaM" name="idDescripcionFacturaM" value="" />
                    <input type="hidden" id="descripcionFacturaM" name="descripcionFacturaM" value="" />
                </td>
                <td align="center" id="tdFactura5">

                    <input type="text" class="form-control input-sm" style="width: 80%; text-align: right;" onblur="fnTotalImporte('M');fnSumaTotalFactura('Factura','M');" id="precioFacturaM" name="precioFacturaM" value="0" />

                </td>
                <td align="center" id="tdFactura6">
                    <input type="text" class="form-control input-sm" style="width: 80%; text-align: right;" onblur="fnSumaTotalFactura('Factura','M');" id="importeFacturaM" name="importeFacturaM" value="0" /></td>
                <td align="center" id="tdFactura7">
                    <input type="text" style="text-align: center;" id="claveImpuestoFacturaM" name="claveImpuestoFacturaM" class="form-control input-sm" readonly="true" />
                    <input type="hidden" id="importeImpuestoFacturaM" name="importeImpuestoFacturaM" value="0" />
                </td>
                <td>
                    <img src="../img/agregar.png" alt="Agregar el Registro" onclick="javascript:fnAgragaCarrito('');" style="height: 25px; width: 25px; cursor: pointer" />
                </td>
            </tr>
            <tbody id="bodyFacturaM"></tbody>
            <tfoot>
                <tr style="display: none">
                    <td>&nbsp;<input type="hidden" name="totalFacturaM" id="totalFacturaM" value="0" /></td>
                </tr>
            </tfoot>
            <tr>
                <td colspan="5"></td>
                <td colspan="4">
                    <fieldset style="border: solid 2px rgba(185,186,187,0.25);"><legend id="opcionesSAT" align="center" style="color: darkred; font-family: Arial; font-size: 13px; font-weight: bold;"></legend></fieldset>
                    <table class="table table-bordered">
                        <tr>
                            <td align="right" style="font-family: Arial; font-size: 12px; font-weight: bold;">SUBTOTAL</td>
                            <td align="right">
                                <div class="input-group">
                                    <span class="input-group-addon">$</span>
                                    <input style="width: 120px; text-align: right;" type="text" id="subTotalM" name="subTotalM" class="form-control input-sm" value="0" />
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="font-family: Arial; font-size: 12px; font-weight: bold;">I.V.A 16%</td>
                            <td align="right">
                                <div class="input-group">
                                    <span class="input-group-addon">$</span>
                                    <input style="width: 120px; text-align: right;" type="text" id="ivaM" name="ivaM" class="form-control input-sm" value="0" />
                                </div>
                            </td>
                        </tr>
                        <tr id="rentencionIVA" style="display: none;">
                            <td align="right" style="font-family: Arial; font-size: 12px; font-weight: bold;">RET I.V.A</td>
                            <td align="left">
                                <input style="width: 120px" type="text" id="ivaRetM" class="form-control input-sm" name="ivaRetM" value="0" /></td>
                        </tr>
                        <tr style="display: none;">
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
                                    <input style="width: 120px; text-align: right;" type="text" id="totalFacM" class="form-control input-sm" name="totalFacM" value="0" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="padding-top: 15px; display: none">
                    <table style="padding-right: 25px;" width="100%">
                        <tr>
                            <td style="display: none">

                                <table>
                                    <tr>
                                        <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Retención Iva:</td>
                                        <td>
                                            <input type="checkbox" id="retencionIva" onclick="javascript: fnRetieneIsr();" name="retencionIva" /></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Retención ISR: </td>
                                        <td>
                                            <input type="checkbox" id="retencionIsr" name="retencionIsr" /></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Retención Iva 4%: </td>
                                        <td>
                                            <input type="checkbox" id="retencionIva4" onclick="javascript: fnChecaIva4();" name="retencionIva4" /></td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Retención 5 Al Millar: </td>
                                        <td>
                                            <input type="checkbox" onclick="fnRet5();" id="retencion5" name="retencion5" /></td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                <input type="button" id="enviar" name="enviar" value="Genera Factura" onclick="javascript: fnOpcionSAT();" class="boton_azul2" style="height: 25px; width: 110px;" />
                            </td>

                        </tr>
                    </table>

                </td>
            </tr>
        </table>
       

        <div class="modal fade" id="miModal2" tabindex="-1" role="dialog" aria-labelledby="myModalLabel2" aria-hidden="true">
            <div class="modal-dialog" role="document" style="width: 80%;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" id="cierraOpcionSATM" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title" id="myModalLabel2" style="text-align: center;">Opciones SAT</h4>
                    </div>
                    <div class="modal-body">
                        
                        <table class="table-hover" align="center">
                            <thead>
                                
                                <tr>
                                    <td colspan="4" align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Forma Pago SAT</td>
                                    <td>
                                        <select id="formaPagoM" name="formaPagoM" runat="server" style="font-family: Arial; width:200px; font-size: 12px; font-weight: bold;">
                                            <option value="">Seleccione una opcion</option>
                                            <option value="01">Efectivo</option>
                                            <option value="02">Cheque nominativo</option>
                                            <option value="03">Transferencia electrónica de fondos</option>
                                            <option value="04">Tarjeta de crédito</option>
                                            <option value="05">Monedero electrónico</option>
                                            <option value="06">Dinero electrónico</option>
                                            <option value="08">Vales de despensa</option>
                                            <option value="12">Dación en pago</option>
                                            <option value="13">Pago por subrogación</option>
                                            <option value="14">Pago por consignación</option>
                                            <option value="15">Condonación</option>
                                            <option value="17">Compensación</option>
                                            <option value="23">Novación</option>
                                            <option value="24">Confusión</option>
                                            <option value="25">Remisión de deuda</option>
                                            <option value="26">Prescripción o caducidad</option>
                                            <option value="27">A satisfacción del acreedor</option>
                                            <option value="28">Tarjeta de débito</option>
                                            <option value="29">Tarjeta de servicios</option>
                                            <option value="30">Aplicación de anticipos</option>
                                            <option value="99">Por definir</option>
                                        </select>

                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4" align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;">Metodo de Pago SAT:</td>
                                    <td>
                                        <select id="metodoPagoM" name="metodoPagoM" runat="server" style="width:200px; font-family: Arial; font-size: 12px; font-weight: bold;">
                                            <option value="">Seleccione una opcion</option>
                                            <option value="PUE">Pago en una sola exhibición</option>
                                            <option value="PPD">Pago en parcialidades o diferido</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr style="font-family: Arial">
                                    <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;" colspan="4">Cta: </td>
                                    <td>
                                        <input style="width:200px; font-family: Arial; font-size: 12px; font-weight: bold;" type="text" runat="server" id="numeroCtaM" name="numeroCtaM" value="" /></td>

                                </tr>
                                <tr style="font-family: Arial">
                                    <td align="left" style="font-family: Arial; font-size: 12px; font-weight: bold;" colspan="4">Condicion de Pago:</td>
                                    <td>
                                        <select id="condicionPagoM" name="condicionPagoM" runat="server" style="width:200px; font-family: Arial; font-size: 12px; font-weight: bold;">
                                            <option value="">Seleccione una opcion</option>
                                            <option value="Contado">Contado</option>
                                            <option value="Crédito">Crédito</option>

                                        </select>
                                    </td>
                                </tr>
                            </thead>
                            
                        </table>
                        <div align="center" style="padding-top:25px;">
                             <span class="btn btn-default btn-sm" style="width: 20%" onclick="javascript:fnEnviar();">Aceptar</span>
                        </div>
                       
                        
                    </div>
                </div>
            </div>
        </div>


        <div class="modal fade" id="miModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document" style="width: 80%;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h4 class="modal-title" id="myModalLabel" style="text-align: center;">Relacion CFDI.</h4>
                    </div>
                    <div class="modal-body">
                        <table class="table-hover">
                            <thead>
                                <tr>
                                    <td colspan="4" align="center">Tipo Relacion CFDI:</td>
                                    <td>
                                        <input name="nombreTipoRelacionM" id="nombreTipoRelacionM" type="text" class="form-control input-sm" maxlength="100"
                                            onkeydown="javascript:fnObtenPosicionInput('nombreTipoRelacionM');catalogo.verificaCatalogo('TipoUsoCFDI','nombreTipoRelacionM','tipoRelacionM','catalogo',50,300,100,'','',event,10,false,false,false,'');"
                                            onblur="javascript:if(this.value=='') {document.getElementById('tipoRelacionM').value='';}" onchange="if(this.value=='') {document.getElementById('tipoRelacionM').value='';}" />
                                        <input type="hidden" id="tipoRelacionM" name="tipoRelacionM" value="" />
                                    </td>
                                </tr>
                            </thead>
                        </table>
                        <table class="table-hover" width="100%">
                            <thead>
                                <tr style="background-color:rgba(135, 226, 104, 0.70);">
                                    <td># Factura</td>
                                    <td>Timbre Fiscal</td>
                                    <td>Cliente Factura</td>
                                    <td>Monto</td>
                                    <td>Opcion</td>
                                </tr>
                                <tr>
                                    <td id="tdCFDI1">
                                        <input name="numeroCFDIM" id="numeroCFDIM" type="text" class="form-control input-sm" maxlength="100"
                                            onkeydown="javascript:fnObtenPosicionInput('numeroCFDIM');catalogo.verificaCatalogo('TimbreFiscal','numeroCFDIM','timbreFiscalCFDIM','catalogo',50,300,100,'','parent.fnRetornaTimbre(\'M\');',event,10,false,false,false,'');"
                                            onblur="javascript:if(this.value=='') {document.getElementById('timbreFiscalCFDIM').value='';}" onchange="if(this.value=='') {document.getElementById('timbreFiscalCFDIM').value='';}" />
                                        <input type="hidden" id="timbreFiscalCFDIM" name="timbreFiscalCFDIM" value="" />
                                    </td>
                                    <td id="tdCFDI2" style="font-size: 10px;">
                                        <input type="hidden" id="timbreCFDIM" name="timbreCFDIM" value="" />
                                    </td>
                                    <td id="tdCFDI3" style="font-size: 10px;"></td>
                                    <td id="tdCFDI4" style="font-size: 10px;"></td>
                                    <td align="right">
                                        <img src="../img/agregar.png" alt="Agregar el Registro" onclick="javascript:fnAgragaTimbre();" style="height: 18px; width: 18px; cursor: pointer" /></td>
                                </tr>

                            </thead>
                            <tbody id="bodyCFDIM"></tbody>
                            <tfoot>
                                <tr style="display: none">
                                    <td>&nbsp;<input type="hidden" name="totalCFDIM" id="totalCFDIM" value="0"></td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>

    </form>
    <iframe id="fnProcesos" name="fnProcesos" style="position: absolute; top: 80%; display: NONE; width: 100px; height: 100px;"></iframe>

    <iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border: 0 ridge; visibility: hidden; position: absolute; z-index: 65535;"></iframe>
</body>
<script type="text/javascript">
    function alerta(texto) {
        //un alert
        alertify.alert(texto, function () {
        });
    }
</script>
</html>
