//
//  OMSearchRequest.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "OMSearchRequest.h"
#import "OMRequestManager.h"
#import "OMMacros.h"
#import "NSDictionary+OMParser.h"

@interface OMSearchRequest ()

@property (readwrite) NSArray <OMMovieViewModel *> *results;
@property (nonatomic, copy) OMSearchRequestCompletionBlock completionBlock;
@property (nonatomic) NSURLSessionDataTask *sessionDataTask;

@end

@implementation OMSearchRequest

- (instancetype)initWithSearchText:(NSString *)searchText completionBlock:(OMSearchRequestCompletionBlock)completionBlock
{
    NSAssert(completionBlock, @"OMSearchRequest requires completionBlock");
    
    self = [super init];
    
    if (self) {
        _completionBlock = [completionBlock copy];
        _page = 1;
        _total = 0;
        _results = @[];
        _searchText = [searchText copy];
    }
    
    return self;
}

- (BOOL)hasMore
{
    return _total > 0 && _total > _results.count;
}

- (void)search
{
    if (_sessionDataTask || _results.count) {
        if (!_sessionDataTask) {
            [self finishRequestWithError:nil];
        }
        
        return;
    }
    
    [self loadNextPage];
}

- (void)loadNextPage
{
    if (!_sessionDataTask && (_total == 0 || self.hasMore)) {
        
        OMWeakSelf;
        _sessionDataTask = [[OMRequestManager backgroundSharedManager]
                            GET:OMDBAPIURL
                            parameters:@{ @"s":_searchText, @"page":@(_page) }
                            progress:NULL
                            success:^(NSURLSessionDataTask *task, id responseObject) {
                                OMStrongSelf;
                                [strongSelf parseResponseWithData:responseObject];
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                OMStrongSelf;
                                [strongSelf finishRequestWithError:error];
                            }];
        
    } else if (!_sessionDataTask) {
        [self finishRequestWithError:nil];
    }
}

- (void)cancel
{
    [_sessionDataTask cancel];
}

- (void)parseResponseWithData:(NSDictionary *)data
{
    if (![data isKindOfClass:[NSDictionary class]]) {
        // TODO: Response error.
        [self finishRequestWithError:nil];
        
        return;
    }
    
    NSInteger total = [[data om_stringWithKey:@"totalResults"] integerValue];
    
    if (total > 0) {
        _page++;
        _total = total;
        NSArray *resultsData = [data om_arrayWithKey:@"Search"];
        
        NSMutableArray *results = [NSMutableArray arrayWithArray:_results];
        
        for (NSDictionary *itemData in resultsData) {
            if ([itemData isKindOfClass:[NSDictionary class]]) {
                [results addObject:[[OMMovieViewModel alloc] initWithData:itemData]];
            }
        }
        
        self.results = [results copy];
    }
    
    [self finishRequestWithError:nil];
}

- (void)finishRequestWithError:(NSError *)error
{
    _sessionDataTask = nil;
    
    if ([NSThread isMainThread]) {
        _completionBlock(_results, _page, error);
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            _completionBlock(_results, _page, error);
        });
    }
}

@end
