<html>
<head>
	<%--<link rel="stylesheet" href="/resources/css/main.css" type="text/css">--%>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
		<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
		<script src="https://maps.googleapis.com/maps/api/js?callback=initMap&key=AIzaSyCsx14zSe9l2m-dbf0T_OmFgtz-HLatWgU"
				async defer></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.6.1/css/bootstrap-datepicker.css" type="text/css">
</head>
<body>
	<h1>Welcome to TravelMap, ${userName}</h1>
<div class="header">
	<a href="addLocation">click me!</a>
	<a href="addLocation">click me1!</a>
	<button id="postLocation">postLocation</button>
	<button id="link1">Add point</button>
</div>
<div class="container">
	<div id="map" style="width: 500px; height: 400px"></div>
	<div id="usersInfo">
		<p id="usersHeader"></p>
	</div>
	<div >
		City: <input type="text" id="city" name="city"/>
		<br />
		Longitude: <input type="text" id="longitude" name="longitude" />
		<br />
		Latitude: <input type="text" id="latitude" name="latitude" />
		<br />
		Country: <input type="text" id="country" name="country" />
		<br />
		Country code: <input type="text" id="countryCode" name="countryCode" />
		<br />
		Was visited: <input type="checkbox" id="wasVisited" name="wasVisited" />
		<br />
		<p id="dateLine">Country code: <input type="text" id="date" name="date" /></p>
		<button id="sendLocationData">Submit</button>
	</div>
	<%--need for displaying information about existed location--%>
	<%--<div id="locationInfo">--%>
		<%--City: <input type="text" id="cityInfo"/>--%>
		<%--<br />--%>
		<%--Longitude: <input type="text" id="longitudeInfo"/>--%>
		<%--<br />--%>
		<%--Latitude: <input type="text" id="latitudeInfo"/>--%>
		<%--<br />--%>
		<%--Country: <input type="text" id="countryInfo"/>--%>
		<%--<br />--%>
		<%--Country code: <input type="text" id="countryCodeInfo"/>--%>
		<%--<br />--%>
		<%--Was visited: <input type="checkbox" id="wasVisitedInfo"/>--%>
		<%--<br />--%>
		<%--Country code: <input type="text" id="dateInfo"/>--%>

	<%--</div>--%>
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
							$('#city').val(results[1].formatted_address)
						} else {
							window.alert('No results found');
						}
						if(results[3] && results[3].address_components){
							for(var i=0; i<results[3].address_components.length; i++){
								if(results[3].address_components[i].short_name){
									$('#countryCode').val(results[3].address_components[i].short_name);
									$('#country').val(results[3].address_components[i].long_name);
								}
							}
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
				$('#date').val('');
			});

		}
	}
	$(document).ready(function(){
		$('#date').datepicker();
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
	function printAllVisitedLocations(users){

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
				"date":$('#date').val(),
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


</script>
</html>