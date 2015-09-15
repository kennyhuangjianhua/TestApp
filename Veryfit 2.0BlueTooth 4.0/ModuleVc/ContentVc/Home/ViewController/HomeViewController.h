//
//  HomeViewController.h
//  Warm
//
//  Created by 黄建华 on 15/8/10.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceTableViewCell.h"
#import "FunctionViewController.h"

@interface HomeViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *deviceList;
@property (nonatomic, strong) NavButton *scanButton;
@end
