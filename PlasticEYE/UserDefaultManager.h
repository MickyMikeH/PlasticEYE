//
//  UserDefaultManager.h
//  PlasticEYE
//
//  Created by Michael Hsieh on 2017/7/7.
//  Copyright © 2017年 Michael Hsieh. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kEyeSwitch = @"EyeSwtich";

@interface UserDefaultManager : NSObject

+ (void)saveUserDefaultWithObj:(id)obj key:(NSString *)key;

+ (id)loadUserDefaultWithKey:(NSString *)key;

+ (void)removeUserDefaultWithKey:(NSString *)key;

@end

@interface UserDefaultManager (LaunchApp)

+ (BOOL)isFirstLauch;

@end
