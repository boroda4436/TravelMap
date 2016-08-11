<html lang="en">
	<head>
		<meta http-equiv="content-type" content="text/html; charset=UTF-8">
		<meta charset="utf-8">
		<title>Registration</title>
		<meta name="generator" content="Bootply" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<link href="../resources/lib/css/bootstrap.min.css" rel="stylesheet">
		<!--[if lt IE 9]>
			<script src="//html5shim.googlecode.com/svn/trunk/html5.js"></script>
		<![endif]-->
		<link href="../resources/lib/css/styles.css" rel="stylesheet">
	</head>
	<body>
<!--registration modal-->
<div id="registrationModal" class="modal show" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="text-center">Registration</h1>
            </div>
            <div class="modal-body">
                <form class="form col-md-12 center-block">
                    <div class="form-group">
                        <input type="text" id="registrationEmail" class="form-control input-lg" placeholder="Email">
                    </div>
                    <div class="form-group">
                        <input type="password" id="registrationPassword" class="form-control input-lg" placeholder="Password">
                    </div>
                    <div class="form-group">
                        <input type="password" id="registrationPasswordRepeat" class="form-control input-lg" placeholder="Password">
                    </div>
                    <div class="form-group">
                        <button class="btn btn-primary btn-lg btn-block" id="registrationBtn">Confirm</button>
                        <span class="pull-right"><a href="login">Login</a></span><span><a href="#">Need help?</a></span>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <div class="col-md-12">
                    <%--<button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button>--%>
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
        $('#registrationBtn').click(function () {
            console.log('OK!');
            sendLoginRequest();
        });
    });
    function sendLoginRequest() {
        var request = {
            email: $('#registrationEmail').val(),
            password : $('#registrationPassword').val()
        };
//        request.email = $('#registrationEmail').val();
//        request.password = $('#registrationPassword').val();
        var repeatPassword = $('#registrationPasswordRepeat').val();
        $.ajax({
            url: "signin",
            method: "POST",
            contentType : 'application/json; charset=utf-8',
            data: JSON.stringify(request),
            dataType: "json",
            success: function (data) {
                console.log(1);
            },
            error: function (err) {
                console.log(2);
            }
        });
    }
</script>
</html>