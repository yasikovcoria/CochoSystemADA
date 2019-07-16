function fnAgregaTRNotaRemision(idTabla, idNotaRemision, idEmpresa, montoNotaRemision, nombreCliente, fechaNotaRemision, estatus) {

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

        var inputIdNotaRemision = document.createElement('input');
        inputIdNotaRemision.type = 'hidden';
        inputIdNotaRemision.id = 'idNotaRemisionHidden' + totalElementosInterno;
        inputIdNotaRemision.name = 'idNotaRemisionHidden' + totalElementosInterno;
        inputIdNotaRemision.value = idNotaRemision;

        var inputIdEmpresa = document.createElement('input');
        inputIdEmpresa.type = 'hidden';
        inputIdEmpresa.id = 'idEmpresaHidden' + totalElementosInterno;
        inputIdEmpresa.name = 'idEmpresaHidden' + totalElementosInterno;
        inputIdEmpresa.value = idEmpresa;

        var rowNombreNotaRemision = document.createElement('td');
        rowNombreNotaRemision.innerText = idNotaRemision;
        rowNombreNotaRemision.style.width = '100px';
        rowNombreNotaRemision.style.textAlign = 'center';
        rowNombreNotaRemision.style.fontSize = '12px';
        rowNombreNotaRemision.appendChild(inputIdNotaRemision);
        rowNombreNotaRemision.appendChild(inputIdEmpresa);

        var inputMontoNotaRemision = document.createElement('input');
        inputMontoNotaRemision.type = 'hidden';
        inputMontoNotaRemision.id = 'montoNotaRemisionHidden' + totalElementosInterno;
        inputMontoNotaRemision.name = 'montoNotaRemisionHidden' + totalElementosInterno;
        inputMontoNotaRemision.value = montoNotaRemision;

        var textoCancela;
        if (estatus == '0') {
            textoCancela = 'Cancelar'
        } else {
            textoCancela = 'Nota Cancelada';
        }

        var inputLink = document.createElement('a');
        inputLink.href = '#';
        inputLink.style.fontWeight = 'bold';
        inputLink.style.color = 'red';
        inputLink.innerText = textoCancela;
        inputLink.id = 'linkCacelaHidden' + totalElementosInterno;
        inputLink.name = 'linkCacelaHidden' + totalElementosInterno;
        inputLink.onclick = function () { fnCancela(totalElementosInterno); }



        var inputImgPDF = document.createElement('img');
        inputImgPDF.width = '25';
        inputImgPDF.height = '20';
        inputImgPDF.id = 'imgPDFHidden' + totalElementosInterno;
        inputImgPDF.name = 'imgPDFHidden' + totalElementosInterno;
        inputImgPDF.src = '../img/Imprimir.png';
        inputImgPDF.style.cursor = 'pointer';
        inputImgPDF.onclick = function () { fnImprimeRecibo(totalElementosInterno); }

     


        var rowPDFNotaRemision = document.createElement('td');
        rowPDFNotaRemision.style.width = '50px';
        rowPDFNotaRemision.style.textAlign = 'center';
        rowPDFNotaRemision.style.fontSize = '12px';
        rowPDFNotaRemision.appendChild(inputImgPDF);

        
        var rowMontoNotaRemision = document.createElement('td');
        rowMontoNotaRemision.innerText = '$ ' + montoNotaRemision;
        rowMontoNotaRemision.style.width = '100px';
        rowMontoNotaRemision.style.textAlign = 'center';
        rowMontoNotaRemision.style.fontSize = '12px';
        rowMontoNotaRemision.appendChild(inputMontoNotaRemision);



        var inputClienteNotaRemision = document.createElement('input');
        inputClienteNotaRemision.type = 'hidden';
        inputClienteNotaRemision.id = 'clienteNotaRemisionHidden' + totalElementosInterno;
        inputClienteNotaRemision.name = 'clienteNotaRemisionHidden' + totalElementosInterno;
        inputClienteNotaRemision.value = nombreCliente;

        var rowClienteNotaRemision = document.createElement('td');
        rowClienteNotaRemision.innerText = nombreCliente;
        rowClienteNotaRemision.style.width = '300px';
        rowClienteNotaRemision.style.fontSize = '12px';
        rowClienteNotaRemision.style.textAlign = 'center';
        rowClienteNotaRemision.appendChild(inputClienteNotaRemision);


        var inputFechaNotaRemision = document.createElement('input');
        inputFechaNotaRemision.type = 'hidden';
        inputFechaNotaRemision.id = 'fechaNotaRemisionHidden' + totalElementosInterno;
        inputFechaNotaRemision.name = 'fechaNotaRemisionHidden' + totalElementosInterno;
        inputFechaNotaRemision.value = fechaNotaRemision;

        var rowFechaNotaRemision = document.createElement('td');
        rowFechaNotaRemision.innerText = fechaNotaRemision;
        rowFechaNotaRemision.style.fontSize = '12px';
        rowFechaNotaRemision.style.width = '100px';
        rowFechaNotaRemision.style.textAlign = 'center';
        rowFechaNotaRemision.appendChild(inputFechaNotaRemision);

       
        var rowEstatusUUID = document.createElement('td');
        rowEstatusUUID.style.fontSize = '12px';
        rowEstatusUUID.style.width = '100px';
        rowEstatusUUID.style.textAlign = 'center';
        rowEstatusUUID.appendChild(inputLink);



        var filaDatos = document.createElement('tr');
        filaDatos.id = 'idRenglonDatos' + totalElementosInterno;
        //filaDatos.onclick = function () { fnCargaNotaRemision(totalElementosInterno); }
        filaDatos.style.fontSize = '12px';
        filaDatos.style.fontWeight = 'bold';
        filaDatos.style.color = 'darkblue';
        filaDatos.style.cursor = '';
        filaDatos.style.backgroundColor = EstiloTR;


        filaDatos.appendChild(rowNombreNotaRemision);
        filaDatos.appendChild(rowMontoNotaRemision);
        filaDatos.appendChild(rowClienteNotaRemision);
        filaDatos.appendChild(rowFechaNotaRemision);
        filaDatos.appendChild(rowEstatusUUID);
        //filaDatos.appendChild(rowXMLNotaRemision);
        filaDatos.appendChild(rowPDFNotaRemision);
        //filaDatos.appendChild(rowMailNotaRemision);
        //filaDatos.appendChild(rowPrecioMenudeo);
        //filaDatos.appendChild(rowCantidadNotaRemision);
        //filaDatos.appendChild(rowObservacionesNotaRemision);

        tablaDatos.appendChild(filaDatos);
        document.getElementById('totalElementosM').value = totalElementosInterno + 1;

    } catch (ex) {
        var regresa = parseFloat(document.getElementById('totalElementosM').value);
        document.getElementById('totalElementosM').value = regresa - 1;
        alert(ex.message);
    }


}
