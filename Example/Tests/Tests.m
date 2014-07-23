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
         "(guid text primary key, name text, age integer)"];
        [db executeUpdate:@"create table if not exists repository "
         "(guid text primary key, url text)"];

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
        expect(stmt).to.equal(@"insert into user (age, name, guid) values (?, ?, ?)");
    });

    it(@"can convert from MTLModel to UPDATE statement", ^{
        MTLFMDBMockUser *user = [[MTLFMDBMockUser alloc] init];
        user.guid = @"myuniqueid";
        user.name = @"John Doe";
        user.age = [NSNumber numberWithInt:42];
        
        NSString *stmt = [MTLFMDBAdapter updateStatementForModel:user];
        expect(stmt).to.equal(@"update user set age = ?, name = ?, guid = ? where guid = ?");
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

});


SpecEnd
