package com.springapp.mvc.dto;

import org.springframework.stereotype.Component;

/**
 * Created by Bohdan on 06.07.2016.
 */
public enum  Role {
    USER_ROLE("USER"),
    ADMIN_ROLE("ADMIN");

    private String name;

    Role() {
    }
    Role(String name) {
        this.name = name;
    }
}
