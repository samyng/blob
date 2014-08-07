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
@property (strong, nonatomic) NSMutableArray *feelings;
@property (nonatomic) CGPoint cellCopyImageViewStartLocation;
@property (nonatomic) UIImageView *cellCopyImageView;
@property (nonatomic) NSIndexPath *startingIndexPath;
@property (strong, nonatomic) NSString *currentFeelingName;
@property (nonatomic) BOOL shouldMoveCellCopyImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *feelingsCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *lumpyCircleImageView;

@property (weak, nonatomic) IBOutlet UICollectionView *codeBlocksCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *codeGroupsTableView;
@property (strong, nonatomic) NSArray *codingGroups;
@property (strong, nonatomic) NSArray *codingBlocks;

@end

@implementation BBSecretLanguageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.codeGroupsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCodingGroupsTableCellIdentifier];
    [self.codeBlocksCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCodingBlocksCollectionCellIdentifier];
    [self.feelingsCollectionView registerNib:[UINib nibWithNibName:@"BBFeelingCollectionCell" bundle:nil] forCellWithReuseIdentifier:kFeelingCollectionCellIdentifier];
    self.feelings = [[NSMutableArray alloc] initWithObjects:@"happy", @"excited", @"nervous", @"flirty", @"frustrated", @"angry", @"sad", nil];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    longPressGestureRecognizer.minimumPressDuration = 0.5f;
    [self.view addGestureRecognizer:longPressGestureRecognizer];
    
    self.codingGroups = @[@"All", @"Operators", @"Conditional", @"Sound"];
    self.codingBlocks = @[@"If", @"Then", @"While", @"Greater than", @"Less than", @"Blush", @"Shake", @"Giggle"];
}

#pragma mark - Gesture Recognizer Method

- (IBAction)longPressed:(UILongPressGestureRecognizer *)sender
{
    CGPoint touchLocation = [sender locationInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if ([self.feelingsCollectionView pointInside:touchLocation withEvent:nil] && !self.currentFeelingName)
        {
            self.shouldMoveCellCopyImageView = YES;
            self.startingIndexPath = [self.feelingsCollectionView indexPathForItemAtPoint:touchLocation];
            
            if (self.startingIndexPath)
            {
                BBFeelingCollectionCell *cell = (BBFeelingCollectionCell *)[self.feelingsCollectionView cellForItemAtIndexPath:self.startingIndexPath];
                self.cellCopyImageView = [[UIImageView alloc] initWithImage:[cell getRasterizedImageCopy]];
                
                [self.view addSubview:self.cellCopyImageView];
                self.cellCopyImageView.center = touchLocation;
                self.cellCopyImageViewStartLocation = self.cellCopyImageView.center;
                [self.view bringSubviewToFront:self.cellCopyImageView];
                
                [UIView animateWithDuration:0.4f animations:^{
                    CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
                    self.cellCopyImageView.transform = transform;
                }];
            }
        }
        else if ([self.lumpyCircleImageView pointInside:touchLocation withEvent:nil])
        {
            self.shouldMoveCellCopyImageView = YES;
        }
        else
        {
            self.shouldMoveCellCopyImageView = NO;
        }
    }
    
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        self.cellCopyImageView.center = touchLocation;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.feelingsCollectionView pointInside:touchLocation withEvent:nil])
        {
            NSIndexPath *endingIndexPath = [self.feelingsCollectionView indexPathForItemAtPoint:touchLocation];
            if (endingIndexPath != self.startingIndexPath)
            {
                if (endingIndexPath)
                {
                    [self.feelings insertObject:self.currentFeelingName atIndex:endingIndexPath.item];
                    self.currentFeelingName = nil;
                    [self.feelingsCollectionView insertItemsAtIndexPaths:@[endingIndexPath]];
                    [self.feelingsCollectionView reloadItemsAtIndexPaths:@[endingIndexPath]];
                    [self.cellCopyImageView removeFromSuperview];
                }
                else
                {
                    CGPoint finalTouchLocation = CGPointMake(667.0f, 107.0f);
                    self.cellCopyImageView.center = finalTouchLocation;
                }
            }
            else
            {
                self.currentFeelingName = nil;
                [self.cellCopyImageView removeFromSuperview];
            }
        }
        else
        {
            CGPoint finalTouchLocation = CGPointMake(667.0f, 107.0f);
            self.cellCopyImageView.center = finalTouchLocation;
            if (!self.currentFeelingName)
            {
                [self.feelings removeObjectAtIndex:self.startingIndexPath.item];
                BBFeelingCollectionCell *cell = (BBFeelingCollectionCell *)[self.feelingsCollectionView cellForItemAtIndexPath:self.startingIndexPath];
                self.currentFeelingName = cell.feelingLabel.text;
                [self.feelingsCollectionView deleteItemsAtIndexPaths:@[self.startingIndexPath]];
            }
        }
    }
}

#pragma mark - Collection View Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kTotalNumberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.feelingsCollectionView)
    {
    return [self.feelings count];
    }
    else if (collectionView == self.codeBlocksCollectionView)
    {
        return [self.codingBlocks count];
    }
    else
    {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.feelingsCollectionView)
    {
        BBFeelingCollectionCell *cell = [self.feelingsCollectionView dequeueReusableCellWithReuseIdentifier:kFeelingCollectionCellIdentifier forIndexPath:indexPath];
        [cell configureWithName:[self.feelings objectAtIndex:indexPath.item]];
        return cell;
    }
    else
    {
        UICollectionViewCell *cell = [self.codeBlocksCollectionView dequeueReusableCellWithReuseIdentifier:kCodingBlocksCollectionCellIdentifier forIndexPath:indexPath];
        CGRect frame = CGRectInset(cell.contentView.frame, 10, 0);
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:frame];
        [cell.contentView addSubview:nameLabel];
        nameLabel.text = [self.codingBlocks objectAtIndex:indexPath.item];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}

#pragma mark - Table View Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kTotalNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.codingGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.codeGroupsTableView dequeueReusableCellWithIdentifier:kCodingGroupsTableCellIdentifier];
    cell.textLabel.text = [self.codingGroups objectAtIndex:indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.codeBlocksCollectionView reloadData];
}

@end
