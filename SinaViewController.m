//
//  SinaViewController.m
//  LoginApp
//
//  Created by keenray on 13-9-29.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#import "SinaViewController.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@interface SinaViewController ()

@end

@implementation SinaViewController
@synthesize webView;
@synthesize _access_token;
@synthesize _uid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSMutableString *urlString =[[NSMutableString alloc] initWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&display=mobile&state=authorize",OAuth_URL,APP_KEY,APP_REDIRECT_URL];
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
       [self.webView setDelegate:self];
       [self.webView loadRequest:request];
}

-(void) webViewDidFinishLoad:(UIWebView *)webView{
    /*
    NSString *url = webView.request.URL.absoluteString;
    NSRange rang = NSMakeRange(52,32);
    NSString *_access_token = [url substringWithRange:rang];
    NSLog(@"access_token:%@",_access_token);  
    if([_access_token characterAtIndex:1] == '.')
    {
        [self.webView setHidden:YES];
        [self performSegueWithIdentifier:@"show" sender:nil];
    }*/
}


-(BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *resultStr = [request URL];
    NSString *tempStr = [resultStr absoluteString];
    NSLog(@"resultstr:%@",resultStr);
    //判断是否授权调用返回的URL获取code
    if([tempStr hasPrefix:@"http://weibo.com/638298000/home?"]){
        NSLog(@"back url: %@",tempStr);
        //找到“code＝”的range
        NSRange rangeOne;
        rangeOne = [tempStr rangeOfString:@"code="];
        //根据他的“code＝”的range确定code参数的值的range
        NSRange range = NSMakeRange(rangeOne.length+rangeOne.location, tempStr.length-(rangeOne.length+rangeOne.location));
        //获取code值
        NSString *codeString = [tempStr substringWithRange:range];
        NSLog(@"code = %@",codeString);
        //获取access_token
        [self getAccessToken:codeString];
        //获取用户id,name,头像地址
        [self getUserInfo];
        //跳转登陆成功页面
        [self performSegueWithIdentifier:@"show" sender:nil];
    
    }
    return  YES;
}
+(NSString *) returnOAuthUrlString{
    return  [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&response_type=code&display=mobile&state=authorize",OAuth_URL,APP_KEY,APP_REDIRECT_URL];
}
-(void) getAccessToken : (NSString *) code {
    NSMutableString *accessTokenString = [[NSMutableString alloc] initWithFormat:@"%@?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=",ACCESS_TOKEN_URL,APP_KEY,APP_SECRET,APP_REDIRECT_URL];
    [accessTokenString appendString:code];
    NSURL *urlstring = [NSURL URLWithString:accessTokenString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlstring cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *backString = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    NSDictionary *directionary = [backString objectFromJSONString];
    [[NSUserDefaults standardUserDefaults] setObject:[directionary objectForKey:@"access_token"] forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] setObject:[directionary objectForKey:@"uid"] forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *access = [[NSUserDefaults standardUserDefaults] stringForKey:@"access_token"];
    _access_token=access;
    NSLog(@"access:%@",_access_token);
    NSString *getuid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    _uid=getuid;
    NSLog(@"uid:%@",_uid);
}

-(void) getUserInfo {
    

    NSMutableString *UserInfoString = [[NSMutableString alloc] initWithFormat:@"%@?uid=%@&access_token=%@",USERINFO_URL,_uid,_access_token];
    NSURL *urlstring = [NSURL URLWithString:UserInfoString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlstring cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *backString = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
    NSDictionary *directionary = [backString objectFromJSONString];
     [[NSUserDefaults standardUserDefaults] setObject:[directionary objectForKey:@"id"] forKey:@"id"];
     [[NSUserDefaults standardUserDefaults] setObject:[directionary objectForKey:@"screen_name"] forKey:@"screen_name"];
     [[NSUserDefaults standardUserDefaults] setObject:[directionary objectForKey:@"profile_image_url"] forKey:@"profile_image_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"id"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:@"screen_name"];
    NSString *userImage = [[NSUserDefaults standardUserDefaults] stringForKey:@"profile_image_url"];
    NSLog(@"id=%@;name=%@,image=%@",userId,userName,userImage);
}
-(void) getUIDString {
   // NSString *uidURLString = [[NSString alloc]initWithFormat:@"%@?access_token=%@",GET_UID_URL,[InfoForSina //returnAccessTokenString]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
