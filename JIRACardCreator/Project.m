//
//  Project.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/24/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "Project.h"

static NSMutableArray *projects;

@implementation Project

-(id) init:(NSDictionary *)item {
    self = [super init];
    
    if(self) {
        self.projectID = (NSString *)[item objectForKey:@"id"];
        self.projectName = (NSString *)[item objectForKey:@"name"];
        self.projectKey = (NSString *)[item objectForKey:@"key"];
    }
    
    return self;
}

//Create a retained list of Projects from a provided Array.
-(NSMutableArray *) createProjectList:(NSArray *)dictionary {
    
    projects = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in dictionary){
        Project *project = [[Project alloc] init:item];
        [projects addObject:project];
    }
    
    return projects;
}
@end