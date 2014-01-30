//
//  Request.m
//  JIRACardCreator
//
//  Created by Ian Patterson on 1/28/14.
//  Copyright (c) 2014 Catalyst IT Services. All rights reserved.
//

#import "Request.h"
#import <Foundation/Foundation.h>
#define SUCCESS ((int) 200)

@interface Request(){
    NSString *fragmentURL;
    HttpMethod methodType;
}

-(id)initRequestWithURLFragment:(NSString *)urlString andHttpMethod:(HttpMethod)httpMethod;
-(id)initProjectGetIssuesByProjectID:(NSString *)projectID;

@end

@implementation Request

@synthesize fragmentURL = _fragmentURL;
@synthesize request = _request;
@synthesize methodType = _methodType;

NSString *baseURL = @"https://catalystit.atlassian.net/rest/";

-(id)initRequestWithURLFragment:(NSString *)urlString andHttpMethod:(HttpMethod)httpMethod {
    self = [super init];
    
    //Build the full URL
    NSString *url = @"";
    url = [url stringByAppendingString:baseURL];
    url = [url stringByAppendingString:urlString];
    
    if(self) {
        NSURL *projectURL = [NSURL URLWithString:url];
        self.request = [NSMutableURLRequest requestWithURL:projectURL];
    
        [self.request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [self.request setHTTPMethod:[self httpMethodToString:httpMethod]];
    }
    
    return self;
}

-(id)initProjectGetIssuesByProjectID:(NSString *)projectID {
    //Build the URL fragment
    NSString *urlFragment = @"api/2/search?jql=project=";
    urlFragment = [urlFragment stringByAppendingString:projectID];
    
    return [self initRequestWithURLFragment:urlFragment andHttpMethod:GET];
}

-(void)setPostData:(NSData *)jsonData{
    [self.request setHTTPBody: jsonData];
}

-(NSString *)httpMethodToString:(HttpMethod)httpType {
    NSString *result = nil;
    
    switch(httpType) {
        case GET:
            result = @"GET";
            break;
        case POST:
            result = @"POST";
            break;
        case PUT:
            result = @"PUT";
            break;
        case DELETE:
            result = @"DELETE";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected Http Method."];
    }
    
    return result;
}

@end
