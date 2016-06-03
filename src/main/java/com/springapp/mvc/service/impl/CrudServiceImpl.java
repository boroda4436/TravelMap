package com.springapp.mvc.service.impl;

import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.document.json.JsonArray;
import com.couchbase.client.java.document.json.JsonObject;
import com.couchbase.client.java.view.AsyncViewResult;
import com.couchbase.client.java.view.AsyncViewRow;
import com.couchbase.client.java.view.Stale;
import com.couchbase.client.java.view.ViewQuery;
import com.springapp.mvc.db.ConnectionManager;
import com.springapp.mvc.service.CrudService;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * Created by Bohdan on 31.05.2016.
 */
@Service
public class CrudServiceImpl implements CrudService {


    @Override
    public JsonDocument insert(JsonDocument doc) {
        ConnectionManager.getBucket().insert(doc);
        return doc;
    }

    @Override
    public void insertDump() {

        String city;
        String countryCode;
        String country;
        for (int i = 0; i < 10; i++) {
            if(i%2==0){city = "Irshava";} else {city="Kiev";}
            if(i%2==0){countryCode = "GB";} else {countryCode = "FR";}
            if(i%3==0){country="France";} else if(i%3==1){country="Ukraine";} else {country="Spain";}

            JsonObject data = JsonObject.create()
                .put("type", "location")
                .put("name", "bob_" + i)
                .put("password", "password" + i)
                .put("city", city)
                .put("county", country)
                .put("storeName", "storeName" + i%5)
                .put("merchantId", "11195977235" + i)
                .put("locationId", UUID.randomUUID().toString())
                .put("country", JsonObject.create().put("alpha2Code", countryCode))
                .put("geoLocation", JsonObject.create().put("longitude", 40.9501001 + i).put("latitude", -3.0234001 + i));
                JsonDocument doc = JsonDocument.create("user::" + (10+i), data);
                insert(doc);
        }
    }

}
