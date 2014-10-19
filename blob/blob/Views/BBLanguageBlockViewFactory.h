#import <Foundation/Foundation.h>
@class BBLanguageBlockView;
@class BBLanguageBlock;

@interface BBLanguageBlockViewFactory : NSObject
+ (BBLanguageBlockView *)viewForBlock:(BBLanguageBlock *)languageBlock;
@end
