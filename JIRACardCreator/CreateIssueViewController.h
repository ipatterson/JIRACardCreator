//
//  CreateIssueViewController.h
//  JIRACardCreator
//
//  Created by Ian Patterson on 2/3/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateIssueViewController : UIViewController
- (IBAction)dismissView:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end
