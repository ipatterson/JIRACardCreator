//
//  Request.h
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/28/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Request : NSObject

typedef enum httpMethods{
    GET,
    POST,
    PUT,
    DELETE
}HttpMethod;

@property (nonatomic) NSString *fragmentURL;
@property HttpMethod methodType;
@property (nonatomic, strong) NSMutableURLRequest *request;

-(NSString *)httpMethodToString:(HttpMethod)httpMethod;

-(id)initRequestWithURLFragment:(NSString *)urlString andHttpMethod:(HttpMethod)httpMethod;
-(id)initProjectGetIssuesByProjectID:(NSString *)projectID;

-(void)setPostData:(NSData *)jsonData;

@end
