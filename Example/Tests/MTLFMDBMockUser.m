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
             @"repositories": [NSNull null],
             @"lastupdateat": @"lastupdateat"
             };
}

+ (NSArray *)FMDBPrimaryKeys
{
    return @[@"guid"];
}

+ (NSString *)FMDBTableName {
    return @"user";
}

+ (NSDateFormatter *)dateFormatter {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
  return dateFormatter;
}

+ (NSValueTransformer *)lastupdateatFMDBTransformer {
  return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
    // If we were storing dates as Unix epoch, we'd use the following commented statements
    //NSTimeInterval interval = [dateString longLongValue];
    //return [NSDate dateWithTimeIntervalSince1970: interval];
    return [self.dateFormatter dateFromString:dateString];
  } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
    return [self.dateFormatter stringFromDate:date];
  }];
}
@end
