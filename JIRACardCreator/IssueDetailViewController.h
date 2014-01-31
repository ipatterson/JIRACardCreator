//
//  IssueDetailViewController.h
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/29/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectCard.h"

@interface IssueDetailViewController : UIViewController

//UI Elements

@property (retain, nonatomic) IBOutlet UIBarButtonItem *btnEditIssue;
@property (weak, nonatomic) IBOutlet UITextView *txtSummary;
@property (weak, nonatomic) IBOutlet UILabel *txtStatus;
@property (weak, nonatomic) IBOutlet UILabel *txtReporter;
@property (weak, nonatomic) IBOutlet UIImageView *imgReporter;
@property (weak, nonatomic) IBOutlet UILabel *txtAssignee;
@property (weak, nonatomic) IBOutlet UIImageView *imgAssignee;
@property (weak, nonatomic) IBOutlet UIButton *btnIssueType;
@property (weak, nonatomic) IBOutlet UIButton *btnStoryValue;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (weak, nonatomic) ProjectCard *project;

@end
