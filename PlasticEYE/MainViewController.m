//
//  MainViewController.m
//  PlasticEYE
//
//  Created by Michael Hsieh on 2017/7/7.
//  Copyright © 2017年 Michael Hsieh. All rights reserved.
//

#import "MainViewController.h"
#import "UserDefaultManager.h"
#import "DataManager.h"
#import "LocalNotify.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UILabel *eyeLimitLabel;
@property (strong, nonatomic) IBOutlet UILabel *eyeCountDownLabel;

@property (strong, nonatomic) IBOutlet UISwitch *countDownSwtich;

@property (copy, nonatomic) LocalNotify *localNotify;
@property (copy, nonatomic) DataManager *dataManager;
@property (assign, nonatomic) LimitMode leftLimitMode;
@property (assign, nonatomic) LimitMode rightLimitMode;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![UserDefaultManager isFirstLauch]) {
        [self showAlert];
    }
    self.countDownSwtich.on = [[UserDefaultManager loadUserDefaultWithKey:kEyeSwitch] boolValue];
    [self updateEyeCountDown:self.countDownSwtich.isOn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)startCountDown {
    NSArray *data = self.dataManager.dataList;
    if (data.count) {
        NSDictionary *dataDic = data.firstObject;
        NSDate *dataDate = dataDic[@"LeftEye"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *laterDateStr = [dateFormatter stringFromDate:dataDate];
        self.eyeLimitLabel.text = laterDateStr;
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
        NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                                   fromDate:self.dataManager.now
                                                     toDate:dataDate
                                                    options:0];
        
        self.eyeCountDownLabel.text = [NSString stringWithFormat:@"%ld天", components.day + 1];
    }
}

- (void)stopCountDown {
    self.eyeLimitLabel.text = @"有效期限";
    self.eyeCountDownLabel.text = @"結束時間";
}

- (void)updateEyeCountDown:(BOOL)on {
    if (self.dataManager.dataList.count) {
        if (on) {
            [self.localNotify registNotify];
            [self startCountDown];
        }
        else {
            [self.localNotify cancelNotify];
            [self stopCountDown];
        }
        [UserDefaultManager saveUserDefaultWithObj:@(on) key:kEyeSwitch];
    }
    else {
        self.countDownSwtich.on = NO;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"請設定使用期限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)switchHandler:(UISwitch *)sender {
    [self updateEyeCountDown:sender.isOn];
}

- (void)showAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"請選擇使用期限" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *oneDay = [UIAlertAction actionWithTitle:@"日拋" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.leftLimitMode = self.rightLimitMode = LimitModeOneDay;
        self.dataManager.eyeDic = @{@"EyeDirectionLeft" : @(self.leftLimitMode),
                                    @"EyeDirectionRight" : @(self.rightLimitMode)};
    }];
    UIAlertAction *twoWeek = [UIAlertAction actionWithTitle:@"雙週拋" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.leftLimitMode = self.rightLimitMode = LimitModeTwoWeek;
        self.dataManager.eyeDic = @{@"EyeDirectionLeft" : @(self.leftLimitMode),
                                    @"EyeDirectionRight" : @(self.rightLimitMode)};
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:oneDay];
    [alert addAction:twoWeek];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)addHandler:(UIBarButtonItem *)sender {
    [self showAlert];
}

- (IBAction)resetHandler:(UIBarButtonItem *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意！是否清除目前資料" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *clear = [UIAlertAction actionWithTitle:@"確認" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self updateEyeCountDown:NO];
        self.countDownSwtich.on = NO;
        [self.dataManager resetData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:clear];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}

- (DataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [DataManager new];
    }
    
    return _dataManager;
}

- (LocalNotify *)localNotify {
    if (!_localNotify) {
        _localNotify = [LocalNotify new];
    }
    
    return _localNotify;
}
@end
