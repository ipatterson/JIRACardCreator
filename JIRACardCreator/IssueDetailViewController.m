//
//  IssueDetailViewController.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/29/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "IssueDetailViewController.h"
#import "ProjectCard.h"
#import "Request.h"
#import <UIKit/UIKit.h>

@interface IssueDetailViewController ()

@end

@implementation IssueDetailViewController

@synthesize btnEditIssue;
@synthesize issueTypePicker;
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
@synthesize projectTasks;
@synthesize lblRuler;
@synthesize lblStory;
@synthesize lblReporter;
@synthesize lblAssignee;
@synthesize btnSave;

NSString *selectedIssue;
int selectedIssueRow;
NSNumber *pointValue;

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
    [self setupButtons];
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
    
    [self.issueTypePicker setHidden:TRUE];
    [self.sliderStoryValue setHidden:TRUE];
    
    [self deactivatePicker];
    
    [self.btnSave setHidden:TRUE];
}

-(void)enableEditing{
    [self.txtSummary setEditable:YES];
    [self.txtSummary setTextColor:self.view.tintColor];
    [self.txtDescription setEditable:YES];
    [self.txtDescription setTextColor:self.view.tintColor];
    
    [self.btnIssueType setEnabled:YES];
    [self.btnStoryValue setEnabled:YES];
    
    [self.sliderStoryValue setHidden:FALSE];
    
    [self.btnSave setHidden:FALSE];
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
    [super setEditing:!editing animated:YES];
    
    if(!editing){
        [self enableEditing];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Cancel", @"Cancel");
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    } else {
        [self disableEditing];
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Edit", @"Edit");
        self.navigationItem.rightBarButtonItem.style = UIBarButtonItemStylePlain;
    }
    
}


- (void)setupButtons{
    
    btnEditIssue = self.editButtonItem;
    [btnEditIssue setTarget:self];
    [btnEditIssue setAction:@selector(toggleEdit)];
    self.navigationItem.rightBarButtonItem = btnEditIssue;
    [self disableEditing];
    
    [self.btnIssueType addTarget:self action:(@selector(activatePicker)) forControlEvents:UIControlEventTouchUpInside];
    [self.btnSave addTarget:self action:(@selector(saveChanges)) forControlEvents:UIControlEventTouchUpInside];
    [self.sliderStoryValue addTarget:self action:(@selector(changePoints)) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changePoints{
    int storyValue = ((int)(self.sliderStoryValue.value * 10)/10);
    [self.sliderStoryValue setValue:storyValue animated:NO];
    
    pointValue = [NSNumber numberWithInt:storyValue];
    [self updateStoryValueButtonValue:pointValue];
}

-(IBAction)saveChanges{
    
    NSString *issueURL = @"api/2/issue/";
    issueURL = [issueURL stringByAppendingString:[self.project cardID]];
    
    Request *postRequest = [[Request alloc] initRequestWithURLFragment:issueURL andHttpMethod:PUT];

    NSData *newData = [self createUpdateJson];
    
    [postRequest setPostData:newData];
    
    [NSURLConnection sendAsynchronousRequest:postRequest.request queue:
     [[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         NSArray *postResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         if([(NSHTTPURLResponse*)response statusCode] == 204){
             
             [self disableEditing];
         } else {
             //TODO: Error
             NSLog(@"What Happened?");
             NSLog(@"Results = %@", postResponse);
         }
     }];
    
    
}

-(NSData *)createUpdateJson{
    //TODO Implement Issue Type change
    NSString *summary = self.txtSummary.text;
    NSNumberFormatter *numberFormat = [[NSNumberFormatter alloc] init];
    [numberFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *storyValue = [numberFormat numberFromString:self.btnStoryValue.titleLabel.text];
    NSString *description = self.txtDescription.text;
    
    NSDictionary *testDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [[NSDictionary alloc] initWithObjectsAndKeys:
                                     summary, @"summary",
                                     description, @"description",
                                     storyValue, @"customfield_10004",
                                     nil], @"fields", nil];
    
    
//    NSDictionary *testDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                    [[NSDictionary alloc] initWithObjectsAndKeys:
//                                     summary, @"summary",
//                                     description, @"description",
//                                     storyValue, @"customfield_10004",
//                                     [[NSDictionary alloc] initWithObjectsAndKeys:
//                                      issueType, @"issuetype", nil], @"name",
//                                     nil], @"fields", nil];
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:testDictionary
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    
    return jsonData;
}

/*
 
 UI Picker Confingurations

*/

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [projectTasks count];
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    title = [projectTasks objectAtIndex:row];
    return [self utilRemoveQuotes:title];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    //Retain the selection choice.
    selectedIssue = [projectTasks objectAtIndex:row];
    selectedIssueRow = row;
    [self updateIssueTypeButtonText:[self utilRemoveQuotes:selectedIssue]];
    [self deactivatePicker];
}

- (void)activatePicker{
    // Establish a fade animation Hiding/Showing elements
    [UIView transitionWithView:self.view
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [self.txtAssignee setHidden:TRUE];
    [self.lblAssignee setHidden:TRUE];
    [self.imgAssignee setHidden:TRUE];
    [self.txtSummary setHidden:TRUE];
    [self.lblStory setHidden:TRUE];
    [self.btnStoryValue setHidden:TRUE];
    [self.sliderStoryValue setHidden:TRUE];
    [self.txtDescription setHidden:TRUE];
    [self.lblRuler setHidden:TRUE];
    [self.issueTypePicker setHidden:FALSE];
}

- (void)deactivatePicker {
    // Establish a fade animation Hiding/Showing elements
    [UIView transitionWithView:self.view
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:NULL
                    completion:NULL];
    [self.txtAssignee setHidden:FALSE];
    [self.lblAssignee setHidden:FALSE];
    [self.imgAssignee setHidden:FALSE];
    [self.txtSummary setHidden:FALSE];
    [self.lblStory setHidden:FALSE];
    [self.btnStoryValue setHidden:FALSE];
    [self.sliderStoryValue setHidden:FALSE];
    [self.txtDescription setHidden:FALSE];
    [self.lblRuler setHidden:FALSE];
    [self.issueTypePicker setHidden:TRUE];
}

- (NSString *)utilRemoveQuotes:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}

@end
