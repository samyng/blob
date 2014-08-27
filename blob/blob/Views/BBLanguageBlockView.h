//
//  BBLanguageBlockView.h
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBLanguageBlock;
@class BBLanguageBlockView;
@class BBParameterView;

@protocol LanguageBlockDelegate <NSObject>

- (void)panDidBegin:(UIPanGestureRecognizer *)sender forLanguageBlockView:(BBLanguageBlockView *)blockView;
- (void)panDidChange:(UIPanGestureRecognizer *)sender forLanguageBlockView:(BBLanguageBlockView *)blockView;
- (void)panDidEnd:(UIPanGestureRecognizer *)sender forLanguageBlockView:(BBLanguageBlockView *)blockView;
- (void)updateFrameForTouchedLanguageBlockView:(BBLanguageBlockView *)touchedBlockView andDraggedLanguageBlockView:(BBLanguageBlockView *)draggedBlockView
                                    withWidth:(CGFloat)width
                                    withHeight:(CGFloat)height
                withParameterViewOrigin:(CGPoint)parameterOrigin;

@end

@interface BBLanguageBlockView : UIView
@property (weak, nonatomic) id <LanguageBlockDelegate> delegate;
@property (strong, nonatomic) BBLanguageBlock *languageBlock;
@property (strong, nonatomic) NSMutableSet *snappedBlockViews;
@property (nonatomic) BOOL overlapped;
@property (nonatomic) BOOL isOverlapped;
@property (nonatomic) BOOL hasSlotBlock;
- (void)touchedByLanguageBlockView:(BBLanguageBlockView *)blockView
                   atTouchLocation:(CGPoint)touchLocation;
- (void)untouchedByLanguageBlockView:(BBLanguageBlockView *)blockView
                   fromStartingOrigin:(CGPoint)blockViewStartingOrigin;
- (void)moveCenterToPoint:(CGPoint)newCenterPoint;
- (void)updateFrameForBlockStack:(BBParameterView *)blockStack withBlockView:(BBLanguageBlockView *)blockView;
- (NSInteger)numberOfAdditionalStackBlockSpaces;
- (CGSize)originalSize;
- (CGRect)originalFrame;
@end
