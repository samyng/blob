//
//  BBExpandedLanguageBlockImageView.h
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBLanguageBlockView;
@class BBExpandedLanguageBlockImageView;

@protocol ExpandedLanguageBlockDelegate <NSObject>

- (void)panDidChange:(UIPanGestureRecognizer *)sender forExpandedLanguageBlockImageView:(BBExpandedLanguageBlockImageView *)draggableImageView;
- (void)panDidEnd:(UIPanGestureRecognizer *)sender forExpandedLanguageBlockImageView:(BBExpandedLanguageBlockImageView *)draggableImageView;

@end

@interface BBExpandedLanguageBlockImageView : UIImageView
@property (weak, nonatomic) id <ExpandedLanguageBlockDelegate> delegate;
@end
