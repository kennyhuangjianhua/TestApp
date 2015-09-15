//
//  Datemodel.h
//  money
//
//  Created by bodyconn on 14/12/17.
//  Copyright (c) 2014年 bodyconn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotmoxibustionModel : NSObject

@property (nonatomic, strong) NSString *modelTitle;
@property (nonatomic, strong) NSString *temperature;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL isOn;

+ (NSArray *)getHotmoxibustionModelModel;

@end
