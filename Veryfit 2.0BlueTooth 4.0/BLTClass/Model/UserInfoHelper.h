//
//  UserInfoHelper.h
//  AJBracelet
//
//  Created by zorro on 15/7/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
#import "BLTModel.h"

#define AJ_HeadImage @"headImage.jpg"

@interface UserInfoHelper : NSObject

// 当前用户信息
@property (nonatomic, strong) UserInfoModel *userModel;

AS_SINGLETON(UserInfoHelper)

//// 移除用户头像
//- (void)removeUserHeadImage;
//
//// 缓存用户头像到本地.
//- (void)saveHeadImageToFileCacheWithPicker:(UIImagePickerController *)picker
//                                  withInfo:(NSDictionary *)info;
//
//// 获取用户头像.
//- (UIImage *)getUserHeadImage;
//
//// 设置闹钟.
//- (void)sendAlarmClockSetting;
//// 设置久坐提醒
//- (void)sendSedentaryRemindSetting;
//
//// 设置闹钟替换上面的.
//- (void)startSetAlarmClock;
//
//// 更新手环信息到蓝牙 暂时用不到.  isShow 是否需要提示 外部使用为YES.
//- (void)updateBraceletInfoToDevice:(BOOL)isShow;
//
//// 更新用户信息到蓝牙
//- (void)updateUserInfoToDevice:(BOOL)isShow;
//
//// 设置运动睡眠目标
//- (void)updateUserSportTargetAndSleepTarget:(BOOL)isShow;
//
//// 设置用户信息 和 设置运动睡眠目标
//- (void)updateUserInfoAndTarget;
//
//// 解绑当前设备
//- (void)unpairCurrentDeviceWithBackBlock:(NSObjectSimpleBlock)block;
//
//// 拍照模式
//- (void)sendPhotoControl:(BOOL)type;

@end
