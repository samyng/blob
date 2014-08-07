//
//  BBFeelingCollectionCell.h
//  blob
//
//  Created by Sam Yang on 8/6/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBFeelingCollectionCell : UICollectionViewCell
- (void)configureWithName:(NSString *)name;
- (UIImage *)getRasterizedImageCopy;
@property (weak, nonatomic) IBOutlet UILabel *feelingLabel;
@end
