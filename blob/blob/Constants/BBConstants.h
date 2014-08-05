#import <Foundation/Foundation.h>

static NSString * const MY_BLOB_TITLE = @"My Blob";
static NSString * const CLOSET_TITLE = @"Closet";
static NSString * const SECRET_LANGUAGE_TITLE = @"Secret Language";

static CGFloat const BORDER_WIDTH = 2.0f;

@interface BBConstants : NSObject
+ (UIColor *)lightGrayBackgroundColor;
+ (UIColor *)lightGrayTabBackgroundColor;
+ (UIColor *)lightGrayBorderColor;
@end