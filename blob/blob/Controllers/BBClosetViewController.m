//
//  BBClosetViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBClosetViewController.h"
#import "BBAccessory.h"
#import "BBAccessoryCollectionCell.h"

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
    [self.accessoriesCollectionView registerNib:[UINib nibWithNibName:@"BBAccessoryCollectionCell" bundle:nil] forCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier];
    self.categories = @[@"All", @"Food", @"Clothes", @"Friends", @"Places", @"Cooking", @"Sports", @"Special Occassions", @"Movies", @"Celebrities", @"Concerts", @"Holidays"];
    
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
    NSInteger selectedRowIndex = [self categoriesTableCellSelectedRowIndex];
    switch (selectedRowIndex)
    {
        case kAllSectionIndex:
            return [self totalNumberOfAccessories];
        case kFoodSectionIndex:
            return [self.foods count];
        case kClothesSectionIndex:
            return [self.clothes count];
        case kFriendsSectionIndex:
            return [self.friends count];
        case kPlacesSectionIndex:
            return [self.places count];
        default:
            return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBAccessoryCollectionCell *cell = [self.accessoriesCollectionView dequeueReusableCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier
                                                                                                forIndexPath:indexPath];
    
    BBAccessory *accessory;
    NSInteger selectedRowIndex = [self categoriesTableCellSelectedRowIndex];
    switch (selectedRowIndex)
    {
        case kAllSectionIndex:
            accessory = [[self allAccessories] objectAtIndex:indexPath.item];
            break;
        case kFoodSectionIndex:
             accessory = [self.foods objectAtIndex:indexPath.item];
            break;
        case kClothesSectionIndex:
            accessory = [self.clothes objectAtIndex:indexPath.item];
            break;
        case kFriendsSectionIndex:
            accessory = [self.friends objectAtIndex:indexPath.item];
            break;
        case kPlacesSectionIndex:
            accessory = [self.places objectAtIndex:indexPath.item];
            break;
        default:
            accessory = nil;
    }
    
    if (accessory)
    {
        [cell configureWithAccessory:accessory];
    }
    
    return cell;
}

#pragma mark - Helper Methods

- (NSInteger)totalNumberOfAccessories
{
    return [self.foods count] + [self.clothes count] + [self.friends count] + [self.places count];
}

- (NSInteger)categoriesTableCellSelectedRowIndex
{
    return [self.categoriesTableView indexPathForSelectedRow].row;
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
    BBAccessory *hightops = [[BBAccessory alloc] initWithName:@"hightops"];
    BBAccessory *rainboots = [[BBAccessory alloc] initWithName:@"rainboots"];
    BBAccessory *sweater = [[BBAccessory alloc] initWithName:@"sweater"];
    return @[hightops, rainboots, sweater];
}

- (NSArray *)friendTest
{
    BBAccessory *happy = [[BBAccessory alloc] initWithName:@"happy"];
    return @[happy, happy, happy, happy];
}

- (NSArray *)placeTest
{
    BBAccessory *colosseum = [[BBAccessory alloc] initWithName:@"colosseum"];
    return @[colosseum];
}

- (NSArray *)allAccessories
{
    NSArray *allAccessories = [[[[self foodTest] arrayByAddingObjectsFromArray:[self clothTest]] arrayByAddingObjectsFromArray:[self friendTest]] arrayByAddingObjectsFromArray:[self placeTest]];
    return allAccessories;
}

@end
