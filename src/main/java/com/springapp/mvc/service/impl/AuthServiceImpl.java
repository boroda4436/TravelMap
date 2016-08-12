package com.springapp.mvc.service.impl;

import com.couchbase.client.deps.com.fasterxml.jackson.databind.ObjectMapper;
import com.couchbase.client.deps.com.fasterxml.jackson.databind.util.JSONWrappedObject;
import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.document.json.JsonObject;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.springapp.mvc.ctrl.SecurityContext;
import com.springapp.mvc.ctrl.error.IncorrectPasswordException;
import com.springapp.mvc.ctrl.error.UserExistException;
import com.springapp.mvc.ctrl.error.UserNotFoundException;
import com.springapp.mvc.ctrl.viewmodel.LogInRequest;
import com.springapp.mvc.ctrl.viewmodel.SignInRequest;
import com.springapp.mvc.dto.Profile;
import com.springapp.mvc.dto.Role;
import com.springapp.mvc.dto.User;
import com.springapp.mvc.dto.UserToken;
import com.springapp.mvc.service.AuthService;
import com.springapp.mvc.service.BaseService;
import com.springapp.mvc.service.CrudService;
import com.springapp.mvc.service.LocationService;
import com.springapp.mvc.util.CryptoHelper;
import jdk.nashorn.internal.parser.JSONParser;
import org.apache.log4j.Logger;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.UUID;

import static com.springapp.mvc.db.initializeDefaultBucket.GET_LOCATION_INFO;
import static com.springapp.mvc.db.initializeDefaultBucket.GET_USER_TOKEN_BY_EMAIL;

/**
 * Created by Bohdan on 06.07.2016.
 */
@Service
public class AuthServiceImpl implements AuthService {
    public final int TOKEN_LIFE_TIME = 2;//days;
    final static Logger log = Logger.getLogger(AuthService.class);
    @Autowired
    CrudService crudService;
    @Autowired
    LocationService locationService;
    @Autowired
    BaseService baseService;
    @Override
    public User userByToken(String token) {
        return null;
    }

    @Override
    public UserToken signIn(SignInRequest request) throws UserExistException {
        List<JsonDocument> list = locationService.fromViewWithStringKey(request.email,"landmarks", GET_USER_TOKEN_BY_EMAIL);
        JsonDocument res = list==null?null:list.size()>0?list.get(0):null;
        if(res!=null) throw new UserExistException("User with such email already exist!");
        String slat = CryptoHelper.newSlat();
        String password = CryptoHelper.GetPasswordHash(request.password,slat);
        User user = new User();
        user.email = request.email;
        Profile profile = new Profile();
        profile.role  = Role.USER_ROLE;
        user.profile = profile;
        user.joinDate = DateTime.now().getMillis();
        user.password = password;
        user.slat = slat;
        UserToken token = new UserToken();
        token.user = user;
        token.value = CryptoHelper.newToken();
        token.validTill = DateTime.now().plusDays(TOKEN_LIFE_TIME).getMillis();
        token.type = "userToken";
        crudService.insert(JsonDocument.create("user::" + UUID.randomUUID(), JsonObject.fromJson(new Gson().toJson(token))));
        return token;
    }

    @Override
    public UserToken login(LogInRequest request) throws IncorrectPasswordException, UserNotFoundException {
        List<JsonDocument> list = locationService.fromViewWithStringKey(request.email,"landmarks", GET_USER_TOKEN_BY_EMAIL);
        JsonDocument res = list==null?null:list.size()>0?list.get(0):null;
        if (res==null) throw new UserNotFoundException("User not found! Please, check your email address");
        UserToken userToken = null;
        try {
            userToken = new ObjectMapper().readValue(res.content().toString(), UserToken.class);
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
