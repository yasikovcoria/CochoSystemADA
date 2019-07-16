
function fnAgregaTRProducto(idTabla, idProducto, nombreProducto, precioProducto, idUnidadProducto, unidadProducto, idProvedorProducto, ProvedorProducto, PrecioMayoreo, PrecioMenudeo, CantidadProducto, observacionesproducto,
    modeloProducto, colorProducto, tallaProducto, fechaProducto, precioCompra, EstiloTR, claveSAT) {

    var tablaDatos = document.getElementById(idTabla);
    //tablaDatos.className = 'table table-hover';
    var totalElementosInterno = parseFloat(document.getElementById('totalElementosM').value);
    var StyleTRB = document.getElementById('StyleTR').value;
    
    
    try {

        var inputIdProducto = document.createElement('input');
        inputIdProducto.type = 'hidden';
        inputIdProducto.id = 'idproductoHidden' + totalElementosInterno;
        inputIdProducto.name = 'idproductoHidden' + totalElementosInterno;
        inputIdProducto.value = idProducto;

        

        var inputNombreProducto = document.createElement('input');
        inputNombreProducto.type = 'hidden';
        inputNombreProducto.id = 'nombreProductoHidden' + totalElementosInterno;
        inputNombreProducto.name = 'nombreProductoHidden' + totalElementosInterno;
        inputNombreProducto.value = nombreProducto;

        var rowNombreProducto = document.createElement('td');
        rowNombreProducto.innerText = nombreProducto;
        //rowNombreProducto.style.width = '200px';
        rowNombreProducto.style.textAlign = 'center';
        rowNombreProducto.style.fontSize = '10px';
        rowNombreProducto.appendChild(inputIdProducto);
        rowNombreProducto.appendChild(inputNombreProducto);
        
        var inputPrecioProducto = document.createElement('input');
        inputPrecioProducto.type = 'hidden';
        inputPrecioProducto.id = 'precioProductoHidden' + totalElementosInterno;
        inputPrecioProducto.name = 'precioProductoHidden' + totalElementosInterno;
        inputPrecioProducto.value = precioProducto;

        var rowPrecioProducto = document.createElement('td');
        rowPrecioProducto.innerText = '$ '+precioProducto;
        //rowPrecioProducto.style.width = '100px';
        rowPrecioProducto.style.fontSize = '10px';
        rowPrecioProducto.style.textAlign = 'center';
        rowPrecioProducto.appendChild(inputPrecioProducto);

        var inputIdUnidadProducto = document.createElement('input');
        inputIdUnidadProducto.type = 'hidden';
        inputIdUnidadProducto.id = 'idUnidadProductoHidden' + totalElementosInterno;
        inputIdUnidadProducto.name = 'idUnidadProductoHidden' + totalElementosInterno;
        inputIdUnidadProducto.value = idUnidadProducto;

        var inputUnidadProducto = document.createElement('input');
        inputUnidadProducto.type = 'hidden';
        inputUnidadProducto.id = 'unidadProductoHidden' + totalElementosInterno;
        inputUnidadProducto.name = 'unidadProductoHidden' + totalElementosInterno;
        inputUnidadProducto.value = unidadProducto;

        var rowUnidadProducto = document.createElement('td');
        rowUnidadProducto.innerText = unidadProducto;
        rowUnidadProducto.style.fontSize = '10px';
        //rowUnidadProducto.style.width = '200px';
        rowUnidadProducto.style.textAlign = 'center';
        rowUnidadProducto.appendChild(inputIdUnidadProducto);
        rowUnidadProducto.appendChild(inputUnidadProducto);

        var inputIdProvedorProducto = document.createElement('input');
        inputIdProvedorProducto.type = 'hidden';
        inputIdProvedorProducto.id = 'idProvedorProductoHidden' + totalElementosInterno;
        inputIdProvedorProducto.name = 'idProvedorProductoHidden' + totalElementosInterno;
        inputIdProvedorProducto.value = idProvedorProducto;

        var inputProvedorProducto = document.createElement('input');
        inputProvedorProducto.type = 'hidden';
        inputProvedorProducto.id = 'provedorProductoHidden' + totalElementosInterno;
        inputProvedorProducto.name = 'provedorProductoHidden' + totalElementosInterno;
        inputProvedorProducto.value = ProvedorProducto;


        var rowProvedorProducto = document.createElement('td');
        rowProvedorProducto.innerText = ProvedorProducto;
        rowProvedorProducto.style.fontSize = '10px';
        //rowProvedorProducto.style.width = '200px';
        rowProvedorProducto.style.textAlign = 'center';
        rowProvedorProducto.style.display = 'none';
        rowProvedorProducto.appendChild(inputIdProvedorProducto);
        rowProvedorProducto.appendChild(inputProvedorProducto);

        var inputPrecioMayoreo = document.createElement('input');
        inputPrecioMayoreo.type = 'hidden';
        inputPrecioMayoreo.id = 'precioMayoreoHidden' + totalElementosInterno;
        inputPrecioMayoreo.name = 'precioMayoreoHidden' + totalElementosInterno;
        inputPrecioMayoreo.value = precioProducto;

        var rowPrecioMayoreo = document.createElement('td');
        rowPrecioMayoreo.innerText = '$ ' + PrecioMayoreo;
        rowPrecioMayoreo.style.fontSize = '10px';
        //rowPrecioMayoreo.style.width = '100px';
        rowPrecioMayoreo.style.textAlign = 'center';
        rowPrecioMayoreo.appendChild(inputPrecioMayoreo);
        rowPrecioMayoreo.style.display = 'none';



        var inputPrecioMenudeo = document.createElement('input');
        inputPrecioMenudeo.type = 'hidden';
        inputPrecioMenudeo.id = 'precioMenudeoHidden' + totalElementosInterno;
        inputPrecioMenudeo.name = 'precioMenudeoHidden' + totalElementosInterno;
        inputPrecioMenudeo.value = precioProducto;

        var rowPrecioMenudeo = document.createElement('td');
        rowPrecioMenudeo.innerText = '$ ' + PrecioMenudeo;
        rowPrecioMenudeo.style.fontSize = '10px';
        //rowPrecioMenudeo.style.width = '100px';
        rowPrecioMenudeo.style.textAlign = 'center';
        rowPrecioMenudeo.appendChild(inputPrecioMenudeo);
        rowPrecioMenudeo.style.display = 'none';


        var inputCantidadProducto = document.createElement('input');
        inputCantidadProducto.type = 'hidden';
        inputCantidadProducto.id = 'CantidadProductoHidden' + totalElementosInterno;
        inputCantidadProducto.name = 'CantidadProductoHidden' + totalElementosInterno;
        inputCantidadProducto.value = CantidadProducto;

        var rowCantidadProducto = document.createElement('td');
        rowCantidadProducto.innerText =  CantidadProducto;
        rowCantidadProducto.style.fontSize = '10px';
        //rowCantidadProducto.style.width = '100px';
        rowCantidadProducto.style.textAlign = 'center';
        rowCantidadProducto.appendChild(inputCantidadProducto);


        var inputObservacionesProducto = document.createElement('input');
        inputObservacionesProducto.type = 'hidden';
        inputObservacionesProducto.id = 'observacionesProductoHidden' + totalElementosInterno;
        inputObservacionesProducto.name = 'observacionesProductoHidden' + totalElementosInterno;
        inputObservacionesProducto.value = observacionesproducto;



        var rowObservacionesProducto = document.createElement('td');
        rowObservacionesProducto.innerText = observacionesproducto;
        rowObservacionesProducto.style.fontSize = '10px';
        //rowObservacionesProducto.style.width = '100px';
        rowObservacionesProducto.style.textAlign = 'center';
        rowObservacionesProducto.appendChild(inputObservacionesProducto);



        var inputModeloProducto = document.createElement('input');
        inputModeloProducto.type = 'hidden';
        inputModeloProducto.id = 'modeloProductoHidden' + totalElementosInterno;
        inputModeloProducto.name = 'modeloProductoHidden' + totalElementosInterno;
        inputModeloProducto.value = modeloProducto;



        var rowModeloProducto = document.createElement('td');
        rowModeloProducto.innerText = modeloProducto;
        rowModeloProducto.style.fontSize = '10px';
        //rowObservacionesProducto.style.width = '100px';
        rowModeloProducto.style.textAlign = 'center';
        rowModeloProducto.appendChild(inputModeloProducto);
        rowModeloProducto.style.display = 'none';


        var inputColorProducto = document.createElement('input');
        inputColorProducto.type = 'hidden';
        inputColorProducto.id = 'colorProductoHidden' + totalElementosInterno;
        inputColorProducto.name = 'colorProductoHidden' + totalElementosInterno;
        inputColorProducto.value = colorProducto;

        var rowColorProducto = document.createElement('td');
        rowColorProducto.innerText = colorProducto;
        rowColorProducto.style.fontSize = '10px';
        //rowObservacionesProducto.style.width = '100px';
        rowColorProducto.style.textAlign = 'center';
        rowColorProducto.appendChild(inputColorProducto);
        rowColorProducto.style.display = 'none';

        var inputTallaProducto = document.createElement('input');
        inputTallaProducto.type = 'hidden';
        inputTallaProducto.id = 'tallaProductoHidden' + totalElementosInterno;
        inputTallaProducto.name = 'tallaProductoHidden' + totalElementosInterno;
        inputTallaProducto.value = tallaProducto;

        var rowTallaProducto = document.createElement('td');
        rowTallaProducto.innerText = tallaProducto;
        rowTallaProducto.style.fontSize = '10px';
        //rowObservacionesProducto.style.width = '100px';
        rowTallaProducto.style.textAlign = 'center';
        rowTallaProducto.style.display = 'none';
        rowTallaProducto.appendChild(inputTallaProducto);
        rowTallaProducto.style.display = 'none';

        var inputFechaProducto = document.createElement('input');
        inputFechaProducto.type = 'hidden';
        inputFechaProducto.id = 'fechaProductoHidden' + totalElementosInterno;
        inputFechaProducto.name = 'fechaProductoHidden' + totalElementosInterno;
        inputFechaProducto.value = fechaProducto;

        var rowFechaProducto = document.createElement('td');
        rowFechaProducto.innerText = fechaProducto;
        rowFechaProducto.style.fontSize = '10px';
        //rowObservacionesProducto.style.width = '100px';
        rowFechaProducto.style.textAlign = 'center';
        rowFechaProducto.appendChild(inputFechaProducto);

        var inputPrecioCompraProducto = document.createElement('input');
        inputPrecioCompraProducto.type = 'hidden';
        inputPrecioCompraProducto.id = 'precioCompraProductoHidden' + totalElementosInterno;
        inputPrecioCompraProducto.name = 'precioCompraProductoHidden' + totalElementosInterno;
        inputPrecioCompraProducto.value = precioCompra;

        var rowPrecioCompraProducto = document.createElement('td');
        rowPrecioCompraProducto.innerText = '$ '+precioCompra;
        rowPrecioCompraProducto.style.fontSize = '10px';
        //rowObservacionesProducto.style.width = '100px';
        rowPrecioCompraProducto.style.textAlign = 'center';
        rowPrecioCompraProducto.appendChild(inputPrecioCompraProducto);

        var inputClaveSAT = document.createElement('input');
        inputClaveSAT.type = 'hidden';
        inputClaveSAT.id = 'claveSatProductoHidden' + totalElementosInterno;
        inputClaveSAT.name = 'claveSatProductoHidden' + totalElementosInterno;
        inputClaveSAT.value = claveSAT;


        var rowClaveSAT = document.createElement('td');
        rowClaveSAT.innerText =  claveSAT;
        rowClaveSAT.style.fontSize = '10px';
        //rowObservacionesProducto.style.width = '100px';
        rowClaveSAT.style.textAlign = 'center';
        rowClaveSAT.appendChild(inputClaveSAT);
        


        var filaDatos = document.createElement('tr');
        filaDatos.id = 'idRenglonDatos' + totalElementosInterno;
        filaDatos.onclick = function () { fnCargaProducto(totalElementosInterno); }
        //filaDatos.style.fontSize = '10px';
        //filaDatos.style.fontWeight = 'bold';
        //filaDatos.style.color = 'darkblue';
        filaDatos.style.cursor = 'pointer';
        //filaDatos.className = EstiloTR;
        

        filaDatos.appendChild(rowNombreProducto);
        filaDatos.appendChild(rowClaveSAT);
        filaDatos.appendChild(rowUnidadProducto);
        filaDatos.appendChild(rowModeloProducto);
        filaDatos.appendChild(rowColorProducto);
        filaDatos.appendChild(rowTallaProducto);
        filaDatos.appendChild(rowFechaProducto);
        filaDatos.appendChild(rowPrecioCompraProducto);
        filaDatos.appendChild(rowPrecioProducto);
        filaDatos.appendChild(rowCantidadProducto);
        //filaDatos.appendChild(rowObservacionesProducto);
       
        tablaDatos.appendChild(filaDatos);
        document.getElementById('totalElementosM').value = totalElementosInterno + 1;

    } catch (ex) {
        var regresa = parseFloat(document.getElementById('totalElementosM').value);
        document.getElementById('totalElementosM').value = regresa - 1;
        alert(ex.message);
    }


}
