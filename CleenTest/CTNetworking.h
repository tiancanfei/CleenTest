//
//  CTNetworking.h
//  CleenTest
//
//  Created by bjwltiankong on 2018/3/19.
//  Copyright © 2018年 bjwltiankong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTNetworking : NSObject

- (void)GET:(NSString *)url
     params:(NSDictionary *)params
    success:(void(^)(id response))success
    failure:(void(^)(NSError *error))failure;

+ (instancetype)share;

@end
