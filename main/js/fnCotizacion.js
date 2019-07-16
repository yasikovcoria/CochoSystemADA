
function fnAgregaTRCotizacion(idTabla, numeroCotizacion, nombreCliente, montoCotizacion, fechaCotizacion, idEmpresa) {

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

        var inputIdCotizacion = document.createElement('input');
        inputIdCotizacion.type = 'hidden';
        inputIdCotizacion.id = 'idCotizacion' + totalElementosInterno;
        inputIdCotizacion.name = 'idCotizacion' + totalElementosInterno;
        inputIdCotizacion.value = numeroCotizacion;

        var inputIdEmpresa = document.createElement('input');
        inputIdEmpresa.type = 'hidden';
        inputIdEmpresa.id = 'idEmpresa' + totalElementosInterno;
        inputIdEmpresa.name = 'idEmpresa' + totalElementosInterno;
        inputIdEmpresa.value = idEmpresa;


        var rowNombreCotizacion = document.createElement('td');
        rowNombreCotizacion.innerText = numeroCotizacion;
        rowNombreCotizacion.style.width = '120px';
        rowNombreCotizacion.style.textAlign = 'center';
        rowNombreCotizacion.style.fontSize = '12px';
        rowNombreCotizacion.appendChild(inputIdCotizacion);
        rowNombreCotizacion.appendChild(inputIdEmpresa);
        

        var rowMontoCotizacion = document.createElement('td');
        rowMontoCotizacion.innerText =  montoCotizacion;
        rowMontoCotizacion.style.width = '100px';
        rowMontoCotizacion.style.fontSize = '12px';
        rowMontoCotizacion.style.textAlign = 'center';
        

        var rowNombreCliente = document.createElement('td');
        rowNombreCliente.innerText = nombreCliente;
        rowNombreCliente.style.fontSize = '12px';
        rowNombreCliente.style.width = '300px';
        rowNombreCliente.style.textAlign = 'center';

        var rowFechaCotizacion = document.createElement('td');
        rowFechaCotizacion.innerText = fechaCotizacion;
        rowFechaCotizacion.style.fontSize = '12px';
        rowFechaCotizacion.style.width = '200px';
        rowFechaCotizacion.style.textAlign = 'center';

        var imgImpresion = document.createElement('img');
        imgImpresion.src = '../img/Imprimir.png';
        imgImpresion.width = '20';
        imgImpresion.height = '20';
        imgImpresion.title = 'Imprimir Cotizacion';
        imgImpresion.onclick = function(){ fnImprimeCotizacion(totalElementosInterno);}

        var rowimpresion = document.createElement('td');
        
        rowimpresion.style.width = '30px';
        rowimpresion.style.textAlign = 'center';
        rowimpresion.appendChild(imgImpresion);
        

        var filaDatos = document.createElement('tr');
        filaDatos.id = 'idRenglonDatos' + totalElementosInterno;
        filaDatos.style.fontSize = '12px';
        filaDatos.style.fontWeight = 'bold';
        filaDatos.style.color = 'black';
        filaDatos.style.cursor = 'pointer';
        filaDatos.className = 'infoNew';

        filaDatos.appendChild(rowNombreCotizacion);
        filaDatos.appendChild(rowNombreCliente);
        filaDatos.appendChild(rowMontoCotizacion);
        filaDatos.appendChild(rowFechaCotizacion);
        filaDatos.appendChild(rowimpresion);
        

        tablaDatos.appendChild(filaDatos);
        document.getElementById('totalElementosM').value = totalElementosInterno + 1;

    } catch (ex) {
        var regresa = parseFloat(document.getElementById('totalElementosM').value);
        document.getElementById('totalElementosM').value = regresa - 1;
        alert(ex.message);
    }


}
