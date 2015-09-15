//
//  DeviceTableViewCell.h
//  Warm
//
//  Created by 黄建华 on 15/8/10.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceTableViewCell : UITableViewCell

@property (nonatomic, strong) NavLabel *deviceName;
@property (nonatomic, strong) NavLabel *deviceUuid;
@property (nonatomic, strong) NavLabel *rssi;
@property (nonatomic, strong) UIImageView *selectImage;

- (void)updateBltModel:(BltModel *)model;

@end
