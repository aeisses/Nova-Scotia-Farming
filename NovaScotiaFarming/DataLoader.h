//
//  DataLoader.h
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/20/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@interface DataLoader : NSObject

- (id)init;
+ (id)sharedInstance;
- (void)loadGMLData;
- (void)loadGMLDataKey;
- (void)loadCMPData;
- (void)loadSoilType;

@end
