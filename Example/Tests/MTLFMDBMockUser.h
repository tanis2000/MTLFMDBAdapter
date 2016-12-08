//
//  MTLFMDBMockUser.h
//  MTLFMDBAdapter
//
//  Created by Valerio Santinelli on 23/07/14.
//  Copyright (c) 2014 Valerio Santinelli. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface MTLFMDBMockUser : MTLModel<MTLFMDBSerializing>

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *age;
@property (nonatomic, copy) NSSet *repositories;
@property (nonatomic, copy) NSDate *lastupdateat;

@end
