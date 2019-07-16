<%@ Page Language="vb" AspCompat="true" EnableViewStateMac="false" AutoEventWireup="false" CodeBehind="factura.aspx.vb" Inherits="Factura.factura" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    
    <link rel="stylesheet" type="text/css" href="../css/estiloCliente.css" />
    <script src="../js/JQuery.js" type="text/javascript"></script>
    <script src="../js/AjaxBuscador.js" type="text/javascript"></script>
    <script src="../js/fnFunciones.js" type="text/javascript"></script>

    
    <script type="text/javascript">
        function fnEnviar() {



            if (document.getElementById('tipoFolioM').value == '') {
                alert('No ha seleccionado el tipo de factura a generar');
                return false;
            }
            if (document.getElementById('IdclienteM').value == '') {
                alert('No ha seleccionado ningun cliente');
                return false;
            }

            if (document.getElementById('formaPagoM').value == '') {
                alert('Es necesario seleccionar la forma de Pago');
                return false;
            }
            if (document.getElementById('metodoPagoM').value == '') {
                alert('Es necesario seleccionar el metodo de Pago');
                return false;
            }

            if (confirm('Estas seguro que la informacion a facturar es correcta??')) {
                document.getElementById('accion').value = 'generaFactura';
                var form1 = document.getElementById('form1');
                form1.method = 'POST';
                form1.submit();
            }

        }

        function fnRetornaValor(idInput) {

            var valor = document.getElementById(idInput).value;
            document.getElementById('clienteM').value = valor;
            document.getElementById('IdclienteM').value = idInput;
            document.getElementById("lista_opciones").innerHTML = "";
        }
        var totalElementos = 1;
        var ultimoSubTotal = 0;


        function fnCargaNumero(TipoFolio) {
            var variableAleatoria = parseInt(Math.random() * 9999999999999);
            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("numeroReciboM").innerText = xmlhttp.responseText;
                }
            }
            xmlhttp.open("GET", "../funciones/fnFunciones.aspx?accion=consecutivo&tipoFolio=" + TipoFolio + "&" + variableAleatoria, true);
            xmlhttp.send();

        }

        function muestraMetodoPago() {

            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("condicionPagoM").innerHTML = xmlhttp.responseText;
                }
            }
            xmlhttp.open("GET", "../funciones/fnFunciones.aspx?accion=buscar", true);
            xmlhttp.send();

        }
        function fnCargaUnidad() {

            if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
                xmlhttp2 = new XMLHttpRequest();
            }
            else {// code for IE6, IE5
                xmlhttp2 = new ActiveXObject("Microsoft.XMLHTTP");
            }
            xmlhttp2.onreadystatechange = function () {
                if (xmlhttp2.readyState == 4 && xmlhttp2.status == 200) {
                    document.getElementById("unidadSATM").innerHTML = xmlhttp2.responseText;
                }
            }
            xmlhttp2.open("GET", "../funciones/fnFunciones.aspx?accion=unidad", true);
            xmlhttp2.send();
        }



        function agregaRenglonInput(divContenedor) {

            var contenedor = divContenedor;
            var cantidadRenglones;
            var combo = '<option value="">Seleccione una opcion</option><option value="1">KILO</option><option value="2">GRAMO</option><option value="3">METRO LINEAL</option><option value="4">METRO CUADRADO</option><option value="5">METRO CUBICO</option><option value="6">PIEZA</option><option value="7">CABEZA</option><option value="8">LITRO</option><option value="9">PAR</option><option value="10">KILOWATT</option><option value="11">MILLAR</option><option value="12">JUEGO</option><option value="13">KILOWATT / HORA</option><option value="14">TONELADA</option><option value="15">BARRIL</option><option value="16">GRAMO NETO</option><option value="17">DECENAS</option><option value="18">CIENTOS</option><option value="19">DOCENAS</option><option value="20">CAJA</option><option value="21">BOTELLA</option><option value="22">HORAS</option><option value="23">FLETE</option>';

            var tdUnidad = '<td><select style="width:200px; border-radius:5px;" id="unidadSATM' + totalElementos + '" name="unidadSATM' + totalElementos + '">' + combo + '</select></td>';
            var tdDescripcion = '<td><input style="width:150px" type="text" name="descripcionM' + totalElementos + '" id="descripcionM' + totalElementos + '" value=""/></td>';
            var tdPrecio = '<td>$ <input onKeyUp="javascrip:fnTotalImporte(' + totalElementos + ');" style="width:40px" type="text" name="precioM' + totalElementos + '" id="precioM' + totalElementos + '" value="0"/></td>';
            var tdImporte = '<td>$ <input style="width:40px" type="text" name="importeM' + totalElementos + '" id="importeM' + totalElementos + '" value="0"/></td>';
            var tdAgregaOk = '<td><img  src="../img/ok.png" style="height: 25px; width: 25px; cursor:pointer;" onclick="javascript:agregaRenglonInput(\'tablaFactura\');" /></td>';
            var tdElimina = '<td><img src="../img/delete.png" onclick="javascript:fnEliminaRenglonInput(' + totalElementos + ');" style="height: 25px; width: 25px; cursor:pointer" /></td>';

            var renglonInput = '<tr id="elemento' + totalElementos + '"><td><input onKeyUp="javascrip:fnTotalImporte(' + totalElementos + ');" style="width:70px" type="text" name="cantidadM' + totalElementos + '" id="cantidadM' + totalElementos + '" value=""/></td>' + tdUnidad + tdDescripcion + tdPrecio + tdImporte + tdElimina + '</tr>';
            $("#" + divContenedor).append(renglonInput);
            document.getElementById('totalElementos').value = totalElementos;
            totalElementos = totalElementos + 1;

        }
        function fnEliminaRenglonInput(indiceContenedor) {
            var elemento = document.getElementById('elemento' + indiceContenedor);
            $("#tablaFactura").find(elemento).remove();
            totalElementos = totalElementos - 1;
            document.getElementById('totalElementos').value = totalElementos - 1;


        }
        function fnTotalImporte(idElementoCalculo) {
            var iContador = 0;
            var elementoPrecioVenta;
            var valorPrecioVenta = 0;
            var cantidadVenta = 0;
            var importeVenta = 0;

            precioVenta = document.getElementById('precioM' + idElementoCalculo).value;


            cantidadVenta = document.getElementById('cantidadM' + idElementoCalculo).value;

            importeVenta = (precioVenta * cantidadVenta).toFixed(2);
            if (precioVenta == '0') {
                document.getElementById('importeM' + idElementoCalculo).value = '0';

            } else {
                document.getElementById('importeM' + idElementoCalculo).value = parseFloat(importeVenta).toFixed(2);


            }

        }




        function fnChecaIva4() {
            var banderaChek;
            var bandera5Millar;
            bandera5Millar = document.getElementById('retencion5').checked;
            banderaChek = document.getElementById('retencionIsr').checked;
            if (banderaChek == true || bandera5Millar) {
                alert('Esta Opcion no aplica');
                document.getElementById('retencionIva4').checked = false;
            }
        }
        function fnRet5() {

            var banderaIsr = document.getElementById('retencionIsr').checked;
            var baderaRet5 = document.getElementById('retencion5').checked;
            var subtotal = parseFloat(document.getElementById('subTotalM').value);
            var Iva16 = parseFloat(document.getElementById('ivaM').value);
            var IvaRetenido = parseFloat(document.getElementById('ivaRetM').value);
            var IsrRetenido = parseFloat(document.getElementById('isrRetM').value);
            var Ret5Millar = parseFloat(subtotal * (5 / 100));

            if (baderaRet5 == true) {
                document.getElementById('totalFacM').value = subtotal + Iva16 - IvaRetenido - IsrRetenido - Ret5Millar;
                document.getElementById('ret5M').value = parseFloat(Ret5Millar);
            } else {
                document.getElementById('totalFacM').value = parseFloat(subtotal + Iva16 - IvaRetenido - IsrRetenido);
                document.getElementById('ret5M').value = '0';
            }
        }

        function fnCalculaTotales() {

            var banderaRetieneIva;
            var banderaRetienISR;
            var banderaRetieneIva4;
            var bandera5Millar;

            banderaRetieneIva = document.getElementById('retencionIva').checked;
            banderaRetienISR = document.getElementById('retencionIsr').checked;
            banderaRetieneIva4 = document.getElementById('retencionIva4').checked;
            bandera5Millar = document.getElementById('retencion5').checked;


            var iContador = 0;
            var Subtotal = 0;
            var iva16 = 0;
            var totalFactura = 0;
            var ivaRetenido = 0;
            var IsrRetenido = 0;
            var retencion5Millar = 0;

            var arregloImporte = new Array();
            while (iContador < totalElementos) {
                arregloImporte[iContador] = document.getElementById('importeM' + iContador).value;
                Subtotal += parseFloat(arregloImporte[iContador]);
                iContador++;
            }
            iva16 = (Subtotal * (16 / 100));


            if (banderaRetieneIva == false && banderaRetienISR == false && banderaRetieneIva4 == false && bandera5Millar == false) {
                totalFactura = parseFloat(Subtotal + iva16);
                document.getElementById('subTotalM').value = Subtotal.toFixed(2);
                document.getElementById('ivaM').value = iva16.toFixed(2);
                document.getElementById('totalFacM').value = totalFactura.toFixed(2);
                document.getElementById('ivaRetM').value = '0';
                document.getElementById('isrRetM').value = '0';
                document.getElementById('ret5M').value = '0';

            }

            if (banderaRetieneIva == true && banderaRetienISR == true) {
                ivaRetenido = (Subtotal * (10.67 / 100));
                IsrRetenido = (Subtotal * (10 / 100));

                totalFactura = parseFloat(Subtotal + iva16 - ivaRetenido - IsrRetenido);

                document.getElementById('subTotalM').value = Subtotal.toFixed(2);
                document.getElementById('ivaM').value = iva16.toFixed(2);
                document.getElementById('ivaRetM').value = ivaRetenido.toFixed(2);
                document.getElementById('isrRetM').value = IsrRetenido.toFixed(2);
                document.getElementById('ret5M').value = '0';
                document.getElementById('totalFacM').value = totalFactura.toFixed(2);
            }

            if (banderaRetieneIva == true && banderaRetienISR == true && bandera5Millar == true) {
                ivaRetenido = (Subtotal * (10.67 / 100));
                IsrRetenido = (Subtotal * (10 / 100));
                retencion5Millar = (Subtotal * (5 / 100));

                totalFactura = parseFloat(Subtotal + iva16 - ivaRetenido - IsrRetenido - retencion5Millar);

                document.getElementById('subTotalM').value = Subtotal.toFixed(2);
                document.getElementById('ivaM').value = iva16.toFixed(2);
                document.getElementById('ivaRetM').value = ivaRetenido.toFixed(2);
                document.getElementById('isrRetM').value = IsrRetenido.toFixed(2);
                document.getElementById('ret5M').value = retencion5Millar.toFixed(2);
                document.getElementById('totalFacM').value = totalFactura.toFixed(2);
            }

            if (banderaRetieneIva == false && banderaRetienISR == false && bandera5Millar == true) {
                ivaRetenido = (Subtotal * (10.67 / 100));
                IsrRetenido = (Subtotal * (10 / 100));
                retencion5Millar = (Subtotal * (5 / 100));

                totalFactura = parseFloat(Subtotal + iva16 - retencion5Millar);

                document.getElementById('subTotalM').value = Subtotal.toFixed(2);
                document.getElementById('ivaM').value = iva16.toFixed(2);
                document.getElementById('ivaRetM').value = '0';
                document.getElementById('isrRetM').value = '0';
                document.getElementById('ret5M').value = retencion5Millar.toFixed(2);
                document.getElementById('totalFacM').value = totalFactura.toFixed(2);
            }




        }

        function fnEdita(idCliente) {

            window.open('../catalogos/cliente.aspx?idCliente=' + idCliente + '&accion=edicionExterna', 'Edicion de Cliente');
        }
        function fnValidaRenglon(idRenglon) {
            if (document.getElementById('cantidadM' + idRenglon).value == '') {
                alert('No ha especificado la cantidad');
                return false;
            }
        }
        function fnRetieneIsr() {
            var banderaCheked;
            banderaCheked = document.getElementById('retencionIva').checked;
            if (banderaCheked == true) {
                document.getElementById('retencionIsr').checked = true;
            } else {
                document.getElementById('retencionIsr').checked = false;
            }

        }
    </script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    
    <style type="text/css">
        .li {
            width:350px;
            background-color:lightblue;
            padding:3px;
            border-bottom: solid 1px;
            text-align:center;
            font-family:Arial;
            font-size:13px;
            border-bottom-color:white;
            border-radius:5px;
        }
        .auto-style3 {
            width: 189px;
            height: 10px;
        }
        .auto-style4 {
            height: 10px;
        }
    </style>
    
</head>
<body onload="javscript:muestraMetodoPago();fnCargaUnidad();">
    <form id="form1" runat="server">
        <input type="hidden" id="accion" name="accion" value="" />
        <input type="hidden" id="IdclienteM" runat="server" name="IdclienteM" value="" />
        

    <div id="contenedor">
        <table>
            <tr>
                <td>Tipo de factura: </td>
                <td>
                    <select id="tipoFolioM" name="tipoFolioM">
                        <option value="">Seleccione una opcion</option>
                    <option value="100" onclick="javascript:fnCargaNumero(this.value);">VICTOR HUGO VEGA HERNADEZ </option>
                    <option value="101" onclick="javascript:fnCargaNumero(this.value);">CARLOS DE LA CRUZ MATEO </option>
                    </select>
                </td>
                <td>Numero Folio</td>
                <td><input type="text" id="numeroReciboM" name="numeroReciboM"  value="" style="width:50px;" /></td>
                <td>Cliente :</td><td><input type="text" id="clienteM" onkeyup="javascript:fnCargaCliente();" name="clienteM" style="width:250px;" value=""/></td>
            </tr>

            <tr><td></td><td></td><td></td><td></td><td></td><td><div id="lista_opciones" class="autorelleno" style="border-style: none; border-color: inherit; border-width: 2px; display:block; top: 51px; left: 565px; height: 12px;"> </div></td></tr>
        </table>
    <table border="0" style="width: 800px" id="tablaFactura">
        <tr><td class="auto-style3">Cantidad</td><td class="auto-style4">Unidad</td><td class="auto-style4">Descripcion</td><td class="auto-style4">Precio</td><td class="auto-style4">Importe</td><td class="auto-style4"> </td><td class="auto-style4"> </td></tr>
        <tr>
            <td><input type="text" style="width:70px;" runat="server"  id="cantidadM0" value="" /></td>
            <td>
                <select id="unidadSATM" name="unidadSATM" style="width:200px; border-radius:5px;">
                        <option value="">Seleccione una opcion</option>

                    </select></td>
            <td><input type="text" id="descripcionM" style="width:150px;" name="descripcionM" value=""/></td>
            <td>$ <input type="text" style="width:40px;" onkeyup="javascript:fnTotalImporte('0');" id="precioM0" name="precioM0" value="0" /></td>
            <td>$ <input type="text" style="width:40px;" id="importeM0" name="importeM0" runat="server" value="0" /></td>
            <td><img src="../img/ok.png" alt="Agregar el Registro" onclick="javascript:fnValidaRenglon('0');agregaRenglonInput('tablaFactura');" style="height: 25px; width: 25px; cursor:pointer" /></td>
            

        </tr>
        
        
        
    </table>
        <table style="position:fixed; left:39%; margin-top:0%;">
            <tr><td>SubTotal </td><td>$ <input style="width:40px;" type="text" id="subTotalM" name="subTotalM" value="0" /></td></tr>
            <tr><td>Iva 16 %</td><td>$ <input style="width:40px"; type="text" id="ivaM" name="ivaM" value="0" /></td></tr>
            <tr><td> Ret Iva (-) </td><td>$ <input style="width:40px"; type="text" id="ivaRetM" name="ivaRetM" value="0" /></td></tr>
             <tr><td> Ret Isr (-) </td><td>$ <input style="width:40px"; type="text" id="isrRetM" name="isrRetM" value="0" /></td></tr> 
            <tr><td>Ret 5%(-)</td><td>$ <input type="text" style="width:40px"; id="ret5M" name="ret5M" value="0" /></td></tr>
            <tr><td>Total Factura </td><td>$ <input style="width:40px"; type="text" id="totalFacM" name="totalFacM" value="0" /></td></tr>
        
        </table>
        
    </div>
        
        <div style="position:relative; top: 116px; left: 6px; width: 440px;">
            <fieldset>
            <table>
                <tr>
                    <td>
                        Retención Iva: <input type="checkbox" id="retencionIva" onclick="javascript: fnRetieneIsr();" name="retencionIva" />
                    </td>
                    <td>
                        Retención ISR: <input type="checkbox" id="retencionIsr" name="retencionIsr"  />
                    </td>
                    <td>
                        Retención Iva 4%: <input type="checkbox" id="retencionIva4" onclick="javascript: fnChecaIva4();" name="retencionIva4" />
                    </td>
                    <td>
                        Retención 5 Al Millar: <input type="checkbox" id="retencion5" name="retencion5"/>
                    </td>
                </tr>
            </table>
                </fieldset>
        </div>
            
        <input type="hidden" id="totalElementos"  name="totalElementos" />
    
        <table style="position:fixed; margin-top: 9%; left: 0px;">
            
            <tr style="position:fixed;margin-top:2%;"><td style="font-size:12px; color:darkblue;">Forma de Pago SAT: </td>
                <td >
                    <select id="formaPagoM" name="formaPagoM" runat="server" style="width:200px; border-radius:5px;">
                        <option value="">Seleccione una opcion</option>
                        <option value="Pago en una sola exhibición" >Pago en una sola exhibición</option>
                        <option value="Pago en parcialidades">Pago en parcialidades</option>
                        <option value="número de parcialidad pagada contra el total de parcialidades">número de parcialidad pagada contra el total de parcialidades</option>
                        <option value="Parcialidad 1 de">Parcialidad 1 de</option>
                    </select>

                </td>
                <td style="font-size:12px; color:darkblue;">Metodo de Pago SAT:</td>
                <td>
                    <select id="metodoPagoM" name="metodoPagoM" runat="server" style="width:200px; border-radius:5px;">
                        <option value="">Seleccione una opcion</option>
                        <option value="Efectivo">Efectivo</option>
                        <option value="No Identificado">No Identificado</option>
                        <option value="Cheque">Cheque</option>
                        <option value="Tarjeta de crédito">Tarjeta de crédito</option>
                        <option value="Tarjeta de debito">Tarjeta de debito</option>
                        <option value="Transferencia6">Transferencia</option>
                        <option value="Deposito">Deposito</option>
                    </select>
                </td>
                <td style="font-size:12px; color:darkblue;">Cta: </td>
                <td><input style="width:70px;" type="text" runat="server" id="numeroCtaM" name="numeroCtaM" value="" /></td></tr>
                
            <tr style="position:fixed;margin-top:6%;">
                <td style="font-size:12px; color:darkblue;">Condicion de Pago:</td>
                <td>
                    <select id="condicionPagoM" name="condicionPagoM" runat="server" style="width:200px; border-radius:5px;">
                        <option value="">Seleccione una opcion</option>

                    </select>
                </td>
            </tr>
        </table>
        </form>
        <table>
            <tr>
                <td><input type="button" id="enviar" name="enviar" value="Genera Factura" onclick="javascript: fnEnviar();" /></td>
                <td></td><td></td><td></td><td></td><td></td><td></td><td></td>
                <td><input type="button" id="calcula" name="calcula" value="Calcula Totales" onclick="javascript: fnCalculaTotales();" /></td>
            </tr>

        </table>
        </body>
</html>
