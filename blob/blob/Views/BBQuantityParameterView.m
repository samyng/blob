//
//  BBQuantityParameterView.m
//  blob
//
//  Created by Sam Yang on 8/16/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBQuantityParameterView.h"
#import "BBLanguageBlock+Configure.h"
#import "BBLanguageBlockView.h"

@interface BBQuantityParameterView () <UITextFieldDelegate>
@property (strong, nonatomic) UITextField *quantityTextField;
@end

@implementation BBQuantityParameterView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup
{
    self.layer.cornerRadius = BLOB_QUANTITY_CORNER_RADIUS;
    CGRect textFieldFrame = CGRectInset(self.bounds, 10.0f, 0.0f);
    self.quantityTextField = [[UITextField alloc] initWithFrame:textFieldFrame];
    [self addSubview:self.quantityTextField];
    self.quantityTextField.delegate = self;
    self.quantityTextField.returnKeyType = UIReturnKeyDone;
    self.quantityTextField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark - Text Field Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength > 2)
    {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.textAlignment = NSTextAlignmentLeft;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Override Methods

- (BOOL)acceptsBlockView:(BBLanguageBlockView *)blockView
{
    return [blockView.languageBlock isMathOperatorBlock] ? YES : NO;
}

@end
