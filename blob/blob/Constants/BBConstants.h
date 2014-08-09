#import <Foundation/Foundation.h>

static NSString * const BLOB_TITLE = @"BLOB LOGO";
static NSString * const FOOD_CATEGORY = @"Food";
static NSString * const FRIENDS_CATEGORY = @"Friends";
static NSString * const PLACES_CATEGORY = @"Places";
static NSString * const INSTRUMENTS_CATEGORY = @"Instruments";
static NSString * const FASHION_CATEGORY = @"Fashion";

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

@end