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

@end

@implementation BBIfThenElseBlockView

- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    if (CGRectContainsPoint(self.blockSlot.frame, touchLocation) && [self.blockSlot acceptsBlockView:blockView])
    {
        blockView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        CGFloat xDifference = CGRectGetWidth(blockView.frame) - CGRectGetWidth(self.blockSlot.frame);
//        CGFloat yDifference = CGRectGetHeight(blockView.frame) - CGRectGetHeight(self.blockSlot.frame);
//        CGPoint blockSlotOrigin = self.blockSlot.frame.origin;
//        [self.delegate updateFrameForTouchedLanguageBlockView:self
//                                  andDraggedLanguageBlockView:blockView
//                                                          byX:xDifference
//                                                          byY:yDifference
//                                      withParameterViewOrigin:blockSlotOrigin];
        [self.snappedBlockViews addObject:blockView];
    }
    // hack - will only accept one block for now hack until find more scalable way to stack blocks - SY
    else if (CGRectContainsPoint(self.topBlockStack.frame, touchLocation) && [self.topBlockStack acceptsBlockView:blockView])
    {
        blockView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        CGFloat xDifference = 0.0f;
//        CGFloat yDifference = 0.0f;
//        CGPoint blockStackOrigin = self.topBlockStack.frame.origin;
//        [self.delegate updateFrameForTouchedLanguageBlockView:self
//                                  andDraggedLanguageBlockView:blockView
//                                                          byX:xDifference
//                                                          byY:yDifference
//                                      withParameterViewOrigin:blockStackOrigin];
        [self.snappedBlockViews addObject:blockView];
    }
    // hack - will only accept one block for now hack until find more scalable way to stack blocks - SY
    else if (CGRectContainsPoint(self.bottomBlockStack.frame, touchLocation) && [self.bottomBlockStack acceptsBlockView:blockView])
    {
        blockView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//        CGFloat xDifference = 0.0f;
//        CGFloat yDifference = 0.0f;
//        CGPoint blockStackOrigin = self.bottomBlockStack.frame.origin;
//        [self.delegate updateFrameForTouchedLanguageBlockView:self
//                                  andDraggedLanguageBlockView:blockView
//                                                          byX:xDifference
//                                                          byY:yDifference
//                                      withParameterViewOrigin:blockStackOrigin];
        [self.snappedBlockViews addObject:blockView];
    }
}

- (CGSize)originalSize
{
    return CGSizeMake(210.0f, 231.0f);
}

@end
