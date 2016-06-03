package com.springapp.mvc;

import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.document.json.JsonObject;
import com.google.gson.Gson;
import com.springapp.mvc.db.ConnectionManager;
import com.springapp.mvc.db.initializeDefaultBucket;
import com.springapp.mvc.service.CrudService;
import com.springapp.mvc.service.MerchantService;
import com.springapp.mvc.service.PlaceLocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/")
public class HelloController {
	@Autowired
	CrudService crudService;
	@Autowired
	PlaceLocationService placeLocationService;

	@RequestMapping(method = RequestMethod.GET)
	public String printWelcome(ModelMap model) {
//		initializeDefaultBucket.initializeLandmarksViews();
		model.addAttribute("userName", "Bohdan");
		model.addAttribute("users",new Gson().toJson(placeLocationService.getAll()));
		return "hello";
	}
	@RequestMapping(value = "addLocation",method = RequestMethod.GET)
	public String addNewLocation(ModelMap model) {
		model.addAttribute("message", "Hello new page");
		placeLocationService.getAll();
		return "addLocation";
	}
	@RequestMapping(value = "postLocation",method = RequestMethod.POST)
	public String postNewLocation(@RequestBody String jsonObject,
										  ModelMap model) {
		model.addAttribute("message", "Hello new page");
		JsonObject data = JsonObject.fromJson(jsonObject);
		crudService.insert(JsonDocument.create("placeLocation::" + data.getString("locationUUID"), data));
		model.addAttribute("users",new Gson().toJson(placeLocationService.getAll()));
		return "hello";
	}

}