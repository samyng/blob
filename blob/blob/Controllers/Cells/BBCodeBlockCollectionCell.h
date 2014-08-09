//
//  BBCodeBlockCollectionCell.h
//  blob
//
//  Created by Sam Yang on 8/7/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBLanguageBlock;

@interface BBCodeBlockCollectionCell : UICollectionViewCell
- (void)configureWithBlock:(BBLanguageBlock *)block;
@end
