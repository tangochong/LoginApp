//
//  SinaViewController.m
//  LoginApp
//
//  Created by keenray on 13-9-29.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#import "SinaViewController.h"
#import "JSONKit.h"
@interface SinaViewController ()

@end

@implementation SinaViewController
@synthesize webView;

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
    NSString *urlString =@"https://api.weibo.com/oauth2/authorize?client_id=318745286&redirect_uri=http://weibo.com/638298000/home&response_type=code&display=mobile&state=authorize";
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
      //获取access_token调用URL的string
       NSMutableString *muString = [[NSMutableString alloc] initWithString:@"https://api.weibo.com/oauth2/access_token?client_id=318745286&client_secret=1f1fb2cfc78d064319dfee88c15b2adb&grant_type=authorization_code&redirect_uri=http://weibo.com/638298000/home&code="];
        [muString appendString:codeString];
        NSLog(@"access token url :%@",muString);
        NSURL *urlstring = [NSURL URLWithString:muString];
        //第一步，创建URL
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlstring cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        //创建请求
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET  
        NSString *str = @"type=focus-c";//设置参数  
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        //第三步，连接服务器  
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str1 = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
        NSLog(@"back string :%@",str1);
         //如何从str1中获取到access_token  
        NSDictionary *directionary = [str1 objectFromJSONString];
        NSLog(@"access token is :%@",[directionary objectForKey:@"access_token"]);
         [self performSegueWithIdentifier:@"show" sender:nil];
    
    }
    /*
    NSRange range = [tempStr rangeOfString:@"code="];
    if(!(range.location == NSNotFound)){
        NSString *tempStr = [resultStr absoluteString];
        NSArray *codeArr = [tempStr componentsSeparatedByString:@"="];
        NSLog(@"codearr:%@",codeArr);
        NSString *code = [codeArr objectAtIndex:1];
        NSLog(@"code:%@",code);
    }*/
    return  YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
