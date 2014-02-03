//
//  CreateIssueViewController.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 2/3/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "CreateIssueViewController.h"

@interface CreateIssueViewController ()

@end

@implementation CreateIssueViewController

@synthesize btnCancel;
@synthesize btnSave;

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

- (IBAction)dismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
