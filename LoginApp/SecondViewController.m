//
//  SecondViewController.m
//  LoginApp
//
//  Created by keenray on 13-9-28.
//  Copyright (c) 2013年 keenray. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

@synthesize data;
@synthesize SecondField;
@synthesize reid;
@synthesize reidValue;
@synthesize rename;
@synthesize renameValue;
@synthesize relogo;
@synthesize relogoValue;


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

    // NSLog(@"%@,%@,%@,%@",data,reid,rename,relogo);
    //SecondField.text = data;
    //reidValue.text = reid;
   // renameValue.text = rename;
   // relogoValue.text = relogo;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
