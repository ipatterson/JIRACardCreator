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

@interface ProjectCardsViewController ()

@end

@implementation ProjectCardsViewController

@synthesize cards;
@synthesize cardTableView;
@synthesize btnAddIssue;
@synthesize projectID;
@synthesize projectName;

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
    
    NSURL *imageURL = [NSURL URLWithString:[projectCard cardCreatorAvatarURL]];
    
    //Async call to download image avatars
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = [UIImage imageWithData:imageData];
            NSLog(@"Image Added?");
        });
    });
    
    return cell;
}

-(void)prepareCardList{
    
    //Retrieve the JIRA cards associated to the project
    Request *projectRequest = [[Request alloc] initProjectGetIssuesByProjectID:projectID];
    
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
