//
//  BBCollapsedLanguageBlockImageView.h
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBLanguageBlock;
@class BBCollapsedLanguageBlockImageView;
@class BBLanguageBlockView;

@protocol CollapsedLanguageBlockDelegate <NSObject>

- (void)panDidBegin:(UIPanGestureRecognizer *)sender inCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)collapsedView;
- (void)panDidChange:(UIPanGestureRecognizer *)sender forCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)collapsedView;
- (void)panDidEnd:(UIPanGestureRecognizer *)sender forCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)collapsedView;

@end

@interface BBCollapsedLanguageBlockImageView : UIImageView
@property (weak, nonatomic) id <CollapsedLanguageBlockDelegate> delegate;
@property (strong, nonatomic) UILabel *languageBlockLabel;
@property (strong, nonatomic) BBLanguageBlockView *expandedBlockView;
- (UIImage *)rasterizedImageCopy;
- (void)configureWithLanguageBlock:(BBLanguageBlock *)languageBlock;
@property (strong, nonatomic) BBLanguageBlock *languageBlock;
@end