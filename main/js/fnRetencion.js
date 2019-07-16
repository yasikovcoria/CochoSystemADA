function fnPaginarRetencion(valorPaginar) {

    var valorInicial = parseFloat(document.getElementById('idPaginaM').value);
    var form1 = document.getElementById('form1');
    document.getElementById('accion').value = 'paginaRecibo';
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
function fnAgregaTRRetencion(idTabla, folioRetencion, nombreCliente, periodo ,tipoRetencion ,estatus,timbrado, EstiloTR) {

    var tablaDatos = document.getElementById(idTabla);
    var totalElementosInterno = parseFloat(document.getElementById('totalElementosM').value);
    
    try {

        var inputIdRetencion = document.createElement('input');
        inputIdRetencion.type = 'hidden';
        inputIdRetencion.id = 'idRetencionHidden' + totalElementosInterno;
        inputIdRetencion.name = 'idRetencionHidden' + totalElementosInterno;
        inputIdRetencion.value = folioRetencion;


        var rowFolioRetencion = document.createElement('td');
        rowFolioRetencion.innerText = folioRetencion;
        rowFolioRetencion.style.width = '50px';
        rowFolioRetencion.style.textAlign = 'center';
        rowFolioRetencion.appendChild(inputIdRetencion);
        

        var rowNombreCliente = document.createElement('td');
        rowNombreCliente.innerText = '' + nombreCliente;
        rowNombreCliente.style.width = '200px';
        rowNombreCliente.style.textAlign = 'center';
       


        var rowPeriodo = document.createElement('td');
        rowPeriodo.innerText = periodo;
        rowPeriodo.style.width = '100px';
        rowPeriodo.style.textAlign = 'center';

        var rowTipoRetencion = document.createElement('td');
        rowTipoRetencion.innerText = tipoRetencion;
        rowTipoRetencion.style.width = '100px';
        rowTipoRetencion.style.textAlign = 'center';

        var rowEstatusRetencion = document.createElement('td');
        rowEstatusRetencion.innerText = estatus;
        rowEstatusRetencion.style.width = '50px';
        rowEstatusRetencion.style.textAlign = 'center';
        


        var imgDirectorio = document.createElement('img');
        imgDirectorio.src = '../img/editar2.png';
        imgDirectorio.style.cursor = 'pointer';
        imgDirectorio.title = 'Editar Recibo';
        imgDirectorio.onclick = function () { fnCargaRetencion(totalElementosInterno); }

        var rowEditarRecibo = document.createElement('td');
        rowEditarRecibo.appendChild(imgDirectorio);
        rowEditarRecibo.style.width = '30px';
        rowEditarRecibo.style.textAlign = 'center';


        var filaDatos = document.createElement('tr');
        filaDatos.id = 'idRenglonDatos' + totalElementosInterno;
        
        filaDatos.className = EstiloTR;
        
        filaDatos.appendChild(rowFolioRetencion);
        filaDatos.appendChild(rowNombreCliente);
        filaDatos.appendChild(rowPeriodo);
        filaDatos.appendChild(rowTipoRetencion);
        filaDatos.appendChild(rowEstatusRetencion);
        filaDatos.appendChild(rowEditarRecibo);
        tablaDatos.appendChild(filaDatos);
        document.getElementById('totalElementosM').value = totalElementosInterno + 1;

    } catch (ex) {
        var regresa = parseFloat(document.getElementById('totalElementosM').value);
        document.getElementById('totalElementosM').value = regresa - 1;
        alert(ex.message);
    }


}


