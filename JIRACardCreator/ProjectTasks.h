//
//  ProjectStatus.h
//  JIRACardCreator
/*
  A dictionary object that contains a list of tasks associated to a project.
  The tasks themselves are dictionaries that
  hold the name and color of statuses associated to them.
*/
//
//  Created by Ian Patterson on 1/30/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectTasks : NSObject


@property NSMutableDictionary *taskDictionary;
@property NSString *taskName; //Key
@property NSMutableDictionary *statusDictionary; //Value
// Key: "status"
@property NSString *statusName; // Value
// Key: "color"
@property NSString *statusColor; //Value

-(id) initDictionaryWithJSON:(NSArray *)data;
-(NSArray *)getAllTasks;

@end
