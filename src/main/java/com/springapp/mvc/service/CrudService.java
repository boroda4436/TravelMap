package com.springapp.mvc.service;

import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.document.json.JsonArray;
import com.couchbase.client.java.view.ViewQuery;

import java.util.List;

/**
 * Created by Bohdan on 31.05.2016.
 */

public interface CrudService {
    JsonDocument insert(JsonDocument doc);
    void insertDump();

}
