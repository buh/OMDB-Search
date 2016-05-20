//
//  NSDictionary+OMParser.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 16.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (OMParser)

- (instancetype)om_dictionaryWithKey:(NSString *)key;
- (NSArray *)om_arrayWithKey:(NSString *)key;
- (NSString *)om_stringWithKey:(NSString *)key;

@end
