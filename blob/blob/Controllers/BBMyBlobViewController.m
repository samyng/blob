//
//  BBMyBlobViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBMyBlobViewController.h"
#import "BBFeelingCollectionCell.h"
#import "BBFeeling.h"

static NSString * const kFeelingCollectionCellIdentifier = @"feelingCollectionCellIdentifier";


@interface BBMyBlobViewController () <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *feelingsCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *lumpyCircleImageView;

@property (strong, nonatomic) NSMutableArray *feelings;
@property (nonatomic) CGPoint cellCopyImageViewStartLocation;
@property (nonatomic) UIImageView *cellCopyImageView;
@property (nonatomic) NSIndexPath *startingIndexPath;
@property (strong, nonatomic) BBFeeling *currentFeeling;
@property (nonatomic) BOOL shouldMoveCellCopyImageView;

@property (strong, nonatomic) NSFetchedResultsController *feelingsFetchedResultsController;
@end

@implementation BBMyBlobViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.feelingsCollectionView registerNib:[UINib nibWithNibName:@"BBFeelingCollectionCell" bundle:nil] forCellWithReuseIdentifier:kFeelingCollectionCellIdentifier];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
//    longPressGestureRecognizer.minimumPressDuration = 0.5f;
    [self.view addGestureRecognizer:panGestureRecognizer];
    
#warning - preload accessories and test heavily before shipping final product -SY (8/9/14)
    
    [self populateFeelings];
#if DEBUG
    if ([self.feelings count] == 0)
    {
        [self createTestData];
        [self populateFeelings];
    }
#endif
}


- (void)populateFeelings
{
    NSManagedObjectContext *context = self.context;
    if (context)
    {
        self.feelingsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self allFeelingsFetchRequest]
                                                                                    managedObjectContext:context
                                                                                      sectionNameKeyPath:nil
                                                                                               cacheName:nil];
        [self.feelingsFetchedResultsController setDelegate:self];
        [self.feelingsFetchedResultsController performFetch:nil];
        self.feelings = [[self.feelingsFetchedResultsController fetchedObjects] mutableCopy];
    }
}

- (NSFetchRequest *)allFeelingsFetchRequest
{
    NSFetchRequest *allFeelingsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Feeling"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:YES];
    [allFeelingsFetchRequest setSortDescriptors:@[sort]];
    return allFeelingsFetchRequest;
}

#pragma mark - Gesture Recognizer Method

- (IBAction)panned:(UIPanGestureRecognizer *)sender
{
    CGPoint touchLocation = [sender locationInView:self.view];

    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if ([self.feelingsCollectionView pointInside:touchLocation withEvent:nil] && !self.currentFeeling)
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
            // TODO - make it so that the blocks switch, instead of having to put one away before grabbing a new one - SY (8/9/2014)
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
                    [self.feelings insertObject:self.currentFeeling atIndex:endingIndexPath.item];
                    self.currentFeeling = nil;
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
                self.currentFeeling = nil;
                [self.cellCopyImageView removeFromSuperview];
            }
        }
        else
        {
            CGPoint finalTouchLocation = CGPointMake(667.0f, 107.0f);
            self.cellCopyImageView.center = finalTouchLocation;
            if (!self.currentFeeling)
            {
                if (self.startingIndexPath)
                {
                    [self.feelings removeObjectAtIndex:self.startingIndexPath.item];
                    BBFeelingCollectionCell *cell = (BBFeelingCollectionCell *)[self.feelingsCollectionView cellForItemAtIndexPath:self.startingIndexPath];
                    self.currentFeeling = cell.feeling;
                    [self.feelingsCollectionView deleteItemsAtIndexPaths:@[self.startingIndexPath]];
                }
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
    return [self.feelings count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BBFeelingCollectionCell *cell = [self.feelingsCollectionView dequeueReusableCellWithReuseIdentifier:kFeelingCollectionCellIdentifier forIndexPath:indexPath];
    BBFeeling *feeling = [self.feelings objectAtIndex:indexPath.item];
    [cell configureWithFeeling:feeling];
    return cell;
}

#pragma mark - Create test data

- (void)createTestData
{
    NSManagedObjectContext *context = self.context;
    NSEntityDescription *feelingEntityDescription = [NSEntityDescription entityForName:@"Feeling" inManagedObjectContext:context];
    
    BBFeeling *happy = [[BBFeeling alloc] initWithEntity:feelingEntityDescription
                              insertIntoManagedObjectContext:context];
    happy.name = @"happy";
    
    BBFeeling *excited = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    excited.name = @"excited";
    
    BBFeeling *nervous = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    nervous.name = @"nervous";
    
    BBFeeling *flirty = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    flirty.name = @"flirty";
    
    BBFeeling *angry = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    angry.name = @"angry";
    
    BBFeeling *sad = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    sad.name = @"sad";
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Could not save: %@", [error localizedDescription]);
    }
}

@end
