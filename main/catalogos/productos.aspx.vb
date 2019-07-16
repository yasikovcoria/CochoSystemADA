Public Class productos
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases()
    Public IdEmpresa As String = "ARAD14"
    Public cadenaTitulo As String = "MODULO DE ALMACEN"
    Public cadenaPermiso As String = "MENU/CATALOGO PRODUCTO"
    Public IdUsuarioPermiso As String = variableSession.idUsuarioSession
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
        Dim retornoBool As Boolean


        Dim accion As String = HttpContext.Current.Request.Form("accion")
        If accion = "agregaProducto" Then
            Call fnAgregaProducto(accion, Request.Form("idPaginaM"))

        End If

        If accion = "paginaProducto" Then
            Dim numeroPagina As String = ""
            If Request.Form("idPaginaM") = "0" Then
                numeroPagina = "1"
            Else
                numeroPagina = Request.Form("idPaginaM")
            End If

            Call fnConsultaProducto(numeroPagina, accion)
        End If

        If accion = "buscar" Then
            Call fnConsultaProducto("1", accion)
        End If

        If accion = "modificaProducto" Then
            retornoBool = fnModificaProducto(accion, HttpContext.Current.Request.Form("idPaginaM"))
        End If

    End Sub

    Public Function fnModificaProducto(ByVal accion As String, ByVal numeroPagina As String) As Boolean
        Dim retornoInterno As Boolean
        Dim InstrSQL As String = ""
        InstrSQL = " EXEC [dbo].[spCatalogoSatProducto]  '" + Request.Form("idProductoM") + "','" + IdEmpresa + "|" + Request.Form("nombreProductoM") + "|" + variableSession.idUsuarioSession + "'," _
               + "'" + Request.Form("nombreProductoM") + "','" _
               + Request.Form("precioProductoM") + "','" _
               + Request.Form("idUnidadProductoM") + "','" _
               + Request.Form("idProvedorProductoM") + "','" _
               + Request.Form("precioMayoreoProductoM") + "','" _
               + Request.Form("precioMenudeoProductoM") + "','" _
               + "','" _
               + Request.Form("cantidadProductoM") + "|" + Request.Form("modeloProductoM") + "|" + Request.Form("colorProductoM") + "|" + Request.Form("tallaProductoM") + "|" + Request.Form("fechaProductoM") + "|" + Request.Form("precioCompraProductoM") + "|" + Request.Form("precioPublicoProductoM") + "','','',3 "
        Response.Write(InstrSQL)
        Try
            retornoInterno = objetoClases.fnExecutaStored(InstrSQL)
            Response.Write("<script>parent.parent.alerta('Registro Modificado con Exito');</script>")
        Catch ex As Exception
            retornoInterno = False
            Response.Write("<script>parent.parent.alerta('" + ex.Message + "');</script>")
        End Try

        If retornoInterno = True Then
            Call fnConsultaProducto(numeroPagina, accion)
        End If

        Return retornoInterno
    End Function

    Public Function fnAgregaProducto(ByVal accion As String, ByVal numeroPagina As String) As Boolean
        Dim retornoBool As Boolean
        Dim totalElementos As String = ""
        Dim sqlConexion As New Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim sqlComando As Data.SqlClient.SqlCommand
        Dim sqlTransaccion As Data.SqlClient.SqlTransaction

        totalElementos = HttpContext.Current.Request.Form("totalProductoM")
        Dim iContador As Integer
        Dim InstrSQL As String = ""
        sqlConexion.Open()
        sqlTransaccion = sqlConexion.BeginTransaction()

        Try
            For iContador = 0 To totalElementos - 1
                InstrSQL = " EXEC [dbo].[spCatalogoSatProducto]  '','" + IdEmpresa + "|" + Request.Form("nombreProductoM") + "|" + variableSession.idUsuarioSession + "'," _
                + "'" + Request.Form("nombreProducto" + iContador.ToString) + "','" _
                + Request.Form("precioProducto" + iContador.ToString) + "','" _
                + Request.Form("idUnidadProducto" + iContador.ToString) + "','" _
                + Request.Form("idProvedorProducto" + iContador.ToString) + "','" _
                + Request.Form("precioMayoreoProducto" + iContador.ToString) + "','" _
                + Request.Form("precioMenudeoProducto" + iContador.ToString) + "','" _
                + "','" _
                + Request.Form("cantidadProducto" + iContador.ToString) + "|" + Request.Form("modeloProducto" + iContador.ToString) + "|" + Request.Form("colorProducto" + iContador.ToString) + "|" + Request.Form("tallaProducto" + iContador.ToString) + "|" + Request.Form("fechaProducto" + iContador.ToString) + "|" + Request.Form("precioCompraProducto" + iContador.ToString) + "|" + Request.Form("precioPublicoProducto" + iContador.ToString) + "','','',1 "

                'Response.Write(InstrSQL)

                sqlComando = New SqlClient.SqlCommand(InstrSQL, sqlConexion)
                sqlComando.Transaction = sqlTransaccion
                sqlComando.ExecuteNonQuery()

            Next

            Response.Write("<script> parent.parent.alerta('Productos Agregados Exitosamente'); </script>")
            Response.Write("<script> parent.fnLimpiaTabla('bodyProductoM','totalProductoM'); </script>")
            Response.Write("<script> parent.fnLimpiaTabla('tablaDatosM','totalElementosM'); </script>")
            retornoBool = True
            sqlTransaccion.Commit()
        Catch ex As Exception
            sqlTransaccion.Rollback()
            retornoBool = False
            Response.Write("<script> parent.parent.alerta('Ocurrio un Error. " + ex.Message + "'); </script>")
        End Try

        retornoBool = fnConsultaProducto("1", accion)

        Return retornoBool
    End Function

    Public Function fnConsultaProducto(ByVal numeroPagina As String, ByVal accion As String) As Boolean
        Dim retornoBool As Boolean
        Dim totalPaginas As String = ""
        Dim tablaProducto As Data.DataView
        Dim InstrSQL As String = ""
        Dim iContador As Integer
        Dim totalRegistrosReal As String = ""
        'fnAgregaTRProducto

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('idPaginador').style.display = 'block'; ")
        Response.Write(" parent.fnLimpiaTabla('tablaDatosM','totalElementosM'); ")
        Response.Write(" parent.document.getElementById('idPaginaM').value = '" + numeroPagina + "'; ")
        Response.Write("</script>")

        'InstrSQL = " EXEC [dbo].[spCatalogoSatProducto]  '','" + IdEmpresa + "','','','','','','','','','" + numeroPagina + "','10',99 "
        'If accion = "buscar" Then
        InstrSQL = " EXEC [dbo].[spCatalogoSatProducto]  '','" + IdEmpresa + "|" + Request.Form("nombreProductoM") + "|" + variableSession.idUsuarioSession + "','','','','','','','','','" + numeroPagina + "','10',99 "
        'End If


        tablaProducto = objetoClases.fnRegresaTabla(InstrSQL, "Paginas")
        totalPaginas = tablaProducto(0)("Paginas").ToString
        totalRegistrosReal = tablaProducto(0)("RegistrosTotales").ToString
        tablaProducto = Nothing
        InstrSQL = Nothing

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('totalRegistroM').innerText = 'Total de Registros : " + totalRegistrosReal + "'; ")
        Response.Write(" parent.document.getElementById('totalPaginas').innerText = 'Pagina numero:" + numeroPagina + " de " + totalPaginas + "'; ")
        Response.Write("</script>")

        'InstrSQL = " EXEC [dbo].[spCatalogoSatProducto]  '','" + IdEmpresa + "','','','','','','','','','" + numeroPagina + "','10', 0 "
        'If accion = "buscar" Then
        InstrSQL = " EXEC [dbo].[spCatalogoSatProducto]  '','" + IdEmpresa + "|" + Request.Form("nombreProductoM") + "','','','','','','','','','" + numeroPagina + "','10', 0 "
        'End If
        Response.Write(InstrSQL)
        tablaProducto = objetoClases.fnRegresaTabla(InstrSQL, "DetalleProducto")
        Dim unidadProducto As String = ""

        If tablaProducto.Count <> 0 Then
            Dim estiloTR As String = ""
            Response.Write("<script>")
            For iContador = 0 To tablaProducto.Count - 1
                estiloTR = "active"
                If tablaProducto(iContador)("CantidadProducto") < 0 Then
                    estiloTR = "warningNew"
                ElseIf tablaProducto(iContador)("CantidadProducto") = 0
                    estiloTR = "infoNew"
                End If

                If tablaProducto(iContador)("UnidadProducto") = "" Then
                    unidadProducto = "Sin Asignar"
                Else
                    unidadProducto = tablaProducto(iContador)("UnidadProducto")
                End If
                Response.Write(" parent.fnAgregaTRProducto('tablaDatosM','" + tablaProducto(iContador)("IdProducto").ToString + "','" + tablaProducto(iContador)("NombreProducto").ToString + "'," _
                + " '" + tablaProducto(iContador)("PrecioProducto").ToString + "','" + tablaProducto(iContador)("IdUnidadProducto").ToString + "','" + unidadProducto + "','0'," _
                + " 'NO APLICA','" + tablaProducto(iContador)("PrecioMayoreo").ToString + "','" + tablaProducto(iContador)("PrecioMenudeo").ToString + "'," _
                + " '" + tablaProducto(iContador)("CantidadProducto").ToString + "' ,'" + tablaProducto(iContador)("ObservacionesProducto").ToString + "','" + tablaProducto(iContador)("ModeloProducto").ToString + "', " _
                + " '" + tablaProducto(iContador)("ColorProducto").ToString + "','" + tablaProducto(iContador)("TallaProducto").ToString + "','" + tablaProducto(iContador)("FechaProducto").ToString + "','" + tablaProducto(iContador)("PrecioCompra").ToString + "','" + estiloTR + "','" + tablaProducto(iContador)("ClaveSAT") + "'); ")

                'PrecioCompra
            Next
            Response.Write("</script>")
        End If

        Return retornoBool
    End Function

End Class