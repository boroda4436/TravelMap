package com.springapp.mvc.service;

import com.springapp.mvc.ctrl.error.IncorrectPasswordException;
import com.springapp.mvc.ctrl.error.UserExistException;
import com.springapp.mvc.ctrl.error.UserNotFoundException;
import com.springapp.mvc.ctrl.viewmodel.LogInRequest;
import com.springapp.mvc.ctrl.viewmodel.SignInRequest;
import com.springapp.mvc.dto.User;
import com.springapp.mvc.dto.UserToken;

/**
 * Created by Bohdan on 06.07.2016.
 */
public interface AuthService {
    User userByToken(String token);
    UserToken signIn(SignInRequest request) throws UserExistException;
    UserToken login(LogInRequest request) throws IncorrectPasswordException, UserNotFoundException;
}
