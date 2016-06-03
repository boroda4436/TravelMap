package com.springapp.mvc.service.impl;

import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.document.json.JsonArray;
import com.couchbase.client.java.view.AsyncViewResult;
import com.couchbase.client.java.view.AsyncViewRow;
import com.couchbase.client.java.view.Stale;
import com.couchbase.client.java.view.ViewQuery;
import com.springapp.mvc.db.ConnectionManager;
import com.springapp.mvc.service.BaseService;

import java.util.List;

/**
 * Created by Bohdan on 02.06.2016.
 */
public abstract class BaseServiceImpl implements BaseService {
    @Override
    public List<JsonDocument> fromViewWithoutParsing(String designDocument, String view) {
        ViewQuery viewQuery =
                ViewQuery.from(designDocument, view)
                        .stale(Stale.FALSE);

        return fromViewWithoutParsing(viewQuery);
    }
    @Override
    public List<JsonDocument> fromViewWithKeys(JsonArray keys, String designDocument, String view) {
        ViewQuery viewQuery =
                ViewQuery.from(designDocument, view)
                        .key(keys)
                        .includeDocsOrdered()
                        .stale(Stale.FALSE);

        return fromViewWithoutParsing(viewQuery);
    }
    @Override
    public List<JsonDocument> fromViewWithoutParsing(ViewQuery viewQuery) {

        return ConnectionManager.getBucket().async()
                .query(viewQuery)
                .flatMap(AsyncViewResult::rows)
                .flatMap(AsyncViewRow::document)
                .toList()
                .toBlocking()
                .single();
    }
}
