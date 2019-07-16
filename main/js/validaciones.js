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

function validaId2(id) {
 var contador = true;
 var contador2 = true;
 for (i = 0; i < document.form2.length; i++) {
  var tempobj = document.form2.elements[i];
  if (tempobj.id == id) {
   if (tempobj.type.toLowerCase() == 'checkbox' || tempobj.type.toLowerCase() == 'radio')
    if (tempobj.checked != true)
     contador2=false;
   if (tempobj.type.toLowerCase() == 'text' || tempobj.type.toLowerCase() == 'select-one' || tempobj.type.toLowerCase() == 'password' || tempobj.type.toLowerCase() == 'textarea')
    if (tempobj.value == '')
     contador=false;
  }
 }
 if (contador==false || contador2 == false)
  return false;
 else
  return true;
}

function validaId3(id,forma,nombreCampo,entero,positivo,retornaMensaje,allowBlank) {
 var contador = true;
 var contador2 = true;
 if(!forma)
  forma = document.form1;
 for (i = 0; i < forma.length; i++) {
  var tempobj = forma.elements[i];
  if (tempobj.id == id) {
   if (tempobj.type.toLowerCase() == 'checkbox' || tempobj.type.toLowerCase() == 'radio')
    if (tempobj.checked != true) {
	 if(!retornaMensaje)
	  alert('El campo ' + nombreCampo + ' es obligatorio');
	  else
	   alert(retornaMensaje);
     return false;
	}
   if (tempobj.type.toLowerCase() == 'text' || tempobj.type.toLowerCase() == 'select-one' || tempobj.type.toLowerCase() == 'password' || tempobj.type.toLowerCase() == 'textarea' || tempobj.type.toLowerCase() == 'hidden' || tempobj.type.toLowerCase() == 'file')
   {
    if(entero) {
	 if(entero == '1') {
	  if(isNaN(tempobj.value.replace(/\$|\,|\%/g,'')) || tempobj.value == '') {
	   if(!(allowBlank && tempobj.value == '')) {
	    if(!retornaMensaje)
	    alert('El campo ' + nombreCampo + ' debe de ser numérico');
		else
		 alert(retornaMensaje);
	    cambiaEstiloValida(tempobj);
	    return false;
	   }
	  }
	  if(positivo && parseFloat(tempobj.value.replace(/\$|\,/g,''))<0) {
	   if(!retornaMensaje)
	    alert('El campo ' + nombreCampo + ' debe de ser mayor o igual a cero');
	   else
	    alert(retornaMensaje);
	   cambiaEstiloValida(tempobj);
	   return false;
	  }
	 }
	}
	else {
	 if (tempobj.value == '') {
      cambiaEstiloValida(tempobj);
	  if(!retornaMensaje)
       alert('El campo ' + nombreCampo + ' es obligatorio');
	  else
	   alert(retornaMensaje);
      return false;
     }
	}
   }
  }
 }
 return true;
}

function validaExisteIFrameId(forma,id,mensaje) {
 for (i = 0; i < forma.length; i++) {
  var tempobj = forma.elements[i];
  if (tempobj.id == id)
   return true;
 }
 if(mensaje)
  alert(mensaje);
 return false;
}

function cambiaEstiloValida(objeto) {
 if (objeto.type.toLowerCase() == 'text' || objeto.type.toLowerCase() == 'select-one' || objeto.type.toLowerCase() == 'password' || objeto.type.toLowerCase() == 'textarea' || objeto.type.toLowerCase() == 'file')
  if(objeto.disabled!=true) {
   objeto.style.border = '1px solid red';
  try {
   if(objeto.readOnly!=true) {
    objeto.focus();
   }
  }
  catch(err) {}
 }
}


function validaBusqueda(id,sinMensaje) {
 var contador = 0;
 var contador2 = 0;
 for (i = 0; i < document.form1.length; i++) {
  var tempobj = document.form1.elements[i];
  if (tempobj.id == id) {
   if (tempobj.type.toLowerCase() == 'checkbox' || tempobj.type.toLowerCase() == 'radio')
    if (tempobj.checked == true)
     contador2=++contador2;
   if (tempobj.type.toLowerCase() == 'text' || tempobj.type.toLowerCase() == 'select-one' || tempobj.type.toLowerCase() == 'password' || tempobj.type.toLowerCase() == 'textarea')
    if (tempobj.value != '')
     contador=++contador;
  }
 }
 if (contador>0 || contador2 >0)
  return true;
 else {
  if(!sinMensaje)
   alert('Debe de ingresar por lo menos un criterio de búsqueda');
  else
   if(sinMensaje!=true)
    alert(sinMensaje);
  return false;
 }
}

//Limpieza de objetos por Id
function limpiarId(idEnviado,valor) {
 var valor2 = '';
 if (valor) 
  valor2 = valor;
 for (i = 0; i < document.form1.length; i++) {
  var tempobj = document.form1.elements[i];
  if (tempobj.id == idEnviado) {
   if (tempobj.type.toLowerCase() == 'checkbox' || tempobj.type.toLowerCase() == 'radio')
    tempobj.checked = false;
   if (tempobj.type.toLowerCase() == 'text' || tempobj.type.toLowerCase() == 'password' || tempobj.type.toLowerCase() == 'textarea' || tempobj.type.toLowerCase() == 'hidden')
    tempobj.value =valor2;
   if (tempobj.type.toLowerCase() == 'select-one')
    tempobj.selectedIndex = 0;
  }
 }
}

// Cambia de imagen a la tabla dependiendo los permisos
function mostrar(x,permiso,imagen,accion,forma,valorAccion)
{
  if (permiso == '0') {
   alert('No tiene permiso de realizar movimientos en esta sección.');
  }
  else {
    proceso = accion;
	if (parseInt(navigator.appVersion) > 3) {
		if (esconder != '') {
		  ocultar(esconder);
		}
		if (permiso =='1') {
		  if (accion == '4') {
			document.form1.Ac.disabled = true;
		  }
		  else {
			document.form1.Ac.disabled = false;
		  }
		  if (accion!='1') {
		    //alert('Despues de ingresar un parámetro de búsqueda; dé clic en consulta');
			if (document.form2.Co)
			 document.form2.Co.disabled = false;
			forma.accion.value = valorAccion;
		  }
		  else {
		    limpiar();
			accionFormulario = accion;
		  }
		  eval(layerVar + '["' + x + '"]' + styleVar + '.visibility = "' + 'visible' + '"');
		  cambiar_imagen('image8', 'document', imagen, true)
		  if (accion=='1')
		   forma.accion.value = accion;
		  accionFormulario = accion;
		}		  	
		esconder = x;		
	}
  }
}

function mostrar2(x,permiso,imagen,accion,forma,valorAccion)
{
  if (permiso == '0') {
   alert('No tiene permiso de realizar movimientos en esta sección.');
  }
  else {
    proceso = accion;
	if (parseInt(navigator.appVersion) > 3) {
		if (esconder != '') {
		  ocultar(esconder);
		}
		if (permiso =='1') {
		  if (accion!='1') {
		    //alert('Despues de ingresar un parámetro de búsqueda; dé clic en consulta');
			forma.accion.value = valorAccion;
		  }
		  else {
		    //limpiar();
			accionFormulario = accion;
		  }
		  eval(layerVar + '["' + x + '"]' + styleVar + '.visibility = "' + 'visible' + '"');
		  cambiar_imagen('image8', 'document', imagen, true)
		  if (accion=='1')
		   forma.accion.value = accion;
		  accionFormulario = accion;
		}		  	
		esconder = x;		
	}
  }
}

function limpiarForma(forma) {
 forma.setAttribute('method','');
 forma.setAttribute('action','');
 forma.setAttribute('target','');
 /*forma.method = '';
 forma.action = '';
 forma.target = '';*/
}

function retornaObjeto(name,forma) {
 for (i = 0; i < forma.length; i++) {
  var tempobj = forma.elements[i];
  if (tempobj.name == name) {
   return tempobj;
   break;
  }
 }
}

function retornaObjeto2(name) {
 var auxObjeto = document.all.item(name);
 return auxObjeto;
}


var accionFormulario = '';