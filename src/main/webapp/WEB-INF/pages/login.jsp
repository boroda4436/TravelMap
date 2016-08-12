<html lang="en">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta charset="utf-8">
		<title>Login</title>
		<meta name="generator" content="Bootply" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<link href="../resources/lib/css/bootstrap.min.css" rel="stylesheet">
		<!--[if lt IE 9]>
			<script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
		<link href="../resources/lib/css/styles.css" rel="stylesheet">
	</head>
	<body>
<!--login modal-->
<div id="loginModal" class="modal show" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog">
  <div class="modal-content">
      <div class="modal-header">
          <h1 class="text-center">Login</h1>
      </div>
      <div class="modal-body">
          <div class="form col-md-12 center-block">
            <div class="form-group">
              <input type="text" id="email" class="form-control input-lg" placeholder="Email">
            </div>
            <div class="form-group">
              <input type="password" id="password" class="form-control input-lg" placeholder="Password">
            </div>
            <div class="form-group">
              <button class="btn btn-primary btn-lg btn-block " id="loginBtn">Sign In</button>
              <span class="pull-right"><a href="signin">Register</a></span><span><a href="#">Need help?</a></span>
            </div>
          </div>
      </div>
      <div class="modal-footer">
          <div class="col-md-12">
          </div>
      </div>
  </div>
  </div>
</div>
	<!-- script references -->
		<script src="//ajax.googleapis.com/ajax/libs/jquery/2.0.2/jquery.min.js"></script>
		<script src="../resources/lib/js/bootstrap.min.js"></script>
	</body>
<script>
    $(document).ready(function () {
        $('#loginBtn').click(function () {
            sendLoginRequest();
        });
    });
    function sendLoginRequest() {
        $('#errorMessage').remove();
        var request = {};
        request.email = $('#email').val();
        request.password = $('#password').val();
        $.ajax({
            url: "login",
            method: "POST",
            contentType : 'application/json; charset=utf-8',
            data: JSON.stringify(request),
            dataType: "json",
            success: function (data) {
                if(data.exception){
                    $($('.form.col-md-12.center-block')[0])
                            .append('<div class="form-group" id="errorMessage" style="color:red; text-align:center; ' +
                                    'font-weight:bold">'+data.exception.detailMessage+'</div>');
                } else{
                    location.href = "/index.html"
                }
            },
            error: function (err) {
                console.log(err);
            }
        });
    }
</script>
</html>