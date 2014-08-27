//
//  BBIfThenElseBlockView.m
//  blob
//
//  Created by Sam Yang on 8/17/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBIfThenElseBlockView.h"
#import "BBBlockSlotParameterView.h"
#import "BBBlockStackParameterView.h"

@interface BBIfThenElseBlockView ()
@property (weak, nonatomic) IBOutlet BBBlockSlotParameterView *blockSlot;
@property (weak, nonatomic) IBOutlet BBBlockStackParameterView *topBlockStack;
@property (weak, nonatomic) IBOutlet BBBlockStackParameterView *bottomBlockStack;
@property (nonatomic) BOOL hasTopStackBlock;
@end

@implementation BBIfThenElseBlockView

- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    if (CGRectContainsPoint(self.blockSlot.frame, touchLocation) && [self.blockSlot acceptsBlockView:blockView])
    {
        CGFloat newWidth = CGRectGetWidth(self.frame);
        CGFloat xDifference = CGRectGetWidth(blockView.frame) - CGRectGetWidth(self.blockSlot.frame);
        if (abs(xDifference) >= MARGIN_OF_ERROR_CONSTANT) // only change width if the difference is nontrivial
        {
            newWidth += xDifference;
        }
        CGPoint blockSlotOrigin = self.blockSlot.frame.origin;
        [self.delegate updateFrameForTouchedLanguageBlockView:self
                                  andDraggedLanguageBlockView:blockView
                                                    withWidth:newWidth
                                                   withHeight:CGRectGetHeight(self.frame)
                                      withParameterViewOrigin:blockSlotOrigin];
        [self.snappedBlockViews addObject:blockView];
        self.hasSlotBlock = YES;
    }
    else if (CGRectContainsPoint(self.topBlockStack.frame, touchLocation) && [self.topBlockStack acceptsBlockView:blockView])
    {
        [self updateFrameForBlockStack:self.topBlockStack withBlockView:blockView];
        [self.snappedBlockViews addObject:blockView];
    }
    else if (CGRectContainsPoint(self.bottomBlockStack.frame, touchLocation) && [self.bottomBlockStack acceptsBlockView:blockView])
    {
        [self updateFrameForBlockStack:self.bottomBlockStack withBlockView:blockView];
        [self.snappedBlockViews addObject:blockView];
    }
}

- (void)untouchedByLanguageBlockView:(BBLanguageBlockView *)blockView fromStartingOrigin:(CGPoint)blockViewStartingOrigin
{
    if ([self.snappedBlockViews containsObject:blockView])
    {
        [self.snappedBlockViews removeObject:blockView];
    }
    if ([self.snappedBlockViews count] == 0)
    {
        self.frame = [self originalFrame];
    }
}

- (CGSize)originalSize
{
    return CGSizeMake(210.0f, 246.0f);
}

- (NSInteger)numberOfAdditionalStackBlockSpaces
{
    NSInteger toSubtract = 0;
    if (self.hasSlotBlock)
    {
        toSubtract = 3;
    }
    if (self.hasTopStackBlock)
    {
        toSubtract += 1;
    }
    if (!self.hasSlotBlock && !self.hasTopStackBlock)
    {
        toSubtract = 1;
    }
    return [self.snappedBlockViews count] - toSubtract;
}

@end
