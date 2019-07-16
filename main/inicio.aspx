<%@ Page Language="vb" EnableViewStateMac="false" AutoEventWireup="false" CodeBehind="inicio.aspx.vb" EnableSessionState="True" AspCompat="true" Inherits="CochoSystem.inicio" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link rel="stylesheet" href="css/style.css" type="text/css" />
    <link rel="stylesheet" href="css/estiloTelerik.css" type="text/css" />
    <link rel="Stylesheet" href="css/formulariosStyle.css" type="text/css" />
    <link rel="Stylesheet" href="css/formularios.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type="text/javascript" src="framework/lib/alertify.js"></script>
    <link rel="stylesheet" href="framework/themes/alertify.core.css" />
    <link rel="stylesheet" href="framework/themes/alertify.default.css" />
    <script type="text/javascript" src="js/noRegresa.js"></script>
    <link rel="shortcut icon" href="img/usuarioSistema.png" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="Stylesheet" href="css/bootstrap.min.css" />

    <style>
        body {
            position: absolute;
            margin-top: 70px;
            padding-left: -10px;
        }

        .glyphicon {
            margin-right: 15px;
        }

        .panel-body {
            padding: 0px;
        }

            .panel-body table tr td {
                padding-left: 15px;
            }

            .panel-body .table {
                margin-bottom: 0px;
            }
    </style>
    <script type="text/javascript">

        var totalElementos;
        function fnSalir() {
            alerta('Gracias por utilizar CochoSystem.');
            setTimeout(function () {
                document.getElementById('accion').value = 'salir';
                var form = document.getElementById('form1');
                form.action = '../index.aspx';
                form.submit();
            }, 4000);

        }
        function fnReporte() {
            document.getElementById('accionReporte').value = 'GeneraReporte';
            var form1 = document.getElementById('form1');
            //form1.target = '_blank';
            form1.method = 'POST';
            form1.submit();
        }
        function agregaRenglonInput(divContenedor) {
            var renglonInput = '<tr id="elemento' + totalElementos + '"><input type="text name="descripcionM' + totalElementos + '" id="descripcionM' + totalElementos + '" />';
            $("#" + divContenedor).append(renglonInput);
            totalElementos++;
        }
    </script>
    <style>
        .oculto {
            display: none;
        }

        body {
            filter: alpha(opacity=100);
            opacity: 1;
            background-repeat: no-repeat;
            background-position: top;
        }
    </style>
</head>
<body onload="noBack();">
    <div id='ventana-flotante' style="display: none">
        <a class='cerrar' href='javascript:void(0);' onclick='document.getElementById(&apos;ventana-flotante&apos;).className = &apos;oculto&apos;'>x</a>
        <div id='contenedor'>
            <div class='contenido'>
                Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.Aquí va el mensaje.
            </div>

        </div>

    </div>
    <header>
        <div align="center">

            <h4 id="tituloModulo" style="color: white; border: 0px; font-weight: bold; position: absolute; top: 15px; left: 45%;"></h4>
            <!--<div align="left" style="position: absolute; top: 5px;">
                <img src="img/logoUltimo.png" width="220" height="60" />
            </div>-->
            <div align="right" style="position: absolute; top: 5px; right: 10px;">
                <h4 id="nombreUsuario" style="color: white; font-size: 12px; font-style: italic; border: 0px;">USUARIO : <% Response.Write(Session("NombreUsuario"))%></h4>
                <div align="right" style="position: absolute; top: 17px; right: 50%;">
                    <img src="img/usuarioSistema.png" />
                </div>
            </div>
            
        </div>
        <!--<div style="background-color:rgba(135, 226, 104, 0.90); width:100%; height:0%; position:absolute; bottom:0px;"></div>-->
    </header>

    <form name="form1" id="form1">
        <input type="hidden" name="accion" id="accion" value="" />
    </form>
    <div class="container">
        <div class="row">
            <div class="col-sm-3 col-md-3">
                <div class="panel-group" id="accordion">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne"><img src="img/xml.png" class="glyphicon glyphicon-folder-close"></img>Emision de Recibos</a>
                            </h4>
                        </div>
                        <div id="collapseOne" class="panel-collapse collapse in">
                            <div class="panel-body">
                                <table class="table">
                                    <tr id="EmisionFactura">
                                        <td>
                                            <span class="glyphicon glyphicon-pencil text-primary"></span><a href="facturas/factura.aspx" target="iframeMaestra">CFDI 3.3</a>
                                        </td>
                                    </tr>
                                    <tr id="EmisionCotizacion" style="display:none">
                                        <td>
                                            <span class="glyphicon glyphicon-flash text-success"></span><a href="cotizaciones/cotizacion.aspx" target="iframeMaestra">Nota de Venta</a>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo"><span class="glyphicon glyphicon-folder-open"></span>Catalogos</a>
                            </h4>
                        </div>
                        <div id="collapseTwo" class="panel-collapse collapse">
                            <div class="panel-body">
                                <table class="table">
                                    <tr id="CatalogoClientes">
                                        <td>
                                            <a href="catalogos/cliente.aspx" target="iframeMaestra">Clientes</a>
                                        </td>
                                    </tr>
                                    <tr id="CatalogoProvedores" style="display:none">
                                        <td>
                                            <a href="catalogos/provedores.aspx" target="iframeMaestra">Proveedores</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <a href="catalogos/productos.aspx" target="iframeMaestra">Productos SAT</a>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree"><span class="glyphicon glyphicon-user"></span>Consultas</a>
                            </h4>
                        </div>
                        <div id="collapseThree" class="panel-collapse collapse">
                            <div class="panel-body">
                                <table class="table">
                                    <tr id="ConsultaFacturas">
                                        <td>
                                            <a href="facturas/consultaFactura.aspx" target="iframeMaestra">Consulta Facturas</a>
                                        </td>
                                    </tr>
                                    <tr id="ConsultaNotas" style="display:none">
                                        <td>
                                            <a href="facturas/consultaNota.aspx" target="iframeMaestra">Consulta Notas</a> <span class="label label-info">5</span>
                                        </td>
                                    </tr>
                                    <tr id="ConsultaCotizaciones" style="display:none">
                                        <td>
                                            <a href="cotizaciones/consultaCotizacion.aspx" target="iframeMaestra">Consulta Cotizaciones</a>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="display:none">
                                            <span class="glyphicon glyphicon-trash text-danger"></span><a href="http://www.jquery2dotnet.com" class="text-danger">Delete Account</a>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseFour"><span class="glyphicon glyphicon-cog"></span>Sistema</a>
                            </h4>
                        </div>
                        <div id="collapseFour" class="panel-collapse collapse">
                            <div class="panel-body">
                                <table class="table">
                                    
                                    <tr>
                                        <td onclick="javascript:fnSalir();" style="cursor:pointer;">
                                            <span class="glyphicon glyphicon-off"></span><a >Salir</a>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--
        <div class="col-sm-9 col-md-9">
            <div class="well">
                <h1>
                    Accordion Menu With Icon</h1>
                Admin Dashboard Accordion Menu
            </div>
        </div>-->
        </div>

        <div id="idFormulario" style=" bottom:1%;"></div>
    </div>

    <!--
    <div id="imagenFondo" style="width:80%; position:absolute; top:60%; left:30%;" >
        <img src="img/logoADA.png" />
    </div>-->
    <%
        Dim cadena As String = "MENU"
        If IdUsuarioPermiso = "" Then
            Response.Write("<script> alert('Session Invalida.'); location.href='../index.aspx'; </script>")
        End If

        Dim InstrSQL As String = "EXEC [dbo].[spRevisaPermiso] '" + IdEmpresa + "','" + IdUsuarioPermiso + "','" + cadena + "',1"
        'Response.Write(InstrSQL)
        Dim objetoMenu As System.Data.DataView
        objetoMenu = ObjetoClases.fnRegresaTabla(InstrSQL, "Menu")
        If objetoMenu.Count <> 0 Then
            Response.Write("<script>")
            For iMenu = 0 To objetoMenu.Count - 1
                Response.Write("document.getElementById('" + objetoMenu(iMenu)("idlista") + "').style.display = 'none'; ")
            Next
            'Response.Write(" document.getElementById('nombreUsuario').value = '" + Session("NombreUsuario") + "'; ")

            Response.Write("var idUsuarioGloblal = '" + IdUsuarioPermiso + "';")
            Response.Write("</script>")


        End If
    %>
        <iframe class="frameMaestra" name="iframeMaestra" id="iframeMaestra" allowtransparency="true" style="width:79%; left:21%;"></iframe>
    <style>
        #ventana-flotante {
            width: 300px; /* Ancho de la ventana */
            height: 400px; /* Alto de la ventana */
            background: #33FFFF; /* Color de fondo */
            position: fixed;
            top: 50%;
            left: 50%;
            margin-left: -180px;
            border: 1px solid #adffad; /* Borde de la ventana */
            box-shadow: 0 5px 25px rgba(0,0,0,.8); /* Sombra */
            z-index: 999;
            filter: alpha(opacity=100);
            opacity: 0.9;
            background-color: rgba(255, 0, 8, 0);
        }

            #ventana-flotante #contenedor {
                padding: 25px 10px 10px 10px;
            }

            #ventana-flotante .cerrar {
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

                #ventana-flotante .cerrar:hover {
                    background: #ff6868;
                    color: white;
                    text-decoration: none;
                    text-shadow: -1px -1px red;
                    border-bottom: 1px solid red;
                    border-left: 1px solid red;
                }

            #ventana-flotante #contenedor .contenido {
                padding: 15px;
                box-shadow: inset 1px 1px white;
                background: #deffc4; /* Fondo del mensaje */
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
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</body>
<script type="text/javascript">

    function alerta(texto) {

        alertify.alert(texto, function () {
        });
    }
</script>
</html>

