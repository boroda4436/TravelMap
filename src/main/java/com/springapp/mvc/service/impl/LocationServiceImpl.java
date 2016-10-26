package com.springapp.mvc.service.impl;

import com.couchbase.client.java.document.JsonDocument;
import com.springapp.mvc.config.SecurityContext;
import com.springapp.mvc.service.LocationService;
import org.springframework.stereotype.Service;

import java.util.List;

import static com.springapp.mvc.db.initializeDefaultBucket.GET_PLACE_LOCATIONS;

/**
 * Created by Bohdan on 02.06.2016.
 */
@Service
public class LocationServiceImpl extends BaseServiceImpl implements LocationService {
    @Override
    public List<JsonDocument> getAll() {
        List<JsonDocument>  response = fromViewWithStringKey(
                SecurityContext.getContext().getUserToken().user.email, "landmarks", GET_PLACE_LOCATIONS);
        return response;
    }

    @Override
    public List<JsonDocument> getAllByUser(String email) {
        List<JsonDocument>  response = fromViewWithStringKey(email, "landmarks", GET_PLACE_LOCATIONS);
        return response;
    }
}
