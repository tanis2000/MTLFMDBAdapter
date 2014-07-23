# MTLFMDBAdapter

[![CI Status](http://img.shields.io/travis/tanis2000/MTLFMDBAdapter.svg?style=flat)](https://travis-ci.org/tanis2000/MTLFMDBAdapter)
[![Version](https://img.shields.io/cocoapods/v/MTLFMDBAdapter.svg?style=flat)](http://cocoadocs.org/docsets/MTLFMDBAdapter)
[![License](https://img.shields.io/cocoapods/l/MTLFMDBAdapter.svg?style=flat)](http://cocoadocs.org/docsets/MTLFMDBAdapter)
[![Platform](https://img.shields.io/cocoapods/p/MTLFMDBAdapter.svg?style=flat)](http://cocoadocs.org/docsets/MTLFMDBAdapter)

**MTLFMDBAdapter** is a Mantle adapter that can serialize to and from FMDB (SQLite).
What this all boils down to is being able to create an MTLModel instance by feeding an FMResultSet and vice versa create the INSERT/UPDATE/DELETE statements to store the object in FMDB.

## Why?

I have been using Core Data and RestKit for in many commercial projects but I've never been satisfied with the results. Core Data is slow and it's hard to get right when working with different threads. RestKit is great and it works fine with RESTful services but it's not good when you need to talk to web services that do not adhere to the REST protocol or that diverge in some way. So this has become the base for my own web service to object model mapping. I adopted Mantle as it's got all the features I need and it works way better than what I originally coded, so it was kind of natural to add it to my toolbelt. 
I also love to work directly with SQL statements and SQLite has always been my solution of choice for new projects. FMDB is a thin layer of code on top of SQLite that simplifies common tasks like managing threads (queues).
This adapter fills the gap between Mantle and FMDB. 

Contributions and Pull Requests are welcome!

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Defining a model

A model can be defined using the standard Mantle way. To add support for FMDB serialization you have to add the `<MTLFMDBSerializing>` protocol.

	#import "MTLModel.h"
	#import <Mantle/Mantle.h>
	#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

	@interface MTLFMDBMockUser : MTLModel<MTLFMDBSerializing>

	@property (nonatomic, copy) NSString *guid;
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, copy) NSNumber *age;
	@property (nonatomic, copy) NSSet *repositories;

	@end

`<MTLFMDBSerializing>` requires a few methods to be implemented in your model's code.

	#import "MTLFMDBMockUser.h"

	@implementation MTLFMDBMockUser

	+ (NSDictionary *)FMDBColumnsByPropertyKey
	{
	    return @{
	             @"guid": @"guid",
	             @"name": @"name",
	             @"age": @"age",
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

### Getting the INSERT statement for a model

	NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];

If `user` is an instance of the `MTLFMDBMockUser` class we defined up there, the result will be

	insert into user (age, name, guid) values (?, ?, ?)

## Requirements

MTLFMDBAdapter requires [Mantle](https://github.com/Mantle/Mantle) as a dependency.

## Installation

MTLFMDBAdapter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MTLFMDBAdapter"

## Author

Valerio Santinelli, santinelli@altralogica.it

## License

MTLFMDBAdapter is available under the MIT license. See the LICENSE file for more info.

