//
//  ViewController.m
//  ApiDemo
//
//  Created by Dimmetrius on 14.01.16.
//  Copyright © 2016 JivoSite. All rights reserved.
//

#import "ChatController.h"

@interface ChatController ()
{
    //***************
    JivoSdk* jivoSdk;
    
    NSString *langKey;
}
@property (weak, nonatomic) IBOutlet UIWebView *JivoView;
@end

@implementation ChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    langKey = [[NSBundle mainBundle] localizedStringForKey:(@"LangKey") value:@"" table:nil];
    
    //*********************************************
    jivoSdk = [[JivoSdk alloc] initWith: _JivoView :langKey];
    
    jivoSdk.delegate = self;
    
    [jivoSdk prepare];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];

    //*************
    [jivoSdk start];
    
    if ([langKey isEqualToString:@"ru"]){
        self.navigationItem.title = @"Техподдержка JivoSite";
    }else{
        self.navigationItem.title = @"JivoChat Support";
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //*************
    [jivoSdk stop];
    
}

-(void)dealloc{
    //*************
    [jivoSdk stop];
}

//************************************************
-(void)onEvent:(NSString *)name :(NSString*)data;{
    NSLog(@"event:%@, data:%@", name, data);
    if([[name lowercaseString] isEqualToString:@"url.click"]){
        if([data length] > 2){
            NSString *urlStr = [data substringWithRange:NSMakeRange(1,[data length] - 2)];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
