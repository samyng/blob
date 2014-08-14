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
@class BBExpandedLanguageBlockImageView;

@protocol CollapsedLanguageBlockDelegate <NSObject>

- (void)panDidBegin:(UIPanGestureRecognizer *)sender inCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)languageBlockView;
- (void)panDidChange:(UIPanGestureRecognizer *)sender forCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)languageBlockView;

@end

@interface BBCollapsedLanguageBlockImageView : UIImageView
@property (weak, nonatomic) id <CollapsedLanguageBlockDelegate> delegate;
@property (strong, nonatomic) BBLanguageBlock *languageBlock;
@property (strong, nonatomic) BBExpandedLanguageBlockImageView *draggableCopyImageView;
- (UIImage *)rasterizedImageCopy;
@end