package com.springapp.mvc.ctrl;

import com.google.gson.Gson;
import com.springapp.mvc.dto.User;
import com.springapp.mvc.service.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * Created by Bohdan on 26.10.2016.
 */
@Controller
@RequestMapping(value = "/social")
public class SocialCtrl {

    @Autowired
    LocationService locationService;

    @RequestMapping(value = "user", method = RequestMethod.GET)
    public String findUser(ModelMap model, @RequestParam String email){

//        User user
        model.addAttribute("locations",new Gson().toJson(locationService.getAllByUser(email)));
        return "social/userLocations";
    }
}
