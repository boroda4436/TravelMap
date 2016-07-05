package com.springapp.mvc;

import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.document.json.JsonArray;
import com.couchbase.client.java.document.json.JsonObject;
import com.google.gson.Gson;
import com.springapp.mvc.db.initializeDefaultBucket;
import com.springapp.mvc.service.CrudService;
import com.springapp.mvc.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static com.springapp.mvc.db.initializeDefaultBucket.GET_LOCATION_INFO;

@Controller
@RequestMapping("/")
public class HelloController {
	@Autowired
	CrudService crudService;
	@Autowired
	LocationService locationService;

	@RequestMapping(method = RequestMethod.GET)
	public String printWelcome(ModelMap model) {
//		initializeDefaultBucket.initializeLandmarksViews();
		model.addAttribute("userName", "Bohdan");
		model.addAttribute("locations",new Gson().toJson(locationService.getAll()));
		return "hello";
	}
	@RequestMapping(value = "addLocation",method = RequestMethod.GET)
	public String addNewLocation(ModelMap model) {
		locationService.getAll();
		return "addLocation";
	}
	@RequestMapping(value = "postLocation",method = RequestMethod.POST)
	public String postNewLocation(@RequestBody String jsonObject,
										  ModelMap model) {
		JsonObject data = JsonObject.fromJson(jsonObject);
		crudService.insert(JsonDocument.create("placeLocation::" + data.getString("locationUUID"), data));
		model.addAttribute("locations",new Gson().toJson(locationService.getAll()));
		return "hello";
	}
	@RequestMapping(value = "editLocation",method = RequestMethod.POST)
	public String editLocation(@RequestBody String locationEdit,
								  ModelMap model) {
		JsonObject data = JsonObject.fromJson(locationEdit);
		crudService.update(data);
		return "hello";
	}
	@RequestMapping(value = "deleteLocation",method = RequestMethod.POST)
	public String deleteLocation(@RequestBody String locationEdit,
							   ModelMap model) {
		JsonObject data = JsonObject.fromJson(locationEdit);
		crudService.delete(data);
		return "hello";
	}
	@ResponseBody
	@RequestMapping(value = "getLocationInfo", method = RequestMethod.POST)
	public JsonDocument getLocationInfo(@RequestBody String locationId, ModelMap model){
		List<JsonDocument> list = locationService.fromViewWithStringKey(locationId,"landmarks", GET_LOCATION_INFO);
		return list==null?null:list.get(0);
	}

}