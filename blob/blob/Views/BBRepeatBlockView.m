#import "BBRepeatBlockView.h"
#import "BBBlockStackParameterView.h"

@interface BBRepeatBlockView ()
@property (weak, nonatomic) IBOutlet BBBlockStackParameterView *blockStack;

@end

@implementation BBRepeatBlockView

- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    if (CGRectContainsPoint(self.blockStack.frame, touchLocation) && [self.blockStack acceptsBlockView:blockView])
    {
        [self updateFrameForBlockStack:self.blockStack withBlockView:blockView];
        [self.snappedBlockViews addObject:blockView];
    }
}

- (void)untouchedByLanguageBlockView:(BBLanguageBlockView *)blockView fromStartingOrigin:(CGPoint)blockViewStartingOrigin
{
    if ([self.snappedBlockViews containsObject:blockView])
    {
        [self.snappedBlockViews removeObject:blockView];
        [self updateFrameForBlockStack:self.blockStack withBlockView:blockView];
    }
}

- (CGSize)originalSize
{
    return CGSizeMake(215.0f, 144.0f);
}

@end
