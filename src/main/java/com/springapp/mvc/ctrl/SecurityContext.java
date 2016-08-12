package com.springapp.mvc.ctrl;

import com.springapp.mvc.dto.UserToken;
import org.springframework.stereotype.Component;

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
        if(userToken.validTill>System.currentTimeMillis()) getContext().userToken = userToken;

    }

    public UserToken getUserToken() {
        return getContext().userToken;
    }
}
