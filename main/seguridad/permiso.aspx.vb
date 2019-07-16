Public Class permiso
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases()
    Public IdEmpresa As String = "ARAD14"
    Public cadenaTitulo As String = "PERMISOS USUARIO"
    Public IntrSQL As String = ""
    Public retornoBool As Boolean

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
        Dim accion As String = Request.Form("accion")
        If accion = "agregaPermiso" Then Call fnAgregarPermiso()
        If accion = "modificaPermiso" Then Call fnModificaPermiso()
        If accion = "eliminaPermiso" Then Call fnEliminar()


    End Sub

    Public Function fnAgregarPermiso() As Boolean
        IntrSQL = " EXEC [dbo].[spPermisoModulo] '" + IdEmpresa + "','', '" + Request.Form("idModuloPermisoM") + "', '" + Request.Form("idUsuarioPermisoM") + "', '" + Request.Form("modificarPermisoM") + "', '" + Request.Form("consultarPermisoM") + "', '" + Request.Form("agregarPermisoM") + "', '" + Request.Form("eliminarPermisoM") + "','', '10', 1 "
        Try
            retornoBool = objetoClases.fnExecutaStored(IntrSQL)
            Response.Write("<script>alert('Registro Permiso Asignado');</script>")
        Catch ex As Exception
            Response.Write("<script>alert('" + ex.Message + "');</script>")
            Return False
            Exit Function
        End Try

        Return True
    End Function

    Public Function fnEliminar()
        IntrSQL = " EXEC [dbo].[spPermisoModulo] '" + IdEmpresa + "','" + Request.Form("idPermisoModuloM") + "', '" + Request.Form("idModuloPermisoM") + "', '" + Request.Form("idUsuarioPermisoM") + "', '" + Request.Form("modificarPermisoM") + "', '" + Request.Form("consultarPermisoM") + "', '" + Request.Form("agregarPermisoM") + "', '" + Request.Form("eliminarPermisoM") + "','', '10', 2 "
        Try
            retornoBool = objetoClases.fnExecutaStored(IntrSQL)
            Response.Write("<script>alert('El Registro se Elimino con Exito');</script>")
        Catch ex As Exception
            Response.Write("<script>alert('" + ex.Message + "');</script>")
            Return False
            Exit Function
        End Try
        Return True
    End Function

    Public Function fnModificaPermiso()
        IntrSQL = " EXEC [dbo].[spPermisoModulo] '" + IdEmpresa + "','" + Request.Form("idPermisoModuloM") + "', '" + Request.Form("idModuloPermisoM") + "', '" + Request.Form("idUsuarioPermisoM") + "', '" + Request.Form("modificarPermisoM") + "', '" + Request.Form("consultarPermisoM") + "', '" + Request.Form("agregarPermisoM") + "', '" + Request.Form("eliminarPermisoM") + "','', '10', 3 "
        Try
            retornoBool = objetoClases.fnExecutaStored(IntrSQL)
            Response.Write("<script>alert('El Registro se Modifico con Exito');</script>")
        Catch ex As Exception
            Response.Write("<script>alert('" + ex.Message + "');</script>")
            Return False
            Exit Function
        End Try
        Return True
    End Function

End Class