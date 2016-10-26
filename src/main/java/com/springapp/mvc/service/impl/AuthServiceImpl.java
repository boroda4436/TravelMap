package com.springapp.mvc.service.impl;

import com.couchbase.client.deps.com.fasterxml.jackson.databind.ObjectMapper;
import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.document.json.JsonObject;
import com.google.gson.Gson;
import com.springapp.mvc.config.SecurityContext;
import com.springapp.mvc.ctrl.error.IncorrectPasswordException;
import com.springapp.mvc.ctrl.error.UserExistException;
import com.springapp.mvc.ctrl.error.UserNotFoundException;
import com.springapp.mvc.ctrl.viewmodel.LogInRequest;
import com.springapp.mvc.ctrl.viewmodel.SignInRequest;
import com.springapp.mvc.dto.Profile;
import com.springapp.mvc.dto.Role;
import com.springapp.mvc.dto.User;
import com.springapp.mvc.dto.UserToken;
import com.springapp.mvc.service.*;
import com.springapp.mvc.util.CryptoHelper;
import org.apache.log4j.Logger;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import static com.springapp.mvc.db.initializeDefaultBucket.GET_USER_TOKEN_BY_EMAIL;

/**
 * Created by Bohdan on 06.07.2016.
 */
@Service
public class AuthServiceImpl implements AuthService {
    public static final int TOKEN_LIFE_TIME = 2;//days;
    final static Logger log = Logger.getLogger(AuthService.class);
    @Autowired
    CrudService crudService;
    @Autowired
    LocationService locationService;
    @Autowired
    BaseService baseService;
    @Autowired
    UserService userService;
    @Override
    public User userByToken(String token) {
        return null;
    }

    @Override
    public UserToken signIn(SignInRequest request) throws UserExistException {

        UserToken token = userService.fromSignInRequest(request);
        crudService.insert(JsonDocument.create("user::" + UUID.randomUUID(), JsonObject.fromJson(new Gson().toJson(token))));
        return token;
    }

    @Override
    public UserToken login(LogInRequest request) throws IncorrectPasswordException, UserNotFoundException {
        UserToken userToken = null;
        try {
            userToken = userService.getByEmail(request.email);
        } catch (IOException e) {
            log.error("can't parse JsonDocument to UserToken.class " + e);
        }
        if(userToken!=null){
            if(CryptoHelper.CheckPassword(request.password, userToken.user.slat, userToken.user.password)){
                SecurityContext.getContext().setUserToken(userToken);
                return userToken;
            } else throw new IncorrectPasswordException("Wrong password! Please, try again");
        }
        return null;
    }
}
