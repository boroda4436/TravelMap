package com.springapp.mvc.ctrl.viewmodel;

public class LogInResponse {
    public Exception exception;

    public LogInResponse() {}
    public LogInResponse(Exception exception) {
        this.exception = exception;
    }

}
