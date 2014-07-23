//
//  MTLFMDBMockRepository.m
//  MTLFMDBAdapter
//
//  Created by Valerio Santinelli on 23/07/14.
//  Copyright (c) 2014 Valerio Santinelli. All rights reserved.
//

#import "MTLFMDBMockRepository.h"

@implementation MTLFMDBMockRepository

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"guid": @"guid",
             @"url": @"url",
             };
}

+ (NSArray *)FMDBPrimaryKeys
{
    return @[@"guid"];
}

+ (NSString *)FMDBTableName {
    return @"repository";
}

@end
