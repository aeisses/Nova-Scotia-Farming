//
//  ViewController.h
//  NovaScotiaFarming
//
//  Created by Aaron Eisses on 2/20/15.
//  Copyright (c) 2015 KNOWTime. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NovaScotiaMapView.h"

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet NovaScotiaMapView *nsMapView;

@end

