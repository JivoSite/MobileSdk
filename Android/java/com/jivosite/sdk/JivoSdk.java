package com.jivosite.sdk;

import android.annotation.TargetApi;
import android.graphics.Bitmap;
import android.os.Build;
import android.support.annotation.NonNull;
import android.view.View;

import android.webkit.WebResourceRequest;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ProgressBar;

import java.net.URLDecoder;

/**
 *  Created by dimmetrius.
 *  Refactored & extended by Maxim Todorenko on 26/02/2018.
 *  Copyright © 2017 JivoSite. All rights reserved.
 *  Copyright © 2018 maximot. All rights reserved.
 *  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 */

/**
 *  This class provides Java business-logic for JivoSite Web-based chat
 *  @author maximot
 *  @author dimmetrius
 */

public class JivoSdk {


    /**
     *  Language constants
     */
    public static final String LANG_RU = "ru";
    public static final String LANG_EN = "en";
    public static final String LANG_DEFAULT = "";

    /**
     *  Constant API_SCHEME determines the String with scheme of JivoSite URI
     */
    private static final String API_SCHEME = "jivoapi://";

    /**
     *  Field mWebView is the WebView that shows the chat to the user
     */
    private WebView mWebView;
    /**
     *  Field mProgressBar is the Android ProgressBar that shows the loading progress to the user
     */
    private ProgressBar mProgressBar;
    /**
     *  Field mLanguage determines which language has to be loaded
     */
    private String mLanguage;
    /**
     *  Field mDelegate is the delegate for interaction with the third-party code
     */
    private JivoDelegate mDelegate = null;


    /**
     *  Minimalistic class constructor.
     *  @param webView the WebView to be used for chat
     *  Default values for other params:
     *  @param loadingProgressBar = null
     *  @param language = LANG_DEFAULT
     */
    public JivoSdk(WebView webView){
       this(webView,null,LANG_DEFAULT);
    }


    /**
     *  Class constructor with language choice.
     *  @param webView the WebView to be used for chat
     *  @param language the language to be used for chat
     *  Default values for other params:
     *  @param loadingProgressBar = null
     */
    public JivoSdk(WebView webView, String language){
        this(webView,null,language);
    }

    /**
     *  Class constructor with language choice & progressBar
     *  @param webView the WebView to be used for chat
     *  @param language the language to be used for chat
     *  @param loadingProgressBar the ProgressBar to be used for indicating webView loading progress
     */
    public JivoSdk(WebView webView, ProgressBar loadingProgressBar, String language){
        this.mWebView = webView;
        this.mLanguage = language;
        this.mProgressBar = loadingProgressBar;
    }


    /**
     *  prepare method must be called after constructor.
     *  That method shows progressBar to the user & loads chat page into prepared webView
     */
    public void prepare(){

        //Show loading spinner
        if(mProgressBar != null){
           mProgressBar.setIndeterminate(true);
           showProgress();
        }

        //Setting up the webView...
        WebSettings webSettings = mWebView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setDatabaseEnabled(true);

        mWebView.setWebViewClient(new JivoWebViewClient());

        //Loading page with chat
        if (this.mLanguage.length() > 0){
            mWebView.loadUrl("file:///android_asset/html/index_"+this.mLanguage +".html");
        }else{
            mWebView.loadUrl("file:///android_asset/html/index.html");
        }

    }

    /**
     *  Delegate getter
     */
    public JivoDelegate getDelegate() {
        return mDelegate;
    }

    /**
     *  Delegate setter
     *  @param delegate the delegate to be setted
     */
    public void setDelegate(JivoDelegate delegate) {
        this.mDelegate = delegate;
    }

    /**
     *  decodeString method decodes String from URI-encoded String
     *  @param encodedURI the String to be decoded
     */
    public static String decodeString(String encodedURI) {
        return URLDecoder.decode(encodedURI);
    }

    /**
     *  showProgress method shows progressBar to the user if it is not null
     */
    private void showProgress() {
        if(mProgressBar!=null){
            mProgressBar.setProgress(0);
            mProgressBar.setVisibility(View.VISIBLE);
        }
    }


    /**
     *  hideProgress method hides progressBar if it is not null
     */
    private void hideProgress() {
        if(mProgressBar!=null){
            mProgressBar.setProgress(100);
            mProgressBar.setVisibility(View.GONE);
        }
    }

    /**
     *  processUrl method processes given url & if it is api call sends message to the delegate
     *  @param url the String to be processed
     */
    private void processUrl(String url) {
        if(url==null) return;

        if (url.toLowerCase().contains(API_SCHEME)){

            String[] components = url.replace(API_SCHEME, "").split("/");

            String apiKey = components[0];
            String dataString = "";

            if (components.length > 1){
                dataString = decodeString(components[1]);
            }

            if (mDelegate !=null) {
                mDelegate.onEvent(apiKey, dataString);
            }
        }
    }

    /**
     *  execJS method executes given script
     *  @param script the JavaScript String to be executed
     */
    private void execJS(@NonNull String script){
        mWebView.evaluateJavascript("javascript:" + script,null);
    }

    /**
     *  callApiMethod method calls JivoSite api methods with given data
     *  @param methodName the JivoApi method name (String) to be executed
     *  @param data the Data (String) to be passed to the JivoApi method
     */
    public void callApiMethod(@NonNull String methodName,@NonNull String data){
        execJS("window.jivo_api." + methodName + "("+ data +");");
    }

    /**
     *  dispose method
     */
    public void dispose(){
        mWebView.loadUrl("about:blank");
        mWebView.destroy();
        mWebView = null;
        mProgressBar = null;
        mDelegate = null;
    }


    /**
     *  JivoWebViewClient class is required to show/hide progress automatically & process api calls
     */
    private class JivoWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url){
            processUrl(url);
            return super.shouldOverrideUrlLoading(view, url);
        }

        @TargetApi(Build.VERSION_CODES.LOLLIPOP)
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, WebResourceRequest request){
            String url = request.getUrl().toString();
            processUrl(url);
            return super.shouldOverrideUrlLoading(view, request);
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon){
            super.onPageStarted(view, url, favicon);
            showProgress();
        }

        @Override
        public void onPageFinished(WebView view, String url){
            super.onPageFinished(view, url);
            hideProgress();
        }

    }

}