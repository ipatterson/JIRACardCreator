//
//  ViewController.h
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/23/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, NSURLConnectionDelegate>

- (IBAction)verifyEmail:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end
