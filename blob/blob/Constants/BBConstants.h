#import <Foundation/Foundation.h>

static NSString * const BLOB_TITLE = @"BLOB LOGO";
static NSString * const BLOB_FONT_BOLD = @"GillSans-Bold";
static NSString * const CLOSET_ICON_NAME = @"closet-ico-selected";
static NSString * const MY_BLOB_ICON_NAME = @"my-blob-ico-selected";
static NSString * const SECRET_LANGUAGE_ICON_NAME = @"secret-lang-ico-selected";

static NSString * const ACCESSORY_ENTITY_DESCRIPTION = @"Accessory";
static NSString * const CLOSET_CATEGORY_ENTITY_DESCRIPTION = @"ClosetCategory";
static NSString * const LANGUAGE_GROUP_ENTITY_DESCRIPTION = @"LanguageGroup";
static NSString * const LANGUAGE_BLOCK_ENTITY_DESCRIPTION = @"LanguageBlock";
static NSString * const FEELING_ENTITY_DESCRIPTION = @"Feeling";
static NSString * const NAME_SORT_DESCRIPTOR_KEY = @"name";

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