//
//  NSArray+OMParser.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "NSArray+OMParser.h"

@implementation NSArray (OMParser)

- (NSDictionary *)om_dictionaryAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        NSDictionary *data = self[index];
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            return data;
        }
    }
    
    return nil;
}

@end
