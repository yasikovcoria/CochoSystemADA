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
 
 Dim j
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
 Response.Write "<form name=""frmComboBox"">"
 Response.Write "<div id=""layCatalogo"" style=""position:absolute;visibility:hidden;top:0px;left:0px;width:" & ancho+20 & "px;height:" & alto & "px;overflow-x:hidden;overflow-y:scroll;border: 1px solid #7499C5;"">"
 Response.Write "<table border=""0"" class="""" width=""" & ancho & "px"" align=""center"" cellpadding=""3px"" cellspacing=""0px"">"
 Response.Write "<tbody id=""bodytable"">"
 separador = "?"
 tamarreglo = 2
  If contador =1 THEN
  for i= 0 to j
   condicionX = ""
   linea = arreglo(i)
   posicion = instr(linea,separador)
   valorId= left(linea,posicion-1)
   posicion = instr(linea,separador)
   linea=right(linea,len(linea)-posicion)
   ValorNombre = linea
   Response.Write "<tr class=""ContenidoDynamicCombo"" id=""id" & i & """ name=""id" & i & """ onClick=""procesa(" & i & ");"" title=""Haga clic para pasar Parámetros"">"
   Response.Write "<td align=""center"" class=""sinbordes"" width=""1px"">&nbsp;</span></td>"
   Response.Write "<td align=""left"" class=""sinbordes""><span class=""celda_titulo"">" _
    & "<div id=""blay" & i + 0 & """>" & ValorNombre & "</div></span></td>"
   Response.Write "</tr>"
   Response.Write "<div id=""alay" & i & """ style=""visibility:hidden;top:0px;position:absolute;"">" &valorId & "</div>"
   Response.Write "</tr>"
  next
 End If 
 Response.Write "</tbody></table></div>"
 Response.WRITE "<input name=""pagina"" id=""pagina"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""catalogo"" id=""catalogo"" type=""hidden"" value=""" & Request.Form("Catalogo") & """>"
 Response.WRITE "<input name=""cmbTextPadre"" id=""cmbTextPadre"" type=""hidden"" value=""" & Request.Form("cmbTextPadre") & """>"
 Response.WRITE "<input name=""cmbIdPadre"" id=""cmbIdPadre"" type=""hidden"" value=""" & Request.Form("cmbIdPadre") & """>"
 Response.WRITE "<input name=""accion"" id=""accion"" type=""hidden"" value=""" & Request.Form("accion") & """>"
 Response.WRITE "<input name=""ancho"" id=""ancho"" type=""hidden"" value=""" & Request.Form("ancho") & """>"
 Response.WRITE "<input name=""alto"" id=""alto"" type=""hidden"" value=""" & Request.Form("alto") & """>"
 Response.WRITE "<input name=""condicion"" id=""condicion"" type=""hidden"" value=""" & Request.Form("condicion") & """>"
 Response.WRITE "<input name=""CampoMostrar"" id=""CampoMostrar"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""accionJavaScript"" id=""accionJavaScript"" type=""hidden"" value=""" & Request.Form("accionJavaScript") & """>"
 Response.WRITE "<input name=""paginacionX"" id=""paginacionX"" type=""hidden"" value=""" & Request.Form("paginacionX") & """>"
 Response.WRITE "<input name=""procesado"" id=""procesado"" type=""hidden"" value="""">"
 Response.WRITE "<input name=""iFrameFather"" id=""iFrameFather"" type=""hidden"" value=""" & Request.Form("iFrameFather") & """>"
 Response.Write "</form>"
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
  } while(aTag.tagName!="BODY");
  return pt;
 }
 
 function verificaCatalogo(catalogo,cmbPadre,cmbId,iFrameFather,accion,ancho,alto,condicion,accionJavaScript,evento,paginacionX,evento2) {
  if(catalogo!=Catalogo) {
   parent.document.getElementById(iFrameFather).style.width = parseInt(ancho)+20;
   parent.document.getElementById(iFrameFather).style.height = parseInt(alto);
   document.getElementById('catalogo').value = catalogo;
   document.getElementById('cmbTextPadre').value = cmbPadre;
   document.getElementById('cmbIdPadre').value = cmbId;
   document.getElementById('accion').value = accion;
   document.getElementById('ancho').value = ancho;
   document.getElementById('alto').value = alto;
   document.getElementById('condicion').value = condicion;
   document.getElementById('accionJavaScript').value = accionJavaScript;
   document.getElementById('iFrameFather').value = iFrameFather;
   document.getElementById('procesado').value = 1;
   document.getElementById('pagina').value = 1; 
   if(!paginacionX)
    paginacionX = 100;
   document.getElementById('paginacionX').value = paginacionX;
   submitForm();
  }
  else {
   if(evento2)
    procesaId(false,1);
   else
    procesaId(evento);
  }
 }
  
 function resizeParent() { 	
  if(parent.iframe)
   parent.parent.resizeIFrame(parent.iframe);
 }
  
 function procesa(elemento) {
  if (antStyle!='' && indiceAnterior!=-1)
	bodytable.rows(indiceAnterior).className ='ContenidoDynamicCombo';
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
 
 function submitForm() {
  document.frmComboBox.method = 'post';
  document.frmComboBox.target = '_self';
  document.frmComboBox.action = 'catalogoEstatico.asp';
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
    alert('EL número de página debe ser numérico');
  }
 
 }
  
 function procesaId(evento,tecla2) {
  campoCombo.focus();
  campoIdCombo.value = '';
  var teclaAux = '';
  var tecla = '';
  if(evento) {
   tecla = evento.keyCode; 
   if (tecla >=48)
    teclaAux = String.fromCharCode(evento.keyCode).toLowerCase();
   if (tecla==16 || tecla ==8)
    return false;
  }
  else
  if (tecla2) {
   tecla = tecla2;
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
    if(navigator.appVersion.indexOf("Mac")!=-1)
     campoCombo.value=campoCombo.value.toLowerCase()+teclaAux;
    tecla = 40;
    for (i=0;i<=<%= i-1 %>;i++) {
     var index = document.getElementById('blay'+i).innerText.toLowerCase().indexOf(campoCombo.value);
	 if(index==0) {
      indiceAnterior = i-1;
	  indiceAnterior2 = i-1;
	  antStyle = bodytable.rows(i).style.backgroundColor ;
	  tecla = 40;
	  break;
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