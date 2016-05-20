//
//  OMDetailRequest.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMMovieViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^OMDetailRequestCompletionBlock)(OMMovieViewModel *movieViewModel, NSError *_Nullable error);

@interface OMDetailRequest : NSObject

@property (nonatomic, readonly) OMMovieViewModel *movieViewModel;

- (instancetype)initWithMovieViewModel:(OMMovieViewModel *)movieViewModel
                       completionBlock:(OMDetailRequestCompletionBlock)completionBlock;

- (void)sendRequest;
- (void)cancel;

@end

NS_ASSUME_NONNULL_END