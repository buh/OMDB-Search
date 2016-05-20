//
//  OMMovieViewModel.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OMMovieViewModel : NSObject

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSURL *posterURL;
@property (nonatomic, readonly) NSString *year;
@property (nonatomic, readonly) NSString *IMDBId;
@property (nonatomic, readonly) NSString *director;
@property (nonatomic, readonly) NSString *writer;
@property (nonatomic, readonly) NSString *actors;
@property (nonatomic, readonly) NSString *awards;
@property (nonatomic, readonly) NSString *country;
@property (nonatomic, readonly) NSString *genre;
@property (nonatomic, readonly) NSString *plot;

@property (nonatomic, readonly) BOOL isFull;

- (instancetype)initWithData:(NSDictionary *)data;

- (void)updateWithFullData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END