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
#import "BBCollapsedLanguageBlockView.h"
#import "BBExpandedLanguageBlockImageView.h"

static NSString * const kGroupsTableCellIdentifier = @"groupsTableCellIdentifier";

@interface BBSecretLanguageViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, CollapsedLanguageBlockViewDelegate, ExpandedLanguageBlockDelegate>
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
}

- (void)doneButtonPressed:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"did dismiss self");
    }];
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
    NSString *name = group.name;
    self.blocksContainerView.backgroundColor = [BBConstants backgroundColorForCellWithLanguageGroupName:name];
    
    // temporary hack to test customer uiview for language block - SY
    [self resetBlocksContainerView];
    BBCollapsedLanguageBlockView *blockView = [[BBCollapsedLanguageBlockView alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 200.0f, 40.0f)];
    blockView.backgroundColor = [BBConstants pinkColor];
    blockView.languageBlock = [[group.blocks allObjects] firstObject];
    NSLog(@"%@",blockView.languageBlock.name);
    blockView.delegate = self;
    [self.blocksContainerView addSubview:blockView];
}

- (void)resetBlocksContainerView
{
    for (UIView *subview in self.blocksContainerView.subviews)
    {
        [subview removeFromSuperview];
    }
}

#pragma mark - Draggable Language Block Delegate Methods

- (void)panDidChange:(UIPanGestureRecognizer *)sender forExpandedLanguageBlockImageView:(BBExpandedLanguageBlockImageView *)draggableImageView
{
    CGPoint touchLocation = [sender locationInView:self.view];
    draggableImageView.center = touchLocation;
    draggableImageView.alpha = CGRectIntersectsRect(self.blocksContainerView.frame, draggableImageView.frame) ? 0.5f : 1.0f;
}

- (void)panDidEnd:(UIPanGestureRecognizer *)sender forExpandedLanguageBlockImageView:(BBExpandedLanguageBlockImageView *)draggableImageView
{
    if (CGRectIntersectsRect(self.blocksContainerView.frame, draggableImageView.frame))
    {
        [UIView animateWithDuration:0.25f animations:^{
            draggableImageView.alpha = 0.0f;
        }];
        [draggableImageView removeFromSuperview];
        draggableImageView = nil;
    }
}

#pragma mark - Language Block Delegate Methods

- (void)panDidBegin:(UIPanGestureRecognizer *)sender inCollapsedLanguageBlockView:(BBCollapsedLanguageBlockView *)languageBlockView
{
    BBExpandedLanguageBlockImageView *draggableImageView = [[BBExpandedLanguageBlockImageView alloc] initWithImage:[languageBlockView rasterizedImageCopy]];
    draggableImageView.delegate = self;
    languageBlockView.draggableCopyImageView = draggableImageView;
    
    draggableImageView.alpha = 0.0f;
    [self.view addSubview:draggableImageView];
    [UIView animateWithDuration:0.25f animations:^{
        draggableImageView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:draggableImageView];
    }];
}

- (void)panDidChange:(UIPanGestureRecognizer *)sender forCollapsedLanguageBlockView:(BBCollapsedLanguageBlockView *)languageBlockView
{
    CGPoint touchLocation = [sender locationInView:self.view];
    languageBlockView.draggableCopyImageView.center = touchLocation;
    languageBlockView.draggableCopyImageView.alpha = CGRectIntersectsRect(self.blocksContainerView.frame, languageBlockView.draggableCopyImageView.frame) ? 0.5f : 1.0f;
}

#pragma mark - Create test data

- (void)createTestData
{
    NSManagedObjectContext *context = self.context;
    NSEntityDescription *groupEntityDescription = [NSEntityDescription entityForName:LANGUAGE_GROUP_ENTITY_DESCRIPTION inManagedObjectContext:context];
    NSEntityDescription *languageBlockEntityDescription = [NSEntityDescription entityForName:LANGUAGE_BLOCK_ENTITY_DESCRIPTION inManagedObjectContext:context];
    
    // Blocks
//    BBLanguageBlock *blush = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
//    blush.name = @"blush";
//    
//    BBLanguageBlock *giggle = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
//    giggle.name = @"giggle";
//    
//    BBLanguageBlock *shake = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
//    shake.name = @"shake";
//    
//    BBLanguageBlock *cry = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
//    cry.name = @"cry";
//    
//    BBLanguageBlock *yawn = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
//    yawn.name = @"yawn";
    
    BBLanguageBlock *ifThenBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    ifThenBlock.name = @"ifThen";
    
    BBLanguageBlock *ifThenElseBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    ifThenElseBlock.name = @"ifThenElse";
    
    BBLanguageBlock *repeatBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    repeatBlock.name = @"repeat";
    
    BBLanguageBlock *waitBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    waitBlock.name = @"wait";
//    
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
//    reactions.blocks = [NSSet setWithArray:@[blush, giggle, shake, cry, yawn]];
    
    BBLanguageGroup *operators = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription insertIntoManagedObjectContext:context];
    operators.name = OPERATORS_GROUP;
    
    BBLanguageGroup *variables = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription insertIntoManagedObjectContext:context];
    variables.name = VARIABLES_GROUP;
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Could not save: %@", [error localizedDescription]);
    }
}

#pragma mark - Helper Methods

- (NSInteger)groupsTableCellSelectedRowIndex
{
    return [self.groupsTableView indexPathForSelectedRow].row;
}


@end
