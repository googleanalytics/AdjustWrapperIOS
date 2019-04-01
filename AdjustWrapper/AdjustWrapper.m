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

#import "AdjustWrapper.h"
#import <FirebaseAnalytics/FirebaseAnalytics.h>
#import "Adjust.h"
#import "AdjustGoogleAnalyticsAdapter.h"
#import "GoogleAnalyticsAdapter.h"

static AdjustWrapper *instance = nil;
static NSDictionary *eventMapping = nil;

@implementation AdjustWrapper {
  Adjust *_adjust;
  GoogleAnalyticsAdapter *_googleAnalytics;
}

- (instancetype)init {
  return [self initWithAdjust:[Adjust getInstance]
              googleAnalytics:[[GoogleAnalyticsAdapter alloc]
                                  initWithSdkAdapter:[[AdjustGoogleAnalyticsAdapter alloc] init]]];
}

- (instancetype)initWithAdjust:(Adjust *)adjust
               googleAnalytics:(GoogleAnalyticsAdapter *)analyticsAdapter {
  self = [super init];
  if (self) {
    _adjust = adjust;
    _googleAnalytics = analyticsAdapter;
  }

  return self;
}

+ (void)setEventMapping:(NSDictionary<NSString *, NSString *> *)dictionary {
  eventMapping = dictionary;
}

+ (id)getInstance {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[AdjustWrapper alloc] init];
  });

  return instance;
}

+ (void)trackEvent:(ADJWrappedEvent *)event {
  [[AdjustWrapper getInstance] trackEvent:event];
}

- (void)trackEvent:(ADJWrappedEvent *)event {
  [_adjust trackEvent:event];

  NSString *name = event.rawEventToken;
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  if (eventMapping == nil) {
    NSLog(@"Event logged before [AdjustWrapper setEventMapping:] called. Google Analytics for "
          @"Firebase data will be incorrect.");
  }
  if ([eventMapping objectForKey:name]) {
    name = eventMapping[name];
  }
  if (event.revenue) {
    params[kFIRParameterValue] = [event.revenue copy];
  }
  if (event.currency) {
    params[kFIRParameterCurrency] = [event.currency copy];
  }
  if (event.transactionId) {
    params[kFIRParameterTransactionID] = [event.transactionId copy];
  }
  [_googleAnalytics logEventWithName:name parameters:[params copy]];
}

@end
