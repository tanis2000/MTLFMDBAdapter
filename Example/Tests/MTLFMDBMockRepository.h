//
//  MTLFMDBMockRepository.h
//  MTLFMDBAdapter
//
//  Created by Valerio Santinelli on 23/07/14.
//  Copyright (c) 2014 Valerio Santinelli. All rights reserved.
//

#import "MTLModel.h"
#import <Mantle/Mantle.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

@interface MTLFMDBMockRepository : MTLModel<MTLFMDBSerializing>

@property (nonatomic, copy) NSString *guid;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *unused;

@end
