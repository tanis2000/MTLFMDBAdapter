//
//  MTLFMDBAdapterTests.m
//  MTLFMDBAdapterTests
//
//  Created by Valerio Santinelli on 07/22/2014.
//  Copyright (c) 2014 Valerio Santinelli. All rights reserved.
//

#import <FMDB/FMDB.h>
#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#import "MTLFMDBMockUser.h"
#import "MTLFMDBMockRepository.h"

FMDatabase *db;

SpecBegin(InitialSpecs)

describe(@"main tests", ^{
    beforeEach(^{
        // Grab the Documents folder
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        // Sets the database filename
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MTLFMDBTests.sqlite"];
        
        // Tell FMDB where the database is
        db = [FMDatabase databaseWithPath:filePath];
        [db open];

        [db executeUpdate:@"drop table if exists user"];
        [db executeUpdate:@"drop table if exists repository"];

        [db executeUpdate:@"create table if not exists user "
         "(guid text primary key, name text, age integer, lastupdateat date)"];
        [db executeUpdate:@"create table if not exists repository "
         "(guid text primary key, url text, repo_description text)"];

    });
    
    afterEach(^{
        [db close];
    });
    
    it(@"can convert from MTLModel to INSERT statement", ^{
        MTLFMDBMockUser *user = [[MTLFMDBMockUser alloc] init];
        user.guid = @"myuniqueid";
        user.name = @"John Doe";
        user.age = [NSNumber numberWithInt:42];
        
        NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
        expect(stmt).to.equal(@"insert into user (age, guid, lastupdateat, name) values (?, ?, ?, ?)");
    });

    it(@"can convert from MTLModel to UPDATE statement", ^{
        MTLFMDBMockUser *user = [[MTLFMDBMockUser alloc] init];
        user.guid = @"myuniqueid";
        user.name = @"John Doe";
        user.age = [NSNumber numberWithInt:42];
        
        NSString *stmt = [MTLFMDBAdapter updateStatementForModel:user];
        expect(stmt).to.equal(@"update user set age = ?, guid = ?, lastupdateat = ?, name = ? where guid = ?");
    });

    it(@"can convert from MTLModel to DELETE statement", ^{
        MTLFMDBMockUser *user = [[MTLFMDBMockUser alloc] init];
        user.guid = @"myuniqueid";
        user.name = @"John Doe";
        user.age = [NSNumber numberWithInt:42];
        
        NSString *stmt = [MTLFMDBAdapter deleteStatementForModel:user];
        expect(stmt).to.equal(@"delete from user where guid = ?");
    });

    it(@"can convert from FMResultSet to MTLModel", ^{
        MTLFMDBMockUser *resultUser = nil;
        MTLFMDBMockUser *user = [[MTLFMDBMockUser alloc] init];
        user.guid = @"myuniqueid";
        user.name = @"John Doe";
        user.age = [NSNumber numberWithInt:42];
        
        NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
        NSArray *params = [MTLFMDBAdapter columnValues:user];
        [db executeUpdate:stmt withArgumentsInArray:params];
        
        NSError *error = nil;
        FMResultSet *resultSet = [db executeQuery:@"select * from user"];
        if ([resultSet next]) {
            resultUser = [MTLFMDBAdapter modelOfClass:MTLFMDBMockUser.class fromFMResultSet:resultSet error:&error];
        }
        expect(resultUser.name).to.equal(@"John Doe");
    });

    it(@"empty number from FMResultSet converts to nil in MTLModel", ^{
        MTLFMDBMockUser *resultUser = nil;
        MTLFMDBMockUser *user = [[MTLFMDBMockUser alloc] init];
        user.age = nil;
        
        NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
        NSArray *params = [MTLFMDBAdapter columnValues:user];
        [db executeUpdate:stmt withArgumentsInArray:params];
        
        NSError *error = nil;
        FMResultSet *resultSet = [db executeQuery:@"select * from user"];
        if ([resultSet next]) {
            resultUser = [MTLFMDBAdapter modelOfClass:MTLFMDBMockUser.class fromFMResultSet:resultSet error:&error];
        }
        expect(resultUser.age).to.equal(nil);
    });
    
    it(@"number from FMResultSet converts to number in MTLModel", ^{
        MTLFMDBMockUser *resultUser = nil;
        MTLFMDBMockUser *user = [[MTLFMDBMockUser alloc] init];
        user.age = @(42);
        
        NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
        NSArray *params = [MTLFMDBAdapter columnValues:user];
        [db executeUpdate:stmt withArgumentsInArray:params];
        
        NSError *error = nil;
        FMResultSet *resultSet = [db executeQuery:@"select * from user"];
        if ([resultSet next]) {
            resultUser = [MTLFMDBAdapter modelOfClass:MTLFMDBMockUser.class fromFMResultSet:resultSet error:&error];
        }
        expect(resultUser.age).to.equal(@(42));
    });
  
  it(@"can use the correct column names from the mapping", ^{
    MTLFMDBMockRepository *repo = [[MTLFMDBMockRepository alloc] init];
    repo.guid = @"myuniqueid";
    repo.url = @"https://github.com/tanis2000/MTLFMDBAdapter";
    repo.desc = @"Mantle adapter for FMDB";
    
    NSString *stmt = [MTLFMDBAdapter insertStatementForModel:repo];
    NSArray *params = [MTLFMDBAdapter columnValues:repo];
    [db executeUpdate:stmt withArgumentsInArray:params];
    
    NSError *error = nil;
    FMResultSet *resultSet = [db executeQuery:@"select * from repository"];
    if ([resultSet next]) {
      repo = [MTLFMDBAdapter modelOfClass:MTLFMDBMockRepository.class fromFMResultSet:resultSet error:&error];
    }
    expect(repo.desc).to.equal(@"Mantle adapter for FMDB");
  });

  it(@"can serialize an NSDate to string on db and back", ^{
    MTLFMDBMockUser *user = [[MTLFMDBMockUser alloc] init];
    user.guid = @"myuniqueid";
    user.name = @"John Doe";
    user.age = [NSNumber numberWithInt:42];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    NSDate *originalDate = [dateFormatter dateFromString:@"2016-12-08T19:42:00Z"];
    user.lastupdateat = originalDate;
    NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
    NSArray *params = [MTLFMDBAdapter columnValues:user];
    [db executeUpdate:stmt withArgumentsInArray:params];
    
    NSError *error = nil;
    FMResultSet *resultSet = [db executeQuery:@"select * from user"];
    if ([resultSet next]) {
      user = [MTLFMDBAdapter modelOfClass:MTLFMDBMockUser.class fromFMResultSet:resultSet error:&error];
    }
    expect(user.lastupdateat).to.equal(originalDate);
  });

});


SpecEnd
