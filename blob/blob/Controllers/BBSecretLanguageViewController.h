//
//  BBSecretLanguageViewController.h
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBFeeling;

@interface BBSecretLanguageViewController : UIViewController
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) BBFeeling *feeling;
@end
