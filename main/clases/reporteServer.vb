Imports CrystalDecisions.CrystalReports.Design
Imports CrystalDecisions.Shared
Imports System.Data.SqlClient

Public Class reporteServer
    Inherits System.Web.UI.Page

    Private valorReporteRPT As String
    Public Property rutaReproteRPT() As String
        Get
            Return valorReporteRPT
        End Get
        Set(ByVal value As String)
            valorReporteRPT = value
        End Set
    End Property


    Private valorRutaPDF As String
    Public Property rutaPDFTemp() As String
        Get
            Return valorRutaPDF
        End Get
        Set(ByVal value As String)
            valorRutaPDF = value
        End Set
    End Property

    Private Function fnRetornaTabla(ByVal queryConsulta As String) As DataTable

        Dim tablaReporte As DataTable = New DataTable
        Dim daClientes As SqlDataAdapter = New SqlDataAdapter(queryConsulta, New clases().cadenaDB)
        daClientes.FillSchema(tablaReporte, SchemaType.Source)
        daClientes.Fill(tablaReporte)
        daClientes.Dispose()

        Return tablaReporte
    End Function

    Public Function fnCreaReporte(ByVal queryConsulta As String) As String
        Dim crExportOptions As CrystalDecisions.Shared.ExportOptions = New CrystalDecisions.Shared.ExportOptions
        Dim crDiskFileDestinationOptions As CrystalDecisions.Shared.DiskFileDestinationOptions = New CrystalDecisions.Shared.DiskFileDestinationOptions
        Dim crystalDocumento As CrystalDecisions.CrystalReports.Engine.ReportDocument = New CrystalDecisions.CrystalReports.Engine.ReportDocument()
        Dim retornaDocPDF As String = ""
        With crystalDocumento
            .Load(rutaReproteRPT)
            .SetDataSource(fnRetornaTabla(queryConsulta))
            crDiskFileDestinationOptions.DiskFileName = rutaPDFTemp
            With crExportOptions
                .ExportDestinationType = ExportDestinationType.DiskFile
                .ExportFormatType = ExportFormatType.PortableDocFormat
                .DestinationOptions = crDiskFileDestinationOptions
            End With

        End With

        Try
            If System.IO.File.Exists(rutaPDFTemp) Then
                retornaDocPDF = rutaPDFTemp
            Else
                crystalDocumento.Export(crExportOptions)
                retornaDocPDF = rutaPDFTemp
            End If

        Catch ex As Exception
            retornaDocPDF = ex.Message
        Finally
            crystalDocumento.Close()
        End Try

        Return retornaDocPDF
    End Function
End Class
