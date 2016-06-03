package com.springapp.mvc.dto.parser;

import com.couchbase.client.java.document.JsonDocument;
import com.springapp.mvc.dto.Location;
import org.springframework.stereotype.Component;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Bohdan on 03.06.2016.
 */
@Component
public class LocationParser {
    public LocationParser() {
    }
    public static Location build (JsonDocument jsonDocument) {
        Location location = parseLocation(jsonDocument);
        return location;
    }
    public static List<Location> build(List<JsonDocument> jsonDocumentList){
        List<Location> locations = new ArrayList<>();
        jsonDocumentList.forEach(x->locations.add(parseLocation(x)));
        return locations;
    }
    private static Location parseLocation(JsonDocument jsonDocument){
        Location location = new Location();
        location.city = jsonDocument.content().getString("city");
        location.country = jsonDocument.content().getString("country");
        location.countryCode = jsonDocument.content().getString("countryCode");
        location.userUUID = jsonDocument.content().getString("userUUID");
        location.wasVisited = jsonDocument.content().getBoolean("wasVisited");
        String target = jsonDocument.content().getString("date");
        DateFormat df = new SimpleDateFormat("dd MM yyyy ");
        Date date = null;
        try {
            date =  df.parse(target);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        location.date = date;
        return location;
    }
}
