//
//  UserInfoHelper.m
//  AJBracelet
//
//  Created by zorro on 15/7/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserInfoHelper.h"
#import "BLTSendModel.h"
#import "XYSandbox.h"

@implementation UserInfoHelper

DEF_SINGLETON(UserInfoHelper)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [ShareData sharedInstance].isAllowUserInfoSave = NO;
        _userModel = [UserInfoModel getUserInfoFromDB];
        [ShareData sharedInstance].isAllowUserInfoSave = YES;
    }
    
    return self;
}

// 保证一直持有最新的bltmodel. 所以有可能这一次与上一次返回的完全不一样...
//- (BLTModel *)bltModel
//{
//    BLTModel *model = [BLTManager sharedInstance].model;
//    
//    if (model)
//    {
//        _bltModel = model;
//    }
//    else
//    {
//        model = [BLTModel getModelFromDBWtihUUID:[AJ_LastWareUUID getObjectValue]];
//        if (model)
//        {
//            _bltModel = model;
//        }
//        else
//        {
//            model = [BLTModel initWithUUID:[AJ_LastWareUUID getObjectValue]];
//            _bltModel = model;
//        }
//    }
//    
//    return _bltModel;
//}
//
//- (void)removeUserHeadImage
//{
//    NSString *filePath = [self getUserHeadImageFilePath];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    [fileManager removeItemAtPath:filePath error:nil];
//}
//
//// 缓存用户头像到本地.
//- (void)saveHeadImageToFileCacheWithPicker:(UIImagePickerController *)picker withInfo:(NSDictionary *)info
//{
//    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//    UIImage *scaleImage = [image imageScaleToSize:CGSizeMake(200.0, 200.0)];
//    
//    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
//    {
//        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
//    }
//    
//    NSString *filePath = [self getUserHeadImageFilePath];
//    NSData *data = UIImageJPEGRepresentation(scaleImage, 1.0);
//    
//    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
//}
//
//// 获取用户头像.
//- (UIImage *)getUserHeadImage
//{
//    NSString *filePath = [self getUserHeadImageFilePath];
//    
//    if ([self completePathDetermineIsThere:filePath])
//    {
//        return [UIImage imageWithPath:filePath];
//    }
//    else
//    {
//        // 默认头像图片
//        return UIImageNamed(@"mine_big_circle_5s@2x.png");
//    }
//}
//
//- (NSString *)getUserHeadImageFilePath
//{
//    NSString *headFold = [[XYSandbox libCachePath] stringByAppendingPathComponent:AJ_FileCache_HeadImage];
//    NSString *filePath = [headFold stringByAppendingPathComponent:AJ_HeadImage];
//    
//    return filePath;
//}
//
//- (void)sendAlarmClockSetting
//{
//    if ([BLTManager sharedInstance].isConnected)
//    {
//        if (_bltModel.alarmArray.count > _alarmCount)
//        {
//            AlarmClockModel *model = _bltModel.alarmArray[_alarmCount];
//            
//            NSLog(@"model.isChanged>>>>%i..%d",model.isChanged, _alarmCount);
//            
//            if (model.isChanged)
//            {
//                [BLTSendModel sendSetDeviceAlarmClock:model
//                                      withUpdateBlock:^(id object, BLTAcceptModelType type) {
//                                          if (type == BLTAcceptModelTypeSetAlarmClock)
//                                          {
//                                              // NSString *title = [NSString stringWithFormat:@"闹钟%ld设置成功", (long)_alarmCount];
//                                              // SHOWMBProgressHUD(title, nil, nil, NO, 2.0);
//                                              model.isChanged = NO;
//                                          }
//                                          else
//                                          {
//                                              // _alarmCount--;
//                                          }
//                                          
//                                          _alarmCount ++;
//                                          
//                                          [self performSelector:@selector(sendAlarmClockSetting)
//                                                     withObject:nil
//                                                     afterDelay:BLT_InfoDelayTime];
//                                      }];
//            }
//            else
//            {
//                _alarmCount ++;
//                
//                [self performSelector:@selector(sendAlarmClockSetting)
//                           withObject:nil
//                           afterDelay:BLT_InfoDelayTime];
//            }
//        }
//        else if (_bltModel.alarmArray.count == _alarmCount)
//        {
//            SHOWMBProgressHUD(@"设置成功.", nil, nil, NO, 2.0);
//        }
//        
//    }
//    else
//    {
//        SHOWMBProgressHUD(@"设备未连接.", nil, nil, NO, 2.0);
//    }
//}
//
//- (void)startSetAlarmClock
//{
//    _alarmCount = 0;
//    [self sendAlarmClockSetting];
//}
//
//- (void)sendSedentaryRemindSetting
//{
//    if ([BLTManager sharedInstance].isConnected)
//    {
//        RemindModel *model = [_bltModel.remindArray lastObject];
//
//        [BLTSendModel sendSetDeviceSedentaryRemind:model withUpdateBlock:^(id object, BLTAcceptModelType type) {
//            if (type == BLTAcceptModelTypeSetRemind)
//            {
//                SHOWMBProgressHUD(@"设置成功.", nil, nil, NO, 2.0);
//            }
//        }];
//    }
//    else
//    {
//        SHOWMBProgressHUD(@"设备未连接.", nil, nil, NO, 2.0);
//    }
//}
//
//// 拍照模式
//- (void)sendPhotoControl:(BOOL)type
//{
//    if ([BLTManager sharedInstance].isConnected)
//    {
//        [BLTSendModel sendControlTakePhotoState:type WithUpdateBlock:^(id object, BLTAcceptModelType type)
//        {
//            if (type == BLTAcceptModelPhotoControl)
//            {
//                NSLog(@"拍照模式  object>>>>>>%@",object);
//                if (type)
//                {
////                 SHOWMBProgressHUD(@"开启拍照", nil, nil, NO, 1.0);
//                }
//                else
//                {
////                  SHOWMBProgressHUD(@"关闭拍照", nil, nil, NO, 1.0);
//                }
//                
//            }
//        }];
//    }
//}
//
//- (void)updateBraceletInfoToDevice:(BOOL)isShow
//{
//    
//}
//
//- (void)updateUserInfoToDevice:(BOOL)isShow
//{
//    if ([BLTManager sharedInstance].isConnected)
//    {
//        [BLTSendModel sendSetUserInfoWithUpdateBlock:^(id object, BLTAcceptModelType type) {
//            if (type == BLTAcceptModelTypeSetUserInfo)
//            {
//                if (isShow)
//                {
//                    SHOWMBProgressHUD(@"设置成功.", nil, nil, NO, 2.0);
//                }
//            }
//        }];
//    }
//    else
//    {
//        SHOWMBProgressHUD(@"设备未连接.", nil, nil, NO, 2.0);
//    }
//}
//
//- (void)updateUserSportTargetAndSleepTarget:(BOOL)isShow
//{
//    if ([BLTManager sharedInstance].isConnected)
//    {
//        [BLTSendModel sendSetSportTargetWithUpdateBlock:^(id object, BLTAcceptModelType type) {
//            if (type == BLTAcceptModelTypeSetSportTarget)
//            {
//                if (isShow)
//                {
//                    SHOWMBProgressHUD(@"设置成功.", nil, nil, NO, 2.0);
//                }
//            }
//        }];
//    }
//    else
//    {
//        SHOWMBProgressHUD(@"设备未连接.", nil, nil, NO, 2.0);
//    }
//}
//
//// 目前蓝牙省电模式 不适宜一起延迟发送.必须一个接一个的发送指令
//- (void)updateUserInfoAndTarget
//{
//    if ([BLTManager sharedInstance].isConnected)
//    {
//        [BLTSendModel sendSetUserInfoWithUpdateBlock:^(id object, BLTAcceptModelType type) {
//            if (type == BLTAcceptModelTypeSetUserInfo)
//            {
//                [self performSelector:@selector(delaySettingUserSportTargetAndSleepTarget)
//                           withObject:nil
//                           afterDelay:BLT_InfoDelayTime];
//            }
//        }];
//    }
//    else
//    {
//        SHOWMBProgressHUD(@"设备未连接.", nil, nil, NO, 2.0);
//    }
//}
//
//- (void)delaySettingUserSportTargetAndSleepTarget
//{
//    [self updateUserSportTargetAndSleepTarget:NO];
//}
//
//// 解绑当前设备
//- (void)unpairCurrentDeviceWithBackBlock:(NSObjectSimpleBlock)block
//{
//    if ([BLTManager sharedInstance].isConnected)
//    {
//      [BLTSendModel sendDeviceBindingWithCMDType:BLTDeviceUnbundling withUpdateBlock:^(id object, BLTAcceptModelType type) {
//          if (type == BLTAcceptModelTypeUnBindingSuccess)
//          {
//              [UserInfoHelper sharedInstance].bltModel.isBinding = NO;
//              SHOWMBProgressHUD(@"解绑成功", nil, nil, NO, 2.0);
//              
//              if (block)
//              {
//                  block(@(YES));
//              }
//          }
//      }];
//    }
//    else
//    {
//        SHOWMBProgressHUD(@"设备未连接.", nil, nil, NO, 2.0);
//    }
//}

@end
