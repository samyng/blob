//
//  BBLanguageBlockView.h
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBLanguageBlockView;

@protocol LanguageBlockDelegate <NSObject>

- (void)panDidChange:(UIPanGestureRecognizer *)sender forLanguageBlockView:(BBLanguageBlockView *)blockView;
- (void)panDidEnd:(UIPanGestureRecognizer *)sender forLanguageBlockView:(BBLanguageBlockView *)blockView;

@end

@interface BBLanguageBlockView : UIView
@property (weak, nonatomic) id <LanguageBlockDelegate> delegate;
@end
