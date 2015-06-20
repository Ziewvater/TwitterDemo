//
//  ViewController.h
//  TwitterDemo
//
//  Created by Jeremy Lawrence on 6/18/15.
//  Copyright (c) 2015 Ziewvater. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;


- (IBAction)logInButtonTapped:(UIButton *)sender;
@end

