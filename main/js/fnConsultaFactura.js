function fnAgregaTRFactura(idTabla, idFactura,idEmpresa,montoFactura, nombreCliente, fechaFactura, tipoFolio, estatusUUID, campoXML,porCobrar) {

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

        var inputIdFactura = document.createElement('input');
        inputIdFactura.type = 'hidden';
        inputIdFactura.id = 'idFacturaHidden' + totalElementosInterno;
        inputIdFactura.name = 'idFacturaHidden' + totalElementosInterno;
        inputIdFactura.value = idFactura;

        var inputIdEmpresa = document.createElement('input');
        inputIdEmpresa.type = 'hidden';
        inputIdEmpresa.id = 'idEmpresaHidden' + totalElementosInterno;
        inputIdEmpresa.name = 'idEmpresaHidden' + totalElementosInterno;
        inputIdEmpresa.value = idEmpresa;

        var rowNombreFactura = document.createElement('td');
        rowNombreFactura.innerText = idFactura;
        rowNombreFactura.style.width = '100px';
        rowNombreFactura.style.textAlign = 'center';
        rowNombreFactura.style.fontSize = '10px';
        rowNombreFactura.appendChild(inputIdFactura);
        rowNombreFactura.appendChild(inputIdEmpresa);

        var inputMontoFactura = document.createElement('input');
        inputMontoFactura.type = 'hidden';
        inputMontoFactura.id = 'montoFacturaHidden' + totalElementosInterno;
        inputMontoFactura.name = 'montoFacturaHidden' + totalElementosInterno;
        inputMontoFactura.value = montoFactura;

        var inputLink = document.createElement('a');
        inputLink.href = '#';
        inputLink.style.fontWeight = 'bold';
        inputLink.style.color = 'black';
        inputLink.innerText = estatusUUID;
        inputLink.id = 'linkCacelaHidden' + totalElementosInterno;
        inputLink.name = 'linkCacelaHidden' + totalElementosInterno;
        inputLink.onclick = function () { fnCancela(totalElementosInterno); }


        var inputImgLink = document.createElement('img');
        inputImgLink.width = '30';
        inputImgLink.height = '20';
        inputImgLink.id = 'imgLinkHidden' + totalElementosInterno;
        inputImgLink.name = 'imgLinkHidden' + totalElementosInterno;
        inputImgLink.src = '../img/xml.png';
        inputImgLink.style.cursor = 'pointer';
        inputImgLink.onclick = function () { fnImprimeXML(totalElementosInterno); }

        var inputImgPDF = document.createElement('img');
        inputImgPDF.width = '25';
        inputImgPDF.height = '20';
        inputImgPDF.id = 'imgPDFHidden' + totalElementosInterno;
        inputImgPDF.name = 'imgPDFHidden' + totalElementosInterno;
        inputImgPDF.src = '../img/Imprimir.png';
        inputImgPDF.style.cursor = 'pointer';
        inputImgPDF.onclick = function () { fnImprimeRecibo(totalElementosInterno); }

        var inputImgMail = document.createElement('img');
        inputImgMail.width = '25';
        inputImgMail.height = '20';
        inputImgMail.id = 'imgMailHidden' + totalElementosInterno;
        inputImgMail.name = 'imgMailHidden' + totalElementosInterno;
        inputImgMail.src = '../img/correo.png';
        inputImgMail.style.cursor = 'pointer';
        inputImgMail.onclick = function () { fnEnviaCorreo(totalElementosInterno); }


        var rowXMLFactura = document.createElement('td');
        rowXMLFactura.style.textAlign = 'center';
        rowXMLFactura.appendChild(inputImgLink);

        var rowPDFFactura = document.createElement('td');
        rowPDFFactura.style.textAlign = 'center';
        rowPDFFactura.appendChild(inputImgPDF);

        var rowMailFactura = document.createElement('td');
        rowMailFactura.style.textAlign = 'center';
        rowMailFactura.appendChild(inputImgMail);



        var rowMontoFactura = document.createElement('td');
        rowMontoFactura.innerText ='$ '+ montoFactura;
        rowMontoFactura.style.textAlign = 'center';
        rowMontoFactura.appendChild(inputMontoFactura);
        


        var inputClienteFactura = document.createElement('input');
        inputClienteFactura.type = 'hidden';
        inputClienteFactura.id = 'clienteFacturaHidden' + totalElementosInterno;
        inputClienteFactura.name = 'clienteFacturaHidden' + totalElementosInterno;
        inputClienteFactura.value = nombreCliente;

        var rowClienteFactura = document.createElement('td');
        rowClienteFactura.innerText = nombreCliente;

        rowClienteFactura.style.textAlign = 'center';
        rowClienteFactura.appendChild(inputClienteFactura);

        
        var inputFechaFactura = document.createElement('input');
        inputFechaFactura.type = 'hidden';
        inputFechaFactura.id = 'fechaFacturaHidden' + totalElementosInterno;
        inputFechaFactura.name = 'fechaFacturaHidden' + totalElementosInterno;
        inputFechaFactura.value = fechaFactura;

        var rowFechaFactura = document.createElement('td');
        rowFechaFactura.innerText = fechaFactura;

        rowFechaFactura.style.textAlign = 'center';
        rowFechaFactura.appendChild(inputFechaFactura);

        var inputTipoFolio = document.createElement('input');
        inputTipoFolio.type = 'hidden';
        inputTipoFolio.id = 'tipoFolioHidden' + totalElementosInterno;
        inputTipoFolio.name = 'tipoFolioHidden' + totalElementosInterno;
        inputTipoFolio.value = tipoFolio;

        var rowEstatusUUID = document.createElement('td');

        rowEstatusUUID.style.textAlign = 'center';
        rowEstatusUUID.appendChild(inputTipoFolio);
        rowEstatusUUID.appendChild(inputLink);



        var filaDatos = document.createElement('tr');
        filaDatos.id = 'idRenglonDatos' + totalElementosInterno;
        //filaDatos.onclick = function () { fnCargaFactura(totalElementosInterno); }
        filaDatos.style.cursor = 'pointer';
        //filaDatos.className = 'infoNew';
        filaDatos.style.color = 'black';
        filaDatos.style.fontSize = '11px';

        if (porCobrar == 'Por Cobrar') {
            filaDatos.className = 'infoNew';
            filaDatos.onclick = function () { fnAgregaComplementoPago(totalElementosInterno); }
        }



        filaDatos.appendChild(rowNombreFactura);
        filaDatos.appendChild(rowMontoFactura);
        filaDatos.appendChild(rowClienteFactura);
        filaDatos.appendChild(rowFechaFactura);
        filaDatos.appendChild(rowEstatusUUID);
        filaDatos.appendChild(rowXMLFactura);
        filaDatos.appendChild(rowPDFFactura);
        filaDatos.appendChild(rowMailFactura);
        //filaDatos.appendChild(rowPrecioMenudeo);
        //filaDatos.appendChild(rowCantidadFactura);
        //filaDatos.appendChild(rowObservacionesFactura);

        tablaDatos.appendChild(filaDatos);
        document.getElementById('totalElementosM').value = totalElementosInterno + 1;

    } catch (ex) {
        var regresa = parseFloat(document.getElementById('totalElementosM').value);
        document.getElementById('totalElementosM').value = regresa - 1;
        alert(ex.message);
    }


}
