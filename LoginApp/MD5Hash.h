//
//  MD5Hash.h
//  LoginApp
//
//  Created by keenray on 13-9-24.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
@interface MD5Hash : NSObject{
    
}
+(NSString*)md5:(NSString*)str;
@end
