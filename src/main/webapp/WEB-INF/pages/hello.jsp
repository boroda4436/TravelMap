<html>
<head>
	<script src="https://maps.googleapis.com/maps/api/js?callback=initMap&key=AIzaSyCsx14zSe9l2m-dbf0T_OmFgtz-HLatWgU&language=us" async defer></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
	<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js" integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS" crossorigin="anonymous"></script>

	<link rel="stylesheet" href="resources/css/main.css" type="text/css">
</head>
<body>
<div class="header">
	<h1>Welcome to TravelMap, ${userName}</h1>
	<button class="btn-default" id="link1">Add point</button>
</div>
<div class="col-md-12 container">
	<div class="col-md-8"><div id="map" style="width: 100%; height: 500px"></div></div>
	<div class="col-md-4" id="addLocationDiv">
		<div class="col-md-3">City:</div>
		<input class="col-md-9" type="text" id="city" name="city"/>

		<div class="col-md-3">Longitude:</div>
		<input class="col-md-9" type="text" id="longitude" name="longitude"/>

		<div class="col-md-3">Latitude:</div>
		<input class="col-md-9" type="text" id="latitude" name="latitude"/>

		<div class="col-md-3">Country:</div>
		<input class="col-md-9" type="text" id="country" name="country"/>

		<div class="col-md-3">Country code:</div>
		<input class="col-md-9" type="text" id="countryCode" name="countryCode"/>

		<div class="col-md-12">
			<div class="col-md-3">Was visited:</div>
			<div class="col-md-9"><input type="checkbox" id="wasVisited" name="wasVisited"></div>
		</div>
		<div class="col-md-12" id="dateLine">
			<div class="col-md-3">Country code:</div>
			<input class="col-md-9" type="text" id="datepicker"/>
		</div>
		<div class="col-md-12">
			<button class="btn-default" id="sendLocationData">Submit</button>
		</div>
	</div>
	<%--need for displaying information about existed location--%>
	<div class="col-md-4" style="display: none" id="locationInfo">
		City: <input type="text" id="cityInfo"/>
		<br />
		Longitude: <input type="text" id="longitudeInfo"/>
		<br />
		Latitude: <input type="text" id="latitudeInfo"/>
		<br />
		Country: <input type="text" id="countryInfo"/>
		<br />
		Country code: <input type="text" id="countryCodeInfo"/>
		<br />
		Was visited: <input type="checkbox" id="wasVisitedInfo"/>
		<br />
		Country code: <input type="text" id="dateInfo"/>

	</div>
    <div class="col-md-4" id="allLocations">

    </div>
</div>
<div class="footer">
	<p class="termsOfPrivacy">terms of privacy</p>
</div>
</body>
<script>
	function initMap() {
		// In the following example, markers appear when the user clicks on the map.
		// Each marker is labeled with a single alphabetical character.
		var labels = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
		var labelIndex = 0;
		var myLatLng = {lat: -25.363, lng: 131.044};
		var mapDiv = document.getElementById('map');
		var map = new google.maps.Map(mapDiv, {
			center: {lat: 50.449335, lng: 30.525155},
			zoom: 6
		});
		var geocoder = new google.maps.Geocoder;
		// This event listener calls addMarker() when the map is clicked.

		$('#link1').click(function(){
			google.maps.event.addListenerOnce(map, 'click', function(event) {
				addMarker(event.latLng, map);
				$('#longitude').val(event.latLng.lng().toFixed(6));
				$('#latitude').val(event.latLng.lat().toFixed(6));
				geocoder.geocode({'location': event.latLng}, function(results, status) {
					if (status === google.maps.GeocoderStatus.OK) {
						if (results[1]) {
                            addCity(results[1]);
						} else {
							window.alert('No results found');
						}
						if(results[3] && results[3].address_components){
							addCountry(results[3]);
						}
					} else {
						window.alert('Geocoder failed due to: ' + status);
					}
				});
			});
		});
		var users =  ${users};
		users.sort(function(a, b){
			var dateDiff = new Date(b.content.content.date) - new Date(a.content.content.date);
			if(dateDiff==0){
				b.content.content.geoLocation.content.longitude - a.content.content.geoLocation.content.longitude;
			} else{
				return dateDiff;
			}
		});
		for(var i=0; i<users.length; i++){
			if(users[i].content.content.geoLocation){
				var location = { lat: parseFloat(users[i].content.content.geoLocation.content.latitude),
					lng: parseFloat(users[i].content.content.geoLocation.content.longitude) }
				addMarker(location, map);
                printAllVisitedLocations(labels[labelIndex - 1], users[i]);
			}
		}

		// Adds a marker to the map.
		function addMarker(location, map) {
			// Add the marker at the clicked location, and add the next-available label
			// from the array of alphabetical characters.
			var marker = new google.maps.Marker({
				position: location,
				label: labels[labelIndex++ % labels.length],
				map: map
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

		}
	}
	$(document).ready(function(){
		$('#datepicker').datepicker();
		$('#dateLine').hide();
		$('#wasVisited').click(function(){
			if($('#wasVisited').is(':checked')){
				$('#dateLine').show();
			} else{
				$('#dateLine').hide();
			}
		});

	});
	function guid() {
		function s4() {
			return Math.floor((1 + Math.random()) * 0x10000)
					.toString(16)
					.substring(1);
		}
		return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
				s4() + '-' + s4() + s4() + s4();
	}
	function printLocationInfo(location){
		$('#longitudeInfo').val(location.content.content.geoLocation.content.longitude);
		$('#latitudeInfo').val(location.content.content.geoLocation.content.latitude);
		$('#countryCodeInfo').val(location.content.content.countryCode);
		$('#cityInfo').val(location.content.content.city);
		$('#countryInfo').val(location.content.content.country);
		$('#dateInfo').val(location.content.content.date);
	}
	function printAllVisitedLocations(marker, user){
        var container = $('#allLocations');
        $('<div>'+marker+'</div>');
        container.append($('<div  class="col-md-1">'+marker+'</div>'));
        container.append($('<div  class="col-md-5">'+user.content.content.city+'</div>'));
        container.append($('<div  class="col-md-3">'+user.content.content.country+'</div>'));
        container.append($('<div  class="col-md-3">'+user.content.content.date+'</div>'));
	}
	$('#sendLocationData').click(function(){
			var locationObj = {};
			locationObj.longitude = $('#longitude').val();
			locationObj.latitude = $('#latitude').val();
			var json = {
				"city": $('#city').val(),
				"geoLocation": { "latitude": locationObj.latitude, "longitude": locationObj.longitude },
				"userId": "bob_0",
				"country": $('#country').val(),
				"countryCode":$('#countryCode').val(),
				"wasVisited":$('#wasVisited').is(':checked'),
				"locationUUID":guid(),
				"date":$('#datepicker').val(),
				"type": "placeLocation"}
			$.ajax({
				'type': 'POST',
				'url': 'postLocation',
				'data': JSON.stringify(json),
				'dataType': 'json',
				'contentType': 'application/json',
					'charset':'utf-8',
				'success': function(){}
			});
		});
function addCity(result) {
    var founded = false;
    for (var i = 0; i < result.address_components.length; i++) {
        if (result.address_components[i].types.length > 0) {
            for (var j = 0; j < result.address_components[i].types.length; j++) {
                if(result.address_components[i].types[j]=='locality'){
                    $('#city').val(result.address_components[i].long_name);
                    founded = true;
                }
            }
        }
    }
    if(founded==false){
        $('#city').val(result.formatted_address);
    }
}
    function addCountry(result) {
        var founded = false;
        for (var i = 0; i < result.address_components.length; i++) {
            if (result.address_components[i].types.length > 0) {
                for (var j = 0; j < result.address_components[i].types.length; j++) {
                    if (result.address_components[i].types[j] == "country") {
                        $('#country').val(result.address_components[i].long_name);
                        $('#countryCode').val(result.address_components[i].short_name);
                        founded = true;
                    }
                }
            }
        }
        if (founded == false) {
            $('#city').val(result.formatted_address);
        }
    }

</script>
</html>