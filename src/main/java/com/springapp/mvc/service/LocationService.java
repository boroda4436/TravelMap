package com.springapp.mvc.service;

import com.couchbase.client.java.document.JsonDocument;

import java.util.List;

/**
 * Created by Bohdan on 02.06.2016.
 */
public interface LocationService extends BaseService {
    List<JsonDocument> getAll();
    List<JsonDocument> getAllByUser(String email);

}
