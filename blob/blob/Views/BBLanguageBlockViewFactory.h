//
//  BBLanguageBlockViewFactory.h
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BBLanguageBlockView;
@class BBLanguageBlock;

@interface BBLanguageBlockViewFactory : NSObject
+ (BBLanguageBlockView *)viewForBlock:(BBLanguageBlock *)languageBlock;
@end
