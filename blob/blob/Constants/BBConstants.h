#import <Foundation/Foundation.h>

static NSString * const BLOB_TITLE = @"BLOB LOGO";

static NSString * const FOOD_CATEGORY = @"Food";
static NSString * const FRIENDS_CATEGORY = @"Friends";
static NSString * const PLACES_CATEGORY = @"Places";
static NSString * const INSTRUMENTS_CATEGORY = @"Instruments";
static NSString * const FASHION_CATEGORY = @"Fashion";

static NSString * const FEELINGS_TITLE = @"Feelings";
static NSString * const REACTIONS_GROUP = @"Reactions";
static NSString * const ACCESSORIES_GROUP = @"Group";
static NSString * const CONTROL_GROUP = @"Control";

static NSInteger const kTotalNumberOfSections = 1;

@interface BBConstants : NSObject

+ (UIColor *)pinkDefaultColor;
+ (UIColor *)lightGrayDefaultColor;
+ (UIColor *)lightBlueDefaultColor;
+ (UIColor *)blueClosetColor;
+ (UIColor *)pinkMyBlobColor;
+ (UIColor *)purpleSecretLanguageColor;
+ (UIColor *)unselectedTabTextColor;
+ (UIColor *)magnesiumGrayColor;

+ (UIColor *)reactionGroupBackgroundColor;
+ (UIColor *)accessoriesGroupBackgroundColor;
+ (UIColor *)controlGroupBackgroundColor;

@end