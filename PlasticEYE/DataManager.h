//
//  DataManager.h
//  PlasticEYE
//
//  Created by Michael Hsieh on 2017/7/3.
//  Copyright © 2017年 Michael Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LimitModeOneDay,
    LimitModeTwoWeek
} LimitMode;

typedef enum : NSUInteger {
    EyeDirectionLeft,
    EyeDirectionRight
} EyeDirection;

typedef enum : NSUInteger {
    CycleModeSame,
    CycleModeNotSame
} CycleMode;

@interface DataManager : NSObject

@property (nonatomic, assign) LimitMode limitMode;

@property (nonatomic, assign) EyeDirection EyeDirection;

@property (nonatomic, assign) CycleMode cycleMode;

@property (nonatomic, copy) NSDictionary *eyeDic;

- (NSArray *)dataList;

- (NSDate *)now;

- (NSInteger)dayOfSetting;

- (void)resetData;
@end
