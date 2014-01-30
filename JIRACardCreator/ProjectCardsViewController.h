//
//  ProjectCardsViewController.h
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/28/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ProjectCardsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *cardTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnAddIssue;
@property (weak, nonatomic) NSMutableArray *cards;
@property (weak, nonatomic) NSString *projectID;
@property (weak, nonatomic) NSString *projectName;

-(void)prepareCardList;

@end
