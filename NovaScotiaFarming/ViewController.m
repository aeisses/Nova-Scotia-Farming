//
//  ViewController.m
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/20/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import "ViewController.h"
#import "DataLoader.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize nsMapView = _nsMapView;

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  _nsMapView.delegate = self;
  CLLocationCoordinate2D center = CLLocationCoordinate2DMake(45.263357, -63.323368);
  MKCoordinateSpan span = MKCoordinateSpanMake(3.527896, 6.861726);
  [_nsMapView setRegion:MKCoordinateRegionMake(center, span)];
  _nsMapView.mapType = MKMapTypeSatellite;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if (![defaults boolForKey:@"DataLoaded"]) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      DataLoader *dataLoader = [[DataLoader alloc] init];
      [dataLoader loadGMLData];
      [defaults setBool:YES forKey:@"DataLoaded"];
      [defaults synchronize];
    });
  }
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
//  NSLog(@"Location: %f, %f, %f, %f",mapView.region.center.latitude,mapView.region.center.longitude,mapView.region.span.latitudeDelta,mapView.region.span.longitudeDelta);
}

@end
