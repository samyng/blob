//
//  BBSecretLanguageViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBSecretLanguageViewController.h"
#import "BBLanguageBlockCollectionCell.h"
#import "BBLanguageBlock.h"
#import "BBLanguageGroup.h"
#import "BBFeeling.h"
#import "BBCollapsedLanguageBlockImageView.h"
#import "BBAccessory.h"
#import "BBLanguageBlockView.h"
#import "BBLanguageBlockViewFactory.h"

static NSString * const kGroupsTableCellIdentifier = @"groupsTableCellIdentifier";
static NSString * const kCollapsedImageStringFormat = @"%@Block-collapsed";
static NSInteger const kControlGroupIndexRow = 0;

@interface BBSecretLanguageViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, NSFetchedResultsControllerDelegate, CollapsedLanguageBlockDelegate, LanguageBlockDelegate>
@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *blocksContainerView;
@property (weak, nonatomic) IBOutlet UIPageControl *blocksContainerPageControl;
@property (strong, nonatomic) NSMutableSet *blockViewsInUse;

@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) NSArray *accessories;
@property (strong, nonatomic) NSFetchedResultsController *groupsFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *accessoriesFetchedResultsController;
@end

@implementation BBSecretLanguageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.groupsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kGroupsTableCellIdentifier];
    [self populateLanguageGroups];
    
    //TODO - preload model data and test heavily before shipping final product -SY (8/8/14)
    
#if DEBUG
    if ([self.groups count] == 0)
    {
        [self createTestData];
        [self populateLanguageGroups];
    }
#endif
    
    self.blockViewsInUse = [[NSMutableSet alloc] init];
    self.blocksContainerView.userInteractionEnabled = YES;
    self.blocksContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.blocksContainerView.scrollEnabled = YES;
    self.blocksContainerView.pagingEnabled = YES;
    self.blocksContainerPageControl.hidesForSinglePage = YES;
    [self.groupsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self updateBlocksContainerViewForGroup:[self.groups objectAtIndex:kControlGroupIndexRow]];
}

- (void)doneButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Fetch Data

- (void)populateLanguageGroups
{
    NSManagedObjectContext *context = self.context;
    if (context)
    {
        self.groupsFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self allGroupsFetchRequest]
                                                                                  managedObjectContext:context
                                                                                    sectionNameKeyPath:nil
                                                                                             cacheName:nil];
        [self.groupsFetchedResultsController setDelegate:self];
        [self.groupsFetchedResultsController performFetch:nil];
        self.groups = [self.groupsFetchedResultsController fetchedObjects];
    }
}

- (NSFetchRequest *)allGroupsFetchRequest
{
    NSFetchRequest *allGroupsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:LANGUAGE_GROUP_ENTITY_DESCRIPTION];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:NAME_SORT_DESCRIPTOR_KEY ascending:YES];
    [allGroupsFetchRequest setSortDescriptors:@[sort]];
    return allGroupsFetchRequest;
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
    NSString *name = [[self.groups objectAtIndex:indexPath.row] name];
    cell.textLabel.text = name;
    cell.textLabel.font = [UIFont fontWithName:BLOB_FONT_BOLD size:17.0f];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [BBConstants textColorForCellWithLanguageGroupName:name];
    cell.contentView.backgroundColor = [BBConstants colorForCellWithLanguageGroupName:name];
    
    CGRect frame = cell.contentView.frame;
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    selectedBackgroundView.backgroundColor = [BBConstants colorForCellWithLanguageGroupName:name];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BBLanguageGroup *group = [self.groups objectAtIndex:indexPath.row];
    [self updateBlocksContainerViewForGroup:group];
}

- (void)updateBlocksContainerViewForGroup:(BBLanguageGroup *)group
{
    NSString *groupName = group.name;
    self.blocksContainerView.backgroundColor = [BBConstants backgroundColorForCellWithLanguageGroupName:groupName];
    self.blocksContainerPageControl.currentPageIndicatorTintColor = [BBConstants colorForCellWithLanguageGroupName:groupName];
    self.blocksContainerPageControl.pageIndicatorTintColor = [BBConstants textColorForCellWithLanguageGroupName:groupName];
    self.blocksContainerPageControl.numberOfPages = 1;
    
    [self resetBlocksContainerView];
    NSArray *languageBlocks = [group.blocks allObjects];
    if ([groupName isEqualToString:CONTROL_GROUP])
    {
        [self arrangeControlBlocks:languageBlocks];
    }
    else if ([groupName isEqualToString:FROM_CLOSET_GROUP])
    {
        [self arrangeAccessoryBlocks:languageBlocks];
    }
    else if ([groupName isEqualToString:REACTIONS_GROUP])
    {
        [self arrangeReactionBlocks:languageBlocks];
    }
    else if ([groupName isEqualToString:OPERATORS_GROUP])
    {
        [self arrangeOperatorBlocks:languageBlocks];
    }
    else if ([groupName isEqualToString:VARIABLES_GROUP])
    {
        [self arrangeVariableBlocks:languageBlocks];
    }
    
}

#pragma mark - Arrange Blocks

- (void)updateNumberOfScrollViewPages
{
    if (self.blocksContainerView.contentSize.width > CGRectGetWidth(self.blocksContainerView.frame))
    {
        self.blocksContainerPageControl.numberOfPages = ceil(self.blocksContainerView.contentSize.width / CGRectGetWidth(self.blocksContainerView.frame));
    }
}

- (void)arrangeControlBlocks:(NSArray *)controlBlocks
{
    const CGFloat xPadding = BLOB_PADDING_30PX;
    CGFloat xOrigin = BLOB_PADDING_20PX;
    CGFloat yOrigin = BLOB_PADDING_20PX;
    for (BBLanguageBlock *languageBlock in controlBlocks)
    {
        NSString *imageName = [NSString stringWithFormat:kCollapsedImageStringFormat,languageBlock.name];
        BBCollapsedLanguageBlockImageView *blockView = [[BBCollapsedLanguageBlockImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        CGSize blockViewSize = blockView.frame.size;
        blockView.frame = CGRectMake(xOrigin, yOrigin, blockViewSize.width, blockViewSize.height);
        xOrigin += (blockViewSize.width + xPadding);
        [blockView configureWithLanguageBlock:languageBlock];
        blockView.delegate = self;
        [self.blocksContainerView addSubview:blockView];
    }
    self.blocksContainerView.contentSize = CGSizeMake(xOrigin, CGRectGetHeight(self.blocksContainerView.frame));
    [self updateNumberOfScrollViewPages];
}

- (void)arrangeAccessoryBlocks:(NSArray *)accessoryBlocks
{
    const CGFloat xPadding = BLOB_PADDING_15PX;
    const CGFloat yPadding = BLOB_PADDING_15PX;
    const CGFloat xBackgroundPadding = BLOB_PADDING_45PX;
    const CGFloat yBackgroundPadding = BLOB_PADDING_10PX;
    CGFloat xOrigin = BLOB_PADDING_20PX;
    CGFloat yOrigin = BLOB_PADDING_20PX;
    for (BBLanguageBlock *languageBlock in accessoryBlocks)
    {
        NSString *languageBlockName = languageBlock.name;
        CGSize nameStringSize = [languageBlockName sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:BLOB_FONT_REGULAR size:BLOB_FONT_19PT]}];
        CGFloat frameWidth = nameStringSize.width + 2*xBackgroundPadding;
        CGFloat frameHeight = nameStringSize.height + 2*yBackgroundPadding;
        CGFloat calculatedEndingX = xOrigin + frameWidth + xPadding;
        
        if (calculatedEndingX >= self.blocksContainerView.frame.size.width)
        {
            xOrigin = BLOB_PADDING_20PX;
            yOrigin += (frameHeight + yPadding);
        }
        CGRect languageBlockFrame = CGRectMake(xOrigin, yOrigin, frameWidth, frameHeight);
        BBCollapsedLanguageBlockImageView *blockView = [[BBCollapsedLanguageBlockImageView alloc] initWithFrame:languageBlockFrame];
        [blockView configureWithLanguageBlock:languageBlock];
        blockView.delegate = self;
        [self.blocksContainerView addSubview:blockView];
        xOrigin += (frameWidth + xPadding);
    }
}

- (void)arrangeReactionBlocks:(NSArray *)reactionBlocks
{
    const CGFloat xPadding = BLOB_PADDING_15PX;
    const CGFloat yPadding = BLOB_PADDING_15PX;
    const CGFloat xBackgroundPadding = BLOB_PADDING_25PX;
    const CGFloat yBackgroundPadding = BLOB_PADDING_10PX;
    CGFloat xOrigin = BLOB_PADDING_20PX;
    CGFloat yOrigin = BLOB_PADDING_20PX;
    for (BBLanguageBlock *languageBlock in reactionBlocks)
    {
        NSString *languageBlockName = languageBlock.name;
        CGSize nameStringSize = [languageBlockName sizeWithAttributes: @{NSFontAttributeName:[UIFont fontWithName:BLOB_FONT_REGULAR size:BLOB_FONT_19PT]}];
        CGFloat frameWidth = nameStringSize.width + 2*xBackgroundPadding;
        CGFloat frameHeight = nameStringSize.height + 2*yBackgroundPadding;
        CGFloat calculatedEndingX = xOrigin + frameWidth + xPadding;
        
        if (calculatedEndingX >= self.blocksContainerView.frame.size.width)
        {
            xOrigin = BLOB_PADDING_20PX;
            yOrigin += (frameHeight + yPadding);
        }
        CGRect languageBlockFrame = CGRectMake(xOrigin, yOrigin, frameWidth, frameHeight);
        BBCollapsedLanguageBlockImageView *blockView = [[BBCollapsedLanguageBlockImageView alloc] initWithFrame:languageBlockFrame];
        [blockView configureWithLanguageBlock:languageBlock];
        blockView.delegate = self;
        [self.blocksContainerView addSubview:blockView];
        xOrigin += (frameWidth + xPadding);
    }
}

- (void)arrangeOperatorBlocks:(NSArray *)operatorBlocks
{
    const CGFloat xPadding = BLOB_PADDING_25PX;
    const CGFloat yPadding = BLOB_PADDING_20PX;
    CGFloat xOrigin = BLOB_PADDING_20PX;
    CGFloat yOrigin = BLOB_PADDING_20PX;
    for (BBLanguageBlock *languageBlock in operatorBlocks)
    {
        NSString *imageName = [NSString stringWithFormat:kCollapsedImageStringFormat,languageBlock.name];
        BBCollapsedLanguageBlockImageView *blockView = [[BBCollapsedLanguageBlockImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        CGSize blockViewSize = blockView.frame.size;
        
        CGFloat calculatedEndingX = xOrigin + blockViewSize.width + xPadding;
        if (calculatedEndingX >= self.blocksContainerView.frame.size.width)
        {
            xOrigin = BLOB_PADDING_20PX;
            yOrigin += (blockViewSize.height + yPadding);
        }
        
        blockView.frame = CGRectMake(xOrigin, yOrigin, blockViewSize.width, blockViewSize.height);
        [blockView configureWithLanguageBlock:languageBlock];
        blockView.delegate = self;
        [self.blocksContainerView addSubview:blockView];
        xOrigin += (blockViewSize.width + xPadding);
    }
}

- (void)arrangeVariableBlocks:(NSArray *)variableBlocks
{
    const CGFloat xPadding = BLOB_PADDING_10PX;
    CGFloat xOrigin = BLOB_PADDING_20PX;
    CGFloat yOrigin = BLOB_PADDING_20PX;
    for (BBLanguageBlock *languageBlock in variableBlocks)
    {
        NSString *imageName = [NSString stringWithFormat:kCollapsedImageStringFormat,languageBlock.name];
        BBCollapsedLanguageBlockImageView *blockView = [[BBCollapsedLanguageBlockImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        CGSize blockViewSize = blockView.frame.size;
        blockView.frame = CGRectMake(xOrigin, yOrigin, blockViewSize.width, blockViewSize.height);
        xOrigin += (blockViewSize.width + xPadding);
        [blockView configureWithLanguageBlock:languageBlock];
        blockView.delegate = self;
        [self.blocksContainerView addSubview:blockView];
    }
}

#pragma mark - Helper Methods

- (NSInteger)groupsTableCellSelectedRowIndex
{
    return [self.groupsTableView indexPathForSelectedRow].row;
}


- (void)resetBlocksContainerView
{
    for (UIView *subview in self.blocksContainerView.subviews)
    {
        [subview removeFromSuperview];
    }
}

#pragma mark - Expanded Language Block Delegate Methods

- (void)panDidBegin:(UIPanGestureRecognizer *)sender forLanguageBlockView:(BBLanguageBlockView *)blockView
{
}

- (void)panDidChange:(UIPanGestureRecognizer *)sender forLanguageBlockView:(BBLanguageBlockView *)blockView
{
    CGPoint touchLocation = [sender locationInView:self.view];
    [blockView moveCenterToPoint:touchLocation];
    blockView.alpha = CGRectIntersectsRect(self.blocksContainerView.frame, blockView.frame) ? kAlphaHalf : kAlphaOpaque;
    [self.view bringSubviewToFront:blockView];
    [self checkIntersectionFromSender:sender forLanguageBlockView:blockView];
}

- (void)panDidEnd:(UIPanGestureRecognizer *)sender forLanguageBlockView:(BBLanguageBlockView *)blockView
{
    if (CGRectIntersectsRect(self.blocksContainerView.frame, blockView.frame))
    {
        [UIView animateWithDuration:kViewAnimationDuration animations:^{
            blockView.alpha = kAlphaZero;
        }];
        [blockView removeFromSuperview];
        blockView = nil;
    }
}

- (void)checkIntersectionFromSender:(UIPanGestureRecognizer *)sender forLanguageBlockView:(BBLanguageBlockView *)blockView
{
    for (BBLanguageBlockView *aBlockView in self.blockViewsInUse)
    {
        if (aBlockView != blockView)
        {
            blockView.overlapped = CGRectIntersectsRect(aBlockView.frame, blockView.frame) ? YES : NO;
            
            if (blockView.overlapped == NO && blockView.isOverlapped == YES) // if they were overlapping and now aren't
            {
                [aBlockView.snappedBlockViews removeObject:blockView];
                CGSize originalSize = [aBlockView originalSize];
                CGPoint origin = aBlockView.frame.origin;
                CGRect originalFrame = CGRectMake(origin.x, origin.y, originalSize.width, originalSize.height);
                aBlockView.frame = originalFrame;
            }
            else if (blockView.overlapped)
            {
                CGPoint touchPoint = [sender locationInView:aBlockView];
                [aBlockView touchedByLanguageBlockView:blockView atTouchLocation:touchPoint];
            }
            blockView.isOverlapped = blockView.overlapped;
        }
    }
}

- (void)updateFrameForTouchedLanguageBlockView:(BBLanguageBlockView *)touchedBlockView
                   andDraggedLanguageBlockView:(BBLanguageBlockView *)draggedBlockView
                                           byX:(CGFloat)xDifference
                                           byY:(CGFloat)yDifference
                       withParameterViewOrigin:(CGPoint)parameterOrigin
{
    CGPoint origin = touchedBlockView.frame.origin;
    CGFloat newWidth = CGRectGetWidth(touchedBlockView.frame) + xDifference;
    CGFloat newHeight = CGRectGetHeight(touchedBlockView.frame) + yDifference;
    CGRect newFrame = CGRectMake(origin.x, origin.y, newWidth, newHeight);
    touchedBlockView.frame = newFrame;
    
    CGFloat newCenterXPoint = origin.x + parameterOrigin.x + (CGRectGetWidth(draggedBlockView.frame)/2);
    CGFloat newCenterYPoint = origin.y + parameterOrigin.y + (CGRectGetHeight(draggedBlockView.frame)/2);
    CGPoint newCenter = CGPointMake(newCenterXPoint, newCenterYPoint);
    draggedBlockView.center = newCenter;
}

#pragma mark - Collpased Language Block Delegate Methods

- (void)panDidBegin:(UIPanGestureRecognizer *)sender inCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)collapsedView
{
    BBLanguageBlockView *expandedBlockView = [BBLanguageBlockViewFactory viewForBlock:collapsedView.languageBlock];
    expandedBlockView.delegate = self;
    collapsedView.expandedBlockView = expandedBlockView;
    
    expandedBlockView.alpha = kAlphaZero;
    [self.view addSubview:expandedBlockView];
    [self.view bringSubviewToFront:expandedBlockView];
    [UIView animateWithDuration:kViewAnimationDuration animations:^{
        expandedBlockView.alpha = kAlphaOpaque;
    }];
}

- (void)panDidChange:(UIPanGestureRecognizer *)sender forCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)collapsedView
{
        CGPoint touchLocation = [sender locationInView:self.view];
        collapsedView.expandedBlockView.center = touchLocation;
        collapsedView.expandedBlockView.alpha = CGRectIntersectsRect(self.blocksContainerView.frame, collapsedView.expandedBlockView.frame) ? kAlphaHalf : kAlphaOpaque;
        [self.view bringSubviewToFront:collapsedView.expandedBlockView];
        [self checkIntersectionFromSender:sender forLanguageBlockView:collapsedView.expandedBlockView];
}

- (void)panDidEnd:(UIPanGestureRecognizer *)sender forCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)collapsedView
{
    if (CGRectIntersectsRect(self.blocksContainerView.frame, collapsedView.expandedBlockView.frame))
    {
        [UIView animateWithDuration:kViewAnimationDuration animations:^{
            collapsedView.expandedBlockView.alpha = kAlphaZero;
        }];
        [collapsedView.expandedBlockView removeFromSuperview];
        collapsedView.expandedBlockView = nil;
    }
    else
    {
        [self.blockViewsInUse addObject:collapsedView.expandedBlockView];
    }
}

#pragma mark - Create test data

- (void)createTestData
{
    NSManagedObjectContext *context = self.context;
    NSEntityDescription *groupEntityDescription = [NSEntityDescription entityForName:LANGUAGE_GROUP_ENTITY_DESCRIPTION inManagedObjectContext:context];
    NSEntityDescription *languageBlockEntityDescription = [NSEntityDescription entityForName:LANGUAGE_BLOCK_ENTITY_DESCRIPTION inManagedObjectContext:context];
    
    // Blocks
    BBLanguageBlock *blush = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    blush.name = @"blush";
    
    BBLanguageBlock *giggle = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    giggle.name = @"giggle";
    
    BBLanguageBlock *shake = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    shake.name = @"shake";
    
    BBLanguageBlock *cry = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    cry.name = @"cry";
    
    BBLanguageBlock *yawn = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    yawn.name = @"yawn";
    
    BBLanguageBlock *sayYes = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    sayYes.name = @"say 'yes'";
    
    BBLanguageBlock *sayNo = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    sayNo.name = @"say 'no'";
    
    BBLanguageBlock *ifThenBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    ifThenBlock.name = IF_THEN_BLOCK_NAME;
    
    BBLanguageBlock *ifThenElseBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    ifThenElseBlock.name = IF_THEN_ELSE_BLOCK_NAME;
    
    BBLanguageBlock *repeatBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    repeatBlock.name = REPEAT_BLOCK_NAME;
    
    BBLanguageBlock *waitBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    waitBlock.name = WAIT_BLOCK_NAME;
    
    //    BBLanguageBlock *switchStateToBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    //    switchStateToBlock.name = @"switchStateTo";
    
    BBLanguageBlock *greaterThanBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    greaterThanBlock.name = @"greaterThan";
    greaterThanBlock.abbreviation = @">";
    
    BBLanguageBlock *lessThanBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    lessThanBlock.name = @"lessThan";
    lessThanBlock.abbreviation = @"<";
    
    BBLanguageBlock *equalToBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    equalToBlock.name = @"equalTo";
    equalToBlock.abbreviation = @"=";
    
    BBLanguageBlock *orBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    orBlock.name = @"or";
    
    BBLanguageBlock *andBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    andBlock.name = @"and";
    
    BBLanguageBlock *notBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    notBlock.name = NOT_BLOCK_NAME;
    
    BBLanguageBlock *additionBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    additionBlock.name = @"addition";
    additionBlock.abbreviation = @"+";
    
    BBLanguageBlock *subtractionBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    subtractionBlock.name = @"subtraction";
    subtractionBlock.abbreviation = @"–";
    
    BBLanguageBlock *divisionBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    divisionBlock.name = @"division";
    divisionBlock.abbreviation = @"/";
    
    BBLanguageBlock *multiplicationBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    multiplicationBlock.name = @"multiplication";
    multiplicationBlock.abbreviation = @"x";
    
    BBLanguageBlock *newBooleanVariable = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    newBooleanVariable.name = @"newBooleanVariable";
    
    BBLanguageBlock *newIntegerVariable = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    newIntegerVariable.name = @"newIntegerVariable";
    
    [self populateAccessories];
    NSMutableArray *accessoryBlocks = [[NSMutableArray alloc] initWithCapacity:[self.accessories count]];
    for (BBAccessory *accessory in self.accessories)
    {
        BBLanguageBlock *accessoryBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
        accessoryBlock.name = accessory.name;
        [accessoryBlocks addObject:accessoryBlock];
    }
    
    BBLanguageGroup *control = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription
                                        insertIntoManagedObjectContext:context];
    control.name = CONTROL_GROUP;
    control.blocks = [NSSet setWithArray:@[ifThenBlock, ifThenElseBlock, repeatBlock, waitBlock]];
    
    BBLanguageGroup *fromCloset = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription insertIntoManagedObjectContext:context];
    fromCloset.name = FROM_CLOSET_GROUP;
    fromCloset.blocks = [NSSet setWithArray:[accessoryBlocks copy]];
    
    BBLanguageGroup *reactions = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription
                                  
                                          insertIntoManagedObjectContext:context];
    reactions.name = REACTIONS_GROUP;
    reactions.blocks = [NSSet setWithArray:@[blush, giggle, shake, cry, yawn, sayYes, sayNo]];
    
    BBLanguageGroup *operators = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription insertIntoManagedObjectContext:context];
    operators.name = OPERATORS_GROUP;
    operators.blocks = [NSSet setWithArray:@[greaterThanBlock, lessThanBlock, equalToBlock, andBlock, orBlock, notBlock, additionBlock, subtractionBlock, multiplicationBlock, divisionBlock]];
    
    BBLanguageGroup *variables = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription insertIntoManagedObjectContext:context];
    variables.name = VARIABLES_GROUP;
    //variables.blocks = [NSSet setWithArray:@[newBooleanVariable, newIntegerVariable]];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Could not save: %@", [error localizedDescription]);
    }
}


- (void)populateAccessories
{
    NSManagedObjectContext *context = self.context;
    if (context)
    {
        self.accessoriesFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[self allAccessoriesFetchRequest]
                                                                                       managedObjectContext:context
                                                                                         sectionNameKeyPath:nil
                                                                                                  cacheName:nil];
        [self.accessoriesFetchedResultsController setDelegate:self];
        [self.accessoriesFetchedResultsController performFetch:nil];
        self.accessories = [self.accessoriesFetchedResultsController fetchedObjects];
    }
}

- (NSFetchRequest *)allAccessoriesFetchRequest
{
    NSFetchRequest *allCategoriesFetchRequest = [NSFetchRequest fetchRequestWithEntityName:ACCESSORY_ENTITY_DESCRIPTION];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:NAME_SORT_DESCRIPTOR_KEY ascending:YES];
    [allCategoriesFetchRequest setSortDescriptors:@[sort]];
    return allCategoriesFetchRequest;
}

@end
