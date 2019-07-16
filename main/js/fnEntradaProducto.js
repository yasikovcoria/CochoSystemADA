function fnAgregaTREntrada(idTabla, nombreProducto, unidad, fechaIngreso, precioAnterior, precioActual, cantidadAgregada, existencia,EstiloTR) {

    var tablaDatos = document.getElementById(idTabla);
    var totalElementosInterno = parseFloat(document.getElementById('totalElementosM').value);
    
    try {

       
        var rowNombreProducto = document.createElement('td');
        rowNombreProducto.innerText = nombreProducto;
        //rowNombreProducto.style.width = '200px';
        rowNombreProducto.style.textAlign = 'center';
        rowNombreProducto.style.fontSize = '14px';


        var rowUnidad = document.createElement('td');
        rowUnidad.innerText = '' + unidad;
        //rowPrecioProducto.style.width = '100px';
        rowUnidad.style.fontSize = '14px';
        rowUnidad.style.textAlign = 'center';

        var rowFechaIngreso = document.createElement('td');
        rowFechaIngreso.innerText = fechaIngreso;
        rowFechaIngreso.style.fontSize = '14px';
        //rowUnidadProducto.style.width = '200px';
        rowFechaIngreso.style.textAlign = 'center';


        var rowPrecioAnterior = document.createElement('td');
        rowPrecioAnterior.innerText = '$ ' + precioAnterior;
        rowPrecioAnterior.style.fontSize = '14px';
        //rowProvedorProducto.style.width = '200px';
        rowPrecioAnterior.style.textAlign = 'center';


        var rowPrecioActual = document.createElement('td');
        rowPrecioActual.innerText = '$ ' + precioActual;
        rowPrecioActual.style.fontSize = '14px';
        //rowPrecioMayoreo.style.width = '100px';
        rowPrecioActual.style.textAlign = 'center';

        var rowCantidadAgregada = document.createElement('td');
        rowCantidadAgregada.innerText = cantidadAgregada;
        rowCantidadAgregada.style.fontSize = '14px';
        //rowPrecioMenudeo.style.width = '100px';
        rowCantidadAgregada.style.textAlign = 'center';


        var rowExistencia = document.createElement('td');
        rowExistencia.innerText = existencia;
        rowExistencia.style.fontSize = '14px';
        //rowCantidadProducto.style.width = '100px';
        rowExistencia.style.textAlign = 'center';



        var filaDatos = document.createElement('tr');
        filaDatos.id = 'idRenglonDatos' + totalElementosInterno;
        filaDatos.onclick = function () { fnCargaProducto(totalElementosInterno); }
        //filaDatos.style.fontSize = '14px';
        //filaDatos.style.fontWeight = 'bold';
        //filaDatos.style.color = 'darkblue';
        filaDatos.style.cursor = 'pointer';
        filaDatos.className = EstiloTR;


        filaDatos.appendChild(rowNombreProducto);
        filaDatos.appendChild(rowUnidad);
        filaDatos.appendChild(rowFechaIngreso);
        filaDatos.appendChild(rowPrecioAnterior);
        filaDatos.appendChild(rowPrecioActual);
        filaDatos.appendChild(rowCantidadAgregada);
        filaDatos.appendChild(rowExistencia);
        

        tablaDatos.appendChild(filaDatos);
        document.getElementById('totalElementosM').value = totalElementosInterno + 1;

    } catch (ex) {
        var regresa = parseFloat(document.getElementById('totalElementosM').value);
        document.getElementById('totalElementosM').value = regresa - 1;
        alert(ex.message);
    }


}