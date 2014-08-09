#import "BBConstants.h"


@implementation BBConstants

+ (UIColor *)pinkDefaultColor
{
    return [UIColor colorWithRed:206.0f/255 green:58.0f/255 blue:78.0f/255 alpha:1.0f];
}

+ (UIColor *)lightGrayDefaultColor
{
    return [UIColor colorWithRed:231.0f/255 green:231.0f/255 blue:231.0f/255 alpha:1.0f];
}

+ (UIColor *)lightBlueDefaultColor
{
    return [UIColor colorWithRed:95.0f/255 green:173.0f/255 blue:219.0f/255 alpha:1.0f];
}

+ (UIColor *)blueClosetColor
{
    return [UIColor colorWithRed:101.0f/255 green:154.0f/255 blue:201.0f/255 alpha:1.0f];
}

+ (UIColor *)pinkMyBlobColor
{
    return [BBConstants pinkDefaultColor];
}

+ (UIColor *)purpleSecretLanguageColor
{
    return [UIColor colorWithRed:117.0f/255 green:77.0f/255 blue:154.0f/255 alpha:1.0f];
}

+ (UIColor *)unselectedTabTextColor
{
    return [UIColor darkGrayColor];
}

+ (UIColor *)magnesiumGrayColor
{
    return [UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f];
}

+ (UIColor *)reactionGroupBackgroundColor
{
    return [self pinkDefaultColor];
}

+ (UIColor *)accessoriesGroupBackgroundColor
{
    return [self lightBlueDefaultColor];
}

+ (UIColor *)controlGroupBackgroundColor
{
    return [self purpleSecretLanguageColor];
}

@end
