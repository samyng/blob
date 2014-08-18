//
//  BBQuantityParameterView.h
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBLanguageBlockView;

@interface BBQuantityParameterView : UIView
@property (nonatomic) BOOL isVacant;
- (BOOL)acceptsBlockView:(BBLanguageBlockView *)blockView;
@end
