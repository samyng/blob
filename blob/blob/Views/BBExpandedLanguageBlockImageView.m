//
//  BBExpandedLanguageBlockImageView.m
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBExpandedLanguageBlockImageView.h"

@implementation BBExpandedLanguageBlockImageView

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [self addGestureRecognizer:panGestureRecognizer];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)panned:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        [self.delegate panDidChange:sender forExpandedLanguageBlockImageView:self];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate panDidEnd:sender forExpandedLanguageBlockImageView:self];
    }
    else if (sender.state == UIGestureRecognizerStateBegan)
    {
        
    }
}

@end
