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

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults boolForKey:@"DataLoaded"]) {
    DataLoader *dataLoader = [[DataLoader alloc] init];
    [dataLoader loadGMLData];
    [defaults setBool:YES forKey:@"DataLoaded"];
    [defaults synchronize];
  }
}

@end
