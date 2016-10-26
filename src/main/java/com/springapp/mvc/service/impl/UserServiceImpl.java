package com.springapp.mvc.service.impl;

import com.couchbase.client.deps.com.fasterxml.jackson.databind.ObjectMapper;
import com.couchbase.client.java.document.JsonDocument;
import com.springapp.mvc.ctrl.error.UserExistException;
import com.springapp.mvc.ctrl.error.UserNotFoundException;
import com.springapp.mvc.ctrl.viewmodel.SignInRequest;
import com.springapp.mvc.dto.Profile;
import com.springapp.mvc.dto.Role;
import com.springapp.mvc.dto.User;
import com.springapp.mvc.dto.UserToken;
import com.springapp.mvc.service.LocationService;
import com.springapp.mvc.service.UserService;
import com.springapp.mvc.util.CryptoHelper;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;

import static com.springapp.mvc.db.initializeDefaultBucket.GET_USER_TOKEN_BY_EMAIL;
import static com.springapp.mvc.service.impl.AuthServiceImpl.TOKEN_LIFE_TIME;

/**
 * Created by Bohdan on 26.10.2016.
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    LocationService locationService;
    @Override
    public UserToken getByEmail(String email) throws UserNotFoundException, IOException {
        List<JsonDocument> list = locationService.fromViewWithStringKey(email,"landmarks", GET_USER_TOKEN_BY_EMAIL);
        JsonDocument res = list==null?null:list.size()>0?list.get(0):null;
        if (res==null) throw new UserNotFoundException("User not found! Please, check your email address");
        UserToken userToken = null;
        userToken = new ObjectMapper().readValue(res.content().toString(), UserToken.class);
        return userToken;
    }

    @Override
    public UserToken fromSignInRequest(SignInRequest request) throws UserExistException {
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
        return token;
    }
}
