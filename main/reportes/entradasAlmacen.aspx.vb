Public Class entradasAlmacen


    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases
    Public objetoReporte As reporteServer = New reporteServer
    Public rutaTEM As String = Server.MapPath("../../UPLOAD/TEMP/")
    Public cadenaTitulo As String = "REPORTE DE ENTRADAS X FECHA"
    Public IdEmpresa As String = "ARAD14"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
        Dim accion As String = HttpContext.Current.Request.Form("accion")

        If accion = "Buscar" Then
            Call fnConsultaEntrada("1", accion)
        End If

        If accion = "paginaProducto" Then
            Dim numeroPagina As String = ""
            If Request.Form("idPaginaM") = "0" Then
                numeroPagina = "1"
            Else
                numeroPagina = Request.Form("idPaginaM")
            End If

            Call fnConsultaEntrada(numeroPagina, accion)
        End If
        If accion = "generaReporte" Then
            Call fnGeneraReporte()
        End If
        If accion = "imprimeRecibo" Then
            Call fnImprimeRecibo()
        End If
    End Sub


    Public Function fnGeneraReporte() As Boolean


        Dim fecha As Date = Date.Now()
        Dim nombreArchivo As String = ("entradasAlmacen" + Second(fecha).ToString + "-" + Minute(fecha).ToString + "-" + Hour(fecha).ToString + ".pdf")
        objetoReporte.rutaReproteRPT = Server.MapPath("archivosRPT/" + Request.Form("nombreRPT"))

        objetoReporte.rutaPDFTemp = rutaTEM + "" + nombreArchivo

        Dim InstrSQL As String = ""
        InstrSQL = " EXEC [dbo].[spConsultaEntrada] '" + Request.Form("cadenaConsultaM") + "', '" + IdEmpresa + "', '0', '0', 999"
        'Response.Write(InstrSQL)
        'Response.End()

        Dim retornoReporte As String = ""
        retornoReporte = objetoReporte.fnCreaReporte(InstrSQL)
        Response.Write("<script> parent.fnImprimeRecibo('" + Replace("" + nombreArchivo, "/", "//") + "'); </script>")
        System.Threading.Thread.Sleep(2000)
        Return True
    End Function

    Public Function fnImprimeRecibo() As Boolean
        Response.Redirect(Request.Form("rutaRecibo"))
        Return True
    End Function


    Public Function fnConsultaEntrada(ByVal numeroPagina As String, ByVal accion As String) As Boolean
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

        InstrSQL = " EXEC [dbo].[spConsultaEntrada] '" + Request.Form("cadenaConsultaM") + "', '" + IdEmpresa + "', '" + numeroPagina + "', '10', 99"


        tablaProducto = objetoClases.fnRegresaTabla(InstrSQL, "Paginas")
        totalPaginas = tablaProducto(0)("Paginas").ToString
        totalRegistrosReal = tablaProducto(0)("RegistrosTotales").ToString
        tablaProducto = Nothing
        InstrSQL = Nothing

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('totalRegistroM').innerText = 'Total de Registros : " + totalRegistrosReal + "'; ")
        Response.Write(" parent.document.getElementById('totalPaginas').innerText = 'Pagina numero:" + numeroPagina + " de " + totalPaginas + "'; ")
        Response.Write("</script>")

        InstrSQL = " EXEC [dbo].[spConsultaEntrada] '" + Request.Form("cadenaConsultaM") + "', '" + IdEmpresa + "', '" + numeroPagina + "', '10', 0"

        tablaProducto = objetoClases.fnRegresaTabla(InstrSQL, "DetalleProducto")
        If tablaProducto.Count <> 0 Then
            Dim estiloTR As String = ""
            Response.Write("<script>")
            For iContador = 0 To tablaProducto.Count - 1
                estiloTR = "infoNew"
                If tablaProducto(iContador)("Existencia") < 0 Then
                    estiloTR = "warningNew"
                ElseIf tablaProducto(iContador)("Existencia") = 0
                    estiloTR = "infoNew"
                End If
                ' fnAgregaTREntrada(idTabla, nombreProducto, unidad, fechaIngreso, precioAnterior, precioActual, cantidadAgregada, existencia,EstiloTR)
                Response.Write(" parent.fnAgregaTREntrada('tablaDatosM','" + tablaProducto(iContador)("Producto").ToString + "','" + tablaProducto(iContador)("Unidad").ToString + "'," _
                + " '" + tablaProducto(iContador)("FechaIngreso").ToString + "','" + tablaProducto(iContador)("PrecioAnterior").ToString + "','" + tablaProducto(iContador)("PrecioActual").ToString + "','" + tablaProducto(iContador)("CantidadAgregada").ToString + "'," _
                + " '" + tablaProducto(iContador)("Existencia").ToString + "','" + estiloTR + "'); ")

                'PrecioCompra
            Next
            Response.Write("</script>")
        End If

        Return retornoBool
    End Function

End Class