//
//  ProjectStatus.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/30/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "ProjectTasks.h"

static NSMutableDictionary *taskDictionary;

@implementation ProjectTasks

-(id)initDictionaryWithJSON:(NSArray *)data{
    
    self = [super init];
    self.taskDictionary = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *taskItem in data){
        //Create a Dictionary of Statuses associated to the task
        
        NSString *taskName = [taskItem objectForKey:@"name"];
        NSDictionary *statusDictionary = [self createStatusDictionary:[taskItem objectForKey:@"statuses"]];
        
        [self.taskDictionary setValue:statusDictionary forKey:taskName];
    }
    
    return self;
}

-(NSMutableDictionary *)createStatusDictionary:(NSDictionary *)data{
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    
    for(NSDictionary *status in data){
        //[results setValue:[status objectForKey:@"name"] forKey:@"status"];
        [results setValue:[(NSDictionary *)[status objectForKey:@"statusCategory"] objectForKey:@"colorName"] forKey:[status objectForKey:@"name"]];
        
    }
    return results;
}

-(NSArray *)getAllTasks{    
    return [[self.taskDictionary keyEnumerator] allObjects];
}

@end
