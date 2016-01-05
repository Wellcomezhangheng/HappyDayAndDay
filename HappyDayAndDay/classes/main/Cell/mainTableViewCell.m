//
//  mainTableViewCell.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "mainTableViewCell.h"

@interface mainTableViewCell ()



@property (weak, nonatomic) IBOutlet UIImageView *op;
@property (weak, nonatomic) IBOutlet UILabel *activityNameLable;//活动名称

@property (weak, nonatomic) IBOutlet UILabel *activityMoney;//活动价格
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceButton;//活动距离


@end


@implementation mainTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
