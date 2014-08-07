#import "BBConstants.h"


@implementation BBConstants

+ (UIColor *)lightRedDefaultColor
{
    return [UIColor colorWithRed:205.0f/255 green:58.0f/255 blue:78.0f/255 alpha:1.0f];
}

+ (UIColor *)blueClosetColor
{
    return [UIColor colorWithRed:101.0f/255 green:154.0f/255 blue:201.0f/255 alpha:1.0f];
}

+ (UIColor *)pinkMyBlobColor
{
    return [BBConstants lightRedDefaultColor];
}

+ (UIColor *)purpleSecretLanguageColor
{
    return [UIColor colorWithRed:117.0f/255 green:77.0f/255 blue:154.0f/255 alpha:1.0f];
}

+ (UIColor *)unselectedTabTextColor
{
    return [UIColor darkGrayColor];
}

@end
