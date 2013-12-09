//
//  FirstLoViewController.m
//  LoginApp
//
//  Created by keenray on 13-12-3.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#import "FirstLoViewController.h"

@interface FirstLoViewController ()

@end

@implementation FirstLoViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:Nil];
    [UIView setAnimationDuration:animationDuration];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
}
- (IBAction)Login:(UIButton *)sender {
}
- (IBAction)textFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}
- (IBAction)backgroundTap:(id)sender{
    [self.NameField resignFirstResponder];
    [self.SecretField resignFirstResponder];
}

@end
