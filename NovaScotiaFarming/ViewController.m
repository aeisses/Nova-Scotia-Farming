//
//  ViewController.m
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/20/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import "ViewController.h"
#import "DataLoader.h"
#import "AppDelegate.h"
#import "NSPolygon.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize nsMapView = _nsMapView;
@synthesize shader = _shader;
@synthesize spinner = _spinner;
@synthesize infoLabel = _infoLabel;

@synthesize BarneyButton = _BarneyButton;
@synthesize BrydenButton = _BrydenButton;
@synthesize CobequidButton = _CobequidButton;
@synthesize CumberlandButton = _CumberlandButton;
@synthesize CastleyButton = _CastleyButton;
@synthesize HebertButton = _HebertButton;
@synthesize HansfordButton = _HansfordButton;
@synthesize HopewellButton = _HopewellButton;
@synthesize JogginsButton = _JogginsButton;
@synthesize KirkhillButton = _KirkhillButton;
@synthesize KirkmountButton = _KirkmountButton;
@synthesize MillbrookButton = _MillbrookButton;
@synthesize PugwashButton = _PugwashButton;
@synthesize PerchLakeButton = _PerchLakeButton;
@synthesize QueensButton = _QueensButton;
@synthesize StewiackeButton = _StewiackeButton;
@synthesize ShulieButton = _ShulieButton;
@synthesize ThomButton = _ThomButton;
@synthesize WestbrookButton = _WestbrookButton;
@synthesize WoodbourneButton = _WoodbourneButton;
@synthesize WyvernButton = _WyvernButton;
@synthesize CoastalBeachButton = _CoastalBeachButton;
@synthesize MineTailingsButton = _MineTailingsButton;
@synthesize SaltMarshButton = _SaltMarshButton;
@synthesize HortonButton = _HortonButton;
@synthesize AllButton = _AllButton;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  _nsMapView.delegate = self;
  
  _nsMapView.mapType = MKMapTypeSatellite;
  _nsMapView.context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).managedObjectContext;

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults boolForKey:@"DataLoaded"]) {
    [_spinner removeFromSuperview];
    [_shader removeFromSuperview];
    [_infoLabel removeFromSuperview];
  } else {
    [_spinner startAnimating];
    [_nsMapView setUserInteractionEnabled:NO];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (![defaults boolForKey:@"DataLoaded"]) {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(45.263357, -63.323368);
    MKCoordinateSpan span = MKCoordinateSpanMake(3.662484, 7.125030);
    [_nsMapView setRegion:MKCoordinateRegionMake(center, span)];
    DataLoader *dataLoader = [[DataLoader alloc] init];
    [dataLoader loadGMLData];
    [dataLoader loadGMLDataKey];
    [dataLoader loadCMPData];
    [dataLoader loadSoilType];
    [defaults setBool:YES forKey:@"DataLoaded"];
    [defaults synchronize];
    dispatch_async(dispatch_get_main_queue(), ^{
      [_shader removeFromSuperview];
      [_spinner removeFromSuperview];
      [_infoLabel removeFromSuperview];
      [_nsMapView setUserInteractionEnabled:YES];
    });
  } else {
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(45.263357, -63.323368);
    MKCoordinateSpan span = MKCoordinateSpanMake(3.662484, 7.125030);
    [_nsMapView setRegion:MKCoordinateRegionMake(center, span)];
  }
}

- (MKOverlayView*)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
  if ([overlay isKindOfClass:[MKPolygon class]]) {
    MKPolygonView *aView = [[MKPolygonView alloc] initWithPolygon:(NSPolygon*)overlay];
    if ([((NSPolygon*)overlay).soilName isEqualToString:@"Barney"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Bryden"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.2f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Cobequid"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.4f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Cumberland"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.6f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Castley"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.8f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Hebert"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:1.0f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Hansford"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.2f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Hopewell"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.4f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Joggins"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.6f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Kirkhill"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.8f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Kirkmount"]) {
      aView.fillColor = [UIColor colorWithRed:1.0f green:0.0f blue:1.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Millbrook"]) {
      aView.fillColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.2f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Pugwash"]) {
      aView.fillColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.4f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Perch Lake"]) {
      aView.fillColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.6f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Queens"]) {
      aView.fillColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.8f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Stewiacke"]) {
      aView.fillColor = [UIColor colorWithRed:0.0f green:1.0f blue:1.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Shulie"]) {
      aView.fillColor = [UIColor colorWithRed:0.2f green:1.0f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Thom"]) {
      aView.fillColor = [UIColor colorWithRed:0.4f green:1.0f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Westbrook"]) {
      aView.fillColor = [UIColor colorWithRed:0.6f green:1.0f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Woodbourne"]) {
      aView.fillColor = [UIColor colorWithRed:0.8f green:1.0f blue:0.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Wyvern"]) {
      aView.fillColor = [UIColor colorWithRed:0.2f green:0.0f blue:1.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Coastal Beach"]) {
      aView.fillColor = [UIColor colorWithRed:0.4f green:0.0f blue:1.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Mine Tailings"]) {
      aView.fillColor = [UIColor colorWithRed:0.6f green:0.0f blue:1.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Salt Marsh"]) {
      aView.fillColor = [UIColor colorWithRed:0.8f green:0.0f blue:1.0f alpha:0.6];
    } else if ([((NSPolygon*)overlay).soilName isEqualToString:@"Horten"]) {
      aView.fillColor = [UIColor colorWithRed:0.0f green:1.0f blue:0.0f alpha:0.6];
    }
    aView.strokeColor = [[UIColor brownColor] colorWithAlphaComponent:1.0];
    aView.lineWidth = 2;
    return aView;
  }
  return nil;
}

- (IBAction)touchButton:(id)sender {

  if ([(UIButton*)sender isEqual:_BarneyButton]) {
    [_nsMapView loadAPolygon:@"Barney"];
  } else if ([(UIButton*)sender isEqual:_BrydenButton]) {
    [_nsMapView loadAPolygon:@"Bryden"];
  } else if ([(UIButton*)sender isEqual:_CobequidButton]) {
    [_nsMapView loadAPolygon:@"Cobequid"];
  } else if ([(UIButton*)sender isEqual:_CumberlandButton]) {
    [_nsMapView loadAPolygon:@"Cumberland"];
  } else if ([(UIButton*)sender isEqual:_CastleyButton]) {
    [_nsMapView loadAPolygon:@"Castley"];
  } else if ([(UIButton*)sender isEqual:_HebertButton]) {
    [_nsMapView loadAPolygon:@"Hebert"];
  } else if ([(UIButton*)sender isEqual:_HansfordButton]) {
    [_nsMapView loadAPolygon:@"Hansford"];
  } else if ([(UIButton*)sender isEqual:_HopewellButton]) {
    [_nsMapView loadAPolygon:@"Hopewell"];
  } else if ([(UIButton*)sender isEqual:_JogginsButton]) {
    [_nsMapView loadAPolygon:@"Joggins"];
  } else if ([(UIButton*)sender isEqual:_KirkhillButton]) {
    [_nsMapView loadAPolygon:@"Kirkhill"];
  } else if ([(UIButton*)sender isEqual:_KirkmountButton]) {
    [_nsMapView loadAPolygon:@"Kirkmount"];
  } else if ([(UIButton*)sender isEqual:_MillbrookButton]) {
    [_nsMapView loadAPolygon:@"Millbrook"];
  } else if ([(UIButton*)sender isEqual:_PugwashButton]) {
    [_nsMapView loadAPolygon:@"Pugwash"];
  } else if ([(UIButton*)sender isEqual:_PerchLakeButton]) {
    [_nsMapView loadAPolygon:@"Perch Lake"];
  } else if ([(UIButton*)sender isEqual:_QueensButton]) {
    [_nsMapView loadAPolygon:@"Queens"];
  } else if ([(UIButton*)sender isEqual:_StewiackeButton]) {
    [_nsMapView loadAPolygon:@"Stewiacke"];
  } else if ([(UIButton*)sender isEqual:_ShulieButton]) {
    [_nsMapView loadAPolygon:@"Shulie"];
  } else if ([(UIButton*)sender isEqual:_ThomButton]) {
    [_nsMapView loadAPolygon:@"Thom"];
  } else if ([(UIButton*)sender isEqual:_WestbrookButton]) {
    [_nsMapView loadAPolygon:@"Westbrook"];
  } else if ([(UIButton*)sender isEqual:_WoodbourneButton]) {
    [_nsMapView loadAPolygon:@"Woodbourne"];
  } else if ([(UIButton*)sender isEqual:_WyvernButton]) {
    [_nsMapView loadAPolygon:@"Wyvern"];
  } else if ([(UIButton*)sender isEqual:_CoastalBeachButton]) {
    [_nsMapView loadAPolygon:@"Coastal Beach"];
  } else if ([(UIButton*)sender isEqual:_MineTailingsButton]) {
      [_nsMapView loadAPolygon:@"Mine Tailings"];
  } else if ([(UIButton*)sender isEqual:_SaltMarshButton]) {
    [_nsMapView loadAPolygon:@"Salt Marsh"];
  } else if ([(UIButton*)sender isEqual:_HortonButton]) {
    [_nsMapView loadAPolygon:@"Horten"];
  } else if ([(UIButton*)sender isEqual:_AllButton]) {
    [_nsMapView loadAPolygon:@"All"];
  }
}


- (IBAction)touchInfoButton:(id)sender {
  if (_nsMapView.mapType == MKMapTypeSatellite) {
    _nsMapView.mapType = MKMapTypeHybrid;
  } else if (_nsMapView.mapType == MKMapTypeHybrid) {
    _nsMapView.mapType = MKMapTypeStandard;
  } else {
    _nsMapView.mapType = MKMapTypeSatellite;
  }
}


@end
