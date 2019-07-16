<%@ Page Language="vb" EnableViewStateMac="false" AutoEventWireup="false"  CodeBehind="inicio.aspx.vb" EnableSessionState="True" AspCompat="true" Inherits="Factura.inicio" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <link rel="stylesheet" href="css/style.css" type="text/css" />
    <link rel="stylesheet" href="css/estiloTelerik.css" type="text/css" />
    <link rel="Stylesheet" href="css/formulariosStyle.css" type="text/css" />
    <script src="../js/JQuery.js" type="text/javascript"></script>
    <link rel="shortcut icon" href="img/faveicon.jpg" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <script type="text/javascript">
        var totalElementos;
        function fnSalir() {
            alert('Gracias por utilizar Genera tu Recibo CFDI');
            document.getElementById('accion').value = 'salir';
            var form = document.getElementById('form1');
            form.action = '../index.aspx';
            form.submit();
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
   <telerik:RadStyleSheetManager id="RadStyleSheetManager1" runat="server" />
</head>
<body>
    <header>
        <div align="center">
        <h4 id="tituloModulo" style="color:white; border:0px;font-weight:bold;"></h4>
            <div align="left" style="position:absolute; top:5px;">
              <img src="img/logotipo.png" width="180" height="40" />
            </div>
            <div align="right" style="position:absolute; top:5px; right:10px;">
                <h4 id="nombreUsuario" style="color:white; font-size:12px; font-style:italic;  border:0px;">USUARIO : <% Response.Write(Session("NombreUsuario")) %></h4>
            </div>
        </div>
       
    </header>
    <form id="form1" runat="server" >
         <telerik:RadScriptManager runat="server" ID="RadScriptManager1" />
            <telerik:RadSkinManager ID="QsfSkinManager" runat="server" ShowChooser="false" />
            <telerik:RadFormDecorator ID="QsfFromDecorator" runat="server" DecoratedControls="All" EnableRoundedCorners="true" /> 

          <div class="qsf-demo-canvas" style="position:absolute; top:20%; left:2%;">
              <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" >
                <div class="qsf-demo-canvas qsf-demo-canvas-vertical">
                    <telerik:RadMenu ID="menuPadreM" runat="server" Flow="Vertical" Width="180" Skin="MetroTouch" >
                        <Items>
                            <telerik:RadMenuItem Text="Emision de Recibos"  GroupSettings-Flow="Vertical" GroupSettings-OffsetY="-1">
                                <Items>
                                    <telerik:RadMenuItem id="EmisionFactura" Text="Emision de Factura"  NavigateUrl="facturas/factura.aspx" Target="iframeMaestra"></telerik:RadMenuItem>
                                    <telerik:RadMenuItem  id="EmisionCotizacion" Text="Emision de Cotizaciones / Notas de Venta"  NavigateUrl="cotizaciones/cotizacion.aspx" Target="iframeMaestra"></telerik:RadMenuItem>
                                </Items>
                            </telerik:RadMenuItem>
                            <telerik:RadMenuItem Text="Catalogos" GroupSettings-Flow="Vertical" GroupSettings-OffsetY="-1">
                                <Items>
                                    <telerik:RadMenuItem id="CatalogoClientes" Text="Catalogo de Clientes" NavigateUrl="catalogos/cliente.aspx" Target="iframeMaestra"></telerik:RadMenuItem>
                                    <telerik:RadMenuItem  id="CatalogoProvedores" Text="Catalogo de Proovedores" NavigateUrl="catalogos/provedores.aspx" Target="iframeMaestra"></telerik:RadMenuItem>
                                    <telerik:RadMenuItem  id="CatalogoProductos" Text="Catalogo de Productos"  NavigateUrl="catalogos/productos.aspx?idUsuario=Otro" Target="iframeMaestra"></telerik:RadMenuItem>
                                </Items>
                            </telerik:RadMenuItem>
                            <telerik:RadMenuItem Text="Consultas" GroupSettings-Flow="Vertical" GroupSettings-OffsetY="-1">
                                <Items>
                                    <telerik:RadMenuItem  id="ConsultaFacturas" Text="Consulta Facturas" NavigateUrl="facturas/consultaFactura.aspx" Target="iframeMaestra"></telerik:RadMenuItem>
                                    <telerik:RadMenuItem  id="ConsultaNotas" Text="Consulta Notas" NavigateUrl="facturas/consultaNota.aspx" Target="iframeMaestra"></telerik:RadMenuItem>
                                    <telerik:RadMenuItem  id="ConsultaCotizaciones" Text="Consulta Cotizaciones" NavigateUrl="cotizaciones/consultaCotizacion.aspx" Target="iframeMaestra"></telerik:RadMenuItem>
                                </Items>
                            </telerik:RadMenuItem>
                           
                            <telerik:RadMenuItem Text="Seguridad" GroupSettings-Flow="Vertical" GroupSettings-OffsetY="-1">
                                <Items>
                                    <telerik:RadMenuItem   id="Permisos" Text="Permisos" NavigateUrl="seguridad/permiso.aspx" Target="iframeMaestra"></telerik:RadMenuItem>
                                </Items>
                            </telerik:RadMenuItem>
                            <telerik:RadMenuItem Text="Opciones Sistema" GroupSettings-Flow="Vertical" GroupSettings-OffsetY="-1">
                                <Items>
                                    <telerik:RadMenuItem Text="Salir del Sistema" onclick="javascript:fnSalir();"></telerik:RadMenuItem>
                                </Items>
                            </telerik:RadMenuItem>
                        </Items>
                        <ExpandAnimation Type="None" />
                        <CollapseAnimation Type="None" />
                    </telerik:RadMenu>
                </div>
              </telerik:RadAjaxPanel>
          </div>      
    <input type="hidden" id="accion" name="accion" value="" />
        <input type="hidden" id="accionReporte" name="accionReporte" value="" />
        <div id="divMenu" class="divMenu" style="display:none;">
            <ul>
                
                <li ><a class="a" href="catalogos/cliente.aspx" target="iframeMaestra">Catalogo de clientes</a></li>
                <li ><a class="a" href="catalogos/provedores.aspx" target="iframeMaestra">Catalogo de Provedores</a></li>
                <li ><a class="a" href="catalogos/productos.aspx" target="iframeMaestra">Catalogo de Productos</a></li>
                <li ><a class="a" href="facturas/consultaFactura.aspx" target="iframeMaestra">Consulta facturas</a></li>
                <li ><a class="a" href="facturas/consultaNota.aspx" target="iframeMaestra">Consulta Notas</a></li>
                <li ><a class="a" href="cotizaciones/consultaCotizacion.aspx" target="iframeMaestra">Consulta Cotizaciones</a></li>
                <li><a class="a" href="reportes/reporteAlmacen.aspx" target="iframeMaestra">Reporte Almacen</a></li>
                <li><a class="a" href="seguridad/permiso.aspx" target="iframeMaestra">Permisos</a></li>
                <li><a class="a" onclick="javascript:fnSalir();">Salir del Sistema</a></li>
            </ul>
        </div>
    <div>
    </div>
        
    </form>
    <%
        Dim cadena As String = "MENU"
        Dim InstrSQL As String = "EXEC [dbo].[spRevisaPermiso] '" + IdEmpresa + "','" + Session("IdUsuario").ToString + "','" + cadena + "',1"
		
        Dim objetoMenu As System.Data.DataView
        objetoMenu = ObjetoClases.fnRegresaTabla(InstrSQL, "Menu")
        If objetoMenu.Count <> 0 Then
            Response.Write("<script>")
            For iMenu = 0 To objetoMenu.Count - 1
                Response.Write("document.getElementById('" + objetoMenu(iMenu)("idlista") + "').style.display = 'none'; ")
            Next
            'Response.Write(" document.getElementById('nombreUsuario').value = '"+Session("NombreUsuario")+"'; ")
            
            Response.Write("var idUsuarioGloblal = '"+Session("IdUsuario").ToString+"';")
            Response.Write("</script>")
            
            
        End If
     %>
    <iframe   class="frameMaestra"  name="iframeMaestra" id="iframeMaestra"></iframe>
</body>
</html>

