Imports System.IO
Public Class cotizacion
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases
    Public mensajeError As String = ""
    Public IdEmpresa As String = ""
    Public cadenaTitulo As String = "EMISION DE COTIZACIONES / NOTAS DE VENTA"
    Public InstrSQLConsecutivo As String = ""

    Public Function fnCargaConsecutivo() As Boolean
        InstrSQLConsecutivo = "SELECT dbo.fnConsecutivoCotizacion(" + Request.Form("tipoFolioM") + ") as NumeroRecibo"
        Dim consecutivo As DataView
        consecutivo = objetoClases.fnRegresaTabla(InstrSQLConsecutivo, "Consecutivo")
        If consecutivo.Count <> 0 Then
            Response.Write("<script>")
            Response.Write(" parent.document.getElementById('numeroReciboM').value = '" + consecutivo(0)("NumeroRecibo").ToString + "'; ")
            Response.Write("</script>")
        End If
        Return True
    End Function

    Sub fnImprimeTicke()

    End Sub
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
        Dim tipoFolio As String = ""
        Dim retorno As String = ""
        Dim accion As String = Request.Form("accion")
        Dim totalElemento As String = Request.Form("totalCotizacionM")

        tipoFolio = Request.Form("tipoFolioM")
        If tipoFolio = "2" Then
            IdEmpresa = "ARAD14"
        ElseIf tipoFolio = "3" Then
            IdEmpresa = "ARAD14"
        Else
            IdEmpresa = "ARAD14"
        End If
        If accion = "generaCotizacion" Then

            If Request.Form("tipoFolioM") = "70" Then
                Call fnGuardaNotaRemision(totalElemento)
            Else
                retorno = fnIngresaCotizacion(totalElemento)
            End If

        End If
        If accion = "Cotizacion" Then
            Call fnAbreCot()
        End If

        If accion = "consecutivoRecibo" Then
            Call fnCargaConsecutivo()
        End If

    End Sub


    Public Function fnAbreCot() As Boolean
        Dim retornoCotizacion As String = ""
        Dim InstrSQLReport As String = ""

        Dim InstrSQL As String = "EXEC [dbo].[spReciboNotaRemision]'" + HttpContext.Current.Request.Form("numeroReciboM") + "', '" + IdEmpresa + "', 1"
        InstrSQLReport = " EXEC dbo.spCotizacionDetalle '" + IdEmpresa + "','" + HttpContext.Current.Request.Form("numeroReciboM") + "','" + HttpContext.Current.Request.Form("tipoFolioM") + "',1 "

        If Request.Form("tipoFolioM") = "70" Then
            retornoCotizacion = objetoClases.fnGeneraNotaRemision("../reportes/notaRemision.rpt", Request.Form("idNotaRemision") + IdEmpresa, InstrSQL)
        Else
            retornoCotizacion = objetoClases.fnGeneraReporteSimpleCot("../reportes/cotizacionDetalle.rpt", objetoClases.fnFormatoFecha(Date.Now(), "dmletray"), InstrSQLReport)
        End If

        HttpContext.Current.Response.Redirect(retornoCotizacion)
        Return True
    End Function

    Public Function fnGuardaNotaRemision(ByVal totalElemento As String) As Boolean
        Dim retornoBool As Boolean
        Dim i As Integer = 0
        Dim SqlConnection As System.Data.SqlClient.SqlConnection
        Dim SqlTransaction As System.Data.SqlClient.SqlTransaction
        Dim SQLCommand As System.Data.SqlClient.SqlCommand




        Dim InstrSQL As String = ""
        Dim errorCodigo As Boolean = False
        Dim mensajeError As String = ""
        Dim mensaje As String = ""


        Dim InstrSQLReport As String = ""

        If totalElemento <> "" Then
            Try
                SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
                SqlConnection.Open()
                SqlTransaction = SqlConnection.BeginTransaction()

                For iContador = 0 To Integer.Parse(totalElemento) - 1
                    InstrSQL = "EXEC [dbo].[spNotaRemision] '" + HttpContext.Current.Request.Form("numeroReciboM") + "','" + IdEmpresa + "','" + Request.Form("cantidadCotizacion" + iContador.ToString) + "','" + Request.Form("idUnidadCotizacion" + iContador.ToString) + "','" + Request.Form("descripcionCotizacion" + iContador.ToString) + "','" + Request.Form("precioCotizacion" + iContador.ToString) + "','" + Request.Form("importeCotizacion" + iContador.ToString) + "','" + Request.Form("ivaM") + "','" + Request.Form("totalFacM") + "','" + Request.Form("tipoFolioM") + "','" + Request.Form("subTotalM") + "','" + Request.Form("clienteM") + "|" + Request.Form("idClienteM") + "','" + Request.Form("ivaRetM") + "','" + Request.Form("isrRetM") + "','" + Request.Form("idProductoCotizacion" + iContador.ToString) + "','','',1"
                    SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
                    SQLCommand.Transaction = SqlTransaction
                    SQLCommand.ExecuteNonQuery()
                    Response.Write("<BR>" + InstrSQL)
                Next

                SqlTransaction.Commit()

                Dim InstrSQL2 As String = "EXEC [dbo].[spActualizaAlmacen]'" + Request.Form("numeroReciboM") + "', '" + IdEmpresa + "', 1"
                objetoClases.fnExecutaStored(InstrSQL2)

                mensajeError = ""
                mensaje = "La Cotizacion se genero con exito"
                If HttpContext.Current.Request.Form("tipoFolioM") = "70" Then
                    mensaje = "Nota de Remision Generada"
                End If


                Response.Write("<s" + "cript>alert('" + mensaje + "')</s" + "cript>")
                Response.Write("<script> ")
                Response.Write(" parent.fnImprimeRecibo('" + IdEmpresa + "','" + Request.Form("numeroReciboM") + "','" + Request.Form("tipoFolioM") + "'); ")
                Response.Write(" parent.fnLimpiaTabla('bodyCotizacionM','totalCotizacionM');")
                Response.Write(" parent.fnLimpiaCotizacion(); ")
                Response.Write(" </script>")
                SqlConnection.Close()

            Catch ex As Exception
                SqlTransaction.Rollback()
                mensajeError = ex.Message.Replace("'", "\'")
                mensajeError = mensajeError
                Response.Write("<s" + "cript>alert('" + mensajeError + "')</s" + "cript>")
                SqlConnection.Close()
            End Try


        End If

        Return retornoBool
    End Function

    Public Function fnIngresaCotizacion(ByVal totalElemento As String) As String

        Dim i As Integer = 0
        Dim SqlConnection As System.Data.SqlClient.SqlConnection
        Dim SqlTransaction As System.Data.SqlClient.SqlTransaction
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim retornoCotizacion As String = ""



        Dim InstrSQL As String = ""
        Dim errorCodigo As Boolean = False
        Dim mensajeError As String = ""
        Dim mensaje As String = ""


        Dim InstrSQLReport As String = ""
        Dim descripcionCotizacion As String = ""
        If totalElemento <> "" Then
            Try
                SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
                SqlConnection.Open()
                SqlTransaction = SqlConnection.BeginTransaction()

                For iContador = 0 To Integer.Parse(totalElemento) - 1

                    descripcionCotizacion = Request.Form("descripcionCotizacion" + iContador.ToString)
                    If descripcionCotizacion = "" And Request.Form("tipoFolioM") = "2" Then
                        descripcionCotizacion = Request.Form("nombredescripcionCotizacion" + iContador.ToString)
                    End If


                    InstrSQL = "EXEC dbo.spCotizacion '" + HttpContext.Current.Request.Form("numeroReciboM") + "','" + IdEmpresa + "','" + Request.Form("cantidadCotizacion" + iContador.ToString) + "','" + Request.Form("idUnidadCotizacion" + iContador.ToString) + "','" + descripcionCotizacion + "','" + Request.Form("precioCotizacion" + iContador.ToString) + "','" + Request.Form("importeCotizacion" + iContador.ToString) + "','" + Request.Form("ivaM") + "','" + Request.Form("totalFacM") + "','" + Request.Form("tipoFolioM") + "','" + Request.Form("subTotalM") + "','" + Request.Form("clienteM") + "','" + Request.Form("ivaRetM") + "','" + Request.Form("isrRetM") + "','" + Request.Form("ret5M") + "',1"
                    SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
                    SQLCommand.Transaction = SqlTransaction
                    SQLCommand.ExecuteNonQuery()
                    Response.Write("<BR>" + InstrSQL)
                Next


                SqlTransaction.Commit()
                mensajeError = ""
                mensaje = "La Cotizacion se genero con exito"
                Response.Write("<s" + "cript>alert('" + mensaje + "')</s" + "cript>")
                Response.Write("<script> ")
                Response.Write(" parent.fnImprimeRecibo('" + IdEmpresa + "','" + Request.Form("numeroReciboM") + "','" + Request.Form("tipoFolioM") + "'); ")
                Response.Write(" parent.fnLimpiaTabla('bodyCotizacionM','totalCotizacionM');")
                Response.Write(" parent.fnLimpiaCotizacion(); ")
                Response.Write(" </script>")
                SqlConnection.Close()

            Catch ex As Exception
                SqlTransaction.Rollback()
                mensajeError = ex.Message.Replace("'", "\'")
                mensajeError = mensajeError
                Response.Write("<s" + "cript>alert('" + mensajeError + "')</s" + "cript>")
                SqlConnection.Close()
            End Try


        End If

        Return retornoCotizacion
    End Function

End Class