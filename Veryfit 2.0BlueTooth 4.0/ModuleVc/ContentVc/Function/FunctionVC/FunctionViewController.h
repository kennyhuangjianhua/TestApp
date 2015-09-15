//
//  FunctionViewController.h
//  Warm
//
//  Created by 黄建华 on 15/8/18.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"
#import "FuncionViewTable.h"

@interface FunctionViewController : NavViewController <BLTControlTypeDelegate>

@property (weak, nonatomic) IBOutlet NavButton *photoControl;
@property (weak, nonatomic) IBOutlet UILabel *bltName;
@property (weak, nonatomic) IBOutlet UILabel *bltUuid;
@property (weak, nonatomic) IBOutlet UILabel *deiceID;
@property (weak, nonatomic) IBOutlet UILabel *firmwareVersion;
@property (weak, nonatomic) IBOutlet UILabel *runModel;
@property (weak, nonatomic) IBOutlet UILabel *battState;
@property (weak, nonatomic) IBOutlet UILabel *battValue;

@property (weak, nonatomic) IBOutlet UILabel *bltRssi;

@property (weak, nonatomic) IBOutlet UILabel *bltBoind;
@property (weak, nonatomic) IBOutlet UILabel *bltTime;

@property (weak, nonatomic) IBOutlet UILabel *wieght;
@property (weak, nonatomic) IBOutlet UILabel *targetStep;
@property (weak, nonatomic) IBOutlet UILabel *targetSleep;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *sex;

@property (weak, nonatomic) IBOutlet UILabel *age;

@property (weak, nonatomic) IBOutlet UILabel *height;

@property (weak, nonatomic) IBOutlet UILabel *birthday;


@end
