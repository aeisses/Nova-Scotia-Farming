//
//  NovaScotiaMapView.m
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/21/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import "NovaScotiaMapView.h"
#import "SoilSectionManagedObject.h"
#import "ShapePointManagedObject.h"
#import "SoilCMPManagedObject.h"
#import "SoilTypeManagedObject.h"
#import "NSPolygon.h"

@interface NovaScotiaMapView()

@end

@implementation NovaScotiaMapView

@synthesize context = _context;

- (void)loadAPolygon:(NSString*)type {
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    dispatch_async(dispatch_get_main_queue(), ^{
      [self removeOverlays:self.overlays];
    });
    
    NSEntityDescription *soilTypeEntity = [NSEntityDescription entityForName:@"SoilType" inManagedObjectContext:_context];
    NSFetchRequest *soilTypeFetchRequest = [[NSFetchRequest alloc] init];
    if (![type isEqualToString:@"All"]) {
      soilTypeFetchRequest.predicate = [NSPredicate predicateWithFormat:@"soilname like %@",type];
    }
    soilTypeFetchRequest.entity = soilTypeEntity;
    NSArray *soilTypes = [_context executeFetchRequest:soilTypeFetchRequest error:nil];
    if ([soilTypes count]) {
      for (SoilTypeManagedObject *soilType in soilTypes) {
        NSEntityDescription *checkEntity = [NSEntityDescription entityForName:@"SoilCMP" inManagedObjectContext:_context];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"soiltype like %@",soilType.soiltype];
        fetchRequest.entity = checkEntity;
        NSArray *fetchObject = [_context executeFetchRequest:fetchRequest error:nil];
        if ([fetchObject count]) {
          for (SoilCMPManagedObject *soilCMP in fetchObject) {
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"SoilSection" inManagedObjectContext:_context];
            NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
            fetchRequest2.predicate = [NSPredicate predicateWithFormat:@"mapunit like %@",soilCMP.mapunit];
            fetchRequest2.entity = entity;
            NSArray *fetchObject2 = [_context executeFetchRequest:fetchRequest2 error:nil];
            NSMutableArray *overLays = [NSMutableArray new];
            if ([fetchObject2 count]) {
              for (SoilSectionManagedObject *soilSection in fetchObject2) {
                CLLocationCoordinate2D polygon[[soilSection.shapePoints count]];
                int count = 0;
                for (ShapePointManagedObject *shape in soilSection.shapePoints) {
                  polygon[count] = CLLocationCoordinate2DMake([shape.latitude doubleValue], [shape.longitude doubleValue]);
                  count++;
                }
                NSPolygon *theShape = [NSPolygon polygonWithCoordinates:polygon count:[soilSection.shapePoints count]];
                theShape.soilName = soilType.soilname;
                [overLays addObject:theShape];
              }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
              [self addOverlays:overLays];
            });
          }
        }
      }
    }
  });
}

@end
