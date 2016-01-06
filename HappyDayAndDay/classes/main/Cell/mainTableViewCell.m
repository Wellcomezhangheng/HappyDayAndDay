//
//  mainTableViewCell.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/4.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "mainTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface mainTableViewCell ()


@property (weak, nonatomic) IBOutlet UILabel *lable;

@property (weak, nonatomic) IBOutlet UIImageView *op;

@property (weak, nonatomic) IBOutlet UILabel *activityMoney;//活动价格
@property (weak, nonatomic) IBOutlet UIButton *activityDistanceButton;//活动距离


@end


@implementation mainTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.image.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 186);
//    [self.contentView addSubview:self.image];
}


- (void)setModel:(mainModel *)model{
    [self.op sd_setImageWithURL:[NSURL URLWithString:model.image_big]placeholderImage:nil];
    self.lable.text = model.title;
   
    self.activityMoney.text = model.price;

    if ([model.type integerValue]!=recommendTypeAcitivity) {
        self.activityDistanceButton.hidden = YES;
    }else{
        self.activityDistanceButton.hidden = NO;
    }
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
