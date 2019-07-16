Imports System.IO

Public Class descargaArchivo
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Request.Form("rutaArchivo") <> "" Then


            Dim file As FileInfo = New FileInfo(Server.MapPath(Request.Form("rutaArchivo")))
            Response.Clear()
            Response.ClearHeaders()
            Response.ClearContent()
            Response.AddHeader("Content-Disposition", "attachment; filename=" + file.Name)
            Response.AddHeader("Content-Length", file.Length.ToString())
            Response.ContentType = "text/plain"
            Response.Flush()
            Response.TransmitFile(file.FullName)
            Response.End()
        End If
    End Sub

End Class