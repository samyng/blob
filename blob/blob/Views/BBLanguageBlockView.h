//
//  BBLanguageBlockView.h
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBLanguageBlockView;
@class BBLanguageBlock;

@protocol LanguageBlockViewDelegate <NSObject>

- (void)panDidBegin:(UIPanGestureRecognizer *)sender inLanguageBlockView:(BBLanguageBlockView *)languageBlockView;
- (void)panDidEnd:(UIPanGestureRecognizer *)sender inLanguageBlockView:(BBLanguageBlockView *)langaugeBlockView;

@end

@interface BBLanguageBlockView : UIView
@property (weak, nonatomic) id <LanguageBlockViewDelegate> delegate;
@property (strong, nonatomic) BBLanguageBlock *languageBlock;
- (void)updateViewForState:(BOOL)isCollapsed;
- (UIImage *)rasterizedImageCopy;
@end
