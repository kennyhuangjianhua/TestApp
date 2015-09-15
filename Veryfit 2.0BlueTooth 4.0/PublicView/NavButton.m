//
//  NavButton.m
//  Warm
//
//  Created by 黄建华 on 15/8/4.
//  Copyright (c) 2015年 kenny. All rights reserved.
//

#import "NavButton.h"

@implementation NavButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self loadbutton];
    }
    return self;
}

- (void)loadbutton
{
    self.backgroundColor = AUTOCOLORDEEPPINK;
    [self setTitleColor:NAVCOLORWHITE forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.titleLabel setFont:AUTOFONTSIZE(14.0)];
    [self.titleLabel setFont:NAVFONTSIZE];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
