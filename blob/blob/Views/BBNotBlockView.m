//
//  BBNotBlockView.m
//  blob
//
//  Created by Sam Yang on 8/17/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBNotBlockView.h"
#import "BBBlockSlotParameterView.h"

@interface BBNotBlockView ()
@property (weak, nonatomic) IBOutlet UILabel *notLabel;
@property (weak, nonatomic) IBOutlet BBBlockSlotParameterView *rightSlot;

@end

@implementation BBNotBlockView

- (void)setLanguageBlock:(BBLanguageBlock *)languageBlock
{
    [super setLanguageBlock:languageBlock];
    [self updateUI];
}

- (void)updateUI
{
    self.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    self.rightSlot.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
}


- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    if (CGRectContainsPoint(self.rightSlot.frame, touchLocation) && [self.rightSlot acceptsBlockView:blockView])
    {
        blockView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGFloat xDifference = CGRectGetWidth(blockView.frame) - CGRectGetWidth(self.rightSlot.frame);
        CGFloat yDifference = CGRectGetHeight(blockView.frame) - CGRectGetHeight(self.rightSlot.frame);
        CGPoint blockSlotOrigin = self.rightSlot.frame.origin;
//        [self.delegate updateFrameForTouchedLanguageBlockView:self
//                                  andDraggedLanguageBlockView:blockView
//                                                          byX:xDifference
//                                                          byY:yDifference
//                                      withParameterViewOrigin:blockSlotOrigin];
        [self.snappedBlockViews addObject:blockView];
    }
}

- (CGSize)originalSize
{
    return CGSizeMake(114.0f, 55.0f);
}

@end
