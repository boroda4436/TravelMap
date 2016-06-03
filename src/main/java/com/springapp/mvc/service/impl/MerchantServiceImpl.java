package com.springapp.mvc.service.impl;

import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.document.json.JsonArray;
import com.couchbase.client.java.view.AsyncViewResult;
import com.couchbase.client.java.view.AsyncViewRow;
import com.couchbase.client.java.view.Stale;
import com.couchbase.client.java.view.ViewQuery;
import com.springapp.mvc.db.ConnectionManager;
import com.springapp.mvc.service.MerchantService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by Bohdan on 31.05.2016.
 */
@Service
public class MerchantServiceImpl extends BaseServiceImpl implements MerchantService {
    @Override
    public List<JsonDocument> getAll() {
        return fromViewWithoutParsing("landmarks", "get_merchant_location");
    }


}
