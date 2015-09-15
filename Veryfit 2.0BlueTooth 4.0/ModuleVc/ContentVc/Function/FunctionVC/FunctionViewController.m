//
//  FunctionViewController.m
//  Warm
//
//  Created by 黄建华 on 15/8/18.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "FunctionViewController.h"

@interface FunctionViewController ()

@end

@implementation FunctionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"蓝牙指令";
//    [_photoControl setTitle:@"开启拍照" forState:UIControlStateNormal];
//    [_photoControl setTitle:@"关闭拍照" forState:UIControlStateSelected];

    FuncionViewTable *table = [[FuncionViewTable alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 340) style:UITableViewStylePlain];
    [self.view addSubview:table];
    
    DEF_WEAKSELF_(FunctionViewController)
    table.FuncionTableSelectBlock = ^(NSInteger index)
    {
        NSLog(@"index>>>>>%d",index);
        [weakSelf functionTableSelect:index];
    };
    
    [[BLTAcceptModel sharedInstance]setBLTControlTDelegate:self];
    
     [self updateViewData];
     [self updateViewUserData];
    
}

- (void)bltControlTakePhoto
{
    SHOWMBProgressHUD(@"去拍照", nil, nil, NO, 0.5);
}

- (void)functionTableSelect:(NSInteger)index
{
    NSLog(@"[BLTManager sharedInstance].model uuid >>>%@",[BLTManager sharedInstance].model.bltName);
    
    DEF_WEAKSELF_(FunctionViewController)
    
    if(![[BLTManager sharedInstance]isConnect])
    {
        SHOWMBProgressHUD(@"请连接设备", nil, nil, NO, 1.0);
        return;
    }
    
    if (index == 0)
    {
        [BLTSendModel sendBoindDeviceState:YES WithUpdateBlock:^(id object, BLTAcceptModelType type)
         {
             if (type == BLTAcceptModelTypeBindingSuccess)
             {
                 SHOWMBProgressHUD(@"绑定成功", nil, nil, NO, 1.0);
                 [BLTManager sharedInstance].model.isBoind = YES;
                 [BOINDUUID setObjectValue:[BLTManager sharedInstance].model.bltUUID];
             }
             else
             {
                 SHOWMBProgressHUD(@"绑定失败", nil, nil, NO, 1.0);
             }
        }];
    }
    else if (index == 1)
    {
        [BLTSendModel sendBoindDeviceState:NO WithUpdateBlock:^(id object, BLTAcceptModelType type)
         {
             if (type == BLTAcceptModelTypeRemoveBindingSuccess)
             {
                 SHOWMBProgressHUD(@"解绑成功", nil, nil, NO, 1.0);
                 [BLTManager sharedInstance].model.isBoind = NO;
                 [BOINDUUID setObjectValue:nil];
             }
             else
             {
                 SHOWMBProgressHUD(@"解绑失败", nil, nil, NO, 1.0);
             }
         }];
    }
    else if (index == 2)
    {
        [BLTSendModel sendControlTakePhotoState:YES WithUpdateBlock:^(id object, BLTAcceptModelType type)
         {
             if (type == BLTAcceptModelPhotoControl)
             {
                SHOWMBProgressHUD(@"开启拍照模式", nil, nil, NO, 1.0);
             }
             
         }];
    }
    else if (index == 3)
    {
        [BLTSendModel sendControlTakePhotoState:NO WithUpdateBlock:^(id object, BLTAcceptModelType type)
         {
             if (type == BLTAcceptModelPhotoControl)
             {
              SHOWMBProgressHUD(@"关闭拍照模式", nil, nil, NO, 1.0);
             }

         }];
    }
    else if (index == 4)
    {
        [BLTSendModel sendDeviceInfo:BLTsendDeviceBasicInfo WithUpdateBlock:^(id object, BLTAcceptModelType type)
         {
             if (type == BLTAcceptModelTypeDeviceInfo)
             {
                 NSArray *DeviceInfo = object;
                 [BLTManager sharedInstance].model.deviceID = DeviceInfo[0];
                 [BLTManager sharedInstance].model.firmWare = DeviceInfo[1];
                 [BLTManager sharedInstance].model.runType = DeviceInfo[2];
                 [BLTManager sharedInstance].model.batteryState = DeviceInfo[3];
                 [BLTManager sharedInstance].model.batteryValue = DeviceInfo[4];
                 [BLTManager sharedInstance].model.boindFlag =DeviceInfo[5];
                  SHOWMBProgressHUD(@"获取设备信息成功", nil, nil, NO, 0.5);
             }
         }];
    }
    else if (index == 5)
    {
        [BLTSendModel sendDeviceInfo:BLTsendDeviceBasicTime WithUpdateBlock:^(id object, BLTAcceptModelType type)
         {
             if (type == BLTAcceptModelTypeDeviceTime)
             {
               NSLog(@"DeviceBasicTime>>>%@",object);
                 NSArray *timeArray = object;
                 [BLTManager sharedInstance].model.time = timeArray[0];
                 [BLTManager sharedInstance].model.weekDays = timeArray[1];
                 [weakSelf updateViewData];
                  SHOWMBProgressHUD(@"获取设备时间成功", nil, nil, NO, 0.5);
             }
         }];
    }
    else if (index == 6)
    {
        [self updateDeviceInfo];
    }
}

// 获取设备信息>>> 同步时间>>> 设置用户信息>>> 同步数据
- (void)updateDeviceInfo
{
    [BLTSendModel sendDeviceInfo:BLTsendDeviceBasicInfo WithUpdateBlock:^(id object, BLTAcceptModelType type)
     {
         if (type == BLTAcceptModelTypeDeviceInfo)
         {
             NSArray *DeviceInfo = object;
             [BLTManager sharedInstance].model.deviceID = DeviceInfo[0];
             [BLTManager sharedInstance].model.firmWare = DeviceInfo[1];
             [BLTManager sharedInstance].model.runType = DeviceInfo[2];
             [BLTManager sharedInstance].model.batteryState = DeviceInfo[3];
             [BLTManager sharedInstance].model.batteryValue = DeviceInfo[4];
             [BLTManager sharedInstance].model.boindFlag =DeviceInfo[5];
             
             SHOWMBProgressHUD(@"获取设备信息成功", nil, nil, NO, 0.5);
             [self performSelector:@selector(sendDeviceInfo) withObject:nil afterDelay:BLT_InfoDelayTime];
         }
     }];
    
    [self updateViewUserData];
}

// 设置时间
- (void)sendDeviceInfo
{
    [BLTSendModel sendSetDeviceTimeWithUpdateBlock:^(id object, BLTAcceptModelType type) {
        if (type == BLTAcceptModelTypeSetDateInfo)
        {
            NSLog(@"时间设置成功>>>>");
            SHOWMBProgressHUD(@"时间设置成功", nil, nil, NO, 0.5);
            [self performSelector:@selector(sendUserInfo) withObject:nil afterDelay:BLT_InfoDelayTime];
        }
    }];
}

// 设置用户信息
- (void)sendUserInfo
{
    [BLTSendModel sendSetUserInfoWithUpdateBlock:^(id object, BLTAcceptModelType type) {
        if (type == BLTAcceptModelTypeSetUserInfo)
        {
            NSLog(@"用户设置成功>>>>");
            SHOWMBProgressHUD(@"用户信息设置成功", nil, nil, NO, 0.5);
            if ([BLTManager sharedInstance].model.isBoind)
            {
            [self performSelector:@selector(sendTarget) withObject:nil afterDelay:BLT_InfoDelayTime];
            }
        }
    }];
}

// 设置目标信息
- (void)sendTarget
{
    if ([[BLTManager sharedInstance]isConnect])
    {
        [BLTSendModel sendSetSportTargetWithUpdateBlock:^(id object, BLTAcceptModelType type) {
            if (type == BLTAcceptModelTypeSetSportTarget)
            {
            SHOWMBProgressHUD(@"目标设置成功.", nil, nil, NO, 0.5);
            }
        }];
    }
}

- (void)updateViewData
{
    _bltTime.text = [NSString stringWithFormat:@"%@",[BLTManager sharedInstance].model.time];
    _bltName.text = [NSString stringWithFormat:@"%@",[BLTManager sharedInstance].model.bltName];
    _bltRssi.text =  [NSString stringWithFormat:@"%@",[BLTManager sharedInstance].model.bltRSSI];
    _bltUuid.text =  [NSString stringWithFormat:@"%@",[BLTManager sharedInstance].model.bltUUID];
    
    if ([BLTManager sharedInstance].model.isBoind)
    {
     _bltBoind.text = @"绑定";
    }
    else
    {
     _bltBoind.text = @"未绑定";
    }
    
    _deiceID.text = [NSString stringWithFormat:@"%@",[BLTManager sharedInstance].model.deviceID];

    _firmwareVersion.text = [NSString stringWithFormat:@"%@",[BLTManager sharedInstance].model.firmWare];

    _runModel.text =  [NSString stringWithFormat:@"%@",[BLTManager sharedInstance].model.runType];
    _battState.text = [NSString stringWithFormat:@"%@",[BLTManager sharedInstance].model.batteryState];
    _battValue.text =  [NSString stringWithFormat:@"%@",[BLTManager sharedInstance].model.batteryValue];
}

- (void)updateViewUserData
{
    UserInfoModel *model = [UserInfoHelper sharedInstance].userModel;
    _userName.text = [NSString stringWithFormat:@"%@",model.userName];
    _age.text = [NSString stringWithFormat:@"%d",model.age];
    _sex.text = [model showGenderSex];
    _birthday.text = [NSString stringWithFormat:@"%@",model.birthDay];
    _height.text = [model showHeight];
    _wieght.text = [model showWeight];
    _targetStep.text = [NSString stringWithFormat:@"%d",model.targetSteps];
    _targetSleep.text = [NSString stringWithFormat:@"%d",model.targetSleep];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
