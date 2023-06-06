package com.excell.customer;
import android.content.Intent;
//import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;

import com.billdesk.sdk.PaymentOptions;
import androidx.appcompat.app.AppCompatActivity;

import android.os.Bundle;
import android.widget.Toast;

public class Payment extends AppCompatActivity {

//    String strPGMsg = "EXCLMDIPVL|10103153|NA|1.18|NA|NA|NA|INR|NA|R|exclmdipvl|NA|NA|F|20200413|H1586786078|NA|NA|NA|Visakhapatnam|1.18|https://billpay.excellmedia.net/billdsk.pl|CA7E96336ED4DD467A3B1FDE14CCECEBEB99727509CA6774274D04342BE30830";
    String strTokenMsg = null;// "AIRMTST|ARP1553593909862|NA|2|NA|NA|NA|INR|NA|R|airmtst|NA|NA|F|NA|NA|NA|NA|NA|NA|NA|https://uat.billdesk.com/pgidsk/pgmerc/pg_dump.jsp|723938585|CP1005!AIRMTST!D1DDC94112A3B939A4CFC76B5490DC1927197ABBC66E5BC3D59B12B552EB5E7DF56B964D2284EBC15A11643062FD6F63!NA!NA!NA";

    Button btnPayNow;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_payment);
        Intent intent = getIntent();
        String MSG = getIntent().getStringExtra("msg");
        Log.d("Debug Msg", MSG);
        btnPayNow = (Button) findViewById(R.id.btnPayNow);
        btnPayNow.setOnClickListener(new View.OnClickListener() {
//            console.log('MSG', MSG);


            @Override
            public void onClick(View v) {
                payNowCalled(MSG);
            }
        });
    }

    private void payNowCalled(String strPGMsg) {
        // call BillDesk SDK

        SampleCallBack objSampleCallBack = new SampleCallBack();

        Intent sdkIntent = new Intent(this, PaymentOptions.class);
        sdkIntent.putExtra("msg",strPGMsg);
//        if(strTokenMsg != null && strTokenMsg.length() > strPGMsg.length()) {
//            sdkIntent.putExtra("token",strTokenMsg);
//        }
        sdkIntent.putExtra("user-email","test@bd.com");
        sdkIntent.putExtra("user-mobile","9800000000");
        sdkIntent.putExtra("callback",objSampleCallBack);
        startActivity(sdkIntent);
     
        
    }
}
