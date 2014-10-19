#import "BBLogicOperatorBlockView.h"
#import "BBLanguageBlock+Configure.h"
#import "BBBlockSlotParameterView.h"

const CGFloat xOffset = 18.0f;
const CGFloat xPadding = 8.0f;

@interface BBLogicOperatorBlockView ()
@property (weak, nonatomic) IBOutlet BBBlockSlotParameterView *leftSlot;
@property (weak, nonatomic) IBOutlet BBBlockSlotParameterView *rightSlot;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation BBLogicOperatorBlockView

- (void)setLanguageBlock:(BBLanguageBlock *)languageBlock
{
    [super setLanguageBlock:languageBlock];
    [self updateUI];
}

- (void)updateUI
{
    self.leftSlot.frame = CGRectMake(self.leftSlot.frame.origin.x, self.leftSlot.frame.origin.y, 48.0f, self.leftSlot.frame.size.height);
    
    self.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    self.leftSlot.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    self.rightSlot.layer.cornerRadius = BLOB_BLOCK_SLOT_CORNER_RADIUS;
    
    self.nameLabel.text = self.languageBlock.abbreviation ? self.languageBlock.abbreviation : self.languageBlock.name;
    
    CGSize labelStringSize = [self.nameLabel.text sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:BLOB_FONT_REGULAR size:BLOB_FONT_21PT]}];
    CGPoint originalOrigin = self.nameLabel.frame.origin;
    self.nameLabel.frame = CGRectMake(originalOrigin.x, originalOrigin.y, labelStringSize.width, labelStringSize.height);
    
    CGFloat calculatedWidth = CGRectGetWidth(self.nameLabel.frame) + xOffset * 2 + xPadding * 2 + CGRectGetWidth(self.rightSlot.frame) + CGRectGetWidth(self.leftSlot.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    CGRect calculatedFrame = CGRectMake(CGPointZero.x, CGPointZero.y, calculatedWidth, height);
    self.frame = calculatedFrame;
}


- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView atTouchLocation:(CGPoint)touchLocation
{
    if (CGRectContainsPoint(self.leftSlot.frame, touchLocation) && [self.leftSlot acceptsBlockView:blockView])
    {
        [self expandSlotView:self.leftSlot forBlockView:blockView];
    }
    else if (CGRectContainsPoint(self.rightSlot.frame, touchLocation) && [self.rightSlot acceptsBlockView:blockView])
    {
        [self expandSlotView:self.rightSlot forBlockView:blockView];
    }
}

- (void)untouchedByLanguageBlockView:(BBLanguageBlockView *)blockView fromStartingOrigin:(CGPoint)blockViewStartingOrigin
{
    if ([self.snappedBlockViews containsObject:blockView])
    {
        [self.snappedBlockViews removeObject:blockView];
        CGPoint translatedPoint = CGPointMake(self.frame.origin.x + self.leftSlot.frame.origin.x, self.frame.origin.y + self.leftSlot.frame.origin.y);
        
        if (CGPointEqualToPoint(translatedPoint, blockViewStartingOrigin))
        {
            [self resetOriginalSizeOfSlotView:self.leftSlot];
        }
        else
        {
            [self resetOriginalSizeOfSlotView:self.rightSlot];
        }
    }
}

#pragma mark - Resize Helper Methods

- (void)expandSlotView:(BBBlockSlotParameterView *)slotView forBlockView:(BBLanguageBlockView *)blockView
{
    CGFloat xDifference = CGRectGetWidth(blockView.frame) - CGRectGetWidth(slotView.frame);
    CGFloat yDifference = CGRectGetHeight(blockView.frame) - CGRectGetHeight(slotView.frame);
    CGFloat slotWidth = CGRectGetWidth(slotView.frame);
    CGFloat slotHeight = CGRectGetHeight(slotView.frame);
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    if (abs(xDifference) >= MARGIN_OF_ERROR_CONSTANT)
    {
        slotWidth += xDifference;
        width += xDifference;
    }
   
    if (abs(yDifference) >= MARGIN_OF_ERROR_CONSTANT)
    {
        slotHeight += yDifference;
        height += yDifference;
    }
    slotView.frame = CGRectMake(slotView.frame.origin.x, slotView.frame.origin.y, slotWidth, slotHeight);
    [self.delegate updateFrameForTouchedLanguageBlockView:self
                              andDraggedLanguageBlockView:blockView
                                                withWidth:width
                                               withHeight:height
                                  withParameterViewOrigin:slotView.frame.origin];
    [self.snappedBlockViews addObject:blockView];
}

- (void)resetOriginalSizeOfSlotView:(BBBlockSlotParameterView *)slotView
{
    if ([self.snappedBlockViews count] == 0)
    {
        self.frame = [self originalFrame];
    }
}

#pragma mark - Size Helper Methods

- (CGSize)originalSlotSize
{
    return CGSizeMake(48.0f, 34.0f);
}

- (CGSize)originalSize
{
    return CGSizeMake(198.0f, 55.0f);
}

@end
