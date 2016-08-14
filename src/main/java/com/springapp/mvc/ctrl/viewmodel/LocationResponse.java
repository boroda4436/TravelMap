package com.springapp.mvc.ctrl.viewmodel;

import com.couchbase.client.java.document.JsonDocument;

import java.util.List;

public class LocationResponse {
    public List<JsonDocument> locations;
    public Exception exception;
}
