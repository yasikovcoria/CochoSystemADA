
Public Class cliente
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases
    Public cadenaTitulo As String = "MODULO DE CLIENTES"
    Public cadenaPermiso As String = "MENU/CATALOGO CLIENTES"
    Public IdEmpresa As String = "ARAD14"
    Public IdUsuarioPermiso As String = variableSession.idUsuarioSession


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
        ' Declaracion de Variables
        Dim accion As String = ""
        accion = Request.Form("accion")
        If accion = "muestraCliente" Then Call fnPaginaCliente("1", accion)
        If accion = "paginaCliente" Then Call fnPaginaCliente(Request.Form("idPaginaM"), accion)
        If accion = "consultaCliente" Then Call fnConsultaCliente(Request.Form("idClienteM"), accion)
        If accion = "modificarCliente" Then Call fnGuardarCliente(Request.Form("idClienteM"), accion)
        If accion = "agregarCliente" Then Call fnGuardarCliente(Request.Form("idClienteM"), accion)
    End Sub

    Function fnGuardarCliente(ByVal idClienteM As String, ByVal accion As String) As Boolean
        Dim InstrSQL As String = ""
        Dim auxiliarAccion As String = "3"
        If accion = "agregarCliente" Then
            auxiliarAccion = "1"
        End If
        InstrSQL = "EXEC [dbo].[spCliente] '" + Request.Form("idClienteM") + "', '" + Request.Form("nombreClienteM") + "|" + Request.Form("tipoProcesoM") + "|" + Request.Form("tipoAmbitoM") + "|" + Request.Form("idContabilidadM") + "|" + Request.Form("claveSatEstadoM") + "' " _
            + ", '" + Request.Form("apellidoP") + "', '" + Request.Form("apellidoM") + "', '" + Request.Form("rfcClienteM") + "' " _
            + " , '" + Request.Form("curpClienteM") + "', '" + Request.Form("telefonoM") + "', '" + Request.Form("correoM") + "', '' " _
            + ", '" + Request.Form("tipoPersonaM") + "', '" + Request.Form("numeroInteriorM") + "', '" + Request.Form("numeroExteriorM") + "' " _
            + ", '" + Request.Form("municipioM") + "', '" + Request.Form("localidadM") + "', '" + Request.Form("estadoM") + "', '" + Request.Form("coloniaClienteM") + "' " _
            + ", '" + Request.Form("codigoPostalM") + "', '" + Request.Form("paisM") + "', '" + Request.Form("calleClienteM") + "','" + Request.Form("claveSatUsoM") + "', " + auxiliarAccion + ""
        Dim retornoBool As Boolean = False
        retornoBool = objetoClases.fnExecutaStored(InstrSQL)
        If retornoBool = True Then
            If auxiliarAccion = "1" Then
                Response.Write("<script> parent.parent.alerta('Cliente Agregado Exitosamente'); </script>")
            Else
                Response.Write("<script> parent.parent.alerta('Cliente Modificado Exitosamente'); </script>")
            End If
        Else
            Response.Write("<script> parent.parent.alerta('Ocurrio un Error'); </script>")
        End If
        Return retornoBool
    End Function

    Function fnConsultaCliente(ByVal idClienteM As String, ByVal accion As String) As Boolean
        Dim InstrSQL As String = "EXEC [dbo].[spCliente]'" + idClienteM + "', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '','', 99"
        Dim tablaCliente As DataView
        Dim tipoPersona As String = ""
        If idClienteM <> "" Then
            tablaCliente = objetoClases.fnRegresaTabla(InstrSQL, "Cliente")
            If tablaCliente.Count <> 0 Then

                

                Response.Write("<script>")

                If tablaCliente(0)("TipoPersona").ToString = "0" Then
                    Response.Write(" parent.document.getElementById('tipoPersonaMoralM').checked = true; ")
                    Response.Write(" parent.document.getElementById('tipoPersonaFisicaM').checked = false; ")
                Else
                    Response.Write(" parent.document.getElementById('tipoPersonaMoralM').checked = false; ")
                    Response.Write(" parent.document.getElementById('tipoPersonaFisicaM').checked = true; ")
                End If

                'Nuevo Cambio UsoCfdiSAT
                Response.Write(" parent.document.getElementById('claveSatUsoM').value = '" + tablaCliente(0)("IdUsoCfdiSat").ToString + "'; ")
                Response.Write(" parent.document.getElementById('usoCfdiSAT').value = '" + tablaCliente(0)("UsoCfdiSAT").ToString + "'; ")

                'Termina UsoCfdiSat

                Response.Write(" parent.document.getElementById('idClaveClienteM').value = '" + tablaCliente(0)("IdCliente").ToString + "'; ")
                Response.Write(" parent.document.getElementById('nombreClienteM').value = '" + tablaCliente(0)("Nombre").ToString + "'; ")
                Response.Write(" parent.document.getElementById('apellidoP').value = '" + tablaCliente(0)("ApePaterno").ToString + "'; ")
                Response.Write(" parent.document.getElementById('apellidoM').value = '" + tablaCliente(0)("ApeMaterno").ToString + "'; ")
                Response.Write(" parent.document.getElementById('rfcClienteM').value = '" + tablaCliente(0)("RFC").ToString + "'; ")
                Response.Write(" parent.document.getElementById('curpClienteM').value = '" + tablaCliente(0)("CURP").ToString + "'; ")
                Response.Write(" parent.document.getElementById('correoM').value = '" + tablaCliente(0)("Correo").ToString + "'; ")
                Response.Write(" parent.document.getElementById('telefonoM').value = '" + tablaCliente(0)("Telefono").ToString + "'; ")
                Response.Write(" parent.document.getElementById('calleClienteM').value = '" + tablaCliente(0)("CalleCliente").ToString + "'; ")
                Response.Write(" parent.document.getElementById('coloniaClienteM').value = '" + tablaCliente(0)("Colonia").ToString + "'; ")
                Response.Write(" parent.document.getElementById('numeroInteriorM').value = '" + tablaCliente(0)("NumeroInterior").ToString + "'; ")
                Response.Write(" parent.document.getElementById('numeroExteriorM').value = '" + tablaCliente(0)("NumeroExterior").ToString + "'; ")
                Response.Write(" parent.document.getElementById('codigoPostalM').value = '" + tablaCliente(0)("CodigoPostal").ToString + "'; ")
                Response.Write(" parent.document.getElementById('localidadM').value = '" + tablaCliente(0)("Localidad").ToString + "'; ")
                Response.Write(" parent.document.getElementById('municipioM').value = '" + tablaCliente(0)("Municipio").ToString + "'; ")
                Response.Write(" parent.document.getElementById('estadoM').value = '" + tablaCliente(0)("Estado").ToString + "'; ")
                Response.Write(" parent.document.getElementById('nombreEstadoM').setAttribute('value','" + tablaCliente(0)("Estado").ToString + "'); ")
                Response.Write(" parent.document.getElementById('paisM').value = '" + tablaCliente(0)("PaisCliente").ToString + "'; ")
                Response.Write(" parent.document.getElementById('nombrePaisM').setAttribute('value','" + tablaCliente(0)("NombrePais").ToString + "'); ")
                Response.Write(" parent.document.getElementById('tipoProcesoM').setAttribute('value','" + tablaCliente(0)("TipoProceso").ToString + "'); ")
                Response.Write(" parent.document.getElementById('tipoAmbitoM').setAttribute('value','" + tablaCliente(0)("TipoAmbito").ToString + "'); ")
                Response.Write(" parent.document.getElementById('idContabilidadM').setAttribute('value','" + tablaCliente(0)("IdContabilidad").ToString + "'); ")
                Response.Write(" parent.document.getElementById('claveSatEstadoM').setAttribute('value','" + tablaCliente(0)("ClaveSatEstado").ToString + "'); ")
                Response.Write(" parent.document.getElementById('nombreEstadoSatM').setAttribute('value','" + tablaCliente(0)("NombreEstado").ToString + "'); ")






                Response.Write(" parent.fnMuestra('oculta'); ")

                Response.Write("</script>")
            End If
            tablaCliente = Nothing
        End If

        Return True
    End Function

    Public Function fnPaginaCliente(ByVal numeroPagina As String, ByVal accion As String) As Boolean

        Dim totalPaginas As String = ""
        Dim tablaCliente As Data.DataView
        Dim InstrSQL As String = ""
        Dim iContador As Integer
        Dim totalRegistrosReal As String = ""
        'fnAgregaTRProducto

        Response.Write("<script>")
        'Response.Write(" parent.document.getElementById('idPaginador').style.display = 'block'; ")
        Response.Write(" parent.fnLimpiaTabla('tablaDatosM','totalElementosM'); ")
        Response.Write(" parent.document.getElementById('idPaginaM').value = '" + numeroPagina + "'; ")
        Response.Write("</script>")

        InstrSQL = " EXEC [dbo].[spPaginadorCliente] '10', '" + numeroPagina + "', '" + IdEmpresa + "', 99 "
        tablaCliente = objetoClases.fnRegresaTabla(InstrSQL, "Paginas")
        totalPaginas = tablaCliente(0)("Paginas").ToString
        totalRegistrosReal = tablaCliente(0)("RegistrosTotales").ToString
        tablaCliente = Nothing
        InstrSQL = Nothing

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('totalRegistroM').innerText = 'Total de Registros : " + totalRegistrosReal + "'; ")
        Response.Write(" parent.document.getElementById('totalPaginas').innerText = 'Pagina numero:" + numeroPagina + " de " + totalPaginas + "'; ")
        Response.Write("</script>")

        InstrSQL = " EXEC [dbo].[spPaginadorCliente] '10', '" + numeroPagina + "', '" + IdEmpresa + "', 1"
        tablaCliente = objetoClases.fnRegresaTabla(InstrSQL, "DetalleCliente")
        If tablaCliente.Count <> 0 Then
            Dim styloTR As String = ""
            Response.Write("<script>")
            For iContador = 0 To tablaCliente.Count - 1
                styloTR = "blanco"
                If iContador Mod 2 = 1 Then styloTR = "azul"

                Response.Write(" parent.fnAgregaTRCliente('tablaDatosM','" + tablaCliente(iContador)("ClaveCliente").ToString + "','" + tablaCliente(iContador)("NombreCliente").ToString + "'," _
                + " '" + tablaCliente(iContador)("CorreoCliente").ToString + "','" + tablaCliente(iContador)("TipoPersonaCliente").ToString + "','" + styloTR + "'); ")

            Next
            If accion = "muestraCliente" Then
                Response.Write(" parent.fnMuestra('muestra'); ")

            End If
          

            Response.Write("</script>")
        End If
        Return True
    End Function

    Public Function fnRegresaCliente(ByVal InstrSQL As String, ByVal accion As String) As Boolean
        Dim retorno As Boolean

        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim tipoPersona As Integer = 0

        Try
            SqlConnection.Open()
            Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)
            DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
            DataAdapter.Fill(DataSet, "tabla")
            DataView = DataSet.Tables("tabla").DefaultView

        Catch ex As Exception
            retorno = False
        End Try


        Return retorno
    End Function

End Class
