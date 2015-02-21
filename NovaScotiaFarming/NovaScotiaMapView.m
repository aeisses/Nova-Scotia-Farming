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

@interface NovaScotiaMapView()

@end

@implementation NovaScotiaMapView

@synthesize context = _context;

- (void)loadAPolygon:(NSString*)type {
  NSEntityDescription *soilTypeEntity = [NSEntityDescription entityForName:@"SoilType" inManagedObjectContext:_context];
  NSFetchRequest *soilTypeFetchRequest = [[NSFetchRequest alloc] init];
  soilTypeFetchRequest.predicate = [NSPredicate predicateWithFormat:@"soilname like %@",type];
  soilTypeFetchRequest.entity = soilTypeEntity;
  NSArray *soilTypes = [_context executeFetchRequest:soilTypeFetchRequest error:nil];
  if ([soilTypes count]) {
//    NSMutableString *predicateString = [[NSMutableString alloc] initWithString:@""];
    NSMutableArray *predicates = [NSMutableArray new];
    for (SoilTypeManagedObject *soilType in soilTypes) {
//      if (soilType == [soilTypes lastObject]) {
//        [predicateString appendFormat:@"soiltype like %@",soilType.soiltype];
//      } else {
////        [predicateString appendFormat:@"(soiltype like '%@') OR ",soilType.soiltype];
//      }
      [predicates addObject:[NSPredicate predicateWithFormat:@"soiltype like %@",soilType.soiltype]];
    }
    
    NSEntityDescription *checkEntity = [NSEntityDescription entityForName:@"SoilCMP" inManagedObjectContext:_context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    fetchRequest.predicate = [NSPredicate predicateWithFormat:predicateString];
    fetchRequest.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    fetchRequest.entity = checkEntity;
    NSArray *fetchObject = [_context executeFetchRequest:fetchRequest error:nil];
    if ([fetchObject count]) {
      for (SoilCMPManagedObject *soilCMP in fetchObject) {
        NSLog(@"%@--",soilCMP.soiltype);
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SoilSection" inManagedObjectContext:_context];
        NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
  //      NSString *predicate = [NSString stringWithFormat:@"mapunit like %@",soilCMP.mapunit];
        fetchRequest2.predicate = [NSPredicate predicateWithFormat:@"mapunit like %@",soilCMP.mapunit];
  //      fetchRequest2.predicate = [NSPredicate predicateWithFormat:@"objectid < 10"];
        fetchRequest2.entity = entity;
        NSArray *fetchObject2 = [_context executeFetchRequest:fetchRequest2 error:nil];
        NSMutableArray *overLays = [NSMutableArray new];
        if ([fetchObject2 count]) {
          for (SoilSectionManagedObject *soilSection in fetchObject2) {
        //    SoilSectionManagedObject *soilSection = [fetchObject lastObject];
            CLLocationCoordinate2D polygon[[soilSection.shapePoints count]];
            int count = 0;
            for (ShapePointManagedObject *shape in soilSection.shapePoints) {
              polygon[count] = CLLocationCoordinate2DMake([shape.latitude doubleValue], [shape.longitude doubleValue]);
              count++;
            }
            MKPolygon *theShape = [MKPolygon polygonWithCoordinates:polygon count:[soilSection.shapePoints count]];
            [overLays addObject:theShape];
          }
        }
        [self addOverlays:overLays];
      }
    }
  }
}

@end
