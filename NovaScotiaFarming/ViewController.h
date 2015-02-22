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
@property (nonatomic, strong) IBOutlet UIView *shader;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *spinner;
@property (nonatomic, strong) IBOutlet UILabel *infoLabel;
@property (nonatomic, strong) IBOutlet UIButton *infoButton;

@property (nonatomic, strong) IBOutlet UIButton *BarneyButton;
@property (nonatomic, strong) IBOutlet UIButton *BrydenButton;
@property (nonatomic, strong) IBOutlet UIButton *CobequidButton;
@property (nonatomic, strong) IBOutlet UIButton *CumberlandButton;
@property (nonatomic, strong) IBOutlet UIButton *CastleyButton;
@property (nonatomic, strong) IBOutlet UIButton *HebertButton;
@property (nonatomic, strong) IBOutlet UIButton *HansfordButton;
@property (nonatomic, strong) IBOutlet UIButton *HopewellButton;
@property (nonatomic, strong) IBOutlet UIButton *JogginsButton;
@property (nonatomic, strong) IBOutlet UIButton *KirkhillButton;
@property (nonatomic, strong) IBOutlet UIButton *KirkmountButton;
@property (nonatomic, strong) IBOutlet UIButton *MillbrookButton;
@property (nonatomic, strong) IBOutlet UIButton *PugwashButton;
@property (nonatomic, strong) IBOutlet UIButton *PerchLakeButton;
@property (nonatomic, strong) IBOutlet UIButton *QueensButton;
@property (nonatomic, strong) IBOutlet UIButton *StewiackeButton;
@property (nonatomic, strong) IBOutlet UIButton *ShulieButton;
@property (nonatomic, strong) IBOutlet UIButton *ThomButton;
@property (nonatomic, strong) IBOutlet UIButton *WestbrookButton;
@property (nonatomic, strong) IBOutlet UIButton *WoodbourneButton;
@property (nonatomic, strong) IBOutlet UIButton *WyvernButton;
@property (nonatomic, strong) IBOutlet UIButton *CoastalBeachButton;
@property (nonatomic, strong) IBOutlet UIButton *MineTailingsButton;
@property (nonatomic, strong) IBOutlet UIButton *SaltMarshButton;
@property (nonatomic, strong) IBOutlet UIButton *HortonButton;
@property (nonatomic, strong) IBOutlet UIButton *AllButton;

- (IBAction)touchButton:(id)sender;
- (IBAction)touchInfoButton:(id)sender;

@end

