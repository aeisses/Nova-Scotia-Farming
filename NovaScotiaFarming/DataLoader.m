//
//  DataLoader.m
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/20/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import "DataLoader.h"
#import "DDFileReader.h"
#import "AppDelegate.h"
#import "ShapePointManagedObject.h"
#import "SoilSectionManagedObject.h"

static DataLoader *instance;

@interface DataLoader()
@property (nonatomic) BOOL foundGMLTag;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;

- (CLLocationCoordinate2D)convertWebMercatorToGeographicX:(double)mercX Y:(double)mercY;
@end

@implementation DataLoader

@synthesize foundGMLTag = _foundGMLTag;
@synthesize managedObjectContext = _managedObjectContext;

- (id)init {
  if (instance) {
    return instance;
  }
  
  if (self = [super init]) {
    _foundGMLTag = NO;
    _managedObjectContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;
  }
  return self;
}

+ (id)sharedInstance {
  if (instance) {
    return instance;
  }
  return [self init];
}

- (CLLocationCoordinate2D)convertWebMercatorToGeographicX:(double)mercX Y:(double)mercY {
  // define earth
  const double earthRadius = 6378137.0;
  // handle out of range
  if (fabs(mercX) < 180 && fabs(mercY) < 90)
    return kCLLocationCoordinate2DInvalid;
  // this handles the north and south pole nearing infinite Mercator conditions
  if ((fabs(mercX) > 20037508.3427892) || (fabs(mercY) > 20037508.3427892)) {
    return kCLLocationCoordinate2DInvalid;
  }
  // math for conversion
  double num1 = (mercX / earthRadius) * 180.0 / M_PI;
  double num2 = floor(((num1 + 180.0) / 360.0));
  double num3 = num1 - (num2 * 360.0);
  double num4 = ((M_PI_2 - (2.0 * atan(exp((-1.0 * mercY) / earthRadius)))) * 180 / M_PI);
  // set the return
  CLLocationDegrees lattitude = num4;
  CLLocationDegrees longitude = num3;
  CLLocationCoordinate2D geoLocation = CLLocationCoordinate2DMake(lattitude, longitude);
  return geoLocation;
}

- (void)loadGMLData {
  NSString *pathToMyFile = [[NSBundle mainBundle] pathForResource:@"PED_NS_DTL_50K" ofType:@"gml"];
  DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:pathToMyFile];
//  NSEntityDescription *soilSectionEntity = [NSEntityDescription entityForName:@"SoilSection" inManagedObjectContext:_managedObjectContext];
//  NSEntityDescription *shapePointEntity = [NSEntityDescription entityForName:@"ShapePoint" inManagedObjectContext:_managedObjectContext];
  __block SoilSectionManagedObject *soilSectionManagedObject;
  
  [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
    @autoreleasepool {
      if ([line hasPrefix:@"<gml:featureMember"] && !_foundGMLTag) {
        _foundGMLTag = YES;
        soilSectionManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"SoilSection" inManagedObjectContext:_managedObjectContext];
        
      } else if ([line hasPrefix:@"</gml:featureMember"] && _foundGMLTag) {
        _foundGMLTag = NO;
        NSLog(@"Addd row");
      } else if (_foundGMLTag) {
        NSMutableString *mutableLine = [[NSMutableString alloc] initWithString:line];
        // Start with these three, can add more later if needed.....
        if ([mutableLine hasPrefix:@"<fme:OBJECTID>"]) {
          [mutableLine replaceOccurrencesOfString:@"<fme:OBJECTID>"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          [mutableLine replaceOccurrencesOfString:@"</fme:OBJECTID>\n"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          soilSectionManagedObject.objectid = [NSNumber numberWithInt:(uint16_t)[mutableLine intValue]];
  //        NSLog(@"read line: %@", mutableLine);
        } else if ([mutableLine hasPrefix:@"<fme:SOIL_ID>"]) {
          [mutableLine replaceOccurrencesOfString:@"<fme:SOIL_ID>"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          [mutableLine replaceOccurrencesOfString:@"</fme:SOIL_ID>\n"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          soilSectionManagedObject.soilid = [NSNumber numberWithInt:(uint16_t)[mutableLine intValue]];
  //        NSLog(@"read line: %@", mutableLine);
        } else if ([mutableLine hasPrefix:@"<gml:posList>"]) {
          [mutableLine replaceOccurrencesOfString:@"<gml:posList>"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          [mutableLine replaceOccurrencesOfString:@"</gml:posList>\n"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          NSArray *pointArray = [mutableLine componentsSeparatedByString:@" "];
          // Check to make sure the list has an even number of points
          if ([pointArray count] % 2 != 0) {
            NSLog(@"Error in the number of points in the array");
          } else {
            NSMutableOrderedSet *shapePoints = [NSMutableOrderedSet new];
            for (int i=0; i<[pointArray count]; i+=2) {
              ShapePointManagedObject *shapePoint = (ShapePointManagedObject*)[NSEntityDescription insertNewObjectForEntityForName:@"ShapePoint" inManagedObjectContext:_managedObjectContext];
              CLLocationCoordinate2D location = [self convertWebMercatorToGeographicX:[[pointArray objectAtIndex:i] doubleValue] Y:[[pointArray objectAtIndex:i+1] doubleValue]];
              shapePoint.latitude = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:location.latitude];
              shapePoint.longitude = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:location.longitude];
              shapePoint.soilSection = soilSectionManagedObject;
              [shapePoints addObject:shapePoint];
            }
            soilSectionManagedObject.shapePoints = (NSOrderedSet*)shapePoints;
          }
        }
      }
    }
  }];
  NSError *error = nil;
  [_managedObjectContext save:&error];
}

@end