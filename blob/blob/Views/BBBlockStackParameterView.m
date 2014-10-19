#import "BBBlockStackParameterView.h"
#import "BBLanguageBlockView.h"
#import "BBLanguageBlock+Configure.h"

@implementation BBBlockStackParameterView

- (BOOL)acceptsBlockView:(BBLanguageBlockView *)blockView
{
    return ([blockView.languageBlock isReactionBlock] ||
            [blockView.languageBlock isSwitchToBlock]) ? YES : NO;
}

@end
