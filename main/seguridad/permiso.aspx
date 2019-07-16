<%@ Page Language="vb" AutoEventWireup="false" AspCompat="true" CodeBehind="permiso.aspx.vb" Inherits="CochoSystem.permiso" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="Stylesheet" type="text/css" href="../css/formulariosStyle.css" />
    <link rel="Stylesheet" type="text/css" href="../css/formularios.css" />
    <script src="../js/JQuery.js" type="text/javascript"></script>
    <title></title>
     <% Response.WriteFile("../js/fnGeneral.asp")%>
      
    <script type="text/javascript">
        var esconderFrame = 0;
        document.onclick = function () { esconderX(); }
        var objetoDiv = parent.document.getElementById('idFormulario');
        objetoDiv.innerHTML = '';

        function esconderX() {

            if (esconderFrame == 1) {
                document.getElementById("catalogo").style.visibility = "hidden";

            }
            esconderFrame = 1;
        }
        function fnPaginarPermiso(valorPaginar) {

            var valorInicial = parseFloat(document.getElementById('idPaginaM').value);
            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = 'paginaPermiso';
            if (valorPaginar == '-1') {
                document.getElementById('idPaginaM').value = valorInicial - 1;
            } else {
                document.getElementById('idPaginaM').value = valorInicial + 1;
            }
            try {
                form1.method = 'POST';
                //form1.target = 'fnProcesos';
                form1.submit();
            } catch (ex) {
                alert(ex.message);
            }
            
        }
        function fnEnviar(accion) {

           
            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = accion;
            form1.method = 'POST';
            //form1.target = 'fnProcesos';
            form1.submit();

        }
        function fnEliminar(idElemento) {
            document.getElementById('accion').value = 'eliminaPermiso';
            document.getElementById('idPermisoModuloM').value = idElemento;
            var form1 = document.getElementById('form1');
            form1.method = 'POST';
            //form1.target = 'fnProcesos';
            form1.submit();

        }


        function fnCargaPermiso(idElemento) {
            
            var nombreModulo = document.getElementById('nombreModulo' + idElemento).value;
            var idModulo = document.getElementById('idModuloPermiso' + idElemento).value;
            var nombreUsuario = document.getElementById('nombreUsuario' + idElemento).value;
            var idUsuario = document.getElementById('idUsuarioPermiso' + idElemento).value;
            var idPermisoModulo = document.getElementById('idPermisoModulo' + idElemento).value;

            document.getElementById('nombreModuloPermisoM').value = nombreModulo;
            document.getElementById('idModuloPermisoM').value = idModulo;
            document.getElementById('nombreUsuarioPermisoM').value = nombreUsuario;
            document.getElementById('idUsuarioPermisoM').value = idUsuario;
            document.getElementById('idPermisoModuloM').value = idPermisoModulo;


            var banderaModifica = document.getElementById('modificarPermiso' + idElemento);
            var banderaAgregar = document.getElementById('agregarPermiso' + idElemento);
            var banderaConsultar = document.getElementById('consultarPermiso' + idElemento);
            var banderaEliminar = document.getElementById('eliminarPermiso' + idElemento);
            if (banderaModifica.checked == true) {
                document.getElementById('modificarPermisoM').value = '1';
                document.getElementById('modificarPermisoM').checked = true;
            } else {
                document.getElementById('modificarPermisoM').value = '0';
                document.getElementById('modificarPermisoM').checked = false;
            }
            if (banderaAgregar.checked == true) {
                document.getElementById('agregarPermisoM').value = '1';
                document.getElementById('agregarPermisoM').checked = true;
            } else {
                document.getElementById('agregarPermisoM').value = '0';
                document.getElementById('agregarPermisoM').checked = false;
            }
            if (banderaConsultar.checked == true) {
                document.getElementById('consultarPermisoM').value = '1';
                document.getElementById('consultarPermisoM').checked = true;
            } else {
                document.getElementById('consultarPermisoM').value = '0';
                document.getElementById('consultarPermisoM').checked = false;
            }
            if (banderaEliminar.checked == true) {
                document.getElementById('eliminarPermisoM').value = '1';
                document.getElementById('eliminarPermisoM').checked = true;
            } else {
                document.getElementById('eliminarPermisoM').value = '0';
                document.getElementById('eliminarPermisoM').checked = false;
            }

        }

        function fnValorPermiso(objeto) {
            var banderaBOOL;
            banderaBOOL = objeto.checked;
            if (banderaBOOL == true) {
                objeto.value = '1';
            } else {
                objeto.value = '0';
            }
        }

        $(document).ready(function () {

            var porcentajeTop = parent.document.getElementById('menuPrincipal').style.top;


            var objetoDiv = parent.document.getElementById('idFormulario');
            var botonProcesar = document.createElement('a');
            botonProcesar.className = 'btn btn-primary btn-sm';
            botonProcesar.style.width = '200px';
            botonProcesar.innerHTML = 'Agregar';
            botonProcesar.onclick = function () { window.fnEnviar('agregaPermiso'); };

            var botonModificar = document.createElement('a');
            botonModificar.className = 'btn btn-primary btn-sm';
            botonModificar.style.width = '200px';
            botonModificar.style.paddingTop = '5px';
            botonModificar.innerText = 'Modificar';
            botonModificar.onclick = function () { window.fnEnviar('modificaPermiso'); };


            var espacio = document.createElement('br');
            var espacio2 = document.createElement('br');
            var espacio3 = document.createElement('br');
            var espacio4 = document.createElement('br');
            var espacio5 = document.createElement('br');

            objetoDiv.innerHTML = '';

            objetoDiv.appendChild(botonProcesar);
            objetoDiv.appendChild(espacio);
            objetoDiv.appendChild(espacio2);
            objetoDiv.appendChild(botonModificar);
            objetoDiv.appendChild(espacio3);
            objetoDiv.appendChild(espacio4);
            //objetoDiv.appendChild(botonImprimir);


        });

    </script>
   
</head>
        
<body  style="padding-top: 0px;">
    
    <form id="form1">
        <input type="hidden" name="accion" id="accion" value="" />
    <table width="90%">
        <tr>
            <td align="center">
                <table>
                    <tr>
                        <td>
                            <table id="idPaginador" style="padding-top: 0px;">
                                <tr>

                                    <td>
                                        <img src="../img/atras.jpg" width="30" title="Retroceder Pagina" height="18" onclick="fnPaginarPermiso('-1');" style="cursor: pointer;" />
                                    </td>

                                    <td>
                                        <fieldset style="border: solid 1px rgba(185,186,187,0.25);">
                                            <table>
                                                <tr>

                                                    <td>
                                                        <input type="text" name="idPaginaM" id="idPaginaM" value="0" style="width: 30px; height: 15px; text-align: center; font-size: 10px; font-family: Arial; font-weight: bold;" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </td>
                                    <td>
                                        <img src="../img/adelante.jpg" style="cursor: pointer" title="Adelante Pagina" onclick="javascript:fnPaginarPermiso('1');" width="30" height="18" />
                                    </td>
                                </tr>
                            </table>

                        </td>
                    </tr>
                </table>
            </td>
            </tr>
        <tr>
            <td align="center">
                <table width="80%">
                    <tr style="background-color:lightblue; text-align:center;">
                        <td><span style="font-weight:bold; font-size:15px;">Modulo</span></td>
                        <td><span style="font-weight:bold; font-size:15px;">Usuario</span></td>
                        <td><span style="font-weight:bold; font-size:15px;">Modificar</span></td>
                        <td><span style="font-weight:bold; font-size:15px;">Agregar</span></td>
                        <td><span style="font-weight:bold; font-size:15px;">Consultar</span></td>
                        <td><span style="font-weight:bold; font-size:15px;">Eliminar</span></td>
                    </tr>
                    <% Dim pathImagenes As String = "../img/"
                        
                        Dim paginaM As String = ""
                        If Request.Form("idPaginaM") = "" Then
                            paginaM = "1"
                        Else
                            paginaM = Request.Form("idPaginaM")
                        End If
                        
                        Dim IntrSQL As String = " EXEC [dbo].[spPermisoModulo] '', '', '', '', '', '', '', '', '" + paginaM + "', '10', 0 "

                        Dim objetoTabla As System.Data.DataView
                        objetoTabla = objetoClases.fnRegresaTabla(IntrSQL, "Permiso")
                        Dim styloTR As String = "", checkmodificar As String = "", checkagregar As String = "",checkconsultar As String="",checkeliminar As String=""
                        Dim styloRead As String="readOnly"
                        If objetoTabla.Count <> 0 Then
                            For icontador = 0 To objetoTabla.Count - 1
                                checkmodificar = ""
                                checkagregar = ""
                                checkconsultar = ""
                                checkeliminar=""
                                If objetoTabla(icontador)("Modificar").ToString = "1" Then checkmodificar = "checked"
                                If objetoTabla(icontador)("Agregar").ToString = "1" Then checkagregar = "checked"
                                If objetoTabla(icontador)("Consultar").ToString = "1" Then checkconsultar = "checked"
                                If objetoTabla(icontador)("Eliminar").ToString = "1" Then checkeliminar = "checked"
                                
                                styloTR = ""
                                If (icontador Mod 2 = 0) = True Then styloTR = "background-color:lightblue;"
                                
                                Response.Write("<tr style=""" + styloTR + "border-collapse:collapse; cursor:pointer; padding-top:20px;"" class=""normal"" onclick=""fnCargaPermiso('" + icontador.ToString() + "');"">")
                                Response.Write("<td style=""width: 200px; text-align: left; ""><input type=""hidden""  name=""idModuloPermiso" + icontador.ToString + """ id=""idModuloPermiso" + icontador.ToString + """ value=""" + objetoTabla(icontador)("IdModulo").ToString + """ /><input type=""hidden"" name=""nombreModulo" + icontador.ToString + """ id=""nombreModulo" + icontador.ToString + """ value=""" + objetoTabla(icontador)("Modulo").ToString + """ /> " + objetoTabla(icontador)("Modulo").ToString + "</td>")
                                Response.Write("<td style=""width: 200px; text-align: center; ""><input type=""hidden""  name=""idUsuarioPermiso" + icontador.ToString + """ id=""idUsuarioPermiso" + icontador.ToString + """ value=""" + objetoTabla(icontador)("IdUsuario").ToString + """ /><input type=""hidden"" name=""nombreUsuario" + icontador.ToString + """ id=""nombreUsuario" + icontador.ToString + """ value=""" + objetoTabla(icontador)("NombreUsuario").ToString + """ /> " + objetoTabla(icontador)("NombreUsuario").ToString + "</td>")
                                Response.Write("<td style="" text-align: center;""><input type=""checkbox"" " + styloRead + " name=""modificarPermiso" + icontador.ToString + """ id=""modificarPermiso" + icontador.ToString + """ value=""" + objetoTabla(icontador)("Modificar").ToString + """ " + checkmodificar + " /></td>")
                                Response.Write("<td style="" text-align: center;""><input type=""checkbox"" " + styloRead + " name=""agregarPermiso" + icontador.ToString + """ id=""agregarPermiso" + icontador.ToString + """ value=""" + objetoTabla(icontador)("Agregar").ToString + """ " + checkagregar + " /></td>")
                                Response.Write("<td style="" text-align: center;""><input type=""checkbox"" " + styloRead + " name=""consultarPermiso" + icontador.ToString + """ id=""consultarPermiso" + icontador.ToString + """ value=""" + objetoTabla(icontador)("Consultar").ToString + """ " + checkconsultar + " /></td>")
                                Response.Write("<td style="" text-align: center;""><input type=""hidden"" id=""idPermisoModulo" + icontador.ToString + """ id=""idPermisoModulo" + icontador.ToString + """ value=""" + objetoTabla(icontador)("IdPermisoModulo").ToString + """ /><input type=""checkbox"" " + styloRead + " name=""eliminarPermiso" + icontador.ToString + """ id=""eliminarPermiso" + icontador.ToString + """ value=""" + objetoTabla(icontador)("Eliminar").ToString + """ " + checkeliminar + " /></td>")
                                Response.Write("<td style="" text-align: center;""><img src=""" + pathImagenes + "eliminar.jpg"" onclick=""fnEliminar('" + objetoTabla(icontador)("IdPermisoModulo").ToString + "');"" width=""20"" height=""20"" /></td>")
                                Response.Write("</tr>")
                            Next
                           
                            
                        End If
                       
                       
                        Response.Write("<script>document.getElementById('idPaginaM').value='" + paginaM + "';</script>")
                        
                        
                    %>
                    <tr>
                        <td style="width: 200px; text-align: center; padding-top:20px;">
                                <div id="moduloPermisoM" style="width: 220px">
                                    <input name="nombreModuloPermisoM" id="nombreModuloPermisoM" value="" class="text" type="text" maxlength="100" style="width: 170px; font-family: Arial; font-size: 10px; font-weight: bold;"
                                        onkeydown="javascript:fnObtenPosicionInput('nombreModuloPermisoM');catalogo.verificaCatalogo('Modulo','nombreModuloPermisoM','idModuloPermisoM','catalogo',50,300,100,'','',event,10,false,false,false,'parent');"
                                        onblur="javascript:if(this.value=='') {document.getElementById('idModuloPermisoM').value='';}" onchange="if(this.value=='') {document.getElementById('idModuloPermisoM').value='';}" />

                                    <img src="../img/comboImg/down.png"  onmouseover="this.src='../img/comboImg/down.png';" onmouseout="this.src='../img/comboImg/down.png';"
                                        onclick="javascript:fnObtenPosicionInput('nombreModuloPermisoM');document.getElementById('idModuloPermisoM').value='';document.getElementById('idModuloPermisoM').value='';this.src='../img/comboImg/down.png';
                                                        catalogo.verificaCatalogo('Modulo','nombreModuloPermisoM','idModuloPermisoM','catalogo',0,300,100,'','',event,10,true,false,false,'parent');esconderFrame=1;"
                                        style="cursor: pointer" align="top" />
                                    <input type="hidden" name="idModuloPermisoM" id="idModuloPermisoM" value="" />
                                    <input type="hidden" id="idPermisoModuloM" name="idPermisoModuloM" value="" /> 
                                </div>
                            </td>
                        <td style="width: 200px; text-align: center; padding-top:20px;">
                                <div id="usuarioPermisoM" style="width: 220px">
                                    <input name="nombreUsuarioPermisoM" id="nombreUsuarioPermisoM" value="" class="text" type="text" maxlength="100" style="width: 170px; font-family: Arial; font-size: 10px; font-weight: bold;"
                                        onkeydown="javascript:fnObtenPosicionInput('nombreUsuarioPermisoM');catalogo.verificaCatalogo('Usuario','nombreUsuarioPermisoM','idUsuarioPermisoM','catalogo',50,300,100,'','',event,10,false,false,false,'parent');"
                                        onblur="javascript:if(this.value=='') {document.getElementById('idUsuarioPermisoM').value='';}" onchange="if(this.value=='') {document.getElementById('idUsuarioPermisoM').value='';}" />

                                    <img src="../img/comboImg/down.png"  onmouseover="this.src='../img/comboImg/down.png';" onmouseout="this.src='../img/comboImg/down.png';"
                                        onclick="javascript:fnObtenPosicionInput('nombreUsuarioPermisoM');document.getElementById('idUsuarioPermisoM').value='';document.getElementById('idUsuarioPermisoM').value='';this.src='../img/comboImg/down.png';
                                                        catalogo.verificaCatalogo('Usuario','nombreUsuarioPermisoM','idUsuarioPermisoM','catalogo',0,300,100,'','',event,10,true,false,false,'parent');esconderFrame=1;"
                                        style="cursor: pointer" align="top" />
                                    <input type="hidden" name="idUsuarioPermisoM" id="idUsuarioPermisoM" value="" />
                                </div>
                            </td>
                        <td align="center" style="padding-top:20px;">
                            <input type="checkbox" name="modificarPermisoM" id="modificarPermisoM" onclick="javascript: fnValorPermiso(this);" value="0" />
                        </td>
                        <td align="center" style="padding-top:20px;">
                            <input type="checkbox" name="agregarPermisoM" id="agregarPermisoM" onclick="javascript: fnValorPermiso(this);" value="0" />
                        </td>
                        <td align="center" style="padding-top:20px;">
                            <input type="checkbox" name="consultarPermisoM" id="consultarPermisoM" onclick="javascript: fnValorPermiso(this);" value="0" />
                        </td>
                        <td align="center" style="padding-top:20px;">
                            <input type="checkbox" name="eliminarPermisoM" id="eliminarPermisoM" onclick="javascript: fnValorPermiso(this);" value="0" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        
    </table>
    </form>
     <iframe id="fnProcesos" name="fnProcesos" style="display:none; width: 100px; height: 100px; position: absolute; top: 70%;"></iframe>
     <iframe src="../clases/autoComplete.asp?GVIdSesion=9999" id="catalogo" name="catalogo" width="350px" frameborder="0" scrolling="no" style="border: 0 ridge; visibility: hidden; position: absolute; z-index: 65535;"></iframe>

</body>
</html>
