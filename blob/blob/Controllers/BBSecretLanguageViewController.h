#import <UIKit/UIKit.h>
@class BBFeeling;

@interface BBSecretLanguageViewController : UIViewController
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) BBFeeling *feeling;
@end
