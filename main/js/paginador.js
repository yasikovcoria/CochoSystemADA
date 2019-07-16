function objetoAjaxPaginador() {
    var xmlhttp = false;
    try {
        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            xmlhttp = false;
        }
    }
    if (!xmlhttp && typeof XMLHttpRequest != 'undefined') {
        xmlhttp = new XMLHttpRequest();
    }
    return xmlhttp;
}

function Paginador(nropagina) {
    
    divContenido = document.getElementById('contenido');

    ajax = objetoAjax();
   
    ajax.open("GET", "fnFunciones.aspx?accion=paginar&numeroPagina=" + nropagina);
    divContenido.innerHTML = '<img src="anim.gif">';
    ajax.onreadystatechange = function () {
        if (ajax.readyState == 4) {
          
            divContenido.innerHTML = ajax.responseText
        }
    }
    
    ajax.send(null)
}