//
//  BBRepeatBlockView.m
//  blob
//
//  Created by Sam Yang on 8/17/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBRepeatBlockView.h"
#import "BBBlockStackParameterView.h"

@interface BBRepeatBlockView ()
@property (weak, nonatomic) IBOutlet BBBlockStackParameterView *blockStack;

@end

@implementation BBRepeatBlockView

- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    // will only accept one block for now hack until find more scalable way to stack blocks - SY
    if (CGRectContainsPoint(self.blockStack.frame, touchLocation) && [self.blockStack acceptsBlockView:blockView])
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
        [self updateFrameForBlockStack:self.blockStack withBlockView:blockView];
    }
}

- (CGSize)originalSize
{
    return CGSizeMake(215.0f, 144.0f);
}

@end
