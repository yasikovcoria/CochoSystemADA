Public Class salidasAlmacen
    Inherits System.Web.UI.Page
    Public objetoReporte As reporteServer = New reporteServer
    Public rutaTEM As String = Server.MapPath("../../UPLOAD/TEMP/")
    Public cadenaTitulo As String = "SALIDAS DEL ALMACEN"
    Public IdEmpresa As String = "ARAD14"
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
    End Sub

End Class