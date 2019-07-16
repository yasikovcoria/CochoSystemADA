<%@ Page EnableViewStateMac="false" Language="vb" AspCompat="true" AutoEventWireup="false" CodeBehind="cliente.aspx.vb" Inherits="CochoSystem.cliente" %>

<!DOCTYPE html>
<% 
    Dim permisoModificar As String = "", permisoAgregar As String = "", permisoConsultar As String = "", permisoEliminar As String = ""

    Dim queryPermiso As String = "EXEC [dbo].[spRevisaPermiso]'" + IdEmpresa + "', '" + IdUsuarioPermiso + "', '" + cadenaPermiso + "', 0"
    Dim objetoPermiso As System.Data.DataView = Nothing
    objetoPermiso = objetoClases.fnRegresaTabla(queryPermiso, "Permiso")
    If objetoPermiso.Count <> 0 Then
        If objetoPermiso(0)("Modificar").ToString = "0" Then
            permisoModificar = "0"
        End If
        If objetoPermiso(0)("Agregar").ToString = "0" Then
            permisoAgregar = "0"
        End If
    End If

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head >
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <script src="../js/JQuery.js" type="text/javascript"></script>
    <script src="../js/fnFunciones.js" type="text/javascript"></script>

    <link rel="Stylesheet" type="text/css" href="../css/formularios.css" />
    <link rel="stylesheet" type="text/css" href="../css/estiloAutoComplete.css" />
    <% Response.WriteFile("../js/fnGeneral.asp")%>
    <script type="text/javascript" src="../framework/lib/alertify.js"></script>
    <link rel="stylesheet" href="../framework/themes/alertify.core.css" />
    <link rel="stylesheet" href="../framework/themes/alertify.default.css" />
    <!-- Latest compiled and minified CSS -->
    <!-- <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap-theme.min.css" />
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/js/bootstrap.min.js"></script>-->

    <script type="text/javascript">
        function fnLimpiaTabla(idTablaDatos, totalElementos) {

            var tablaDatos = document.getElementById(idTablaDatos);
            try {
                while (tablaDatos.hasChildNodes()) {
                    tablaDatos.removeChild(tablaDatos.firstChild);
                }
                document.getElementById(totalElementos).value = '0';
            } catch (ex) {
                alert(ex.message);
            }
        }

        var esconderFrame = 0;
        document.onclick = function () { esconderX(); }

        function esconderX() {

            if (esconderFrame == 1) {
                document.getElementById("catalogo").style.visibility = "hidden";

            }
            esconderFrame = 1;
        }

        function fnCierraVentana(idVentana) {
            $('#' + idVentana).fadeOut('slow');
        }
        function fnMuestraComplemento(idComplemento) {
            $('#' + idComplemento).slideDown("slow");
        }
        function fnMuestra(opcion) {
            if (opcion == 'muestra') {
                $('#Intereses').fadeIn("slow");
            } else {
                $('#Intereses').fadeOut("slow");
            }
        }

        function fnBuscar() {
            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = 'muestraCliente';
            form1.method = 'POST';
            form1.target = 'fnProcesos';
            form1.submit();
        }
        function resizeIFrame(idFrame) {

            var the_height = document.getElementById(idFrame).contentWindow.document.body.scrollHeight;
            var the_width = document.getElementById(idFrame).contentWindow.document.body.scrollWidth;
            document.getElementById(idFrame).width = the_width;
            document.getElementById(idFrame).height = the_height;
        }

        function fnProcesar(accion) {
            var banderaFisca = document.getElementById('tipoPersonaFisicaM').checked;
            var banderaMoral = document.getElementById('tipoPersonaMoralM').checked;
            if (banderaFisca == false && banderaMoral == false) {
                parent.alerta('Es necesario el tipo de Persona');
                return false;
            }

            var accionRealizar;
            if (accion == 3) {
                accionRealizar = 'modificarCliente';
            } else {
                accionRealizar = 'agregarCliente';
            }

            var total = $('.textObligatorio').length;
            var totalValidados = total;
            for (i = total; i >= 0; i--) {
                if ($('.textObligatorio').eq(i).val() == '') {
                    $('.textObligatorio').eq(i).css({ "border": "solid 1px", "border-color": "red" });
                    $('.textObligatorio').eq(i).focus();
                    totalValidados = totalValidados - 1;
                } else {
                    $('.textObligatorio').eq(i).addClass('textObligatorio');
                }
            }
            if (total == totalValidados) {
            } else {
                parent.alerta('Los campos en rojo son obligatorios');
                return false;
            }
            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = accionRealizar;
            form1.method = 'POST';
            form1.target = 'fnProcesos';
            form1.submit();



        }

        $(document).ready(function () {
            var objetoDiv = parent.document.getElementById('idFormulario');
            objetoDiv.className = 'row col-sm-3 col-md-3';
            var botonProcesar = document.createElement('a');
            botonProcesar.className = 'btn btn-default btn-sm';
            botonProcesar.innerText = 'Agregar';
            botonProcesar.style.width = '265px';
            botonProcesar.style.cursor = 'pointer';
            botonProcesar.onclick = function () { window.fnProcesar(1) };
            
            if('<%= permisoAgregar%>'=='0'){
                botonProcesar.disabled = true
                botonProcesar.style.backgroundColor ='lightgray;';
            }


            var botonModificar = document.createElement('a');
            botonModificar.className = 'btn btn-default btn-sm';
            botonModificar.innerText = 'Modificar';
            botonModificar.style.width = '265px';
            botonModificar.style.cursor = 'pointer';
            botonModificar.onclick = function () { window.fnProcesar(3) };
            if('<%= permisoModificar%>'=='0'){
                botonModificar.style.backgroundColor ='lightgray;';
            botonModificar.disabled=true
            }



            var botonBuscar = document.createElement('a');
            botonBuscar.className = 'btn btn-default btn-sm';
            botonBuscar.innerText = 'Buscar';
            botonBuscar.style.width = '265px';
            botonBuscar.style.cursor = 'pointer';
            botonBuscar.onclick = function () { window.fnBuscar() };


            var espacio = document.createElement('br');
            var espacio2 = document.createElement('br');
            var espacio3 = document.createElement('br');
            var espacio4 = document.createElement('br');
            var espacio5 = document.createElement('br');

            objetoDiv.innerHTML = '';
            objetoDiv.appendChild(espacio3);
            objetoDiv.appendChild(botonProcesar);
            //objetoDiv.appendChild(espacio);
            objetoDiv.appendChild(espacio2);

            objetoDiv.appendChild(botonBuscar);
            //objetoDiv.appendChild(espacio4);
            objetoDiv.appendChild(espacio5);
            objetoDiv.appendChild(botonModificar);

        });

        function fnRevisaPersona(objeto) {
            
            var elementoCatalogo = document.getElementById('usoCfdiSAT');
            var StringCatalogoUso = '';
            var iframeCatalogo = document.getElementById('catalogo');

            if (objeto.value == 0) {
                var StringCatalogoUso = 'javascript:fnObtenPosicionInput(\'usoCfdiSAT\');catalogo.verificaCatalogo(\'UsoSat\',\'usoCfdiSAT\',\'claveSatUsoM\',\'catalogo\',50,300,100,\'AND?CatSatUCFDIMoral&IN(\\\'SI\\\')\',\'\',event,10,false,false,false,\'\');';

            } else {
                var StringCatalogoUso = 'javascript:fnObtenPosicionInput(\'usoCfdiSAT\');catalogo.verificaCatalogo(\'UsoSat\',\'usoCfdiSAT\',\'claveSatUsoM\',\'catalogo\',50,300,100,\'AND?CatSatUCFDIFisica&IN(\\\'SI\\\')\',\'\',event,10,false,false,false,\'\');';

            }

            elementoCatalogo.setAttribute('onkeydown', StringCatalogoUso);
            iframeCatalogo.contentDocument.location = iframeCatalogo.src;
            elementoCatalogo.removeAttribute('disabled');


        }


        function fnCargaCliente(indiceConsulta) {
            var form1 = document.getElementById('form1');
            var idClienteConsulta = document.getElementById('idClienteHidden' + indiceConsulta).value;
            document.getElementById('accion').value = 'consultaCliente';
            document.getElementById('idClienteM').value = idClienteConsulta;
            form1.method = 'POST';
            form1.target = 'fnProcesos';
            form1.submit();
        }

    </script>
    <script src="../js/fnCliente.js" type="text/javascript"></script>
    <link rel="Stylesheet" type="text/css" href="../css/cssCliente.css" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
        <link rel="Stylesheet" href="../css/bootstrap.min.css" />
    <script src="../js/bootstrap.min.js" type="text/javascript"></script>
    <link rel="Stylesheet" href="../css/bootstrap-switch.css" />
</head>
<body style="background-color:transparent;">

    <form id="form1">
        <div id='Intereses' style="display: none">
            <a class='cerrar' href='javascript:void(0);' onclick="fnCierraVentana('Intereses');">x</a>
            <div id='contenedor'>
                <div class="contenido">
                    
                    <table class="table table-hover">
                        <thead>
                        <tr>
                            <td colspan="4" align="right">
                                <table id="idPaginador" style="padding-left: 20%; display: block;">
                                    <tr>
                                        <td id="totalRegistroM" align="center" colspan="3"></td>
                                        <td>
                                            <ul class="pager">
                                                <li class="previous"><a onclick="fnPaginarCliente('-1');" style="cursor: pointer;">Anterior</a></li>
                                            </ul>
                                        </td>
                                        <td>
                                            <input type="text" name="idPaginaM" id="idPaginaM" value="0" class="form-control input-sm text-center" style="width: 50px;" />
                                        </td>
                                        <td>
                                            <ul class="pager">
                                                <li class="next"><a onclick="javascript:fnPaginarCliente('1');" style="cursor: pointer;">Siguiente</a></li>
                                            </ul>
                                        </td>
                                        <td id="totalPaginas" align="right" colspan="3"></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        </thead>
                        <tr style="text-align:center;background-color:rgba(135, 226, 104, 0.70);">
                            <td>Cliente</td>
                            <td>Tipo Persona</td>
                            <td>Mail</td>
                            <td>Opciones</td>
                        </tr>
                        <tbody id="tablaDatosM" class="table table-bordered" style="font-size:12px;"></tbody>
                       
                    </table>
                </div>
            </div>
        </div>
        <input type="hidden" id="totalElementosM" name="totalElementosM" value="0" />
        <input type="hidden" name="accion" id="accion" value="" />
        <input type="hidden" name="idClienteM" id="idClienteM" value="" />
        <div id="contenidoFormulario">
            <table class="table table-hover">
                <thead class="table table-bordered" style="font-size:11px; text-align:center; font-weight:bold;">
                    <tr align="center" style="background-color:rgba(135, 226, 104, 0.70);">
                        <td><span>Clave-Cliente:</span></td>
                        <td><span>Persona Fisica</span></td>
                        <td><span>Persona Moral</span></td>
                        <td><span>Uso CFDI 3.3</span></td>
                    </tr>
                </thead>
                <tr align="center" >
                    <td><input type="text" id="idClaveClienteM" name="idClaveClienteM" class="form-control input-sm" disabled="disabled" value="" /></td>
                    <td><input type="radio" onclick="fnRevisaPersona(this);" value="1" class="bootstrap-switch" name="tipoPersonaM" id="tipoPersonaFisicaM" /></td>
                    <td><input type="radio" onclick="fnRevisaPersona(this);" value="0" class="bootstrap-switch" name="tipoPersonaM" id="tipoPersonaMoralM" /></td>
                    <td><input disabled="disabled" name="usoCfdiSAT" id="usoCfdiSAT" type="text" class="textObligatorio form-control input-sm" maxlength="100" onkeydown="javascript:fnObtenPosicionInput('usoCfdiSAT');catalogo.verificaCatalogo('UsoSat','usoCfdiSAT','claveSatUsoM','catalogo',50,300,100,'','',event,10,false,false,false,'');"
                                                onblur="javascript:if(this.value=='') {document.getElementById('usoCfdiSAT').value='';}" onchange="if(this.value=='') {document.getElementById('claveSatUsoM').value='';}" />
                                             <input type="hidden" id="claveSatUsoM" name="claveSatUsoM" value="" />
                    </td>
                </tr>
            </table>
            <div align="center"><strong style="font-size:18px;">Datos Generales</strong></div>
            <table class="table table-hover">
                <thead class="table table-bordered" style="font-size:11px; text-align:center; font-weight:bold;">
                    <tr style="background-color:rgba(135, 226, 104, 0.70);">
                        <td ><span >Nombre <strong style="color:yellow;">*</strong></span></td>
                        <td ><span>ApellidoP</span></td>
                        <td><span >ApellidoM</span></td>
                        <td><span >R.F.C *</span></td>
                        <td><span >C.U.R.P</span></td>
                        <td><span >Correo Electronico *</span></td>
                        <td><span>Telefono:</span></td>
                    </tr>
                </thead>
                <tr align="center">
                    <td><input type="text" id="nombreClienteM" name="nombreClienteM" class="textObligatorio form-control input-sm" /></td>
                    <td><input type="text" id="apellidoP" name="apellidoP" class="form-control input-sm" /></td>
                    <td><input type="text" id="apellidoM" name="apellidoM" class="form-control input-sm" /></td>
                    <td><input type="text" id="rfcClienteM" name="rfcClienteM" class="textObligatorio form-control input-sm" /></td>
                    <td><input type="text" id="curpClienteM" name="curpClienteM" class="form-control input-sm" /></td>
                    <td><input type="text" id="correoM" name="correoM" class="textObligatorio form-control input-sm" /></td>
                    <td><input type="text" id="telefonoM" name="telefonoM" class="form-control input-sm" /></td>
                </tr>
            </table>
            <div align="center"><strong style="font-size:18px;">Direccion de Facturacion</strong></div>
            <table class="table table-hover">
                <thead class="table table-bordered" style="font-size:11px; text-align:center; font-weight:bold;">
                    <tr style="background-color:rgba(135, 226, 104, 0.70);">
                        <td ><span>Calle</span></td>
                        <td><span>Colonia</span></td>
                        <td> <span>Localidad</span></td>
                        <td> <span>Numero Exterior</span></td>
                        <td><span>Codigo Postal</span></td>
                        <td><span>Numero Interior</span></td>
                        <td><span>Municipio </span></td>
                        <td ><span>Pais *</span></td>
                        <td><span>Estado *</span></td>
                    </tr>
                </thead>
                <tr>
                    <td><input type="text" id="calleClienteM" name="calleClienteM" class=" form-control input-sm"  /></td>
                    <td><input type="text" id="coloniaClienteM" name="coloniaClienteM" class="form-control input-sm"  /></td>
                    <td><input type="text" id="localidadM" name="localidadM" class="form-control input-sm" /></td>
                    <td><input type="text" id="numeroExteriorM" name="numeroExteriorM" class="form-control input-sm"  /></td>
                    <td><input type="text" id="codigoPostalM" name="codigoPostalM" maxlength="5" class=" form-control input-sm" /></td>
                    <td><input type="text" id="numeroInteriorM" name="numeroInteriorM" class="form-control input-sm" /></td>
                    <td><input type="text" id="municipioM" name="municipioM" class=" form-control input-sm"  /></td>
                    <td><input name="nombrePaisM" id="nombrePaisM" type="text" class="textObligatorio form-control input-sm" maxlength="100" onkeydown="javascript:fnObtenPosicionInput('nombrePaisM');catalogo.verificaCatalogo('Pais','nombrePaisM','paisM','catalogo',50,300,100,'','',event,10,false,false,false,'');"
                                                onblur="javascript:if(this.value=='') {document.getElementById('numeroReciboRetM').value='';}" onchange="if(this.value=='') {document.getElementById('paisM').value='';}" />
                                            <input type="hidden" id="paisM" name="paisM" value="" /></td>
                    <td><input name="nombreEstadoM" id="nombreEstadoM" type="text" class="textObligatorio form-control input-sm" maxlength="100" onkeydown="javascript:fnObtenPosicionInput('nombreEstadoM');catalogo.verificaCatalogo('Estado','nombreEstadoM','estadoM','catalogo',50,300,100,'AND?EdoIdPais&IN(1)','',event,10,false,false,false,'');"
                                                onblur="javascript:if(this.value=='') {document.getElementById('nombreEstadoM').value='';}" onchange="if(this.value=='') {document.getElementById('estadoM').value='';}" />
                                             <input type="hidden" id="estadoM" name="estadoM" value="" /></td>
                </tr>
            </table>
            <div align="center"><strong style="font-size:18px;">Complemento INE</strong></div>
            <table class="table table-hover">
                <thead class="table table-bordered" style="font-size:11px; text-align:center; font-weight:bold;">
                    <tr style="background-color:rgba(135, 226, 104, 0.70);">
                        <td ><span>Tipo Proceso</span></td>
                        <td><span>Ambito</span></td>
                        <td> <span>Id Contabilidad</span></td>
                        <td><span>Estado Proceso</span></td>
                        </tr>
                    <tr>
                        <td><select id="tipoProcesoM" name="tipoProcesoM" class="form-control input-sm" >
                            <option value="">Seleccione una opcion</option>
                            <option value="Ordinario">Ordinario</option>
                            <option value="Precampaña">Precampaña</option>
                            <option value="Campaña">Campaña</option>
                            </select>
                        </td>
                        <td><select type="text" id="tipoAmbitoM" name="tipoAmbitoM" class="form-control input-sm" >
                            <option value="">Seleccione una Opcion</option>
                            <option value="Local">Local</option>
                            <option value="Federal">Federal</option>
                            </select>
                            </td>
                        <td><input type="text" id="idContabilidadM" name="idContabilidadM" class="form-control input-sm" maxlength="6" /></td>
                        <td>
                            <input name="nombreEstadoSatM" id="nombreEstadoSatM" type="text" class="form-control input-sm" maxlength="100" onkeydown="javascript:fnObtenPosicionInput('nombreEstadoSatM');catalogo.verificaCatalogo('EstadoSAT','nombreEstadoSatM','claveSatEstadoM','catalogo',50,300,100,'','',event,10,false,false,false,'');"
                                                onblur="javascript:if(this.value=='') {document.getElementById('nombreEstadoSatM').value='';}" onchange="if(this.value=='') {document.getElementById('claveSatEstadoM').value='';}" />
                                             <input type="hidden" id="claveSatEstadoM" name="claveSatEstadoM" value="" />
                        </td>
                    </tr>
                </thead>
            </table>
        </div>
        <iframe id="fnProcesos" name="fnProcesos" style="display: none; width: 100px; height: 100px; position: absolute; top: 70%;"></iframe>
    </form>
    <iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border: 0 ridge; visibility: hidden; position: absolute; z-index: 0;"></iframe>
    <style type="text/css">

        #Intereses {
            width: 90%; /* Ancho de la ventana */
            height: auto; /* Alto de la ventana */
            background: #35434b; /* Color de fondo */
            position: absolute;
            top: 2%;
            left: 20%;
            margin-left: -180px;
            border: 1px solid #adffad; /* Borde de la ventana */
            box-shadow: 0 5px 25px rgba(0,0,0,.8);
            z-index: 999;
            filter: alpha(opacity=100);
            opacity: 3;
            background-color: rgba(104, 144, 226, 0.83);
        }

            #Intereses #contenedor {
                padding: 25px 10px 10px 10px;
            }

            #Intereses .cerrar {
                float: right;
                border-bottom: 1px solid #bbb;
                border-left: 1px solid #bbb;
                color: #999;
                background: white;
                line-height: 17px;
                text-decoration: none;
                padding: 0px 14px;
                font-family: Arial;
                border-radius: 0 0 0 5px;
                box-shadow: -1px 1px white;
                font-size: 18px;
                -webkit-transition: .3s;
                -moz-transition: .3s;
                -o-transition: .3s;
                -ms-transition: .3s;
            }

                #Intereses .cerrar:hover {
                    background: #ff6868;
                    color: white;
                    text-decoration: none;
                    text-shadow: -1px -1px red;
                    border-bottom: 1px solid red;
                    border-left: 1px solid red;
                }

            #Intereses #contenedor .contenido {
                padding: 5px;
                box-shadow: inset 1px 1px white;
                background: #fff; /* Fondo del mensaje */
                border: 1px solid #9eff9e; /* Borde del mensaje */
                font-size: 20px; /* Tamaño del texto del mensaje */
                color: #555; /* Color del texto del mensaje */
                text-shadow: 1px 1px white;
                margin: 0 auto;
                border-radius: 4px;
            }

        .oculto {
            -webkit-transition: 1s;
            -moz-transition: 1s;
            -o-transition: 1s;
            -ms-transition: 1s;
            opacity: 0;
            -ms-opacity: 0;
            -moz-opacity: 0;
            visibility: hidden;
        }
    </style>

</body>
</html>
