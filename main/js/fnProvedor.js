
function fnAgregaTRProvedor(idTabla, idProvedor, nombreProvedor, RFCProvedor, direccionProvedor ,telefonoProvedor) {



    var tablaDatos = document.getElementById(idTabla);
    var totalElementosInterno = parseFloat(document.getElementById('totalElementosM').value);
    var StyleTRB = document.getElementById('StyleTR').value;
    var EstiloTR;
    if (StyleTRB == 'lightblue') {
        EstiloTR = 'lightblue';
        document.getElementById('StyleTR').value = 'white';
    } else {
        EstiloTR = 'white';
        document.getElementById('StyleTR').value = 'lightblue';
    }

    try {

        var inputIdProvedor = document.createElement('input');
        inputIdProvedor.type = 'hidden';
        inputIdProvedor.id = 'idProvedorHidden' + totalElementosInterno;
        inputIdProvedor.name = 'idProvedorHidden' + totalElementosInterno;
        inputIdProvedor.value = idProvedor;



        var inputNombreProvedor = document.createElement('input');
        inputNombreProvedor.type = 'hidden';
        inputNombreProvedor.id = 'nombreProvedorHidden' + totalElementosInterno;
        inputNombreProvedor.name = 'nombreProvedorHidden' + totalElementosInterno;
        inputNombreProvedor.value = nombreProvedor;

        var rowNombreProvedor = document.createElement('td');
        rowNombreProvedor.innerText = nombreProvedor;
        rowNombreProvedor.style.width = '200px';
        rowNombreProvedor.style.textAlign = 'center';
        rowNombreProvedor.style.fontSize = '14px';
        rowNombreProvedor.appendChild(inputIdProvedor);
        rowNombreProvedor.appendChild(inputNombreProvedor);

        var inputRFCProvedor = document.createElement('input');
        inputRFCProvedor.type = 'hidden';
        inputRFCProvedor.id = 'rfcProvedorHidden' + totalElementosInterno;
        inputRFCProvedor.name = 'rfcProvedorHidden' + totalElementosInterno;
        inputRFCProvedor.value = RFCProvedor;

        var rowRFCProvedor = document.createElement('td');
        rowRFCProvedor.innerText = '' + RFCProvedor;
        rowRFCProvedor.style.width = '200px';
        rowRFCProvedor.style.fontSize = '14px';
        rowRFCProvedor.style.textAlign = 'center';
        rowRFCProvedor.appendChild(inputRFCProvedor);

        var inputDireccionProvedor = document.createElement('input');
        inputDireccionProvedor.type = 'hidden';
        inputDireccionProvedor.id = 'direccionProvedorHidden' + totalElementosInterno;
        inputDireccionProvedor.name = 'direccionProvedorHidden' + totalElementosInterno;
        inputDireccionProvedor.value = direccionProvedor;


        var rowDireccionProvedor = document.createElement('td');
        rowDireccionProvedor.innerText = direccionProvedor;
        rowDireccionProvedor.style.fontSize = '14px';
        rowDireccionProvedor.style.width = '200px';
        rowDireccionProvedor.style.textAlign = 'center';
        rowDireccionProvedor.appendChild(inputDireccionProvedor);


        var inputTelefonoProvedor = document.createElement('input');
        inputTelefonoProvedor.type = 'hidden';
        inputTelefonoProvedor.id = 'telefonoProvedorHidden' + totalElementosInterno;
        inputTelefonoProvedor.name = 'telefonoProvedorHidden' + totalElementosInterno;
        inputTelefonoProvedor.value = telefonoProvedor;


        var rowTelefonoProvedor = document.createElement('td');
        rowTelefonoProvedor.innerText = telefonoProvedor;
        rowTelefonoProvedor.style.fontSize = '14px';
        rowTelefonoProvedor.style.width = '200px';
        rowTelefonoProvedor.style.textAlign = 'center';
        rowTelefonoProvedor.appendChild(inputTelefonoProvedor);



        var filaDatos = document.createElement('tr');
        filaDatos.id = 'idRenglonDatos' + totalElementosInterno;
        filaDatos.onclick = function () { fnCargaProvedor(totalElementosInterno); }
        filaDatos.style.fontSize = '14px';
        filaDatos.style.fontWeight = 'bold';
        filaDatos.style.color = 'darkblue';
        filaDatos.style.cursor = 'pointer';
        filaDatos.style.backgroundColor = EstiloTR;


        filaDatos.appendChild(rowNombreProvedor);
        filaDatos.appendChild(rowRFCProvedor);
        filaDatos.appendChild(rowDireccionProvedor);
        filaDatos.appendChild(rowTelefonoProvedor);

        tablaDatos.appendChild(filaDatos);
        document.getElementById('totalElementosM').value = totalElementosInterno + 1;

    } catch (ex) {
        var regresa = parseFloat(document.getElementById('totalElementosM').value);
        document.getElementById('totalElementosM').value = regresa - 1;
        alert(ex.message);
    }


}

function fnCargaProvedor(idElemento) {
    var valorAnterior = document.getElementById('valorTRStyle').value;
    document.getElementById('valorTRStyle').value = 'idRenglonDatos' + idElemento;

    var valorNombreProvedor = document.getElementById('nombreProvedorHidden' + idElemento).value;
    var rfcProvedor = document.getElementById('rfcProvedorHidden' + idElemento).value;
    var direccionProvedor = document.getElementById('direccionProvedorHidden' + idElemento).value;
    var telefonoProvedor = document.getElementById('telefonoProvedorHidden' + idElemento).value;
    var idProvedor = document.getElementById('idProvedorHidden' + idElemento).value;

    document.getElementById('idRenglonDatos' + idElemento).style.backgroundColor = 'lightyellow';
    if (valorAnterior != '') {
        document.getElementById(valorAnterior).style.backgroundColor = 'lightblue';
    }
    document.getElementById('idProvedorM').value = idProvedor;
    document.getElementById('nombreProvedorM').value = valorNombreProvedor;
    document.getElementById('RFCProvedorM').value = rfcProvedor;
    document.getElementById('direccionProvedorM').value = direccionProvedor;
    document.getElementById('telefonoProvedorM').value = telefonoProvedor;
}
