//
//  NSArray+OMParser.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (OMParser)

- (NSDictionary *)om_dictionaryAtIndex:(NSUInteger)index;

@end
