//
//  FuncionViewTable.m
//  Warm
//
//  Created by 黄建华 on 15/8/20.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "FuncionViewTable.h"

@implementation FuncionViewTable

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        self.delegate = self;
        self.dataSource  = self;
        [self loadTable];
    }
    return self;
}

-(void)setExtraCellLineHidden:(UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColorHEX(0x272727);
    [self setTableFooterView:view];
}

- (void)loadTable
{
    _titleArray = [[NSArray alloc] initWithObjects:@"绑定",@"解绑",@"开启拍照",@"关闭拍照",
                   @"获取设备基本信息",@"获得设备时间", @"更新所有信息",nil];
    [self reloadData];
    [self setExtraCellLineHidden:self];
}

- (NSInteger )numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *ListViewCellId = @"FunctionTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ListViewCellId];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ListViewCellId];
    }
    
    cell.backgroundColor = AUTOCOLORDEEPPINK;
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    return  cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (_FuncionTableSelectBlock)
   {
       _FuncionTableSelectBlock (indexPath.row);
   }
}

@end
