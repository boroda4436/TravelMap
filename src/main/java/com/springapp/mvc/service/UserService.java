package com.springapp.mvc.service;

import com.springapp.mvc.ctrl.error.UserExistException;
import com.springapp.mvc.ctrl.error.UserNotFoundException;
import com.springapp.mvc.ctrl.viewmodel.SignInRequest;
import com.springapp.mvc.dto.User;
import com.springapp.mvc.dto.UserToken;

import java.io.IOException;

/**
 * Created by Bohdan on 26.10.2016.
 */
public interface UserService {
    UserToken getByEmail(String email) throws UserNotFoundException, IOException;
    UserToken fromSignInRequest(SignInRequest request) throws UserExistException;
}
