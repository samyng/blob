#import "BBLanguageBlockView.h"
#import "BBParameterView.h"

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
    self.snappedBlockViews = [[NSMutableSet alloc] init];
    self.userInteractionEnabled = YES;
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
    CGFloat newCenterX = newCenterPoint.x;
    CGFloat newCenterY = newCenterPoint.y;
    CGSize screenSize = [BBConstants screenSize];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if ((newCenterX - width/2) < 0) // left boundary
    {
        newCenterX = width/2;
    }
    if ((newCenterY - height/2) < 0) // top boundary
    {
        newCenterY = height/2;
    }
    if ((newCenterX + width/2) > screenSize.width) // right boundary
    {
        newCenterX = screenSize.width - width/2;
    }
    
    CGFloat xDifference = newCenterX - oldCenterPoint.x;
    CGFloat yDifference = newCenterY - oldCenterPoint.y;
    self.center = CGPointMake(newCenterX, newCenterY);
    
    for (BBLanguageBlockView *blockView in self.snappedBlockViews)
    {
        CGFloat xPosition = blockView.center.x + xDifference;
        CGFloat yPosition = blockView.center.y + yDifference;
        blockView.center = CGPointMake(xPosition, yPosition);
        [self.superview bringSubviewToFront:blockView];
    }
}

- (void)updateFrameForBlockStack:(BBParameterView *)blockStack withBlockView:(BBLanguageBlockView *)blockView
{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = [self originalSize].height;
    CGFloat blockViewHeight = CGRectGetHeight(blockView.frame);
    CGPoint blockStackOrigin = blockStack.frame.origin;
    
    if ([self numberOfAdditionalStackBlockSpaces] > 0)
    {
        height = [self originalSize].height + ([self numberOfAdditionalStackBlockSpaces] *
                                               blockViewHeight);
        blockStackOrigin = CGPointMake(blockStackOrigin.x, blockStackOrigin.y + ([self numberOfAdditionalStackBlockSpaces] * blockViewHeight));
    }
    
    [self.delegate updateFrameForTouchedLanguageBlockView:self
                              andDraggedLanguageBlockView:blockView
                                                withWidth:width
                                               withHeight:height
                                  withParameterViewOrigin:blockStackOrigin];
}

- (NSInteger)numberOfAdditionalStackBlockSpaces
{
    if (self.hasSlotBlock)
    {
        return  [self.snappedBlockViews count] - 2;
    }
    return [self.snappedBlockViews count] - 1;
}

- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    // overridden by subclasses
}

- (void)untouchedByLanguageBlockView:(BBLanguageBlockView *)blockView fromStartingOrigin:(CGPoint)blockViewStartingOrigin
{
    // overridden by subclasses
}

- (CGSize)originalSize
{
    return CGSizeZero; // overridden by subclasses
}


- (CGRect)originalFrame
{
    return CGRectMake(self.frame.origin.x, self.frame.origin.y, [self originalSize].width, [self originalSize].height);
}

@end
