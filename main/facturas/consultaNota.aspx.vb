Imports System.Data.Common
Imports CRAXDDRT

Public Class consultaNota
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases
    Public cadenaTitulo As String = "CONSULTA NOTAS DE VENTA"
    Public IdEmpresa As String = "ARAD14"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
        Dim accion As String = ""
        accion = Request.Form("accion")

        If accion = "NotaRemision" Then
            Call fnRPTNotaRemision()
        End If

        If accion = "paginaNotaRemision" Then
            Dim numeroPagina As String = ""
            If Request.Form("idPaginaM") = "0" Then
                numeroPagina = "1"
            Else
                numeroPagina = Request.Form("idPaginaM")
            End If

            Call fnConsultaNotaRemision(numeroPagina, accion)
        End If

        If accion = "cancelaNotaRemision" Then
            Call fnCancelaNota()
        End If

    End Sub

    Public Function fnRPTNotaRemision() As Boolean
        Dim InstrSQL As String = "EXEC [dbo].[spReciboNotaRemision]'" + Request.Form("idNotaRemision") + "', '" + IdEmpresa + "', 1"
        Dim retornoNota As String = ""
        'Reporte = "../reportes/reciboCFDI.rpt"
        retornoNota = objetoClases.fnGeneraNotaRemision("../reportes/notaRemision.rpt", Request.Form("idNotaRemision") + IdEmpresa, InstrSQL)
        Response.Write(retornoNota)
        'Response.End()

        Response.Redirect(retornoNota)

        Return True
    End Function

    Public Function fnCancelaNota() As Boolean
        Dim retornoBool As Boolean
        Dim InstrSQL As String = ""
        'EXEC [dbo].[spCancelaNotaRemision]'2', '70', 'ARAD14', 1
        'InstrSQL = "EXEC [dbo].[spCancelaNotaRemision]'" + Request.Form("idNotaRemision") + "', '" + Request.Form("FolioElectronico") + "', '" + IdEmpresa + "', 1"
        'objetoClases.fnExecutaStored(InstrSQL)

        InstrSQL = ""
        InstrSQL = "EXEC [dbo].[spActualizaAlmacen]'" + Request.Form("idNotaRemision") + "', '" + IdEmpresa + "|" + variableSession.idUsuarioSession + "', 2"
        Response.Write(InstrSQL)
        objetoClases.fnExecutaStored(InstrSQL)

        Dim mensaje As String = ""
        mensaje = "La Nota se Cancelo con exito"
        Response.Write("<s" + "cript>alert('" + mensaje + "')</s" + "cript>")
        'Response.Write("<script> ")
        'Response.Write(" parent.fnImprimeRecibo('" + IdEmpresa + "','" + Request.Form("numeroReciboM") + "','" + Request.Form("tipoFolioM") + "'); ")
        'Response.Write(" parent.fnLimpiaTabla('bodyCotizacionM','totalCotizacionM');")
        'Response.Write(" parent.fnLimpiaCotizacion(); ")
        'Response.Write(" </script>")

        Call fnConsultaNotaRemision(Request.Form("idPaginaM"), "consulta")

        Return retornoBool
    End Function

    Public Function fnConsultaNotaRemision(ByVal numeroPagina As String, ByVal accion As String) As Boolean


        Dim idEmpresa As String = ""

        Dim totalPaginas As String = ""
        Dim tablaNotaRemision As Data.DataView
        Dim iContador As Integer
        Dim totalRegistrosReal As String = ""
        'fnAgregaTRNotaRemision

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('idPaginador').style.display = 'block'; ")
        Response.Write(" parent.fnLimpiaTabla('tablaDatosM','totalElementosM'); ")
        Response.Write(" parent.document.getElementById('idPaginaM').value = '" + numeroPagina + "'; ")
        Response.Write("</script>")

        Dim InstrSQL As String = "EXEC [dbo].[spNotaRemision] '','" + Request.Form("IdEmpresaM") + "','','','','','','','','','','','','','','10|" + Request.Form("fechaInicialM") + "|" + Request.Form("fechaFinalM") + "','" + numeroPagina + "',99"

        Response.Write(InstrSQL)
        'Response.End()

        tablaNotaRemision = objetoClases.fnRegresaTabla(InstrSQL, "Paginas")
        totalPaginas = tablaNotaRemision(0)("numeroPaginas").ToString
        totalRegistrosReal = tablaNotaRemision(0)("totalRegistros").ToString

        Response.Write("<script>")
        Response.Write(" parent.document.getElementById('totalRegistroM').innerText = 'Total de Registros : " + totalRegistrosReal + "'; ")
        Response.Write(" parent.document.getElementById('totalPaginas').innerText = 'Pagina numero:" + numeroPagina + " de " + totalPaginas + "'; ")
        Response.Write("</script>")

        If tablaNotaRemision.Count <> 0 Then
            Response.Write("<script>")
            For iContador = 0 To tablaNotaRemision.Count - 1

                Response.Write(" parent.fnAgregaTRNotaRemision('tablaDatosM','" + tablaNotaRemision(iContador)("NumeroNotaRemision").ToString + "','" + tablaNotaRemision(iContador)("IdEmpresa").ToString + "'," _
                + " '" + tablaNotaRemision(iContador)("MontoNotaRemision").ToString + "','" + tablaNotaRemision(iContador)("NombreCliente").ToString + "','" + tablaNotaRemision(iContador)("FechaNotaRemision").ToString + "','" + tablaNotaRemision(iContador)("notaCancelada").ToString + "'); ")

            Next
            Response.Write("</script>")
        End If
        'fnAgregaTRNotaRemision(idTabla, idNotaRemision, idEmpresa, montoNotaRemision, nombreCliente, fechaNotaRemision, tipoFolio, estatus) {
        'fnAgregaTRNotaRemision(idTabla, idNotaRemision,idEmpresa,montoNotaRemision, nombreCliente, fechaNotaRemision, tipoFolio, estatusUUID, campoXML) {

        Return True
    End Function

End Class