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

static NSString * const kCategoriesTableCellIdentifier = @"categoriesTableCellIdentifier";
static NSString * const kAccessoriesCollectionCellIdentifier = @"accessoriesCollectionCellIdentifier";


@interface BBClosetViewController () <UITableViewDataSource, UICollectionViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *accessoriesCollectionView;
@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *accessories;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@end

@implementation BBClosetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.categoriesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCategoriesTableCellIdentifier];
    [self.accessoriesCollectionView registerNib:[UINib nibWithNibName:@"BBAccessoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier];
    self.categories = @[ALL_CATEGORY, FOOD_CATEGORY, INSTRUMENTS_CATEGORY, PLACES_CATEGORY, FRIENDS_CATEGORY, FASHION_CATEGORY];
    [self populateAccessoryData];
    
    [self.categoriesTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)populateAccessoryData
{
    NSManagedObjectContext *context = self.context;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self allAccessoriesFetchRequest]
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
    [self.fetchedResultsController performFetch:nil];
    self.accessories = [self.fetchedResultsController fetchedObjects];
}

- (NSFetchRequest *)allAccessoriesFetchRequest
{
    NSFetchRequest *allAccessoriesFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Accessory"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:YES];
    [allAccessoriesFetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    return allAccessoriesFetchRequest;
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
    cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:17.0f];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    
    CGRect frame = cell.contentView.frame;
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    selectedBackgroundView.backgroundColor = [UIColor whiteColor];
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
    return 1;
//    NSInteger selectedRowIndex = [self categoriesTableCellSelectedRowIndex];
//    switch (selectedRowIndex)
//    {
//        case kAllSectionIndex:
//            return [self totalNumberOfAccessories];
//        case kFoodSectionIndex:
//            return [self.foods count];
//        case kClothesSectionIndex:
//            return [self.clothes count];
//        case kFriendsSectionIndex:
//            return [self.friends count];
//        case kPlacesSectionIndex:
//            return [self.places count];
//        default:
//            return 0;
//    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBAccessoryCollectionCell *cell = [self.accessoriesCollectionView dequeueReusableCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier
                                                                                                forIndexPath:indexPath];
    
//    BBAccessory *accessory;
//    NSInteger selectedRowIndex = [self categoriesTableCellSelectedRowIndex];
//    switch (selectedRowIndex)
//    {
//        case kAllSectionIndex:
//            accessory = [[self allAccessories] objectAtIndex:indexPath.item];
//            break;
//        case kFoodSectionIndex:
//             accessory = [self.foods objectAtIndex:indexPath.item];
//            break;
//        case kClothesSectionIndex:
//            accessory = [self.clothes objectAtIndex:indexPath.item];
//            break;
//        case kFriendsSectionIndex:
//            accessory = [self.friends objectAtIndex:indexPath.item];
//            break;
//        case kPlacesSectionIndex:
//            accessory = [self.places objectAtIndex:indexPath.item];
//            break;
//        default:
//            accessory = nil;
//    }
//    
//    if (accessory)
//    {
//        [cell configureWithAccessory:accessory];
//    }
    
    return cell;
}

#pragma mark - Helper Methods

- (NSInteger)totalNumberOfAccessories
{
    return 1;
}

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
