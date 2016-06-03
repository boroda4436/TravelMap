package com.springapp.mvc.service;

import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.document.json.JsonArray;
import com.couchbase.client.java.view.ViewQuery;

import java.util.List;

/**
 * Created by Bohdan on 02.06.2016.
 */
public interface BaseService {
    List<JsonDocument> fromViewWithoutParsing(ViewQuery viewQuery);
    List<JsonDocument> fromViewWithKeys(JsonArray keys, String designDocument, String view);
    List<JsonDocument> fromViewWithoutParsing(String designDocument, String view);
}
