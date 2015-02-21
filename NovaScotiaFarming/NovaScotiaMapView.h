//
//  NovaScotiaMapView.h
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/21/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@interface NovaScotiaMapView : MKMapView

@property (nonatomic, retain) NSManagedObjectContext *context;

- (void)loadAPolygon:(NSString*)type;

@end
