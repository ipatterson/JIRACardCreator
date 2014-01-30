//
//  IssueDetailViewController.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/29/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "IssueDetailViewController.h"
#import "ProjectCard.h"

@interface IssueDetailViewController ()

@end

@implementation IssueDetailViewController

@synthesize btnEditIssue;
@synthesize txtSummary;
@synthesize txtStatus;
@synthesize txtReporter;
@synthesize imgReporter;
@synthesize txtAssignee;
@synthesize imgAssignee;
@synthesize btnIssueType;
@synthesize btnStoryPoints;
@synthesize txtDescription;

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

@end
