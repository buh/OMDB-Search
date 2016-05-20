//
//  OMRequestManager.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

FOUNDATION_EXTERN NSString *const OMDBAPIURL;

@interface OMRequestManager : AFHTTPSessionManager

+ (instancetype)backgroundSharedManager;

@end
