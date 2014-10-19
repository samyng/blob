#import "BBReactionBlockView.h"
#import "BBLanguageBlock.h"

@interface BBReactionBlockView ()
@property (weak, nonatomic) IBOutlet UILabel *reactionLabel;

@end

@implementation BBReactionBlockView

- (void)setLanguageBlock:(BBLanguageBlock *)languageBlock
{
    [super setLanguageBlock:languageBlock];
    [self updateUI];
}

- (void)updateUI
{
    self.reactionLabel.text = self.languageBlock.name;
    
    CGSize labelStringSize = [self.reactionLabel.text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:BLOB_FONT_REGULAR size:BLOB_FONT_21PT]}];
    
    const CGFloat xPadding = 15.0f;
    
    CGFloat calculatedWidth = labelStringSize.width + xPadding * 3;
    CGFloat height = CGRectGetHeight(self.frame);
    CGRect calculatedFrame = CGRectMake(CGPointZero.x, CGPointZero.y, calculatedWidth, height);
    self.frame = calculatedFrame;
}

- (CGSize)originalSize
{
    return CGSizeMake(190.0f, 55.0f);
}

@end
