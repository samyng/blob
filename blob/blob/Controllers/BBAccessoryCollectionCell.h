//
//  BBAccessoryCollectionCell.h
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBAccessory.h"

@interface BBAccessoryCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
- (void)configureWithAccessory:(BBAccessory *)accessory;
@end
