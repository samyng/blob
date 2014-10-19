#import <UIKit/UIKit.h>
@class BBFeeling;

@interface BBFeelingCollectionCell : UICollectionViewCell
- (void)configureWithFeeling:(BBFeeling *)feeling;
@property (strong, nonatomic) BBFeeling *feeling;
- (UIImage *)rasterizedImageCopy;
- (void)setToBlankState;
- (void)resetDefaultUI;
@end
