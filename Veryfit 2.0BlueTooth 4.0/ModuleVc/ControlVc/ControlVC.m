//
//  ControlVC.m
//  AJBracelet
//
//  Created by zorro on 15/6/17.
//  Copyright (c) 2015年 zorro. All rights reserved.
//

#import "ControlVC.h"
#import "TabBarButton.h"
#import "HomeViewController.h"

@interface ControlVC ()

@end

@implementation ControlVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view.
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

+ (id)simpleInit
{
    
    HomeViewController *homePageView = [[HomeViewController alloc] init];
    
//    HotMoxibustionVc *vc1 = [[HotMoxibustionVc alloc] init];
//    HealthManagementVc *vc2 = [[HealthManagementVc alloc] init];
//    MineVc *vc3 = [[MineVc alloc] init];

    NSArray *vcArray = @[homePageView];
    NSMutableArray *itemsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *imageArray = @[@""];
    NSArray *selImageArray = @[@""];
    NSArray *titleArray = @[@"Home"];
    
    for (int i = 0; i < vcArray.count; i++)
    {
        TabBarButton *button = [[TabBarButton alloc] initWithFrame:CGRectMake(0, 0, homePageView.view.width , 50)];
        
         button.exclusiveTouch = YES;
        [button setNomarlImage:imageArray[i] withTitle:titleArray[i] withTextColor:[UIColor whiteColor]];
        [button setSelectorlImage:selImageArray[i] withTitle:titleArray[i] withTextColor:AUTOCOLORDEEPPINK];
         button.selected = NO;
        
        [itemsArray addObject:button];
    }
    
    ControlVC *tabBarController = [[ControlVC alloc] initWithViewControllers:vcArray items:itemsArray];
    
    return tabBarController;
}


@end
