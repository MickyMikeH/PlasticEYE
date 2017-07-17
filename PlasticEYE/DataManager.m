//
//  DataManager.m
//  PlasticEYE
//
//  Created by Michael Hsieh on 2017/7/3.
//  Copyright © 2017年 Michael Hsieh. All rights reserved.
//

#import "DataManager.h"
#import "UserDefaultManager.h"

static NSInteger const OneDay = 1;
static NSInteger const TwoWeek = 13;

static NSString *const kUserDEye = @"EYE";

@implementation DataManager

- (NSArray *)dataList {
    return [UserDefaultManager loadUserDefaultWithKey:kUserDEye];
}

- (void)resetData {
    [UserDefaultManager removeUserDefaultWithKey:kUserDEye];
}

- (void)setEyeDic:(NSDictionary *)eyeDic {
    if (eyeDic) {
        NSDate *left = [self laterDate:[eyeDic[@"EyeDirectionLeft"] unsignedIntValue]];
        NSDate *right = [self laterDate:[eyeDic[@"EyeDirectionRight"] unsignedIntValue]];
        NSArray *array = @[@{@"LeftEye" : left, @"RightEye" : right}];
        
        [UserDefaultManager saveUserDefaultWithObj:array key:kUserDEye];
    }
}

- (NSDate *)laterDate:(LimitMode)limitMode {
    self.limitMode = limitMode;
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setDay:[self dayOfSetting]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDate *laterDate = [calendar dateByAddingComponents:components toDate:[self now] options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSLog(@"%@", [dateFormatter stringFromDate:laterDate]);
    
    return laterDate;
    
}

- (NSInteger)dayOfSetting {
    if (self.limitMode == LimitModeOneDay) {
        return OneDay;
    }
    else {
        return TwoWeek;
    }
}

- (NSDate *)now {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:[NSDate date]];
    NSDate *now = [[NSDate date] dateByAddingTimeInterval:interval];
    
    return now;
}
@end
