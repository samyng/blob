//
//  BBLanguageBlockCollectionCell.h
//  blob
//
//  Created by Sam Yang on 8/7/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBLanguageBlock;

@interface BBLanguageBlockCollectionCell : UICollectionViewCell
- (void)configureWithLanguageBlock:(BBLanguageBlock *)block;
@end
