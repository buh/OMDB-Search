//
//  NSString+OMSearch.m
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import "NSString+OMSearch.h"

@implementation NSString (OMSearch)

- (instancetype)om_searchText
{
    return [[self lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
