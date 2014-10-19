#import "BBBlockSlotParameterView.h"
#import "BBLanguageBlockView.h"
#import "BBLanguageBlock+Configure.h"

@implementation BBBlockSlotParameterView

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
    self.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
}

- (BOOL)acceptsBlockView:(BBLanguageBlockView *)blockView
{
    return ([blockView.languageBlock isAccessoryBlock] ||
            [blockView.languageBlock isLogicOperatorBlock] ||
            [blockView.languageBlock isNotBlock] ||
            [blockView.languageBlock isComparisonOperatorBlock]) ? YES : NO;
}

@end
