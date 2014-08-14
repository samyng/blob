//
//  BBLanguageBlockView.m
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBLanguageBlockView.h"
#import "BBLanguageBlock.h"

@interface BBLanguageBlockView ()
@end

@implementation BBLanguageBlockView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)updateViewForState:(BOOL)isCollapsed
{
    if (isCollapsed)
    {
        self.backgroundColor = [BBConstants pinkColor];
    }
    else
    {
        self.backgroundColor = [UIColor blackColor];
    }
}

- (void)panned:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        [self.delegate panDidBegin:sender inLanguageBlockView:self];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        [self.delegate panDidChange:sender forLanguageBlockView:self];
    }
}

- (UIImage *)rasterizedImageCopy
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
