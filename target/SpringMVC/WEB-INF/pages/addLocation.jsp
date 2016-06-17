<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add location</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?callback=initMap&key=AIzaSyCsx14zSe9l2m-dbf0T_OmFgtz-HLatWgU" async defer></script>
</head>
<body>
hello world
${message}
<div id="map"></div>
<script>
    function initMap() {
        var mapDiv = document.getElementById('map');
    }
</script>
</body>
</html>
