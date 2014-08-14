//
//  BBCollapsedLanguageBlockImageView.m
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBCollapsedLanguageBlockImageView.h"
#import "BBLanguageBlock.h"

@implementation BBCollapsedLanguageBlockImageView
@synthesize delegate;

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [self addGestureRecognizer:recognizer];
        self.userInteractionEnabled = YES;
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
