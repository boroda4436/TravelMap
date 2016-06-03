package com.springapp.mvc.service.impl;

import com.couchbase.client.java.document.JsonDocument;
import com.springapp.mvc.dto.Location;
import com.springapp.mvc.dto.parser.LocationParser;
import com.springapp.mvc.service.PlaceLocationService;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.Date;
import java.util.List;

/**
 * Created by Bohdan on 02.06.2016.
 */
@Service
public class PlaceLocationServiceImpl extends BaseServiceImpl implements PlaceLocationService {
    @Override
    public List<JsonDocument> getAll() {
        List<JsonDocument>  response = fromViewWithoutParsing("landmarks", "get_place_location");
        return response;
    }
}
