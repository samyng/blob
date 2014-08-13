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
@property (weak, nonatomic) IBOutlet UIImageView *currentFeelingSlot;
@property (weak, nonatomic) IBOutlet UILabel *letsMakeLabel;
@property (weak, nonatomic) IBOutlet UILabel *beLabel;
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *periodLabel;

@property (strong, nonatomic) NSMutableArray *feelings;
@property (nonatomic) UIImageView *draggableCellImageView;
@property (strong, nonatomic) BBFeeling *currentFeeling;
@property (nonatomic) NSIndexPath *currentFeelingIndexPath;
@property (nonatomic) BOOL allowDrag;
@property (strong, nonatomic) NSFetchedResultsController *feelingsFetchedResultsController;
@end

@implementation BBMyBlobViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.feelingsCollectionView registerNib:[UINib nibWithNibName:@"BBFeelingCollectionCell" bundle:nil] forCellWithReuseIdentifier:kFeelingCollectionCellIdentifier];
    self.currentFeelingSlot.backgroundColor = [BBConstants yellowColor];
    self.connectedLabel.textColor = [BBConstants lightBlueColor];
    self.letsMakeLabel.textColor = [BBConstants blueColor];
    self.beLabel.textColor = [BBConstants orangeColor];
    self.feelingsCollectionView.backgroundColor = [BBConstants yellowBackgroundColor];
    self.periodLabel.backgroundColor = [BBConstants lightBlueColor];
    self.periodLabel.layer.cornerRadius = CGRectGetWidth(self.periodLabel.frame)/2;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
//TODO - preload model data and test heavily before shipping final product -SY (8/9/14)
    
    [self populateFeelings];
#if DEBUG
    if ([self.feelings count] == 0)
    {
        [self createTestData];
        [self populateFeelings];
    }
#endif
}

#pragma mark - Fetch Data

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
    NSFetchRequest *allFeelingsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:FEELING_ENTITY_DESCRIPTION];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:NAME_SORT_DESCRIPTOR_KEY ascending:YES];
    [allFeelingsFetchRequest setSortDescriptors:@[sort]];
    return allFeelingsFetchRequest;
}

#pragma mark - Pan Gesture Recognizer

- (IBAction)panned:(UIPanGestureRecognizer *)sender
{
    CGPoint touchLocation = [sender locationInView:self.view];
    
    if ([self touchBeganInFeelingsCollectionView:touchLocation forPanGestureRecognizer:sender])
    {
        CGFloat yOriginOffset = self.feelingsCollectionView.frame.origin.y;
        CGPoint translatedPoint = CGPointMake(touchLocation.x, touchLocation.y - yOriginOffset);
        NSIndexPath *startingIndexPath = [self.feelingsCollectionView indexPathForItemAtPoint:translatedPoint];
        if (startingIndexPath)
        {
            if (self.currentFeeling)
            {
                [self returnCurrentFeelingToFeelingsCollectionView];
            }
            [self createDraggableCurrentFeelingForCellAtIndexPath:startingIndexPath atTouchLocation:touchLocation];
        }
    }
    else if ([self touchBeganInDraggableCell:touchLocation forPanGestureRecognizer:sender])
    {
        self.allowDrag = YES;
    }
    else if (sender.state == UIGestureRecognizerStateBegan) // if touch began anywhere else
    {
        self.allowDrag = NO;
    }
    else if ([self touchChangedWithDraggableCell:touchLocation forPanGestureRecognizer:sender])
    {
        self.draggableCellImageView.center = touchLocation;
    }
    else if ([self touchEndedInFeelingsCollectionView:touchLocation forPanGestureRecognizer:sender])
    {
        if (self.currentFeelingIndexPath)
        {
            [self returnCurrentFeelingToFeelingsCollectionView];
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded) // if touch ended anywhere else
    {
        self.draggableCellImageView.center = self.currentFeelingSlot.center;
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


#pragma mark - Touch Helper Methods

- (BOOL)touchBeganInFeelingsCollectionView:(CGPoint)touchPoint forPanGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    return (sender.state == UIGestureRecognizerStateBegan && CGRectContainsPoint(self.feelingsCollectionView.frame, touchPoint)) ? YES : NO;
}

- (BOOL)touchBeganInDraggableCell:(CGPoint)touchPoint forPanGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    return (sender.state == UIGestureRecognizerStateBegan && CGRectContainsPoint(self.currentFeelingSlot.frame, touchPoint)) ? YES : NO;
}

- (BOOL)touchChangedWithDraggableCell:(CGPoint)touchPoint forPanGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    return (sender.state == UIGestureRecognizerStateChanged && self.allowDrag) ? YES : NO;
}

- (BOOL)touchEndedInFeelingsCollectionView:(CGPoint)touchPoint forPanGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    return (sender.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(self.feelingsCollectionView.frame, touchPoint)) ? YES : NO;
}

#pragma mark - Other Helper Methods

- (void)createDraggableCurrentFeelingForCellAtIndexPath:(NSIndexPath *)startingIndexPath atTouchLocation:(CGPoint)touchLocation
{
    self.allowDrag = YES;
    BBFeelingCollectionCell *cell = (BBFeelingCollectionCell *)[self.feelingsCollectionView cellForItemAtIndexPath:startingIndexPath];
    self.draggableCellImageView = [[UIImageView alloc] initWithImage:[cell rasterizedImageCopy]];
    [self.view addSubview:self.draggableCellImageView];
    self.draggableCellImageView.center = touchLocation;
    [self.view bringSubviewToFront:self.draggableCellImageView];
    [cell setToBlankState];
    self.currentFeeling = cell.feeling;
    self.currentFeelingIndexPath = startingIndexPath;
    [UIView animateWithDuration:0.4f animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(1.2f, 1.2f);
        self.draggableCellImageView.transform = transform;
    }];
}

- (void)returnCurrentFeelingToFeelingsCollectionView
{
    BBFeelingCollectionCell *cell = (BBFeelingCollectionCell *)[self.feelingsCollectionView cellForItemAtIndexPath:self.currentFeelingIndexPath];
    [cell resetDefaultUI];
    [self.draggableCellImageView removeFromSuperview];
    self.draggableCellImageView = nil;
    self.currentFeeling = nil;
    self.currentFeelingIndexPath = nil;
}

#pragma mark - Create test data

- (void)createTestData
{
    NSManagedObjectContext *context = self.context;
    NSEntityDescription *feelingEntityDescription = [NSEntityDescription entityForName:FEELING_ENTITY_DESCRIPTION inManagedObjectContext:context];
    
    BBFeeling *happy = [[BBFeeling alloc] initWithEntity:feelingEntityDescription
                              insertIntoManagedObjectContext:context];
    happy.name = @"happy";
    
    BBFeeling *excited = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    excited.name = @"excited";
    
    BBFeeling *nervous = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    nervous.name = @"nervous";
    
    BBFeeling *flirty = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    flirty.name = @"flirty";
    
    BBFeeling *hungry = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    hungry.name = @"hungry";
    
    BBFeeling *sad = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    sad.name = @"talkative";
    
    BBFeeling *lazy = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    lazy.name = @"lazy";
    
    BBFeeling *confused = [[BBFeeling alloc] initWithEntity:feelingEntityDescription insertIntoManagedObjectContext:context];
    confused.name = @"confused";
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Could not save: %@", [error localizedDescription]);
    }
}


@end
