package com.springapp.mvc.service.impl;

import com.couchbase.client.java.document.JsonDocument;
import com.springapp.mvc.service.LocationService;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by Bohdan on 02.06.2016.
 */
@Service
public class LocationServiceImpl extends BaseServiceImpl implements LocationService {
    @Override
    public List<JsonDocument> getAll() {
        List<JsonDocument>  response = fromViewWithoutParsing("landmarks", "get_place_location");
        return response;
    }
}
