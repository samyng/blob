#import "BBRootViewController.h"
#import "BBClosetViewController.h"
#import "BBMyBlobViewController.h"
#import "BBSecretLanguageViewController.h"
#import "SWRevealViewController.h"
#import "BBChooseFeelingViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface BBRootViewController ()
@property (weak, nonatomic) IBOutlet UIView *tabBarBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *closetButton;
@property (weak, nonatomic) IBOutlet UIButton *myBlobButton;
@property (weak, nonatomic) IBOutlet UIButton *secretLanguageButton;
@property (strong, nonatomic) UIViewController *currentChildViewController;
@property (strong, nonatomic) MPMoviePlayerViewController *moviePlayerViewController;
@property (strong, nonatomic) UIBarButtonItem *playIntroVideoBarButtonItem;
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
    
    self.playIntroVideoBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Watch Blob's Story" style:UIBarButtonItemStylePlain target:self action:@selector(playIntroVideo)];
    [self.playIntroVideoBarButtonItem setTintColor:[BBConstants tealColor]];
    self.navigationItem.rightBarButtonItem = self.playIntroVideoBarButtonItem;
    
    UIImage *templateClosetImage = [[UIImage imageNamed:CLOSET_ICON_NAME] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.closetButton setImage:templateClosetImage forState:UIControlStateNormal];
    UIImage *templateMyBlobImage = [[UIImage imageNamed:MY_BLOB_ICON_NAME] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.myBlobButton setImage:templateMyBlobImage forState:UIControlStateNormal];
    UIImage *templateSecretLanguageImage = [[UIImage imageNamed:SECRET_LANGUAGE_ICON_NAME] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.secretLanguageButton setImage:templateSecretLanguageImage forState:UIControlStateNormal];
    
    [self myBlobButtonPressed:self.myBlobButton];
}

- (void)playIntroVideo
{
    NSString *introVideoPath = [[NSBundle mainBundle] pathForResource:@"blob-intro" ofType:@"mp4"];
    NSURL *introVideoURL = [NSURL fileURLWithPath:introVideoPath];
    
    self.moviePlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:introVideoURL];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClicked:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(movieDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [self.navigationController presentViewController:self.moviePlayerViewController animated:YES completion:^{
    }];
}

- (void)movieDidFinish:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [self closetButtonPressed:self.closetButton];
    self.moviePlayerViewController = nil;
}

- (void)doneButtonClicked:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    [self closetButtonPressed:self.closetButton];
    self.moviePlayerViewController = nil;
}

# pragma mark - Button Pressed

- (IBAction)closetButtonPressed:(UIButton *)sender {
    [self resetNavigationBar];
    [self displayClosetViewController];
    self.closetButton.selected = YES;
    self.myBlobButton.selected =
    self.secretLanguageButton.selected = NO;
}

- (IBAction)myBlobButtonPressed:(UIButton *)sender {
    [self resetNavigationBar];
    [self displayMyBlobViewController];
    self.myBlobButton.selected = YES;
    self.closetButton.selected =
    self.secretLanguageButton.selected = NO;
}

- (IBAction)secretLanguageButtonPressed:(UIButton *)sender {
    [self resetNavigationBar];
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

- (void)resetNavigationBar
{
    self.navigationItem.title = nil;
    self.navigationItem.rightBarButtonItem = self.playIntroVideoBarButtonItem;
}

@end
