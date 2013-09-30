//
//  SinaViewController.h
//  LoginApp
//
//  Created by keenray on 13-9-29.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#import <UIKit/UIKit.h>
#define OAuth_URL @"https://api.weibo.com/oauth2/authorize"
#define APP_KEY @"318745286"
#define APP_REDIRECT_URL @"http://weibo.com/638298000/home"

@interface SinaViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
