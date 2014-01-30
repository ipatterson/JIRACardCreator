//
//  ProjectCard.h
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/28/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectCard : NSObject

@property NSString *cardID;
@property NSString *cardName;
@property NSString *cardSummary;
@property NSString *cardCreatorAvatarURL;

@property NSMutableArray *cards;
@property NSMutableDictionary *issueDetails;

//Variables for Issue Details

@property NSString *cardDescription;
@property NSString *cardReporter;
@property NSString *cardReporterAvatarURL;
@property NSString *cardAssignee;
@property NSString *cardAssigneeAvatarURL;
@property NSString *cardIssueType;
@property NSString *cardStoryValue;

- (NSMutableArray *) createCardList:(NSArray *)dictionary;

@end
