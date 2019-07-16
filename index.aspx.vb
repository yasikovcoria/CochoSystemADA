Public Class index
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim errorTexto As String = ""
        errorTexto = HttpContext.Current.Request("error")
        If errorTexto = "1" Then
            Response.Write("<script>alert('Usuario o Contraseña invalidos');</script>")
        End If

    End Sub

End Class