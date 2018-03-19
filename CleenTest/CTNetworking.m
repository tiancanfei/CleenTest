//
//  CTNetworking.m
//  CleenTest
//
//  Created by bjwltiankong on 2018/3/19.
//  Copyright © 2018年 bjwltiankong. All rights reserved.
//

#import "CTNetworking.h"

static CTNetworking *_instance;

@interface CTNetworking()

@property (nonatomic, strong) AFURLSessionManager *sessionManager;

@end

@implementation CTNetworking

+ (instancetype)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)GET:(NSString *)url
     params:(NSDictionary *)params
    success:(void(^)(id response))success
    failure:(void(^)(NSError *error))failure
{
    AFURLSessionManager *sessionManager = self.sessionManager;
    
    AFHTTPRequestSerializer *requestManager = [AFHTTPRequestSerializer serializer];
    requestManager.timeoutInterval = 30;
    NSURLRequest *request = [requestManager requestWithMethod:@"GET" URLString:kCTRoot_Url parameters:nil error:nil];
    
    NSURLSessionDataTask *task = [sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error && failure)
        {
            failure(error);
            return ;
        }
        
        
        if (success) {
            success(responseObject);
        }
        
        
    }];
    
    [task resume];
}

#pragma mark - setter getter

- (AFURLSessionManager *)getCommonSessionManager
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForResource = 40;
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    return sessionManager;
}

- (AFURLSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [self getCommonSessionManager];
        AFJSONResponseSerializer * serializer = [AFJSONResponseSerializer serializer];
        serializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",nil];
        _sessionManager.responseSerializer = serializer;
    }
    return _sessionManager;
}


@end
