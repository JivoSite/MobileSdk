package com.jivosite.supportapp;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.net.Uri;
import android.os.Bundle;
import android.webkit.WebView;

//************************
import com.jivosite.sdk.*;

import java.util.Locale;

//**********
public class JivoActivity extends Activity implements JivoDelegate{

    //**************
    JivoSdk jivoSdk;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_jivo);

        String lang = Locale.getDefault().getLanguage().indexOf("ru") >= 0 ? "ru": "en";

        //*********************************************************
        jivoSdk = new JivoSdk((WebView) findViewById(R.id.webview), lang);
        jivoSdk.delegate = this;
        jivoSdk.prepare();
    }

    //*********************************************
    @Override
    public void onEvent(String name, String data) {
        if(name.equals("url.click")){
            if(data.length() > 2){
                String url = data.substring(1, data.length() - 1);
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));
                startActivity(browserIntent);
            }
        }
    }


}
