package com.springapp.mvc.dto;

import org.joda.time.DateTime;
import org.springframework.stereotype.Component;

/**
 * Created by Bohdan on 06.07.2016.
 */
@Component
public class User {
    public String email;
    public String password;
    public String slat;

    public Profile profile;

    public long joinDate;
}
