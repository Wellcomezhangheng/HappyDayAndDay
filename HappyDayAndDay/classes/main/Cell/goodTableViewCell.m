//
//  goodTableViewCell.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/8.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "goodTableViewCell.h"
@interface goodTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *activityPriceLable;
@property (weak, nonatomic) IBOutlet UILabel *activityDistanceLable;
@property (weak, nonatomic) IBOutlet UIButton *loveCountButton;
@property (weak, nonatomic) IBOutlet UIImageView *ageImageView;




@end



@implementation goodTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    
    self.frame = CGRectMake(0, 0, kWidth, 90);
    
}
- (void)setModel:(goodActivityModel *)model{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
