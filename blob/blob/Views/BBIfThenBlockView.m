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

@interface BBIfThenBlockView ()
@property (weak, nonatomic) IBOutlet BBBlockSlotParameterView *blockSlot;
@property (weak, nonatomic) IBOutlet BBBlockStackParameterView *blockStack;
@property (nonatomic) BOOL hasSlotBlock;
@end

@implementation BBIfThenBlockView

- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    if (CGRectContainsPoint(self.blockSlot.frame, touchLocation) && [self.blockSlot acceptsBlockView:blockView])
    {
        blockView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGFloat xDifference = CGRectGetWidth(blockView.frame) - CGRectGetWidth(self.blockSlot.frame);
        CGFloat newWidth = CGRectGetWidth(self.frame) + xDifference;
        CGPoint blockSlotOrigin = self.blockSlot.frame.origin;
        [self.delegate updateFrameForTouchedLanguageBlockView:self
                                  andDraggedLanguageBlockView:blockView
                                                    withWidth:newWidth
                                                   withHeight:CGRectGetHeight(self.frame)
                                      withParameterViewOrigin:blockSlotOrigin];
        [self.snappedBlockViews addObject:blockView];
        self.hasSlotBlock = YES;
    }
    // will only accept one block for now hack until find more scalable way to stack blocks - SY
    else if (CGRectContainsPoint(self.blockStack.frame, touchLocation) && [self.blockStack acceptsBlockView:blockView])
    {
        [self updateFrameForBlockStackWithBlockView:blockView];
        [self.snappedBlockViews addObject:blockView];
    }
}

- (void)updateFrameForBlockStackWithBlockView:(BBLanguageBlockView *)blockView
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = [self originalSize].height;
    CGFloat reactionBlockHeight = CGRectGetHeight(blockView.frame);
    CGPoint blockStackOrigin = self.blockStack.frame.origin;
    
    if ([self numberOfAdditionalStackBlockSpaces] > 0)
    {
        height = [self originalSize].height + ([self numberOfAdditionalStackBlockSpaces] *
                                                                     reactionBlockHeight);
        blockStackOrigin = CGPointMake(blockStackOrigin.x, blockStackOrigin.y + ([self numberOfAdditionalStackBlockSpaces] * reactionBlockHeight));
    }
    
    [self.delegate updateFrameForTouchedLanguageBlockView:self
                              andDraggedLanguageBlockView:blockView
                                                withWidth:width
                                               withHeight:height
                                  withParameterViewOrigin:blockStackOrigin];
}

- (void)untouchedByLanguageBlockView:(BBLanguageBlockView *)blockView fromStartingOrigin:(CGPoint)blockViewStartingOrigin
{
    NSLog(@"untouched by: %@", NSStringFromClass([blockView class]));
    if ([self.snappedBlockViews containsObject:blockView])
    {
        NSLog(@"should remove");
        [self.snappedBlockViews removeObject:blockView];
        CGPoint translatedPoint = CGPointMake(self.frame.origin.x + self.blockSlot.frame.origin.x, self.frame.origin.y + self.blockSlot.frame.origin.y);
        
        if (CGPointEqualToPoint(translatedPoint, blockViewStartingOrigin))
        {
            self.hasSlotBlock = NO;
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [self originalSize].width, self.frame.size.height);
        }
        else
        {
            [self updateFrameForBlockStackWithBlockView:blockView];
        }
    }
}

- (NSInteger)numberOfAdditionalStackBlockSpaces
{
    if (self.hasSlotBlock)
    {
        return  [self.snappedBlockViews count] - 2;
    }
    return [self.snappedBlockViews count] - 1;
}

- (CGSize)originalSize
{
    return CGSizeMake(210.0f, 159.0f);
}

@end
