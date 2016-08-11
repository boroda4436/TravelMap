package com.springapp.mvc.ctrl.error;

public class UserExistException extends Exception {
    public UserExistException(String message) {
        super(message);
    }
}
