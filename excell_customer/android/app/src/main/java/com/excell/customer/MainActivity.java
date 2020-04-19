package com.excell.customer;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.billdesk.sdk.PaymentOptions;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private String CHANNEL = "test_activity";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            String MSG = call.argument("MSG");

                            if (call.method.equals("startNewActivity")) {

                                startAct(MSG);

                            }
                        }
                );
    }

    void startAct(String MSG) {

                SampleCallBack objSampleCallBack = new SampleCallBack();

        Intent sdkIntent = new Intent(this, PaymentOptions.class);
//        if(strTokenMsg != null && strTokenMsg.length() > strPGMsg.length()) {
//            sdkIntent.putExtra("token",MSG);
//        }

        sdkIntent.putExtra("msg",MSG);
        sdkIntent.putExtra("user-email","test@bd.com");
        sdkIntent.putExtra("user-mobile","9800000000");
        sdkIntent.putExtra("callback",objSampleCallBack);
        startActivity(sdkIntent);
        
//        Intent intent = new Intent(this, Payment.class);
//        startActivity(intent);
    }


}
