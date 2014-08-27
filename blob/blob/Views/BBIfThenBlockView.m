//
//  BBIfThenBlockView.m
//  blob
//
//  Created by Sam Yang on 8/17/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBIfThenBlockView.h"
#import "BBBlockSlotParameterView.h"
#import "BBBlockStackParameterView.h"
#import "BBReactionBlockView.h"

const CGFloat marginOfErrorConstant = 2.0f;

@interface BBIfThenBlockView ()
@property (weak, nonatomic) IBOutlet BBBlockSlotParameterView *blockSlot;
@property (weak, nonatomic) IBOutlet BBBlockStackParameterView *blockStack;
@end

@implementation BBIfThenBlockView

- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    if (CGRectContainsPoint(self.blockSlot.frame, touchLocation) && [self.blockSlot acceptsBlockView:blockView])
    {
        CGFloat newWidth = CGRectGetWidth(self.frame);
        CGFloat xDifference = CGRectGetWidth(blockView.frame) - CGRectGetWidth(self.blockSlot.frame);
        if (xDifference >= marginOfErrorConstant) // only change width if the difference is nontrivial
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
    else if (CGRectContainsPoint(self.blockStack.frame, touchLocation) && [self.blockStack acceptsBlockView:blockView])
    {
        [self updateFrameForBlockStack:self.blockStack withBlockView:blockView];
        [self.snappedBlockViews addObject:blockView];
    }
}

- (void)untouchedByLanguageBlockView:(BBLanguageBlockView *)blockView fromStartingOrigin:(CGPoint)blockViewStartingOrigin
{
    if ([self.snappedBlockViews containsObject:blockView])
    {
        [self.snappedBlockViews removeObject:blockView];
        CGPoint translatedPoint = CGPointMake(self.frame.origin.x + self.blockSlot.frame.origin.x, self.frame.origin.y + self.blockSlot.frame.origin.y);
        
        if (CGPointEqualToPoint(translatedPoint, blockViewStartingOrigin))
        {
            self.hasSlotBlock = NO;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self originalSize].width, self.frame.size.height);
        }
        else
        {
            [self updateFrameForBlockStack:self.blockStack withBlockView:blockView];
        }
    }
}

- (CGSize)originalSize
{
    return CGSizeMake(210.0f, 159.0f);
}

@end
