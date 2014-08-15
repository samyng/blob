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
#import "BBExpandedLanguageBlockImageView.h"

static NSString * const kGroupsTableCellIdentifier = @"groupsTableCellIdentifier";
static NSString * const kCollapsedImageStringFormat = @"%@Block-collapsed";
static NSInteger const kControlGroupIndexRow = 0;

@interface BBSecretLanguageViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CollapsedLanguageBlockDelegate, ExpandedLanguageBlockDelegate>
@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;
@property (weak, nonatomic) IBOutlet UIView *blocksContainerView;
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) NSFetchedResultsController *groupsFetchedResultsController;
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
    
    [self resetBlocksContainerView];
    NSArray *languageBlocks = [group.blocks allObjects];
    if ([groupName isEqualToString:CONTROL_GROUP])
    {
        [self arrangeControlBlocks:languageBlocks];
    }
    else if ([groupName isEqualToString:FROM_CLOSET_GROUP])
    {
        [self arrangeAccessoryBlocks];
    }
    else if ([groupName isEqualToString:REACTIONS_GROUP])
    {
        [self arrangeReactionBlocks:languageBlocks];
    }
    else if ([groupName isEqualToString:OPERATORS_GROUP])
    {
        NSLog(@"operators");
    }
    else if ([groupName isEqualToString:VARIABLES_GROUP])
    {
        NSLog(@"variables");
    }

}

#pragma mark - Arrange Blocks

- (void)arrangeControlBlocks:(NSArray *)controlBlocks
{
    const CGFloat xPadding = 30.0f;
    CGFloat xOrigin = 20.0f;
    CGFloat yOrigin = 20.0f;
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
}

- (void)arrangeAccessoryBlocks
{
    NSLog(@"arrange accessories");
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
        xOrigin = calculatedEndingX;
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

- (void)panDidChange:(UIPanGestureRecognizer *)sender forExpandedLanguageBlockImageView:(BBExpandedLanguageBlockImageView *)draggableImageView
{
    CGPoint touchLocation = [sender locationInView:self.view];
    draggableImageView.center = touchLocation;
    draggableImageView.alpha = CGRectIntersectsRect(self.blocksContainerView.frame, draggableImageView.frame) ? kAlphaHalf : kAlphaOpaque;
    [self.view bringSubviewToFront:draggableImageView];
}

- (void)panDidEnd:(UIPanGestureRecognizer *)sender forExpandedLanguageBlockImageView:(BBExpandedLanguageBlockImageView *)draggableImageView
{
    if (CGRectIntersectsRect(self.blocksContainerView.frame, draggableImageView.frame))
    {
        [UIView animateWithDuration:kViewAnimationDuration animations:^{
            draggableImageView.alpha = kAlphaZero;
        }];
        [draggableImageView removeFromSuperview];
        draggableImageView = nil;
    }
}

#pragma mark - Collpased Language Block Delegate Methods

- (void)panDidBegin:(UIPanGestureRecognizer *)sender inCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)languageBlockView
{
    BBExpandedLanguageBlockImageView *draggableImageView = [[BBExpandedLanguageBlockImageView alloc] initWithImage:[languageBlockView rasterizedImageCopy]];
    draggableImageView.delegate = self;
    languageBlockView.draggableCopyImageView = draggableImageView;
    
    draggableImageView.alpha = kAlphaZero;
    [self.view addSubview:draggableImageView];
    [self.view bringSubviewToFront:draggableImageView];
    [UIView animateWithDuration:kViewAnimationDuration animations:^{
        draggableImageView.alpha = kAlphaOpaque;
    }];
}

- (void)panDidChange:(UIPanGestureRecognizer *)sender forCollapsedLanguageBlockView:(BBCollapsedLanguageBlockImageView *)languageBlockView
{
    CGPoint touchLocation = [sender locationInView:self.view];
    languageBlockView.draggableCopyImageView.center = touchLocation;
    languageBlockView.draggableCopyImageView.alpha = CGRectIntersectsRect(self.blocksContainerView.frame, languageBlockView.draggableCopyImageView.frame) ? kAlphaHalf : kAlphaOpaque;
    [self.view bringSubviewToFront:languageBlockView.draggableCopyImageView];
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
    ifThenBlock.name = @"ifThen";
    
    BBLanguageBlock *ifThenElseBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    ifThenElseBlock.name = @"ifThenElse";
    
    BBLanguageBlock *repeatBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    repeatBlock.name = @"repeat";
    
    BBLanguageBlock *waitBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    waitBlock.name = @"wait";
    
//    BBLanguageBlock *switchStateToBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
//    switchStateToBlock.name = @"switchStateTo";

    
    BBLanguageGroup *control = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription
                                         insertIntoManagedObjectContext:context];
    control.name = CONTROL_GROUP;
    control.blocks = [NSSet setWithArray:@[ifThenBlock, ifThenElseBlock, repeatBlock, waitBlock]];
    
    BBLanguageGroup *fromCloset = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription insertIntoManagedObjectContext:context];
    fromCloset.name = FROM_CLOSET_GROUP;
    
    BBLanguageGroup *reactions = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription
                                  
                                          insertIntoManagedObjectContext:context];
    reactions.name = REACTIONS_GROUP;
    reactions.blocks = [NSSet setWithArray:@[blush, giggle, shake, cry, yawn, sayYes, sayNo]];
    
    BBLanguageGroup *operators = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription insertIntoManagedObjectContext:context];
    operators.name = OPERATORS_GROUP;
    
    BBLanguageGroup *variables = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription insertIntoManagedObjectContext:context];
    variables.name = VARIABLES_GROUP;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Could not save: %@", [error localizedDescription]);
    }
}

@end
