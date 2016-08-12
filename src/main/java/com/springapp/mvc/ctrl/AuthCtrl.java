package com.springapp.mvc.ctrl;

import com.springapp.mvc.ctrl.error.IncorrectPasswordException;
import com.springapp.mvc.ctrl.error.UserExistException;
import com.springapp.mvc.ctrl.error.UserNotFoundException;
import com.springapp.mvc.ctrl.viewmodel.LogInRequest;
import com.springapp.mvc.ctrl.viewmodel.LogInResponse;
import com.springapp.mvc.ctrl.viewmodel.SignInRequest;
import com.springapp.mvc.ctrl.viewmodel.SingInResponse;
import com.springapp.mvc.dto.UserToken;
import com.springapp.mvc.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

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

    @ResponseBody
    @RequestMapping(value = "login", method = RequestMethod.POST)
    public LogInResponse logInPost(@RequestBody LogInRequest request, ModelMap model){
        LogInResponse response = new LogInResponse();
        try {
            authService.login(request);
        } catch (IncorrectPasswordException e) {
            response.exception = e;
        } catch (UserNotFoundException e) {
            response.exception = e;
        }
        return response;
    }

    @RequestMapping(value = "signin", method = RequestMethod.GET)
    public String signIn() {
        return "registration";
    }

    @ResponseBody
    @RequestMapping(value = "signin", method = RequestMethod.POST)
    public SingInResponse signInPost(@RequestBody SignInRequest request, ModelMap model) {
        SingInResponse response = new SingInResponse();
        try {
            SecurityContext.getContext().setUserToken(authService.signIn(request));
        } catch (UserExistException e) {
            response.exception = e;
        }
        return response;
    }

    @RequestMapping(value = "logOut", method = RequestMethod.POST)
    public String LogOut(){
        SecurityContext.getContext().setUserToken(null);
        return "redirect:/index";
    }
}
