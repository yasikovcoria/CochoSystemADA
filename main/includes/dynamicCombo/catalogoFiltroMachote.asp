<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!--#include file="../../funciones/mis_funciones.asp" -->
<link href="../../CSS/dynamicCombo.css" rel="stylesheet" type="text/css"> 
<%  
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
 IF cmbTextPadre = "" THEN cmbTextPadre = "procesado"
 IF cmbIdPadre = "" THEN cmbIdPadre = "procesado"
 if ancho = "" Then ancho = 500
 if alto = "" Then alto = 100
 
 Call ABREDB2(DBMun,Application("DATABASEMUN"))
 InstrSQL = "EXEC spObtieneCatalogo '" & Catalogo & "','" & Session("idEmpresa")& "'"
 Call AbreRS2(RSInstruccion,DBMun,InstrSQL)
 InstrSQL = ""
 Condicion = ""
 If RSInstruccion.EOF <> TRUE THEN
  InstrSQL = "SELECT " & RSInstruccion.Fields("CampoClave") & " AS ID," _
   & RSInstruccion.Fields("CampoMostrar") & " AS Nombre FROM " & RSInstruccion.Fields("Tabla")
  If Request.Form("CampoMostrar") <> "" AND Request.Form("CampoMostrar") <> "all" THEN 
   'Condicion = " WHERE " & RSInstruccion.Fields("CampoMostrar") & " LIKE '%" & Request.Form("CampoMostrar") & "%' "
   'Response.write Condicion & "<br>"
   Condicion = GetCriterio(RSInstruccion.Fields("CampoMostrar"),Replace(Request.Form("CampoMostrar")," ","+"))
   Condicion = " " & Condicion & " "
  End If
  OrderBy = " ORDER BY " & RSInstruccion.Fields("OrderBy")
  NombreCatalogo = RSInstruccion.Fields("Nota")
  ASPPage = RSInstruccion.Fields("ASPPage")
 END IF
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
 'Response.Write InstrSQL & Condicion & OrderBy
' Response.End()
 
 tamarreglo=2
 j = 0
 contador = 0
 dim arreglo()
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
 
 CALL CierraRS(RSInstruccion)
 Response.Write "<form name=""frmComboBox"">"
 Response.Write "<div id=""layCatalogo"" style=""position:absolute;visibility:hidden;top:0px;left:0px;width:" & ancho+20 & "px;height:" & alto-5 & "px;overflow-x:hidden;overflow-y:scroll;border: 1px solid #7499C5;"">"
'Response.Write InstrSQL & Condicion & OrderBy 'aqui
'Response.Write Request("condicion")
'InstrSQL = ""
 IF InstrSQL <> "" THEN
  Response.Write "<table border=""0"" class="""" width=""" & ancho & "px"" align=""center"" cellpadding=""1px"" cellspacing=""0px"">"
  Response.Write "<tbody id=""bodytable"">"
  InstrSQL = InstrSQL & Condicion & OrderBy
  Call AbreRS2(RSCatalogo,DBMun,InstrSQL)
  Registros = RSCatalogo.RecordCount
  tamPagina = 100
  if isnumeric(Request("paginacionX")) THEN tamPagina = CINT(Request("paginacionX"))
  RSCatalogo.Pagesize = tamPagina
  RSCatalogo.CacheSize = tamPagina
  iPageCount = RSCatalogo.PageCount
  If NOT isNumeric(pagina) THEN pagina = 1
  pagina = Cint(pagina)
  If pagina >= iPageCount Then
   paginaActual = iPageCount
  Else
   paginaActual = pagina
  End If
  contador = 0
  IF Registros > 0 THEN RSCatalogo.AbsolutePage = paginaActual
  i = 0
  DO WHILE RSCatalogo.EOF <> TRUE
   if i<tamPagina Then 
    Response.Write "<tr class=""ContenidoDynamicCombo"" id=""id" & i & """ name=""id" & i & """ onClick=""procesa(" & i & ");"" title=""Haga clic para pasar Parámetros"">"
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
  CALL CierraRS(RSCatalogo)
  Response.Write "</tr>"
 End If
 Response.Write "</tbody></table>"
 IF Registros = 0 THEN Response.Write "<span class=""celda_titulo""><font color=""red"">No se encontrarón registros!!!</font></span>"
 Response.Write "</div>"
 Response.WRITE "<input name=""pagina"" id=""pagina"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""catalogo"" id=""catalogo"" type=""hidden"" value=""" & Request.Form("Catalogo") & """>"
 Response.WRITE "<input name=""cmbTextPadre"" id=""cmbTextPadre"" type=""hidden"" value=""" & Request.Form("cmbTextPadre") & """>"
 Response.WRITE "<input name=""cmbIdPadre"" id=""cmbIdPadre"" type=""hidden"" value=""" & Request.Form("cmbIdPadre") & """>"
 Response.WRITE "<input name=""accion"" id=""accion"" type=""hidden"" value=""" & Request.Form("accion") & """>"
 Response.WRITE "<input name=""ancho"" id=""ancho"" type=""hidden"" value=""" & Request.Form("ancho") & """>"
 Response.WRITE "<input name=""alto"" id=""alto"" type=""hidden"" value=""" & Request.Form("alto") & """>"
 Response.WRITE "<input name=""condicion"" id=""condicion"" type=""hidden"" value=""" & Request.Form("condicion") & """>"
 Response.WRITE "<input name=""CampoMostrar"" id=""CampoMostrar"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""indiceAnterior"" id=""indiceAnterior"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""accionJavaScript"" id=""accionJavaScript"" type=""hidden"" value=""" & Request.Form("accionJavaScript") & """>"
 Response.WRITE "<input name=""paginacionX"" id=""paginacionX"" type=""hidden"" value=""" & Request.Form("paginacionX") & """>"
 Response.WRITE "<input name=""procesado"" id=""procesado"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""iFrameFather"" id=""iFrameFather"" type=""hidden"" value=""" & Request.Form("iFrameFather") & """>"
 Response.Write "</form>"
 Response.Write "<div id="""" align=""center"" style=""position:absolute;visibility:visible;top:" & alto-5
 Response.Write "px;left:0px;width:" & ancho +20 & "px;height:20px;overflow: no;"" class=""paginacion"">"
 Response.Write "<table border=""1"" class="""" width=""" & ancho +20 & "px"" align=""center"">"
 Response.Write "<tr class=""registros"">"
 imgAgregar = ""
 if ASPPage <> "" THEN imgAgregar = "<A href=""" & ASPPage & """ target=""_blank""><img src=""" & pathImages _
 & "comboBox/edit.gif"" border=""0"" align=""top"" title=""Haga clic para agregar, modificar o eliminar registros""" _
 & " onMouseOver=""this.src='" & pathImages & "comboBox/edit2.gif" & "';"" onMouseOut=""this.src='" & pathImages _
 & "comboBox/edit.gif" & "';"">"
 strPaginaAux = ((paginaActual*tamPagina)-tamPagina+1) & "-" & ((paginaActual*tamPagina)-tamPagina)+i 
 if Registros = 0 THEN strPaginaAux = "0" 
 Response.Write "<td class=""registros"" width=""35%""><div id=""registroAct"">Registros:&nbsp;" & strPaginaAux & "/" & Registros & "</div></td>"
 Response.Write "<td class=""paginacion"" width=30%"" align=""center"">&nbsp;"
 If iPageCount >1 AND paginaActual <> 1 THEN Response.Write "&nbsp;&nbsp;<a href=""javascript:enviar(1);"" title=""Primer página""><img src=""" & pathImages & "comboBox/firstpage.gif"" border=""0"" align=""middle""></a>&nbsp;" 
 If iPageCount >1 AND paginaActual > 1 THEN Response.Write "<a href=""javascript:enviar(" & paginaActual -1 & ");"" title=""Página anterior""><img src=""" & pathImages & "comboBox/prevpage.gif"" border=""0"" align=""middle""></a>&nbsp;"
 Response.Write "<input name=""pagina"" id=""pagina2"" type=""text"" onkeyPress=""verificaTxtPag(event,this," & paginaActual & "," & iPageCount & ");"" value=""" & paginaActual & """ maxlength=""6"" style=""width:30px;"" class=""paginacion"" title=""Ingrese un número de página y presione la tecla ENTER"">"
 If iPageCount >1 AND paginaActual < iPageCount THEN Response.Write "<a href=""javascript:enviar(" & paginaActual + 1 & ");"" title=""Página siguiente""><img src=""" & pathImages & "comboBox/nextpage.gif"" border=""0"" align=""middle"">&nbsp;</a>"
 If iPageCount >1 AND paginaActual <> iPageCount THEN Response.Write "<a href=""javascript:enviar(" & iPageCount & ");"" title=""Ultima página""><img src=""" & pathImages & "comboBox/lastpage.gif"" border=""0"" align=""middle"">&nbsp;</a>"
 Response.Write "</td>"
 Response.Write "<td class=""registros"" width=""35%"" align=""right"">Página:&nbsp;" & paginaActual & " de " & iPageCount & "&nbsp;&nbsp;" & imgAgregar & "</td>"
 Response.Write "</tr>" 
 Response.Write "</table>"
 Response.Write "</div>"
 Response.Write"<script>var totPaginas = " & iPageCount & ";var paginaActual=" & paginaActual & ";var indiceAnteriorMandado = '" & Request.Form("indiceAnterior") & "';</script>"
 CALL CierraDB2(DBMun)
%>
<script>
 
 var indiceActual = 0;
 var indiceAnterior = 0;
 var antStyle = '';
 var procesado = '<%= Request.Form("procesado") %>';
 var iFrameFather = document.getElementById('iFrameFather');
 var iFrameFatherX = '';
 var campoCombo = parent.document.all.item('<%= cmbTextPadre %>');
 var campoIdCombo = parent.document.all.item('<%= cmbIdPadre %>');
 var Catalogo = '<%= catalogo %>';
 indiceAnterior = -1;
 indiceAnterior2 = -1;
 
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
 
 function resizeParent() { 	
  if(parent.iframe)
   parent.parent.resizeIFrame(parent.iframe);
 }
 
 function verificaCatalogo(catalogo,cmbPadre,cmbId,iFrameFather,accion,ancho,alto,condicion,accionJavaScript,evento,paginacionX,evento2,targetAux) {
  var bandera = true;
  if(!evento2)
   bandera = caracterValido(evento.keyCode);
  try { //new
  if(campoCombo!= parent.document.all.item(cmbPadre))
   Catalogo = '';
  }
  catch(err) {}
  if(bandera) {
   if(catalogo!=Catalogo) {
    parent.document.getElementById(iFrameFather).style.width = parseInt(ancho)+20;
    parent.document.getElementById(iFrameFather).style.height = parseInt(alto)+20;
    document.getElementById('catalogo').value = catalogo;
    document.getElementById('cmbTextPadre').value = cmbPadre;
    document.getElementById('cmbIdPadre').value = cmbId;
    document.getElementById('accion').value = accion;
    document.getElementById('ancho').value = ancho;
    document.getElementById('alto').value = alto;
    document.getElementById('condicion').value = condicion;
    document.getElementById('accionJavaScript').value = accionJavaScript;
    document.getElementById('iFrameFather').value = iFrameFather;
	if(evento2)
     valorAux='';
    else {
     if(caracterValido2(evento.keyCode))
	  valorAux = String.fromCharCode(evento.keyCode).toLowerCase();
	 else 
	  valorAux='';
	}
	valorAux = parent.document.all.item(cmbPadre).value+valorAux;	
	document.getElementById('CampoMostrar').value = valorAux;
    document.getElementById('procesado').value = 1;
    document.getElementById('pagina').value = 1; 
    if(!paginacionX)
     paginacionX = 100;
    document.getElementById('paginacionX').value = paginacionX;
    submitForm(targetAux);
   }
   else {
    if(evento2) {
     procesaId(false,1);
	 }
    else
     procesaId(evento);
   }
  }
 }
 
 function caracterValido(codeCaracter) {
  var arrayCaracter = new Array(8,18,22,33,34,35,36,37,39,46); 
  for(var i=0;i<arrayCaracter.length;i++) {
   if(arrayCaracter[i]==codeCaracter)
    return false;
  }
  return true;
 }
 
 function caracterValido2(codeCaracter) {
  var arrayCaracter = new Array(8,9,13,18,22,33,34,35,36,37,38,39,40,46); 
  for(var i=0;i<arrayCaracter.length;i++) {
   if(arrayCaracter[i]==codeCaracter)
    return false;
  }
  return true;
 }
  
 function procesa(elemento) {
  if (antStyle!='' && indiceAnterior!=-1)
	bodytable.rows(indiceAnterior).className ='ContenidoDynamicCombo'
  var layerA = document.getElementById('alay'+elemento).innerText;
  var layerB = document.getElementById('blay'+elemento).innerText;
  campoIdCombo.value = layerA;
  campoCombo.value = layerB;
  indiceAnterior = elemento;
  indiceAnterior2 = elemento;
  antStyle = bodytable.rows(indiceAnterior).style.backgroundColor ;
  bodytable.rows(indiceAnterior).className ='SeleccionDynamicCombo'
  <%= Request("accionJavaScript") %>
  campoCombo.focus();
  iFrameFatherX.style.visibility='hidden';
 }
 
 function enviar(pagina) {
  document.getElementById('CampoMostrar').value = campoCombo.value.toLowerCase();
  document.getElementById('procesado').value = 1;
  document.getElementById('pagina').value = pagina; 
  submitForm();
 }
 
 function submitForm(targetAux) {
  document.frmComboBox.method = 'post';
  document.frmComboBox.target = '_self';
  document.frmComboBox.action = 'catalogo.asp';
  if(targetAux)
   document.frmComboBox.action =targetAux;
  document.frmComboBox.submit(); 
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
 
 function procesaId(evento,tecla2) {
  campoCombo.focus();
  //campoIdCombo.value = '';
  var teclaAux = '';
  var tecla = '';
  if(evento) {
   tecla = evento.keyCode; 
   if (tecla >=48) {
    teclaAux = String.fromCharCode(evento.keyCode).toLowerCase();
	campoIdCombo.value = '';
   }
   if (tecla==16 || tecla ==8)
    return false;
  }
  else
  if (tecla2) {
   tecla = tecla2;
  }
  
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
  
  iFrameFatherX = parent.document.getElementById(iFrameFather.value);
  var point = fGetXY(campoCombo);
  with (iFrameFatherX.style) {
   left = point.x;
   top  = point.y+campoCombo.offsetHeight+3;
   visibility = "visible";
  }
  resizeParent();
  if ((tecla==13||tecla==9) && indiceAnterior!=-1) {
   procesa(indiceAnterior);
  }
  else
   if (tecla!=38 && tecla!=40) {
    tecla = 40;
    for (i=0;i<=<%= i-1 %>;i++) {
     var index = document.getElementById('blay'+i).innerText.toLowerCase().indexOf(campoCombo.value.toLowerCase()+teclaAux);
	 //if(index!=-1) {
	 if(index==0) {
      indiceAnterior = i-1;
	  indiceAnterior2 = i-1;
	  antStyle = bodytable.rows(i).style.backgroundColor ;
	  tecla = 40;
	  break;
     }
    }
	//if(index==-1 || (!index)) {
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
 procesaId(false,1);
}
</script>