//
//  FirstLoViewController.h
//  LoginApp
//
//  Created by keenray on 13-12-3.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstLoViewController : UIViewController<UITextFieldDelegate>
- (IBAction)Login:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *NameField;
@property (strong, nonatomic) IBOutlet UIView *SecretField;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
@end
