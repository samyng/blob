//
//  BBAccessoryCollectionCell.h
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBAccessory;

@interface BBAccessoryCollectionCell : UICollectionViewCell
- (void)configureWithAccessory:(BBAccessory *)accessory;
@end
