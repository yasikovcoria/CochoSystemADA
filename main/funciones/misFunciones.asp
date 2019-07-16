<%
PUBLIC SUB fnAbreDB()
dim Conn
 Set Conn = Server.CreateObject("ADODB.Connection")
DSNtest="DRIVER={SQL Server};SERVER=EDUARDOCORIA\SQLSERVER;UID=eduardo;PWD=chaparrita1994A;DATABASE=FacturacionCFDI"
Conn.open DSNtest
Response.Write(Conn)
response.End()
 
END SUB

PUBLIC SUB fnAbreRS(fnARSInstrSQL)
Response.Write(fnARSRS)
 Set fnARSRS = Server.CreateObject("ADODB.Recordset")
 fnARSRS.Open fnARSInstrSQL,fnAbreDB

END SUB

PUBLIC SUB fnCierraRS(fnCRSRS)

 
END SUB

PUBLIC SUB fnCierraDB(fnAbreDB)
 fnCDBDB.Close
 Set fnCDBDB = NOTHING
END SUB

FUNCTION fnRedondea(numero)
 entero = CInt(numero)
 flotante = numero - entero
 IF numero < 1 THEN 
  flotante = 0
  entero = 1
 END IF
 IF flotante >0 AND flotante < 1 THEN entero = entero + 1
 fnRedondea = entero
END FUNCTION
 
FUNCTION fnConstruyeImagen(imagen,borde,onclick,onMouseOver,onMouseOut,alt) 'FUNCION PARA ESCRIBIR UNA IMAGEN
 fnConstruyeImagen = "<img src=""" & imagen & """ border=""" & borde & """ align=""absmiddle"" " _
  & " onclick=""" & onclick & """ onMouseOver=""" & onMouseOver & """ onMouseOut=""" & onMouseOut & """ " _
  & " alt=""" & alt & """>"
END FUNCTION
 
FUNCTION fnInputText(valor,nombre,id,clase,longMax,ancho,readOnly)
 fnInputText = "<input name=""" & nombre & """ type=""text"" style=""width=" & ancho & """ maxlength=""" & longMax & """" _
  & "class=""" & clase & """ id=""" & id & """" & "value=""" & valor & """ " & readOnly & ">"
END FUNCTION 

FUNCTION fnInputHidden(valor,nombre,id)
 fnInputHidden = "<input name=""" & nombre & """ id=""" & id & """ type=""hidden"" value=""" & valor & """>"
END FUNCTION 

FUNCTION fnInputRadio(valor,nombre,id)
 fnInputRadio = "<input name=""" & nombre & """ id=""" & id & """ type=""radio"" value=""" & valor & """>"
END FUNCTION 

FUNCTION fnInputchkbox(valor,nombre,id,opciones)
 fnInputchkbox = "<input name=""" & nombre & """ id=""" & id & """ type=""checkbox"" value=""" & valor & """ " & opciones & ">"
END FUNCTION 

FUNCTION fnInputSelect(nombre,id,clase,ancho,disabled)
 fnInputSelect = "<select name=""" & nombre & """ id=""" & id & """ class=""" & clase & """ style=""width=" & ancho & "px"" " & disabled & "></select>"
END FUNCTION

FUNCTION fnObtieneFileOfString(strSeparador,strCadena)
  Dim strPosicion
  strPosicion = 0
  posicion = instr(strCadena,strSeparador)
  while not posicion = 0
   strCadena=right(strCadena,len(strCadena)-posicion)
   posicion=instr(strCadena,strSeparador)
  wend
  fnObtieneFileOfString = strCadena
END FUNCTION



Function fnFormatoMoneda(valor,ceros)
  Dim mndValor
  mndValor = valor
  if isnull(mndValor) Then mndValor = ""
  mndValor = replace(mndValor,"$","")
  mndValor = replace(mndValor,",","")
  If isnumeric(mndValor) then mndValor = Replace(FormatCurrency(mndValor,ceros),"$","")
  fnFormatoMoneda = mndValor
 End Function

 Function fnFormatoPorcentaje(valor,ceros)
  Dim mndValor
  mndValor = valor
  if isnull(mndValor) Then mndValor = ""
  mndValor = replace(mndValor,"%","")
  mndValor = replace(mndValor,",","")
  If isnumeric(mndValor) then mndValor = FormatPercent(mndValor/100,ceros)
  fnFormatoPorcentaje = mndValor
 End Function
 
 Function fnFormatoNumero(valor,ceros)
  Dim mndValor
  mndValor = valor
  if isnull(mndValor) Then mndValor = ""
  mndValor = replace(mndValor,"%","")
  mndValor = replace(mndValor,",","")
  If isnumeric(mndValor) then mndValor = FormatNumber(mndValor,ceros)
  fnFormatoNumero = mndValor
 End Function
 
  Function fnRetornaValor(cadena,separador,numSep)
  Dim valor1
  Dim arregloValor
   arregloValor = SPLIT(cadena,separador)
   if(numSep <= UBound(arregloValor)+1) THEN
    valor1=arregloValor(numSep-1)
   END IF
  fnRetornaValor=valor1
 END FUNCTION
 
 Function fnConvertMoneyToSQL(valor)
 
  valor = replace(valor,"$","")
  valor = replace(valor,",","")
  valor = replace(valor,"%","")
  IF NOT ISNUMERIC(valor) THEN valor = 0
  
  fnConvertMoneyToSQL = CDBL(valor)
 
 END FUNCTION 

SUB fnPieTabla(sizeTable,columnas)
 Response.Write "</table>"
END SUB
 
SUB fnEscribeColumna(clase,valor,width,align,valign,colspan) 'FUNCION PARA ESCRIBIR UNA COLUMNA
 Response.Write "<td class=""" & clase & """ align=""" & align & """ valign=""" & valign & """ width=""" _
  & width & """ colspan=""" & colspan & """>" & valor & "</td>"
END SUB

FUNCTION fnGetCriterio(strCampo,strCadenaBusqueda)	
'Funcion que crea el criterio de busqueda de registros con varios criterios

'Declara variables 
DIM strCadena
DIM strTemp
DIM intVeces
DIM intPosMas
DIM intPosMenos
DIM intPosIni
DIM intPosFinal
'Se evalue la presencia de los signos de mas o menos
intPosMas = INSTR(strCadenaBusqueda,"+")
intPosMenos = INSTR(strCadenaBusqueda,"-xxxxxx")
	
IF intPosMas = 0 and intPosMenos = 0 THEN 
	Globalflg=1
	strCadena = "Where"
	strCadena = strCadena & " " & strCampo & " like " & "'%" & strCadenaBusqueda & "%'"
	fnGetCriterio = strCadena
	exit FUNCTION
END IF
'Obtiene la longitud de la cadena general
lngCadena=len(strCadenaBusqueda)
'Inicializa valores
	strCadena =""
	intPosIni = 1
	
	'Quita el ultimo caracter si es un operador (+)(-)
	IF mid(strCadenaBusqueda,lngCadena,1) = "+" or mid(strCadenaBusqueda,lngCadena,1) = "-" THEN
		strCadenaBusqueda = mid(strCadenaBusqueda,1,lngCadena-1)
	END IF 
	
	'Busca la posicion de los caracteres (+)(-)
	intPosMas = INSTR(strCadenaBusqueda,"+")
	intPosMenos = INSTR(strCadenaBusqueda,"-xxxxxx")				
		
	IF intPosMas = 0 and intPosMenos = 0 THEN 'Si no tiene ningun caracter (+)((-) retorna la cadena original
		strCadena = "WHERE " & strCadena & " " & strCampo & " like " & "'%" & strCadenaBusqueda & "%'"	
	ELSE
		'Recorre la cadena 	
		for i = 1 to lngCadena - 1
			strTemp = mid(strCadenaBusqueda,i,1)
			
			'Valida el tipo de caracter
			IF strTemp="+" or strTemp="-xxxxxx" THEN
					'Valida la posicion de los carateres (+)(-)
					intPosMas = INSTR(mid(strCadenaBusqueda,intPosIni,i),"+")
					intPosMenos = INSTR(mid(strCadenaBusqueda,intPosIni,i),"-xxxxxx")				
						
					'Asigna la posicion final de la cadena a extraer
					IF intPosMas = 0 and  intPosMenos = 0 THEN
						intPosFinal = (lngCadena - 1)
					ELSEIF intPosMas <> 0 and  intPosMenos = 0 THEN
						intPosFinal = (intPosMas - 1)
					ELSEIF intPosMas = 0 and intPosMenos <> 0 THEN
						intPosFinal = (intPosMenos - 1)
					ELSE
						IF intPosMas < intPosMenos THEN
							intPosFinal = (intPosMas - 1)
						ELSE
							intPosFinal = (intPosMenos - 1)
						END IF					
					END IF
	
				
					IF strTemp="+" THEN
						IF  TRIM(strCadena) = "" THEN
							strCadena = strCadena +" Where " +  strCampo + " like '%"
						END IF				

						IF i = 1 THEN
							strCadena= strCadena + mid(strCadenaBusqueda,intPosIni,intPosFinal) '+ "%'" 					
						ELSE
							strCadena= strCadena + mid(strCadenaBusqueda,intPosIni,intPosFinal) + "%' and " + strCampo + " like '%" 					
						END IF 
						
						intPosMas = INSTR(mid(strCadenaBusqueda,i+1),"+")
						intPosMenos = INSTR(mid(strCadenaBusqueda,i+1),"-xxxxxx")	
									
						IF intPosMas = 0 and  intPosMenos = 0 THEN
							strCadena= strCadena + mid(strCadenaBusqueda,i+1) + "%'"
						END IF
						
					ELSEIF strTemp="-" THEN
						IF  TRIM(strCadena) = "" THEN
							strCadena = strCadena +" Where " +  strCampo + " NOT like '%"
						END IF				

						IF i = 1 THEN
							strCadena= strCadena + mid(strCadenaBusqueda,intPosIni,intPosFinal) '+ "%'" 					
						ELSE
						
						strCadena= strCadena + mid(strCadenaBusqueda,intPosIni,intPosFinal) + "%' and " + strCampo + " NOT like '%" 					
						END IF
						
						intPosMas = INSTR(mid(strCadenaBusqueda,i+1),"+")
						intPosMenos = INSTR(mid(strCadenaBusqueda,i+1),"-xxxxxx")				
						IF intPosMas = 0 and  intPosMenos = 0 THEN
							strCadena= strCadena + mid(strCadenaBusqueda,i+1) + "%'"
						END IF
					END IF
					'Asigna la nueva posicion Inicial
					intPosIni = i + 1
		 END IF
		next
	END IF
	'Asigna la cadena final de retorno
	fnGetCriterio=lTRIM(strCadena)	
END FUNCTION

FUNCTION fnTraeFechaYa(idFecha)
 IF NOT isdate(idFecha) THEN 
  auxFecha = ""
 ELSE
  auxFecha = fnPonerCeros(day(idFecha),2,1) & "/" &  fnPonerCeros(month(idFecha),2,1) & "/" & year(idFecha)
 END IF
 fnTraeFechaYa = auxFecha
END FUNCTION
 
PUBLIC FUNCTION fnNombreMes(idMes)
  IF idMes = 1 THEN fnNombreMes = "Enero"
  IF idMes = 2 THEN fnNombreMes = "Febrero"
  IF idMes = 3 THEN fnNombreMes = "Marzo"
  IF idMes = 4 THEN fnNombreMes = "Abril"
  IF idMes = 5 THEN fnNombreMes = "Mayo"
  IF idMes = 6 THEN fnNombreMes = "Junio"
  IF idMes = 7 THEN fnNombreMes = "Julio"
  IF idMes = 8 THEN fnNombreMes = "Agosto"
  IF idMes = 9 THEN fnNombreMes = "Septiembre"
  IF idMes = 10 THEN fnNombreMes = "Octubre"
  IF idMes = 11 THEN fnNombreMes = "Noviembre"
  IF idMes = 12 THEN fnNombreMes = "Diciembre"
END FUNCTION
 
 PUBLIC FUNCTION fnPonerCeros(variable,ceros,orden)
	 DIM i
	 i=0
		IF len(variable) > cint(ceros) THEN exit FUNCTION
		IF variable <> "" THEN
			IF isnumeric(variable) THEN
				for i=1 to (cint(ceros)-len(variable))
				  IF orden = 1 THEN
					variable = "0" & variable
				  ELSE
				   variable = variable & "0"
				  END IF
				next
			ELSE
				fnPonerCeros = ""
				exit FUNCTION
			END IF
		END IF
		fnPonerCeros=variable
	END FUNCTION
	
	PUBLIC FUNCTION fnNroEnLetras(curNumero,blnO_Final)
	IF NOT ISNUMERIC(curNumero) or ISNULL(curNumero) THEN
	 fnNroEnLetras = ""
	 exit FUNCTION
	END IF
	DIM dblCentavos
    DIM lngContDec
    DIM lngContCent
    DIM lngContMil
    DIM lngContMillon
    DIM strNumLetras
    DIM strNumero
    DIM strDecenas
    DIM strCentenas
    DIM blnNegativo
    DIM blnPlural
    
    IF Int(curNumero) = 0 THEN
        strNumLetras = "CERO"
    END IF
    
    strNumero = Array(vbNullString, "UN", "DOS", "TRES", "CUATRO", "CINCO", "SEIS", "SIETE", _
                   "OCHO", "NUEVE", "DIEZ", "ONCE", "DOCE", "TRECE", "CATORCE", _
                   "QUINCE", "DIECISEIS", "DIECISIETE", "DIECIOCHO", "DIECINUEVE", _
                   "VEINTE")

    strDecenas = Array(vbNullString, vbNullString, "VEINTI", "TREINTA", "CUARENTA", "CINCUENTA", "SESENTA", _
                    "SETENTA", "OCHENTA", "NOVENTA", "CIEN")

    strCentenas = Array(vbNullString, "CIENTO", "DOSCIENTOS", "TRESCIENTOS", _
                     "CUATROCIENTOS", "QUINIENTOS", "SEISCIENTOS", "SETECIENTOS", _
                     "OCHOCIENTOS", "NOVECIENTOS")

    IF curNumero < 0 THEN
        blnNegativo = True
        curNumero = Abs(curNumero)
    END IF

    IF Int(curNumero) <> curNumero THEN
        dblCentavos = Abs(curNumero - Int(curNumero))
        curNumero = Int(curNumero)
    END IF

    DO WHILE curNumero >= 1000000
        lngContMillon = lngContMillon + 1
        curNumero = curNumero - 1000000
    LOOP

    DO WHILE curNumero >= 1000
        lngContMil = lngContMil + 1
        curNumero = curNumero - 1000
    LOOP
    
    DO WHILE curNumero >= 100
        lngContCent = lngContCent + 1
        curNumero = curNumero - 100
    LOOP
    
    IF NOT (curNumero > 10 And curNumero <= 20) THEN
        DO WHILE curNumero >= 10
            lngContDec = lngContDec + 1
            curNumero = curNumero - 10
        LOOP
    END IF
    
    IF lngContMillon > 0 THEN
        IF lngContMillon >= 1 THEN   'si el número es >1000000 usa recursividad
            strNumLetras = fnNroEnLetras(lngContMillon, False)
            IF NOT blnPlural THEN blnPlural = (lngContMillon > 1)
            lngContMillon = 0
        END IF
		DIM AuxPlural 
		AuxPlural = " "
		IF(blnPlural) THEN AuxPlural = "ES "
        strNumLetras = TRIM(strNumLetras) & strNumero(lngContMillon) & " MILLON" & AuxPlural '& _
        'IIF(blnPlural, "ES ", " ")
    END IF
    
    IF lngContMil > 0 THEN
        IF lngContMil >= 1 THEN   'si el número es >100000 usa recursividad
            strNumLetras = strNumLetras & fnNroEnLetras(lngContMil, False)
            lngContMil = 0
        END IF
        strNumLetras = TRIM(strNumLetras) & strNumero(lngContMil) & " MIL "
    END IF
    
    IF lngContCent > 0 THEN
        IF lngContCent = 1 And lngContDec = 0 And curNumero = 0 THEN
            strNumLetras = strNumLetras & "CIEN "
        ELSE
            strNumLetras = strNumLetras & strCentenas(lngContCent) & " "
        END IF
    END IF
    
    IF lngContDec >= 1 THEN
        IF lngContDec = 1 THEN
            strNumLetras = strNumLetras & strNumero(10)
        ELSE
            strNumLetras = strNumLetras & strDecenas(lngContDec)
        END IF
        
        IF lngContDec >= 3 And curNumero > 0 THEN
            strNumLetras = strNumLetras & " Y "
        END IF
    ELSE
        IF curNumero >= 0 And curNumero <= 20 THEN
            strNumLetras = strNumLetras & strNumero(curNumero)
            IF curNumero = 1 And blnO_Final THEN
                strNumLetras = strNumLetras & "O"
            END IF
            IF dblCentavos > 0 THEN
                strNumLetras = TRIM(strNumLetras) & " PESOS " & Cstr((CInt(dblCentavos * 100))) & "/100 M.N."
            END IF
            fnNroEnLetras =strNumLetras
            Exit FUNCTION
        END IF
    END IF
 
    IF curNumero > 0 THEN
        strNumLetras = strNumLetras & strNumero(curNumero)
        IF curNumero = 1 And blnO_Final THEN
            strNumLetras = strNumLetras & "O"
        END IF
    END IF
    
    IF dblCentavos > 0 THEN
        strNumLetras = strNumLetras & " PESOS " & Cstr(CInt(dblCentavos * 100)) & "/100 M.N."
    END IF
    fnNroEnLetras =strNumLetras
END FUNCTION

Public Function fnRetornaArchivo(PathArchivo)
  Dim auxiliarx
  auxiliarx = ""
  set fsObject=Server.CreateObject("Scripting.FileSystemObject")
  set importFileObj = fsObject.OpenTextFile(server.MapPath(PathArchivo))
  Do while not importFileObj.AtEndOfStream
    auxiliarx = auxiliarx & " " & importFileObj.readLine
  loop
  importFileObj.Close()
  Set importFileObj = Nothing
  Set fsObject = Nothing
  fnRetornaArchivo = auxiliarx
End Function

Public function fnIncrementa_0Z(incremento,valor)
' NUMERACIÓN (0-9),(A-Z)
 Dim numeracion(36)
 for i=0 to 9
  numeracion(i) = i
  j = 10
 next
 for i=65 to 90
  numeracion(j) = Chr(i)
  j=j+1
 next
 Dim x()
 ReDim x(len(valor))
 variable = valor
 for y =0 to CLng(incremento)-1
  incrementa = 1
  for cont = 0 to len(variable)-1
   x(cont) = mid(variable,cont+1,1)
  next
  for i=len(variable)-1 to 0 Step -1
   for j=0 to UBound(numeracion) - 1
    if UCase(x(i)) = UCase(numeracion(j)) Then
     if UCase(x(i)) <> "Z" Then
      x(i) = numeracion(j+1)
      incrementa = incrementa-1
     Else
	  x(i) = "0"
	 End If
    End If
    if incrementa=0 Then Exit For
   Next
   if incrementa=0 Then Exit For
  Next
  variable = ""
  for i=0 to Ubound(x) - 1
   variable = variable + UCase(x(i))
  Next
 Next
 fnIncrementa_0Z = variable
End Function

Function fnFormatoFecha(strfnFecha,strfnFormato)
 Dim strRetorno
 IF strfnFormato = "3" AND strfnFecha <> "" THEN
  strRetorno = mid(strfnFecha,7,4) & "/" & mid(strfnFecha,4,2) & "/" & mid(strfnFecha,1,2)
 ELSE
  strRetorno=""
 END IF
 fnFormatoFecha = strRetorno
End Function

Class DBClase
 Dim DB,varAplicacion,varCommandTimeout,varConexiones
 
 Private Sub Class_Initialize()
  varCommandTimeout=100
  varConexiones=0
 End Sub
 
 Public Property Let Conexiones(ByRef valor)
   varConexiones = valor
 End Property
 
 Public Property Get Conexiones()
   Conexiones = varConexiones
 End Property
 
 Public Property Let Aplicacion(ByRef valor)
   varAplicacion = valor
 End Property
 
 Public Property Let CommandTimeout(ByRef valor)
   varCommandTimeout = valor
 End Property
 
 Public Function incrementaConexiones()
  varConexiones=varConexiones+1
  incrementaConexiones = varConexiones
 End Function
 
 Public Sub Constructor(ByRef varAplicacionX,ByRef CommandTimeoutX)
  varCommandTimeout = CommandTimeoutX
  varAplicacion = varAplicacionX
  CALL fnAbreDB()
 End Sub

 PUBLIC SUB fnAbreDB()
  DIM fnADBDBCadena,fnADBDBpwd,fnADBDBpwdPwd,fnADBDBpwdUser,fnADBDBpwdDatabase,fnADBDBpwdServer
  Set DB = Server.CreateObject("ADODB.Connection")
  SET fnADBDBpwd = Server.CreateObject("Password.DBASystem")
  fnADBDBpwdPwd = fnADBDBpwd.ReturnPWD(varAplicacion,1)
  fnADBDBpwdUser = fnADBDBpwd.ReturnPWD(varAplicacion,2)
  fnADBDBpwdDatabase = fnADBDBpwd.ReturnPWD(varAplicacion,3)
  fnADBDBpwdServer = fnADBDBpwd.ReturnPWD(varAplicacion,5)
  SET fnADBDBpwd = NOTHING
  fnADBDBCadena = "Driver={SQL Server};Server=" & fnADBDBpwdServer& ";DATABASE=" & fnADBDBpwdDatabase & ";UID=" _
   & fnADBDBpwdUser & ";PWD=" & fnADBDBpwdPwd & ";"
  DB.CommandTimeout = varCommandTimeout
  DB.Open(fnADBDBCadena)
 END SUB


 PUBLIC SUB fnCierraDB()
  ON ERROR RESUME NEXT
  IF isobject(DB) THEN  DB.Close
 END SUB
 
 PUBLIC SUB Close()
  CALL fnCierraDB()
  Set DB = NOTHING
 END SUB

 Private Sub Class_Terminate()
  CALL Close()
 End Sub
END Class


Class RSClase
 Dim DBRecibido,RS,instrSQLRecibido,varCursorTypeEnum,varLockTypeEnum,varCommandTypeEnum,varExecuteOptionEnum 
 Public Property Let InstrSQL(ByRef valor)
   instrSQLRecibido = valor
 End Property
 
 Public Property Let CursorTypeEnum(ByRef valor)
   varCursorTypeEnum = valor
 End Property
 
 Public Property Let LockTypeEnum(ByRef valor)
   varLockTypeEnum = valor
 End Property
 
 Public Property Let CommandTypeEnum(ByRef valor)
   varCommandTypeEnum = valor
 End Property
 
 Public Property Let ExecuteOptionEnum(ByRef valor)
   varExecuteOptionEnum = valor
 End Property
 
 Public Sub Constructor(ByRef DBRecibidoX,ByRef instrSQLRecibidoX,ByRef varCursorTypeEnumX,ByRef varLockTypeEnumX,ByRef varCommandTypeEnumX,ByRef varExecuteOptionEnumX)
  IF NOT isobject(DBRecibido) THEN Set DBRecibido = Server.CreateObject("ADODB.Connection")
  DBRecibido = DBRecibidoX
  instrSQLRecibido = instrSQLRecibidoX
  varCursorTypeEnum = varCursorTypeEnumX
  varLockTypeEnum = varLockTypeEnumX
  varCommandTypeEnum = varCommandTypeEnumX
  varExecuteOptionEnum = varExecuteOptionEnumX
  'CALL fnCierraRS()
  CALL fnAbreRS()
 End Sub
 
 Public Property Let DB(ByRef valor)
  IF NOT isobject(DBRecibido) OR DBRecibido = NOTHING THEN Set DBRecibido = Server.CreateObject("ADODB.Connection")
  DBRecibido = valor
 End Property
 
 
 
 PUBLIC SUB fnAbreRS()
  CALL fnCierraRS()
  Set RS = Server.CreateObject("ADODB.Recordset")  
  RS.Open instrSQLRecibido,DBRecibido,varCursorTypeEnum,varLockTypeEnum,varCommandTypeEnum
 END SUB
 
 PUBLIC SUB fnCierraRS()
  ON ERROR RESUME NEXT
  IF isobject(RS) THEN
   RS.ActiveConnection = NOTHING
   RS.Close
   'Set RSX = NOTHING
  END IF
 END SUB
 
 PUBLIC SUB Close()
  CALL fnCierraRS()
  Set RS = NOTHING
  SET DBRecibido = NOTHING
 END SUB
 
 Private Sub Class_Terminate()
  CALL Close()
 End Sub

 
  
END Class


 Function fnEtapaXExpediente(etapa,leyenda,ancho,largo) 
  Dim totalEtapas ,iAuxiliar
  iAuxiliar=1
  totalEtapas =   CDBL(fnRetornaValor(fnRetornaValor(leyenda,"|",iAuxiliar),"?",6))
   IF ancho = "0" THEN
     ancho = "20"
   ELSE
    ancho=ancho*totalEtapas
   END IF
   IF largo = "0" THEN largo = "20"
   retorno = "<table border=1 cellpadding=""0px"" cellspacing=""0px"" bgcolor=""#FFFFFF""  bordercolor=""#000000"" width=""" & ancho & "px;""  height=""" & largo & "px;""><tr>"
   FOR iAuxiliar=1 TO totalEtapas
    retorno = retorno & "<td bgcolor=""" & fnRetornaValor(fnRetornaValor(leyenda,"|",iAuxiliar),"?",5) & """ onMouseOver=""popupTitle('ETAPA " & iAuxiliar & "','#0000FF', '" & fnRetornaValor(fnRetornaValor(leyenda,"|",iAuxiliar),"?",1)  & "','#000000', '#DCFCED',this);"" onMouseOut=""killPopupTitle();"">&nbsp;</td>"
   NEXT
   retorno = retorno & "</tr></table>"
  fnEtapaXExpediente=retorno
 END FUNCTION
 
Function fnVerificaFolios(auxiliar,claveDigital,idExpedienteDigital,addendaDigital)
   on error resume next
   Dim claveError,mensajeFolios
    Err.clear
	CALL fnAbreDB(MyDB,GVAplicacion)
	InstrSQL = "SET DATEFORMAT DMY SELECT [dbo].[fnVerificaTipoFolioExpediente](" & claveDigital& ",'" & GVIdEmpresa& "','" & idExpedienteDigital & "','" & fnTraeFechaYa(Date) & "',-1) AS esDigital"
	  
	  CALL fnAbreRS(RSRemision,GVMainDB,InstrSQL)
	  tipoFolio=fnRetornaValor(RSRemision.Fields("esDigital"),"|",1)
	  esDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",2)
	  idSelloFolio=fnRetornaValor(RSRemision.Fields("esDigital"),"|",3)
	  consecutivoDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",4)
	  certificadoDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",5)
	  numeroAprobacionDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",6)
	  serieDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",7)
	  fechaFolioDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",8)
	  idFolioDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",9)
	  CALL fnCierraRS(RSRemision)
	  
      'Response.Write("<br>"&InstrSQL)
	   InstrSQL=	"SELECT (FEleFolioFinal-FEleUltimoFolioUtilizado)-1 AS FoliosRestantes " _
	   				& " FROM FolioElectronico INNER JOIN dbo.SelloDigital ON SDigIdSelloDigital = FEleIdSelloDigital " _
					& " AND SDigIdEmpresa = FEleIdEmpresa WHERE FEleActivo=1 AND FEleIdEmpresa = '"&GVIdEmpresa & "'" _
					& " AND '"&fnTraeFechaYa(Now)&"'<DATEADD(DAY,1,SDigCaducidad) AND FEleIdFolioElectronico="& idFolioDigital
					
	  'Response.Write(InstrSQL)
	  mensajeFolios=""
	  CALL fnAbreRS(RSRemision,GVMainDB,InstrSQL)
	  
	  		IF RSRemision.Fields("FoliosRestantes")<=15 THEN 
				mensajeFolios="Sus folios electrónicos están por terminarse, le sugerimos trámitar una nueva serie.Quedan "&RSRemision.Fields("FoliosRestantes")&" folios."
				
			END IF
	  CALL fnCierraRS(RSRemision)
 
	CALL fnCierraDB(MyDB)
    fnVerificaFolios = mensajeFolios
End Function
 
 
 Function fnEtapaXExpediente(etapa,leyenda,ancho,largo) 
  Dim totalEtapas ,iAuxiliar
  iAuxiliar=1
  totalEtapas =   CDBL(fnRetornaValor(fnRetornaValor(leyenda,"|",iAuxiliar),"?",6))
   IF ancho = "0" THEN
     ancho = "20"
   ELSE
    ancho=ancho*totalEtapas
   END IF
   IF largo = "0" THEN largo = "20"
   retorno = "<table border=1 cellpadding=""0px"" cellspacing=""0px"" bgcolor=""#FFFFFF""  bordercolor=""#000000"" width=""" & ancho & "px;""  height=""" & largo & "px;""><tr>"
   FOR iAuxiliar=1 TO totalEtapas
    retorno = retorno & "<td bgcolor=""" & fnRetornaValor(fnRetornaValor(leyenda,"|",iAuxiliar),"?",5) & """ onMouseOver=""popupTitle('ETAPA " & iAuxiliar & "','#0000FF', '" & fnRetornaValor(fnRetornaValor(leyenda,"|",iAuxiliar),"?",1)  & "','#000000', '#DCFCED',this);"" onMouseOut=""killPopupTitle();"">&nbsp;</td>"
   NEXT
   retorno = retorno & "</tr></table>"
  fnEtapaXExpediente=retorno
 END FUNCTION

 
    'CAMBIOSAT
   FUNCTION fnProcesaFacturaDigital(auxiliar,claveDigital,idExpedienteDigital,addendaDigital,PFDigFormaPago,PFDigMetodoPago,PFDigCondicionPago,PFDigCuentaBanco )
  ' TERMINA CAMBIOSAT
  
   ON ERROR RESUME NEXT
	DIM retornoError
	DIM descripcionErrorWS ,errorWS
	 errorWS=0
	retornoError=0
	
	IF auxiliar=4 OR auxiliar=6 OR auxiliar=9 OR auxiliar=10  THEN
	   DIM esDigital,idSelloFolio,consecutivoDigital,serieDigital,tipoFolio
	   DIM certificadoDigital,numeroAprobacionDigital,fechaFolioDigital,idFolioDigital
	   DIM versionFolioElectronico
	  InstrSQL = "SET DATEFORMAT DMY SELECT [dbo].[fnVerificaTipoFolioExpediente](" & claveDigital& ",'" & GVIdEmpresa& "','" & idExpedienteDigital & "','" & fnTraeFechaYa(Date) & "',-1) AS esDigital"
	  
	  CALL fnAbreRS(RSRemision,GVMainDB,InstrSQL)
	  tipoFolio=fnRetornaValor(RSRemision.Fields("esDigital"),"|",1)
	  esDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",2)
	  idSelloFolio=fnRetornaValor(RSRemision.Fields("esDigital"),"|",3)
	  consecutivoDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",4)
	  certificadoDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",5)
	  numeroAprobacionDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",6)
	  serieDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",7)
	  fechaFolioDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",8)
	  idFolioDigital=fnRetornaValor(RSRemision.Fields("esDigital"),"|",9)
	  versionFolioElectronico=fnRetornaValor(RSRemision.Fields("esDigital"),"|",10)
	  CALL fnCierraRS(RSRemision)
	  
      'Response.Write("<br>"&InstrSQL)
	   
	  'claveDigital
	   
	  IF CSTR(esDigital)=1 THEN
	  DIM fechaFactura,fechaFacturaSAT,fechaFacturaSistema
	  fechaFactura = now
	  fechaFacturaSAT=year(fechaFactura)& "-" & fnPonerCeros(month(fechaFactura),2,1) & "-" & fnPonerCeros(day(fechaFactura),2,1)  _
	   & "T"&fnPonerCeros(hour(fechaFactura),2,1) & ":" & fnPonerCeros(minute(fechaFactura),2,1)& ":" & fnPonerCeros(second(fechaFactura),2,1)
	  fechaFacturaSistema=fnTraeFechaYa(fechaFactura)  _
	   & " "&fnPonerCeros(hour(fechaFactura),2,1) & ":" & fnPonerCeros(minute(fechaFactura),2,1)& ":" & fnPonerCeros(second(fechaFactura),2,1)
		'CAMBIOSAT
	  InstrSQL = "SET DATEFORMAT DMY INSERT INTO dbo.PagoFacturaDigital " _
	   & "(PFDigIdConsecutivo, PFDigIdExpediente, PFDigIdEmpresa, PFDigIdFolioElectronico, PFDigFolioElectronico, PFDigFecha, PFDigIdUsuario,PFDigFormaPago,PFDigMetodoPago,PFDigCondicionPago,PFDigCuentaBanco) " _
	   & " VALUES(" & claveDigital & ",'" & idExpedienteDigital& "','" & GVIdEmpresa & "'," & idFolioDigital & "," & consecutivoDigital & ",'" & fechaFacturaSistema & "','" _
	   & GVIdUuario & "','" & PFDigFormaPago & "','" & PFDigMetodoPago & "','" & PFDigCondicionPago & "','" & PFDigCuentaBanco & "')"
	  GVMainDB.Execute(InstrSQL)
	  'TERMINA CAMBIO SAT
	  
	  'Response.Write("<br>"&InstrSQL)
	  InstrSQL = "EXEC [dbo].[spReciboDigital" & GVIdEmpresa & "] '" & GVIdEmpresa & "','" & idExpedienteDigital & "','" & claveDigital & "' "
	  'Response.Write("<br>"&InstrSQL)
	  CALL fnAbreRS(RSRemision,GVMainDB,InstrSQL)
	  IF RSRemision.EOF<>TRUE THEN
	  
	   DIM XMLString,tipoComprobante   
	   
	   tipoComprobante="ingreso"
	   IF tipoFolio = "77" OR tipoFolio = "78" OR tipoFolio = "79" THEN tipoComprobante="egreso" END IF
	   
	 
	   
		IF versionFolioElectronico="1" THEN 'VERSIÓN 2.0 
			XMLString="<?xml version=""1.0"" encoding=""UTF-8""?><Comprobante xsi:schemaLocation=""http://www.sat.gob.mx/cfd/2 http://www.sat.gob.mx/sitio_internet/cfd/2/cfdv2.xsd"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://www.sat.gob.mx/cfd/2"" version=""2.0"" "
		END IF
       
		IF versionFolioElectronico="2" THEN 'VERSION 2.2
		   XMLString="<?xml version=""1.0"" encoding=""UTF-8""?><Comprobante xsi:schemaLocation=""http://www.sat.gob.mx/cfd/2 http://www.sat.gob.mx/sitio_internet/cfd/2/cfdv22.xsd"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://www.sat.gob.mx/cfd/2"" version=""2.2"" "
		  END IF	
       
       IF RSRemision.Fields("SerieFolio")<>"" AND ISNULL(RSRemision.Fields("SerieFolio"))=false THEN XMLString = XMLString & "serie=""" & RSRemision.Fields("SerieFolio") & """ " 
       
		IF versionFolioElectronico="2" THEN 'VERSION 2.2
			XMLString = XMLString  & "metodoDePago=""" & fnCaracterEspecialXML(RSRemision.Fields("formaPago"))& """ " _
			& "LugarExpedicion=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorEstado")) & ","&fnCaracterEspecialXML(RSRemision.Fields("EmisorMunicipio"))&""" " _
			& "TipoCambio=""1"" Moneda=""MX"" "
		END IF
		
        'CAMBIOSAT
		IF versionFolioElectronico="2" AND LEN(RSRemision.Fields("NumCtaPago"))>=4 THEN 'VERSION 2.2 
			XMLString = XMLString  & "NumCtaPago=""" & fnCaracterEspecialXML(RSRemision.Fields("NumCtaPago")) & """ "
		END IF
		
		IF versionFolioElectronico="2" AND TRIM(RSRemision.Fields("CondicionPago"))<>""THEN 'VERSION 2.2 
			XMLString = XMLString  & "condicionesDePago=""" & fnCaracterEspecialXML(RSRemision.Fields("CondicionPago")) & """ "
		END IF
		'TERMINA CAMBIOSAT ( NO OLVIDAR MODIFICAR  el nodo formaDePago= )
		
       XMLString = XMLString _
		& "folio=""" & RSRemision.Fields("FolioElectronico") & """ " _
		& "fecha=""" & fechaFacturaSAT & """ " _
		& "noAprobacion=""" & RSRemision.Fields("NumeroAprobacion") & """ " _
		& "anoAprobacion=""" & year(RSRemision.Fields("FechaTransaccionFolios")) & """ " _
		& "formaDePago=""" & RSRemision.Fields("formaPago") & """ " _
		& "subTotal=""" & RSRemision.Fields("SubTotalReciboElectronico") & """ " _
		& "total=""" & RSRemision.Fields("TotalReciboElectronico") & """ " _
		& "tipoDeComprobante="""&tipoComprobante&"""  " _
		& "noCertificado=""""  " _
		& "certificado=""""  " _
		& "sello="""">" _
		& "<Emisor nombre=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorNombre")) & """ " _
		& "rfc=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorRFC")) & """>" _
		& "<DomicilioFiscal calle=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorCalle")) & """ " _
		& "codigoPostal=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorCP")) & """ " _
		& "colonia=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorColonia")) & """ " _
		& "estado=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorEstado")) & """ " _
		& "localidad=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorMunicipio")) & """ " _
		& "municipio=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorMunicipio")) & """ " _
		& "noExterior=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorNumeroExterior")) & """ " _
		& "noInterior=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorNumeroInterior")) & """ " _
		& "pais=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorPais")) & """ referencia=""ÁÉÍÓÚÑ áéíóñ"" />" _
		& "<ExpedidoEn calle=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorCalle")) & """ " _
		& "codigoPostal=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorCP")) & """ " _
		& "colonia=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorColonia")) & """ " _
		& "estado=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorEstado")) & """ " _
		& "localidad=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorMunicipio")) & """ " _
		& "municipio=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorMunicipio")) & """ " _
		& "noExterior=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorNumeroExterior")) & """ " _
		& "noInterior=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorNumeroInterior")) & """ " _
		& "pais=""" & fnCaracterEspecialXML(RSRemision.Fields("EmisorPais")) & """ />" 
		
		IF versionFolioElectronico="2" THEN 'VERSION 2.2
		 		XMLString = XMLString  & "<RegimenFiscal Regimen="""& fnCaracterEspecialXML(RSRemision.Fields("RegimenFiscal")) &"""/> "
		END IF
			
		XMLString = XMLString _
 		& "</Emisor>" _
		& "<Receptor nombre=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorNombre"))   & """ rfc=""" & fnCaracterEspecialXML(RSRemision.Fields("RFCReceptor")) & """>" _
		& "<Domicilio calle=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorCalle")) & """ " _
		& "codigoPostal=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorCP")) & """ " _
		& "colonia=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorColonia")) & """ " _
		& "estado=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorEstado")) & """ " _
		& "localidad=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorPoblacion")) & """ " _
		& "municipio=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorPoblacion")) & """ " _
		& "noExterior=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorNumeroExterior")) & """ " _
		& "noInterior=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorNumeroInterior")) & """ " _
		& "pais=""" & fnCaracterEspecialXML(RSRemision.Fields("ReceptorPais")) & """ />" _
		&  "</Receptor>" _
		&  "<Conceptos>"
		DIM IVADigital,factorIVADigital
		DIM FactorRetencionISRDigital,FactorRetencionIVADigital,TieneRetencionesDigital,montoRETIVADigital,montoRETISRDigital
		IVADigital = RSRemision.Fields("montoIVA")
		factorIVADigital = RSRemision.Fields("FactorIVA")
		idSelloFolio= RSRemision.Fields("IdSelloDigital")
		
		FactorRetencionISRDigital = RSRemision.Fields("FactorRetencionISR")
		FactorRetencionIVADigital = RSRemision.Fields("FactorRetencionIVA")
		TieneRetencionesDigital = RSRemision.Fields("TieneRetenciones")
		montoRETIVADigital = RSRemision.Fields("montoRETIVA")
		montoRETISRDigital = RSRemision.Fields("montoRETISR")

		
		DIM instrumentosDigital
		instrumentosDigital = RSRemision.Fields("Instrumentos")
		DO WHILE RSRemision.EOF <> TRUE
		
		 IF  RSRemision.Fields("Tipo")<>11 THEN
		
		 XMLString = XMLString _
		 &  "<Concepto cantidad=""1"" unidad=""NA"" descripcion=""" & fnCaracterEspecialXML(RSRemision.Fields("Concepto")) & """ valorUnitario=""" & RSRemision.Fields("MontoCotizado") & """ importe=""" & RSRemision.Fields("MontoCotizado") & """/>"
		END IF
		 RSRemision.MoveNext
		LOOP 
		
		
		DIM totalRetencionesDigital,detalleRetencionesDigital
		totalRetencionesDigital=""
		detalleRetencionesDigital=""
		
		IF TieneRetencionesDigital = 1 THEN
		 totalRetencionesDigital = " totalImpuestosRetenidos=""" & montoRETIVADigital+montoRETISRDigital & """ "
		 detalleRetencionesDigital = "<Retenciones>" _
		  &  "<Retencion impuesto=""ISR"" importe=""" & montoRETISRDigital & """/>" _
		  &  "<Retencion impuesto=""IVA"" importe=""" & montoRETIVADigital & """/>" _
		  &  "</Retenciones>" 
		END IF
		
		
		XMLString = XMLString _
		&  "</Conceptos>" _
		&  "<Impuestos " & totalRetencionesDigital & " totalImpuestosTrasladados=""" & IVADigital & """>" _
		&  detalleRetencionesDigital _
		&  "<Traslados>" _
		&  "<Traslado impuesto=""IVA"" tasa=""" & factorIVADigital & """ importe=""" & IVADigital & """/>" _
		&  "</Traslados>" _
		&  "</Impuestos>"
		'& "<Addenda>" _
		'& "<Expediente>" & idExpedienteDigital & "</Expediente>" _
		'& "<Instrumentos>" & instrumentosDigital & "</Instrumentos>" _
		'& "</Addenda>" _
		XMLString = XMLString _
		&  "</Comprobante>"
		'XMLString = fnEliminarAcentos(XMLString)
		'IF consecutivoDigital = 343 THEN XMLString=""
		archivo= "temporal_" & GVIdUsuario& "_" & replace(replace(replace(replace(now(),":",""),"/",""),".","")," ","")
		pathArchivo = server.MapPath(pathUpload& GVIdEmpresa & "/" & archivo & ".xml") 
		pathArchivoX = server.MapPath(pathUpload& GVIdEmpresa & "/s" & archivo & ".xml") 
		
		set confile = createObject("scripting.filesystemobject") 
        set fich = confile.CreateTextFile(pathArchivoX) 
        fich.write(XMLString) 
		fich.close() 
		
		
		CALL fnConvertirUTF8(pathArchivoX,pathArchivo)
		
		
		

		CALL fnCierraRS(RSRemision)

		pathSello = server.MapPath(pathUpload& GVIdEmpresa & "/selloDigital")
		pathArchivoNuevo = server.MapPath(pathUpload& GVIdEmpresa & "/" & archivo & "_2.xml") 
		pathCadenaOriginal = server.MapPath(pathUpload& GVIdEmpresa & "/" & archivo & "_3.xml") 
		
		
		
		DIM xml,PostData,iCampos
        set xml = Server.CreateObject("Microsoft.XMLHTTP")
        PostData = "?GVIdEmpresa=" & GVIdEmpresa& "&GVIdSesion=" & GVIdSesion& "&pathXML=" & pathArchivo& "&pathXMLNuevo=" & pathArchivoNuevo& "&idSelloFolio=" & idSelloFolio & "&pathSello=" & pathSello & "&pathCadenaOriginal=" & pathCadenaOriginal & "&accion=generaXML&idFolioDigital=" & idFolioDigital& "&consecutivoDigital=" & consecutivoDigital & "&idExpedienteDigital=" & idExpedienteDigital & "&claveDigital=" & claveDigital & "&algoritmoUtilizado=0"
		'response.Write("http://desarrolloweb/officewriter/machotes/firmasat.aspx" & PostData)
        xml.open "POST", "http://localhost/officewriter/machotes/firmasat.aspx" & PostData & "", false
        xml.send ""
		
        allBookmarks = split(xml.responseText,"|")
		'response.Write("<br>mensaje:"&xml.responseText&""&ubound(allBookmarks))
        set xml = nothing
		
		DIM cadenaOriginal,XMLFirmado
		
		
      	IF UBOUND(allBookmarks)=1 THEN
	 		errorWS = allBookmarks(0)
	     	descripcionErrorWS = allBookmarks(1)
		ELSE
	     	errorWS=1
	     	descripcionErrorWS="Ocurrio un error al tratar de procesar la factura Electrónica."
        END IF
		
END IF
	   
		set confile = createObject("scripting.filesystemobject") 
       Set confile = Nothing
	  END IF
     END IF
	 'atrapar , mostrar error el alert
	 'hacer responseend
	 
	 
	 fnProcesaFacturaDigital=retornoError
	
	END FUNCTION
 
  
   
	
	Function fnEliminarAcentos(textRecibido)
 textRecibido=Replace(textRecibido,"Á","A")
 textRecibido=Replace(textRecibido,"É","E")
 textRecibido=Replace(textRecibido,"Í","I")
 textRecibido=Replace(textRecibido,"Ó","O")
 textRecibido=Replace(textRecibido,"Ú","U")
 textRecibido=Replace(textRecibido,"Ñ","n")
 textRecibido=Replace(textRecibido,"á","a")
 textRecibido=Replace(textRecibido,"é","e")
 textRecibido=Replace(textRecibido,"í","i")
 textRecibido=Replace(textRecibido,"ó","o")
 textRecibido=Replace(textRecibido,"ú","u")
 textRecibido=Replace(textRecibido,"Ñ","n")
fnEliminarAcentos = textRecibido
End Function

FUNCTION fnCaracterEspecialXML(textRecibido)
 IF textRecibido=null then textRecibido=""
 IF ISNULL(textRecibido)=true then textRecibido=""
 textRecibido=Replace(textRecibido,"&","&amp;")
 textRecibido=Replace(textRecibido,"<","&lt;")
 textRecibido=Replace(textRecibido,">","&gt;")
 textRecibido=Replace(textRecibido,"""","&quot;")
 textRecibido=Replace(textRecibido,"'","&apos;")

 fnCaracterEspecialXML = textRecibido
END FUNCTION

FUNCTION fnConvertirUTF8(archivo,archivo2)
 Const adTypeBinary = 1 
  Const adTypeText   = 2 
  Const bOverwrite   = True 
  Const bAsASCII     = False 
  
  Dim oFS     
  Set oFS    = CreateObject( "Scripting.FileSystemObject" ) 
  
  Dim sFFSpec 
  sFFSpec    =archivo
  Dim sTFSpec
  sTFSpec     =archivo2
  Dim oFrom   
  Set oFrom  = CreateObject( "ADODB.Stream" ) 
  Dim sFrom
  sFrom      = "Windows-1252" 
  Dim oTo
  Set oTo    = CreateObject( "ADODB.Stream" ) 
  Dim sTo
  sTo        = "utf-8" 
  
  If oFS.FileExists( sTFSpec ) Then oFS.DeleteFile sTFSpec 
  
  oFrom.Type    = adTypeText 
  oFrom.Charset = sFrom 
  oFrom.Open 
  oFrom.LoadFromFile sFFSpec   
  oTo.Type    = adTypeText 
  oTo.Charset = sTo 
  oTo.Open 
  oTo.WriteText oFrom.ReadText 
  oTo.SaveToFile sTFSpec 
  oFrom.Close 
  oTo.Close 


END FUNCTION

function DecodeUTF8(s)
  dim i
  dim c
  dim n

  i = 1
  do while i <= len(s)
    c = asc(mid(s,i,1))
    if c and &H80 then
      n = 1
      do while i + n < len(s)
        if (asc(mid(s,i+n,1)) and &HC0) <> &H80 then
          exit do
        end if
        n = n + 1
      loop
      if n = 2 and ((c and &HE0) = &HC0) then
        c = asc(mid(s,i+1,1)) + &H40 * (c and &H01)
      else
        c = 191 
      end if
      s = left(s,i-1) + chr(c) + mid(s,i+n)
    end if
    i = i + 1
  loop
  DecodeUTF8 = s 
end function

Function fnVerificaCadenaOriginal(idExpediente,claveDigital,accion)
   on error resume next
   Dim claveError,mensajeError
    Err.clear
	CALL fnAbreDB(MyDB,GVAplicacion)
	MyDB.BEGINTRANS
	InstrSQL="EXEC spVerificaCadenaOriginal"&GVIdEmpresa & " '"&idExpediente&"','"&GVIdEmpresa&"','"&claveDigital&"'," & accion
'Response.Write(InstrSQL)
   ' Response.End()
	CALL fnAbreRS(RSVerifica,MyDB,InstrSQL)
 		claveError=RSVerifica.Fields("ClaveError")
 	SET RSVerifica=nothing
 	IF Err.Number<>0 THEN
    MyDB.RollBackTrans
    Response.Write("<script>alert('Ocurrió un error al tratar de verificar la cadena original.');</script>")
	ELSE
	MyDB.CommitTrans
	IF claveError=1 AND accion=0 THEN Response.Write("<script>alert('Error. No se ha generado la factura digital.');</script>")
	END IF
	CALL fnCierraDB(MyDB)
    fnVerificaCadenaOriginal = claveError
End Function


Function fnEliminaFacturaMovBanco(idMovBanco,accion)
   on error resume next
   Dim claveError,mensajeError
    Err.clear
	CALL fnAbreDB(MyDB,GVAplicacion)
	MyDB.BEGINTRANS
	InstrSQL="EXEC spEliminaFacturaDigitalV2"&GVIdEmpresa & " '"&idMovBanco&"','"&GVIdEmpresa&"'," & accion
	'Response.Write(InstrSQL)
    'Response.End()
   	 MyDB.Execute (InstrSQL)
 	IF Err.Number<>0 THEN
    MyDB.RollBackTrans
    Response.Write("<script>alert('Ocurrió un error al tratar de eliminar FMB.');</script>")
	ELSE
	MyDB.CommitTrans
	Response.Write("<script>alert('Error. No se ha generado la factura digital. Favor de volver a intentarlo.');</script>")
	END IF
	CALL fnCierraDB(MyDB)
 End Function




%>