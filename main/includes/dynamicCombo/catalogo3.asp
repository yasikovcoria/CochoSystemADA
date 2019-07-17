<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../../funciones/misFunciones.asp" -->
<!--#include file="../../includes/GlobalVariables.asp" -->
<link href="../../CSS/dynamicCombo.css" rel="stylesheet" type="text/css"> 
<%  
 Dim i,pagina,tamPagina
 pathImages = "../../images/"
 accion = Request.Form("accion")
 Catalogo = request("Catalogo")
 pagina = request("pagina")
 cmbTextPadre = request("cmbTextPadre")
 cmbIdPadre = request("cmbIdPadre")
 alto = request("alto")
 ancho = request("ancho")
 iPageCount = 0
 paginaActual = 0
 MostrarFooter = "0"
 auxAnchoMostrarFooter = 0
 auxAltoMostrarFooter = 0
 esEstatico = 0
 IF cmbTextPadre = "" THEN cmbTextPadre = "procesado"
 IF cmbIdPadre = "" THEN cmbIdPadre = "procesado"
 if ancho = "" Then ancho = 500
 if alto = "" Then alto = 100
 SUB ConstruyeCatalogo
 Call fnAbreDB(GVMainDB,GVAplicacion)
 InstrSQL = "EXEC spObtieneCatalogo '" & Catalogo & "','" & GVIdEmpresa & "'" 'Busca el cat�logo a procesar
 if left(catalogo,2)="||" THEN
  InstrSQL = "SELECT 0 AS IdCatalogo,'" & GVIdEmpresa& "' AS IdEmpresa,'" & Catalogo _
   & "' AS Catalogo,'Cat�logo Estatico' AS Nota ,'' AS Tabla,'ID' AS CampoClave," _
   & "'Nombre' AS CampoMostrar,'' AS ASPPage,'' AS CampoRetorno" _
   & ",-1 AS IdTipoObjeto ,'' AS Campo,'' AS Parametro,'' AS IdTipoDato,'' AS DatoNombre" _
   & ",'' AS CaracterConcatena ,'' AS OrderBy,'' AS Paginacion"
   esEstatico = 1
 END IF
 
 Call fnAbreRS(RSInstruccion,GVMainDB,InstrSQL)
 InstrSQL = ""
 Condicion = ""
 If RSInstruccion.EOF <> TRUE THEN
  PaginacionTop = ""
  'Verifica si se existe condici�n de impresi�n de un tope de registros
  IF RSInstruccion.Fields("Paginacion") <> "" THEN PaginacionTop = " TOP " & RSInstruccion.Fields("Paginacion") 
  'Se construye la instrucci�n principal de todos los registros de una consulta (sin condiciones).
  InstrSQL = "SELECT " & PaginacionTop & RSInstruccion.Fields("CampoClave") & " AS ID," _
   & RSInstruccion.Fields("CampoMostrar") & " AS Nombre FROM " & RSInstruccion.Fields("Tabla")
  MostrarFooter =  Request.Form("showFooter") 'Verifica si se va a imprimir el pie del cat�logo (paginaci�n)
  If MostrarFooter = "0" THEN 
   auxAnchoMostrarFooter = 0
   auxAltoMostrarFooter = 20
  End If
  'Entra a esta condici�n s�lo si el campo de filtro contiene informaci�n o es diferente a la palabra clave "all"
  If Request.Form("CampoMostrar") <> "" AND Request.Form("CampoMostrar") <> "all" THEN 
   'invoca a la funci�n que se encarga de reemplazar likes.  Aplicar� en d�nde encuentre espacios
   Condicion = fnGetCriterio(RSInstruccion.Fields("CampoMostrar"),Replace(Replace(Request.Form("CampoMostrar")," ","+"),"'",""))
   CondicionOriginal = Condicion
   Condicion = " " & Condicion & " "
  End If
  OrderBy = " ORDER BY " & RSInstruccion.Fields("OrderBy") 'Los registros se ordenaran por este campo
  NombreCatalogo = RSInstruccion.Fields("Nota") 'Es el nombre del cat�logo (no se usa actualmente)
  ASPPage = RSInstruccion.Fields("ASPPage") 'Es el link que introduzcamos en el cat�logo
 END IF
 'Verifica si el cat�logo tiene filtros referenciados a variables de session o a objetos tipo request (YA NO SE UTILIZA)
 DO WHILE RSInstruccion.EOF <> TRUE
  AuxCond = " AND "
  IF Condicion = "" THEN AuxCond = " WHERE "
  IF RSInstruccion.Fields("IdTipoObjeto") <> -1 THEN
   IF RSInstruccion.Fields("IdTipoObjeto") = 1 Then
    Condicion =Condicion & AuxCond & RSInstruccion.Fields("Campo") _
	 & " = " & RSInstruccion.Fields("CaracterConcatena") & SESSION(RSInstruccion.Fields("Parametro")) _
	 & RSInstruccion.Fields("CaracterConcatena")
   Else
    Condicion = Condicion & AuxCond & RSInstruccion.Fields("Campo") _
 	 & " = " & RSInstruccion.Fields("CaracterConcatena") & Request(RSInstruccion.Fields("Parametro")) _
	 & RSInstruccion.Fields("CaracterConcatena")
   End If
  End If   
  RSInstruccion.MoveNext
 LOOP
 
 IF esEstatico = 0 THEN
  tamarreglo=2
  j = 0
  contador = 0
  dim arreglo()
  'ARREGLO PARA SEPARAR LAS CONDICIONES ENVIADAS
  Redim arreglo(tamarreglo)
  separador = "|"
  linea = Request("condicion")
  posicion = instr(linea,separador)
  while not posicion = 0
   contador = 1
   if j = (tamarreglo-1) then
   tamarreglo=tamarreglo + 1
   redim preserve arreglo(tamarreglo)
   end if
   arreglo(j)=left(linea,posicion-1)
   linea=right(linea,len(linea)-posicion)
   j=j+1
   posicion=instr(linea,separador)
  wend
  if j > 0 then
   arreglo(j) = linea
  else
   If Request("condicion") <> "" THEN 
    arreglo(0) = Request("condicion")
    contador = 1
   End If
  End If
 
  'ARREGLO PARA SEPARAR LOS CAMPOS DE LAS CONDICIONES, DESPUES SE PROSIGE A SEPARAR EL TIPO DE CONDICI�N (=,<>,etc)
  separador = "?"
  tamarreglo = 2
  condicionY = ""
  
  If contador =1 THEN
   for z= 0 to j
    condicionX = ""
    linea = arreglo(z)
    posicion = instr(linea,separador)
    condicionY =left(linea,posicion-1)
    linea=right(linea,len(linea)-posicion)
    condicionX = linea
    linea2 = condicionX
    separador2 ="&"
    posicion2 = instr(linea2,separador2)
    condicionY = condicionY & " " & left(linea2,posicion2-1)
    linea2=right(linea2,len(linea2)-posicion2) 
    posicion2 = instr(linea2,separador2) 
    condicionZ = ""
   
    while not posicion2 = 0
     condicionZ= condicionZ & condicionY & " " & condicionZ & left(linea2,posicion2-1) & " "
     linea2=right(linea2,len(linea2)-posicion2)
     jj=jj+1
     posicion2=instr(linea2,separador2)
    wend
   
    if jj > 0  then
     condicionZ= condicionZ & condicionY & " " & linea2 & " "
    else
     if contador = 1 THEN condicionZ= condicionY & " " & linea2 & " "
    end if   
    condicionAux = ""
    if condicion <> "" Then
     condicionAux = " AND "
    else
     condicion = " WHERE "  
    End if
    condicionZ = mid(condicionZ,4,len(condicionZ))  
    arreglo(z) = condicionAux & " (" & condicionZ & ") " 
   next
  End If 
 
  If  contador =1 THEN
   for z= 0 to j
    Condicion = Condicion &  arreglo(z)
   Next
  End If
 END IF 
 CALL fnCierraRS(RSInstruccion)
 Response.Write "<div id=""layCatalogo"" style=""position:absolute;top:0px;left:0px;width:" & ancho+20+auxAnchoMostrarFooter & "px;height:" & alto-5+auxAltoMostrarFooter & "px;overflow-x:hidden;overflow-y:scroll;border: 1px solid #7499C5;"" onscroll=""fnScroll();"" onclick=""fnScroll;"">"
'Response.Write InstrSQL & Condicion & OrderBy 'aqui
if esEstatico = 1 THEN 
 cadenaInstruccion = ""
 arregloClave = SPLIT(Replace(Request("condicion"),"",""), "|")
 FOR j = 0 TO UBOUND(arregloClave)
  IF arregloClave(j) <> "" THEN
   IF cadenaInstruccion = "" THEN
    cadenaInstruccion = "SELECT '" & REPLACE(arregloClave(j),"?","' AS ID ,'") & "' AS Nombre"
   ELSE
    cadenaInstruccion = cadenaInstruccion & " UNION SELECT '" & REPLACE(arregloClave(j),"?","' AS ID ,'") & "' AS Nombre"
   END IF
  END IF
  IF cadenaInstruccion <> "" THEN 
   cadenaInstruccion = "SELECT ID,Nombre FROM (" & cadenaInstruccion & ") AS X"
   InstrSQL = cadenaInstruccion
   OrderBy = " ORDER BY Nombre "
   Condicion = "  " & CondicionOriginal
  END IF
 NEXT
END IF
'response.Write(InstrSQL & Condicion & OrderBy)
'response.End()
'InstrSQL = ""
 IF InstrSQL <> "" THEN 'S�lo entra si existe una consulta maestra
  Response.Write "<table border=""0"" class="""" width=""" & ancho & "px"" align=""center"" cellpadding=""1px"" cellspacing=""0px"" onclick=""fnScroll;"">"
  Response.Write "<tbody id=""bodytable"">"
  InstrSQL = InstrSQL & Condicion & OrderBy 'Se le a�ade condici�nes y ordenamiento a la consulta maestra
  Call fnAbreRS(RSCatalogo,GVMainDB,InstrSQL)
  Registros = RSCatalogo.RecordCount 'Se obtienen el total de registros
  tamPagina = 100
  if isnumeric(Request("paginacionX")) THEN tamPagina = CINT(Request("paginacionX")) 'Se determina el n�mero de registros por p�gina
  RSCatalogo.Pagesize = tamPagina
  RSCatalogo.CacheSize = tamPagina
  iPageCount = RSCatalogo.PageCount 'Se obtienen el tama�o de p�ginas totales
  If NOT isNumeric(pagina) THEN pagina = 1
  pagina = Cint(pagina)
  If pagina >= iPageCount Then 'Validaciones sobre el n�mero de p�gina actual
   paginaActual = iPageCount
  Else
   paginaActual = pagina
  End If
  contador = 0
  IF Registros > 0 THEN RSCatalogo.AbsolutePage = paginaActual 
  i = 0
  DO WHILE RSCatalogo.EOF <> TRUE 'Se imprimen los registros de la p�gina solicitada
   if i<tamPagina Then 'Termina si se cumple con los registros a mostrar
    Response.Write "<tr class=""ContenidoDynamicCombo"" id=""id" & i & """ name=""id" & i & """ onClick=""procesa(" & i & ");"" title=""Haga clic para pasar Par�metros"">"
    Response.Write "<td align=""center"" class=""sinbordes"" width=""1px"">&nbsp;</span></td>"
    Response.Write "<td align=""left"" class=""sinbordes""><span class=""celda_titulo"">" _
     & "<div id=""blay" & i + 0 & """>" & RSCatalogo.Fields("Nombre") & "</div></span></td>"
    Response.Write "</tr>"
    Response.Write "<div id=""alay" & i + 0 & """ style=""visibility:hidden;top:0px;position:absolute;"">" & RSCatalogo.Fields("ID") & "</div>"
   Else
    EXIT DO
   End If
   i = i + 1
   RSCatalogo.MoveNext
  LOOP
  CALL fnCierraRS(RSCatalogo)
  Response.Write "</tr>"
 End If
 Response.Write "</tbody></table>"
 IF Registros = 0 THEN Response.Write "<span class=""celda_titulo""><font color=""red"">No se encontrar�n registros!!!</font></span>"
 Response.Write "</div>"
 'Hiddens generales para asegurar recursividad del cat�logo
 'S�lo entra si se solicito la impresi�n del pie del cat�logo
 IF MostrarFooter = "1" THEN
  Response.Write "<div id="""" align=""center"" style=""position:absolute;visibility:visible;top:" & alto-5
  Response.Write "px;left:0px;width:" & ancho +20 & "px;height:20px;overflow: no;"" class=""paginacion"">"
  Response.Write "<table border=""1"" class="""" width=""" & ancho +20 & "px"" align=""center"">"
  Response.Write "<tr class=""registros"">"
  imgAgregar = ""
  if ASPPage <> "" THEN imgAgregar = "<img src=""" & pathImages _
   & "comboBox/edit.gif"" border=""0"" align=""top"" title=""Haga clic para agregar, modificar o eliminar registros""" _
   & " onMouseOver=""this.src='" & pathImages & "comboBox/edit2.gif" & "';"" onMouseOut=""this.src='" & pathImages _
   & "comboBox/edit.gif" & "';"" onClick=""procesaASPCatalogue('" & Replace(ASPPage,"\","\\") & "');"">" 'Se arma el link a procesar al dar clic en la imagen a imprimir (si existe)
  strPaginaAux = ((paginaActual*tamPagina)-tamPagina+1) & "-" & ((paginaActual*tamPagina)-tamPagina)+i 
  if Registros = 0 THEN strPaginaAux = "0"
  'Imprime p�gina actual, total de registros, etc
  Response.Write "<td class=""registros"" width=""35%""><div id=""registroAct"">Registros:&nbsp;" & strPaginaAux & "/" & Registros & "</div></td>"
  Response.Write "<td class=""paginacion"" width=30%"" align=""center"">&nbsp;"
  If iPageCount >1 AND paginaActual <> 1 THEN Response.Write "&nbsp;&nbsp;<a href=""javascript:enviar(1);"" title=""Primer p�gina""><img src=""" & pathImages & "comboBox/firstpage.gif"" border=""0"" align=""middle""></a>&nbsp;" 
  If iPageCount >1 AND paginaActual > 1 THEN Response.Write "<a href=""javascript:enviar(" & paginaActual -1 & ");"" title=""P�gina anterior""><img src=""" & pathImages & "comboBox/prevpage.gif"" border=""0"" align=""middle""></a>&nbsp;"
  Response.Write "<input name=""pagina"" id=""pagina2"" type=""text"" onkeyPress=""verificaTxtPag(event,this," & paginaActual & "," & iPageCount & ");"" value=""" & paginaActual & """ maxlength=""6"" style=""width:30px;"" class=""paginacion"" title=""Ingrese un n�mero de p�gina y presione la tecla ENTER"">"
  If iPageCount >1 AND paginaActual < iPageCount THEN Response.Write "<a href=""javascript:enviar(" & paginaActual + 1 & ");"" title=""P�gina siguiente""><img src=""" & pathImages & "comboBox/nextpage.gif"" border=""0"" align=""middle"">&nbsp;</a>"
  If iPageCount >1 AND paginaActual <> iPageCount THEN Response.Write "<a href=""javascript:enviar(" & iPageCount & ");"" title=""Ultima p�gina""><img src=""" & pathImages & "comboBox/lastpage.gif"" border=""0"" align=""middle"">&nbsp;</a>"
  Response.Write "</td>"
  Response.Write "<td class=""registros"" width=""35%"" align=""right"">P�gina:&nbsp;" & paginaActual & " de " & iPageCount & "&nbsp;&nbsp;" & imgAgregar & "</td>"
  Response.Write "</tr>" 
  Response.Write "</table>"
  Response.Write "</div>"
 END IF
 'variables sobre el estatus de la p�gina actual (NO SE UTILIZA)
 Response.Write"<script>totPaginas = " & iPageCount & ";paginaActual=" & paginaActual & ";indiceAnteriorMandado = '" & Request.Form("indiceAnterior") & "';if(indiceAnteriorMandado>'" & i-1 & "') { indiceAnteriorMandado='';}</script>"
 CALL fnCierraDB(GVMainDB)
 END SUB
 
 CALL ConstruyeCatalogo()

%>
<script>
 var totPaginas;
 var paginaActual;
 var indiceAnteriorMandado;
 //Se capturan variables de servidor necesarios para asegurar la correcta recursividad y seguimiento de la correcta p�ginaci�n
 var indiceActual = 0; //Registro seleccionado (sombreado)
 var indiceAnterior = 0; //Registro anterior del actual
 var antStyle = ''; //Estilo (CSS) del registro anterior
 var procesado = '<%= Request.Form("procesado") %>'; //Verifica si ya fue procesado el cat�logo (para evitar recargar el cat�logo sin necesidad)
 var campoCombo = parent.campoCombo; //campo en donde escribimos la informaci�n
 var campoIdCombo = parent.campoIdCombo; //campo donde se almacenara la clave del registro seleccionado
 var Catalogo = '<%= catalogo %>'; //nombre del cat�logo utilizado
 var refrescarVentana = 2;
 var resizeNewIFrame = '<%= Request.Form("resizeNewIFrame") %>'; //Verificar� si es necesario actualizar el tama�o del cat�logo y la posici�n de este desde lo invoquemos


 function fnScroll(){
  try {
   campoCombo.focus();
  }
  catch(err) {}
 }

 //inicializa variables
 indiceAnterior = -1;
 indiceAnterior2 = -1;
 
 //funci�n principal
 function verificaCatalogo2(catalogo,cmbPadre,cmbId,iFrameFather,accion,ancho,alto,condicion,accionJavaScript,evento,paginacionX,evento2,targetAux,showFooter,parentMaster) {
  
  if((evento==38 || evento==40) && catalogo==Catalogo) {
   procesaId(false,evento,false);
   return false;
  
  }
  
  var bandera = true;
  var resFrame = false;
  if(!parentMaster) //VERIFICAR SI LO LLAMO OTRO PADRE (IFRAME OVER IFRAME)
	 parentMaster = 'parent.parent';
	 
  try { //new
   var cmbPadreObject = eval(parentMaster+'.document.all.item(\''+cmbPadre+'\')');
   if(campoCombo!= cmbPadreObject) {
    Catalogo = '';   
   }
  }
  
  catch(err) {}
  if(bandera) {
   if(catalogo!=Catalogo) {
    document.getElementById('catalogo').value = catalogo;
    document.getElementById('accion').value = accion;
    document.getElementById('ancho').value = ancho;
    document.getElementById('alto').value = alto;
	if(showFooter)
	 document.getElementById('showFooter').value = showFooter;
	else
	 document.getElementById('showFooter').value = '1';
    document.getElementById('condicion').value = condicion;
	valorAux='';
	valorAux = parent.campoCombo.value+valorAux;
	valorAux = parent.campoCombo.value;	
	document.getElementById('CampoMostrar').value = valorAux;
    document.getElementById('procesado').value = 1;
    document.getElementById('pagina').value = 1; 
    if(!paginacionX)
     paginacionX = 100;
    document.getElementById('paginacionX').value = paginacionX;
	resFrame = true;
    submitForm(targetAux);
	return false;
   }
   else {
    if(evento==9 || evento==13)
	 procesa(indiceAnterior);
	 else
   
    if(evento2 && resFrame==false) {
     parent.procesaId(false,1,resFrame);
	}
    else
	 if(resFrame==false)
      parent.procesaId(evento,false,resFrame);
   }
  }
 }
  
 function procesa(elemento) {
  try {
  if (antStyle!='' && indiceAnterior!=-1)
	bodytable.rows(indiceAnterior).className ='ContenidoDynamicCombo'
  var layerA = document.getElementById('alay'+elemento).innerText;
  var layerB = document.getElementById('blay'+elemento).innerText;
  }
  catch(err) { return false;} 
  campoIdCombo.value = layerA;
  campoCombo.value = layerB;
  indiceAnterior = elemento;
  indiceAnterior2 = elemento;
  antStyle = bodytable.rows(indiceAnterior).style.backgroundColor ;
  bodytable.rows(indiceAnterior).className ='SeleccionDynamicCombo'
  
  parent.procesa(layerA,layerB,'<%= Request("accionJavaScript") %>');
  return false;
  

 }
 
 function enviar(pagina) {
  document.getElementById('CampoMostrar').value = campoCombo.value.toLowerCase();
  document.getElementById('procesado').value = 1;
  document.getElementById('paginaX').value = pagina; 
  submitForm();
 }
 
 function submitForm(targetAux) {
  document.getElementById('catalogo').value=parent.fnCatcatalogo;
  document.getElementById('ancho').value=parent.fnCatancho;
  document.getElementById('alto').value=parent.fnCatalto;
  document.getElementById('condicion').value=parent.fnCatcondicion;
  document.getElementById('paginacionX').value=parent.fnCatpaginacionX;
  document.getElementById('showFooter').value=parent.fnCatshowFooter;
  document.getElementById('resizeNewIFrame').value = '1';
  document.frmComboBox.method = 'post';
  document.frmComboBox.target = '_self';
  document.frmComboBox.action = '<%= request.ServerVariables("URL") %>';
  if(targetAux)
   document.frmComboBox.action =targetAux;
  document.frmComboBox.submit(); 
 }
 
 function verificaTxtPag(evento,objeto,paginaActual,iPageCount) {
  if(evento.keyCode==13) {
   if (!isNaN(objeto.value)) {
    valor = parseInt(objeto.value);
    if(valor>iPageCount || valor<1)
	 alert('N�mero de p�gina incorrecto');
	else {
	 if(valor!=paginaActual)
	  enviar(objeto.value);
	}
   }
   else
    alert('El n�mero de p�gina debe ser num�rico');
  }
 }
 
 function procesaId(evento,tecla2,resizeIframeGo) {
  var teclaAux = '';
  var tecla = '';
  if(evento)
   tecla = evento
  else  
   if (tecla2)
    tecla = tecla2;
  teclaAux = '';
  if(indiceAnterior==<%= i-1 %> && tecla==40) //nuevo
   if(totPaginas>paginaActual) {
    enviar(paginaActual+1);
    return true;
   }
   
  if(tecla==38 && indiceAnterior==0) //nuevo
   if(paginaActual!=1) {
    document.getElementById('indiceAnteriorX').value =parent.fnCatpaginacionX;
    enviar(paginaActual-1);
    return true;
   }

  if(indiceAnteriorMandado!='') {  //nuevo
   indiceAnterior2 = parseInt(indiceAnteriorMandado)-1;
   indiceAnterior = parseInt(indiceAnteriorMandado)-2;
   indiceAnteriorMandado = '';
   tecla = 40;
  }
  
  if ((tecla==13||tecla==9) && indiceAnterior!=-1) {
   procesa(indiceAnterior);
  }
  else
   if (tecla!=38 && tecla!=40) {
    tecla = 40;
    for (i=0;i<=<%= i-1 %>;i++) {
     var index = document.getElementById('blay'+i).innerText.toLowerCase().indexOf(campoCombo.value.toLowerCase()+teclaAux);
	 if(index==0) {
      indiceAnterior = i-1;
	  indiceAnterior2 = i-1;
	  antStyle = bodytable.rows(i).style.backgroundColor ;
	  tecla = 40;
	  break;
     }
    }
	if(index!=0) {
     indiceAnterior = -1;
	 indiceAnterior2 = -1;
	 if(tecla2!=1) {
	  document.getElementById('CampoMostrar').value = parent.campoCombo.value.toLowerCase()+teclaAux;
	  document.getElementById('procesado').value = 1;
      document.getElementById('pagina').value = 1;   
      submitForm();
	 }
   }
  }
  
  if (tecla == 38 || tecla == 40) {
   indiceAnterior2 = indiceAnterior; 
   layCatalogo.style.visibility = 'visible';
   if (tecla==40) {
    if(indiceAnterior < <%= i-1 %>)
	 indiceAnterior = indiceAnterior+1;
   }
	else {
	 if(indiceAnterior>0)
	  indiceAnterior = indiceAnterior-1;
  }
  for (i=0;i<=<%= i-1 %>;i++)
   bodytable.rows(i).className = 'ContenidoDynamicCombo';
  if(indiceAnterior2!=indiceAnterior) {
   layCatalogo.scrollTop =bodytable.rows(indiceAnterior).offsetTop;
  }
  if(indiceAnterior!=-1)
  bodytable.rows(indiceAnterior).className ='SeleccionDynamicCombo';   
 }
}

if (procesado=='1') {
 if(resizeNewIFrame=='1')
  procesaId(false,1,true);
 else
   procesaId(false,1,false);
}

function verifyAction() {
 if(refrescarVentana==0) {
  verificaCatalogo2(fnCatcatalogo,fnCatcmbPadre,fnCatcmbId,fnCatiFrameFather,fnCataccion,fnCatancho,fnCatalto,fnCatcondicion,fnCataccionJavaScript,fnCatevento,fnCatpaginacionX,fnCatevento2,fnCattargetAux,fnCatshowFooter,fnCatparentMaster)
  refrescarVentana = 2;
 }
 if(refrescarVentana==1) {
  refrescarVentana = 0;
 }
  var timerID = setTimeout('verifyAction()',300);
}

 var fnCatcatalogo,fnCatcmbPadre,fnCatcmbId,fnCatiFrameFather,fnCataccion,fnCatancho;
 var fnCatalto,fnCatcondicion,fnCataccionJavaScript,fnCatevento,fnCatpaginacionX,fnCatevento2;
 var fnCattargetAux,fnCatshowFooter,fnCatparentMaster;

function verificaCatalogo(catalogo,cmbPadre,cmbId,iFrameFather,accion,ancho,alto,condicion,accionJavaScript,evento,paginacionX,evento2,targetAux,showFooter,parentMaster) {
 fnCatcatalogo=catalogo;
 fnCatcmbPadre=cmbPadre;
 fnCatcmbId=cmbId;
 fnCatiFrameFather=iFrameFather;
 fnCataccion=accion;
 fnCatancho=ancho;
 fnCatalto=alto;
 fnCatcondicion=condicion;
 fnCataccionJavaScript=accionJavaScript;
 if(evento)
  evento = evento.keyCode;
 fnCatevento=evento;
 fnCatpaginacionX=paginacionX;
 fnCatevento2=evento2;
 fnCattargetAux=targetAux;
 fnCatshowFooter=showFooter;
 fnCatparentMaster=parentMaster;
 refrescarVentana = 1;
 
 if(fnCatevento==38 || fnCatevento==40 || fnCatevento==13 || fnCatevento==9 || fnCatevento==0) {
  refrescarVentana = 0;
  try {
  verifyAction();
  }
  catch(err){}
 }
 //if(evento2 || fnCatevento==9 || fnCatevento==13) refrescarVentana = 0;

}

function procesaASPCatalogue(ASPCatalogue) {
 campoCombo.focus();
 if(document.getElementById('alay'+indiceAnterior))
  var auxIdCombo = document.getElementById('alay'+indiceAnterior).innerText;
 else
  var auxIdCombo = '';
 var strToSend = '';
 var mainArray = ASPCatalogue.split('?');
 if(mainArray.length==1) {
  strToSend = ASPCatalogue + '?GVIdSesion=<%=GVIdSesion%>&campoToSend='+campoCombo.value+ '&idCampoToSend='+auxIdCombo+'&invocoCatalogo=1';
 }
 else {
  strToSend = mainArray[0];
  var auxArray = mainArray[1].split('&');
  if(auxArray.length==1)
   strToSend = strToSend + '?GVIdSesion=<%=GVIdSesion%>&'+mainArray[1] + '&campoToSend='+campoCombo.value+'&idCampoToSend='+auxIdCombo+'&invocoCatalogo=1';
  else {
   var auxStrToSend = '';
   for(var n=0;n<auxArray.length;n++)
    auxStrToSend = auxStrToSend + '&'+ auxArray[n];
   strToSend = strToSend + '?GVIdSesion=<%=GVIdSesion%>&campoToSend='+campoCombo.value+'&idCampoToSend='+auxIdCombo+'&invocoCatalogo=1'+auxStrToSend;
  }
 }
 var ventana = window.open(strToSend,'auxiliarCatalogo','status=yes,dependent=yes,scrollbars=yes');   
 ventana.top.window.resizeTo(screen.availWidth,screen.availHeight);
 ventana.focus();
}

function procesaAspCatalogue2(RequestIdValor,RequestValor) {
 parent.procesaAspCatalogue2(RequestIdValor,RequestValor)
}

 verifyAction();
 
 if(campoCombo)
  campoCombo.focus();
</script>

<form name="frmComboBox">
 <input name="pagina" id="paginaX" type="hidden" value="<%= request.Form("pagina") %>">
 <input name="catalogo" id="catalogo" type="hidden" value="">
 <input name="accion" id="accion" type="hidden" value="<%= Request.Form("accion") %>">
 <input name="ancho" id="ancho" type="hidden" value="">
 <input name="alto" id="alto" type="hidden" value="">
 <input name="GVIdSesion" id="GVIdSesion" type="hidden" value="<%= request("GVIdSesion") %>">
 <input name="condicion" id="condicion" type="hidden" value="">
 <input name="indiceAnterior" id="indiceAnteriorX" type="hidden" value="">
 <input name="paginacionX" id="paginacionX" type="hidden" value="">
 <input name="procesado" id="procesado" type="hidden" value="<%= Request.Form("procesado") %>">
 <input name="showFooter" id="showFooter" type="hidden" value="">
 <input name="CampoMostrar" id="CampoMostrar" type="hidden" value="<%= Request.Form("CampoMostrar") %>">
 <input name="resizeNewIFrame" id="resizeNewIFrame" type="hidden" value="<%= Request.Form("resizeNewIFrame") %>">
</form>