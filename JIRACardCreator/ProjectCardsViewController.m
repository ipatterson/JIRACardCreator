//
//  ProjectCardsViewController.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/28/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "ProjectCardsViewController.h"
#import "Request.h"
#import "ProjectCard.h"
#import "ProjectTasks.h"
#import "IssueDetailViewController.h"

@interface ProjectCardsViewController ()

@end

@implementation ProjectCardsViewController

@synthesize cards;
@synthesize statuses;
@synthesize tasks;
@synthesize cardTableView;
@synthesize btnAddIssue;
@synthesize projectID;
@synthesize projectName;

NSArray *taskList;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.title = self.projectName;

    [self prepareCardList];
    
    [super viewDidLoad];
    
    [self getTaskList];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [cards count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    ProjectCard *projectCard = cards[indexPath.row];
    cell.textLabel.text = [projectCard cardName];
    cell.detailTextLabel.text = [projectCard cardSummary];
        
    return cell;
}

-(void)prepareCardList{
    
    //Retrieve the JIRA cards associated to the project
    Request *projectRequest = [[Request alloc] initRequestGetIssuesByProjectID:projectID];
    
    [NSURLConnection sendAsynchronousRequest:projectRequest.request queue:
     [[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         if(results){
             ProjectCard *allCards = [[ProjectCard alloc] init];
             cards = [allCards createCardList:results];
             
             //Fires off the updated table. Async call prevents lag between segue and tableView
             dispatch_async(dispatch_get_main_queue(), ^{
                 [cardTableView reloadData];
             });
         } else {
             //TODO: User has no Cards or Error
         }
     }];
}

-(void)getTaskList{
    //Retrieve the JIRA cards associated to the project
    Request *taskRequest = [[Request alloc] initRequestGetProjectStatusesByProjectID:projectID];
    
    __block ProjectTasks *taskDictionary;
    
    [NSURLConnection sendAsynchronousRequest:taskRequest.request queue:
     [[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         if(results){
             taskDictionary = [[ProjectTasks alloc] initDictionaryWithJSON:results];
             taskList = [taskDictionary getAllTasks];
         } else {
             //TODO: No tasks found
         }
     }];
}

//Set the Title of each Grouped Section
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    // set title of section here
    return [statuses objectAtIndex:section];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"issueDetails"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ProjectCard *selectedCard = cards[indexPath.row];
        
        IssueDetailViewController *controller = (IssueDetailViewController *)segue.destinationViewController;
        controller.project = selectedCard;
        controller.projectTasks = taskList;
    }
}


@end
