//
//  ProjectListViewController.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/24/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "ProjectListViewController.h"
#import "Project.h"
#import "Request.h"
#import "ProjectCardsViewController.h"
#import <Foundation/Foundation.h>

@interface ProjectListViewController ()

@end

@implementation ProjectListViewController

@synthesize projects;
@synthesize projectTableView;

NSString *projectURL = @"api/2/project/";
NSString *selectedProjectURL;

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
    [super viewDidLoad];
    
    [self prepareProjectList];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)prepareProjectList{
    //Retrieve list of projects associated to User
    Request *projectRequest = [[Request alloc] initRequestWithURLFragment:projectURL andHttpMethod:GET];
        
    [NSURLConnection sendAsynchronousRequest:projectRequest.request queue:
     [[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
         NSArray *allProjects = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         if(allProjects){
             Project *projectObject = [[Project alloc] init];
             projects = [projectObject createProjectList:allProjects];
             
             //Fires off the updated table. Async call prevents lag between segue and tableView
             dispatch_async(dispatch_get_main_queue(), ^{
                 [projectTableView reloadData];
             });
         } else {
             //TODO: User has no Projects or Error
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [projects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProjectCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Project *project = projects[indexPath.row];
    cell.textLabel.text = [project projectName];
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - Navigation

// Get the URL from the selected Project and pass it to the Card List View.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"projectCardList"]){
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Project *selectedProject = projects[indexPath.row];

        ProjectCardsViewController *controller = (ProjectCardsViewController *)segue.destinationViewController;
        controller.projectID = selectedProject.projectID;
        controller.projectName = selectedProject.projectName;

    }
}

@end
