//
//  ViewController.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/23/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "LoginViewController.h"
#import "Project.h"
#import "Request.h"
#import "ProjectListViewController.h"
#import <Foundation/Foundation.h>

#define SUCCESSFUL_LOGIN ((int) 200)

@implementation LoginViewController

@synthesize userNameField;
@synthesize passwordField;

NSString *loginURL = @"auth/latest/session/";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
    
    passwordField.secureTextEntry = YES;
    
//    userNameField.placeholder = @"Username";
//    passwordField.placeholder = @"Password";
    
    userNameField.text = @"ipatterson";
    passwordField.text = @"Cherry#2";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)verifyEmail:(id)sender {
    //Dismiss Keyboard
    [self.view endEditing:YES];
    
    // Generate Request
    Request *postRequest = [[Request alloc] initRequestWithURLFragment:loginURL andHttpMethod:POST];
    [self createLoginCredentials:postRequest];

    [NSURLConnection sendAsynchronousRequest:postRequest.request queue:
     [[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         if([(NSHTTPURLResponse*)response statusCode] == SUCCESSFUL_LOGIN){             
             dispatch_sync(dispatch_get_main_queue(), ^{
                 [self performSegueWithIdentifier:@"successfulLogin" sender:self];
             });
         } else {
             NSLog(@"Error!\n\n %@", error.description);
         }
     }];
}

-(void)createLoginCredentials:(Request *)loginRequest{
    NSString *credentials = [NSString stringWithFormat:@"{\"username\" : \"%@\", \"password\" : \"%@\"}", self.userNameField.text, self.passwordField.text];
    
    NSData *jsonData = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    [loginRequest setPostData:jsonData];
}

// Dismiss the keyboard when user touches outside the text fields
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

// Dismiss the keyboard when 'Return' is pressed.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
