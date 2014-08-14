//
//  BBCollapsedLanguageBlockView.m
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBCollapsedLanguageBlockView.h"
#import "BBLanguageBlock.h"

@implementation BBCollapsedLanguageBlockView
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
        [self.delegate panDidBegin:sender inCollapsedLanguageBlockView:self];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        [self.delegate panDidChange:sender forCollapsedLanguageBlockView:self];
    }
}

- (UIImage *)rasterizedImageCopy
{
    NSString *imageName = [NSString stringWithFormat:@"%@Block-expanded", self.languageBlock.name];
    return [UIImage imageNamed:imageName];
}

@end
