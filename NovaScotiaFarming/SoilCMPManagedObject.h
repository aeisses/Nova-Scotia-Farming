//
//  SoilCMPManagedObject.h
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/21/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@interface SoilCMPManagedObject : NSManagedObject

@property (nonatomic, strong) NSString *soiltype;
@property (nonatomic, strong) NSString *mapunit;

@end
