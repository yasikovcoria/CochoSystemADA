Imports CochoSystem.login
Imports System.Web.Script.Serialization
Public Class fnFunciones
    Inherits System.Web.UI.Page

    Public objetoClases As clases = New clases

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim accion As String = HttpContext.Current.Request.QueryString("accion")
        Dim TipoFolio As String = HttpContext.Current.Request.QueryString("TipoFolio")
        Dim query As String = ""
        query = HttpContext.Current.Request("variable")
        Dim retorno As String = ""
        Dim Cliente As String = ""
        Cliente = HttpContext.Current.Request("clienteM")
        Dim Pagina As String = HttpContext.Current.Request.QueryString("pagina")
        Dim Tamanio As String = HttpContext.Current.Request.QueryString("tamanio")
        Dim IdEmpresa As String = HttpContext.Current.Request.QueryString("IdEmpresa")

        If accion = "buscar" Then
            retorno = fnCargaCombo("CondicionPagoSAT")
        End If

        If accion = "unidad" Then
            retorno = fnCargaComboUndad("UnidadSAT")
        End If
        If accion = "consecutivo" Then
            retorno = fnCargaRecibo(TipoFolio)
        End If

        If accion = "consecutivoCot" Then
            retorno = fnCargaCot(TipoFolio)
        End If

        If accion = "paginador" Then

            retorno = fnPaginar(Tamanio, Pagina, IdEmpresa)

        End If

        If accion = "paginadorCliente" Then

            retorno = fnPaginarCliente(Tamanio, Pagina, IdEmpresa)

        End If

        If accion = "paginasCliente" Then
            retorno = fnTotalPaginasCliente(Tamanio, IdEmpresa)
        End If
        If accion = "paginas" Then
            retorno = fnTotalPaginas(Tamanio, IdEmpresa)
        End If
        If accion = "cliente" Then
            Call fnAjax(query)
        End If

    End Sub
    Public Function fnPaginar(ByVal TamañoPagina As String, ByVal Pagina As String, ByVal IdEmpresa As String) As String

        Dim retorno As String
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim iContador As Integer = 0
        Dim EnlaceElimina As String = ""
        EnlaceElimina = "<a href=""#"" style=""text-decoration:none"" alt=""Su factura se genero correctamente"">Timbrado Correcto</a>"

        InstrSQL = "EXEC dbo.spPaginador '" + TamañoPagina + "','" + Pagina + "','" + IdEmpresa + "',1"
        SqlConnection.Open()
        Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)
        DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "Paginacion")
        DataView = DataSet.Tables("Paginacion").DefaultView
        If DataView.Count <> 0 Then
            If DataView(iContador)("CampoXML").ToString = "ELIMINAR" Then
                EnlaceElimina = "<a href=""#"" onclick=""javascript:fnElimina('" + iContador.ToString + "');"">Eliminar Factura<a/>"
            End If
            Response.Write("<table border=""0"" id=""tablaFactura"" name=""tablaFactura"" class=""filtrar"">")
            Response.Write("<thead><tr class=""titulo""><td>Numero Factura</td><td>Fecha Factura</td><td>Nombre Cliente</td><td>Monto Factura</td><td>Estatus Factura</td><td></td><td></td><td></td><td></td></tr></thead>")
            Response.Write("<tbody>")
            Do While iContador < DataView.Count

                HttpContext.Current.Response.Write("<tr class=""contenido""><td><input type=""hidden"" id=""IdEmpresaM" + iContador.ToString + """ value=""" + DataView(iContador)("PFacIdEmpresa").ToString + """ /><input type=""hidden"" id=""numeroFacturaM" + iContador.ToString + """ value=""" + DataView(iContador)("PFacIdFactura").ToString + """ /><input type=""hidden"" id=""folioElectronicoM" + iContador.ToString + """ value=""" + DataView(iContador)("TipoFolio").ToString + """ />" + DataView(iContador)("PFacIdFactura").ToString + "</td><td>" + DataView(iContador)("FechaFactura").ToString + "</td><td>" + DataView(iContador)("NombreCliente").ToString + "</td><td>" + DataView(iContador)("MontoFactura").ToString + "</td><td><a href=""#"" onclick=""javascript:fnCancela('" + iContador.ToString + "');"">" + DataView(iContador)("Estatus").ToString + "</a></td><td><img src=""../img/Imprimir.jpg"" width=""25"" title=""Imprimir Factura"" height=""25"" onclick=""javascript:fnImprimeRecibo('" + iContador.ToString + "');"" style=""cursor:pointer;"" /></td><td><img src=""../img/xml.png"" title=""Abrir archivo XML"" style=""cursor:pointer;"" width=""25"" onclick=""javascript:fnImprimeXML('" + iContador.ToString + "');"" height=""25"" /></td><td><img src=""../img/correo.png"" title=""Enviar por correo los archivos"" width=""25"" style=""cursor:pointer;"" onclick=""javascript:fnEnviaCorreo('" + iContador.ToString + "');"" height=""25"" /></td><td>" + EnlaceElimina + "</td></tr>")
                iContador = iContador + 1
            Loop
            Response.Write("</tbody>")
            Response.Write("</table>")
        End If
        SqlConnection.Close()
        Return fnPaginar
    End Function


    Public Function fnPaginarCliente(ByVal TamañoPagina As String, ByVal Pagina As String, ByVal IdEmpresa As String) As String

        Dim retorno As String
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim iContador As Integer = 0
        Dim EnlaceElimina As String = ""
        EnlaceElimina = "<a href=""#"" style=""text-decoration:none"" alt=""Su factura se genero correctamente"">Timbrado Correcto</a>"

        InstrSQL = "EXEC dbo.spPaginadorCliente '" + TamañoPagina + "','" + Pagina + "','" + IdEmpresa + "',1"
        SqlConnection.Open()
        Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)
        DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "Paginacion")
        DataView = DataSet.Tables("Paginacion").DefaultView
        If DataView.Count <> 0 Then

            EnlaceElimina = "<a href=""#"" onclick=""javascript:fnElimina('" + iContador.ToString + "');"">Eliminar Factura<a/>"

            Response.Write("<table border=""0"" id=""tablaCliente"" name=""tablaCliente"" class=""filtrar2"">")
            Response.Write("<thead><tr class=""normal""><td style=""width:100px; height:30px;"">Clave del Cliente</td><td  style=""width:200px;"">Nombre del Cliente</td><td   style=""width:200px;"">Correo del Cliente</td><td style=""width:100px;"">Tipo de Persona</td><td></td></tr></thead>")
            Response.Write("<tbody>")
            Do While iContador < DataView.Count

                HttpContext.Current.Response.Write("<tr class=""contenido""><td class=""td"">" + DataView(iContador)("ClaveCliente").ToString + "<input type=""hidden"" id=""IdEmpresaM" + iContador.ToString + """ value=""" + DataView(iContador)("IdEmpresa").ToString + """ /><input type=""hidden"" id=""ClaveCliente" + iContador.ToString + """ value=""" + DataView(iContador)("ClaveCliente").ToString + """ /></td><td class=""td""><input type=""hidden"" id=""NombreCliente" + iContador.ToString + """ value=""" + DataView(iContador)("NombreCliente").ToString + """ />" + DataView(iContador)("NombreCliente").ToString + "</td><td class=""td"">" + DataView(iContador)("CorreoCliente").ToString + "</td><td class=""td"">" + DataView(iContador)("TipoPersonaCliente").ToString + "</td><td class=""td""><img src=""../img/editar.png"" width=""25"" title=""Editar Cliente"" height=""25"" onclick=""javascript:parent.fnEditaCliente('" + DataView(iContador)("ClaveCliente").ToString + "');parent.cerrarVentana();"" style=""cursor:pointer;"" /></td></tr>")
                iContador = iContador + 1
            Loop
            Response.Write("</tbody>")
            Response.Write("</table>")
        End If
        SqlConnection.Close()
        Return fnPaginarCliente
    End Function
    Public Function fnTotalPaginas(ByVal TamanioPagina As String, ByVal IdEmpresa As String) As String

        Dim retorno As String
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim iContador As Integer = 1
        Dim totalPaginas As Integer = 0
        Dim IdEmpresaResul As String = ""

        InstrSQL = "EXEC dbo.spPaginador '" + TamanioPagina + "','','" + IdEmpresa + "',2"
        SqlConnection.Open()
        Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)
        DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "Paginacion")
        DataView = DataSet.Tables("Paginacion").DefaultView
        If DataView.Count <> 0 Then
            totalPaginas = DataView(0)("Paginas")
            IdEmpresaResul = DataView(0)("IdEmpresa")

            Do While iContador <= totalPaginas

                Response.Write("<a href=""#"" onclick=""javascript:fnCargaPaginador('" + iContador.ToString + "','" + IdEmpresaResul + "');"">    " + iContador.ToString + "</a>")
                iContador = iContador + 1
            Loop

        End If
        SqlConnection.Close()
        Return fnTotalPaginas
    End Function

    Public Function fnTotalPaginasCliente(ByVal TamanioPagina As String, ByVal IdEmpresa As String) As String

        Dim retorno As String
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())
        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim iContador As Integer = 1
        Dim totalPaginas As Integer = 0
        Dim IdEmpresaResul As String = ""

        InstrSQL = "EXEC dbo.spPaginadorCliente '" + TamanioPagina + "','','" + IdEmpresa + "',2"
        SqlConnection.Open()
        Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)
        DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "Paginacion")
        DataView = DataSet.Tables("Paginacion").DefaultView
        If DataView.Count <> 0 Then
            totalPaginas = DataView(0)("Paginas")
            IdEmpresaResul = DataView(0)("IdEmpresa")

            Do While iContador <= totalPaginas

                Response.Write("<a href=""#"" onclick=""javascript:fnCargaPaginador('" + iContador.ToString + "','" + IdEmpresaResul + "');"">    " + iContador.ToString + "</a>")
                iContador = iContador + 1
            Loop

        End If
        SqlConnection.Close()
        Return fnTotalPaginasCliente
    End Function

    Public Function fnAjax(ByVal Query As String)
        Dim retorno As String
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())

        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String
        Dim i As Double = 0
        Dim javascript As New JavaScriptSerializer
        Dim json As String = ""


        InstrSQL = "select UPPER((CLNombre +' '+CLApePaterno+' '+CLApeMaterno)) as Nombre," _
        + "CLIdUnico as IdCliente from dbo.Cliente " _
        + " where (CLNombre +' '+CLApePaterno+' '+CLApeMaterno) like '%" + Query + "%'"
        'Response.Write(InstrSQL)
        'Response.End()
        SqlConnection.Open()
        Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)

        DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, InstrSQL)
        DataView = DataSet.Tables(InstrSQL).DefaultView

        Response.Write("<ul>")
        If DataView.Count <> 0 Then
            Do While (i < DataView.Count)

                'Response.Write(DataView(i)("IdCliente").ToString)
                Response.Write("<li class=""li"" onclick=""javascript:fnRetornaValor('" + DataView(i)("IdCliente").ToString + "');"">" + DataView(i)("Nombre").ToString + "<input type=""hidden"" id=""" + DataView(i)("IdCliente").ToString + """ value=""" + DataView(i)("Nombre").ToString + """ /><img src=""../img/editar.png"" height=""18"" width=""18"" style=""padding-left:12px;"" onclick=""javascript:fnEdita('" + DataView(i)("IdCliente").ToString + "');"" /></li>")


                i = i + 1
            Loop
            Response.Write("</ul>")
        Else
            Response.Write("<ul>")
            Response.Write("<li class=""li"">No se Encontraron resultados</li>")
            Response.Write("</ul>")
        End If

        Return retorno
    End Function

    Public Function fnCargaCombo(ByVal Combo As String)
        Dim retorno As String
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())

        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim i As Double = 0

        InstrSQL = "SELECT * FROM " + Combo + "  "
        SqlConnection.Open()
        Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)

        DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, Combo)
        DataView = DataSet.Tables(Combo).DefaultView


        Response.Write("<option value="""">Seleccione una opcion</option>")
        Do While (i < DataView.Count)

            Response.Write("<option value=""" + DataView(i)("CPSDescripcion").ToString + """>" + DataView(i)("CPSDescripcion").ToString + "</option>")
            i = i + 1
        Loop


        Return retorno
    End Function

    Public Function fnCargaComboUndad(ByVal Combo As String)
        Dim retorno As String
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())

        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        Dim i As Double = 0

        InstrSQL = "SELECT * FROM " + Combo + ""
        SqlConnection.Open()
        Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)

        DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, Combo)
        DataView = DataSet.Tables(Combo).DefaultView


        Response.Write("<option value="""">Seleccione una opcion</option>")
        Do While (i < DataView.Count)

            Response.Write("<option value=""" + DataView(i)("USIdUnico").ToString + """>" + DataView(i)("USDescripcion").ToString + "</option>")
            i = i + 1
        Loop


        Return retorno
    End Function
    Public Function fnCargaRecibo(ByVal TipoFolio As String) As String

        Dim retorno As String = ""
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())

        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        InstrSQL = "SELECT dbo.fnConsecutivoFactura(" + TipoFolio + ") as NumeroRecibo"
        SqlConnection.Open()
        Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)

        DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "Consecutivo")
        DataView = DataSet.Tables("Consecutivo").DefaultView
        Response.Write(DataView(0)("NumeroRecibo").ToString)
        Return fnCargaRecibo
    End Function
    Public Function fnCargaCot(ByVal TipoFolio As String) As String

        Dim retorno As String = ""
        Dim SqlConnection = New System.Data.SqlClient.SqlConnection(objetoClases.cadenaDB())

        Dim DataAdapter As System.Data.SqlClient.SqlDataAdapter
        Dim DataView As New System.Data.DataView
        Dim DataSet As New System.Data.DataSet
        Dim InstrSQL As String = ""
        InstrSQL = "SELECT dbo.fnConsecutivoCotizacion(" + TipoFolio + ") as NumeroRecibo"
        SqlConnection.Open()
        Dim SQLCommand As New System.Data.SqlClient.SqlCommand(InstrSQL, SqlConnection)

        DataAdapter = New SqlClient.SqlDataAdapter(SQLCommand)
        DataAdapter.Fill(DataSet, "Consecutivo")
        DataView = DataSet.Tables("Consecutivo").DefaultView
        Response.Write(DataView(0)("NumeroRecibo").ToString)
        Return fnCargaCot
    End Function

End Class