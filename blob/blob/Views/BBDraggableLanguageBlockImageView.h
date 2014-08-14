//
//  BBDraggableLanguageBlockImageView.h
//  blob
//
//  Created by Sam Yang on 8/14/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBLanguageBlockView;
@class BBDraggableLanguageBlockImageView;

@protocol DraggableLanguageBlockDelegate <NSObject>

- (void)panDidChange:(UIPanGestureRecognizer *)sender forDraggableLanguageBlockImageView:(BBDraggableLanguageBlockImageView *)draggableImageView;
- (void)panDidEnd:(UIPanGestureRecognizer *)sender forDraggableLanguageBlockImageView:(BBDraggableLanguageBlockImageView *)draggableImageView;

@end

@interface BBDraggableLanguageBlockImageView : UIImageView
@property (weak, nonatomic) id <DraggableLanguageBlockDelegate> delegate;
@end
