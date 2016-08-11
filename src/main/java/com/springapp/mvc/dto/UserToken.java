package com.springapp.mvc.dto;

import org.joda.time.DateTime;
import org.springframework.stereotype.Component;

/**
 * Created by Bohdan on 06.07.2016.
 */
@Component
public class UserToken {
    public String value;

    public User user;

    public long validTill;
    public String type;
}
