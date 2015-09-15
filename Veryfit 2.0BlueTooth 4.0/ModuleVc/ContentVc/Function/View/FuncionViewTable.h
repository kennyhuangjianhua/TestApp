//
//  FuncionViewTable.h
//  Warm
//
//  Created by 黄建华 on 15/8/20.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FuncionViewTable : UITableView <UITableViewDataSource,UITableViewDelegate>

typedef void(^FuncionTableSelect) (NSInteger index);

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) FuncionTableSelect FuncionTableSelectBlock;

@end
