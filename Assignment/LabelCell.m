//
//  LabelCell.m
//  Assignment
//
//  Created by Kimi Wu on 4/9/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import "LabelCell.h"


@implementation LabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString *)nibIdentifier
{
    return @"LabelCell";
}

+ (CGSize)cellSizeWithData:(NSString *)data forWidth:(CGFloat)width
{
    if (!data) {
        return CGSizeZero;
    }
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    titleLabel.numberOfLines = 0;
    titleLabel.text = data;
    CGSize size = [titleLabel sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
    return CGSizeMake(width, size.height);
}

@end
