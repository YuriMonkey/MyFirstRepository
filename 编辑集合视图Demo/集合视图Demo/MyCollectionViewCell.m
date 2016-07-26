//
//  MyCollectionViewCell.m
//  集合视图Demo
//
//  Created by zhongjunpan on 15/11/26.
//  Copyright (c) 2015年 zhimeng. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 20)];
        self.titleLabel.font = [UIFont systemFontOfSize:8];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"No Name";
        [self.contentView addSubview:self.titleLabel];
        
        //selectedBackgroundView可以不使用, 表示被选中（被单击后被选中，直到单击另一个）
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
        self.selectedBackgroundView.backgroundColor = [UIColor orangeColor];
        
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

@end
