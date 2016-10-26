package com.springapp.mvc.config;

import com.springapp.mvc.dto.UserToken;

public class SecurityContext {
    private static SecurityContext context;
    private UserToken userToken;

    public static synchronized SecurityContext getContext() {
        if (context == null) {
            context = new SecurityContext();
        }
        return context;
    }
    public void setUserToken(UserToken  userToken) {
        getContext().userToken = userToken;

    }

    public UserToken getUserToken() {
        return getContext().userToken;
    }
}
