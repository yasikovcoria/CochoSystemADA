<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!--#include file="fnFuncionesASP.asp" -->
<link href="../css/estiloAutoComplete.css" rel="stylesheet" type="text/css" /> 
<link href="../css/bootstrap.css" rel="stylesheet" type="text/css" /> 
<script src="../js/jQuery.js" type="text/javascript"></script>
<%  

 pathImages = "../img/"
 accion = Request.Form("accion")
 Catalogo = request("Catalogo")
 pagina = request("pagina")
 cmbTextPadre = request("cmbTextPadre")
 cmbIdPadre = request("cmbIdPadre")
 
 Catalogo=replace(Catalogo,"""","")
 cmbTextPadre=replace(cmbTextPadre,"""","")
 cmbIdPadre=replace(cmbIdPadre,"""","")
 
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
 Response.Write "<form name=""frmcomboImg"">"

 Call fnAbreDB(GVMainDB,GVAplicacion)

 InstrSQL = "EXEC spObtieneCatalogo '" & Catalogo & "','" & GVIdEmpresa& "'" 'Busca el catálogo a procesar
    
 if left(catalogo,2)="||" THEN
  InstrSQL = "SELECT 0 AS IdCatalogo,'" & GVIdEmpresa& "' AS IdEmpresa,'" & Catalogo _
   & "' AS Catalogo,'Catálogo Estatico' AS Nota ,'' AS Tabla,'ID' AS CampoClave," _
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
    
  'Verifica si se existe condición de impresión de un tope de registros
  IF RSInstruccion.Fields("Paginacion") <> "" THEN PaginacionTop = " TOP " & RSInstruccion.Fields("Paginacion") 
  'Se construye la instrucción principal de todos los registros de una consulta (sin condiciones).
  InstrSQL = "SELECT " & PaginacionTop & RSInstruccion.Fields("CampoClave") & " AS ID," _
   & RSInstruccion.Fields("CampoMostrar") & " AS Nombre FROM " & RSInstruccion.Fields("Tabla")
  MostrarFooter =  Request.Form("showFooter") 'Verifica si se va a imprimir el pie del catálogo (paginación)
  If MostrarFooter = "0" THEN 
   auxAnchoMostrarFooter = 0
   auxAltoMostrarFooter = 20
  End If
  'Entra a esta condición sólo si el campo de filtro contiene información o es diferente a la palabra clave "all"
  If Request.Form("CampoMostrar") <> "" AND Request.Form("CampoMostrar") <> "all" THEN 
   'invoca a la función que se encarga de reemplazar likes.  Aplicará en dónde encuentre espacios
   Condicion = fnGetCriterio(RSInstruccion.Fields("CampoMostrar"),Replace(Replace(Request.Form("CampoMostrar")," ","+"),"'",""))
   CondicionOriginal = Condicion
   Condicion = " " & Condicion & " "
  End If
  OrderBy = " ORDER BY " & RSInstruccion.Fields("OrderBy") 'Los registros se ordenaran por este campo
  NombreCatalogo = RSInstruccion.Fields("Nota") 'Es el nombre del catálogo (no se usa actualmente)
  ASPPage = RSInstruccion.Fields("ASPPage") 'Es el link que introduzcamos en el catálogo
 END IF
 'Verifica si el catálogo tiene filtros referenciados a variables de session o a objetos tipo request (YA NO SE UTILIZA)
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
 
  'ARREGLO PARA SEPARAR LOS CAMPOS DE LAS CONDICIONES, DESPUES SE PROSIGE A SEPARAR EL TIPO DE CONDICIÓN (=,<>,etc)
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
 Response.Write "<div id=""layCatalogo"" class=""table-responsive""  style=""position:absolute;visibility:hidden;top:0px;left:0px;width:" & ancho+20+auxAnchoMostrarFooter & "px;height:" & alto-5+auxAltoMostrarFooter & "px;overflow-x:hidden;overflow-y:scroll;border: 1px solid #7499C5;"">"
'Response.Write InstrSQL & Condicion & OrderBy 'aqui
if esEstatico = 1 THEN 
 cadenaInstruccion = "" 
 variableTemporal = "DECLARE @TABLE TABLE(ID varchar(1000),Nombre varchar(1000)) "
 arregloClave = SPLIT(Replace(Request("condicion"),"'",""), "|")
 FOR j = 0 TO UBOUND(arregloClave)
  IF arregloClave(j) <> "" THEN
   IF cadenaInstruccion = "" THEN
    cadenaInstruccion = "INSERT INTO @TABLE SELECT '" & REPLACE(arregloClave(j),"?","' AS ID ,'") & "' AS Nombre "
   ELSE
    cadenaInstruccion = cadenaInstruccion & "INSERT INTO @TABLE SELECT '" & REPLACE(arregloClave(j),"?","' AS ID ,'") & "' AS Nombre "
   END IF
  END IF
  IF cadenaInstruccion <> "" THEN 
   OrderBy = " ORDER BY Nombre "
   Condicion = "  " & CondicionOriginal
  END IF
 NEXT
 InstrSQL ="SET NOCOUNT ON " & variableTemporal & cadenaInstruccion &" SELECT DISTINCT ID,Nombre FROM @TABLE "
 InstrSQLContar ="SET NOCOUNT ON " & variableTemporal & cadenaInstruccion &" SELECT COUNT(*) As registros FROM (SELECT DISTINCT ID,Nombre FROM @TABLE) AS X "

 Call fnAbreRS(RSCatalogo,GVMainDB,InstrSQLContar)
 Registros = RSCatalogo.fields("registros")
 CALL fnCierraRS(RSCatalogo)
END IF
 IF InstrSQL <> "" THEN 'Sólo entra si existe una consulta maestra
  Response.Write "<table border=""0"" class=""table table-condensed"" width=""" & ancho & "px"" align=""center"" cellpadding=""1px"" cellspacing=""0px"">"
  Response.Write "<tbody id=""bodytable"" style="""">"
  InstrSQL = InstrSQL & Condicion & OrderBy 'Se le añade condiciónes y ordenamiento a la consulta maestra  

    Call fnAbreRS(RSCatalogo,GVMainDB,InstrSQL)
  
  
  tamPagina = 100
  if isnumeric(Request("paginacionX")) THEN tamPagina = CINT(Request("paginacionX")) 'Se determina el número de registros por página
  RSCatalogo.Pagesize = tamPagina
  RSCatalogo.CacheSize = tamPagina
  
  if esEstatico <> 1 THEN 
   Registros = RSCatalogo.RecordCount 'Se obtienen el total de registros
   iPageCount = RSCatalogo.PageCount 'Se obtienen el tamaño de páginas totales
  ELSE
    iPageCount = 1
	tamPagina = 1000
  END IF
  
  If NOT isNumeric(pagina) THEN pagina = 1
  pagina = Cint(pagina)
  If pagina >= iPageCount Then 'Validaciones sobre el número de página actual
   paginaActual = iPageCount
  Else
   paginaActual = pagina
  End If
  contador = 0
  IF Registros > 0 AND esEstatico <> 1 THEN RSCatalogo.AbsolutePage = paginaActual 
  i = 0
  DO WHILE RSCatalogo.EOF <> TRUE 'Se imprimen los registros de la página solicitada
   if i<tamPagina Then 'Termina si se cumple con los registros a mostrar
    Response.Write "<tr class=""infoNew"" id=""id" & i & """ name=""id" & i & """ onClick=""procesa(" & i & ");"" title=""Seleccionar Registro"">"
    Response.Write "<td align=""center"" class=""sinbordes"" width=""1px"">&nbsp;</span></td>"
    Response.Write "<td align=""left"" class=""sinbordes""><span class=""celda_titulo"">" _
     & "<div id=""blay" & i + 0 & """>" & RSCatalogo.Fields("Nombre") & "</div></span></td>"
    Response.Write "</tr>"
    Response.Write "<div id=""alay" & i + 0 & """ style=""background-color:#F0F0F0;visibility:hidden;top:0px;position:absolute;background-color:lightblue"">" & RSCatalogo.Fields("ID") & "</div>"
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
 IF Registros = 0 THEN Response.Write "<span class=""celda_titulo""><font color=""darkblue"">No se encontraron Concidencias!!!</font></span>"
 Response.Write "</div>"
 'Hiddens generales para asegurar recursividad del catálogo
 Response.WRITE "<input name=""pagina"" id=""pagina"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""catalogo"" id=""catalogo"" type=""hidden"" value=""" & Replace(Request.Form("Catalogo"),"""","") & """>"
 Response.WRITE "<input name=""cmbTextPadre"" id=""cmbTextPadre"" type=""hidden"" value=""" & Replace(Request.Form("cmbTextPadre"),"""","") & """>"
 Response.WRITE "<input name=""cmbIdPadre"" id=""cmbIdPadre"" type=""hidden"" value=""" & Request.Form("cmbIdPadre") & """>"
 Response.WRITE "<input name=""accion"" id=""accion"" type=""hidden"" value=""" & Request.Form("accion") & """>"
 Response.WRITE "<input name=""ancho"" id=""ancho"" type=""hidden"" value=""" & Request.Form("ancho") & """>"
 Response.WRITE "<input name=""alto"" id=""alto"" type=""hidden"" value=""" & Request.Form("alto") & """>"
 Response.WRITE "<input name=""condicion"" id=""condicion"" type=""hidden"" value=""" & Replace(Request.Form("condicion"),"""","") & """>"
 Response.WRITE "<input name=""CampoMostrar"" id=""CampoMostrar"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""indiceAnterior"" id=""indiceAnterior"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""accionJavaScript"" id=""accionJavaScript"" type=""hidden"" value=""" & Request.Form("accionJavaScript") & """>"
 Response.WRITE "<input name=""paginacionX"" id=""paginacionX"" type=""hidden"" value=""" & Request.Form("paginacionX") & """>"
 Response.WRITE "<input name=""procesado"" id=""procesado"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""showFooter"" id=""showFooter"" type=""hidden"" value=""" & Request.Form("showFooter") & """>"
 Response.WRITE "<input name=""parentMaster"" id=""parentMaster"" type=""hidden"" value=""" & Request.Form("parentMaster") & """>"
 Response.WRITE "<input name=""iFrameFather"" id=""iFrameFather"" type=""hidden"" value=""" & Request.Form("iFrameFather") & """>"
 Response.WRITE "<input name=""GVIdSolicitoCliente"" id=""GVIdSolicitoCliente"" type=""hidden"" value=""" & GVIdSolicitoCliente & """>"
 Response.WRITE "<input name=""GVIdEmpresa"" id=""GVIdEmpresa"" type=""hidden"" value=""" & GVIdEmpresa & """>"
 Response.WRITE "<input name=""resizeNewIFrame"" id=""resizeNewIFrame"" type=""hidden"">"
 Response.Write "</form>"
 'Sólo entra si se solicito la impresión del pie del catálogo
 IF MostrarFooter = "1" THEN
  Response.Write "<div id="""" align=""center"" style=""background-color:#F0F0F0;position:absolute;visibility:visible;top:" & alto-5
  Response.Write "px;left:-2px;width:" & ancho +22 & "px;height:20px;overflow: no;"" class=""paginacion"">"
  Response.Write "<table style=""padding-top:0px;""  class=""table table-bordered"" width=""" & ancho +26 & "px"" align=""center"">"
  Response.Write "<tr class=""registros"">"
  imgAgregar = ""
  if ASPPage <> "" THEN imgAgregar = "<img src=""" & pathImages _
   & "comboImg/edit.gif"" border=""0"" align=""top"" title=""Haga clic para agregar, modificar o eliminar registros""" _
   & " onMouseOver=""this.src='" & pathImages & "comboImg/edit2.gif" & "';"" onMouseOut=""this.src='" & pathImages _
   & "comboImg/edit.gif" & "';"" onClick=""procesaASPCatalogue('" & Replace(ASPPage,"\","\\") & "');"">" 'Se arma el link a procesar al dar clic en la imagen a imprimir (si existe)
  strPaginaAux = ((paginaActual*tamPagina)-tamPagina+1) & "-" & ((paginaActual*tamPagina)-tamPagina)+i 
  if Registros = 0 THEN strPaginaAux = "0"
  'Imprime página actual, total de registros, etc
  Response.Write "<td style=""border-style:hidden;"" class=""registros"" width=""35%""><div id=""registroAct"">Registros:&nbsp;" & strPaginaAux & "/" & Registros & "</div></td>"
  Response.Write "<td class=""paginacion"" width=30%"" align=""center"">&nbsp;"
  If iPageCount >1 AND paginaActual <> 1 THEN Response.Write "&nbsp;&nbsp;<a href=""javascript:enviar(1);"" title=""Primer pagina""><img src=""" & pathImages & "comboImg/firstpage.gif"" border=""0"" align=""middle""></a>&nbsp;" 
  If iPageCount >1 AND paginaActual > 1 THEN Response.Write "<a href=""javascript:enviar(" & paginaActual -1 & ");"" title=""Pagina anterior""><img src=""" & pathImages & "atrasCmb.jpg"" width=""12"" height=""12"" border=""0"" align=""middle""></a>&nbsp;"
  Response.Write "<input name=""pagina"" id=""pagina2"" type=""text"" onkeyPress=""verificaTxtPag(event,this," & paginaActual & "," & iPageCount & ");"" value=""" & paginaActual & """ maxlength=""6"" style=""width:30px;"" class=""paginacion"" title=""Ingrese un número de página y presione la tecla ENTER"">"
  If iPageCount >1 AND paginaActual < iPageCount THEN Response.Write "<a href=""javascript:enviar(" & paginaActual + 1 & ");"" title=""Pagina siguiente""><img src=""" & pathImages & "adelanteCmb.jpg"" width=""12"" height=""12"" border=""0"" align=""middle"">&nbsp;</a>"
  If iPageCount >1 AND paginaActual <> iPageCount THEN Response.Write "<a href=""javascript:enviar(" & iPageCount & ");"" title=""Ultima pagina""><img src=""" & pathImages & "comboImg/lastpage.gif"" border=""0"" align=""middle"">&nbsp;</a>"
  Response.Write "</td>"
  Response.Write "<td class=""registros"" width=""35%"" align=""right"">Pagina:&nbsp;" & paginaActual & " de " & iPageCount & "&nbsp;&nbsp;" & imgAgregar & "</td>"
  Response.Write "</tr>" 
  Response.Write "</table>"
  Response.Write "</div>"
 END IF
 'variables sobre el estatus de la página actual (NO SE UTILIZA)
 Response.Write"<script>var totPaginas = " & iPageCount & ";var paginaActual=" & paginaActual & ";var indiceAnteriorMandado = '" & Request.Form("indiceAnterior") & "';</script>"
 CALL fnCierraDB(GVMainDB)

   


%>
<script>
 //Se capturan variables de servidor necesarios para asegurar la correcta recursividad y seguimiento de la correcta páginación
 var indiceActual = 0; //Registro seleccionado (sombreado)
 var indiceAnterior = 0; //Registro anterior del actual
 var antStyle = ''; //Estilo (CSS) del registro anterior
 var procesado = '<%= Request.Form("procesado") %>'; //Verifica si ya fue procesado el catálogo (para evitar recargar el catálogo sin necesidad)
 var iFrameFather = document.getElementById('iFrameFather'); //variable del iframe contenedor de este catálogo
 var parentMaster = document.getElementById('parentMaster'); //IFRAME OVER IFRAME (si existe)
 var iFrameFatherX = ''; //auxiliar de iFrameFather
 var strParent = 'parent.'; //variable a usar (sólo cambiara si existe parentMaster)


 if(parentMaster.value!='') strParent = parentMaster.value + '.';
  
 var campoCombo = eval(strParent+'document.all.item(\'<%= cmbTextPadre %>\')'); //campo en donde escribimos la información
 
    
    var campoIdCombo = eval(strParent+'document.all.item(\'<%= cmbIdPadre %>\')'); //campo donde se almacenara la clave del registro seleccionado
 var Catalogo = '<%= catalogo %>'; //nombre del catálogo utilizado
 var resizeNewIFrame = '<%= Request.Form("resizeNewIFrame") %>'; //Verificará si es necesario actualizar el tamaño del catálogo y la posición de este desde lo invoquemos
 var refrescarVentana = 2;
 
 //inicializa variables
 indiceAnterior = -1;
 indiceAnterior2 = -1;
 
 //Determina la posición del objeto padre
 function Point(iX, iY){
	this.x = iX;
	this.y = iY;
 }
 
 function fGetXY(aTag){

  var pt = new Point(aTag.offsetLeft, aTag.offsetTop);
  do {
  	aTag = aTag.offsetParent;
  	pt.x += aTag.offsetLeft;
  	pt.y += aTag.offsetTop;
  } while(aTag.tagName!='BODY');
  return pt;
 }
 
 //Actualiza el tamaño de un iframe o un layer (sólo si aplica y existe la variable iframe dentro de nuestra página padre)
 function resizeParent() { 	
  if(parent.iframe)
   parent.parent.resizeIFrame(parent.iframe);   
  if(parent.ilayer)
   parent.parent.resizeILayer(parent.ilayer);
 }
 
 //Función que detecta si hacemos clic en la página que invoquemos el catálogo y esconderlo, sólo en IFRAME OVER IFRAME
 if(parentMaster.value!='parent') {
  arrayStrParent = parentMaster.value.split('.');
  if(arrayStrParent.length==2) {
   var objetoParentMasterX = eval(parentMaster.value);
   objetoParentMasterX.document.onmousedown=function(e){
    if(objetoParentMasterX.esconderFrame ==1) {
     objetoParentMasterX.esconderFrame =0;
	 window.parent.document.getElementById(iFrameFather.value).style.visibility='hidden';
	}
   }
  }
 }
 
 //función principal
 function verificaCatalogo2(catalogo,cmbPadre,cmbId,iFrameFather,accion,ancho,alto,condicion,accionJavaScript,evento,paginacionX,evento2,targetAux,showFooter,parentMaster) {
  
  var bandera = true;
  var resFrame = false;
  if(!parentMaster) //VERIFICAR SI LO LLAMO OTRO PADRE (IFRAME OVER IFRAME)
	 parentMaster = 'parent';
	 
  try { //new

   var cmbPadreObject = eval(parentMaster+'.document.all.item(\''+cmbPadre+'\')');
  
   if(campoCombo!= cmbPadreObject) {
    Catalogo = '';   
   }
  }
  
  catch(err) {}
  if(bandera) {
    

   if(catalogo!=Catalogo) {
    var iFrameFatherObject = eval('parent.document.getElementById(\''+iFrameFather+'\')');
    

    //iFrameFatherObject.style.width = parseInt(ancho)+20;
    $(iFrameFatherObject).animate({
    width: parseInt(ancho)+20,
    height: parseInt(alto)+20,
    });
    

    //iFrameFatherObject.style.height = parseInt(alto)+20;
    document.getElementById('catalogo').value = catalogo;
    document.getElementById('cmbTextPadre').value = cmbPadre;
    document.getElementById('cmbIdPadre').value = cmbId;
    document.getElementById('accion').value = accion;
	document.getElementById('resizeNewIFrame').value = '1';
    document.getElementById('ancho').value = ancho;
    document.getElementById('alto').value = alto;
	document.getElementById('parentMaster').value = parentMaster;
	if(showFooter)
	 document.getElementById('showFooter').value = showFooter;
	else
	 document.getElementById('showFooter').value = '1';
    document.getElementById('condicion').value = condicion;
    document.getElementById('accionJavaScript').value = accionJavaScript;
    document.getElementById('iFrameFather').value = iFrameFather;
	valorAux='';

    
	var valorAuxObject = eval(parentMaster+'.document.getElementById(\''+cmbPadre+'\')');
   
    
	valorAux = valorAuxObject.value+valorAux;
	
    
    valorAux = valorAuxObject.value;	
    
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
    
     procesaId(false,1,resFrame);
	}
    else
     
	 if(resFrame==false)
      procesaId(evento,false,resFrame);
   }
  }
 }
 
 var posicionAnterior=0; 
   
 function procesa(elemento) {
  var layerA='';
  var layerB='';
    try {
  if (indiceAnterior!=-1)
   
    $('#id'+indiceAnterior).addClass('ContenidoDynamicCombo');

   layerA = $('#alay'+elemento).text();
   layerB = $('#blay'+elemento).text();
  }
  catch(err) { return false;} 
    

  campoIdCombo.value = layerA;
  campoCombo.value = layerB;
  indiceAnterior = elemento;
  indiceAnterior2 = elemento;
  
     $('#id'+indiceAnterior).addClass('SeleccionDynamicCombo');
   
  posicionAnterior = iFrameFatherX.style.top;
  iFrameFatherX.style.top=-1000;
  iFrameFatherX.style.visibility='hidden';
  
    <%= Request("accionJavaScript") %>
   if(campoCombo.enabled) {
    try { campoCombo.focus(); } catch(err) {}
  }
 }
 
 function enviar(pagina) {
  document.getElementById('CampoMostrar').value = campoCombo.value.toLowerCase();
  document.getElementById('procesado').value = 1;
  document.getElementById('pagina').value = pagina; 
  submitForm();
 }
 
 function submitForm(targetAux) {
  document.frmcomboImg.method = 'post';
  document.frmcomboImg.target = '_self';
  document.frmcomboImg.action = '<%= request.ServerVariables("URL") %>';
  if(targetAux)
   document.frmcomboImg.action =targetAux;
  document.frmcomboImg.submit(); 
 }
 
 function verificaTxtPag(evento,objeto,paginaActual,iPageCount) {
  if(evento.keyCode==13) {
   if (!isNaN(objeto.value)) {
    valor = parseInt(objeto.value);
    if(valor>iPageCount || valor<1)
	 alert('Número de página incorrecto');
	else {
	 if(valor!=paginaActual)
	  enviar(objeto.value);
	}
   }
   else
    alert('El número de página debe ser numérico');
  }
 }
 
 function procesaId(evento,tecla2,resizeIframeGo) {

    try { campoCombo.focus(); } catch(err) {}
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
    document.getElementById('indiceAnterior').value =document.getElementById('paginacionX').value;
    enviar(paginaActual-1);
    return true;
   }

  if(indiceAnteriorMandado!='') {  //nuevo
   indiceAnterior2 = parseInt(indiceAnteriorMandado)-1;
   indiceAnterior = parseInt(indiceAnteriorMandado)-2;
   indiceAnteriorMandado = '';
   tecla = 40;
  }
    

  var itop = 0;
  var ileft = 0;
  iFrameFatherX = eval('parent.document.getElementById(\''+iFrameFather.value+'\')');
  

  if(resizeIframeGo) { //sólo entra si es nuevo el campo que solicita el catálogo para actualizar tamaño y posición
   var point = fGetXY(campoCombo);
   with (iFrameFatherX.style) {  
    if(parentMaster.value!='parent') {
     arrayStrParent = parentMaster.value.split('.');
	 if(arrayStrParent.length==2) {
	  var objetoParentMaster = parent.document.getElementById(arrayStrParent[1]);
      itop = objetoParentMaster.offsetTop;
	  ileft = objetoParentMaster.offsetLeft;
	 }
    }
    left = ileft+point.x;
    top  = itop+point.y+campoCombo.offsetHeight+3;
   }
   resizeParent();
  }
  $(iFrameFatherX).css("visibility","visible");
  
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

      //antstyle = $('#bodytable tr',i).style.backgroundColor;
	  tecla = 40;
	  break;
     }
    }
	if(index!=0) {
     indiceAnterior = -1;
	 indiceAnterior2 = -1;
    
	 if(tecla2!=1) {

	  document.getElementById('CampoMostrar').value = campoCombo.value.toLowerCase()+teclaAux;
	  document.getElementById('procesado').value = 1;
      document.getElementById('pagina').value = 1; 
      submitForm();
	 }
   }
  }
  
  if (tecla == 38 || tecla == 40) {
   indiceAnterior2 = indiceAnterior; 
    setTimeout(function(){
   
    $(layCatalogo).css("visibility","visible");
    },10);
    
    
    if (tecla==40) {
    if(indiceAnterior < <%= i-1 %>)
	 indiceAnterior = indiceAnterior+1;
   }
	else {
	 if(indiceAnterior>0)
	  indiceAnterior = indiceAnterior-1;
  }
  for (i=0;i<=<%= i-1 %>;i++)

  $('#id'+i).addClass('ContenidoDynamicCombo');
  
  if(indiceAnterior2!=indiceAnterior) {
    
   layCatalogo.scrollTop = $('#id'+indiceAnterior).offset().top;
  }
  if(indiceAnterior!=-1)

    $('#id'+indiceAnterior).removeClass('ContenidoDynamicCombo');
    $('#id'+indiceAnterior).addClass('SeleccionDynamicCombo');
   
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

 if(posicionAnterior!=0)
  try {iFrameFatherX.style.top=posicionAnterior; } catch(err) {}
	
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
 try { campoCombo.focus(); } catch(err) {}
 if(document.getElementById('alay'+indiceAnterior))
    var auxIdCombo = $('#alay'+indiceAnterior).text();
 else
  var auxIdCombo = '';
 var strToSend = '';
 var mainArray = ASPCatalogue.split('?');
 if(mainArray.length==1) {
  strToSend = ASPCatalogue + '?GVIdSesion=<%=GVIdSesion%>&campoToSend='+campoCombo.value.replace(/&/g,'')+ '&idCampoToSend='+auxIdCombo+'&invocoCatalogo=1';
 }
 else {
  strToSend = mainArray[0];
  var auxArray = mainArray[1].split('&');
  if(auxArray.length==1)
   strToSend = strToSend + '?GVIdSesion=<%=GVIdSesion%>&'+mainArray[1] + '&campoToSend='+campoCombo.value.replace(/&/g,'')+'&idCampoToSend='+auxIdCombo+'&invocoCatalogo=1';
  else {
   var auxStrToSend = '';
   for(var n=0;n<auxArray.length;n++)
    auxStrToSend = auxStrToSend + '&'+ auxArray[n];
   strToSend = strToSend + '?GVIdSesion=<%=GVIdSesion%>&campoToSend='+campoCombo.value.replace(/&/g,'')+'&idCampoToSend='+auxIdCombo+'&invocoCatalogo=1'+auxStrToSend;
  }
 }
 var minute='<%= GVIdUsuario & "_" & hour(now) & "_" & minute(now) & second(now) %>';
 var ventana = window.open(strToSend,'auxiliarCatalogo'+minute,'status=yes,dependent=yes,scrollbars=yes');    
 ventana.top.window.resizeTo(screen.availWidth,screen.availHeight);
    
 ventana.focus();
}

function procesaAspCatalogue2(RequestIdValor,RequestValor) {

 campoCombo.value = RequestValor;
 campoIdCombo.value = RequestIdValor;
 <%= Request("accionJavaScript") %>
 if(campoCombo.enabled) {
  try { campoCombo.focus(); } catch(err) {}
 }
 refrescarVentana = 2;
 iFrameFatherX.style.visibility='hidden';
 
 //verificaCatalogo2(fnCatcatalogo,fnCatcmbPadre,fnCatcmbId,fnCatiFrameFather,fnCataccion,fnCatancho,fnCatalto,fnCatcondicion,fnCataccionJavaScript,fnCatevento,fnCatpaginacionX,fnCatevento2,fnCattargetAux,fnCatshowFooter,fnCatparentMaster)
}

 verifyAction();
 var formulario=document.getElementsByTagName('form'); 
 var iformulario=0
 for(iformulario=0;iformulario<formulario.length;iformulario++) {
  var GVIdSesion = document.createElement('input');
  GVIdSesion.setAttribute('name', 'GVIdSesion');
  GVIdSesion.setAttribute('type', 'hidden');
  GVIdSesion.setAttribute('id', formulario.name+'GVIdSesion');
  GVIdSesion.value = '<%= GVIdSesion %>';
  formulario[iformulario].appendChild(GVIdSesion);
 }
</script>