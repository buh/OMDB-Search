//
//  OMSearchRequest.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMMovieViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^OMSearchRequestCompletionBlock)(NSArray <OMMovieViewModel *> *_Nullable results,
                                              NSUInteger page,
                                              NSError *_Nullable error);

@interface OMSearchRequest : NSObject

@property (nonatomic, readonly) NSString *searchText;
@property (readonly) NSArray <OMMovieViewModel *> *results;
@property (nonatomic, readonly) NSUInteger page;
@property (nonatomic, readonly) NSUInteger total;
@property (nonatomic, readwrite) BOOL hasMore;

- (instancetype)initWithSearchText:(NSString *)searchText completionBlock:(OMSearchRequestCompletionBlock)completionBlock;

- (void)search;
- (void)loadNextPage;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END