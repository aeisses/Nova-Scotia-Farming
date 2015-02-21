//
//  SoilTypeManagedObject.h
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/21/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface SoilTypeManagedObject : NSManagedObject

@property (nonatomic, strong) NSString *soiltype;
@property (nonatomic, strong) NSString *soilname;
@property (nonatomic, strong) NSNumber *objectid;
@property (nonatomic, strong) NSNumber *geoid;

@end
