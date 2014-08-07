//
//  BBSecretLanguageViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBSecretLanguageViewController.h"
#import "BBFeelingCollectionCell.h"

static NSString * const kFeelingCollectionCellIdentifier = @"feelingCollectionCellIdentifier";
static NSString * const kCodingGroupsTableCellIdentifier = @"codingGroupsTableCellIdentifier";
static NSString * const kCodingBlocksCollectionCellIdentifier = @"codingBlocksCollectionCellIdentifier";

@interface BBSecretLanguageViewController () <UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *codeBlocksCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) NSArray *codeBlocks;

@end

@implementation BBSecretLanguageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.groupsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCodingGroupsTableCellIdentifier];
    [self.codeBlocksCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCodingBlocksCollectionCellIdentifier];
    
    self.groups = @[@"All", @"Operators", @"Conditional", @"Sound"];
    self.codeBlocks = @[@"If", @"Then", @"While", @"Greater than", @"Less than", @"Blush", @"Shake", @"Giggle"];
    
    [self.groupsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Collection View Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kTotalNumberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.codeBlocksCollectionView)
    {
        return [self.codeBlocks count];
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        UICollectionViewCell *cell = [self.codeBlocksCollectionView dequeueReusableCellWithReuseIdentifier:kCodingBlocksCollectionCellIdentifier forIndexPath:indexPath];
        CGRect frame = CGRectInset(cell.contentView.frame, 10, 0);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
        [cell.contentView addSubview:nameLabel];
        nameLabel.text = [self.codeBlocks objectAtIndex:indexPath.item];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
}

#pragma mark - Table View Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kTotalNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.groups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.groupsTableView dequeueReusableCellWithIdentifier:kCodingGroupsTableCellIdentifier];
    cell.textLabel.text = [self.groups objectAtIndex:indexPath.row];
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
    [self.codeBlocksCollectionView reloadData];
}

@end
