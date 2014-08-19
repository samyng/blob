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
        blockView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGFloat xDifference = 0.0f;
        CGFloat yDifference = 0.0f;
        CGPoint blockStackOrigin = self.blockStack.frame.origin;
        [self.delegate updateFrameForTouchedLanguageBlockView:self
                                  andDraggedLanguageBlockView:blockView
                                                          byX:xDifference
                                                          byY:yDifference
                                      withParameterViewOrigin:blockStackOrigin];
        [self.snappedBlockViews addObject:blockView];
    }
}

- (CGSize)originalSize
{
    return CGSizeMake(215.0f, 144.0f);
}

@end
