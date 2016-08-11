package com.springapp.mvc.ctrl;

import com.springapp.mvc.ctrl.error.IncorrectPasswordException;
import com.springapp.mvc.ctrl.error.UserExistException;
import com.springapp.mvc.ctrl.error.UserNotFoundException;
import com.springapp.mvc.ctrl.viewmodel.LogInRequest;
import com.springapp.mvc.ctrl.viewmodel.SignInRequest;
import com.springapp.mvc.dto.UserToken;
import com.springapp.mvc.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by Bohdan on 06.07.2016.
 */
@Controller
@RequestMapping("/auth")
public class AuthCtrl {
    @Autowired
    AuthService authService;

    @RequestMapping(value = "login", method = RequestMethod.GET)
    public String logIn() {
        return "login";
    }

    @RequestMapping(value = "login", method = RequestMethod.POST)
    public String logInPost(@RequestBody LogInRequest request, ModelMap model){
        try {
            authService.login(request);
        } catch (IncorrectPasswordException e) {
            model.put("error", e.getMessage());
        } catch (UserNotFoundException e) {
            model.put("error", e.getMessage());
        }
        return "login";
    }

    @RequestMapping(value = "signin", method = RequestMethod.GET)
    public String signIn() {
        return "registration";
    }

    @RequestMapping(value = "signin", method = RequestMethod.POST)
    public void signInPost(@RequestBody SignInRequest request, ModelMap model) {
        try {
            model.put("userToken", authService.signIn(request));
        } catch (UserExistException e) {
            model.put("error", e.getMessage());
        }
    }
}
