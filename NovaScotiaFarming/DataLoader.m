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
#import "SoilSectionKeyManagedObject.h"
#import "SoilCMPManagedObject.h"
#import "SoilTypeManagedObject.h"

static DataLoader *instance;

@interface DataLoader()
@property (nonatomic) BOOL foundGMLTag;
@property (nonatomic, weak) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) SoilSectionManagedObject *soilSectionManagedObject;

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
  
  __weak DataLoader *wSelf = self;
  [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
    @autoreleasepool {
      if ([line hasPrefix:@"<gml:featureMember"] && !_foundGMLTag) {
        _foundGMLTag = YES;
        wSelf.soilSectionManagedObject = [NSEntityDescription insertNewObjectForEntityForName:@"SoilSection" inManagedObjectContext:_managedObjectContext];
        
      } else if ([line hasPrefix:@"</gml:featureMember"] && _foundGMLTag) {
        _foundGMLTag = NO;
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
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
          wSelf.soilSectionManagedObject.objectid = [NSNumber numberWithInt:(uint16_t)[mutableLine intValue]];
        } else if ([mutableLine hasPrefix:@"<fme:SOIL_ID>"]) {
          [mutableLine replaceOccurrencesOfString:@"<fme:SOIL_ID>"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          [mutableLine replaceOccurrencesOfString:@"</fme:SOIL_ID>\n"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          wSelf.soilSectionManagedObject.soilid = [NSNumber numberWithInt:(uint16_t)[mutableLine intValue]];
        } else if ([mutableLine hasPrefix:@"<fme:MAPUNIT>"]) {
          [mutableLine replaceOccurrencesOfString:@"<fme:MAPUNIT>"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          [mutableLine replaceOccurrencesOfString:@"</fme:MAPUNIT>\n"
                                       withString:@""
                                          options:NSLiteralSearch
                                            range:NSMakeRange(0,[mutableLine length])];
          wSelf.soilSectionManagedObject.mapunit = [mutableLine stringByReplacingOccurrencesOfString:@"/" withString:@""];
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
              shapePoint.soilSection = wSelf.soilSectionManagedObject;
              [shapePoints addObject:shapePoint];
            }
            wSelf.soilSectionManagedObject.shapePoints = (NSOrderedSet*)shapePoints;
          }
        }
      }
    }
  }];
  NSLog(@"Finished GEO");
}

- (void)loadGMLDataKey {
  NSString *pathToMyFile = [[NSBundle mainBundle] pathForResource:@"PED_NS_DTL_50K" ofType:@"csv"];
  DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:pathToMyFile];
  
  [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
    @autoreleasepool {
      if (![line hasPrefix:@"geodb_oid"]) {
        NSArray *lineSpiltByCommon = [[line stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]] componentsSeparatedByString:@","];
        SoilSectionKeyManagedObject *soilKey = (SoilSectionKeyManagedObject*)[NSEntityDescription insertNewObjectForEntityForName:@"SoilSectionKey"inManagedObjectContext:_managedObjectContext];
        soilKey.objectid = [NSNumber numberWithInt:(uint16_t)[lineSpiltByCommon objectAtIndex:1]];
        soilKey.mapunit = [(NSString*)[lineSpiltByCommon objectAtIndex:6] stringByReplacingOccurrencesOfString:@"/" withString:@""];
      }
    }
  }];
  [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
    NSLog(@"Finsihed DataKey");
}

- (void)loadCMPData {
  NSString *pathToMyFile = [[NSBundle mainBundle] pathForResource:@"PED_NS_DTL_CMP" ofType:@"csv"];
  DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:pathToMyFile];
  
  [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
    @autoreleasepool {
      if (![line hasPrefix:@"geodb_oid"]) {
        NSString *removeNewLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
        NSArray *lineSpiltByCommon = [removeNewLine componentsSeparatedByString:@","];
        SoilCMPManagedObject *soilCMP = (SoilCMPManagedObject*)[NSEntityDescription insertNewObjectForEntityForName:@"SoilCMP" inManagedObjectContext:_managedObjectContext];
        soilCMP.mapunit = [(NSString*)[lineSpiltByCommon objectAtIndex:2] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        soilCMP.soiltype = [(NSString*)[lineSpiltByCommon objectAtIndex:7] substringToIndex:([((NSString*)[lineSpiltByCommon objectAtIndex:7]) length] -1)];
      }
    }
  }];
  [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
  NSLog(@"Finished CMPData");
}

- (void)loadSoilType {
  NSString *pathToMyFile = [[NSBundle mainBundle] pathForResource:@"PED_NS_DTL_SNF" ofType:@"csv"];
  DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:pathToMyFile];
  
  [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
    @autoreleasepool {
      if (![line hasPrefix:@"geodb_oid"]) {
        NSString *removeNewLine = [line stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
        NSArray *lineSpiltByCommon = [removeNewLine componentsSeparatedByString:@","];
        SoilTypeManagedObject *soilType = (SoilTypeManagedObject*)[NSEntityDescription insertNewObjectForEntityForName:@"SoilType" inManagedObjectContext:_managedObjectContext];
        soilType.geoid = [NSNumber numberWithInt:(uint16_t)[(NSString*)[lineSpiltByCommon objectAtIndex:0] intValue]];
        soilType.objectid = [NSNumber numberWithInt:(uint16_t)[(NSString*)[lineSpiltByCommon objectAtIndex:1] intValue]];
        soilType.soiltype = (NSString*)[lineSpiltByCommon objectAtIndex:2];
        soilType.soilname = (NSString*)[lineSpiltByCommon objectAtIndex:4];
      }
    }
  }];
  [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
  NSLog(@"Finished SoilType");
}

@end