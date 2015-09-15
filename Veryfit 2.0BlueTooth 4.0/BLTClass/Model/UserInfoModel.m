//
//  UserInfoModel.m
//  AJBracelet
//
//  Created by zorro on 15/7/6.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _userName = AJ_UserName; //这个不能修改. 目前为单用户使用.
        _nickName = AJ_UserName;

        _avatar = @"http://www.woyo.li/statics/users/avatar/46/thumbs/200_200_46.jpg?1422252425";
        _birthDay = @"1990-01-01";
        
        _interest = @"";
        _manifesto = @"";
        _age = 25;
        _isMetricSystem = YES;
        _genderSex = 0;
        
        _weight = 70;
        _targetSleep = 60 * 8;
        _targetSteps = 12000;
        _height = 170;
        
        _alarmTypeArray = @[@"起床", @"睡觉", @"锻炼", @"吃药", @"约会", @"聚会", @"会议", @"自定义"];
    }
    
    return self;
}

+ (UserInfoModel *)getUserInfoFromDB
{
    NSString *where = [NSString stringWithFormat:@"userName = '%@'", AJ_UserName];
    UserInfoModel *model = [UserInfoModel searchSingleWithWhere:where orderBy:nil];
    
    if (!model)
    {
        model = [[UserInfoModel alloc] init];
        
        [model saveToDB];
    }
    
    return model;
}

- (BOOL)addAlarmClockType:(NSString *)string
{
    if ([_alarmTypeArray containsObject:string])
    {
        return NO;
    }
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < _alarmTypeArray.count; i++)
    {
        if (i == _alarmTypeArray.count - 1)
        {
            [array addObject:string];
        }
        
        [array addObject:_alarmTypeArray[i]];
    }
    
    self.alarmTypeArray = array;
    
    return YES;
}

- (NSString *)showGenderSex
{
    return  _genderSex ? @"女性" : @"男性";
}

- (NSString *)showHeight
{
    if ([SAVEENTERUSERKEY getBOOLValue])
    {
        return [NSString stringWithFormat:@"%d", _height];
    }
    else
    {
        if (_genderSex)
        {
            return @"160";
        }
        else
        {
            return @"170";
        }
    }
}

- (NSString *)showWeight
{
    if ([SAVEENTERUSERKEY getBOOLValue])
    {
        return [NSString stringWithFormat:@"%d", _weight];
    }
    else
    {
        if (_genderSex)
        {
            return @"50";
        }
        else
        {
            return @"70";
        }
    }
}

- (void)setManifesto:(NSString *)manifesto
{
    _manifesto = manifesto;
    [self updateCurrentModelInDB];
}

- (void)setInterest:(NSString *)interest
{
    _interest = interest;
    [self updateCurrentModelInDB];
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    [self updateCurrentModelInDB];
}

- (void)setStep:(CGFloat)step
{
    _step = step;
    [self updateCurrentModelInDB];
}

- (void)setTargetSteps:(NSInteger)targetSteps
{
    _targetSteps = targetSteps;
    [self updateCurrentModelInDB];
}

- (void)setTargetSleep:(NSInteger)targetSleep
{
    _targetSleep = targetSleep;
    [self updateCurrentModelInDB];
}

- (void)setGenderSex:(NSInteger)genderSex
{
    _genderSex = genderSex;
    [self updateCurrentModelInDB];
}

- (void)setWeight:(NSInteger)weight
{
    _weight = weight;
    [self updateCurrentModelInDB];
}

- (void)setHeight:(NSInteger)height
{
    _height = height;
    [self updateCurrentModelInDB];
}

- (void)setIsMetricSystem:(BOOL)isMetricSystem
{
    _isMetricSystem = isMetricSystem;
    [self updateCurrentModelInDB];
}

- (void)setBirthDay:(NSString *)birthDay
{
    _birthDay = birthDay;
    [self updateCurrentModelInDB];
}

- (void)updateCurrentModelInDB
{
    if ([ShareData sharedInstance].isAllowUserInfoSave)
    {
        [UserInfoModel updateToDB:self where:nil];
    }
}

// 表名
+ (NSString *)getTableName
{
    return @"UserInfoModel";
}

// 主键
+ (NSString *)getPrimaryKey
{
    return @"userName";
}

// 表版本
+ (int)getTableVersion
{
    return 1;
}

+ (void)initialize
{
    //remove unwant property
    //比如 getTableMapping 返回nil 的时候   会取全部属性  这时候 就可以 用这个方法  移除掉 不要的属性
    
    [self removePropertyWithColumnName:@"avatar"];
    [self removePropertyWithColumnName:@"headImage"];
    [self removePropertyWithColumnName:@"interest"];
    [self removePropertyWithColumnName:@"manifesto"];
    [self removePropertyWithColumnName:@"headImage"];

    [self removePropertyWithColumnName:@"showGenderSex"];
    [self removePropertyWithColumnName:@"showHeight"];
    [self removePropertyWithColumnName:@"showWeight"];
}

@end
