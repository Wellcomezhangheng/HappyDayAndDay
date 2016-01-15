//
//  HotTableViewCell.m
//  HappyDayAndDay
//
//  Created by scjy on 16/1/10.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "HotTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HotTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *ima;
@property (weak, nonatomic) IBOutlet UILabel *countsLabel;



@end
@implementation HotTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(hotModel *)model{
    [self.ima sd_setImageWithURL:[NSURL URLWithString:model.ima]placeholderImage:nil];
   // NSLog(@"%@",self.ima);
    self.countsLabel.text = model.counts;
   // NSLog(@"%@",model.counts);
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

@end
