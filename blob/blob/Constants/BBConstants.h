#import <Foundation/Foundation.h>

static NSString * const BLOB_TITLE = @"BLOB LOGO";
static NSString * const BLOB_FONT_REGULAR = @"GillSans";
static NSString * const BLOB_FONT_BOLD = @"GillSans-Bold";
static NSString * const CLOSET_ICON_NAME = @"closet-ico-selected";
static NSString * const MY_BLOB_ICON_NAME = @"my-blob-ico-selected";
static NSString * const SECRET_LANGUAGE_ICON_NAME = @"secret-lang-ico-selected";

static NSString * const ACCESSORY_THUMBNAIL_FORMAT = @"thumbnail_%@";
static NSString * const ACCESSORY_ENTITY_DESCRIPTION = @"Accessory";
static NSString * const CLOSET_CATEGORY_ENTITY_DESCRIPTION = @"ClosetCategory";
static NSString * const LANGUAGE_GROUP_ENTITY_DESCRIPTION = @"LanguageGroup";
static NSString * const LANGUAGE_BLOCK_ENTITY_DESCRIPTION = @"LanguageBlock";
static NSString * const FEELING_ENTITY_DESCRIPTION = @"Feeling";
static NSString * const NAME_SORT_DESCRIPTOR_KEY = @"name";

static NSString * const ALL_CATEGORY = @"All";
static NSString * const FOOD_CATEGORY = @"Food";
static NSString * const FRIENDS_CATEGORY = @"Friends";
static NSString * const PLACES_CATEGORY = @"Places";
static NSString * const INSTRUMENTS_CATEGORY = @"Instruments";
static NSString * const CLOTHES_CATEGORY = @"Clothes";
static NSString * const FURNITURE_CATEGORY = @"Furniture";
static NSString * const ART_SUPPLIES_CATEGORY = @"Art Supplies";

static NSString * const FEELINGS_TITLE = @"Feelings";
static NSString * const REACTIONS_GROUP = @"Reactions";
static NSString * const FROM_CLOSET_GROUP = @"From Closet";
static NSString * const CONTROL_GROUP = @"Control";
static NSString * const OPERATORS_GROUP = @"Operators";
static NSString * const VARIABLES_GROUP = @"Variables";

static NSString * const IF_THEN_BLOCK_NAME = @"ifThen";
static NSString * const IF_THEN_ELSE_BLOCK_NAME = @"ifThenElse";
static NSString * const WAIT_BLOCK_NAME = @"wait";
static NSString * const REPEAT_BLOCK_NAME = @"repeat";
static NSString * const NOT_BLOCK_NAME = @"not";
static NSString * const GREATER_THAN_BLOCK_NAME = @"greaterThan";
static NSString * const LESS_THAN_BLOCK_NAME = @"lessThan";
static NSString * const EQUAL_TO_BLOCK_NAME = @"equalTo";
static NSString * const ADDITION_BLOCK_NAME = @"addition";
static NSString * const SUBTRACTION_BLOCK_NAME = @"subtraction";
static NSString * const MULTIPLICATION_BLOCK_NAME = @"multiplication";
static NSString * const DIVISION_BLOCK_NAME = @"division";
static NSString * const AND_BLOCK_NAME = @"and";
static NSString * const OR_BLOCK_NAME = @"or";

static NSString * const IF_THEN_BLOCK_NIB_NAME = @"BBIfThenBlockView";
static NSString * const IF_THEN_ELSE_BLOCK_NIB_NAME = @"BBIfThenElseBlockView";
static NSString * const WAIT_BLOCK_NIB_NAME = @"BBWaitBlockView";
static NSString * const REPEAT_BLOCK_NIB_NAME = @"BBRepeatBlockView";
static NSString * const NOT_OPERATOR_BLOCK_NIB_NAME = @"BBNotBlockView";
static NSString * const LOGIC_OPERATOR_BLOCK_NIB_NAME = @"BBLogicOperatorBlockView";
static NSString * const ACCESSORY_BLOCK_NIB_NAME = @"BBAccessoryBlockView";
static NSString * const OPERATOR_BLOCK_NIB_NAME = @"BBOperatorBlockView";
static NSString * const REACTION_BLOCK_NIB_NAME = @"BBReactionBlockView";

static NSString * const CHOOSE_FEELING_TITLE = @"Choose a feeling to code";
static NSString * const MY_BLOB_TITLE = @"My Blob";
static NSString * const CLOSET_TITLE = @"Closet";
static NSString * const PLUS_ADD_NEW_LABEL = @"+ NEW";

static NSInteger const kTotalNumberOfSections = 1;
static CGFloat const BLOB_FONT_19PT = 19.0f;
static CGFloat const BLOB_FONT_21PT = 21.0f;
static CGFloat const BLOB_PADDING_5PX = 5.0f;
static CGFloat const BLOB_PADDING_10PX = 10.0f;
static CGFloat const BLOB_PADDING_15PX = 15.0f;
static CGFloat const BLOB_PADDING_20PX = 20.0f;
static CGFloat const BLOB_PADDING_25PX = 25.0f;
static CGFloat const BLOB_PADDING_30PX = 30.0f;
static CGFloat const BLOB_PADDING_45PX = 45.0f;
static CGFloat const kAlphaZero = 0.0f;
static CGFloat const kAlphaHalf = 0.5f;
static CGFloat const kAlphaOpaque = 1.0f;
static CGFloat const kViewAnimationDuration = 0.25f;

static CGFloat const BLOB_BLOCK_SLOT_CORNER_RADIUS = 5.0f;
static CGFloat const BLOB_QUANTITY_CORNER_RADIUS = 18.0f;

static CGFloat const MARGIN_OF_ERROR_CONSTANT = 2.0f;


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
+ (UIColor *)tealColor;
+ (UIColor *)tealBackgroundColor;
+ (UIColor *)tealTextColor;

+ (UIColor *)textColorForCellWithLanguageGroupName:(NSString *)name;
+ (UIColor *)backgroundColorForCellWithLanguageGroupName:(NSString *)name;
+ (UIColor *)colorForCellWithLanguageGroupName:(NSString *)name;

+ (CGSize)screenSize;

@end