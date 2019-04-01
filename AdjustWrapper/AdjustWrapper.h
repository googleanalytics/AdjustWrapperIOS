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

#import <Foundation/Foundation.h>
#import "ADJConfig.h"
#import "ADJWrappedEvent.h"

// Wraps calls to Adjust in order to log them in both Google Analytics for Firebase and Adjust.
@interface AdjustWrapper : NSObject

// Sets token to name pairs for the Adjust wrapper. Allows the events logged with Adjust tokens to
// be translated into the untokenized name for Google Analytics for Firebase.
// The dictionary should look like: @{
//  @"abcdef": @"event_name",
//  @"ghijkl": @"event_name_2"
// }
+ (void)setEventMapping:(NSDictionary<NSString *, NSString *> *)dictionary;

// Wraps calls to [Adjust trackEvent:]
+ (void)trackEvent:(nullable ADJWrappedEvent *)event;

// Wraps calls to [Adjust getInstance]
+ (nullable id)getInstance;

// Wraps calls to [[Adjust getInstance] trackEvent:]
- (void)trackEvent:(nullable ADJWrappedEvent *)event;
@end
