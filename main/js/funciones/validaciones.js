function fnEnviar(accion) {
    if (document.getElementById('nombreClienteM').value == '') {
        alert('No ha indicado el nombre del cliente');
        return false;
    }
    if (document.getElementById('rfcM').value == '') {
        alert('No ha proporcionado el RFC del cliente');
        return false;
    }
    if (document.getElementById('codigoPostalM').value == '') {
        alert('No ha proporcionado el Codigo Postal');
        return false;
    } else {
        if (document.getElementById('codigoPostalM').value.length != 5) {
            alert('El codigo postal debe contener 5 digitos');
            return false;
        }
    }
    if (document.getElementById('paisM').value == '') {
        alert('Ingrese el pais ya que es obligatorio');
        return false;
    }
    if (document.getElementById('calleM').value == '') {
        alert('Debe indicar la direccion');
        return false;
    }

    document.getElementById('accion').value = accion;
    var form1 = document.getElementById('form1');
    form1.method = 'POST';
    form1.submit();

}
function fnValidaNumero() {

    if ((event.keyCode < 48) || (event.keyCode > 57)) {
        event.returnValue = false;
    }

}