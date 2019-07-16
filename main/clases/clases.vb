Imports System.Data
Imports System.Data.SqlClient
Imports CrystalDecisions.CrystalReports.Engine
Imports CrystalDecisions.Shared
Imports CryptoSysPKI
Imports System.IO
Imports System.Web.Mail
Imports System.Net.Mail
Imports System.Net.Mime

Public Class clases

    Inherits System.Web.UI.Page

    Public idUsuarioGlobal As String = ""
    Public Shared idUsuario As String = ""
    Public rutaUploadXML As String = "../../Upload/XML/"
    Public Function cadenaDB() As String
        Dim passwordDB As String = "Compromis0"
        Dim userDB As String = "sa"
        Dim aplicacionDB As String = "CochoSystemADA"
        Dim servidorDB As String = "(local)"
        Dim VariableCadenaDB As String = "Server=" + servidorDB + ";DATABASE=" + aplicacionDB + ";UID=" + userDB + ";PWD=" + passwordDB + ";"
        Return VariableCadenaDB
    End Function

    Public Function fnDescargaArchivo(ByVal contenidoXML As String, ByVal nombreArchivoXML As String) As String
        Dim rutaArchivoXML As String = ""
        Dim documentoXML As System.Xml.XmlDocument = New System.Xml.XmlDocument()
        Try
            documentoXML.LoadXml(contenidoXML)
            documentoXML.Save(Server.MapPath(rutaUploadXML + nombreArchivoXML))
            rutaArchivoXML = rutaUploadXML + nombreArchivoXML
        Catch ex As Exception
            rutaArchivoXML = ""
        End Try

        Return rutaArchivoXML
    End Function

    Public Function fnRegresaTabla(ByVal InstrSQL As String, ByVal nombreTabla As String) As System.Data.DataView
        Dim mensaje As String = ""
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(cadenaDB())
        Dim SqlTransaction As System.Data.SqlClient.SqlTransaction
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim errorCodigo As Boolean = False

        Try
            SqlConnection.Open()
            SqlTransaction = SqlConnection.BeginTransaction()
            SQLCommand = New SqlCommand(InstrSQL, SqlConnection)
            SQLCommand.Transaction = SqlTransaction
            DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)

            DataAdapter.Fill(DataSet, nombreTabla)
            DataView = DataSet.Tables(nombreTabla).DefaultView
            SqlTransaction.Commit()
            SqlConnection.Close()

        Catch ex As Exception

        End Try

        Return DataView
    End Function

    Function fnEnviaCorreoRetencion(rutaArchivoXML As String, IdEmpresa As String, ByVal clienteRecibo As String, ByVal rutaArchivoPDF As String, ByVal correoCliente As String, ByVal numeroRetencion As String) As Boolean


        Dim smtp As New System.Net.Mail.SmtpClient
        Dim correo As New System.Net.Mail.MailMessage

        Dim cuerpo As String

        Dim archivo As String = ""



        Dim dispositionXML As ContentDisposition = New ContentDisposition
        Dim dispositionPDF As ContentDisposition = New ContentDisposition



        Dim archivoXML As Attachment = New Attachment(rutaArchivoXML, MediaTypeNames.Application.Octet)
        Dim archivoPDF As Attachment = New Attachment(rutaArchivoPDF, MediaTypeNames.Application.Octet)


        dispositionXML.CreationDate = System.IO.File.GetCreationTime(rutaArchivoXML)
        dispositionXML.ModificationDate = System.IO.File.GetLastWriteTime(rutaArchivoXML)
        dispositionXML.ReadDate = System.IO.File.GetLastAccessTime(rutaArchivoXML)

        dispositionPDF.CreationDate = System.IO.File.GetCreationTime(rutaArchivoPDF)
        dispositionPDF.ModificationDate = System.IO.File.GetLastWriteTime(rutaArchivoPDF)
        dispositionPDF.ReadDate = System.IO.File.GetLastAccessTime(rutaArchivoPDF)



        Try

            cuerpo = " <table width=""700"" style=""text-align:justify;color:#006;font-size:18px;""> " _
               + "<tr><td>  " _
               + "<br /> ESTIMADO (A) " + clienteRecibo + " Le envio los archivos correspondientes a el recibo de retenciones : " + numeroRetencion + "" _
               + "</td></tr> " _
               + "<tr><td>  " _
               + "</td></tr> " _
               + "</table> "
            With smtp
                .Port = 587
                .Host = "smtp.gmail.com"
                .UseDefaultCredentials = False
                .Credentials = New System.Net.NetworkCredential("facturasada2014new@gmail.com", "Compromis0")
                .EnableSsl = True
            End With

            With correo
                .From = New System.Net.Mail.MailAddress("facturasada2014new@gmail.com")
                .To.Add(correoCliente)
                .Subject = "C. ARACELI DAMIAN AGUIRRE"
                .Body = cuerpo
                .IsBodyHtml = True
                .Priority = System.Net.Mail.MailPriority.High
                .Attachments.Add(archivoXML)
                .Attachments.Add(archivoPDF)
            End With

            Try

                smtp.Send(correo)
                fnEnviaCorreoRetencion = True

            Catch ex As Exception
                Response.Write("<s" + "cript>parent.parent.alerta('" + ex.InnerException.Message + "')</s" + "cript>")
                Response.Write(ex.InnerException.Message)
                fnEnviaCorreoRetencion = False
            End Try


        Catch ex As Exception
            fnEnviaCorreoRetencion = False

        End Try

        Return fnEnviaCorreoRetencion
    End Function

    Function fnEnviaCorreo(NumeroFactura As String, IdEmpresa As String) As Boolean


        Dim smtp As New System.Net.Mail.SmtpClient
        Dim correo As New System.Net.Mail.MailMessage
        Dim SqlConnection As System.Data.SqlClient.SqlConnection
        Dim SqlTransaction As System.Data.SqlClient.SqlTransaction
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String
        Dim correoCliente As String
        Dim NumFactura As String
        Dim Cliente As String
        Dim cuerpo As String

        Dim archivo As String = ""
        Dim rutaArchivoXML As String = ""
        Dim rutaArchivoPDF As String = ""
        InstrSQL = "EXEC spNombraXML '" + NumeroFactura + "','" + IdEmpresa + "',0"

        SqlConnection = New System.Data.SqlClient.SqlConnection(cadenaDB())
        SqlConnection.Open()
        SqlTransaction = SqlConnection.BeginTransaction()
        SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
        SQLCommand.Transaction = SqlTransaction
        DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "InformacionCliente")
        DataView = DataSet.Tables("InformacionCliente").DefaultView
        Dim dispositionXML As ContentDisposition = New ContentDisposition
        Dim dispositionPDF As ContentDisposition = New ContentDisposition
        Dim retornoString As String = ""


        If DataView.Count <> 0 Then

            Try
                retornoString = fnGeneraXML(fnRetornaValor(NumeroFactura, "--", 1), IdEmpresa)
            Catch ex As Exception
                retornoString = DataView(0)("nombreArchivo").ToString
            End Try


            rutaArchivoXML = Server.MapPath("../../UPLOAD/XML/" + retornoString.ToString + "")
            rutaArchivoPDF = Server.MapPath("../../UPLOAD/PDF/FacturaCFDI" + IdEmpresa + NumeroFactura + ".pdf")

        End If
        Dim archivoXML As Attachment = New Attachment(rutaArchivoXML, MediaTypeNames.Application.Octet)
        Dim archivoPDF As Attachment = New Attachment(rutaArchivoPDF, MediaTypeNames.Application.Octet)


        dispositionXML.CreationDate = System.IO.File.GetCreationTime(rutaArchivoXML)
        dispositionXML.ModificationDate = System.IO.File.GetLastWriteTime(rutaArchivoXML)
        dispositionXML.ReadDate = System.IO.File.GetLastAccessTime(rutaArchivoXML)

        dispositionPDF.CreationDate = System.IO.File.GetCreationTime(rutaArchivoPDF)
        dispositionPDF.ModificationDate = System.IO.File.GetLastWriteTime(rutaArchivoPDF)
        dispositionPDF.ReadDate = System.IO.File.GetLastAccessTime(rutaArchivoPDF)


        InstrSQL = " SELECT CLCorreoElectronico AS Correo " _
                              + " ,PFDigIdFactura as NumeroFactura  " _
                              + " ,UPPER(CLNombre +' '+ CLApePaterno + ' ' + CLApeMaterno) AS NombreCLiente  " _
                              + " FROM Cliente " _
                              + " INNER JOIN PagoFactura ON PFacIdCliente = CLIdUnico " _
                              + " INNER JOIN PagoFacturaDigital ON PFDigIdFactura = PFacIdFactura AND PFacIdEmpresa = PFDigIdEmpresa " _
                              + " WHERE PFDigIdFactura = '" + fnRetornaValor(NumeroFactura, "--", 1) + "' AND PFDigIdEmpresa = '" + IdEmpresa + "' " _
                              + " GROUP BY PFDigIdFactura, CLNombre, CLApePaterno, CLApeMaterno, CLCorreoElectronico"

        Try

            SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
            SQLCommand.Transaction = SqlTransaction
            DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
            DataAdapter.Fill(DataSet, "CorreoEnviar")
            DataView = DataSet.Tables("CorreoEnviar").DefaultView

            correoCliente = DataView(0)("Correo")
            NumFactura = DataView(0)("NumeroFactura")
            Cliente = DataView(0)("NombreCLiente")

            If correoCliente = "" Then
                fnEnviaCorreo = False
                Exit Function
            End If
            cuerpo = " <table width=""700"" style=""text-align:justify;color:#006;font-size:18px;""> " _
               + "<tr><td>  " _
               + "<br /> ESTIMADO (A) " + Cliente + " Le envio los archivos correspondientes a la factura Numero : " + NumeroFactura + "" _
               + "</td></tr> " _
               + "<tr><td>  " _
               + "</td></tr> " _
               + "</table> "
            With smtp
                .Port = 587
                .Host = "smtp.gmail.com"
                .UseDefaultCredentials = False
                .Credentials = New System.Net.NetworkCredential("facturasada2014new@gmail.com", "Compromis0")
                .EnableSsl = True
            End With

            With correo
                .From = New System.Net.Mail.MailAddress("facturasada2014new@gmail.com")
                .To.Add(correoCliente)
                .Subject = "C. ARACELI DAMIAN AGUIRRE"
                .Body = cuerpo
                .IsBodyHtml = True
                .Priority = System.Net.Mail.MailPriority.High
                .Attachments.Add(archivoXML)
                .Attachments.Add(archivoPDF)
            End With

            Try

                smtp.Send(correo)

                fnEnviaCorreo = True
                Response.Write("<s" + "cript>alert(""Noticicacion Enviada Satisfactoriamente"")</s" + "cript>")


            Catch ex As Exception
                Response.Write(ex.InnerException.Message)
                fnEnviaCorreo = False
            End Try


        Catch ex As Exception


        End Try

        Return fnEnviaCorreo
    End Function


    Public Function fnFormatoFecha(ByVal varDate As Object, ByVal varFormato As String) As String
        Dim fnRetorno As String = ""
        If IsDate(varDate) = True Then
            If varFormato.ToLower = "dmy" Then
                Dim datThisDay As Integer = varDate.day
                Dim datThisMonth As Integer = varDate.month
                Dim datThisYear As Integer = varDate.year
                fnRetorno = ("0" + datThisDay.ToString).Substring(datThisDay.ToString.Length - 1, 2) & "/" & ("0" & datThisMonth.ToString.ToString).Substring(datThisMonth.ToString.Length - 1, 2) & "/" & ("0" & datThisYear.ToString.ToString).Substring(datThisYear.ToString.Length - 3, 4)
            End If


            If varFormato.ToLower = "ymd" Then
                Dim datThisDay As Integer = varDate.day
                Dim datThisMonth As Integer = varDate.month
                Dim datThisYear As Integer = varDate.year
                fnRetorno = ("0" & datThisYear.ToString.ToString).Substring(datThisYear.ToString.Length - 3, 4) & "/" & ("0" & datThisMonth.ToString.ToString).Substring(datThisMonth.ToString.Length - 1, 2) & "/" & ("0" + datThisDay.ToString).Substring(datThisDay.ToString.Length - 1, 2)
            End If

            If varFormato.ToLower = "dmletray" Then
                'DIM datThisDay AS Integer= DatePart("d", varDate)
                'DIM datThisMonth AS Integer = DatePart("m", varDate)
                'DIM datThisYear AS Integer = DatePart("yyyy", varDate)
                Dim datThisDay As Integer = varDate.day
                Dim datThisMonth As Integer = varDate.month
                Dim datThisYear As Integer = varDate.year
                Dim datThisMonthText As String = ""
                If datThisMonth = 1 Then
                    datThisMonthText = "Enero"
                ElseIf datThisMonth = 2 Then
                    datThisMonthText = "Febrero"
                ElseIf datThisMonth = 3 Then
                    datThisMonthText = "Marzo"
                ElseIf datThisMonth = 4 Then
                    datThisMonthText = "Abril"
                ElseIf datThisMonth = 5 Then
                    datThisMonthText = "Mayo"
                ElseIf datThisMonth = 6 Then
                    datThisMonthText = "Junio"
                ElseIf datThisMonth = 7 Then
                    datThisMonthText = "Julio"
                ElseIf datThisMonth = 8 Then
                    datThisMonthText = "Agosto"
                ElseIf datThisMonth = 9 Then
                    datThisMonthText = "Septiembre"
                ElseIf datThisMonth = 10 Then
                    datThisMonthText = "Octubre"
                ElseIf datThisMonth = 11 Then
                    datThisMonthText = "Noviembre"
                ElseIf datThisMonth = 12 Then
                    datThisMonthText = "Diciembre"
                End If
                'fnRetorno = RIGHT("0"+CSTR(datThisDay),2) & " de " & datThisMonthText & " de " & RIGHT("0000"+CSTR(datThisYear),4)
                fnRetorno = ("0" + datThisDay.ToString).Substring(datThisDay.ToString.Length - 1, 2) & " de " & datThisMonthText & " de " & ("0" & datThisYear.ToString.ToString).Substring(datThisYear.ToString.Length - 3, 4)
            End If

            If varFormato.ToLower = "time" Then
                Dim datThisDay As Integer = varDate.hour
                Dim datThisMonth As Integer = varDate.minute
                Dim datThisSecond As Integer = varDate.second
                fnRetorno = ("0" & datThisDay.ToString).Substring(datThisDay.ToString.Length - 1, 2) & ":" & ("0" & datThisMonth.ToString.ToString).Substring(datThisMonth.ToString.Length - 1, 2) & ":" & ("0" & datThisSecond.ToString.ToString).Substring(datThisSecond.ToString.Length - 1, 2)
            End If
        End If
        Return (fnRetorno)
    End Function

    Public Function fnExecutaStored(ByVal InstrSQL As String) As Boolean
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(cadenaDB)
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim retorno As Boolean

        Try
            SqlConnection.Open()
            SQLCommand = New SqlCommand(InstrSQL, SqlConnection)
            SQLCommand.ExecuteNonQuery()
            SqlConnection.Close()
            retorno = True

        Catch ex As Exception
            retorno = False
        End Try
        Return True
    End Function

    Public Function fnExecutaStoredCliente(ByVal InstrSQL As String) As String
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(cadenaDB)
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim retorno As String

        Try
            SqlConnection.Open()
            Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)
            DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
            DataAdapter.Fill(DataSet, "tabla")
            DataView = DataSet.Tables("tabla").DefaultView

            If DataView.Count <> 0 Then
                retorno = DataView(0)("idCliente").ToString
            End If
            SqlConnection.Close()


        Catch ex As Exception
            retorno = "error"
        End Try
        Return retorno
    End Function



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
            SqlConnection = New System.Data.SqlClient.SqlConnection(cadenaDB())
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

    Public Function fnGeneraNotaRemision(ByVal ReporteArchivo As String, ByVal mesAnio As String, ByVal InstrSQL As String) As String
        Dim retorno As String = ""

        Dim tablaReporte As DataTable = New DataTable
        Dim daClientes As SqlDataAdapter = New SqlDataAdapter(InstrSQL, cadenaDB())
        daClientes.FillSchema(tablaReporte, SchemaType.Source)
        daClientes.Fill(tablaReporte)


        Dim ruta As String = ""

        Dim crExportOptions As CrystalDecisions.Shared.ExportOptions = New CrystalDecisions.Shared.ExportOptions
        Dim crDiskFileDestinationOptions As CrystalDecisions.Shared.DiskFileDestinationOptions = New CrystalDecisions.Shared.DiskFileDestinationOptions
        Dim rpt As CrystalDecisions.CrystalReports.Engine.ReportDocument = New CrystalDecisions.CrystalReports.Engine.ReportDocument

        ruta = "../../upload/PDF/NotaRemision" + mesAnio + ".pdf"
        With rpt
            .Load(Server.MapPath(ReporteArchivo))
            .DataSourceConnections(0).SetConnection("(local)", "CochoSystemADA", "sa", "Compromis0")
            .SetDataSource(tablaReporte)
            crDiskFileDestinationOptions.DiskFileName = Server.MapPath(ruta)
            With crExportOptions
                .ExportDestinationType = ExportDestinationType.DiskFile
                .ExportFormatType = ExportFormatType.PortableDocFormat
                .DestinationOptions = crDiskFileDestinationOptions
            End With
        End With


        Try
            If System.IO.File.Exists(ruta) = True Then
                retorno = ruta
            Else
                rpt.Export(crExportOptions)
                retorno = ruta
            End If

        Catch ex As Exception
            'Response.Write(ex.Message)
            retorno = ex.Message.ToString
        Finally
            rpt.Close()
        End Try


        Return retorno
    End Function



    Public Function fnGeneraReporteSimple(ByVal ReporteArchivo As String, ByVal mesAnio As String, ByVal InstrSQL As String) As String
        Dim retorno As String = ""

        Dim tablaReporte As DataTable = New DataTable
        Dim daClientes As SqlDataAdapter = New SqlDataAdapter(InstrSQL, cadenaDB())
        daClientes.FillSchema(tablaReporte, SchemaType.Source)
        daClientes.Fill(tablaReporte)

        Dim ruta As String = ""

        Dim crExportOptions As CrystalDecisions.Shared.ExportOptions = New CrystalDecisions.Shared.ExportOptions
        Dim crDiskFileDestinationOptions As CrystalDecisions.Shared.DiskFileDestinationOptions = New CrystalDecisions.Shared.DiskFileDestinationOptions
        Dim rpt As CrystalDecisions.CrystalReports.Engine.ReportDocument = New CrystalDecisions.CrystalReports.Engine.ReportDocument

        ruta = "../../upload/PDF/Factura" + mesAnio + ".pdf"
        With rpt
            .Load(Server.MapPath(ReporteArchivo))
            .DataSourceConnections(0).SetConnection("(local)", "CochoSystemADA", "sa", "Compromis0")
            .SetDataSource(tablaReporte)
            crDiskFileDestinationOptions.DiskFileName = Server.MapPath(ruta)
            With crExportOptions
                .ExportDestinationType = ExportDestinationType.DiskFile
                .ExportFormatType = ExportFormatType.PortableDocFormat
                .DestinationOptions = crDiskFileDestinationOptions
            End With
        End With


        Try
            rpt.Export(crExportOptions)
            retorno = ruta
        Catch ex As Exception
            'Response.Write(ex.Message)
            retorno = ex.Message.ToString
        Finally
            rpt.Close()
        End Try


        Return retorno
    End Function

    Public Function fnGeneraReporteSimpleCot(ByVal ReporteArchivo As String, ByVal mesAnio As String, ByVal InstrSQL As String) As String
        Dim retorno As String = ""

        Dim tablaReporte As DataTable = New DataTable
        Dim daClientes As SqlDataAdapter = New SqlDataAdapter(InstrSQL, cadenaDB())
        daClientes.FillSchema(tablaReporte, SchemaType.Source)
        daClientes.Fill(tablaReporte)


        Dim ruta As String = ""

        Dim crExportOptions As CrystalDecisions.Shared.ExportOptions = New CrystalDecisions.Shared.ExportOptions
        Dim crDiskFileDestinationOptions As CrystalDecisions.Shared.DiskFileDestinationOptions = New CrystalDecisions.Shared.DiskFileDestinationOptions
        Dim rpt As CrystalDecisions.CrystalReports.Engine.ReportDocument = New CrystalDecisions.CrystalReports.Engine.ReportDocument

        ruta = "../../upload/PDF/Cotizacion" + mesAnio + ".pdf"
        With rpt
            .Load(Server.MapPath(ReporteArchivo))
            .DataSourceConnections(0).SetConnection("((local)", "CochoSystemADA", "sa", "Compromis0")
            .SetDataSource(tablaReporte)
            crDiskFileDestinationOptions.DiskFileName = Server.MapPath(ruta)
            With crExportOptions
                .ExportDestinationType = ExportDestinationType.DiskFile
                .ExportFormatType = ExportFormatType.PortableDocFormat
                .DestinationOptions = crDiskFileDestinationOptions
            End With
        End With


        Try
            rpt.Export(crExportOptions)
            retorno = ruta
        Catch ex As Exception
            'Response.Write(ex.Message)
            retorno = ex.Message.ToString
        Finally
            rpt.Close()
        End Try


        Return retorno
    End Function
    Public Function fnGeneraReporte(ByVal ReporteArchivo As String, ByVal mesAnio As String, ByVal InstrSQL As String, ByVal InstrSQL2 As String) As String
        Dim retorno As String = ""

        Dim tablaReporte As DataTable = New DataTable
        Dim daClientes As SqlDataAdapter = New SqlDataAdapter(InstrSQL, cadenaDB())
        'daClientes.FillSchema(tablaReporte, SchemaType.Source)
        daClientes.Fill(tablaReporte)

        Dim tablaReporte2 As DataTable = New DataTable
        Dim tablaDatos As SqlDataAdapter = New SqlDataAdapter(InstrSQL2, cadenaDB())
        'tablaDatos.FillSchema(tablaReporte2, SchemaType.Source)
        tablaDatos.Fill(tablaReporte2)

        Dim ruta As String = ""

        Dim crExportOptions As CrystalDecisions.Shared.ExportOptions = New CrystalDecisions.Shared.ExportOptions
        Dim crDiskFileDestinationOptions As CrystalDecisions.Shared.DiskFileDestinationOptions = New CrystalDecisions.Shared.DiskFileDestinationOptions
        Dim rpt As CrystalDecisions.CrystalReports.Engine.ReportDocument = New CrystalDecisions.CrystalReports.Engine.ReportDocument
        'rpt.Subreports("../reportes/reciboCFDI.rpt").SetParameterValue(0, "ARAD14")




        ruta = "../../upload/PDF/FacturaCFDI" + mesAnio + ".pdf"
        With rpt
            .Load(Server.MapPath(ReporteArchivo))
            .DataSourceConnections(0).SetConnection("(local)", "CochoSystemADA", "sa", "Compromis0")
            .SetDataSource(tablaReporte)
            .Subreports.Item(0).SetDataSource(tablaReporte2)
            crDiskFileDestinationOptions.DiskFileName = Server.MapPath(ruta)
            With crExportOptions
                .ExportDestinationType = ExportDestinationType.DiskFile
                .ExportFormatType = ExportFormatType.PortableDocFormat
                .DestinationOptions = crDiskFileDestinationOptions
            End With
        End With


        Try
            rpt.Export(crExportOptions)
            retorno = ruta
        Catch ex As Exception
            'Response.Write(ex.Message)
            retorno = ex.Message.ToString
        Finally
            rpt.Close()
        End Try


        Return retorno
    End Function



    Public Function fnRetornaValor(ByVal cadena As String, ByVal separador As String, ByVal numSep As Integer) As String
        Dim valor1 As String = ""
        'cadena=cadena.replace(separador,"["+separador+"]")
        Dim stringSeparators() As String = {separador}



        Dim arregloValor As String() = cadena.Split(stringSeparators, StringSplitOptions.None)
        'response.write("separador="+separador+",numSep="+numSep.tostring+",long="+arregloValor.Length.tostring+",cadena="+cadena+"<br>")
        If (numSep - 1 < arregloValor.Length) Then
            valor1 = arregloValor(numSep - 1)
        End If


        fnRetornaValor = valor1
    End Function

    Public Function fnCaracterEspecialXML(ByVal textRecibido As String) As String
        Dim textoRecibido As String = textRecibido


        If DBNull.Value.Equals(textoRecibido) = True Then textoRecibido = ""
        textoRecibido = textoRecibido.Replace("&", "&amp;")
        textoRecibido = textoRecibido.Replace("<", "&lt;")
        textoRecibido = textoRecibido.Replace(">", "&gt;")
        textoRecibido = textoRecibido.Replace("""", "&quot;")
        textoRecibido = textoRecibido.Replace("'", "&apos;")

        fnCaracterEspecialXML = textoRecibido
    End Function

    Public Function fnFileToByteArray(ByVal _FileName As String) As Byte()
        Dim _Buffer As Byte() = Nothing
        Try
            Dim _FileStream As System.IO.FileStream = New System.IO.FileStream(_FileName, System.IO.FileMode.Open, System.IO.FileAccess.Read)
            Dim _BinaryReader As System.IO.BinaryReader = New System.IO.BinaryReader(_FileStream)
            Dim _TotalBytes As Long = New System.IO.FileInfo(_FileName).Length
            _Buffer = _BinaryReader.ReadBytes(_TotalBytes)
            _FileStream.Close()
            _FileStream.Dispose()
            _BinaryReader.Close()
        Catch
        End Try
        fnFileToByteArray = _Buffer
    End Function

    Public Function DecodeUTF8(ByVal s As String) As String
        Dim i As Integer
        Dim c As Integer
        Dim n As Integer

        i = 1
        Do While i <= Len(s)
            c = Asc(Mid(s, i, 1))
            If c And &H80 Then
                n = 1
                Do While i + n < Len(s)
                    If (Asc(Mid(s, i + n, 1)) And &HC0) <> &H80 Then
                        Exit Do
                    End If
                    n = n + 1
                Loop
                If n = 2 And ((c And &HE0) = &HC0) Then
                    c = Asc(Mid(s, i + 1, 1)) + &H40 * (c And &H1)
                Else
                    c = 191
                End If
                s = Left(s, i - 1) + Chr(c) + Mid(s, i + n)
            End If
            i = i + 1
        Loop
        DecodeUTF8 = s
    End Function

    Public Function Create_Cancelacion(ByVal strFecha As String, ByVal strRFC As String, ByVal strUUID As String, _
    ByVal strCertFile As String, ByVal strPriKeyFile As String, ByVal strPassword As String) As String
        ' Returns a signed XML document in string form
        Dim strXMLout As String
        Dim strDataTBS As String
        Dim strDigestHex As String
        Dim abMessage() As Byte
        Dim abBlock() As Byte
        Dim abUtf8() As Byte
        Dim nmLen As Long
        Dim nkLen As Long
        Dim strDigestBase64 As String
        Dim strSignedInfoCanon As String
        Dim sbPrivateKey As StringBuilder
        Dim strSignature64 As String
        Dim strCertString64 As String
        Dim strSerialNumber As String
        Dim strIssuerName As String
        Dim strX509IssuerSerial As String

        ' 1. Create a canonicalized version of the data-to-be-signed

        ' (Note no whitespace between elements)
        strDataTBS = "<Cancelacion xmlns=""http://cancelacfd.sat.gob.mx""" & _
            " xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" & _
            " xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""" & _
            " Fecha=""%FECHA%"" RfcEmisor=""%RFC%"">" & _
            "<Folios><UUID>%UUID%</UUID></Folios></Cancelacion>"

        ' Substitute our input values...
        strDataTBS = Replace(strDataTBS, "%FECHA%", strFecha)
        strDataTBS = Replace(strDataTBS, "%RFC%", strRFC)
        strDataTBS = Replace(strDataTBS, "%UUID%", strUUID)
        'Console.WriteLine(strDataTBS)

        ' 2. Compute the SHA-1 message digest value of this in base64 encoding

        ' (because the string is only ASCII characters, we can hash the string directly)
        strDigestBase64 = CryptoSysPKI.Cnv.Base64FromHex(CryptoSysPKI.Hash.HexFromString(strDataTBS, CryptoSysPKI.HashAlgorithm.Sha1))
        'Console.WriteLine("SHA-1(DATA)=" & Cnv.HexFromBase64(strDigestBase64))
        'Console.WriteLine(strDigestBase64)

        ' 3. Create a canonicalized version of the SignedInfo element

        strSignedInfoCanon = "<SignedInfo xmlns=""http://www.w3.org/2000/09/xmldsig#""" & _
            " xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" & _
            " xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">" & _
            "<CanonicalizationMethod Algorithm=""http://www.w3.org/TR/2001/REC-xml-c14n-20010315""></CanonicalizationMethod>" & _
            "<SignatureMethod Algorithm=""http://www.w3.org/2000/09/xmldsig#rsa-sha1""></SignatureMethod>" & _
            "<Reference URI="""">" & _
            "<Transforms>" & _
            "<Transform Algorithm=""http://www.w3.org/2000/09/xmldsig#enveloped-signature""></Transform>" & _
            "</Transforms>" & _
            "<DigestMethod Algorithm=""http://www.w3.org/2000/09/xmldsig#sha1""></DigestMethod>" & _
            "<DigestValue>%DIGESTVALUE%</DigestValue>" & _
            "</Reference>" & _
            "</SignedInfo>"

        ' Substitute the base64 DigestValue we computed above
        strSignedInfoCanon = Replace(strSignedInfoCanon, "%DIGESTVALUE%", strDigestBase64)

        ' Compute SHA-1 digest of this canonicalized SignedInfo
        strDigestHex = Hash.HexFromString(strSignedInfoCanon, CryptoSysPKI.HashAlgorithm.Sha1)
        'Console.WriteLine("SHA-1(SIGNEDINFO)=" & strDigestHex)

        ' 4. Compute the rsa-sha1 signature of the SignedInfo element using the private key

        ' Convert ANSI text to bytes
        abMessage = System.Text.Encoding.Default.GetBytes(strSignedInfoCanon)

        'Console.WriteLine("M (ansi): '" & strSignedInfoCanon & "'")
        'Console.WriteLine("M (hex):  " & Cnv.ToHex(abMessage))

        ' Read in the private key from encrypted file
        sbPrivateKey = Rsa.ReadEncPrivateKey(strPriKeyFile, strPassword)
        If sbPrivateKey.Length = 0 Then
            'MsgBox("Cannot read RSA key file '" & strPriKeyFile & "'", vbCritical)
            Return ""
        End If

        ' To sign: first encode the message, then "encrypt" with RSA private key
        ' Compute lengths
        nmLen = abMessage.Length
        nkLen = Rsa.KeyBytes(sbPrivateKey.ToString)
        'Console.WriteLine("Key is " & nkLen & " bytes long")
        'Console.WriteLine("Message is " & nmLen & " bytes long")

        ' Encode for signature
        abBlock = Rsa.EncodeMsg(nkLen, abMessage, Rsa.EncodeFor.Signature)
        'Console.WriteLine("EM: " & Cnv.ToHex(abBlock))

        ' Sign using RSA private key
        abBlock = Rsa.RawPrivate(abBlock, sbPrivateKey.ToString)
        'Console.WriteLine("SG: " & Cnv.ToHex(abBlock))

        ' Clear the private key for security
        Call Wipe.String(sbPrivateKey)

        ' Convert the signature value to base64
        strSignature64 = Cnv.ToBase64(abBlock)
        'Console.WriteLine("SG: " & strSignature64)

        ' 5. Extract the KeyInfo fields from the X.509 certificate.

        ' Read in certificate file's data to a base64 string
        strCertString64 = CryptoSysPKI.X509.ReadStringFromFile(strCertFile)
        If strCertString64.Length = 0 Then
            'MsgBox("Cannot read certificate file '" & strCertFile & "'", vbCritical)
            Return ""
        End If
        'Console.WriteLine("For certificate '" & strCertFile & "':")
        'Console.WriteLine(strCertString64)

        ' Extract the serialNumber in decimal form
        strSerialNumber = CryptoSysPKI.X509.QueryCert(strCertFile, "serialNumber", X509.Options.Decimal)
        If strSerialNumber.Length = 0 Then
            'MsgBox("Cannot read certificate file '" & strCertFile & "'", vbCritical)
            Return ""
        End If
        'Console.WriteLine("serialNumber=" & strSerialNumber)

        ' Extract the issuerName in LDAP form (encoded in Latin-1 because it's easier to handle)
        strIssuerName = CryptoSysPKI.X509.QueryCert(strCertFile, "issuerName", X509.Options.Ldap + X509.Options.Latin1)
        If strIssuerName.Length = 0 Then
            'MsgBox("Cannot read certificate file '" & strCertFile & "'", vbCritical)
            Return ""
        End If
        'Console.WriteLine("issuerName=" & strIssuerName)

        ' Convert to UTF-8 encoding
        abUtf8 = Encoding.UTF8.GetBytes(strIssuerName)

        ' Compose X509IssuerSerial element

        strX509IssuerSerial = "<X509IssuerSerial><X509IssuerName>" & _
            Encoding.UTF8.GetString(abUtf8) & _
            "</X509IssuerName><X509SerialNumber>" & strSerialNumber & "</X509SerialNumber>" & _
            "</X509IssuerSerial>"

        ' 6. Compose the final output XML document

        strXMLout = "<?xml version=""1.0"" encoding=""UTF-8""?>" & _
            "<Cancelacion xmlns=""http://cancelacfd.sat.gob.mx""" & _
            " xmlns:xsd=""http://www.w3.org/2001/XMLSchema""" & _
            " xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance""" & _
            " Fecha=""" & strFecha & """ RfcEmisor=""" & strRFC & """>" & _
            "<Folios><UUID>" & strUUID & "</UUID></Folios>" & _
            "<Signature xmlns=""http://www.w3.org/2000/09/xmldsig#"">" & _
            "<SignedInfo>" & _
            "<CanonicalizationMethod Algorithm=""http://www.w3.org/TR/2001/REC-xml-c14n-20010315"" />" & _
            "<SignatureMethod Algorithm=""http://www.w3.org/2000/09/xmldsig#rsa-sha1"" />" & _
            "<Reference URI="""">" & _
            "<Transforms>" & _
            "<Transform Algorithm=""http://www.w3.org/2000/09/xmldsig#enveloped-signature"" />" & _
            "</Transforms>" & _
            "<DigestMethod Algorithm=""http://www.w3.org/2000/09/xmldsig#sha1"" />" & _
            "<DigestValue>" & strDigestBase64 & "</DigestValue>" & _
            "</Reference>" & _
            "</SignedInfo>" & _
            "<SignatureValue>" & strSignature64 & "</SignatureValue>" & _
            "<KeyInfo><X509Data>" & _
            strX509IssuerSerial & _
            "<X509Certificate>" & strCertString64 & "</X509Certificate>" & _
            "</X509Data></KeyInfo>" & _
            "</Signature>" & _
            "</Cancelacion>"

        Return strXMLout

    End Function
End Class
