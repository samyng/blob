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


@interface BBClosetViewController () <UITableViewDataSource, UICollectionViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *accessoriesCollectionView;
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
    [self populateCategories];

//TODO - preload model data and test heavily before shipping final product -SY (8/8/14)
    
#if DEBUG
    if ([self.categories count] == 0)
    {
        [self createTestData];
        [self populateCategories];
    }
#endif
    
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
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
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

#pragma mark - Create test data

- (void)createTestData
{
    NSManagedObjectContext *context = self.context;
    NSEntityDescription *accessoryEntityDescription = [NSEntityDescription entityForName:ACCESSORY_ENTITY_DESCRIPTION inManagedObjectContext:context];
    NSEntityDescription *categoryEntityDescription = [NSEntityDescription entityForName:CLOSET_CATEGORY_ENTITY_DESCRIPTION inManagedObjectContext:context];
    
    // Accessories
    
    BBAccessory *apple = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                              insertIntoManagedObjectContext:context];
    apple.name = @"apple";
    
    BBAccessory *carrot = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                               insertIntoManagedObjectContext:context];
    carrot.name = @"carrot";
    
    BBAccessory *hightops = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                                 insertIntoManagedObjectContext:context];
    hightops.name = @"hightops";
    
    BBAccessory *rainboots = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                                  insertIntoManagedObjectContext:context];
    rainboots.name = @"rainboots";
    
    BBAccessory *sweater = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                                insertIntoManagedObjectContext:context];
    sweater.name = @"sweater";
    
    BBAccessory *babies = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                               insertIntoManagedObjectContext:context];
    babies.name = @"babies";
    
    BBAccessory *colosseum = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                                  insertIntoManagedObjectContext:context];
    colosseum.name = @"colosseum";
    
    BBAccessory *pisa = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                             insertIntoManagedObjectContext:context];
    pisa.name = @"pisa";
    
    BBAccessory *pool = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription insertIntoManagedObjectContext:context];
    pool.name = @"pool";
    
    BBAccessory *drums = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                              insertIntoManagedObjectContext:context];
    drums.name = @"drums";
    
    // Categories
    
    BBClosetCategory *foods = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    foods.name = FOOD_CATEGORY;
    foods.accessories = [NSSet setWithObjects:apple, carrot, nil];
    
    BBClosetCategory *fashion = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    fashion.name = FASHION_CATEGORY;
    fashion.accessories = [NSSet setWithObjects:hightops, rainboots, sweater, nil];
    
    BBClosetCategory *friends = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    friends.name = FRIENDS_CATEGORY;
    friends.accessories = [NSSet setWithObjects:babies, nil];
    
    BBClosetCategory *places = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    places.name = PLACES_CATEGORY;
    places.accessories = [NSSet setWithObjects:colosseum, pisa, pool, nil];
    
    BBClosetCategory *instruments = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    instruments.name = INSTRUMENTS_CATEGORY;
    instruments.accessories = [NSSet setWithObjects:drums, nil];
    
    BBClosetCategory *all = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription
                          insertIntoManagedObjectContext:context];
    all.name = @"All";
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Could not save: %@", [error localizedDescription]);
    }
}


@end
