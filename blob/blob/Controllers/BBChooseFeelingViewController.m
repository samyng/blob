#import "BBChooseFeelingViewController.h"
#import "BBSecretLanguageViewController.h"
#import "BBFeeling.h"

static NSString * const kSearchFeelingsTableCellIdentifier = @"searchFeelingsTableCellIdentifier";
static NSInteger kAddNewRowIndex = 0;
static NSInteger kAddNewRowOffset = 1;
static NSInteger kNewFeelingAlertViewTextFieldIndex = 0;
static NSInteger kNewFeelingAlertViewAddButtonIndex = 1;
#define offscreenFrame CGRectMake(2*CGRectGetWidth(self.view.frame), CGPointZero.y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
#define onscreenFrame CGRectMake(CGPointZero.x, CGPointZero.y, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))

@interface BBChooseFeelingViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *feelingsTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *feelingsSearchBar;
@property (strong, nonatomic) NSFetchedResultsController *feelingsFetchedResultsController;
@property (strong, nonatomic) BBSecretLanguageViewController *secretLanguageViewController;
@property (strong, nonatomic) UIAlertView *addFeelingAlertView;
@property (strong, nonatomic) NSArray *feelings;
@end

@implementation BBChooseFeelingViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.feelingsSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    [self populateFeelings];
}

#pragma mark - Setup

- (void)populateFeelings
{
    NSManagedObjectContext *context = self.context;
    if (context)
    {
        self.feelingsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self allFeelingsFetchRequest]
                                                                                    managedObjectContext:context
                                                                                      sectionNameKeyPath:nil
                                                                                               cacheName:nil];
        [self.feelingsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kSearchFeelingsTableCellIdentifier];
        [self.feelingsFetchedResultsController setDelegate:self];
        [self.feelingsFetchedResultsController performFetch:nil];
        self.feelings = [self.feelingsFetchedResultsController fetchedObjects];
    }
}

- (NSFetchRequest *)allFeelingsFetchRequest
{
    NSFetchRequest *allFeelingsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:FEELING_ENTITY_DESCRIPTION];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:NAME_SORT_DESCRIPTOR_KEY ascending:YES];
    [allFeelingsFetchRequest setSortDescriptors:@[sort]];
    return allFeelingsFetchRequest;
}

#pragma mark - Table View Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feelings count] + kAddNewRowOffset;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.feelingsTableView dequeueReusableCellWithIdentifier:kSearchFeelingsTableCellIdentifier];
    if (indexPath.row == kAddNewRowIndex)
    {
        cell.textLabel.textColor = [BBConstants orangeColor];
        cell.textLabel.text = PLUS_ADD_NEW_LABEL;
    }
    else
    {
        cell.textLabel.textColor = [BBConstants pinkColor];
        if (self.feelings)
        {
            cell.textLabel.text = [[self feelingAtIndexPath:indexPath] name];
        }
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont fontWithName:BLOB_FONT_REGULAR size:19.0f];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == kAddNewRowIndex)
    {
        [self.feelingsTableView deselectRowAtIndexPath:indexPath animated:NO];
        self.addFeelingAlertView = [[UIAlertView alloc]initWithTitle:nil message:@"Add a new feeling:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        self.addFeelingAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [self.addFeelingAlertView textFieldAtIndex:kNewFeelingAlertViewTextFieldIndex].delegate = self;
        [self.addFeelingAlertView show];
    }
    else
    {
        self.secretLanguageViewController = [[BBSecretLanguageViewController alloc] initWithNibName:nil bundle:nil];
        self.secretLanguageViewController.context = self.context;
        self.secretLanguageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.secretLanguageViewController.feeling = [self feelingAtIndexPath:indexPath];
        self.secretLanguageViewController.view.frame = offscreenFrame;
        [self.view addSubview:self.secretLanguageViewController.view];
        [UIView animateWithDuration:0.5f animations:^{
            self.secretLanguageViewController.view.frame = onscreenFrame;
        } completion:^(BOOL finished) {
            [self.feelingsTableView deselectRowAtIndexPath:indexPath animated:NO];
            self.parentViewController.navigationItem.title = [NSString stringWithFormat:@"When Blob is %@", self.secretLanguageViewController.feeling.name];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
            self.parentViewController.navigationItem.rightBarButtonItem = doneButton;
        }];
    }
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.addFeelingAlertView dismissWithClickedButtonIndex:kNewFeelingAlertViewAddButtonIndex animated:YES];
    return YES;
}

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kNewFeelingAlertViewAddButtonIndex)
    {
        [self addNewFeelingFromAlertView:alertView];
        self.addFeelingAlertView = nil;
    }
}

#pragma mark - Helper Methods

- (void)addNewFeelingFromAlertView:(UIAlertView *)alertView
{
    NSEntityDescription *feelingEntityDescription = [NSEntityDescription entityForName:FEELING_ENTITY_DESCRIPTION inManagedObjectContext:self.context];
    BBFeeling *newFeeling = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:self.context];
    UITextField *newFeelingTextField = [alertView textFieldAtIndex:kNewFeelingAlertViewTextFieldIndex];
    newFeeling.name = newFeelingTextField.text;
    [self populateFeelings];
    [self.feelingsTableView reloadData];
}

- (BBFeeling *)feelingAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.feelings objectAtIndex:indexPath.row - kAddNewRowOffset];
}

#pragma mark - Dismiss Modal

- (void)doneButtonPressed:(UIBarButtonItem *)doneButton
{
    self.parentViewController.navigationItem.title = CHOOSE_FEELING_TITLE;
    [UIView animateWithDuration:0.5f animations:^{
        self.secretLanguageViewController.view.frame = offscreenFrame;
    } completion:^(BOOL finished) {
        [self.secretLanguageViewController.view removeFromSuperview];
        self.secretLanguageViewController = nil;
        self.parentViewController.navigationItem.rightBarButtonItem = nil;
    }];
}

@end
