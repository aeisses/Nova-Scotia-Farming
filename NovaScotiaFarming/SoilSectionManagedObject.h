//
//  SoilSectionManagedObject.h
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/20/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface SoilSectionManagedObject : NSManagedObject

@property (nonatomic, assign) NSNumber *waterarea;
@property (nonatomic, assign) NSNumber *soilid;
@property (nonatomic, assign) NSNumber *objectid;
@property (nonatomic, assign) NSNumber *landarea;
@property (nonatomic, retain) NSDecimalNumber *shapelength;
@property (nonatomic, retain) NSDecimalNumber *shapearea;
@property (nonatomic, retain) NSString *mapunit;
@property (nonatomic, retain) NSOrderedSet *shapePoints;

@end
