<html>
<head>
	<script src="https://maps.googleapis.com/maps/api/js?callback=initMap&key=AIzaSyCsx14zSe9l2m-dbf0T_OmFgtz-HLatWgU&language=en" async defer></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
	<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	<script src="resources/lib/js/bootstrap-datepicker.js"></script>

	<link rel="stylesheet" href="resources/css/main.css" type="text/css">
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css" >
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css" >
	<link rel="stylesheet" href="resources/lib/css/datepicker.css" type="text/css">


</head>
<body>
<!-- Modal -->
<div class = "modal fade" id = "myModal" tabindex = "-1" role = "dialog"
	 aria-labelledby = "myModalLabel" aria-hidden = "true">

	<div class = "modal-dialog">
		<div class = "modal-content">

			<div class = "modal-header">
				<button type = "button" class = "close" data-dismiss = "modal" aria-hidden = "true">
					&times;
				</button>

				<h4 class = "modal-title" id = "myModalLabel">
					Congratulation!
				</h4>
			</div>

			<div class = "modal-body">
				Location was added successfully
			</div>

			<div class = "modal-footer">
				<button type = "button" class = "btn btn-default" data-dismiss = "modal">
					Close
				</button>
			</div>

		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->

</div><!-- /.modal -->
<div class="header">
	<h1>Welcome to TravelMap, ${userName}</h1>
</div>
<div class="col-md-12 container">
	<div class="col-md-8"><div id="map" style="width: 100%; height: 500px"></div></div>
	<div class="col-md-4" style="display: none" id="addLocationDiv">
		<div class="col-md-12">
			<div class="col-md-3">City:</div>
			<input class="col-md-9" type="text" id="city" name="city"/>
		</div>
		<div class="col-md-12">
			<div class="col-md-3">Longitude:</div>
			<input class="col-md-9" type="text" id="longitude" name="longitude"/>
		</div>
		<div class="col-md-12">
			<div class="col-md-3">Latitude:</div>
			<input class="col-md-9" type="text" id="latitude" name="latitude"/>
		</div>
		<div class="col-md-12">
			<div class="col-md-3">Country:</div>
			<input class="col-md-9" type="text" id="country" name="country"/>
		</div>
		<div class="col-md-12">
			<div class="col-md-3">Country code:</div>
			<input class="col-md-9" type="text" id="countryCode" name="countryCode"/>
		</div>
		<div class="col-md-12">
			<div class="col-md-3">Was visited:</div>
			<div class="col-md-9"><input type="checkbox" id="wasVisited" name="wasVisited"></div>
		</div>
		<div id="dateLine" class="col-md-12">
			<div class="col-md-3">Date visited:</div>
			<input class="col-md-9 datepicker" type="date" id="datepicker"/>
		</div>


		<div class="col-md-12">
			<button class="btn btn-primary" id="sendLocationData">Submit</button>
			<button class="btn btn-default showAllLocation">All Locations</button>
		</div>
	</div>
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
    <div class="col-md-4" id="allLocations">

    </div>
</div>
<div class="footer">
	<p class="termsOfPrivacy">terms of privacy</p>
</div>
</body>
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
			$('#addLocationDiv').hide();
			$('#locationInfo').hide();
			map.setZoom(5);
			map.setCenter(centerCoordinates);
		});
		$('#editLocation').click(function () {
			var json = {
				"city": $('#cityInfo').val(),
				"geoLocation": { "latitude": $('#latitudeInfo').val(), "longitude": $('#longitudeInfo').val() },
				"userId": "bob_0",
				"country": $('#countryInfo').val(),
				"countryCode":$('#countryCodeInfo').val(),
				"wasVisited":$('#wasVisitedInfo').prop('checked'),
				"locationUUID":$('#cityInfo').attr('locationUUID'),
				"date": $('#dateInfo').val(),
				"type": "placeLocation"}
			$.ajax({
				'type': 'POST',
				'url': 'editLocation',
				'data': JSON.stringify(json),
				'dataType': 'json',
				'contentType': 'application/json',
				'charset':'utf-8',
				error:function (error) {
					if((error.status==200)&&(error.readyState==4)){
						$('#myModal').find('.modal-body').text('Location was updated successfully');
						$('#myModal').modal('show');
						$('#addLocationDiv').hide();
						$('#allLocations').hide();
						deleteMarkers();
						addLocationsMarkers();
						zoomToMarker();
						zoomAll();
						addLocation();
						map.setZoom(5);
						map.setCenter(centerCoordinates);
					} else{
						console.log(error);
					}
				}
			});
		});
		$('#deleteLocation').click(function () {
			var json = {
				"locationUUID":$('#cityInfo').attr('locationUUID'),
				"type": "placeLocation"}
			$.ajax({
				'type': 'POST',
				'url': 'deleteLocation',
				'data': JSON.stringify(json),
				'dataType': 'json',
				'contentType': 'application/json',
				'charset':'utf-8',
				error:function (error) {
					if((error.status==200)&&(error.readyState==4)){
						$('#myModal').find('.modal-body').text('Location was deleted successfully')
						$('#myModal').modal('show');
						$('#addLocationDiv').hide();
						$('#locationInfo').hide();
						$('#allLocations').show();
						deleteMarkers();
						addLocationsMarkers();
						zoomToMarker();
						zoomAll();
						addLocation();
						map.setZoom(5);
						map.setCenter(centerCoordinates);
					} else{
						console.log(error);
					}
				}
			});
		});
		addLocationsMarkers();

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
				success: function(res){
					$('#myModal').find('.modal-body').text('Location was added successfully')
					$('#myModal').modal('show');
					$('#addLocationDiv').hide();
					$('#allLocations').show();
					map.setZoom(5);
					map.setCenter(centerCoordinates);
				}, error:function (error) {
					$('#myModal').find('.modal-body').text('Location was added successfully')
					if((error.status==200)&&(error.readyState==4)){
						$('#myModal').modal('show');
						$('#addLocationDiv').hide();
						$('#allLocations').show();
						map.setZoom(5);
						map.setCenter(centerCoordinates);
					} else{
						console.log(error);
					}
				}
			});
		});
		zoomAll();
		zoomToMarker();
		addLocation();
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
		function addLocation() {
			$('#addLocationBtn').click(function(){
				$('#allLocations').hide();
				$('#addLocationDiv').show();
				$('#locationInfo').hide();
				google.maps.event.addListenerOnce(map, 'click', function(event) {
					addMarker(event.latLng, map, null);
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
		}

		// Deletes all markers in the array by removing references to them.
		function deleteMarkers() {
			for (var i = 0; i < markers.length; i++) {
				markers[i].setMap(null);
			}
			labelIndex = 0;
			$('#allLocations').empty();
			markers = [];
		}
		function zoomToMarker() {
			$('.location-input-group').click(function () {
				console.log($(this));
				var markerCenter = {lat: parseFloat($(this).attr('data-lat')), lng: parseFloat($(this).attr('data-lng'))};
				map.setZoom(8);
				map.setCenter(markerCenter);
			});
		}
	}

	function guid() {
		function s4() {
			return Math.floor((1 + Math.random()) * 0x10000)
					.toString(16)
					.substring(1);
		}
		return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
				s4() + '-' + s4() + s4() + s4();
	}
	function printLocationInfo(locationId, map){
		// send ajax request on server with locationId and get location from DB
		$.ajax({
			'type': 'POST',
			'url': 'getLocationInfo',
			'data': locationId,
			'dataType': 'json',
			'contentType': 'application/json',
			'charset':'utf-8',
			'success': function(response){
				var location = response.content.content;
				$('#longitudeInfo').val(location.geoLocation.content.longitude);
				$('#latitudeInfo').val(location.geoLocation.content.latitude);
				$('#countryCodeInfo').val(location.countryCode);
				$('#cityInfo').val(location.city);
				$('#countryInfo').val(location.country);
				$('#dateInfo').val(location.date);
				$('#wasVisitedInfo').prop('checked', location.wasVisited);
				$('#cityInfo').attr('locationUUID', location.locationUUID);
			}
		});
		$('#allLocations').hide();
		$('#addLocationDiv').hide();
		$('#locationInfo').show();

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