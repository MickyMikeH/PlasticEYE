//
//  UserDefaultManager.m
//  PlasticEYE
//
//  Created by Michael Hsieh on 2017/7/7.
//  Copyright © 2017年 Michael Hsieh. All rights reserved.
//

#import "UserDefaultManager.h"

@implementation UserDefaultManager

+ (void)saveUserDefaultWithObj:(id)obj key:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)loadUserDefaultWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)removeUserDefaultWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

@end

@implementation UserDefaultManager (LaunchApp)

+ (BOOL)isFirstLauch {
    return [[self class] loadUserDefaultWithKey:@"FirstLaunch"];
}

@end
