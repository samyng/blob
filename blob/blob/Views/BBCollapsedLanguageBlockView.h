//
//  BBCollapsedLanguageBlockView.h
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBCollapsedLanguageBlockView;
@class BBLanguageBlock;
@class BBExpandedLanguageBlockImageView;

@protocol CollapsedLanguageBlockViewDelegate <NSObject>

- (void)panDidBegin:(UIPanGestureRecognizer *)sender inCollapsedLanguageBlockView:(BBCollapsedLanguageBlockView *)languageBlockView;
- (void)panDidChange:(UIPanGestureRecognizer *)sender forCollapsedLanguageBlockView:(BBCollapsedLanguageBlockView *)languageBlockView;

@end

@interface BBCollapsedLanguageBlockView : UIView
@property (weak, nonatomic) id <CollapsedLanguageBlockViewDelegate> delegate;
@property (strong, nonatomic) BBLanguageBlock *languageBlock;
@property (strong, nonatomic) BBExpandedLanguageBlockImageView *draggableCopyImageView;
- (UIImage *)rasterizedImageCopy;
@end
