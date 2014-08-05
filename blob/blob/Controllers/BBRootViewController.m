//
//  BBRootViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBRootViewController.h"

@interface BBRootViewController ()
@property (weak, nonatomic) IBOutlet UIView *titleBarBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *tabBarBackgroundView;

@end

@implementation BBRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [BBConstants lightGrayBackgroundColor];
        self.tabBarBackgroundView.backgroundColor = [BBConstants lightGrayTabBackgroundColor];
        
        self.titleBarBackgroundView.layer.borderWidth =
        self.tabBarBackgroundView.layer.borderWidth = BORDER_WIDTH;
        
        self.titleBarBackgroundView.layer.borderColor =
        self.tabBarBackgroundView.layer.borderColor = [BBConstants lightGrayBorderColor].CGColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
