//
//  ProjectListViewController.h
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/24/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ProjectListViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *projectTableView;
@property (strong, nonatomic) NSMutableArray *projects;

- (void)prepareProjectList;

@end
