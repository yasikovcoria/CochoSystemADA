<%
response.expires = 0
response.expiresabsolute = Now() -1
response.addHeader "pragma","no-cache"
response.addHeader "cache-control","private"
response.addHeader "cache-control","must-revalidate"
response.addHeader "cache-control","no-store"
Response.CacheControl = "no-cache"
Response.Buffer = TRUE

DIM GVIdSesion,GVIdEmpresa,GVIdUsuario,GVNombreUsuario,GVTitulo,GVNombreEmpresa,GVIdPerfil,GVInstruccionSQL,GVIPCliente
DIM GVMainRS,GVMainDB,GVAplicacion,GVReportesMaximos,GVEnvioCotizacion,GVInicialUsuario,GVNick,bgcolor,GVIdSolicitoCliente
DIM GlobalDriverLetter
GlobalDriverLetter="X:\"

GVReportesMaximos = 0
GVAplicacion = "FacturacionCFDI"
GVIdSolicitoCliente=0

IF tipoSubmit = true THEN 
 GVIdSesion = "2583"
 GVEnvioCotizacion = ""
 IF GVIdSesion = "" THEN GVIdSesion=FormularioArchivos.QueryString("GVIdSesion")
 'Response.Write(GVIdSesion&"sss")
ELSE
 GVIdSesion = Request("GVIdSesion")
 GVEnvioCotizacion = Request("GVEnvioCotizacion")
 GVEnvioCotejo = Request("GVEnvioCotejo")
 GVIdSolicitoCliente = Request("GVIdSolicitoCliente") 
 bgcolor = request("bgcolor")
 IF bgcolor="" THEN bgcolor = "white"
END IF



IF CSTR(GVIdSolicitoCliente) = "1" THEN
 GVIdEmpresa = Request("GVIdEmpresa")
 GVAplicacion = "FacturacionCFDI"
 CALL fnAbreDB(GVMainDB,GVAplicacion)
 GVInstruccionSQL = "EXEC spComparecienteRemoto" & GVIdEmpresa & " '" & GVIdSesion & "','" & GVIdEmpresa & "','','','','','','',0"
 CALL fnAbreRS(GVMainRS,GVMainDB,GVInstruccionSQL)
 GVAplicacion = "NOTARIAL" & GVIdEmpresa
 GVIPCliente = ""
 GVNombreUsuario = "????"
 GVTitulo = ""
 GVNombreEmpresa = ""
 GVIdPerfil = -1
ELSE


GVIdSesion = "2583"
GVIdUsuario = "1"
GVInicialUsuario =  ""
GVIdEmpresa = "HGOV14"
GVAplicacion = "FacturacionCFDI"
GVIPCliente ="localhost"
GVNombreUsuario = "eduardo coria"
GVTitulo = "1"
GVNombreEmpresa = "TRANSPORTES"
GVNick = "chaparrita1994A"
GVIdPerfil = "1"
CALL fnCierraRS(GVMainRS)
CALL fnCierraDB(GVMainDB)




END IF
%>