//
//  OMDetailRequest.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "OMDetailRequest.h"
#import "OMRequestManager.h"
#import "OMMacros.h"
#import "NSDictionary+OMParser.h"

@interface OMDetailRequest ()

@property (nonatomic) OMDetailRequestCompletionBlock completionBlock;
@property (nonatomic) NSURLSessionDataTask *sessionDataTask;

@end

@implementation OMDetailRequest

- (instancetype)initWithMovieViewModel:(OMMovieViewModel *)movieViewModel completionBlock:(OMDetailRequestCompletionBlock)completionBlock
{
    NSAssert(completionBlock, @"OMDetailRequest requires completionBlock");
    
    self = [super init];
    
    if (self) {
        _movieViewModel = movieViewModel;
        _completionBlock = [completionBlock copy];
    }
    
    return self;
}

- (void)sendRequest
{
    if (_sessionDataTask || _movieViewModel.isFull) {
        [self finishRequestWithError:nil];
        
        return;
    }
    
    OMWeakSelf;
    _sessionDataTask = [[OMRequestManager backgroundSharedManager]
                        GET:OMDBAPIURL
                        parameters:@{ @"i":_movieViewModel.IMDBId,
                                      @"plot":@"full",
                                      @"r":@"json" }
                        progress:NULL
                        success:^(NSURLSessionDataTask *task, id responseObject) {
                            OMStrongSelf;
                            [strongSelf parseResponseWithData:responseObject];
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            OMStrongSelf;
                            [strongSelf finishRequestWithError:error];
                        }];
}

- (void)cancel
{
    [_sessionDataTask cancel];
}

- (void)parseResponseWithData:(NSDictionary *)data
{
    if ([data isKindOfClass:[NSDictionary class]] && ![data om_stringWithKey:@"Error"]) {
        [_movieViewModel updateWithFullData:data];
    }
    
    [self finishRequestWithError:nil];
}

- (void)finishRequestWithError:(NSError *)error
{
    _sessionDataTask = nil;
    
    if ([NSThread isMainThread]) {
        _completionBlock(_movieViewModel, error);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _completionBlock(_movieViewModel, error);
        });
    }
}

@end
