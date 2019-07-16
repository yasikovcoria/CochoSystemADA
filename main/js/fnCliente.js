function fnPaginarCliente(valorPaginar) {

    var valorInicial = parseFloat(document.getElementById('idPaginaM').value);
    var form1 = document.getElementById('form1');
    document.getElementById('accion').value = 'paginaCliente';
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
function fnAgregaTRCliente(idTabla, idCliente, nombreCliente, correoCliente, tipoPersona, EstiloTR) {

    var tablaDatos = document.getElementById(idTabla);
    var totalElementosInterno = parseFloat(document.getElementById('totalElementosM').value);
    
    try {

        var inputIdCliente = document.createElement('input');
        inputIdCliente.type = 'hidden';
        inputIdCliente.id = 'idClienteHidden' + totalElementosInterno;
        inputIdCliente.name = 'idClienteHidden' + totalElementosInterno;
        inputIdCliente.value = idCliente;


        var rowNombreCliente = document.createElement('td');
        rowNombreCliente.innerText = nombreCliente;
        rowNombreCliente.style.width = '250px';
        rowNombreCliente.style.textAlign = 'center';
        rowNombreCliente.appendChild(inputIdCliente);
        

        var rowCorreoCliente = document.createElement('td');
        rowCorreoCliente.innerText = '' + correoCliente;
        rowCorreoCliente.style.width = '100px';
        rowCorreoCliente.style.textAlign = 'center';
       


        var rowTipoPersona = document.createElement('td');
        rowTipoPersona.innerText = tipoPersona;
        rowTipoPersona.style.width = '100px';
        rowTipoPersona.style.textAlign = 'center';
        
        var imgDirectorio = document.createElement('img');
        imgDirectorio.src = '../img/directorio.png';
        imgDirectorio.style.cursor = 'pointer';
        imgDirectorio.title = 'Editar Cliente';
        imgDirectorio.onclick = function () { fnCargaCliente(totalElementosInterno); }

        var rowEditarCliente = document.createElement('td');
        rowEditarCliente.appendChild(imgDirectorio);
        rowEditarCliente.style.width = '30px';
        rowEditarCliente.style.textAlign = 'center';


        var filaDatos = document.createElement('tr');
        filaDatos.id = 'idRenglonDatos' + totalElementosInterno;
        filaDatos.onclick = function () { fnCargaCliente(totalElementosInterno); }
        //filaDatos.className = EstiloTR;
        filaDatos.style.cursor = 'pointer';

        filaDatos.appendChild(rowNombreCliente);
        filaDatos.appendChild(rowTipoPersona);
        filaDatos.appendChild(rowCorreoCliente);
        filaDatos.appendChild(rowEditarCliente);
       
        tablaDatos.appendChild(filaDatos);
        document.getElementById('totalElementosM').value = totalElementosInterno + 1;

    } catch (ex) {
        var regresa = parseFloat(document.getElementById('totalElementosM').value);
        document.getElementById('totalElementosM').value = regresa - 1;
        alert(ex.message);
    }


}