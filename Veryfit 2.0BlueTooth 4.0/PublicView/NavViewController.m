//
//  DeviceNavViewController.m
//  AJBracelet
//
//  Created by 黄建华 on 15/7/1.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadBgView];
    
}

- (void)loadBgView
{
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = AUTOCOLORPINK;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:16],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButton)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
    UIView * stateView = [[UIView alloc] initWithFrame:CGRectMake(0, - 20, self.view.width, 20)];
    stateView.backgroundColor = AUTOCOLORPINK;
    [self.navigationController.navigationBar addSubview:stateView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.bgImageNormal = @"back_6@2x.png";
    backButton.frame = CGRectMake(0, 0, 44, 44);
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backButton];
    
//    self.view.backgroundColor = AUTOCOLORSHALLOWPINK;
}

- (void)leftBarButton
{
    
}

- (void)rightBarButton
{
    
}

- (void)backButtonClick
{
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
