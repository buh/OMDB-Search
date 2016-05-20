//
//  OMRequestManager.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "OMRequestManager.h"

NSString *const OMDBAPIURL = @"http://www.omdbapi.com";

@implementation OMRequestManager

+ (instancetype)backgroundSharedManager
{
    static OMRequestManager *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [self manager];
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        manager.operationQueue.maxConcurrentOperationCount = 4;
    });
    
    return manager;
}

@end
