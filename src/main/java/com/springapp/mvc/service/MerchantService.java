package com.springapp.mvc.service;

import com.couchbase.client.java.document.JsonDocument;

import java.util.List;

/**
 * Created by Bohdan on 31.05.2016.
 */
public interface MerchantService extends BaseService {
    List<JsonDocument> getAll();
}
