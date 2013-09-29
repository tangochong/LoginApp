//
//  SecondViewController.h
//  LoginApp
//
//  Created by keenray on 13-9-28.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *SecondField;
@property (weak, nonatomic) IBOutlet UITextField *reidValue;
@property (weak, nonatomic) IBOutlet UITextField *renameValue;
@property (weak, nonatomic) IBOutlet UITextField *relogoValue;
@property (strong,nonatomic) NSString *data;
@property (strong,nonatomic) NSString *reid;
@property (strong,nonatomic) NSString *rename;
@property (strong,nonatomic) NSString *relogo;
@end
