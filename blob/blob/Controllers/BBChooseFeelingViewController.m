//
//  BBChooseFeelingViewController.m
//  blob
//
//  Created by Sam Yang on 8/13/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBChooseFeelingViewController.h"
#import "BBSecretLanguageViewController.h"
#import "BBFeeling.h"

static NSString * const kSearchFeelingsTableCellIdentifier = @"searchFeelingsTableCellIdentifier";
static NSInteger kAddNewRowIndex = 0;
static NSInteger kAddNewRowOffset = 1;
#define offscreenFrame CGRectMake(2*CGRectGetWidth(self.view.frame), 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
#define onscreenFrame CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))

@interface BBChooseFeelingViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *feelingsTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *feelingsSearchBar;
@property (strong, nonatomic) NSFetchedResultsController *feelingsFetchedResultsController;
@property (strong, nonatomic) BBSecretLanguageViewController *secretLanguageViewController;
@property (strong, nonatomic) NSArray *feelings;
@end

@implementation BBChooseFeelingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [BBConstants blueBackgroundColor];
    self.feelingsTableView.backgroundColor = [BBConstants blueBackgroundColor];
    self.feelingsSearchBar.backgroundColor = [UIColor whiteColor];
    self.feelingsSearchBar.barTintColor = [BBConstants blueBackgroundColor];
    self.feelingsSearchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.feelingsTableView.separatorColor = [BBConstants magnesiumGrayColor];
    [self populateFeelings];
}

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
        self.feelings = [[self.feelingsFetchedResultsController fetchedObjects] mutableCopy];
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
        UIAlertView *comingSoon = [[UIAlertView alloc] initWithTitle:@"Oh darn" message:@"Functionality coming soon" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Okay", nil];
        [comingSoon show];
        [self.feelingsTableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    else
    {
        self.secretLanguageViewController = [[BBSecretLanguageViewController alloc] initWithNibName:nil bundle:nil];
        self.secretLanguageViewController.context = self.context;
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

- (BBFeeling *)feelingAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.feelings objectAtIndex:indexPath.row - kAddNewRowOffset];
}

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
