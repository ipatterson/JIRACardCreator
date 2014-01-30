//
//  ProjectCard.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/28/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "ProjectCard.h"

static NSMutableArray *cards;
static NSMutableDictionary *issueDetails;

@implementation ProjectCard

-(id) init:(NSDictionary *)card {
    self = [super init];
    
    if(self) {
        
        
        issueDetails = [[NSMutableDictionary alloc] initWithDictionary:[card valueForKey:@"fields"]];
        
        self.cardID = (NSString *)[card objectForKey:@"id"];
        self.cardName = (NSString *)[card objectForKey:@"key"];
        
        self.cardSummary = (NSString *)[issueDetails objectForKey:@"summary"];
        self.cardCreatorAvatarURL = (NSString *)[(NSDictionary *)
                                                 [(NSDictionary *)
                                                  [issueDetails objectForKey:@"creator"]
                                                  objectForKey:@"avatarUrls"]
                                                 objectForKey:@"48x48"];
        
        //Assign Issue Detail variables
        self.cardDescription =
        self.cardReporter = (NSString *)[(NSDictionary *)
                                         [issueDetails objectForKey:@"reporter"] objectForKey:@"displayName"];
        self.cardReporterAvatarURL = (NSString *)[(NSDictionary *)
                                            [(NSDictionary *)
                                             [issueDetails objectForKey:@"reporter"]
                                             objectForKey:@"avatarUrls"]
                                            objectForKey:@"24x24"];
        self.cardAssignee = (NSString *)[(NSDictionary *)
                                         [issueDetails objectForKey:@"assignee"] objectForKey:@"displayName"];
        self.cardAssigneeAvatarURL = (NSString *)[(NSDictionary *)
                                            [(NSDictionary *)
                                             [issueDetails objectForKey:@"assignee"]
                                             objectForKey:@"avatarUrls"]
                                            objectForKey:@"24x24"];
    }
    
    return self;
}

//Create a retained list of Cards from the issueTypes key of the JSON.
-(NSMutableArray *) createCardList:(NSArray *)dictionary {
    
    NSMutableArray *issues = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"issues"]];

    cards = [[NSMutableArray alloc] init];

    for (NSDictionary *card in issues){
        ProjectCard *projectCard = [[ProjectCard alloc] init:card];
        [cards addObject:projectCard];
    }
    
    return cards;
}

@end
