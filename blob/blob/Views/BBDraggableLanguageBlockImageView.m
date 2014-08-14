//
//  BBDraggableLanguageBlockImageView.m
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBDraggableLanguageBlockImageView.h"
#import "BBLanguageBlockView.h"

@interface BBDraggableLanguageBlockImageView ()
@property (strong, nonatomic) BBLanguageBlockView *languageBlockView;
@end

@implementation BBDraggableLanguageBlockImageView

- (id)initWithLanguageBlockView:(BBLanguageBlockView *)languageBlockView
{
    self = [super initWithImage:[languageBlockView rasterizedImageCopy]];
    if (self)
    {
        _languageBlockView = languageBlockView;
    }
    return self;
}

@end
