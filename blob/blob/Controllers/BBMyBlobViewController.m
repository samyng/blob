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
#import "BBAccessory.h"
#import "BBClosetCategory.h"

static NSString * const kFeelingCollectionCellIdentifier = @"feelingCollectionCellIdentifier";


@interface BBMyBlobViewController () <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *feelingsCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *currentFeelingSlot;
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
        [self returnCurrentFeelingToFeelingsCollectionView];
    }
    else if ([self touchEndedNearCurrentFeelingSlot:touchLocation forPanGestureRecognizer:sender])
    {
        [UIView animateWithDuration:kViewAnimationDuration animations:^{
            self.draggableCellImageView.center = self.currentFeelingSlot.center;
        }];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)  // if touch ended anywhere else
    {
        [self returnCurrentFeelingToFeelingsCollectionView];
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

- (BOOL)touchEndedNearCurrentFeelingSlot:(CGPoint)touchPoint forPanGestureRecognizer:(UIPanGestureRecognizer *)sender
{
    const CGFloat buffer = 100.0f;
    CGRect expandedFrame = CGRectInset(self.currentFeelingSlot.frame, -buffer, -buffer);
    return (sender.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(expandedFrame, touchPoint));
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
    if (self.currentFeelingIndexPath)
    {
        BBFeelingCollectionCell *cell = (BBFeelingCollectionCell *)[self.feelingsCollectionView cellForItemAtIndexPath:self.currentFeelingIndexPath];
        
        CGFloat translatedYOrigin = self.feelingsCollectionView.frame.origin.y + cell.frame.origin.y;
        CGPoint translatedOrigin = CGPointMake(cell.frame.origin.x, translatedYOrigin);
        CGRect translatedFrame = CGRectMake(translatedOrigin.x, translatedOrigin.y, CGRectGetWidth(cell.frame), CGRectGetHeight(cell.frame));
        [UIView animateWithDuration:kViewAnimationDuration animations:^{
            self.draggableCellImageView.frame = translatedFrame;
        } completion:^(BOOL finished) {
            [self.draggableCellImageView removeFromSuperview];
            [cell resetDefaultUI];
            self.draggableCellImageView = nil;
            self.currentFeeling = nil;
            self.currentFeelingIndexPath = nil;
        }];
    }
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
    
    // Accessories
    
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
    
    BBAccessory *slippers = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                              insertIntoManagedObjectContext:context];
    drums.name = @"slippers";
    
    BBAccessory *soccer = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                              insertIntoManagedObjectContext:context];
    drums.name = @"soccer";
    
    BBAccessory *lamb = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                               insertIntoManagedObjectContext:context];
    drums.name = @"lamb";
    
    BBAccessory *umbrella = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                               insertIntoManagedObjectContext:context];
    drums.name = @"umbrella";
    
    BBAccessory *roses = [[BBAccessory alloc] initWithEntity:accessoryEntityDescription
                                 insertIntoManagedObjectContext:context];
    drums.name = @"roses";
    
    // Categories
    
    BBClosetCategory *foods = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    foods.name = FOOD_CATEGORY;
    foods.accessories = [NSSet setWithObjects:apple, carrot, nil];
    
    BBClosetCategory *clothes = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    clothes.name = CLOTHES_CATEGORY;
    clothes.accessories = [NSSet setWithObjects:hightops, rainboots, sweater, slippers, umbrella, nil];
    
    BBClosetCategory *friends = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    friends.name = FRIENDS_CATEGORY;
    friends.accessories = [NSSet setWithObjects:babies, lamb, nil];
    
    BBClosetCategory *places = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    places.name = PLACES_CATEGORY;
    places.accessories = [NSSet setWithObjects:colosseum, pisa, pool, roses, nil];
    
    BBClosetCategory *instruments = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription insertIntoManagedObjectContext:context];
    instruments.name = INSTRUMENTS_CATEGORY;
    instruments.accessories = [NSSet setWithObjects:drums, nil];
    
    BBClosetCategory *all = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription
                                      insertIntoManagedObjectContext:context];
    all.name = ALL_CATEGORY;
    
    BBClosetCategory *furniture = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription
                                            insertIntoManagedObjectContext:context];
    furniture.name = FURNITURE_CATEGORY;
    
    BBClosetCategory *artSupplies = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription
                                              insertIntoManagedObjectContext:context];
    artSupplies.name = ART_SUPPLIES_CATEGORY;
    
    BBClosetCategory *sports = [[BBClosetCategory alloc] initWithEntity:categoryEntityDescription
                                              insertIntoManagedObjectContext:context];
    sports.name = @"Sports";
    sports.accessories = [NSSet setWithObjects:soccer, nil];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Could not save: %@", [error localizedDescription]);
    }
}


@end
