Public Class provedores
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases()
    Public IdEmpresa As String = "ARAD14"
    Public cadenaTitulo As String = "MODULO DE PROVEDORES"
    Public cadenaPermiso As String = "MENU/CATALOGO PROVEDORES"
    'Public sessionUsuario As String = idUsuarioSession
    Public claseProducto As productos = New productos()


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
        Dim retornoBool As Boolean


        Dim accion As String = HttpContext.Current.Request.Form("accion")
        If accion = "agregaProvedor" Then
            Call fnAgregaProvedor(accion, Request.Form("idPaginaM"))

        End If

        If accion = "paginaProvedor" Then
            Dim numeroPagina As String = ""
            If Request.Form("idPaginaM") = "0" Then
                numeroPagina = "1"
            Else
                numeroPagina = Request.Form("idPaginaM")
            End If

            Call fnConsultaProvedor(numeroPagina, accion)
        End If

        If accion = "modificaProvedor" Then
            retornoBool = fnModificaProvedor(accion, HttpContext.Current.Request.Form("idPaginaM"))
        End If
    End Sub

    Public Function fnModificaProvedor(ByVal accion As String, ByVal numeroPagina As String) As Boolean
        Dim retornoInterno As Boolean
        Dim InstrSQL As String = ""

        InstrSQL = " EXEC [dbo].[spProvedor]  '" + Request.Form("idProvedorM") + "','" + IdEmpresa + "','" + Request.Form("nombreProvedorM") + "','" + Request.Form("RFCProvedorM") + "','" + Request.Form("direccionProvedorM") + "','" + Request.Form("telefonoProvedorM") + "','" + numeroPagina + "','10',3"

        Try
            retornoInterno = objetoClases.fnExecutaStored(InstrSQL)
            Response.Write("<script>alert('Registro Modificado con Exito');</script>")
        Catch ex As Exception
            retornoInterno = False
            Response.Write("<script>alert('" + ex.Message + "');</script>")
        End Try

        If retornoInterno = True Then
            Call fnConsultaProvedor(numeroPagina, accion)
        End If

        Return retornoInterno
    End Function

    Function fnConsultaProvedor(ByVal numeroPagina As String, ByVal accion As String) As Boolean
        Dim retornoBool As Boolean
        Dim totalPaginas As String = ""
        Dim tablaProvedor As Data.DataView
        Dim InstrSQL As String = ""
        Dim iContador As Integer
        Dim totalRegistrosReal As String = ""
        'fnAgregaTRProvedor

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('idPaginador').style.display = 'block'; ")
        Response.Write(" parent.fnLimpiaTabla('tablaDatosM','totalElementosM'); ")
        Response.Write(" parent.document.getElementById('idPaginaM').value = '" + numeroPagina + "'; ")
        Response.Write("</script>")

        InstrSQL = " EXEC [dbo].[spProvedor]  '','" + IdEmpresa + "','','','','','" + numeroPagina + "','10',99 "
        tablaProvedor = objetoClases.fnRegresaTabla(InstrSQL, "Paginas")
        totalPaginas = tablaProvedor(0)("Paginas").ToString
        totalRegistrosReal = tablaProvedor(0)("RegistrosTotales").ToString
        tablaProvedor = Nothing
        InstrSQL = Nothing

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('totalRegistroM').innerText = 'Total de Registros : " + totalRegistrosReal + "'; ")
        Response.Write(" parent.document.getElementById('totalPaginas').innerText = 'Pagina numero:" + numeroPagina + " de " + totalPaginas + "'; ")
        Response.Write("</script>")

        InstrSQL = " EXEC [dbo].[spProvedor]  '','" + IdEmpresa + "','','','','','" + numeroPagina + "','10', 0 "
        tablaProvedor = objetoClases.fnRegresaTabla(InstrSQL, "DetalleProvedor")
        If tablaProvedor.Count <> 0 Then
            Response.Write("<script>")
            For iContador = 0 To tablaProvedor.Count - 1

                Response.Write(" parent.fnAgregaTRProvedor('tablaDatosM','" + tablaProvedor(iContador)("IdProvedor").ToString + "','" + tablaProvedor(iContador)("NombreProvedor").ToString + "','" + tablaProvedor(iContador)("RFCProvedor").ToString + "','" + tablaProvedor(iContador)("DireccionProvedor").ToString + "','" + tablaProvedor(iContador)("TelefonoProvedor").ToString + "'); ")

            Next
            Response.Write("</script>")
        End If



        Return retornoBool
    End Function

    Public Function fnAgregaProvedor(ByVal accion As String, ByVal numeroPagina As String) As Boolean
        Dim retornoBool As Boolean
        Dim totalElementos As String = ""
        Dim sqlConexion As New Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim sqlComando As Data.SqlClient.SqlCommand
        Dim sqlTransaccion As Data.SqlClient.SqlTransaction

        totalElementos = HttpContext.Current.Request.Form("totalProvedorM")
        Dim iContador As Integer
        Dim InstrSQL As String = ""
        sqlConexion.Open()
        sqlTransaccion = sqlConexion.BeginTransaction()

        Try
            For iContador = 0 To totalElementos - 1
                InstrSQL = " EXEC [dbo].[spProvedor]  '','" + IdEmpresa + "'," _
                + "'" + Request.Form("nombreProvedor" + iContador.ToString) + "','" _
                + Request.Form("RFCProvedor" + iContador.ToString) + "','" _
                + Request.Form("direccionProvedor" + iContador.ToString) + "','" _
                + Request.Form("telefonoProvedor" + iContador.ToString) + "','','',1 "

                sqlComando = New SqlClient.SqlCommand(InstrSQL, sqlConexion)
                sqlComando.Transaction = sqlTransaccion
                sqlComando.ExecuteNonQuery()

            Next

            Response.Write("<script> alert('Provedores Agregados Exitosamente'); </script>")
            Response.Write("<script> parent.fnLimpiaTabla('bodyProvedorM','totalProvedorM'); </script>")
            Response.Write("<script> parent.fnLimpiaTabla('tablaDatosM','totalElementosM'); </script>")
            retornoBool = True
            sqlTransaccion.Commit()
        Catch ex As Exception
            sqlTransaccion.Rollback()
            retornoBool = False
            Response.Write("<script> alert('Ocurrio un Error. " + ex.Message + "'); </script>")
        End Try

        retornoBool = fnConsultaProvedor("1", accion)

        Return retornoBool
    End Function

End Class