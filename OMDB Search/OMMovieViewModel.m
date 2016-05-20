//
//  OMMovieViewModel.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "OMMovieViewModel.h"
#import "NSDictionary+OMParser.h"

@implementation OMMovieViewModel

- (instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    
    if (self) {
        _title = [data om_stringWithKey:@"Title"];
        _year = [data om_stringWithKey:@"Year"];
        _IMDBId = [data om_stringWithKey:@"imdbID"];
        
        NSString *posterURL = [data om_stringWithKey:@"Poster"];
        _posterURL = posterURL ? [NSURL URLWithString:posterURL] : nil;
    }
    
    return self;
}

- (void)updateWithFullData:(NSDictionary *)data
{
    if (_isFull || ![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    _isFull = YES;
    _director = [data om_stringWithKey:@"Director"];
    _writer = [data om_stringWithKey:@"Writer"];
    _actors = [data om_stringWithKey:@"Actors"];
    _awards = [data om_stringWithKey:@"Awards"];
    _country = [data om_stringWithKey:@"Country"];
    _genre = [data om_stringWithKey:@"Genre"];
    _plot = [data om_stringWithKey:@"Plot"];
}

- (NSString *)description
{
    return [[super description] stringByAppendingFormat:@" %@ (%@)", _title, _year];
}

@end
