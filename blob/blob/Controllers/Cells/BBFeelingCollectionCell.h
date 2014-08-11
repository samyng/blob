//
//  BBFeelingCollectionCell.h
//  blob
//
//  Created by Sam Yang on 8/6/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBFeeling;

@interface BBFeelingCollectionCell : UICollectionViewCell
- (void)configureWithFeeling:(BBFeeling *)feeling;
@property (strong, nonatomic) BBFeeling *feeling;
- (UIImage *)rasterizedImageCopy;
- (void)setToBlankState;
- (void)resetDefaultUI;
@property (weak, nonatomic) IBOutlet UILabel *feelingLabel;
@end
