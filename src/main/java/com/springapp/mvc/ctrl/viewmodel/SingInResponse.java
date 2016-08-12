package com.springapp.mvc.ctrl.viewmodel;

public class SingInResponse {
    public Exception exception;

    public SingInResponse() {}

    public SingInResponse(Exception exception) {
        this.exception = exception;
    }
}
