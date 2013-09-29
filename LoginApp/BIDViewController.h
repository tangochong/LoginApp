//
//  BIDViewController.h
//  LoginApp
//
//  Created by keenray on 13-9-22.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commoncrypto/CommonDigest.h"

@interface BIDViewController : UIViewController{
   
}
@property (weak, nonatomic) IBOutlet UITextField *FirstField;
@property (weak, nonatomic) IBOutlet UITextField *oneField;
@property (weak, nonatomic) IBOutlet UITextField *twoField;
@property (weak, nonatomic) IBOutlet UITextField *threeField;

@property(nonatomic,retain) NSString *_act;
@property(nonatomic,retain) NSString *_ud;
@property(nonatomic) NSString *_type;
@property(nonatomic,retain) NSString *_username;
@property(nonatomic,retain) NSString *_logo;
@property(nonatomic) NSString *_time;
@property(nonatomic,retain) NSString *_sig;

@property(copy,nonatomic) NSString *user_id;
@property(copy,nonatomic) NSString *user_name;
@property(copy,nonatomic) NSString *logo;
-(NSString*) macaddress;
- (IBAction)sinapressed:(id)sender;
- (IBAction)pressed:(id)sender;
@end
