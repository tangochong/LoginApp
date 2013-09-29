//
//  BIDViewController.m
//  LoginApp
//
//  Created by keenray on 13-9-22.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#pragma mark MAC addy
// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
#import "BIDViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "MD5Hash.h"
#import "SecondViewController.h"
#import "WeiboSDK.h"
//#import "CommCrypto/CommonDigest.h"
@interface BIDViewController ()

@end

@implementation BIDViewController

@synthesize _act;
@synthesize _ud;
@synthesize _type;
@synthesize _username;
@synthesize _logo;
@synthesize _time;
@synthesize _sig;
@synthesize FirstField;
@synthesize oneField;
@synthesize twoField;
@synthesize threeField;
@synthesize user_id;
@synthesize user_name;
@synthesize logo;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   // NSString *urlString =@"https://api.weibo.com/oauth2/authorize?client_id=318745286&redirect_uri=http://weibo.com/638298000/home&response_type=code&display=mobile&state=authorize";
   // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
 //   [self.webView setDelegate:self];
    
}

/*
-(BOOL) webView:(UIWebView*) webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *backURL = [request URL];
    NSString *backURLString = [backURL absoluteString];
    
    if([backURLString hasPrefix:@"http://weibo.com/638298000/home"]){
        NSLog(@"back url string : %@",backURLString);
        NSRange rangeOne;
        rangeOne = [backURLString rangeOfString:@"code="];
        
        NSString *codeString = [backURLString substringWithRange:rangeOne];
        NSLog(@"code = %@",codeString);
        
        NSMutableString *muString = [[NSMutableString alloc] initWithString:@"https://api.weibo.com/oauth2/access_token?client_id=318745286&client_secret=1f1fb2cfc78d064319dfee88c15b2adb&grant_type=authorization_code&redirect_uri=http://weibo.com/638298000/home&code="];
        [muString appendString:codeString];
        NSLog(@"access token url:%@",muString);
        
        NSURL *urlstring = [NSURL URLWithString:muString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:urlstring cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str = @"type=focus-c";
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        NSData *received = [NSURLConnection sendSynchronousRequest:request  returningResponse:nil error:nil];
        NSString *str1 = [[NSString alloc] initWithData:received encoding:NSUTF8StringEncoding];
        NSLog(@"Back String:%@",str1);
        
        NSDictionary *dictionary = [str1 objectFromJSONString];
        NSLog(@"access token is :%@",[dictionary objectForKey:@"access_token"]);
                          
    }
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressed:(id)sender {
   // NSLog(@"tt");
    //NSString *action =[[NSString alloc] init];
    NSString *MacAddress = [[NSString alloc] init];
    MacAddress = [self macaddress];
    _act = @"login";
    _ud=MacAddress;
    _type = @"1";
    _username=@"";
    _logo=@"";
    
    //获取系统当前时间
    NSDateFormatter *dataFormat = [[NSDateFormatter alloc] init];
    [dataFormat setDateStyle:NSDateFormatterShortStyle];
    [dataFormat setDateFormat:@"yyyyMMddHHmmss"];
    _time = [dataFormat stringFromDate:[NSDate date]];
   // time=[t2 integerValue];
   // NSLog(@"%@",_ud);
    
    //传递接口参数
    
    NSURL *loginUrl = [NSURL URLWithString:@"http://192.168.1.110/sg/"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:loginUrl];
    [request setPostValue:_act forKey:@"act"];
    [request setPostValue:_ud forKey:@"ud"];
    [request setPostValue:_type forKey:@"type"];
    [request setPostValue:_username forKey:@"username"];
    [request setPostValue:_logo forKey:@"logo"];
    [request setPostValue:_time forKey:@"time"];
   
    //sig的生成
    
    NSDictionary *sigdict;
    sigdict = [NSDictionary dictionaryWithObjectsAndKeys:_act,@"act",_ud,@"ud",_type,@"type",_username,@"username",_logo,@"logo", nil];
   // NSLog(@"%@",sigdict);
    NSString *sigtemp =[[NSString alloc] init];
    NSArray *keyss;
    keyss = [sigdict allKeys];
    int k=0;
    //字典排序
    NSArray *sortedArray = [keyss sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray){
        
        NSString *urlcodetemp = @"=";
        NSString *temp = [[NSString alloc]init];
        NSString *encodestring =[sigdict objectForKey:categoryId];
        encodestring = [encodestring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        urlcodetemp = [[sortedArray objectAtIndex:k] stringByAppendingString:urlcodetemp];
        temp = [urlcodetemp stringByAppendingString:encodestring];
        sigtemp = [sigtemp stringByAppendingString:temp];
        k++;
             
    }
    sigtemp = [sigtemp stringByAppendingString:@"time="];
    sigtemp = [sigtemp stringByAppendingString:_time];
    sigtemp = [sigtemp stringByAppendingString:@"fenglei1420"];
     _sig = sigtemp;
    //  NSLog(@"%@",_sig);
    //md5加密
    _sig = [MD5Hash md5:sigtemp];
    //md5大写转小写
    _sig = [_sig lowercaseStringWithLocale:[NSLocale currentLocale]];
    // NSLog(@"%@",_sig);
    [request setPostValue:_sig forKey:@"sig"];
    [request startSynchronous];
  //  [request start];
    NSError *error = [request error];
    if(!error){
      //  NSString *responerror = [request responseString];
     //   NSLog(@"%@",responerror);
    }
    
    //获取返回status 并弹出提示信息 status为200时 不提示
    int statusCode = [request responseStatusCode];
   // NSString *statusMessage = [request responseStatusMessage];
    if(statusCode==404)
    {
        UIAlertView *baseAllert= [[UIAlertView alloc]initWithTitle:@"服务器无法响应请求" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [baseAllert show];
    }
    if(statusCode==500)
    {
        UIAlertView *baseAllert= [[UIAlertView alloc]initWithTitle:@"服务器无法响应请求" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [baseAllert show];
    }
   // NSLog(@"%d,%@",statusCode,statusMessage);
    
    //获取返回message
    //NSString *statusMessage = [request responseStatusMessage];
    // NSLog(@"%@",statusMessage);
   
    NSString *response = [request responseString];
    NSLog(@"%@",response);
    /*
    NSDictionary *loginResponse = [[request responseString] objectFromJSONString];
   
    NSArray *keycount;
    int t;
    keycount = [loginResponse allKeys];
    t=[keycount count];
    for (id key in loginResponse) {
        NSLog(@"%@:%@", key, [loginResponse objectForKey:key]);
    }
    */
    NSDictionary *loginResponse = [[request responseString] objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSString *stacodereturn = [loginResponse objectForKey:@"status"];
   // NSLog(@"%@",stacodereturn);
    int intsatacode = [stacodereturn intValue];
    if(intsatacode==404)
    {
        UIAlertView *baseAlert = [[UIAlertView alloc]
                                  initWithTitle:@"找不到请求的 act,要请求的服务器 api 方法, 不同 api 对应唯一一个 act,详细见接口说明" message:@""
                                  delegate:self cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
        [baseAlert show];
    }
    else if(intsatacode==300)
    {
        UIAlertView *baseAlert = [[UIAlertView alloc]
                                  initWithTitle:@"服务器维护中" message:@""
                                  delegate:self cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
        [baseAlert show];
    }
    else if(intsatacode==500)
    {
        UIAlertView *baseAlert = [[UIAlertView alloc]
                                  initWithTitle:@"参数验证错误" message:@""
                                  delegate:self cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
        [baseAlert show];
    }
    
    else if(intsatacode==501)
    {
        UIAlertView *baseAlert = [[UIAlertView alloc]
                                  initWithTitle:@"DB暂不可用" message:@""
                                  delegate:self cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
        [baseAlert show];
    }
    else if(intsatacode==502)
    {
        UIAlertView *baseAlert = [[UIAlertView alloc]
                                  initWithTitle:@"cache暂不可用" message:@""
                                  delegate:self cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
        [baseAlert show];
    }
    
    /*
    NSString *testdict = @"{\"val\":{\"code\":\"-50\"},\"userinfo\":{\"user_id\":\"111\",\"username\":\"zhong\",\"logo\":\"url\"}}";
    NSDictionary *data = [testdict objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSLog(@"%@",data);
    NSString *codereturn = [[data objectForKey:@"val"] objectForKey:@"code"];
    int codeint = [codereturn intValue];
    if(codeint<0){
        UIAlertView *baseAlert = [[UIAlertView alloc]
                                  initWithTitle:@"10000" message:@""
                                  delegate:self cancelButtonTitle:nil
                                  otherButtonTitles:@"OK", nil];
        [baseAlert show];
    }
     */
    NSString *codereturn = [[loginResponse objectForKey:@"val"] objectForKey:@"code"];
    int codeint = [codereturn intValue];
    if(codeint<0){
        UIAlertView *baseAlert = [[UIAlertView alloc] initWithTitle:@"连接错误！请重试！" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [baseAlert show];
    }
    user_id = [[[loginResponse objectForKey:@"val"] objectForKey:@"userinfo"] objectForKey:@"user_id"];
    user_name = [[[loginResponse objectForKey:@"val"] objectForKey:@"userinfo"] objectForKey:@"username"];
    logo = [[[loginResponse objectForKey:@"val"] objectForKey:@"userinfo"] objectForKey:@"logo"];
    NSLog(@"%@,%@,%@",user_id,user_name,logo);
    
    
    [self performSegueWithIdentifier:@"login" sender:self];
   
}
/*
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *msg = FirstField.text;
    oneField.text=user_id;
    twoField.text=user_name;
    threeField.text=logo;
    NSString *msg1=oneField.text;
    NSString *msg2=twoField.text;
    NSString *msg3=threeField.text;
    NSLog(@"%@,%@,%@,%@",msg,msg1,msg2,msg3);
    UIViewController *send = segue.destinationViewController;
    if([send respondsToSelector:@selector(setData:)]){
      //  [send setValue:msg forKey:@"data"];
        [send setValue:msg1 forKey:@"reid"];
        //[send setValue:msg2 forKey:@"rename"];
        //[send setValue:msg3 forKey:@"relogo"];
    }
    
}
*/
-(NSString*) macaddress{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    NSString *message = [[NSString alloc] init];
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        message=@"Error:if_nametoindex error";
       _ud=message;
        //  printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        message=@"Error: sysctl, take 1";
       _ud=message;
        //  printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        message=@"Could not allocate memory. error!";
        _ud=message;
        // printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        message=@"Error: sysctl, take 2";
       _ud=message;
        // printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];

}

- (IBAction)sinapressed:(id)sender {
    [self performSegueWithIdentifier:@"sinalogin" sender:self];
}


- (IBAction)weibopressed:(id)sender {
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    //request.scope= =@"email,direct_messages_write";
    request.scope = @"email,direct_messages_write";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
     
     
}
@end
