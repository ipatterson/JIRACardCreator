//
//  Project.h
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/24/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Project : NSObject

@property NSString *projectID;
@property NSString *projectName;
@property NSString *projectKey;
@property NSMutableArray *projects;

- (NSMutableArray *) createProjectList:(NSArray *)dictionary;

@end
