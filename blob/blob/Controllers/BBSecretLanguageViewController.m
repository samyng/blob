//
//  BBSecretLanguageViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBSecretLanguageViewController.h"
#import "BBCodeBlockCollectionCell.h"

static NSString * const kGroupsTableCellIdentifier = @"groupsTableCellIdentifier";
static NSString * const kCodeBlockCollectionCellIdentifier = @"codeBlockCollectionCellIdentifier";

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
    [self.groupsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kGroupsTableCellIdentifier];
    [self.codeBlocksCollectionView registerNib:[UINib nibWithNibName:@"BBCodeBlockCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCodeBlockCollectionCellIdentifier];
    
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
        BBCodeBlockCollectionCell *cell = (BBCodeBlockCollectionCell *)[self.codeBlocksCollectionView dequeueReusableCellWithReuseIdentifier:kCodeBlockCollectionCellIdentifier
                                                                                                                                forIndexPath:indexPath];
        NSString *name = [self.codeBlocks objectAtIndex:indexPath.item];
        [cell configureWithName:name];
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
    UITableViewCell *cell = [self.groupsTableView dequeueReusableCellWithIdentifier:kGroupsTableCellIdentifier];
    cell.textLabel.text = [self.groups objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:17.0f];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    
    CGRect frame = cell.contentView.frame;
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    selectedBackgroundView.backgroundColor = [BBConstants magnesiumGrayColor];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.codeBlocksCollectionView reloadData];
}

@end
