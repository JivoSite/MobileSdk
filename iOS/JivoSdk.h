//
//  JivoSdk.h
//  JivoSupport
//
//  Created by Dimmetrius on 15.03.16.
//  Copyright © 2016 JivoSite. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef JivoSdk_h
#define JivoSdk_h

@protocol JivoDelegate

// define protocol functions that can be used in any class using this delegate
-(void)onEvent:(NSString *)name :(NSString*)data;

@end

@interface JivoSdk : NSObject<UIWebViewDelegate>

@property (nonatomic, assign) id delegate;
@property (strong, nonatomic) UIWebView* webView;
@property (strong, nonatomic) NSString* language;

-(id) initWith:(UIWebView*)web :(NSString*) lang;
-(id) initWith:(UIWebView*)web;
-(void) prepare;
-(void) start;
-(void) stop;
-(NSString*) execJs : (NSString*) code;
-(void) callApiMethod: (NSString*) methodName : (NSString*)data;

@end

#endif /* JivoSdk_h */
