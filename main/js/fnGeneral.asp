<script>  
      function resizeIFrame(idFrame) {

            var the_height = document.getElementById(idFrame).contentWindow.document.body.scrollHeight;
            var the_width = document.getElementById(idFrame).contentWindow.document.body.scrollWidth;
            document.getElementById(idFrame).width = the_width;
            document.getElementById(idFrame).height = the_height;
        }

        function fnObtenPosicionInput(element) {

            var iframe = document.getElementById('catalogo');

            if (typeof element == "string")
                element = document.getElementById(element)

            if (!element) return { top: 0, left: 0 };

            var y = 0;
            var x = 0;
            while (element.offsetParent) {
                x += element.offsetLeft;
                y += element.offsetTop;
                element = element.offsetParent;
            }


            iframe.style.posLeft = x;
            iframe.style.posTop = y + 22;

        }

function FormatCurrency(num,aux,aux2) { 
 var sign, cents, roundFC; 
 roundFC = '1';
 num = num.toString().replace(/\$|\,|\%/g,''); 
 if(isNaN(num)) 
  num = "0"; 
if (aux){
 if(!isNaN(aux2)) {
  for(var iFC=1;iFC<=parseInt(aux2);iFC++)
   roundFC = roundFC + '0';
  roundFC = parseInt(roundFC);
  num=Math.round(num*roundFC)/roundFC; 
  }
 else
  num=Math.round(num)
}

 sign = (num == (num = Math.abs(num))); 
 num = Math.floor(num*100+0.50000000001); 
 cents = num%100; 
 num = Math.floor(num/100).toString(); 
 if(cents<10) 
  cents = "0" + cents; 
 for (var i = 0; i < Math.floor((num.length-(1+i))/3); i++) 
  num = num.substring(0,num.length-(4*i+3))+','+ 
 num.substring(num.length-(4*i+3)); 
 return (((sign)?'':'-') + '' + num + '.' + cents); 
}

      function fnPaginar(valorPaginar) {

            var valorInicial = parseFloat(document.getElementById('idPaginaM').value);
            var form1 = document.getElementById('form1');
            document.getElementById('accion').value = 'paginaProducto';
            if (valorPaginar == '-1') {
                document.getElementById('idPaginaM').value = valorInicial - 1;
            } else {
                document.getElementById('idPaginaM').value = valorInicial + 1;
            }
            try {
                form1.method = 'POST';
                form1.target = 'fnProcesos';
                form1.submit();
            } catch (ex) {
                alert(ex.message);
            }

        }

  function cambiaEstiloValida(objeto) {
   if (objeto.type.toLowerCase() == 'text' || objeto.type.toLowerCase() == 'select-one' || objeto.type.toLowerCase() == 'password' || objeto.type.toLowerCase() == 'textarea' || objeto.type.toLowerCase() == 'file')
   if(objeto.disabled!=true) {
    objeto.style.border = '1px solid red';
   if(objeto.readOnly!=true)
    objeto.focus();
   }
  }

 function validaId(id,forma) {
 var contador = true;
 var contador2 = true;
 if(!forma)
  forma = document.form1;
 for (i = 0; i < forma.length; i++) {
  var tempobj = forma.elements[i];
  if (tempobj.id == id) {
   if (tempobj.type.toLowerCase() == 'checkbox' || tempobj.type.toLowerCase() == 'radio')
    if (tempobj.checked != true)
     contador2=false;
   if (tempobj.type.toLowerCase() == 'text' || tempobj.type.toLowerCase() == 'select-one' || tempobj.type.toLowerCase() == 'password' || tempobj.type.toLowerCase() == 'textarea' || tempobj.type.toLowerCase() == 'hidden')
    if (tempobj.value == '')
     contador=false;
  }
 }
 if (contador==false || contador2 == false)
  return false;
 else
  return true;
}
  
  function replicaFecha(objeto,nameObjDestino,noVerificarFecha) {
   if(!noVerificarFecha) { noVerificarFecha=false; }
   var ObjDestino = document.getElementById(nameObjDestino);
   var strObjeto = objeto.id;
   var strObjeto2 = objeto.id;
   if(ObjDestino.value=='' && objeto.value!='') {
    ObjDestino.value=objeto.value;
    strObjeto2 = ObjDestino.id;
   }
  }
      function fnLimpiaTabla(idTablaDatos, totalElementos) {

            var tablaDatos = document.getElementById(idTablaDatos);
            try {
                while (tablaDatos.hasChildNodes()) {
                    tablaDatos.removeChild(tablaDatos.firstChild);
                }
                document.getElementById(totalElementos).value = '0';
            } catch (ex) {
                alert(ex.message);
            }
        }
  
  function fnValidaValor(idValidar,objetoFocoValidar,nombreCampo,tipo,boolObligatorio) {
   try { if(idValidar.readOnly) return true; } catch(err) {} 
   try {
    if(idValidar.value=='' && boolObligatorio) {
	 if(boolObligatorio=='1') {
      alert('El campo '+nombreCampo+' es obligatorio');
      try { objetoFocoValidar.focus(); } catch(err) {} 
	  cambiaEstiloValida(objetoFocoValidar);
      return false;
     }
	}
   } catch(err) { alert(err+idValidar+''); return false;}
   
   if(tipo==1 && isNaN(idValidar.value.replace(/\$|\,|\%/g,''))) {
    alert('El campo '+nombreCampo+' debe ser numérico');
    try { objetoFocoValidar.focus(); } catch(err) {} 
	cambiaEstiloValida(objetoFocoValidar);
    return false;
   }
   else { if(idValidar.value!='' && tipo==1) idValidar.value=FormatCurrency(idValidar.value).toString().replace(/\$|\%/g,''); }
   return true;
  }
  
  
  function fnAuxiliarTD(strAuxiliarTD,indiceRecibido,incrementador,strIndice) {
   var TDOrigen = document.getElementById('td'+strAuxiliarTD+indiceRecibido);
   var strTD = TDOrigen.innerHTML;
      
   strTD= eval('strTD.replace(/'+strAuxiliarTD+strIndice+'/g'+',\''+strAuxiliarTD+incrementador+'\');');
   if(strIndice!='') {
    strTD=strTD.replace(eval('/'+'\''+strIndice+''+'\''+'/g'),'\''+incrementador+'\'');
    strTD=strTD.replace(eval('/'+'\"'+strIndice+''+'\"'+'/g'),'\"'+incrementador+'\"');
    strTD=strTD.replace(eval('/'+'\\'+'\\'+'\''+strIndice+'\\'+'\\'+'\''+'/g'),'\\\''+incrementador+'\\\'');
   }
   strTD = strTD.replace(/&amp;/g,'&');
   var tdCreado = document.createElement('TD');
   tdCreado.align=TDOrigen.align;
   tdCreado.className=TDOrigen.className;
   tdCreado.style.visibility=TDOrigen.style.visibility;
   tdCreado.style.color=TDOrigen.style.color;
   tdCreado.style.fontSize=TDOrigen.style.fontSize;
   tdCreado.style.fontWeight=TDOrigen.style.fontWeight;
   tdCreado.colSpan = TDOrigen.colSpan;
   tdCreado.style.paddingTop = TDOrigen.style.paddingTop;

   tdCreado.style.display=TDOrigen.style.display;
   delete(TDOrigen);
   tdCreado.innerHTML=strTD;
      
   return(tdCreado); 
  }
  
  
  function fnAgregaTRDIM(fnBoolElemento,strAuxiliarTD,totalTD,BoolImprimeConsecutivo,strIndice,strCamposValidar,strBodyDetalle,totalObjeto,limpiarObjetos,accionEliminarAuxiliar) {
   var objetoIncrementador = false;
   var arrayObjetosValidar = new Array();
   var arrayObjetosValidarDetalle = new Array();  
   var objetoValidar = false;
   var objetoValidarFoco = false;
   var strEliminarAuxiliar='';
   if(accionEliminarAuxiliar) {
	 strEliminarAuxiliar=accionEliminarAuxiliar;
   }
   
   if(strCamposValidar) {
    arrayObjetosValidar=strCamposValidar.split('?'); 
    for(var iarrayObjetosValidar=0;iarrayObjetosValidar<arrayObjetosValidar.length;iarrayObjetosValidar++) {
     arrayObjetosValidarDetalle = arrayObjetosValidar[iarrayObjetosValidar].split('|');
	 if(arrayObjetosValidar[iarrayObjetosValidar]!='') {
      if(arrayObjetosValidarDetalle.length==5) {
	   objetoValidar = document.getElementById(arrayObjetosValidarDetalle[0]+strAuxiliarTD+strIndice);
	   objetoValidarFoco = objetoValidar;
	   if(arrayObjetosValidarDetalle[1]!='') { objetoValidarFoco = document.getElementById(arrayObjetosValidarDetalle[1]+strAuxiliarTD+strIndice); }
	   if(!fnValidaValor(objetoValidar,objetoValidarFoco,arrayObjetosValidarDetalle[2],arrayObjetosValidarDetalle[3],arrayObjetosValidarDetalle[4])) { return false;}
	  }
	 }   
    }
   }
   
   if(!totalObjeto) {
    var objetoIncrementador = document.getElementById('total'+strAuxiliarTD+strIndice);
      
   }
   else {
    var objetoIncrementador = document.getElementById(totalObjeto);
   }
   
   var bodyTable = document.getElementById('body'+strAuxiliarTD+strIndice);
   var renglon = document.createElement('TR');
   renglon.setAttribute('id', 'idTR'+strAuxiliarTD+objetoIncrementador.value);
   renglon.setAttribute('nowrap', false);
   var eliminaAuxiliar='';
   var arrayDetalleGrupo = new Array();
   if(strBodyDetalle) { 
    arrayDetalleGrupo=strBodyDetalle.split('|');
      ;
    for(iarrayDetalleGrupo=0;iarrayDetalleGrupo<arrayDetalleGrupo.length;iarrayDetalleGrupo++) {
     eliminaAuxiliar = eliminaAuxiliar+'fnEliminaMovDinamico(\'idTR'+strAuxiliarTD+arrayDetalleGrupo[iarrayDetalleGrupo]+objetoIncrementador.value+'\',true);'; 
	}
   }
   
   var strEliminar = '<input name="X" type="button" value="X" class="btn btn-danger" onClick="javascript:fnEliminaMovDinamico(\'idTR'+strAuxiliarTD+objetoIncrementador.value+'\');'+eliminaAuxiliar+strEliminarAuxiliar+'">';
      //strEliminar = '';
   for(var iContador=1;iContador<=totalTD;iContador++) { 
    var tdNuevo = fnAuxiliarTD(strAuxiliarTD,iContador,objetoIncrementador.value,strIndice);
     
	if(BoolImprimeConsecutivo && iContador==1) { tdNuevo.innerHTML = (parseFloat(objetoIncrementador.value)+1).toString()+tdNuevo.innerHTML; }
    renglon.appendChild(tdNuevo); 
	
   }
   
   var tdAction = document.createElement('TD');
   tdAction.setAttribute('align', 'center');
   tdAction.innerHTML=strEliminar;
   renglon.appendChild(tdAction);
   bodyTable.appendChild(renglon);
   
   if(strBodyDetalle) {
    for(iarrayDetalleGrupo=0;iarrayDetalleGrupo<arrayDetalleGrupo.length;iarrayDetalleGrupo++) {
    var actionDetalle = document.getElementById('agregar'+strAuxiliarTD+arrayDetalleGrupo[iarrayDetalleGrupo]+strIndice);
	var renglon2 = document.createElement('TR');
    renglon2.setAttribute('id', 'idTR'+strAuxiliarTD+arrayDetalleGrupo[iarrayDetalleGrupo]+objetoIncrementador.value);
    renglon2.setAttribute('nowrap', false);
	var TDX = document.createElement('TD');
	TDX.colSpan = totalTD;
	var strTDAux= eval('actionDetalle.innerHTML.replace(/'+arrayDetalleGrupo[iarrayDetalleGrupo]+strIndice+'/g'+',\''+arrayDetalleGrupo[iarrayDetalleGrupo]+strIndice+objetoIncrementador.value+'\');');
	strTDAux=strTDAux.replace(eval('/'+'\''+strIndice+''+'\''+'/g'),'\''+strIndice+objetoIncrementador.value+'\'');
	strTDAux=strTDAux.replace(eval('/'+'\"'+strIndice+''+'\"'+'/g'),'\"'+strIndice+objetoIncrementador.value+'\"');
	strTDAux=strTDAux.replace(eval('/'+'\\'+'\\'+'\''+strIndice+'\\'+'\\'+'\''+'/g'),'\\\''+strIndice+objetoIncrementador.value+'\\\'');
	strTDAux = strTDAux.replace(/&amp;/g,'&');
    TDX.innerHTML = strTDAux;
	renglon2.appendChild(TDX);
      
	bodyTable.appendChild(renglon2);
	}
   }
   objetoIncrementador.value = parseFloat(objetoIncrementador.value)+1;
   
   if(limpiarObjetos) {
    for(var iarrayObjetosValidar=0;iarrayObjetosValidar<arrayObjetosValidar.length;iarrayObjetosValidar++) {
     arrayObjetosValidarDetalle = arrayObjetosValidar[iarrayObjetosValidar].split('|');
	 if(arrayObjetosValidar[iarrayObjetosValidar]!='') {
      if(arrayObjetosValidarDetalle.length==5) {
	   objetoValidar = document.getElementById(arrayObjetosValidarDetalle[0]+strAuxiliarTD+strIndice);
	   objetoValidarFoco = objetoValidar;
	   if(arrayObjetosValidarDetalle[1]!='') { objetoValidarFoco = document.getElementById(arrayObjetosValidarDetalle[1]+strAuxiliarTD+strIndice); }
       
	   if (objetoValidar.type.toLowerCase() == 'checkbox' || objetoValidar.type.toLowerCase() == 'radio') {
		   
	    objetoValidar.checked=false;
	   }
	   else {
	    objetoValidar.value='';
	    objetoValidarFoco.value='';
	   }
	  }
	 }   
    }
   }
   
   return true;
  }
  
  function fnEliminaMovDinamico(elementoToDelete,apagarMensaje) {
      
   var bandera = true;
   if(!apagarMensaje) bandera=window.confirm('Dese eliminar el registro seleccionado');
   if(bandera) {
   try {
    var elementoToDelete = document.getElementById(elementoToDelete)
    elementoToDelete.parentNode.removeChild(elementoToDelete);
    delete(elementoToDelete);
      fnSumaTotalFactura('Factura','');
   }
   catch(err){}
  }
 }
</script>
