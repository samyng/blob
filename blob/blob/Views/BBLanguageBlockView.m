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
@property (strong, nonatomic) UIView *currentBlockView;
@end

@implementation BBLanguageBlockView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect currentBlockFrame = CGRectMake(CGPointZero.x, CGPointZero.y, frame.size.width, frame.size.height);
        _currentBlockView = [[UIView alloc] initWithFrame:currentBlockFrame];
        [self addSubview:_currentBlockView];
    }
    return self;
}

- (void)updateViewForState:(BOOL)isCollapsed
{
    NSString *nibName = [self nibNameForLanguageBlockState:isCollapsed];
    if (nibName)
    {
        UIView *currentView = [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
        currentView.frame = self.currentBlockView.frame;
        self.currentBlockView = currentView;
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

#pragma mark - Helper Methods

- (NSString *)nibNameForLanguageBlockState:(BOOL)isCollapsed
{
    if (isCollapsed)
    {
        return [NSString stringWithFormat:@"BB%@View_Collapsed", self.languageBlock.name];
    }
    else
    {
        return [NSString stringWithFormat:@"BB%@View_Expanded", self.languageBlock.name];
    }
}

@end
