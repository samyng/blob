#import <Foundation/Foundation.h>

static NSString * const BLOB_TITLE = @"BLOB LOGO";

static NSString * const FOOD_CATEGORY = @"Food";
static NSString * const FRIENDS_CATEGORY = @"Friends";
static NSString * const PLACES_CATEGORY = @"Places";
static NSString * const INSTRUMENTS_CATEGORY = @"Instruments";
static NSString * const FASHION_CATEGORY = @"Fashion";

static NSString * const FEELINGS_TITLE = @"Feelings";
static NSString * const REACTIONS_GROUP = @"Reactions";
static NSString * const FROM_CLOSET_GROUP = @"From Closet";
static NSString * const CONTROL_GROUP = @"Control";
static NSString * const OPERATORS_GROUP = @"Operators";
static NSString * const VARIABLES_GROUP = @"Variables";

static NSInteger const kTotalNumberOfSections = 1;

@interface BBConstants : NSObject

+ (UIColor *)pinkColor;
+ (UIColor *)pinkBackgroundColor;
+ (UIColor *)pinkTextColor;
+ (UIColor *)orangeColor;
+ (UIColor *)orangeBackgroundColor;
+ (UIColor *)orangeTextColor;
+ (UIColor *)yellowColor;
+ (UIColor *)yellowBackgroundColor;
+ (UIColor *)yellowTextColor;
+ (UIColor *)lightBlueColor;
+ (UIColor *)lightBlueBackgroundColor;
+ (UIColor *)lightBlueTextColor;
+ (UIColor *)blueColor;
+ (UIColor *)blueBackgroundColor;
+ (UIColor *)blueTextColor;
+ (UIColor *)textColorForCellWithLanguageGroupName:(NSString *)name;
+ (UIColor *)backgroundColorForCellWithLanguageGroupName:(NSString *)name;
+ (UIColor *)colorForCellWithLanguageGroupName:(NSString *)name;

+ (UIColor *)lightGrayColor;
+ (UIColor *)magnesiumGrayColor;

@end