package com.springapp.mvc.db;

import com.couchbase.client.java.bucket.BucketManager;
import com.couchbase.client.java.view.DefaultView;
import com.couchbase.client.java.view.DesignDocument;
import com.couchbase.client.java.view.SpatialView;
import org.springframework.stereotype.Component;

import java.util.Arrays;

/**
 * Created by Bohdan on 30.05.2016.
 */
@Component
public class initializeDefaultBucket {
    public static final String GET_COORDINATES = "get_coordinates";
    public static final String GET_MERCHANT_LOCATIONS = "get_merchant_location";
    public static final String GET_PLACE_LOCATIONS = "get_place_location";
    public static void initializeLandmarksViews(){
        BucketManager bucketManager = ConnectionManager.getBucket().bucketManager();
        DesignDocument isExist = bucketManager.getDesignDocument("merchants");
        DesignDocument designDoc = DesignDocument.create(
                "landmarks",
                Arrays.asList(
                        DefaultView.create(GET_COORDINATES,
                                "function (doc, meta) { " +
                                        "if (doc.type == 'user') { " +
                                        "emit([doc.location.longitude, " +
                                        "doc.location.latitude], null); } }"
                        ), DefaultView.create(GET_MERCHANT_LOCATIONS,
                                "function (doc, meta) {\n" +
                                        "  if(doc.type=='location')\n" +
                                        "  emit([doc.country.alpha2Code], doc.storeName);\n" +
                                        "}"
                        ), DefaultView.create(GET_PLACE_LOCATIONS,
                                "function (doc, meta) { " +
                                        "if (doc.type == 'placeLocation') { " +
                                        "emit(meta.id, null); } }"
                        ))
                );
        if(isExist==null) {
            bucketManager.insertDesignDocument(designDoc);
        } else {
            bucketManager.upsertDesignDocument(designDoc);
        }
        }
}
