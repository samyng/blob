//
//  BBMyBlobViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBMyBlobViewController.h"
#import "BBFeelingCollectionCell.h"

static NSInteger const kTotalNumberOfSections = 1;
static NSString * const kFeelingCollectionCellIdentifier = @"feelingCollectionCellIdentifier";


@interface BBMyBlobViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *feelingsCollectionView;
@property (strong, nonatomic) NSMutableArray *feelings;
@property (nonatomic) CGPoint cellCopyImageViewStartLocation;
@property (nonatomic) UIImageView *cellCopyImageView;
@property (nonatomic) NSIndexPath *startingIndexPath;
@property (nonatomic) NSIndexPath *endingIndexPath;
@end

@implementation BBMyBlobViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.feelingsCollectionView registerNib:[UINib nibWithNibName:@"BBFeelingCollectionCell" bundle:nil] forCellWithReuseIdentifier:kFeelingCollectionCellIdentifier];
    self.feelings = [[NSMutableArray alloc] initWithObjects:@"happy", @"excited", @"nervous", @"flirty", @"frustrated", @"angry", @"sad", nil];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
    [self.view addGestureRecognizer:longPressGestureRecognizer];
}

#pragma mark - Gesture Recognizer Method

- (IBAction)longPressed:(UILongPressGestureRecognizer *)sender
{
    CGPoint touchLocation = [sender locationInView:self.feelingsCollectionView];

    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.startingIndexPath = [self.feelingsCollectionView indexPathForItemAtPoint:touchLocation];
        
        if (self.startingIndexPath)
        {
            BBFeelingCollectionCell *cell = (BBFeelingCollectionCell *)[self.feelingsCollectionView cellForItemAtIndexPath:self.startingIndexPath];
            self.cellCopyImageView = [[UIImageView alloc] initWithImage:[cell getRasterizedImageCopy]];
            
            cell.contentView.alpha = 0.0f;
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
    
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        self.cellCopyImageView.center = touchLocation;
    }
    
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint finalTouchLocation = CGPointMake(667.0f, 107.0f);
        self.cellCopyImageView.center = finalTouchLocation;
    }
}

#pragma mark - Collection View Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kTotalNumberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.feelings count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBFeelingCollectionCell *cell = [self.feelingsCollectionView dequeueReusableCellWithReuseIdentifier:kFeelingCollectionCellIdentifier forIndexPath:indexPath];
    [cell configureWithName:[self.feelings objectAtIndex:indexPath.item]];
    return cell;
}

@end
