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

#import "AdjustGoogleAnalyticsAdapter.h"
#import <FirebaseAnalytics/FirebaseAnalytics.h>

@interface AdjustGoogleAnalyticsAdapter ()
@property(nonatomic, strong) NSString *sanitizedNamePrefix;
@property(nonatomic, strong) NSString *wrapperParameterValue;
@property(nonatomic, strong) NSString *emptyEventName;
@property(nonatomic, strong) NSString *emptyParameterName;
@property(nonatomic, strong) NSString *emptyUserPropertyName;
@property(nonatomic, strong) NSDictionary<NSString *, NSString *> *eventMap;
@property(nonatomic, strong) NSDictionary<NSString *, NSString *> *parameterMap;
@end

@implementation AdjustGoogleAnalyticsAdapter

- (instancetype)init {
  self = [super init];
  if (self) {
    _sanitizedNamePrefix = @"aj_";
    _wrapperParameterValue = @"aj";
    _emptyEventName = @"aj_unnamed_event";
    _emptyParameterName = @"aj_unnamed_parameter";
    _emptyUserPropertyName = @"aj_unnamed_user_property";

    _eventMap = @{};

    _parameterMap = @{};
  }

  return self;
}

@end
