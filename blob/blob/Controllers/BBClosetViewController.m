//
//  BBClosetViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBClosetViewController.h"
#import "BBAccessory.h"

static NSString * const kCategoriesTableCellIdentifier = @"categoriesTableCellIdentifier";
static NSString * const kAccessoriesCollectionCellIdentifier = @"accessoriesCollectionCellIdentifier";
static NSInteger const kTotalNumberOfSections = 1;

static NSInteger const kAllSectionIndex = 0;
static NSInteger const kFoodSectionIndex = 1;
static NSInteger const kClothesSectionIndex = 2;
static NSInteger const kFriendsSectionIndex = 3;
static NSInteger const kPlacesSectionIndex = 4;

@interface BBClosetViewController () <UITableViewDataSource, UICollectionViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *accessoriesCollectionView;
@property (strong, nonatomic) NSArray *categories;

@property (strong, nonatomic) NSArray *foods;
@property (strong, nonatomic) NSArray *clothes;
@property (strong, nonatomic) NSArray *friends;
@property (strong, nonatomic) NSArray *places;
@end

@implementation BBClosetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.categoriesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCategoriesTableCellIdentifier];
    [self.accessoriesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier];
    self.categories = @[@"All", @"Food", @"Clothes", @"Friends", @"Places"];
    
    // Temporary test data - SY (8/5/2014)
    self.foods = [self foodTest];
    self.clothes = [self clothTest];
    self.friends = [self friendTest];
    self.places = [self placeTest];
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
    NSInteger categoriesTableCellSelectedRowIndex = [self.categoriesTableView indexPathForSelectedRow].row;
    if (categoriesTableCellSelectedRowIndex == kAllSectionIndex)
    {
        return [self totalNumberOfAccessories];
    }
    else if (categoriesTableCellSelectedRowIndex == kFoodSectionIndex)
    {
        return [self.foods count];
    }
    else if (categoriesTableCellSelectedRowIndex == kClothesSectionIndex)
    {
        return [self.clothes count];
    }
    else if (categoriesTableCellSelectedRowIndex == kFriendsSectionIndex)
    {
        return [self.friends count];
    }
    else if (categoriesTableCellSelectedRowIndex == kPlacesSectionIndex)
    {
        return [self.places count];
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.accessoriesCollectionView dequeueReusableCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.layer.borderWidth = 5.0f;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    return cell;
}

#pragma mark - Helper Methods

- (NSInteger)totalNumberOfAccessories
{
    return [self.foods count] + [self.clothes count] + [self.friends count] + [self.places count];
}

#pragma mark - Temporary Test Data

- (NSArray *)foodTest
{
    BBAccessory *apple = [[BBAccessory alloc] initWithName:@"apple"];
    BBAccessory *carrot = [[BBAccessory alloc] initWithName:@"carrot"];
    return @[apple, carrot];
}

- (NSArray *)clothTest
{
    BBAccessory *raybans = [[BBAccessory alloc] initWithName:@"rayban"];
    BBAccessory *rainboots = [[BBAccessory alloc] initWithName:@"rainboots"];
    BBAccessory *hoodie = [[BBAccessory alloc] initWithName:@"hoodie"];
    return @[raybans, rainboots, hoodie];
}

- (NSArray *)friendTest
{
    BBAccessory *happy = [[BBAccessory alloc] initWithName:@"happy"];
    BBAccessory *zool = [[BBAccessory alloc] initWithName:@"zool"];
    BBAccessory *care = [[BBAccessory alloc] initWithName:@"care"];
    BBAccessory *presh = [[BBAccessory alloc] initWithName:@"fresh"];
    return @[happy, zool, care, presh];
}

- (NSArray *)placeTest
{
    BBAccessory *eiffelTower = [[BBAccessory alloc] initWithName:@"eiffel"];
    return @[eiffelTower];
}

- (NSArray *)allAccessories
{
    NSArray *allAccessories = [[[[self foodTest] arrayByAddingObjectsFromArray:[self clothTest]] arrayByAddingObjectsFromArray:[self friendTest]] arrayByAddingObjectsFromArray:[self placeTest]];
    return allAccessories;
}

@end
