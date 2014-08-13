#import "BBConstants.h"


@implementation BBConstants

+ (UIColor *)pinkColor
{
    return [UIColor colorWithRed:251.0f/255 green:52.0f/255 blue:72.0f/255 alpha:1.0f];
}

+ (UIColor *)pinkBackgroundColor
{
    return [UIColor colorWithRed:255.0f/255 green:204.0f/255 blue:211.0f/255 alpha:1.0f];
}

+ (UIColor *)pinkTextColor
{
    return [UIColor colorWithRed:153.0f/255 green:32.0f/255 blue:50.0f/255 alpha:1.0f];
}

+ (UIColor *)orangeColor
{
    return [UIColor colorWithRed:255.0f/255 green:131.0f/255 blue:0.0f/255 alpha:1.0f];
}

+ (UIColor *)orangeBackgroundColor
{
    return [UIColor colorWithRed:255.0f/255 green:215.0f/255 blue:179.0f/255 alpha:1.0f];
}

+ (UIColor *)orangeTextColor
{
    return [UIColor colorWithRed:153.0f/255 green:73.0f/255 blue:0.0f/255 alpha:1.0f];
}

+ (UIColor *)yellowColor
{
    return [UIColor colorWithRed:255.0f/255 green:230.0f/255 blue:0.0f/255 alpha:1.0f];
}

+ (UIColor *)yellowBackgroundColor
{
    return [UIColor colorWithRed:255.0f/255 green:249.0f/255 blue:204.0f/255 alpha:1.0f];
}

+ (UIColor *)yellowTextColor
{
    return [UIColor colorWithRed:153.0f/255 green:134.0f/255 blue:0.0f/255 alpha:1.0f];
}

+ (UIColor *)lightBlueColor
{
    return [UIColor colorWithRed:148.0f/255 green:218.0f/255 blue:206.0f/255 alpha:1.0f];
}

+ (UIColor *)lightBlueBackgroundColor
{
    return [UIColor colorWithRed:207.0f/255 green:255.0f/255 blue:246.0f/255 alpha:1.0f];
}

+ (UIColor *)lightBlueTextColor
{
    return [UIColor colorWithRed:88.0f/255 green:127.0f/255 blue:120.0f/255 alpha:1.0f];
}

+ (UIColor *)blueColor
{
    return [UIColor colorWithRed:0.0f/255 green:154.0f/255 blue:221.0f/255 alpha:1.0f];
}

+ (UIColor *)blueBackgroundColor
{
    return [UIColor colorWithRed:202.0f/255 green:245.0f/255 blue:255.0f/255 alpha:1.0f];
}

+ (UIColor *)blueTextColor
{
    return [UIColor colorWithRed:0.0f/255 green:94.0f/255 blue:127.0f/255 alpha:1.0f];
}

+ (UIColor *)tealColor
{
    return [UIColor colorWithRed:167.0f/255 green:216.0f/255 blue:207.0f/255 alpha:1.0f];
}

+ (UIColor *)tealBackgroundColor
{
    return [UIColor colorWithRed:182.0f/255 green:227.0f/255 blue:218.0f/255 alpha:1.0f];
}

+ (UIColor *)tealTextColor
{
    return [UIColor colorWithRed:0.0f/255 green:174.0f/255 blue:141.0f/255 alpha:1.0f];
}

+ (UIColor *)lightGrayColor
{
    return [UIColor colorWithRed:231.0f/255 green:231.0f/255 blue:231.0f/255 alpha:1.0f];
}

+ (UIColor *)unselectedTabTextColor
{
    return [UIColor darkGrayColor];
}

+ (UIColor *)magnesiumGrayColor
{
    return [UIColor colorWithRed:203.0f/255 green:203.0f/255 blue:203.0f/255 alpha:1.0f];
}

+ (UIColor *)textColorForCellWithLanguageGroupName:(NSString *)name
{
    if ([name isEqualToString:CONTROL_GROUP])
    {
        return [BBConstants pinkTextColor];
    }
    else if ([name isEqualToString:FROM_CLOSET_GROUP])
    {
        return [BBConstants orangeTextColor];
    }
    else if ([name isEqualToString:REACTIONS_GROUP])
    {
        return [BBConstants yellowTextColor];
    }
    else if ([name isEqualToString:OPERATORS_GROUP])
    {
        return [BBConstants lightBlueTextColor];
    }
    else if ([name isEqualToString:VARIABLES_GROUP])
    {
        return [BBConstants blueTextColor];
    }
    else
    {
        return [UIColor grayColor];
    }
}

+ (UIColor *)backgroundColorForCellWithLanguageGroupName:(NSString *)name
{
    if ([name isEqualToString:CONTROL_GROUP])
    {
        return [BBConstants pinkBackgroundColor];
    }
    else if ([name isEqualToString:FROM_CLOSET_GROUP])
    {
        return [BBConstants orangeBackgroundColor];
    }
    else if ([name isEqualToString:REACTIONS_GROUP])
    {
        return [BBConstants yellowBackgroundColor];
    }
    else if ([name isEqualToString:OPERATORS_GROUP])
    {
        return [BBConstants lightBlueBackgroundColor];
    }
    else if ([name isEqualToString:VARIABLES_GROUP])
    {
        return [BBConstants blueBackgroundColor];
    }
    else
    {
        return [UIColor lightGrayColor];
    }
}


+ (UIColor *)colorForCellWithLanguageGroupName:(NSString *)name
{
    if ([name isEqualToString:CONTROL_GROUP])
    {
        return [BBConstants pinkColor];
    }
    else if ([name isEqualToString:FROM_CLOSET_GROUP])
    {
        return [BBConstants orangeColor];
    }
    else if ([name isEqualToString:REACTIONS_GROUP])
    {
        return [BBConstants yellowColor];
    }
    else if ([name isEqualToString:OPERATORS_GROUP])
    {
        return [BBConstants lightBlueColor];
    }
    else if ([name isEqualToString:VARIABLES_GROUP])
    {
        return [BBConstants blueColor];
    }
    else
    {
        return [UIColor grayColor];
    }
}

@end
