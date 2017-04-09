//
//  LabelCell.h
//  Assignment
//
//  Created by Kimi Wu on 4/9/17.
//  Copyright © 2017 yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;

+ (CGSize)cellSizeWithData:(NSString *)data forWidth:(CGFloat)width;
+ (NSString *)nibIdentifier;

@end
