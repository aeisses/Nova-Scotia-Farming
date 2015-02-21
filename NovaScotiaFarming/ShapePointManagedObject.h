//
//  ShapePointManagedObject.h
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/20/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "SoilSectionManagedObject.h"

@interface ShapePointManagedObject : NSManagedObject

@property (nonatomic, strong) NSDecimalNumber *longitude;
@property (nonatomic, strong) NSDecimalNumber *latitude;
@property (nonatomic, strong) SoilSectionManagedObject *soilSection;

@end
