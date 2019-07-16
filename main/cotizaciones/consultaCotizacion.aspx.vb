Public Class consultaCotizacion
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases()
    Public cadenaTitulo As String = "CONSULTA DE COTIZACIONES"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
        Dim accion As String = ""
        accion = Request.Form("accion")
        Dim numeroPagina As String = ""
        If accion = "consultaCotizacion" Then
            If Request.Form("idPaginaM") = "0" Then
                numeroPagina = "1"
            Else
                numeroPagina = Request.Form("idPaginaM")
            End If

            Call fnConsultaCotizacion(numeroPagina, accion)

        End If

        If accion = "imprimeCot" Then
            Call fnImprimeCotizacion(Request.Form("numeroCot"), accion)

        End If

    End Sub

    Function fnImprimeCotizacion(ByVal numeroCotizacion As String, ByVal accion As String) As Boolean
        Dim retornoBool As Boolean
        Dim retornoCot As String = ""
        Dim InstrSQL As String = ""
        Dim tipoFolio As String = ""
        If Request.Form("IdEmpresaM") = "ARAD14" Then
            tipoFolio = "100"
        Else
            tipoFolio = "101"
        End If
        InstrSQL = " EXEC dbo.spCotizacionDetalle '" + Request.Form("IdEmpresaM") + "','" + numeroCotizacion + "','" + tipoFolio + "',1 "



        retornoCot = objetoClases.fnGeneraReporteSimpleCot("../reportes/cotizacionDetalle.rpt", objetoClases.fnFormatoFecha(Date.Now(), "dmletray"), InstrSQL)
        HttpContext.Current.Response.Redirect(retornoCot)
        Return retornoBool
    End Function

    Function fnConsultaCotizacion(ByVal numeroPagina As String, ByVal accion As String) As Boolean
        Dim retornoBool As Boolean
        Dim totalPaginas As String = ""
        Dim tablaCotizacion As Data.DataView
        Dim InstrSQL As String = ""
        Dim iContador As Integer
        Dim totalRegistrosReal As String = ""
        'fnAgregaTRProducto

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('idPaginador').style.display = 'block'; ")
        Response.Write(" parent.fnLimpiaTabla('tablaDatosM','totalElementosM'); ")
        Response.Write(" parent.document.getElementById('idPaginaM').value = '" + numeroPagina + "'; ")
        Response.Write("</script>")

       
        InstrSQL = " EXEC [dbo].[spPaginadorCotizacion] '10','" + numeroPagina + "','" + Request.Form("IdEmpresaM") + "',2 "
        tablaCotizacion = objetoClases.fnRegresaTabla(InstrSQL, "Paginas")
        totalPaginas = tablaCotizacion(0)("Paginas").ToString
        totalRegistrosReal = tablaCotizacion(0)("RegistrosTotales").ToString
        tablaCotizacion = Nothing
        InstrSQL = Nothing

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('totalRegistroM').innerText = 'Total de Registros : " + totalRegistrosReal + "'; ")
        Response.Write(" parent.document.getElementById('totalPaginas').innerText = 'Pagina numero:" + numeroPagina + " de " + totalPaginas + "'; ")
        Response.Write("</script>")

        InstrSQL = " EXEC [dbo].[spPaginadorCotizacion] '10','" + numeroPagina + "','" + Request.Form("IdEmpresaM") + "',1 "
        'Response.Write(InstrSQL)
        'Response.End()

        tablaCotizacion = objetoClases.fnRegresaTabla(InstrSQL, "DetalleCotizacion")
        If tablaCotizacion.Count <> 0 Then
            Response.Write("<script>")
            For iContador = 0 To tablaCotizacion.Count - 1
                Response.Write(" parent.fnAgregaTRCotizacion('tablaDatosM','" + tablaCotizacion(iContador)("CotIdCotizacion").ToString + "','" + tablaCotizacion(iContador)("NombreCliente").ToString + "','" + tablaCotizacion(iContador)("MontoCotizacion").ToString + "','" + tablaCotizacion(iContador)("FechaCotizacion").ToString + "','" + tablaCotizacion(iContador)("CotIdEmpresa").ToString + "'); ")
            Next
            Response.Write("</script>")
        End If

        Return retornoBool
    End Function


End Class