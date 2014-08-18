//
//  BBLanguageBlockView.m
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBLanguageBlockView.h"

@implementation BBLanguageBlockView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [self addGestureRecognizer:panGestureRecognizer];
    self.snappedBlockViews = [[NSMutableArray alloc] init];
    self.userInteractionEnabled = YES;
    self.dragEnabled = YES;
}

- (void)panned:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self.delegate panDidBegin:sender forLanguageBlockView:self];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        [self.delegate panDidChange:sender forLanguageBlockView:self];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate panDidEnd:sender forLanguageBlockView:self];
    }
}

- (void)moveCenterToPoint:(CGPoint)newCenterPoint
{
    CGPoint oldCenterPoint = self.center;
    CGFloat xDifference = newCenterPoint.x - oldCenterPoint.x;
    CGFloat yDifference = newCenterPoint.y - oldCenterPoint.y;
    self.center = newCenterPoint;
    
    for (BBLanguageBlockView *blockView in self.snappedBlockViews)
    {
        CGFloat xPosition = blockView.center.x + xDifference;
        CGFloat yPosition = blockView.center.y + yDifference;
        blockView.center = CGPointMake(xPosition, yPosition);
        [self.superview bringSubviewToFront:blockView];
    }
}

- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    // overridden by subclasses
}

- (CGSize)originalSize
{
    return CGSizeZero; // overridden by subclasses
}

@end
