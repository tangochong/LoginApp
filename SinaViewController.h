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
#define APP_SECRET @"1f1fb2cfc78d064319dfee88c15b2adb"
#define ACCESS_TOKEN_URL @"https://api.weibo.com/oauth2/access_token"
#define USERINFO_URL @"https://api.weibo.com/2/users/show.json"

@interface SinaViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,retain) NSString *_access_token;
@property (nonatomic,retain) NSString *_uid;
+(NSString *) returnOAuthUrlString;
-(void) getAccessToken : (NSString *) code ;
-(void) getUserInfo;
@end
