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
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        
        if (xDifference >= MARGIN_OF_ERROR_CONSTANT)
        {
            width += xDifference;
        }
        if (yDifference >= MARGIN_OF_ERROR_CONSTANT)
        {
            height += yDifference;
        }
        
        CGPoint blockSlotOrigin = self.rightSlot.frame.origin;
        [self.delegate updateFrameForTouchedLanguageBlockView:self
                                  andDraggedLanguageBlockView:blockView
                                                          withWidth:width
                                                          withHeight:height
                                      withParameterViewOrigin:blockSlotOrigin];
        [self.snappedBlockViews addObject:blockView];
    }
}

- (void)untouchedByLanguageBlockView:(BBLanguageBlockView *)blockView fromStartingOrigin:(CGPoint)blockViewStartingOrigin
{
    if ([self.snappedBlockViews containsObject:blockView])
    {
        [self.snappedBlockViews removeObject:blockView];
        CGPoint blockSlotOrigin = self.rightSlot.frame.origin;
        [self.delegate updateFrameForTouchedLanguageBlockView:self
                                  andDraggedLanguageBlockView:blockView
                                                    withWidth:[self originalSize].width
                                                   withHeight:[self originalSize].height
                                      withParameterViewOrigin:blockSlotOrigin];
    }
}

- (CGSize)originalSize
{
    return CGSizeMake(114.0f, 55.0f);
}

@end
