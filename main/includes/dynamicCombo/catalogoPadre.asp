<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<html>
<head>
<title>Prueba</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="STYLESHEET" type="text/css" href="../../CSS/dynamicCombo.css">
<script>
document.onclick=function(){esconder();}
function prueba(){
document.getElementById('cuenta').value ='';
document.getElementById('idCuenta').value ='';
}
var esconderFrame =0;
function esconder() {
 if (esconderFrame==1)
  document.getElementById("catalogo").style.visibility="hidden";
 esconderFrame = 1;
}
</script>
</head>
<body>
<iframe src="catalogo.asp" id="catalogo" name="catalogo" width="220px" frameborder="0" scrolling="no" style="border:0 ridge;visibility:hidden;position:absolute;z-index:65535"></iframe>
puesto<input name="XXX" type="text" size="100" maxlength="100" onKeyDown="catalogo.verificaCatalogo('puesto','XXX','hiddenPuesto','catalogo',0,400,100,'AND?PtoIdEmpresa&=\'<%= Session("idEmpresa") %>\'|OR?PtoIdPuesto&in(1,2,3)|AND?PtoDescripcion&<>\'\'','',event);">
<input type="hidden" name="hiddenPuesto" id="hiddenPuesto">
<br>
Tipo Póliza<input name="poliza" type="text" size="100" maxlength="100" onKeyDown="catalogo.verificaCatalogo('Tipo Póliza','poliza','hiddenPoliza','catalogo',0,300,100,'AND?TPolIdEmpresa&=\'<%= Session("idEmpresa") %>\'','',event);">
<input type="hidden" name="hiddenPoliza" id="hiddenPoliza">
<br>
Mayor<div style="width:320px;" class="dynamicCombo"><input name="mayor" id="mayor" type="text"  maxlength="100" onKeyDown="catalogo.verificaCatalogo('Mayor','mayor','idMayor','catalogo',0,300,100,'AND?MayIdEmpresa&=\'<%= Session("idEmpresa") %>\'','parent.prueba();',event,10);" style="width:300px;" class="dynamicCombo"><img src="../../images/comboBox/button.gif" onMouseOver="this.src='../../images/comboBox/button_hl.gif';" onMouseOut="this.src='../../images/comboBox/button.gif';" onClick="this.src='../../images/comboBox/button_pressed.gif';catalogo.verificaCatalogo('Mayor','mayor','idMayor','catalogo',0,300,100,'AND?MayIdEmpresa&=\'<%= Session("idEmpresa") %>\'','parent.prueba();',event,10,true);esconderFrame=0;" style="cursor: hand" align="top"></div>
<input type="hidden" name="idMayor" id="idMayor">

<br>
Cuenta<input name="cuenta" type="text" size="100" maxlength="100" onKeyDown="catalogo.verificaCatalogo('cuenta','cuenta','idCuenta','catalogo',0,300,100,'AND?CtaIdEmpresa&=\'<%= Session("idEmpresa") %>\'|AND?CtaIdTitulo+\'-\'+CtaIdSubtitulo+\'-\'+CtaIdMayor&=\'' + document.getElementById('idMayor').value + '\'|AND?CtaAfectable&=1','',event);">
<input type="hidden" name="idCuenta" id="idCuenta">
<br>
</body>
</html>