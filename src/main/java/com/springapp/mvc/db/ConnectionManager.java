package com.springapp.mvc.db;

import com.couchbase.client.java.Bucket;
import com.couchbase.client.java.Cluster;
import com.couchbase.client.java.CouchbaseCluster;
import com.couchbase.client.java.document.JsonDocument;
import com.couchbase.client.java.env.CouchbaseEnvironment;
import com.couchbase.client.java.env.DefaultCouchbaseEnvironment;
import com.couchbase.client.java.view.AsyncViewResult;
import com.couchbase.client.java.view.AsyncViewRow;
import com.couchbase.client.java.view.Stale;
import com.couchbase.client.java.view.ViewQuery;
import org.springframework.stereotype.Component;
import rx.Observable;
import rx.Subscriber;
import rx.functions.Action1;
import rx.functions.Func1;

import java.util.ArrayList;
import java.util.NoSuchElementException;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

import static com.couchbase.client.java.query.Select.select;

/**
 * Created by Bohdan on 30.05.2016.
 */
@Component
public class ConnectionManager {

    private static final ConnectionManager connectionManager = new ConnectionManager();
    static ArrayList<AsyncViewRow> result = new ArrayList<AsyncViewRow>();
    public static ConnectionManager getInstance() {
        return connectionManager;
    }

    static Cluster cluster = CouchbaseCluster.create();
    static Bucket bucket = cluster.openBucket("default", 2, TimeUnit.MINUTES);

    public static void disconnect() {
        cluster.disconnect();
    }
    public static Bucket getBucket(){
        return bucket;
    }
    public static JsonDocument getItem(String id) {
        JsonDocument response = null;
        try {
            response = bucket.get(id);
        } catch (NoSuchElementException e) {
            System.out.println("ERROR: No element with message: "
                    + e.getMessage());
            e.printStackTrace();
        }
        return response;
    }

    public static ArrayList<AsyncViewRow> getView(String designDoc, String view) {
        final CountDownLatch latch = new CountDownLatch(1);
        System.out.println("METHOD START");

        bucket.async().query(
                ViewQuery.from(designDoc, view).limit(20).stale(Stale.FALSE))
                .doOnNext(new Action1<AsyncViewResult>() {
                    @Override
                    public void call(AsyncViewResult viewResult) {
                        if (!viewResult.success()) {
                            System.out.println(viewResult.error());
                        } else {
                            System.out.println("Query is running!");
                        }
                    }
                }).flatMap(new Func1<AsyncViewResult, Observable<AsyncViewRow>>() {
            @Override
            public Observable<AsyncViewRow> call(AsyncViewResult viewResult) {
                return viewResult.rows();
            }
        }).subscribe(new Subscriber<AsyncViewRow>() {
            @Override
            public void onCompleted() {
                latch.countDown();
            }
            @Override
            public void onError(Throwable throwable) {
                System.err.println("Whoops: " + throwable.getMessage());
            }
            @Override
            public void onNext(AsyncViewRow viewRow) {
                result.add(viewRow);
            }
        });
        try {
            latch.await();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return result;
    }
}