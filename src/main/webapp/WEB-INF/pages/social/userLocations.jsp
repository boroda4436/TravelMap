<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <script src="https://maps.googleapis.com/maps/api/js?callback=initMap&key=AIzaSyCsx14zSe9l2m-dbf0T_OmFgtz-HLatWgU&language=en" async defer></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
    <link rel="stylesheet" href="/resources/resources/css/main.css" type="text/css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" >
</head>
<body>
<div class="header col-md-12">
    <h1 class="col-md-11">Welcome to TravelMap, ${userName}</h1>
    <button id="logOut" class="col-md-1">LogOut</button>
</div>
<div class="row">
    <div class="col-md-8"><div id="map" style="width: 100%; height: 500px"></div></div>
    <div class="col-md-4" style="display: none" id="locationInfo">
        <div class="col-md-12">
            <div class="col-md-3">City:</div>
            <input class="col-md-9" type="text" id="cityInfo"/>
        </div>
        <div class="col-md-12">
            <div class="col-md-3">Longitude:</div>
            <input class="col-md-9" type="text" id="longitudeInfo" name="longitude"/>
        </div>
        <div class="col-md-12">
            <div class="col-md-3">Latitude:</div>
            <input class="col-md-9" type="text" id="latitudeInfo" name="latitude"/>
        </div>
        <div class="col-md-12">
            <div class="col-md-3">Country:</div>
            <input class="col-md-9" type="text" id="countryInfo" name="country"/>
        </div>
        <div class="col-md-12">
            <div class="col-md-3">Country code:</div>
            <input class="col-md-9" type="text" id="countryCodeInfo" name="countryCode"/>
        </div>
        <div class="col-md-12">
            <div class="col-md-3">Was visited:</div>
            <div class="col-md-9"><input type="checkbox" id="wasVisitedInfo" name="wasVisited"></div>
        </div>
        <div id="dateLineInfo" class="col-md-12">
            <div class="col-md-3">Date visited:</div>
            <input class="col-md-9 datepicker" type="date" id="dateInfo"/>
        </div>

        <button class="btn btn-default showAllLocation">All Locations</button>
        <button class="btn btn-primary" id="editLocation">Edit Locations</button>
        <button class="btn btn-danger" id="deleteLocation">Delete Locations</button>
    </div>
    <div class="col-md-4" id="allLocations"></div>
</div>
<script>
    var locations =  ${locations};
    function initMap() {
        // In the following example, markers appear when the user clicks on the map.
        // Each marker is labeled with a single alphabetical character.
        var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
        var labelIndex = 0;
        var markers = [];
        var mapDiv = document.getElementById('map');
        var centerCoordinates = {lat: 50.449335, lng: 30.525155};
        var map = new google.maps.Map(mapDiv, {
            center: centerCoordinates,
            zoom: 5
        });
        var geocoder = new google.maps.Geocoder;
        // This event listener calls addMarker() when the map is clicked.

        $('.showAllLocation').click(function () {
            $('#allLocations').show();
            $('#locationInfo').hide();
            map.setZoom(5);
            map.setCenter(centerCoordinates);
        });
        $(document).ready(function(){
            $('#dateLine').hide();
            $('#wasVisited').click(function(){
                if($('#wasVisited').is(':checked')){
                    $('#dateLine').show();
                } else{
                    $('#dateLine').hide();
                }
            });
        });
        $('#logOut').click(function () {
            location.href = "/auth/logOut.html";
        });
        addLocationsMarkers();
        function zoomAll() {
            $('#zoomAllBtn').click(function () {
                map.setZoom(5);
                map.setCenter(centerCoordinates);
            });
        }
        function addLocationsMarkers() {
            locations.sort(function(a, b){
                var dateDiff = new Date(b.content.content.date) - new Date(a.content.content.date);
                if(dateDiff==0){
                    b.content.content.geoLocation.content.longitude - a.content.content.geoLocation.content.longitude;
                } else{
                    return dateDiff;
                }
            });
            for(var i=0; i<locations.length; i++){
                if(locations[i].content.content.geoLocation){
                    var location = { lat: parseFloat(locations[i].content.content.geoLocation.content.latitude),
                        lng: parseFloat(locations[i].content.content.geoLocation.content.longitude) }
                    addMarker(location, map, locations[i].content.content.locationUUID);
                    printAllVisitedLocations(labels[labelIndex - 1], locations[i]);
                }
            }
            $('#allLocations').append('<button class="btn btn-default" id="zoomAllBtn">Zoom all</button>');
            $('#allLocations').append('	<button class="btn btn-default" id="addLocationBtn">Add point</button>');
        }
        // Adds a marker to the map.
        function addMarker(location, map, locationId) {
            // Add the marker at the clicked location, and add the next-available label
            // from the array of alphabetical characters.
            var title = labels[labelIndex++ % labels.length];
            if(labelIndex>labels.length) title = labelIndex - labels.length;
            var marker = new google.maps.Marker({
                position: location,
                label: title,
                map: map,
                locationId:locationId
            });
            marker.addListener("dblclick", function() {
                marker.setMap(null);
                $('#longitude').val('');
                $('#latitude').val('');
                $('#countryCode').val('');
                $('#city').val('');
                $('#country').val('');
                $('#datepicker').val('');
            });
            marker.addListener('click', function() {
                map.setZoom(8);
                map.setCenter(marker.getPosition());
                printLocationInfo(marker.locationId, map);
            });
            markers.push(marker);
        }
        function printAllVisitedLocations(marker, user){
            var container = $('<div class="input-group col-md-12 location-input-group" ' +
                    'data-lat="'+user.content.content.geoLocation.content.latitude+'"' +
                    'data-lng="'+user.content.content.geoLocation.content.longitude+'"' +
                    '></div>');
            container.append($('<div  class="col-md-1">'+marker+'</div>'));
            container.append($('<div  class="col-md-4">'+user.content.content.city+'</div>'));
            container.append($('<div  class="col-md-3">'+user.content.content.country+'</div>'));
            container.append($('<div  class="col-md-4">'+user.content.content.date+'</div>'));
            $('#allLocations').append(container);
        }
    }
</script>
</body>
</html>
