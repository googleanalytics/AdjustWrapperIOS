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

#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

#import <FirebaseAnalytics/FirebaseAnalytics.h>
#import "ADJWrappedEvent.h"
#import "Adjust.h"
#import "AdjustWrapper.h"
#import "GoogleAnalyticsAdapter.h"

@interface AdjustWrapper ()
- (instancetype)initWithAdjust:(Adjust *)adjust
               googleAnalytics:(GoogleAnalyticsAdapter *)analyticsAdapter;
@end

@interface AdjustWrapperTests : XCTestCase
@property(nonatomic, strong) id adjustMock;
@property(nonatomic, strong) id googleAnalyticsMock;
@property(nonatomic, strong) AdjustWrapper *wrapper;
@end

@implementation AdjustWrapperTests

- (void)setUp {
  [super setUp];

  self.adjustMock = OCMClassMock([Adjust class]);
  self.googleAnalyticsMock = OCMClassMock([GoogleAnalyticsAdapter class]);
  self.wrapper = [[AdjustWrapper alloc] initWithAdjust:self.adjustMock
                                       googleAnalytics:self.googleAnalyticsMock];
}

- (void)tearDown {
  self.adjustMock = nil;
  self.googleAnalyticsMock = nil;
  self.wrapper = nil;

  [super tearDown];
}

- (void)testTrackUnmappedEventWithNoParameters {
  NSString *eventName = @"unmapped_event";
  ADJWrappedEvent *event = [[ADJWrappedEvent alloc] initWithEventToken:eventName];
  [self.wrapper trackEvent:event];
  OCMVerify([self.adjustMock trackEvent:event]);
  OCMVerify([self.googleAnalyticsMock logEventWithName:eventName parameters:@{}]);
}

- (void)testTrackMappedEventWithNoParameters {
  [AdjustWrapper setEventMapping:@{@"mapped_event" : @"other_event"}];
  ADJWrappedEvent *event = [[ADJWrappedEvent alloc] initWithEventToken:@"mapped_event"];
  [self.wrapper trackEvent:event];
  OCMVerify([self.adjustMock trackEvent:event]);
  OCMVerify([self.googleAnalyticsMock logEventWithName:@"other_event" parameters:@{}]);
}

- (void)testTrackUnmappedEventWithParameters {
  ADJWrappedEvent *event = [[ADJWrappedEvent alloc] initWithEventToken:@"unmapped_event"];
  [event setTransactionId:@"tid"];
  [event setRevenue:15 currency:@"USD"];
  [self.wrapper trackEvent:event];
  NSMutableDictionary *expected = [NSMutableDictionary dictionary];
  expected[kFIRParameterTransactionID] = @"tid";
  expected[kFIRParameterValue] = @15;
  expected[kFIRParameterCurrency] = @"USD";
  OCMVerify([self.adjustMock trackEvent:event]);
  OCMVerify([self.googleAnalyticsMock logEventWithName:@"unmapped_event" parameters:expected]);
}

@end
