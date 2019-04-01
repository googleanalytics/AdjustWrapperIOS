// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
// in compliance with the License. You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License
// is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
// or implied. See the License for the specific language governing permissions and limitations under
// the License.

#import "ViewController.h"
#import <FirebaseCore/FIRApp.h>
#import "Adjust.h"
#import "AdjustWrapper.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  // Initialize Google Analytics for Firebase
  [FIRApp configure];

  // Initialize Adjust
  NSString *environment = ADJEnvironmentSandbox;
  ADJConfig *adjustConfig = [ADJConfig configWithAppToken:@"your-app-token"
                                              environment:environment];
  [Adjust appDidLaunch:adjustConfig];

  // Register event mapping.
  [AdjustWrapper setEventMapping:@{
    @"abcde1" : @"sign_up",
    @"abcde2" : @"tutorial_begin",
    @"fghijk" : @"your_custom_event"
  }];
  AdjustWrapper *wrapper = [AdjustWrapper getInstance];

  // Log sign up event.
  [wrapper trackEvent:[ADJWrappedEvent eventWithEventToken:@"abcde1"]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
