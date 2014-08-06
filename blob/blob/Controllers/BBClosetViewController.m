//
//  BBClosetViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBClosetViewController.h"

static NSString * const kCategoriesTableCellIdentifier = @"categoriesTableCellIdentifier";
static NSString * const kAccessoriesCollectionCellIdentifier = @"accessoriesCollectionCellIdentifier";

@interface BBClosetViewController () <UITableViewDataSource, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *accessoriesCollectionView;
@property (strong, nonatomic) NSArray *categories;
@end

@implementation BBClosetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.categoriesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCategoriesTableCellIdentifier];
    [self.accessoriesCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier];
    self.categories = @[@"All", @"Food", @"Clothes", @"Friends", @"Places"];
}

#pragma mark - Table View Datasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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

#pragma mark - Collection View Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.accessoriesCollectionView dequeueReusableCellWithReuseIdentifier:kAccessoriesCollectionCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    cell.layer.borderWidth = 5.0f;
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    return cell;
}

@end
