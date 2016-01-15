//
//  discoverTableViewCell.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/12.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "discoverTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface discoverTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headimage;
@property (weak, nonatomic) IBOutlet UILabel *headLable;



@end
@implementation discoverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(discoverModel *)model{
//    [self.headimage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.headLable.text = model.title;
    NSLog(@"%@",model.title);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
