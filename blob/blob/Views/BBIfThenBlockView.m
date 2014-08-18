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

@interface BBIfThenBlockView ()
@property (weak, nonatomic) IBOutlet BBBlockSlotParameterView *blockSlot;
@property (weak, nonatomic) IBOutlet BBBlockStackParameterView *blockStack;
@end

@implementation BBIfThenBlockView

- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    if (CGRectContainsPoint(self.blockSlot.frame, touchLocation) && [self.blockSlot acceptsBlockView:blockView])
    {
        blockView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        CGFloat xDifference = CGRectGetWidth(blockView.frame) - CGRectGetWidth(self.blockSlot.frame);
        CGFloat yDifference = CGRectGetHeight(blockView.frame) - CGRectGetHeight(self.blockSlot.frame);
        NSLog(@"before frame: %@", NSStringFromCGRect(self.blockSlot.frame));
        [self.delegate updateFrameForLanguageBlockView:self byX:xDifference byY:yDifference];
        NSLog(@"after frame: %@", NSStringFromCGRect(self.blockSlot.frame));
        [blockView removeFromSuperview];
        [self addSubview:blockView];
        self.blockSlot.isVacant = NO;
    }
    else if (CGRectContainsPoint(self.blockStack.frame, touchLocation) && [self.blockStack acceptsBlockView:blockView])
    {
        self.blockStack.isVacant = NO;
    }
}

- (void)resetUI
{

}

@end
