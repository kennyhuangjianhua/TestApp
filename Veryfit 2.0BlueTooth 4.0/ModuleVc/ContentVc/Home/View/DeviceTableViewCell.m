//
//  DeviceTableViewCell.m
//  Warm
//
//  Created by 黄建华 on 15/8/10.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "DeviceTableViewCell.h"

@implementation DeviceTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
     [self loadcell];
    }
    return self;
}

- (void)loadcell
{
    _deviceName = [[NavLabel alloc] init];
    _deviceUuid = [[NavLabel alloc] init];
    _rssi = [[NavLabel alloc] init];
    _deviceName.frame = CGRectMake(10, 0, self.width, 20);
    _deviceUuid.frame = CGRectMake(10, 20, self.width, 20);
    _rssi.frame = CGRectMake(10, 40, 50, 20);
    _selectImage = [[UIImageView alloc] init];
    
    _selectImage.image = [UIImage imageNamed:@"login_right_5s@2x.png"];
    _selectImage.hidden = YES;
    _selectImage.frame = CGRectMake(self.width , 15, 18, 14);
    [self addSubview:_selectImage];
    
    [self addSubview:_deviceName];
    [self addSubview:_deviceUuid];
    [self addSubview:_rssi];
}

- (void)updateBltModel:(BltModel *)model
{
    _deviceName.text = model.bltName;
    _rssi.text = model.bltRSSI;
    _deviceUuid.text = model.bltUUID;
    if (model.peripheral.state == CBPeripheralStateConnected)
    {
        _selectImage.hidden = NO;
        // SHOWMBProgressHUD(@"设备已连接", nil, nil, NO, 2.0);
    }
    else
    {
        _selectImage.hidden = YES;
    }
}

@end
