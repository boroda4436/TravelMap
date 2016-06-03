package com.springapp.mvc.dto;

import org.springframework.stereotype.Component;

import java.util.Date;

/**
 * Created by Bohdan on 01.06.2016.
 */
@Component
public class Location {
    public GeoPosition geoPosition;
    public String country;
    public String city;
    public String countryCode;
    public boolean wasVisited;
    public Date date;
    public String userUUID;
}
