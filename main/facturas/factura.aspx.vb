Imports System.Data
Imports FirmaSAT
Imports System.IO
Imports timbradoCocho.mx.com.expidetufactura

Public Class factura
    Inherits System.Web.UI.Page
    Public objetoClases As clases = New clases
    Public mensajeError As String = ""
    Public IdEmpresa As String = ""
    Public cadenaTitulo As String = "EMISION DE FACTURAS"
    Public Function fnCargaRecibo(ByVal TipoFolio As String) As Boolean
        Dim InstrSQL As String = ""
        Dim retornoRecibo As DataView

        InstrSQL = "SELECT dbo.fnConsecutivoFactura(" + TipoFolio + ") as NumeroRecibo"
        retornoRecibo = objetoClases.fnRegresaTabla(InstrSQL, "Consecutivo")
        If retornoRecibo.Count <> 0 Then

            Response.Write("<script>")
            Response.Write("try{parent.document.getElementById('numeroReciboM').setAttribute('value','" + retornoRecibo(0)("NumeroRecibo").ToString + "'); ")
            Response.Write("}catch(ex){parent.alerta(ex.message); parent.document.getElementById('numeroReciboM').setAttribute('value','" + retornoRecibo(0)("NumeroRecibo").ToString + "'); } ")
            Response.Write("</script>")
            'Response.Write("<script> parent.document.getElementById('numeroReciboM').value = '" + retornoRecibo(0)("NumeroRecibo").ToString + "'; </script>")
        End If
        Return fnCargaRecibo
    End Function



    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Response.Write("<script>window.parent.document.getElementById('tituloModulo').innerText='" + cadenaTitulo + "';</script>")

        Dim tipoFolio As String = "", numeroReciboM As String = "", idClienteM As String = ""
        Dim cantidad As String = "", descripcion As String = "", precio As String = "", importe As String = ""
        'OPCIONES SAT   
        Dim retorno As String = ""
        Dim accion As String = HttpContext.Current.Request.Form("accion")
        Dim totalElemento As String = HttpContext.Current.Request.Form("totalFacturaM")
        Dim FormaPagoSAT As String = ""
        FormaPagoSAT = HttpContext.Current.Request.Form("formaPagoM")
        Dim MetodoPagoSAT As String = ""
        MetodoPagoSAT = HttpContext.Current.Request.Form("metodoPagoM")
        Dim CondicionPagoSAT As String = ""
        CondicionPagoSAT = HttpContext.Current.Request.Form("condicionPagoM")
        Dim CuentaPago As String = ""
        CuentaPago = HttpContext.Current.Request.Form("numeroCtaM")
        tipoFolio = HttpContext.Current.Request.Form("tipoFolioM")

        If accion = "consecutivoRecibo" Then
            Call fnCargaRecibo(tipoFolio)
        End If

        If tipoFolio = "100" Then
            IdEmpresa = "ARAD14"
        Else
            IdEmpresa = "CDLC14"
        End If

        If accion = "generaFactura" Then
            retorno = fnIngresaFactura(totalElemento, FormaPagoSAT, MetodoPagoSAT, CondicionPagoSAT, CuentaPago)
        End If

        Dim Reporte As String = "", retornoReporte As String = ""

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
            retornoReporte = objetoClases.fnGeneraReporte(Reporte, IdEmpresa + HttpContext.Current.Request("idFactura"), InstrSQL, InstrSQL2)

            'Response.Write(retornoReporte)
            'Response.End()

            HttpContext.Current.Response.Redirect(retornoReporte)
        End If


    End Sub
    Public Function fnIngresaFactura(ByVal totalElemento As String, ByVal FormaPagoSAT As String, ByVal MetodoPagoSAT As String, ByVal CondicionPagoSAT As String, ByVal CuentaPago As String) As Boolean

        Dim i As Integer
        Dim SqlConnection As System.Data.SqlClient.SqlConnection
        Dim SqlTransaction As System.Data.SqlClient.SqlTransaction
        Dim SQLCommand As System.Data.SqlClient.SqlCommand


        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet

        Dim InstrSQL As String = ""
        Dim errorCodigo As Boolean = False
        Dim mensajeError As String = ""
        Dim mensaje As String = ""
        Dim retorno As Boolean = False
        Dim DescripcionFactura As String = ""

        If totalElemento <> "" Then
            Try
                SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
                SqlConnection.Open()
                SqlTransaction = SqlConnection.BeginTransaction()
                Dim claveImpuesto As String = ""

                For i = 0 To Integer.Parse(totalElemento) - 1

                    If Request.Form("descripcionFactura" + i.ToString) = "" Then
                        DescripcionFactura = Request.Form("nombredescripcionFactura" + i.ToString)
                    Else
                        DescripcionFactura = Request.Form("descripcionFactura" + i.ToString)
                    End If
                    claveImpuesto = objetoClases.fnRetornaValor(HttpContext.Current.Request.Form("claveImpuestoFactura" + i.ToString), "-", 2)

                    InstrSQL = "EXEC dbo.spPagoFactura '" + HttpContext.Current.Request.Form("numeroReciboM") + "','" + IdEmpresa + "','" + HttpContext.Current.Request.Form("cantidadFactura" + i.ToString) + "','" + HttpContext.Current.Request.Form("idUnidadFactura" + i.ToString) + "','" + DescripcionFactura + "','" + HttpContext.Current.Request.Form("precioFactura" + i.ToString) + "','" + HttpContext.Current.Request.Form("importeFactura" + i.ToString) + "','" + HttpContext.Current.Request.Form("ivaM") + "','" + HttpContext.Current.Request.Form("totalFacM") + "','" + HttpContext.Current.Request.Form("tipoFolioM") + "','" + HttpContext.Current.Request.Form("subTotalM") + "','" + HttpContext.Current.Request.Form("IdclienteM") + "','" + HttpContext.Current.Request.Form("ivaRetM") + "','" + HttpContext.Current.Request.Form("isrRetM") + "','" + HttpContext.Current.Request.Form("ret5M") + "','" + HttpContext.Current.Request.Form("importeImpuestoFactura" + i.ToString) + "','" + claveImpuesto + "','" + HttpContext.Current.Request.Form("claveSATFactura" + i.ToString) + "','" + HttpContext.Current.Request.Form("idUnidadFactura" + i.ToString) + "',1"
                    Response.Write(InstrSQL)

                    SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
                    SQLCommand.Transaction = SqlTransaction
                    SQLCommand.ExecuteNonQuery()
                Next
                Dim totalRelacionCFDI As Integer = 0
                totalRelacionCFDI = Integer.Parse(HttpContext.Current.Request.Form("totalCFDIM"))

                For iRelacion = 0 To totalRelacionCFDI - 1
                    InstrSQL = "EXEC dbo.spRelacionCFDI '" + IdEmpresa + "','" + HttpContext.Current.Request.Form("tipoRelacionM") + "','" + HttpContext.Current.Request.Form("timbreFiscalCFDI" + iRelacion.ToString) + "','" + HttpContext.Current.Request.Form("numeroReciboM") + "',1 "
                    Response.Write(InstrSQL)
                    SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
                    SQLCommand.Transaction = SqlTransaction
                    SQLCommand.ExecuteNonQuery()
                Next
                Dim fechaFactura As Object, fechaFacturaSAT As String, fechaFacturaSistema As String
                fechaFactura = Now
                fechaFacturaSAT = objetoClases.fnFormatoFecha(fechaFactura, "ymd").Replace("/", "-") + "T" + objetoClases.fnFormatoFecha(fechaFactura, "time")
                fechaFacturaSistema = objetoClases.fnFormatoFecha(fechaFactura, "dmy") + " " + objetoClases.fnFormatoFecha(fechaFactura, "time")


                InstrSQL = " EXEC dbo.spPagoFacturaDigital '" + IdEmpresa + "|" + Request.Form("porCobrarM") + "','" + HttpContext.Current.Request.Form("numeroReciboM") + "','" + FormaPagoSAT + "','" + MetodoPagoSAT + "','" + CondicionPagoSAT + "','" + CuentaPago + "','" + HttpContext.Current.Request.Form("IdclienteM") + "','" + fechaFacturaSistema + "',1"
                Response.Write(InstrSQL)
                SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
                SQLCommand.Transaction = SqlTransaction
                SQLCommand.ExecuteNonQuery()



                InstrSQL = " EXEC dbo.spGeneraXMLV3 '" + HttpContext.Current.Request.Form("tipoFolioM") + "', '" + HttpContext.Current.Request.Form("numeroReciboM") + "'"
                Response.Write(InstrSQL)
                SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
                SQLCommand.Transaction = SqlTransaction

                DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
                DataAdapter.Fill(DataSet, "tablaXML")
                DataView = DataSet.Tables("tablaXML").DefaultView
                Dim cadenaXML As String = ""

                'Response.End()




                Dim claseSello As New selloBase64(), base64Certificado As String = "", cadenaOriginalXML As String = "", selloXmla As String = ""

                Dim rutaUpload As String = Server.MapPath("../../upload/")
                Dim respuestaPrueba As mx.com.expidetufactura.pruebastimbrado.respuestaTimbrado
                Dim respuestaReal As mx.com.expidetufactura.timbradodp.respuestaTimbrado


                If DataView.Count <> 0 Then
                    cadenaXML = DataView(0)("xmlPreTimbrado")
                    base64Certificado = claseSello.fnBase64Cert(rutaUpload + "SelloDigital/" + DataView(0)("Certificado"))
                    cadenaXML = Replace(cadenaXML, "Certificado=""""", "Certificado=""" + base64Certificado + """")


                    Dim streamWriter As System.IO.StreamWriter = System.IO.File.CreateText(rutaUpload + "XML/" + HttpContext.Current.Request.Form("numeroReciboM") + ".xml")
                    streamWriter.WriteLine(cadenaXML)
                    StreamWriter.Close()
                    streamWriter = Nothing
                    cadenaOriginalXML = claseSello.fnObtenCadena(rutaUpload + "XML/" + HttpContext.Current.Request.Form("numeroReciboM") + ".xml", "http://www.sat.gob.mx/sitio_internet/cfd/3/cadenaoriginal_3_3/cadenaoriginal_3_3.xslt", "")

                    selloXmla = claseSello.fnSello33(DataView(0)("PassLlave"), objetoClases.fnFileToByteArray(Replace(rutaUpload + "SelloDigital/" + DataView(0)("Llave"), ".key", ".pfx")), cadenaOriginalXML)

                    'Response.Write(selloXmla)
                    'Response.End()

                    cadenaXML = Replace(cadenaXML, "Sello=""""", "Sello=""" + selloXmla + """")

                    Dim streamWriter2 As System.IO.StreamWriter = System.IO.File.CreateText(rutaUpload + "XML/" + HttpContext.Current.Request.Form("numeroReciboM") + "_2.xml")
                    streamWriter2.WriteLine(cadenaXML)
                    streamWriter2.Close()
                    streamWriter2 = Nothing

                    Dim archivoXMLFirmado As String = rutaUpload + "XML/" + HttpContext.Current.Request.Form("numeroReciboM") + "_2.xml"




                    Dim claseXpide As timbradoExpide = New timbradoExpide()

                    Dim archivoTimbreRespuesta As String = rutaUpload + "XML\" + HttpContext.Current.Request.Form("numeroReciboM") + "Timbre.xml"
                    Dim codigoRespuesta As String = ""
                    Dim timbreUUID As String = ""

                    If 10 = 1 Then
                        claseXpide.passwordWeb = "12345678a"
                        claseXpide.usuarioWeb = "pruebas"

                        respuestaPrueba = claseXpide.fnTimbraPrueba(objetoClases.fnFileToByteArray(archivoXMLFirmado))
                        archivoTimbreRespuesta = respuestaPrueba.timbre
                        timbreUUID = respuestaPrueba.uuid
                        codigoRespuesta = respuestaPrueba.codigo
                        mensajeError = respuestaPrueba.mensaje
                    Else
                        claseXpide.passwordWeb = DataView(0)("PassWebService")
                        claseXpide.usuarioWeb = DataView(0)("UsuarioWebService")
                        respuestaReal = claseXpide.fnTimbraR(objetoClases.fnFileToByteArray(archivoXMLFirmado))
                        archivoTimbreRespuesta = respuestaReal.timbre
                        timbreUUID = respuestaReal.uuid
                        codigoRespuesta = respuestaReal.codigo
                        mensajeError = respuestaReal.mensaje
                    End If




                    Response.Write("aSDasddasd=" + mensajeError)

                    'Response.End()


                    Dim archivoTimbreRespuesta2 As String = rutaUpload + "XML\" + timbreUUID + ".xml"
                    Dim streamWriter3 As System.IO.StreamWriter = System.IO.File.CreateText(archivoTimbreRespuesta2)
                    streamWriter3.WriteLine(archivoTimbreRespuesta)
                    streamWriter3.Close()


                    Dim cadenaOriginalRespuesta As String = ""
                    cadenaOriginalRespuesta = claseSello.fnObtenCadena(rutaUpload + "XML\" + timbreUUID + ".xml", rutaUpload + "archivoSAT\cadenaoriginal_3_3.xslt", "")
                    'creamos documentoXML para leer la informacion del timbreFiscal
                    Dim documentoXML As System.Xml.XmlDocument = New System.Xml.XmlDocument()
                    Dim nodoTimbre As System.Xml.XmlNodeList, selloSat As String = "", certificadoDigital As String = ""

                    documentoXML.Load(rutaUpload + "XML\" + timbreUUID + ".xml")
                    nodoTimbre = documentoXML.GetElementsByTagName("tfd:TimbreFiscalDigital")
                    Dim atributosTimbre As System.Xml.XmlAttributeCollection
                    atributosTimbre = nodoTimbre.Item(0).Attributes
                    Dim UUID As String = "", FechaTimbrado As String = "", SelloCFD As String = "", NoCertificadoSAT As String = ""

                    For iTimbre = 0 To atributosTimbre.Count - 1
                        If atributosTimbre.Item(iTimbre).Name = "UUID" Then
                            UUID = atributosTimbre.Item(iTimbre).Value
                        End If

                        If atributosTimbre.Item(iTimbre).Name = "NoCertificadoSAT" Then
                            NoCertificadoSAT = atributosTimbre.Item(iTimbre).Value
                        End If
                        If atributosTimbre.Item(iTimbre).Name = "SelloSAT" Then
                            selloSat = atributosTimbre.Item(iTimbre).Value
                        End If

                    Next


                    InstrSQL = "UPDATE PagoFacturaDigital SET PFDigCadenaOriginal= @PFDigCadenaOriginal,PFDigSelloDigital = @PFDigSelloDigital ,PFDigXMLTimbrado = @PFDigXMLTimbrado,PFDigXML = @PFDigXML,PFDigCertificadoDigital=@PFDigCertificadoDigital WHERE PFDigIdFactura = " + HttpContext.Current.Request.Form("numeroReciboM") + " AND PFDigIdEmpresa='" + IdEmpresa + "'"
                    SQLCommand = New SqlClient.SqlCommand("SELECT * FROM PagoFacturaDigital WHERE PFDigIdFactura = " + HttpContext.Current.Request.Form("numeroReciboM") + " AND PFDigIdEmpresa='" + IdEmpresa + "'", SqlConnection)
                    SQLCommand.Transaction = SqlTransaction

                    DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
                    DataAdapter.Fill(DataSet, "PagoFacturaDigital")
                    Dim dt As System.Data.DataTable = DataSet.Tables("PagoFacturaDigital")
                    dt.Rows(0)("PFDigCadenaOriginal") = cadenaOriginalRespuesta
                    dt.Rows(0)("PFDigSelloDigital") = selloSat
                    dt.Rows(0)("PFDigXMLTimbrado") = archivoTimbreRespuesta
                    dt.Rows(0)("PFDigXML") = cadenaXML
                    dt.Rows(0)("PFDigCertificadoDigital") = NoCertificadoSAT

                    SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
                    SQLCommand.Transaction = SqlTransaction


                    SQLCommand.Parameters.Add("@PFDigCadenaOriginal",
                            SqlDbType.Text, 80000, "PFDigCadenaOriginal")
                    SQLCommand.Parameters.Add("@PFDigSelloDigital",
                               SqlDbType.Text, 80000, "PFDigSelloDigital")
                    SQLCommand.Parameters.Add("@PFDigXMLTimbrado",
                               SqlDbType.Text, 5000000, "PFDigXMLTimbrado")
                    SQLCommand.Parameters.Add("@PFDigXML",
                               SqlDbType.Text, 5000000, "PFDigXML")
                    SQLCommand.Parameters.Add("@PFDigCertificadoDigital",
                               SqlDbType.Text, 80000, "PFDigCertificadoDigital")
                    DataAdapter.UpdateCommand = SQLCommand
                    DataAdapter.Update(DataSet, "PagoFacturaDigital")
                    retorno = True

                End If



                'Falta hacer commit a las instruccionesSQL y guardar xmlnoTimbrado y xmlTimbrado DB


                If retorno = True Then
                    errorCodigo = False
                    SqlTransaction.Commit()
                    mensajeError = ""
                    mensaje = "La factura se genero con exito"
                    Response.Write("<s" + "cript>parent.alerta('" + mensaje + "')</s" + "cript>")
                    Response.Write("<script> ")
                    Response.Write(" parent.fnImprimeRecibo('" + IdEmpresa + "','" + Request.Form("numeroReciboM") + "','" + Request.Form("tipoFolioM") + "'); ")
                    Response.Write(" parent.fnLimpiaTabla('bodyFacturaM','totalFacturaM');")
                    Response.Write(" parent.fnLimpiaFactura(); ")
                    Response.Write(" </script>")
                    SqlConnection.Close()
                Else
                    SqlTransaction.Rollback()

                mensajeError = mensajeError
                Response.Write("<s" + "cript>parent.alerta('" + mensajeError + "')</s" + "cript>")

                End If

        Catch ex As Exception
        'mensajeError = ex.Message.Replace("'", "\'")
        mensajeError = mensajeError
        Response.Write("<s" + "cript>parent.alerta('" + mensajeError + "')</s" + "cript>")
        End Try

        End If

        Return retorno
    End Function

    Public Function fnGeneraXML(ByVal IdEmpresa As String, ByVal idUsuario As String, tipoFolio As String, ByVal numeroFactura As String, ByVal FormaPagoSAT As String, ByVal MetodoPagoSAT As String, ByVal CondicionPagoSAT As String, ByVal CuentaPago As String, ByVal SqlConnection As System.Data.SqlClient.SqlConnection, ByVal SqlTransaction As System.Data.SqlClient.SqlTransaction) As Boolean
        Dim retornoError As Boolean
        Dim retornoAux As Boolean
        Dim folioElectronico As String = ""
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet

        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim RFCCliente As String = ""
        Dim RFCEmisor As String = ""

        Dim tipoComprobante As String = "ingreso"
        Dim versionFolioElectronico As String = "4"

        Dim XMLString As String = ""
        Dim InstrSQL As String = ""
        Dim fechaXML As String = ""

        Dim fechaFactura As Object, fechaFacturaSAT As String, fechaFacturaSistema As String
        fechaFactura = Now
        fechaFacturaSAT = objetoClases.fnFormatoFecha(fechaFactura, "ymd").Replace("/", "-") + "T" + objetoClases.fnFormatoFecha(fechaFactura, "time")
        fechaFacturaSistema = objetoClases.fnFormatoFecha(fechaFactura, "dmy") + " " + objetoClases.fnFormatoFecha(fechaFactura, "time")

        InstrSQL = " EXEC dbo.spPagoFacturaDigital '" + IdEmpresa + "','" + numeroFactura + "','" + FormaPagoSAT + "','" + MetodoPagoSAT + "','" + CondicionPagoSAT + "','" + CuentaPago + "','" + idUsuario + "','" + fechaFacturaSistema + "',1"
        retornoError = objetoClases.fnExecutaStored(InstrSQL)

        If retornoError = True Then
            InstrSQL = "EXEC [dbo].[spReciboDigitalCFDI] '" + IdEmpresa + "','" + tipoFolio + "','" + numeroFactura + "',1"

            SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
            SQLCommand.Transaction = SqlTransaction
            DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
            DataAdapter.Fill(DataSet, "cabeceraFactura")
            DataView = DataSet.Tables("cabeceraFactura").DefaultView


            If DataView.Count <> 0 Then

                If versionFolioElectronico = "4" Then 'VERSION 3.2
                    XMLString = "<?xml version=""1.0"" encoding=""UTF-8""?><cfdi:Comprobante xsi:schemaLocation=""http://www.sat.gob.mx/cfd/3 http://www.sat.gob.mx/sitio_internet/cfd/3/cfdv32.xsd http://www.sat.gob.mx/implocal http://www.sat.gob.mx/sitio_internet/cfd/implocal/implocal.xsd"" xmlns:cfdi=""http://www.sat.gob.mx/cfd/3"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" version=""3.2"" "

                End If

                If versionFolioElectronico = "4" Then 'VERSION 3.2
                    XMLString = XMLString + "metodoDePago=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("MetodoPago")) + """ " _
                      + "LugarExpedicion=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorEstado")) + "," + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorMunicipio")) + """ " _
                       + "TipoCambio=""1"" Moneda=""MX"" "
                End If

                If versionFolioElectronico = "4" And DataView(0)("CuentaPago").length >= 4 Then 'VERSION 3.2 
                    XMLString = XMLString + "NumCtaPago=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("CuentaPago")) + """ "
                End If

                If versionFolioElectronico = "4" And Trim(DataView(0)("CondicionPago")) <> "" Then 'VERSION 3.2 
                    XMLString = XMLString + "condicionesDePago=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("CondicionPago")) + """ "
                End If
                RFCEmisor = objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorRFC"))
                RFCCliente = objetoClases.fnCaracterEspecialXML(DataView(0)("RFCReceptor"))


                XMLString = XMLString _
                + "folio=""" + numeroFactura.ToString + """ " _
                + "fecha=""" + fechaFacturaSAT.ToString + """ " _
                + "formaDePago=""" + DataView(0)("FormaPago").ToString + """ " _
                + "subTotal=""" + Replace(DataView(0)("SubTotalFactura").ToString, ",", ".") + """ " _
                + "total=""" + Replace(DataView(0)("TotalFactura").ToString, ",", ".") + """ " _
                + "tipoDeComprobante=""" + tipoComprobante + """  " _
                + "noCertificado=""""  " _
                + "certificado=""""  " _
                + "sello="""">" _
                + "<cfdi:Emisor nombre=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorNombre")) + """ " _
                + "rfc=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorRFC")) + """>" _
                + "<cfdi:DomicilioFiscal calle=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorCalle")) + """ " _
                + "codigoPostal=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorCodigoPostal")) + """ " _
                + "colonia=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorColonia")) + """ " _
                + "estado=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorEstado")) + """ " _
                + "localidad=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorMunicipio")) + """ " _
                + "municipio=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorMunicipio")) + """ " _
                + "noExterior=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorNumeroExterior")) + """ " _
                + "noInterior=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorNumeroInterior")) + """ " _
                + "pais=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorPais")) + """ />" _
                + "<cfdi:ExpedidoEn calle=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorCalle")) + """ " _
                + "codigoPostal=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorCodigoPostal")) + """ " _
                + "colonia=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorColonia")) + """ " _
                + "estado=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorEstado")) + """ " _
                + "localidad=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorMunicipio")) + """ " _
                + "municipio=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorMunicipio")) + """ " _
                + "noExterior=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorNumeroExterior")) + """ " _
                + "noInterior=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorNumeroInterior")) + """ " _
                + "pais=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorPais")) + """ />"
                If versionFolioElectronico = "4" Then 'VERSION 3.2
                    XMLString = XMLString + "<cfdi:RegimenFiscal  Regimen=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("EmisorRegimenFiscal")) + """/> "
                End If

                XMLString = XMLString _
                + "</cfdi:Emisor>" _
                + "<cfdi:Receptor nombre=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorNombre")) + """ rfc=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("RFCReceptor")) + """>" _
                + "<cfdi:Domicilio calle=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorCalle")) + """ " _
                + "codigoPostal=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorCP")) + """ " _
                + "colonia=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorColonia")) + """ " _
                + "estado=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorEstado")) + """ " _
                + "localidad=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorPoblacion")) + """ " _
                + "municipio=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorMunicipio")) + """ " _
                + "noExterior=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorNumeroExterior")) + """ " _
                + "noInterior=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorNumeroInterior")) + """ " _
                + "pais=""" + objetoClases.fnCaracterEspecialXML(DataView(0)("ReceptorPais")) + """ />" _
                + "</cfdi:Receptor>" _
                + "<cfdi:Conceptos>"

                InstrSQL = " EXEC dbo.spReciboDigitalConcepto '" + IdEmpresa + "','" + numeroFactura + "','" + tipoFolio + "',1"

                retornoError = fnXMLConcepto(XMLString, InstrSQL, numeroFactura, RFCEmisor, RFCCliente, SqlConnection, SqlTransaction)
                If retornoError = True Then
                    retornoAux = True
                Else
                    retornoAux = False
                End If

            End If



        End If

        Return retornoAux

    End Function

    Public Function fnXMLConcepto(ByVal XMLString As String, ByVal InstrSQL As String, ByVal numeroFactura As String, ByVal RFFEmisor As String, ByVal RFCCliente As String, ByVal SqlConnection As System.Data.SqlClient.SqlConnection, ByVal SqlTransaction As System.Data.SqlClient.SqlTransaction) As Boolean
        Dim retornoAux As Boolean
        Dim retorno As Boolean
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet

        Dim SQLCommand As System.Data.SqlClient.SqlCommand

        SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
        SQLCommand.Transaction = SqlTransaction
        DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)

        DataAdapter.Fill(DataSet, "Concepto")

        DataView = DataSet.Tables("Concepto").DefaultView

        Dim iContador As Integer = 0
        If DataView.Count <> 0 Then

            For iContador = 0 To DataView.Count - 1

                XMLString = XMLString _
                & "<cfdi:Concepto cantidad=""" + objetoClases.fnCaracterEspecialXML(DataView(iContador)("Cantidad")) + """ unidad=""" + objetoClases.fnCaracterEspecialXML(DataView(iContador)("Unidad")) + """ descripcion=""" & objetoClases.fnCaracterEspecialXML(DataView(iContador)("Descripcion")) & """ valorUnitario=""" + Replace(DataView(iContador)("ValorUnitario").ToString, ",", ".") + """ importe=""" + Replace(DataView(iContador)("Importe").ToString, ",", ".") & """/>"

            Next iContador

            If DataView(0)("TieneRetenciones") = "1" And DataView(0)("IsrRetenido") <> "0.00" Then
                XMLString = XMLString _
                + "</cfdi:Conceptos>" _
                + "<cfdi:Impuestos  totalImpuestosTrasladados=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("TotalIva")), ",", ".") + """ totalImpuestosRetenidos=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("TotalRetenciones")), ",", ".") + """>" _
                + "<cfdi:Retenciones>" _
                + "<cfdi:Retencion importe=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("IsrRetenido")), ",", ".") + """ impuesto=""ISR"" />" _
                + "<cfdi:Retencion importe=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("IvaRetenido")), ",", ".") + """ impuesto=""IVA"" />" _
                + "</cfdi:Retenciones>" _
                + "<cfdi:Traslados>" _
                + "<cfdi:Traslado impuesto=""IVA"" tasa=""16.00"" importe=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("TotalIva")), ",", ".") + """/>" _
                + "</cfdi:Traslados>" _
                + "</cfdi:Impuestos>"

            End If

            If DataView(0)("TieneRetenciones") = "1" And DataView(0)("IsrRetenido") = "0.00" Then
                XMLString = XMLString _
                + "</cfdi:Conceptos>" _
                + "<cfdi:Impuestos  totalImpuestosTrasladados=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("TotalIva")), ",", ".") + """ totalImpuestosRetenidos=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("TotalRetenciones")), ",", ".") + """>" _
                + "<cfdi:Retenciones>" _
                + "<cfdi:Retencion importe=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("IvaRetenido")), ",", ".") + """ impuesto=""IVA"" />" _
                + "</cfdi:Retenciones>" _
                + "<cfdi:Traslados>" _
                + "<cfdi:Traslado impuesto=""IVA"" tasa=""16.00"" importe=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("TotalIva")), ",", ".") + """/>" _
                + "</cfdi:Traslados>" _
                + "</cfdi:Impuestos>"

            End If

            If DataView(0)("TieneRetenciones") = "0 " Then

                XMLString = XMLString _
           + "</cfdi:Conceptos>" _
           + "<cfdi:Impuestos  totalImpuestosTrasladados=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("TotalIva")), ",", ".") + """ >" _
           + "<cfdi:Traslados>" _
           + "<cfdi:Traslado impuesto=""IVA"" tasa=""16.00"" importe=""" + Replace(objetoClases.fnCaracterEspecialXML(DataView(0)("TotalIva")), ",", ".") + """/>" _
           + "</cfdi:Traslados>" _
           + "</cfdi:Impuestos>"

            End If
            'Response.Write(DataView(0)("Impuesto5Millar").ToString)
            'Response.End()
            If DataView(0)("Impuesto5Millar").ToString <> "0.00" Then
                XMLString = XMLString _
                    + "<cfdi:Complemento>" _
                    + "<implocal:ImpuestosLocales version=""1.0"" xmlns:implocal=""http://www.sat.gob.mx/implocal"" TotaldeRetenciones=""" + Replace(DataView(0)("Impuesto5Millar").ToString, ",", ".") + """ TotaldeTraslados=""0.00"">" _
                    + "<implocal:RetencionesLocales ImpLocRetenido=""5 AL MILLAR"" TasadeRetencion=""0.5"" Importe=""" + Replace(DataView(0)("Impuesto5Millar").ToString, ",", ".") + """ />" _
                    + "</implocal:ImpuestosLocales>" _
                    + "</cfdi:Complemento>"
            End If

            XMLString = XMLString _
            + "</cfdi:Comprobante>"


        End If
        Dim pathPadre As String = "../../upload/"
        Dim archivo As String = RFCCliente + "_" + numeroFactura + ".XML"
        Dim ruta = Server.MapPath(pathPadre + archivo)

        Dim streamWriter As System.IO.StreamWriter = System.IO.File.CreateText(ruta)
        streamWriter.WriteLine(XMLString)
        streamWriter.Close()
        streamWriter = Nothing

        retorno = fnTimbraXML(ruta, IdEmpresa, archivo, numeroFactura, SqlConnection, SqlTransaction)
        If retorno = True Then
            retornoAux = True
        Else
            retornoAux = False
        End If
        Return retornoAux
    End Function


    Public Function fnTimbraXML(ByVal rutaXML As String, ByVal IdEmpresa As String, ByVal archivo As String, ByVal numeroFactura As String, ByVal SqlConnection As System.Data.SqlClient.SqlConnection, ByVal SqlTransaction As System.Data.SqlClient.SqlTransaction) As Boolean


        Dim retornoAux As Boolean = True
        Dim retornoError As Boolean = False
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim nombreArchivoFinal As String = ""
        Dim SQLCommand As System.Data.SqlClient.SqlCommand
        Dim IdSello As String = ""
        Dim algoritmoUtilizado As String = "2"
        Dim SDigPassword As String = "", usuarioWEBService As String = "", passwordWEBService As String = ""
        InstrSQL = "SELECT * FROM SelloDigital WHERE SDigIdEmpresa = '" + IdEmpresa + "'"

        SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
        SQLCommand.Transaction = SqlTransaction
        DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "SelloDigital")
        DataView = DataSet.Tables("SelloDigital").DefaultView

        If DataView.Count <> 0 Then
            SDigPassword = DataView(0)("SDigPassword").ToString
            usuarioWEBService = DataView(0)("SDigEdicomUsuario").ToString
            passwordWEBService = DataView(0)("SDigEdicomPassword").ToString
            IdSello = DataView(0)("SDigIdSelloDigital").ToString
        End If

        Dim pathSello As String = Server.MapPath("../../UPLOAD/SelloDigital")
        Dim pathCER As String = (pathSello + "\" + IdSello + ".cer")
        Dim pathKEY As String = (pathSello + "\" + IdSello + ".key")

        Dim firmaValidaXML As String = ""
        Dim instance As FirmaSAT.HashAlgorithm
        instance = FirmaSAT.HashAlgorithm.Sha1

        If algoritmoUtilizado = "1" Then instance = FirmaSAT.HashAlgorithm.Md5
        Dim archivoXMLFirmado As String = rutaXML.Replace(".XML", "2.XML")
        firmaValidaXML = Sat.SignXml(archivoXMLFirmado, rutaXML, pathKEY, SDigPassword, pathCER, instance)

        If firmaValidaXML <> "0" Then
            mensajeError = FirmaSAT.General.ErrorLookup(firmaValidaXML)
            fnTimbraXML = True
            Exit Function
        End If

        Dim archivoSinExtension As String = archivo.Replace(".XML", "")
        Dim archivoZIPEnviar As String = Server.MapPath("../../UPLOAD/XML/" + archivoSinExtension + ".zip")
        Dim archivoZIPRespuesta As String = Server.MapPath("../../UPLOAD/XML/" + archivoSinExtension + "Timbrado.zip")
        Dim carpetaXMLTimbrado As String = Server.MapPath("../../UPLOAD/XML")
        Dim archivoXMLTimbrado As String = Server.MapPath("../../UPLOAD/XML/" + archivoSinExtension + "Timbrado.xml")

        Dim serverName As String = Request.ServerVariables("SERVER_NAME").ToUpper
        Dim archivoTimbreRespuesta As String = pathSello.Replace("selloDigital", "XML") + "\" + archivoSinExtension + "Timbre.xml"
        Dim archivoAcuseRespuesta As String = pathSello.Replace("selloDigital", "XML") + "\" + archivoSinExtension + "Acuse.xml"
        Dim codigoRespuesta As String
        Dim claseXpide As New timbradoExpide

        Try
            claseXpide.passwordWeb = passwordWEBService
            claseXpide.usuarioWeb = usuarioWEBService

            ' pruebas

            If 1 = 1 Then

                Dim respuestaPrueba As mx.com.expidetufactura.pruebastimbrado.respuestaTimbrado
                respuestaPrueba = claseXpide.fnTimbraPrueba(objetoClases.fnFileToByteArray(archivoXMLFirmado))
                archivoTimbreRespuesta = respuestaPrueba.timbre
                codigoRespuesta = respuestaPrueba.codigo
                mensajeError = respuestaPrueba.mensaje
            Else
                Dim respuestaReal As mx.com.expidetufactura.timbradodp.respuestaTimbrado
                respuestaReal = claseXpide.fnTimbraR(objetoClases.fnFileToByteArray(archivoXMLFirmado))
                archivoTimbreRespuesta = respuestaReal.timbre
                codigoRespuesta = respuestaReal.codigo
                mensajeError = respuestaReal.mensaje
            End If


            Dim claveError As Integer = 0
            If codigoRespuesta <> "200" Then claveError = 1

            If claveError = 1 Then
                Response.Write("<script>parent.alerta('" + mensajeError + "');</script>")
                fnTimbraXML = False
                retornoAux = False
                Exit Function
            End If


        Catch ex As Exception

        End Try


        Dim archivoTimbreRespuesta2 As String = pathSello.Replace("selloDigital", "XML") + "\" + archivoSinExtension + "Timbre.xml"
        Dim archivoAcuseRespuesta2 As String = pathSello.Replace("selloDigital", "XML") + "\" + archivoSinExtension + "Acuse.xml"

        Dim streamWriter As System.IO.StreamWriter = System.IO.File.CreateText(archivoTimbreRespuesta2)
        streamWriter.WriteLine(archivoTimbreRespuesta)
        streamWriter.Close()

        Dim archivoResultanteXML As String = archivoTimbreRespuesta2


        Dim objReader As StreamReader
        Dim xmlFirmado As String = ""
        objReader = New StreamReader(archivoResultanteXML)

        Do While objReader.Peek() >= 0
            xmlFirmado = xmlFirmado + objReader.ReadLine()
        Loop
        objReader.Close()
        Dim xmlCadenaOriginal As String = FirmaSAT.Sat.MakePipeStringFromXml(archivoResultanteXML)

        Dim elementName As String = "cfdi:Comprobante"
        Dim attributeName As String = "sello"
        Dim selloDigitalObtenido As String = FirmaSAT.Sat.GetXmlAttribute(archivoResultanteXML, attributeName, elementName)
        attributeName = "certificado"
        Dim certificadoDigitalObtenido As String = FirmaSAT.Sat.GetXmlAttribute(archivoResultanteXML, attributeName, elementName)


        InstrSQL = "UPDATE PagoFacturaDigital SET PFDigCadenaOriginal= @PFDigCadenaOriginal,PFDigSelloDigital = @PFDigSelloDigital ,PFDigXMLTimbrado = @PFDigXMLTimbrado,PFDigXML = @PFDigXML,PFDigCertificadoDigital=@PFDigCertificadoDigital WHERE PFDigIdFactura = " + numeroFactura + " AND PFDigIdEmpresa='" + IdEmpresa + "'"
        SQLCommand = New SqlClient.SqlCommand("SELECT * FROM PagoFacturaDigital WHERE PFDigIdFactura = " + numeroFactura + " AND PFDigIdEmpresa='" + IdEmpresa + "'", SqlConnection)
        SQLCommand.Transaction = SqlTransaction

        DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "PagoFacturaDigital")
        Dim dt As System.Data.DataTable = DataSet.Tables("PagoFacturaDigital")
        dt.Rows(0)("PFDigCadenaOriginal") = xmlCadenaOriginal
        dt.Rows(0)("PFDigSelloDigital") = selloDigitalObtenido
        dt.Rows(0)("PFDigXMLTimbrado") = xmlFirmado
        dt.Rows(0)("PFDigXML") = xmlFirmado
        dt.Rows(0)("PFDigCertificadoDigital") = certificadoDigitalObtenido

        SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
        SQLCommand.Transaction = SqlTransaction


        SQLCommand.Parameters.Add("@PFDigCadenaOriginal", _
                SqlDbType.Text, 80000, "PFDigCadenaOriginal")
        SQLCommand.Parameters.Add("@PFDigSelloDigital", _
                   SqlDbType.Text, 80000, "PFDigSelloDigital")
        SQLCommand.Parameters.Add("@PFDigXMLTimbrado", _
                   SqlDbType.Text, 5000000, "PFDigXMLTimbrado")
        SQLCommand.Parameters.Add("@PFDigXML", _
                   SqlDbType.Text, 5000000, "PFDigXML")
        SQLCommand.Parameters.Add("@PFDigCertificadoDigital", _
                   SqlDbType.Text, 80000, "PFDigCertificadoDigital")

        DataAdapter.UpdateCommand = SQLCommand

        DataAdapter.Update(DataSet, "PagoFacturaDigital")

        InstrSQL = "EXEC [dbo].[spNombraXML]'" + numeroFactura + "', '" + IdEmpresa + "',0"
        SQLCommand = New SqlClient.SqlCommand(InstrSQL, SqlConnection)
        SQLCommand.Transaction = SqlTransaction
        DataAdapter = New System.Data.SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "nombreArchivo")
        DataView = DataSet.Tables("nombreArchivo").DefaultView
        If DataView.Count <> 0 Then nombreArchivoFinal = DataView(0)("nombreArchivo").ToString

        If nombreArchivoFinal <> "" Then
            archivoXMLTimbrado = Server.MapPath("../../UPLOAD/XML/" + nombreArchivoFinal + ".xml")
            System.IO.File.Copy(archivoResultanteXML, archivoXMLTimbrado, True)
            System.IO.File.Delete(archivoResultanteXML)
        End If

        If retornoAux = False Then
            retornoAux = False
        Else
            retornoAux = True
        End If

        Return retornoAux
    End Function


End Class