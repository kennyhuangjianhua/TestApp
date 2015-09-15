//
//  Datemodel.m
//  money
//
//  Created by bodyconn on 14/12/17.
//  Copyright (c) 2014年 bodyconn. All rights reserved.
//

#import "HotmoxibustionModel.h"

@implementation HotmoxibustionModel

+ (void)initialize
{
    if (self == [HotmoxibustionModel class])
    {
        LKDBHelper *lkdb = [LKDBHelper getUsingLKDBHelper];
        
        // 创建表
        [lkdb createTableWithModelClass:[self class]];
    }
}
// 主建
+ (NSString *)getPrimaryKey
{
    return @"modelTitle";
}

// 表名
+ (NSString *)getTableName
{
    return @"HotmoxibustionModelTable";
}
// 表版本
+ (int)getTableVersion
{
    return 1;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    

    }
    
    return self;
}

+ (NSArray *)getHotmoxibustionModelModel
{
    NSArray *array= [HotmoxibustionModel searchWithWhere:nil orderBy:nil offset:0 count:-1];
    
    return array;
}

@end
