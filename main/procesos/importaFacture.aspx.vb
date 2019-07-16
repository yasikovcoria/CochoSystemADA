Imports FirebirdSql.Data.FirebirdClient
Public Class importaFacture
    Inherits System.Web.UI.Page
    Dim conexion As New FbConnection
    Dim fbCadeba As FbConnectionStringBuilder = New FbConnectionStringBuilder
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub


    Public Sub conectaFB(ByVal rutaBaseFB As String)
        fbCadeba.ServerType = FbServerType.Default
        fbCadeba.UserID = "sysdba"
        fbCadeba.Password = "masterkey"
        fbCadeba.Dialect = 3
        fbCadeba.Pooling = False
        Try
            conexion.ConnectionString = fbCadeba.ToString
            conexion.Open()
            If conexion.State = ConnectionState.Open Then
                Response.Write("<script> alert('Conexion con la base Exitosa.'); </script>")
            End If
        Catch ex As FbException
            Response.Write("<script> alert('Ocurrio un error al abrir la base. " + ex.Message + "'); </script>")
        End Try
    End Sub
End Class