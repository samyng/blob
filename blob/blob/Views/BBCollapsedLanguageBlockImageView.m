//
//  BBCollapsedLanguageBlockImageView.m
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBCollapsedLanguageBlockImageView.h"
#import "BBLanguageBlock.h"
#import "BBLanguageGroup.h"

static NSString * const kExpandedImageStringFormat = @"%@Block-expanded";

@interface BBCollapsedLanguageBlockImageView ()
@property (strong, nonatomic) BBLanguageBlock *languageBlock;
@end

@implementation BBCollapsedLanguageBlockImageView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
        CGSize frameSize = frame.size;
        CGRect labelFrame = CGRectMake(CGPointZero.x, CGPointZero.y, frameSize.width, frameSize.height);
        _languageBlockLabel = [[UILabel alloc] initWithFrame:labelFrame];
        _languageBlockLabel.font = [UIFont fontWithName:BLOB_FONT_REGULAR size:BLOB_FONT_19PT];
        _languageBlockLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_languageBlockLabel];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithImage:image];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)configureWithLanguageBlock:(BBLanguageBlock *)languageBlock
{
    NSString *groupName = languageBlock.group.name;
    if ([groupName isEqualToString:REACTIONS_GROUP] || [groupName isEqualToString:FROM_CLOSET_GROUP])
    {
        self.languageBlockLabel.textColor = [BBConstants textColorForCellWithLanguageGroupName:groupName];
        self.backgroundColor = [BBConstants colorForCellWithLanguageGroupName:groupName];
        self.languageBlockLabel.text = languageBlock.name;
    }
    self.languageBlock = languageBlock;
}

- (void)setup
{
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [self addGestureRecognizer:recognizer];
    self.userInteractionEnabled = YES;
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
    NSString *imageName = [NSString stringWithFormat:kExpandedImageStringFormat, self.languageBlock.name];
    UIImage *imageCopy = [UIImage imageNamed:imageName];
    if (imageCopy)
    {
        return imageCopy;
    }
    else
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0f);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
}

@end
