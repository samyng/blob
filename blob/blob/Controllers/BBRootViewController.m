//
//  BBRootViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBRootViewController.h"
#import "BBClosetViewController.h"
#import "BBMyBlobViewController.h"
#import "BBSecretLanguageViewController.h"

@interface BBRootViewController ()
@property (weak, nonatomic) IBOutlet UIView *titleBarBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *tabBarBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) UIViewController *currentChildViewController;
@end

@implementation BBRootViewController

#pragma mark - Lifecycle

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
    [self displayMyBlobViewController];
}

# pragma mark - Child View Controller Methods

- (void)displayChildViewController:(UIViewController *)childViewController;
{
    [self addChildViewController:childViewController];
    childViewController.view.frame = [self childViewControllerFrame];
    [self.containerView addSubview:childViewController.view];
    [childViewController didMoveToParentViewController:self];
    self.currentChildViewController = childViewController;
}

- (void)hideChildViewController
{
    if (self.currentChildViewController)
    {
        [self.currentChildViewController willMoveToParentViewController:nil];
        [self.currentChildViewController.view removeFromSuperview];
        [self.currentChildViewController removeFromParentViewController];
        self.currentChildViewController = nil;
    }
}

- (void)displayClosetViewController {
    [self hideChildViewController];
    BBClosetViewController *closetViewController = [[BBClosetViewController alloc] initWithNibName:nil
                                                                                      bundle:nil];
    [self displayChildViewController:closetViewController];
}

- (void)displayMyBlobViewController {
    [self hideChildViewController];
    BBMyBlobViewController *myBlobViewController = [[BBMyBlobViewController alloc] initWithNibName:nil
                                                                                      bundle:nil];
    [self displayChildViewController:myBlobViewController];
}

- (void)displaySecretLanguageViewController {
    [self hideChildViewController];
    BBSecretLanguageViewController *viewController = [[BBSecretLanguageViewController alloc] initWithNibName:nil
                                                                                                      bundle:nil];
    [self displayChildViewController:viewController];
}

#pragma mark - Helper Methods

- (CGRect)childViewControllerFrame
{
    CGPoint origin = CGPointZero;
    CGFloat width = CGRectGetWidth(self.containerView.frame);
    CGFloat height = CGRectGetHeight(self.containerView.frame);
    return CGRectMake(origin.x, origin.y, width, height);
}

@end
