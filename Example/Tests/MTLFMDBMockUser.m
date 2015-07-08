//
//  MTLFMDBMockUser.m
//  MTLFMDBAdapter
//
//  Created by Valerio Santinelli on 23/07/14.
//  Copyright (c) 2014 Valerio Santinelli. All rights reserved.
//

#import "MTLFMDBMockUser.h"

@implementation MTLFMDBMockUser

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"guid": @"guid",
             @"age": @"age",
             @"birthday": @"birthday",
             @"banned": @"banned",
             @"repositories": [NSNull null],
             };
}

+ (NSArray *)FMDBPrimaryKeys
{
    return @[@"guid"];
}

+ (NSString *)FMDBTableName {
    return @"user";
}

@end
