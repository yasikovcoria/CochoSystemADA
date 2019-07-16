Imports System.Web.UI.HtmlControls
Imports System.Data
Imports System.Data.SqlClient

Public Class login
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Variables de Logeo
        Dim usuario As String = HttpContext.Current.Request("usuario")
        Dim password As String = HttpContext.Current.Request("password")
        Dim accion As String = HttpContext.Current.Request("accion")
        Dim retorno As Boolean
        'Variables de Acceso a la base de datos


        If accion = "salir" Then
            retorno = fnSalir()
            If retorno = True Then
                variableSession.idUsuarioSession = ""
                variableSession.IdEmpresaSesion = ""
                Session.Abandon()
                variableSession.sessionValida = False
                Response.Redirect("index.aspx")
            End If
        End If

        If usuario <> "" And password <> "" Then
            retorno = fnLogeo(usuario, password)
            If retorno = True Then
                idUsuarioSession = Session("IdUsuario").ToString
                variableSession.sessionValida = True

                Response.Redirect("Main/inicio.aspx")

            Else
                Response.Redirect("index.aspx?error=1")
            End If
        End If

    End Sub
    Public Function fnSalir() As Boolean



        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim retorno As Boolean
        Dim SessionId As String = System.Web.HttpContext.Current.Session.SessionID
        Dim IdUsuario As String = System.Web.HttpContext.Current.Session("IdUsuario")

        Try

            SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())

            SqlConnection.Open()
            InstrSQL = "EXEC spGuardaSession '" + IdUsuario + "',' 0 ','" + SessionId + "',3"

            'Response.Write(InstrSQL)
            'Response.End()

            SQLCommand = New SqlCommand(InstrSQL, SqlConnection)
            SQLCommand.ExecuteNonQuery()
            SqlConnection.Close()
            Session.Abandon()
            Session.Clear()

            retorno = True


        Catch ex As Exception
            retorno = False
        End Try

        Return retorno

    End Function

    Public Function fnLogeo(ByVal usuario As String, ByVal password As String) As Boolean
        Dim mensaje As String = ""
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim SqlTransaction As System.Data.SqlClient.SqlTransaction
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim errorCodigo As Boolean = False
        Dim idUsuario As Integer
        Dim nombreUsuario As String
        Dim SessionActiva As Integer
        Dim CadenaSession As String
        Dim retorno As Boolean

        Try


            SqlConnection.Open()
            SqlTransaction = SqlConnection.BeginTransaction()
            InstrSQL = "EXEC spLogeoUsuario '" + usuario + "','" + password + "',0"

            SQLCommand = New SqlCommand(InstrSQL, SqlConnection)
            SQLCommand.Transaction = SqlTransaction
            DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)

            DataAdapter.Fill(DataSet, "Usuario")
            DataView = DataSet.Tables("Usuario").DefaultView

            If DataView.Count <> 0 Then


                idUsuario = DataView(0)("IdUsuario")
                variableSession.idUsuarioSession = DataView(0)("IdUsuario").ToString

                nombreUsuario = DataView(0)("NombreUsuario")

                SessionActiva = DataView(0)("Activo")

                Session("usuario") = True
                Session.Add("IdUsuario", idUsuario)
                Session.Add("NombreUsuario", nombreUsuario)
                Session.Timeout = 10000
                CadenaSession = System.Web.HttpContext.Current.Session.SessionID


                retorno = fnGuardaSession(idUsuario, SessionActiva, CadenaSession)
                retorno = True

                'Response.Write("<script> alert('Bienvenido \n " + nombreUsuario + "'); </script>")
            End If

        Catch ex As Exception
            retorno = False
            SqlTransaction.Rollback()

        End Try



        Return retorno
    End Function

    Public Function fnGuardaSession(ByVal idUsuario As String, SessionActiva As String, CadenaSession As String) As Boolean

        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim retorno As Boolean

        Try
            SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
            SqlConnection.Open()
            InstrSQL = "EXEC spGuardaSession '" + idUsuario + "','" + SessionActiva + "','" + CadenaSession + "',1"
            SQLCommand = New SqlCommand(InstrSQL, SqlConnection)
            SQLCommand.ExecuteNonQuery()
            SqlConnection.Close()
            retorno = True


        Catch ex As Exception
            retorno = False
        End Try

        Return retorno
    End Function

    Public Function cadenaDB() As String
        Dim passwordDB As String = "Compromis0"
        Dim userDB As String = "sa"
        Dim aplicacionDB As String = "FacturacionCFDI"
        Dim servidorDB As String = "(local)"
        Dim VariableCadenaDB As String = "Server=" + servidorDB + ";DATABASE=" + aplicacionDB + ";UID=" + userDB + ";PWD=" + passwordDB + ";"

        Return VariableCadenaDB
    End Function

End Class