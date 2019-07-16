Imports CryptoSysPKI
Imports System.Net

Public Class consultaFactura
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases
    Public IdEmpresa As String = "ARAD14"
    Public cadenaTitulo As String = "CONSULTA DE FACTURAS"
    Public cadenaPermiso As String = "MENU/CONSULTA FACTURA"
    'Public sessionUsuario As String = idUsuarioSession

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>window.parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")
        Dim accion As String = ""
        Dim retornoCorreo As Boolean
        accion = Request.Form("accion")
        Dim accion2 As String = ""
        accion2 = HttpContext.Current.Request.Form("accion2")
        Dim retornoReporte As String = ""
        Dim numeroFactura As String = ""
        numeroFactura = HttpContext.Current.Request.Form("idFactura")
        If numeroFactura <> "" Then
            numeroFactura = objetoClases.fnRetornaValor(numeroFactura, "--", 1)
        End If

        'Dim IdEmpresa As String = ""
        'IdEmpresa = HttpContext.Current.Request.Form("idEmpresa")
        Dim Reporte As String = ""
        Dim retorno As Boolean
        Dim ClienteWeb As New WebClient()


        If accion = "paginaFactura" Then
            Dim numeroPagina As String = ""
            If Request.Form("idPaginaM") = "0" Then
                numeroPagina = "1"
            Else
                numeroPagina = Request.Form("idPaginaM")
            End If

            Call fnConsultaFactura(numeroPagina, accion)
        End If

        If accion = "factura" Then
            If IdEmpresa = "ARAD14" Then
                Reporte = "../reportes/reciboCFDI3.3.rpt"
            Else
                Reporte = "../reportes/reciboCFDI2.rpt"
            End If
            Dim InstrSQL As String = ""
            Dim InstrSQL2 As String = ""
            InstrSQL2 = "EXEC dbo.spReciboDigitalConcepto '" + HttpContext.Current.Request.Form("idEmpresa") + "','" + HttpContext.Current.Request.Form("idFactura") + "','" + HttpContext.Current.Request.Form("FolioElectronico") + "',1"
            InstrSQL = "EXEC dbo.spReciboDigitalCFDI '" + HttpContext.Current.Request.Form("idEmpresa") + "','" + HttpContext.Current.Request.Form("FolioElectronico") + "','" + HttpContext.Current.Request.Form("idFactura") + "',99"


            retornoReporte = objetoClases.fnGeneraReporte(Reporte, IdEmpresa + numeroFactura, InstrSQL, InstrSQL2)
            'Response.Write(retornoReporte)
            'Response.End()

            HttpContext.Current.Response.Redirect(retornoReporte)
        End If

        If accion2 = "enviarFactura" Then
            retornoCorreo = objetoClases.fnEnviaCorreo(numeroFactura, IdEmpresa)
            If retornoCorreo = True Then
                Response.Write("<script>parent.alerta('Archivos enviados Satisfactoriamente');</script>")
            Else
                Response.Write("<script>parent.alerta('El Cliente no contiene ningun correo capturado');</script>")
            End If
        End If

        If accion2 = "generaXML" Then
            Dim rutaPadre As String = "../../upload/XML/"
            Dim rutaServer As String = HttpContext.Current.Request.Url.AbsoluteUri
            rutaServer = Replace(rutaServer, "Main/facturas/consultaFactura.aspx", "upload/XML/")
            retornoReporte = fnGeneraXML(numeroFactura, IdEmpresa)
            rutaPadre = rutaServer + retornoReporte + ""
            Response.Write("<s" + "cript>parent.download('" + rutaPadre + "','" + retornoReporte + "')</s" + "cript>")

        End If
        If accion2 = "cancelaFactura" Then

            Call fnCancelaFacturaDigital(IdEmpresa, numeroFactura, HttpContext.Current.Request.Form("FolioElectronico"))

        End If

        If accion2 = "EliminaFactura" Then
            Dim InstrSQL As String = ""
            InstrSQL = "EXEC dbo.spEliminaFactura '" + IdEmpresa + "','" + numeroFactura + "','" + HttpContext.Current.Request.Form("FolioElectronico") + "',1"
            retorno = objetoClases.fnExecutaStored(InstrSQL)
            If retorno = True Then
                Response.Write("<script>parent.alerta('Factura eliminada exitosamente');</script>")
            End If
        End If


    End Sub

    Public Function fnGeneraXML(ByVal NumeroFactura As String, ByVal IdEmpresa As String) As String

        Dim retornoXML As String = ""
        Dim SqlConnection As System.Data.SqlClient.SqlConnection
        Dim SqlTransaction As System.Data.SqlClient.SqlTransaction
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim archivoXML As String = ""
        Dim NombreXML As String = ""



        Try
            SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
            SqlConnection.Open()


            SqlTransaction = SqlConnection.BeginTransaction()
            InstrSQL = "EXEC [dbo].[spNombraXML] '" + NumeroFactura + "','" + IdEmpresa + "',0"


            SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)

            SQLCommand.Transaction = SqlTransaction
            DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
            DataAdapter.Fill(DataSet, "NombraXML")
            DataView = DataSet.Tables("NombraXML").DefaultView


            If DataView.Count <> 0 Then
                archivoXML = DataView(0)("PFDigXMLTimbrado")
                NombreXML = DataView(0)("nombreArchivo").ToString
            End If
            SqlConnection.Close()
        Catch ex As Exception

        End Try

        Dim pathPadre As String = "../../upload/XML/"
        Dim archivo As String = NombreXML + ".XML"
        Dim ruta = Server.MapPath(pathPadre + archivo)

        If System.IO.File.Exists(ruta) Then
            Return archivo
            Exit Function
        Else
            Dim streamWriter As System.IO.StreamWriter = System.IO.File.CreateText(ruta)
            streamWriter.WriteLine(archivoXML)
            streamWriter.Close()
            streamWriter = Nothing
        End If

        retornoXML = archivo

        Return retornoXML
    End Function


    Public Function fnCancelaFacturaDigital(ByVal IdEmpresa As String, ByVal NumeroFactura As String, ByVal TipoFolio As String) As Boolean
        Dim mensajeError As String = "El folio fue cancelado exitosamente."
        Dim mensaje As String = ""

        Dim SqlConnection As System.Data.SqlClient.SqlConnection
        Dim SqlTransaction As System.Data.SqlClient.SqlTransaction
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim InstrSQLCancela As String = ""
        Dim idSelloFolio As String = "", TimbreFiscal As String = "", errorCodigo As Boolean = False
        Dim noCertificado As String = ""


        Try
            SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
            SqlConnection.Open()


            SqlTransaction = SqlConnection.BeginTransaction()
            InstrSQL = "EXEC [dbo].[spReciboDigitalCancela] '" + IdEmpresa + "','" + NumeroFactura + "','" + TipoFolio + "',0"


            SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
            SQLCommand.Transaction = SqlTransaction
            DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
            DataAdapter.Fill(DataSet, "ReciboDigitalCancela")
            DataView = DataSet.Tables("ReciboDigitalCancela").DefaultView

            If DataView.Count <> 0 Then
                idSelloFolio = DataView(0)("IdSelloDigital")
                TimbreFiscal = DataView(0)("TimbreFiscal")
            End If

            InstrSQLCancela = "EXEC spCancelaFactura '" + NumeroFactura.ToString + "','" + TipoFolio + "','" + IdEmpresa + "',1"
            objetoClases.fnExecutaStored(InstrSQLCancela)

            If TimbreFiscal <> "0" Then
                InstrSQL = "EXEC [dbo].[spReciboDigitalCancela] '" + IdEmpresa + "','" + NumeroFactura + "','" + TipoFolio + "',2"
                Dim SDigPassword As String = "", usuarioWEBService As String = "", passwordWEBService As String = "", IdTipoFolioElectronico As String = "", RFCUsuario As String = "", UUID(1) As String
                SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
                SQLCommand.Transaction = SqlTransaction
                DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
                DataAdapter.Fill(DataSet, "ReciboDigitalCancela2")
                DataView = DataSet.Tables("ReciboDigitalCancela2").DefaultView

                If DataView.Count <> 0 Then
                    SDigPassword = DataView(0)("Password").ToString
                    usuarioWEBService = DataView(0)("EdicomUsuario").ToString
                    passwordWEBService = DataView(0)("EdicomPassword").ToString
                    RFCUsuario = DataView(0)("RFC").ToString
                    UUID(0) = DataView(0)("TimbreFiscal").ToString
                    noCertificado = ""


                    Dim pathSello As String = Server.MapPath("../../UPLOAD/SelloDigital")
                    Dim pathCER As String = (pathSello + "\" + idSelloFolio + ".cer")
                    Dim pathKEY As String = (pathSello + "\" + idSelloFolio + ".key")

                    Dim newpassword As String = SDigPassword


                    Dim archivoPEM As String = pathSello + "\" + idSelloFolio + ".pfx"
                    Dim nRet As Long


                    Dim fechaFactura As Object, fechaFacturaSAT As String
                    fechaFactura = Now
                    fechaFacturaSAT = objetoClases.fnFormatoFecha(fechaFactura, "ymd").Replace("/", "-") + "T" + objetoClases.fnFormatoFecha(fechaFactura, "time")

                    'fechaFacturaSAT="2013-10-29T12:00:00"

                    Dim XMLCancelacion As String = objetoClases.Create_Cancelacion(fechaFacturaSAT, RFCUsuario, UUID(0), _
        pathCER, pathKEY, SDigPassword)

                    Dim pathPadre As String = "../../UPLOAD/"
                    Dim archivo As String = UUID(0).ToString + ".XML"
                    Dim ruta As String = Server.MapPath(pathPadre + archivo)


                    Dim streamWriter As System.IO.StreamWriter = System.IO.File.CreateText(ruta)
                    streamWriter.WriteLine(XMLCancelacion)
                    streamWriter.Close()
                    streamWriter = Nothing

                    Dim acuse As String
                    Dim codEstatus As String
                    Dim codmensaje As String
                    Dim estatusUUids As String()
                    Dim respuestaVariable As Object

                    Dim serverName As String = Request.ServerVariables("SERVER_NAME").ToUpper
                    Dim claseXpide As timbradoExpide = New timbradoExpide()
                    Dim respuesta As mx.com.expidetufactura.cancelacionProductivo.respuestaCancelacion
                    Dim cancelaRPrueba As mx.com.expidetufactura.timbradoP.respuestaCancelacion

                    'If serverName = "LOCALHOST" Or serverName = "192.168.100.103" Or serverName = "127.0.0.1" Then
                    If 1 = 10 Then
                        claseXpide.usuarioWeb = "pruebas"
                        claseXpide.passwordWeb = "123456"
                        claseXpide.noCerticado = noCertificado
                        claseXpide.UUIDWeb = UUID(0).ToString
                        claseXpide.emisor = RFCUsuario

                        cancelaRPrueba = claseXpide.fnCancelaPrueba()
                        respuestaVariable = cancelaRPrueba
                    Else
                        claseXpide.usuarioWeb = usuarioWEBService
                        claseXpide.passwordWeb = passwordWEBService
                        claseXpide.noCerticado = noCertificado
                        claseXpide.UUIDWeb = UUID(0).ToString
                        claseXpide.emisor = RFCUsuario

                        respuesta = claseXpide.fnCancelaReal(usuarioWEBService, passwordWEBService, objetoClases.fnFileToByteArray(ruta))
                        respuestaVariable = respuesta
                    End If

                    acuse = "exitoso"
                    codEstatus = respuestaVariable.codEstatus
                    codmensaje = respuestaVariable.codMensaje
                    estatusUUids = respuestaVariable.estatusUUIDs

                    If codEstatus.ToString <> "200" Then
                                errorCodigo = True
                                mensajeError = codEstatus + " - " + codmensaje
                            Else
                                InstrSQL = "UPDATE PagoFacturaDigital SET PFDigXMLCancela= @PFDigXMLCancela WHERE PFDigIdFactura = " + NumeroFactura + "  AND PFDigIdEmpresa = '" + IdEmpresa + "'"
                                SQLCommand = New SqlClient.SqlCommand("SELECT * FROM PagoFacturaDigital WHERE PFDigIdFactura = " + NumeroFactura + " AND PFDigIdEmpresa = '" + IdEmpresa + "'", SqlConnection)
                                SQLCommand.Transaction = SqlTransaction
                                DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
                                DataAdapter.Fill(DataSet, "PagoFacturaDigital")
                                Dim dt As System.Data.DataTable = DataSet.Tables("PagoFacturaDigital")
                                dt.Rows(0)("PFDigXMLCancela") = acuse.ToString
                                SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
                                SQLCommand.Transaction = SqlTransaction
                                SQLCommand.Parameters.Add("@PFDigXMLCancela", SqlDbType.Text, 80000, "PFDigXMLCancela")
                                DataAdapter.UpdateCommand = SQLCommand
                                DataAdapter.Update(DataSet, "PagoFacturaDigital")

                            End If
                        End If

                    End If

            If errorCodigo = False Then
                SqlTransaction.Commit()
                mensajeError = ""
                mensaje = "La Factura numero: " + NumeroFactura.ToString + " se cancelo con éxito."
                Response.Write("<s" + "cript>parent.alerta('" + mensaje + "')</s" + "cript>")

                Call fnConsultaFactura(Request.Form("idPaginaM"), "paginaFactura")

            Else
                SqlTransaction.Rollback()
                mensajeError = mensajeError
            End If


        Catch ex As Exception
            SqlTransaction.Rollback()
            mensajeError = ex.Message.Replace("'", "\'")
            mensajeError = mensajeError
        End Try
        SqlConnection.Close()
        If mensajeError <> "" Then Response.Write("<s" + "cript>parent.alerta('" + mensajeError + "')</s" + "cript>")


        fnCancelaFacturaDigital = True

    End Function

    Public Function fnConsultaFactura(ByVal numeroPagina As String, ByVal accion As String) As Boolean


        Dim idEmpresa As String = ""

        Dim totalPaginas As String = ""
        Dim tablaFactura As Data.DataView
        Dim iContador As Integer
        Dim totalRegistrosReal As String = ""
        'fnAgregaTRFactura

        Response.Write("<script>")
        Response.Write(" window.parent.document.getElementById('idPaginador').style.display = 'block'; ")
        Response.Write(" window.parent.fnLimpiaTabla('tablaDatosM','totalElementosM'); ")
        Response.Write(" window.parent.document.getElementById('idPaginaM').value = '" + numeroPagina + "'; ")
        Response.Write("</script>")

        Dim InstrSQL As String = "EXEC [dbo].[spPaginador]'" + Request.Form("fechaInicialM") + "','" + Request.Form("fechaFinalM") + "','" + Request.Form("cadenaCliente") + "','10', '" + numeroPagina + "', '" + idEmpresa + "', 1"

        'Response.Write(InstrSQL)
        'Response.End()

        tablaFactura = objetoClases.fnRegresaTabla(InstrSQL, "Paginas")
        totalPaginas = tablaFactura(0)("numeroPaginas").ToString
        totalRegistrosReal = tablaFactura(0)("totalRegistros").ToString

        Response.Write("<script>")
        Response.Write(" window.parent.document.getElementById('totalRegistroM').innerText = 'Total de Registros : " + totalRegistrosReal + "'; ")
        Response.Write(" window.parent.document.getElementById('totalPaginas').innerText = 'Pagina numero:" + numeroPagina + " de " + totalPaginas + "'; ")
        Response.Write("</script>")

        If tablaFactura.Count <> 0 Then
            Response.Write("<script>")
            For iContador = 0 To tablaFactura.Count - 1

                Response.Write(" window.parent.fnAgregaTRFactura('tablaDatosM','" + tablaFactura(iContador)("NumeroFactura").ToString + "--" + tablaFactura(iContador)("porCobrar").ToString + "','" + tablaFactura(iContador)("IdEmpresa").ToString + "'," _
                + " '" + tablaFactura(iContador)("MontoFactura").ToString + "','" + tablaFactura(iContador)("NombreCliente").ToString + "','" + tablaFactura(iContador)("FechaFactura").ToString + "','" + tablaFactura(iContador)("TipoFolio").ToString + "'," _
                + " '" + tablaFactura(iContador)("EstatusUUID").ToString + "','" + tablaFactura(iContador)("CampoXML").ToString + "','" + tablaFactura(iContador)("porCobrar").ToString + "'); ")

            Next
            Response.Write("</script>")
        End If
        'fnAgregaTRFactura(idTabla, idFactura,idEmpresa,montoFactura, nombreCliente, fechaFactura, tipoFolio, estatusUUID, campoXML) {

        Return True
    End Function
End Class