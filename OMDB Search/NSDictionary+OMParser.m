//
//  NSDictionary+OMParser.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "NSDictionary+OMParser.h"

@implementation NSDictionary (OMParser)

- (instancetype)om_dictionaryWithKey:(NSString *)key
{
    NSDictionary *data = self[key];
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        return data;
    }
    
    return nil;
}

- (NSArray *)om_arrayWithKey:(NSString *)key
{
    NSArray *data = self[key];
    
    if ([data isKindOfClass:[NSArray class]]) {
        return data;
    }
    
    return nil;
}

- (NSString *)om_stringWithKey:(NSString *)key
{
    NSString *data = self[key];
    
    if ([data isKindOfClass:[NSString class]]) {
        return data;
    }
    
    return nil;
}

@end
