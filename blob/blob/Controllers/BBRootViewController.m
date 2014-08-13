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
#import "SWRevealViewController.h"
#import "BBChooseFeelingViewController.h"

@interface BBRootViewController ()
@property (weak, nonatomic) IBOutlet UIView *tabBarBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *closetButton;
@property (weak, nonatomic) IBOutlet UIButton *myBlobButton;
@property (weak, nonatomic) IBOutlet UIButton *secretLanguageButton;
@property (strong, nonatomic) UIViewController *currentChildViewController;
@property (strong, nonatomic) NSArray *tabButtons;
@end

@implementation BBRootViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    SWRevealViewController *revealViewController = [self revealViewController];
    [revealViewController panGestureRecognizer];
    [revealViewController tapGestureRecognizer];
    UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = menuBarButtonItem;

    self.tabButtons = @[self.closetButton, self.myBlobButton, self.secretLanguageButton];
    for (UIButton *button in self.tabButtons)
    {
        [button setTitleColor:[BBConstants tealColor] forState:UIControlStateNormal];
    }
    [self.closetButton setTitleColor:[BBConstants blueColor] forState:UIControlStateSelected];
    [self.myBlobButton setTitleColor:[BBConstants pinkColor] forState:UIControlStateSelected];
    [self.secretLanguageButton setTitleColor:[BBConstants orangeColor] forState:UIControlStateSelected];
    
    UIImage *defaultClosetImage = [[UIImage imageNamed:CLOSET_ICON_NAME] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.closetButton setImage:defaultClosetImage forState:UIControlStateNormal];
    UIImage *defaultMyBlobImage = [[UIImage imageNamed:MY_BLOB_ICON_NAME] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.myBlobButton setImage:defaultMyBlobImage forState:UIControlStateNormal];
    UIImage *defaultSecretLanguageImage = [[UIImage imageNamed:SECRET_LANGUAGE_ICON_NAME] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.secretLanguageButton setImage:defaultSecretLanguageImage forState:UIControlStateNormal];
    
    [self myBlobButtonPressed:self.myBlobButton];
}

# pragma mark - Button Pressed

- (IBAction)closetButtonPressed:(UIButton *)sender {
    [self displayClosetViewController];
    self.closetButton.selected = YES;
    self.myBlobButton.selected =
    self.secretLanguageButton.selected = NO;
}

- (IBAction)myBlobButtonPressed:(UIButton *)sender {
    [self displayMyBlobViewController];
    self.myBlobButton.selected = YES;
    self.closetButton.selected =
    self.secretLanguageButton.selected = NO;
}

- (IBAction)secretLanguageButtonPressed:(UIButton *)sender {
    [self displaySecretLanguageViewController];
    self.secretLanguageButton.selected = YES;
    self.myBlobButton.selected =
    self.closetButton.selected = NO;
}

# pragma mark - Child View Controller Methods

- (void)displayChildViewController:(UIViewController *)childViewController;
{
    [self hideChildViewController];
    childViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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
    BBClosetViewController *closetViewController = [[BBClosetViewController alloc] initWithNibName:nil
                                                                                      bundle:nil];
    closetViewController.context = self.context;
    [self displayChildViewController:closetViewController];
}

- (void)displayMyBlobViewController {
    BBMyBlobViewController *myBlobViewController = [[BBMyBlobViewController alloc] initWithNibName:nil
                                                                                      bundle:nil];
    myBlobViewController.context = self.context;
    [self displayChildViewController:myBlobViewController];
}

- (void)displaySecretLanguageViewController {
    BBChooseFeelingViewController *feelingViewController = [[BBChooseFeelingViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationItem.title = CHOOSE_FEELING_TITLE;
    feelingViewController.context = self.context;
    [self displayChildViewController:feelingViewController];
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
