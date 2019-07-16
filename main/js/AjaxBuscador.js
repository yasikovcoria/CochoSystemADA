function fnCargaCliente() {

    var xmlhttp;
    var variableAleatoria = parseInt(Math.random() * 9999999999);
    var n = document.getElementById('clienteM').value;
    if (n == '') {
        document.getElementById("lista_opciones").innerHTML = "";
        return;
    }

    if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
    }
    else {// code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }
    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
            document.getElementById("lista_opciones").innerHTML = xmlhttp.responseText;
        }
    }
    xmlhttp.open("GET", "../funciones/fnFunciones.aspx?accion=cliente&variable="+n+"&aleatorio="+variableAleatoria, true);
    xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlhttp.send("q=" + n);
}