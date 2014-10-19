#import "BBParameterView.h"

@implementation BBParameterView

- (BOOL)acceptsBlockView:(BBLanguageBlockView *)blockView
{
    return NO;  // overridden by subclasses
}

@end
