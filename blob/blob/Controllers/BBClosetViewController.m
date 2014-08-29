//
//  BBClosetViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBClosetViewController.h"
#import "BBAccessoryCollectionCell.h"
#import "BBAccessory+Configure.h"
#import "BBClosetCategory.h"

static NSString * const kCategoriesTableCellIdentifier = @"categoriesTableCellIdentifier";
static NSString * const kAccessoriesCollectionCellIdentifier = @"accessoriesCollectionCellIdentifier";
static NSInteger const kAllSectionIndex = 0;
static NSInteger const kNewAccessoryAlertViewTextFieldIndex = 0;
static NSInteger const kAddAccessoryAlertViewButtonIndex = 1;


@interface BBClosetViewController () <UITableViewDataSource, UICollectionViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *accessoriesCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *addNewAccessoryButton;
@property (strong, nonatomic) UIAlertView *addAccessoryAlertView;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *accessories;
@property (strong, nonatomic) NSFetchedResultsController *categoriesFetchedResultsController;
@end

@implementation BBClosetViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.categoriesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCategoriesTableCellIdentifier];
    [self.accessoriesCollectionView registerNib:[UINib nibWithNibName:@"BBAccessoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier];
    [self.addNewAccessoryButton setTitle:PLUS_ADD_NEW_LABEL forState:UIControlStateNormal];
    [self populateCategories];
    [self.categoriesTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Fetch Data

- (void)populateCategories
{
    NSManagedObjectContext *context = self.context;
    if (context)
    {
        self.categoriesFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self allCategoriesFetchRequest]
                                                                                      managedObjectContext:context
                                                                                        sectionNameKeyPath:nil
                                                                                                 cacheName:nil];
        [self.categoriesFetchedResultsController setDelegate:self];
        [self.categoriesFetchedResultsController performFetch:nil];
        self.categories = [self.categoriesFetchedResultsController fetchedObjects];
        [self populateAccessories];
    }
}

- (void)populateAccessories
{
    if (self.categories)
    {
        NSMutableArray *accessories = [[NSMutableArray alloc] init];
        for (BBClosetCategory *category in self.categories)
        {
            [accessories addObjectsFromArray:[category.accessories allObjects]];
        }
        self.accessories = accessories;
    }
}

- (NSFetchRequest *)allCategoriesFetchRequest
{
    NSFetchRequest *allCategoriesFetchRequest = [NSFetchRequest fetchRequestWithEntityName:CLOSET_CATEGORY_ENTITY_DESCRIPTION];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:NAME_SORT_DESCRIPTOR_KEY ascending:YES];
    [allCategoriesFetchRequest setSortDescriptors:@[sort]];
    return allCategoriesFetchRequest;
}

#pragma mark - Button Action

- (IBAction)addButtonPressed:(UIButton *)sender {
    self.addAccessoryAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Enter code" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    self.addAccessoryAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [self.addAccessoryAlertView textFieldAtIndex:kNewAccessoryAlertViewTextFieldIndex].delegate = self;
    [self.addAccessoryAlertView show];
}

#pragma mark - Text Field Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.addAccessoryAlertView dismissWithClickedButtonIndex:kNewAccessoryAlertViewTextFieldIndex animated:YES];
    return YES;
}

#pragma mark - Alert View Delegate Methods

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kAddAccessoryAlertViewButtonIndex)
    {
        self.addAccessoryAlertView = nil;
        UIAlertView *confirmAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"Babies added!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        NSEntityDescription *accessoryEntityDescription = [NSEntityDescription entityForName:ACCESSORY_ENTITY_DESCRIPTION inManagedObjectContext:self.context];
        BBAccessory *babies = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                                   insertIntoManagedObjectContext:self.context];
        babies.name = @"babies";
        for (BBClosetCategory *closetCategory in self.categories)
        {
            if ([closetCategory.name isEqualToString:FRIENDS_CATEGORY])
            {
                [closetCategory addAccessoriesObject:babies];
            }
        }
        [self populateAccessories];
        [confirmAlertView show];
        [self.accessoriesCollectionView reloadData];
    }
}

#pragma mark - Table View Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kTotalNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.categoriesTableView dequeueReusableCellWithIdentifier:kCategoriesTableCellIdentifier];
    NSString *name;
    if (self.categories)
    {
        name = [[self.categories objectAtIndex:indexPath.row] name];
    }
    cell.textLabel.text = name;
    cell.textLabel.font = [UIFont fontWithName:BLOB_FONT_BOLD size:19.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.contentView.backgroundColor = [BBConstants blueColor];
    
    CGRect frame = cell.contentView.frame;
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    selectedBackgroundView.backgroundColor = [BBConstants blueBackgroundColor];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.accessoriesCollectionView reloadData];
}

#pragma mark - Collection View Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kTotalNumberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger selectedRowIndex = [self categoriesTableCellSelectedRowIndex];
    switch (selectedRowIndex)
    {
        case 0:
            return [self.accessories count];
        default:
            return [[[self.categories objectAtIndex:selectedRowIndex] accessories] count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBAccessoryCollectionCell *cell = [self.accessoriesCollectionView dequeueReusableCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier
                                                                                                forIndexPath:indexPath];
    
    BBAccessory *accessory;
    NSArray *accessories;
    NSInteger selectedRowIndex = [self categoriesTableCellSelectedRowIndex];
    switch (selectedRowIndex)
    {
        case kAllSectionIndex:
            accessory = [self.accessories objectAtIndex:indexPath.item];
            break;
        default:
            accessories = [[[self.categories objectAtIndex:selectedRowIndex] accessories] allObjects];
            accessory = [accessories objectAtIndex:indexPath.item];
            break;
    }
    
    if (accessory)
    {
        [cell configureWithAccessory:accessory];
    }
    
    return cell;
}

#pragma mark - Helper Methods

- (NSInteger)categoriesTableCellSelectedRowIndex
{
    return [self.categoriesTableView indexPathForSelectedRow].row;
}

#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.categoriesTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.categoriesTableView insertRowsAtIndexPaths:@[newIndexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.categoriesTableView reloadRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.categoriesTableView deleteRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.categoriesTableView deleteRowsAtIndexPaths:@[indexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.categoriesTableView insertRowsAtIndexPaths:@[newIndexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.categoriesTableView endUpdates];
}



@end
