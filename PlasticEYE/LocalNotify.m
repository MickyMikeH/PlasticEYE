//
//  LocalNotify.m
//  PlasticEYE
//
//  Created by Michael Hsieh on 2017/7/6.
//  Copyright © 2017年 Michael Hsieh. All rights reserved.
//

#import "LocalNotify.h"
#import <UserNotifications/UserNotifications.h>
#import "UserDefaultManager.h"
#import "DataManager.h"

static NSString *const kExpired = @"即將到期";

@implementation LocalNotify

- (BOOL)localNotifyisOn {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    __block BOOL isON = YES;
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        if (settings.authorizationStatus != UNAuthorizationStatusAuthorized) {
            isON = NO;
        }
    }];
    return isON;
}

- (void)registNotify {
    if ([self localNotifyisOn]) {
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.title = [NSString localizedUserNotificationStringForKey:kExpired
                                                              arguments:nil];
        content.body = [NSString localizedUserNotificationStringForKey:@"請替換您的隱形眼鏡"
                                                             arguments:nil];
        content.sound = [UNNotificationSound defaultSound];
        
        NSInteger dataDate = [[[DataManager alloc] init] dayOfSetting];
        
        NSDateComponents *components = [[NSDateComponents alloc] init];
        components.day = dataDate;
        
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
        
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:kExpired
                                                                              content:content
                                                                              trigger:trigger];
        /// 3. schedule localNotification
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (!error) {
                NSLog(@"add NotificationRequest succeeded!");
            }
        }];
    }
    else {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
    }
}

- (void)cancelNotify {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllDeliveredNotifications];
}

@end
