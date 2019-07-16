<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>::Entrar al Sistema::</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/css/bootstrap.min.css" rel="stylesheet">
    <style type="text/css">
        
    </style>
    <script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.0/js/bootstrap.min.js"></script>
</head>
<body>
    
    <div class="container">
        <div align="center">
        <h3>Soporta la nueva version 3.3 cfdi</h3>
        </div>

        <div id="loginbox" style="margin-top: 100px;" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <div class="panel-title" align="center"><strong>Sistema de Facturacion y Control de inventarios.</strong></div>
                    <!--<div style="float: right; font-size: 80%; position: relative; top: -10px"><a href="#">Forgot password?</a></div>-->
                </div>

                <div style="padding-top: 30px" class="panel-body">

                    <div style="display: none" id="login-alert" class="alert alert-danger col-sm-12"></div>

                    <form id="loginform" class="form-horizontal" action="login.aspx" role="form" method="post">
                        <input type="hidden" id="accion" name="accion" />
                        <div style="margin-bottom: 25px" class="input-group">
                            <span class="input-group-addon"><i class="glyphicon glyphicon-user"></i></span>
                            <input id="usuario" type="text" class="form-control" name="usuario" value="" placeholder="username or email">
                        </div>

                        <div style="margin-bottom: 25px" class="input-group">
                            <span class="input-group-addon"><i class="glyphicon glyphicon-lock"></i></span>
                            <input id="password" type="password" class="form-control" name="password" >
                        </div>
                        <!--
                        <div class="input-group">
                            <div class="checkbox">
                                <label>
                                    <input id="login-remember" type="checkbox" name="remember" value="1">
                                    Remember me
                                </label>
                            </div>
                        </div>
                        -->
                        <div style="margin-top: 10px" class="form-group" align="center">
                            <!-- Button -->
                            <div class="col-sm-12 controls">
                                <!--<a id="btn-login" href="login.aspx" class="btn btn-success">Entrar  </a>-->
                                <input type="submit" class="btn btn-success" value="Entrar" style="width:40%;" />
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
    </div>
    <div align="center">
            <h4>NOTA: Revisar con su provedor de sistemas costo de actualizacion, y la nueva forma de operar en dicha version.</h4>
        </div>
<script type="text/javascript">

</script>
</body>
</html>
