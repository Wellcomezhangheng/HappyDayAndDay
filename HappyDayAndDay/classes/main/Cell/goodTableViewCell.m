//
//  goodTableViewCell.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/11.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "goodTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface goodTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLable;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLable;

@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLable;
@property (weak, nonatomic) IBOutlet UILabel *loveCountLable;


    

@end
@implementation goodTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(goodActivityModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.image]placeholderImage:nil];
    
    self.activityTitleLable.text = model.title;
    self.activityPriceLable.text = model.price;
    self.ageLable.text = model.age;
    self.loveCountLable.text = [NSString stringWithFormat:@"%@",model.counts];
    
    
    //
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
