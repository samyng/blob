#import "BBAccessoryCollectionCell.h"
#import "BBAccessory+Configure.h"

@interface BBAccessoryCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation BBAccessoryCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [BBConstants pinkBackgroundColor];
    self.thumbnailImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.nameLabel.textColor = [BBConstants blueTextColor];
    self.nameLabel.backgroundColor = [UIColor whiteColor];
}

- (void)configureWithAccessory:(BBAccessory *)accessory
{
    self.thumbnailImageView.image = accessory.thumbnailImage;
    self.nameLabel.text = [accessory.name capitalizedString];
}

@end
