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
@synthesize btnStoryValue;
@synthesize txtDescription;
@synthesize project;

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
    self.navigationItem.title = [self.project cardName];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self loadIssueData];
    
    btnEditIssue = self.editButtonItem;
    [btnEditIssue setTarget:self];
    [btnEditIssue setAction:@selector(toggleEdit)];
    self.navigationItem.rightBarButtonItem = btnEditIssue;
    [self disableEditing];
    
}

- (void)loadIssueData{
    self.txtSummary.text = [self.project cardSummary];
    self.txtStatus.text = [self.project cardStatus];
    self.txtReporter.text = [self.project cardReporter];
    self.txtAssignee.text = [self.project cardAssignee];
    
    [self updateIssueTypeButtonText:[self.project cardIssueType]];
    [self updateStoryValueButtonValue:[self.project cardStoryValue]];
    
    NSURL *imageReporterURL = [NSURL URLWithString:[self.project cardReporterAvatarURL]];
    NSURL *imageAssigneeURL = [NSURL URLWithString:[self.project cardAssigneeAvatarURL]];
    
    //Async calls to download image avatars
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageReporterURL];
        if(imageData){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imgReporter.image = [UIImage imageWithData:imageData];
            });
        }
        imageData = [NSData dataWithContentsOfURL:imageAssigneeURL];
        if(imageData){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imgAssignee.image = [UIImage imageWithData:imageData];
            });
        }
    });
    
    self.txtDescription.text = [self.project cardDescription];
}

-(void)disableEditing{
    [self.txtSummary setTextColor:[UIColor darkGrayColor]];
    [self.txtDescription setTextColor:[UIColor darkGrayColor]];
    [self.txtSummary setEditable:NO];
    [self.txtDescription setEditable:NO];
    [self.btnIssueType setEnabled:NO];
    [self.btnStoryValue setEnabled:NO];
}

-(void)enableEditing{
    [self.txtSummary setEditable:YES];
    [self.txtSummary setTextColor:self.view.tintColor];
    [self.txtDescription setTextColor:self.view.tintColor];
    [self.txtDescription setEditable:YES];
    [self.btnIssueType setEnabled:YES];
    [self.btnStoryValue setEnabled:YES];
}

-(void)updateIssueTypeButtonText:(NSString *)title {
    [self.btnIssueType setTitle:title forState:UIControlStateDisabled];
    [self.btnIssueType setTitle:title forState:UIControlStateNormal];
}

-(void)updateStoryValueButtonValue:(NSNumber *)value {
    [self.btnStoryValue setTitle:[value stringValue] forState:UIControlStateNormal];
    [self.btnStoryValue setTitle:[value stringValue] forState:UIControlStateDisabled];
}

// Dismiss the keyboard when user touches outside the text fields
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)toggleEdit{
    BOOL editing = self.editing;
    [super setEditing:!editing animated:NO];
    
    [UIView animateWithDuration:2.0
                     animations:^{
                         self.navigationItem.rightBarButtonItem.customView.alpha = 0;
                     }];

    if(!editing){
        [self enableEditing];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Cancel", @"Cancel");
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
//        self.navigationItem.rightBarButtonItem.
    } else {
        [self disableEditing];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
