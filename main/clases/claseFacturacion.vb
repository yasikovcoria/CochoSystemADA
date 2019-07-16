Imports CryptoSysPKI
Imports System
Imports System.IO
Imports System.Text
Imports System.Xml.Xsl
Imports System.Security.Cryptography.X509Certificates
Imports System.Security.Cryptography

Public Class timbradoExpide

    Private usuarioWebServicio As String
    Public Property usuarioWeb() As String
        Get
            Return usuarioWebServicio
        End Get
        Set(ByVal value As String)
            usuarioWebServicio = value
        End Set
    End Property

    Private passwordWebService As String
    Public Property passwordWeb() As String
        Get
            Return passwordWebService
        End Get
        Set(ByVal value As String)
            passwordWebService = value
        End Set
    End Property

    Private UUIDWebService As String
    Public Property UUIDWeb() As String
        Get
            Return UUIDWebService
        End Get
        Set(ByVal value As String)
            UUIDWebService = value
        End Set
    End Property

    Private noCertificadoWebService As String
    Public Property noCerticado() As String
        Get
            Return noCertificadoWebService
        End Get
        Set(ByVal value As String)
            noCertificadoWebService = value
        End Set
    End Property

    Private emisorUUID As String
    Public Property emisor() As String
        Get
            Return emisorUUID
        End Get
        Set(ByVal value As String)
            emisorUUID = value
        End Set
    End Property




    Public Function fnTimbraPrueba(ByVal archivoXML() As Byte) As mx.com.expidetufactura.pruebastimbrado.respuestaTimbrado
        Dim retornoTimbradoPrueba As mx.com.expidetufactura.pruebastimbrado.respuestaTimbrado
        Dim clienteWeb As mx.com.expidetufactura.pruebastimbrado.TimbradoWSService = New mx.com.expidetufactura.pruebastimbrado.TimbradoWSService()
        retornoTimbradoPrueba = clienteWeb.timbrar(usuarioWeb, passwordWeb, archivoXML)
        Return retornoTimbradoPrueba
    End Function

    Public Function fnCancelaPrueba() As mx.com.expidetufactura.timbradoP.respuestaCancelacion
        Dim respuestaCancelacion As mx.com.expidetufactura.timbradoP.respuestaCancelacion
        Dim clienteCancelacionPrueba As mx.com.expidetufactura.timbradoP.TimbradoTXTService = New mx.com.expidetufactura.timbradoP.TimbradoTXTService()
        respuestaCancelacion = clienteCancelacionPrueba.cancelarUUID(usuarioWeb, passwordWeb, noCerticado, UUIDWeb, emisor)

        Return respuestaCancelacion
    End Function


    Public Function fnTimbraR(ByVal archivoXML() As Byte) As mx.com.expidetufactura.timbradodp.respuestaTimbrado
        Dim retornoTimbradoR As mx.com.expidetufactura.timbradodp.respuestaTimbrado
        Dim clienteWeb As mx.com.expidetufactura.timbradodp.TimbradoWSService = New mx.com.expidetufactura.timbradodp.TimbradoWSService()
        retornoTimbradoR = clienteWeb.timbrar(usuarioWeb, passwordWeb, archivoXML)
        Return retornoTimbradoR
    End Function


    Function fnCancelaReal(ByVal usuarioCancela As String, ByVal passwordCancela As String, ByVal archivoXML As Byte()) As mx.com.expidetufactura.cancelacionProductivo.respuestaCancelacion
        Dim respuestaCancela As mx.com.expidetufactura.cancelacionProductivo.respuestaCancelacion
        Dim objetoWebService As mx.com.expidetufactura.cancelacionProductivo.CancelacionProductivo = New mx.com.expidetufactura.cancelacionProductivo.CancelacionProductivo()
        respuestaCancela = objetoWebService.cancelar(usuarioCancela, passwordCancela, archivoXML)
        Return respuestaCancela
    End Function


End Class


Public Class selloBase64
    Function fnBase64Cert(ByVal PathCert As String) As String
        Return X509.ReadStringFromFile(PathCert)
    End Function

    Function fnObtenCadena(ByVal pathXMLTimbrar As String, ByVal pathXSLTCadena As String, ByVal pathTemp As String) As String
        Dim stylesheetUri As String = pathXSLTCadena
        Dim inputUri As String = pathXMLTimbrar
        Dim tempFileName As String = Path.GetTempFileName()

        Dim compiledTransform As XslCompiledTransform = New XslCompiledTransform()
        Using text As StreamWriter = File.CreateText(tempFileName)
            text.Close()
        End Using
        Dim str As String
        Dim excepcion As Exception

        If File.Exists(tempFileName) Then
            Try
                compiledTransform.Load(stylesheetUri)
                compiledTransform.Transform(inputUri, tempFileName)
                str = New StreamReader(tempFileName, Encoding.GetEncoding(437), True).ReadToEnd()
            Catch ex As Exception
                excepcion = ex
                str = "1"
            End Try
        Else
            File.CreateText(tempFileName)
            Try
                compiledTransform.Load(stylesheetUri)
                compiledTransform.Transform(inputUri, tempFileName)
                str = New StreamReader(tempFileName, Encoding.GetEncoding(437), True).ReadToEnd()
            Catch ex As Exception
                excepcion = ex
                str = excepcion.Message
            End Try
        End If

        Return str
    End Function



    'Public Function fnSelloCochoCFDI(strPassword As String, strKeyFileRuta As String, CadenaOriginal As String) As String
    '    Dim str As String = "1"


    '    Dim stringBuilder1 As New StringBuilder()
    '    Dim numArray1 As Byte() = Hash.BytesFromBytes(Encoding.UTF8.GetBytes(CadenaOriginal), DirectCast(0, HashAlgorithm))
    '    If numArray1.Length <= 0 Then
    '        Return str
    '    End If
    '    Dim stringBuilder2 As StringBuilder = Rsa.ReadEncPrivateKey(strKeyFileRuta, strPassword)
    '    If stringBuilder2.Length = 0 Then
    '        Return str
    '    End If
    '    Dim numArray2 As Byte() = Rsa.EncodeDigestForSignature(Rsa.KeyBytes(stringBuilder2.ToString()), numArray1, DirectCast(0, HashAlgorithm))
    '    If numArray2.Length = 0 Then
    '        Return str
    '    End If
    '    Dim inArray As Byte() = Rsa.RawPrivate(numArray2, stringBuilder2.ToString())
    '    Wipe.[String](stringBuilder2)
    '    Return Convert.ToBase64String(inArray)
    'End Function


    Public Function fnSello33(strPassword As String, pfxByte() As Byte, CadenaOriginal As String)
        Dim privateCert As New X509Certificate2(pfxByte, strPassword, X509KeyStorageFlags.Exportable)
        Dim privateKey As RSACryptoServiceProvider = DirectCast(privateCert.PrivateKey, RSACryptoServiceProvider)
        Dim privateKey1 As New RSACryptoServiceProvider()
        privateKey1.ImportParameters(privateKey.ExportParameters(True))

        Dim streamReaderCadena As New MemoryStream(Encoding.UTF8.GetBytes(CadenaOriginal))

        Dim signature As Byte() = privateKey1.SignData(streamReaderCadena, "SHA256")

        Dim sello256 As String = Convert.ToBase64String(signature)

        Dim isValid As Boolean = privateKey1.VerifyData(Encoding.UTF8.GetBytes(CadenaOriginal), "SHA256", signature)

        Return sello256
    End Function


End Class