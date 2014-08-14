//
//  BBDraggableLanguageBlockImageView.m
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBDraggableLanguageBlockImageView.h"
#import "BBLanguageBlockView.h"

@implementation BBDraggableLanguageBlockImageView

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
        [self.delegate panDidChange:sender forDraggableLanguageBlockImageView:self];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate panDidEnd:sender forDraggableLanguageBlockImageView:self];
    }
    else if (sender.state == UIGestureRecognizerStateBegan)
    {
        
    }
}

@end
