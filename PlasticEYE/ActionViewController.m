//
//  ActionViewController.m
//  PlasticEYE
//
//  Created by Michael Hsieh on 2017/7/3.
//  Copyright © 2017年 Michael Hsieh. All rights reserved.
//

#import "ActionViewController.h"
#import "DataManager.h"

#define kEyeDateLimit @[@"日拋", @"雙週拋"]

static NSString *const kActionViewTitle = @"請設定有效期限";
static NSString *const kEffectiveDate = @"請選擇有效期限";
static NSString *const kConfirmSave = @"確定是否存檔";
static NSString *const kConfirm = @"確定";
static NSString *const kCancel = @"取消";
static NSString *const kComplete = @"存檔完成";


@interface ActionViewController ()

@property (weak, nonatomic) IBOutlet UIButton *leftEyeButton;
@property (weak, nonatomic) IBOutlet UIButton *rightEyeButton;
@property (copy, nonatomic) DataManager *dataManager;
@property (assign, nonatomic) LimitMode leftLimitMode;
@property (assign, nonatomic) LimitMode rightLimitMode;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cycleSegment:(UISegmentedControl *)sender {
    self.dataManager.cycleMode = sender.selectedSegmentIndex;
}

- (void)updateEyeButtonTitle:(NSString *)title sender:(UIButton *)sender limitMode:(LimitMode)limitMode{
    if (self.dataManager.cycleMode == CycleModeSame) {
        [self.leftEyeButton setTitle:title forState:UIControlStateNormal];
        [self.rightEyeButton setTitle:title forState:UIControlStateNormal];
        self.leftLimitMode = limitMode;
        self.rightLimitMode = limitMode;
    }
    else {
        if ([sender isEqual:self.leftEyeButton]) {
            [self.leftEyeButton setTitle:title forState:UIControlStateNormal];
            self.leftLimitMode = limitMode;
        }
        else {
            [self.rightEyeButton setTitle:title forState:UIControlStateNormal];
            self.rightLimitMode = limitMode;
        }
    }
}

- (IBAction)eyeButtonHandler:(UIButton *)sender {
    UIAlertController *eyeDatePick = [UIAlertController alertControllerWithTitle:kEffectiveDate message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *oneDay = [UIAlertAction actionWithTitle:kEyeDateLimit[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateEyeButtonTitle:kEyeDateLimit[0] sender:sender limitMode:LimitModeOneDay];
    }];
    
    UIAlertAction *twoWeek = [UIAlertAction actionWithTitle:kEyeDateLimit[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self updateEyeButtonTitle:kEyeDateLimit[1] sender:sender limitMode:LimitModeTwoWeek];
    }];
    
    [eyeDatePick addAction:oneDay];
    [eyeDatePick addAction:twoWeek];
    
    [self presentViewController:eyeDatePick animated:YES completion:nil];
}

- (IBAction)done:(UIButton *)sender {
    UIAlertController *confirmAlert = [UIAlertController alertControllerWithTitle:kConfirmSave message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *confirm = [UIAlertAction actionWithTitle:kConfirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.dataManager.eyeDic = @{@"EyeDirectionLeft" : @(self.leftLimitMode),
                                    @"EyeDirectionRight" : @(self.rightLimitMode)};
        [self saveCompleteAlert];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:kCancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [confirmAlert addAction:confirm];
    [confirmAlert addAction:cancel];
    
    [self presentViewController:confirmAlert animated:YES completion:nil];
}

- (void)saveCompleteAlert {
    UIAlertController *saveCompleteAlert = [UIAlertController alertControllerWithTitle:kComplete message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *saveComplete = [UIAlertAction actionWithTitle:kConfirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [saveCompleteAlert addAction:saveComplete];
    
    [self presentViewController:saveCompleteAlert animated:YES completion:nil];
}

- (DataManager *)dataManager {
    if (!_dataManager) {
        _dataManager = [DataManager new];
    }
    
    return _dataManager;
}
@end
