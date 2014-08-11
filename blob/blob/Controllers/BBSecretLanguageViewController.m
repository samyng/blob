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

static NSString * const kGroupsTableCellIdentifier = @"groupsTableCellIdentifier";
static NSString * const kLanguageBlockCollectionCellIdentifier = @"languageBlockCollectionCellIdentifier";

@interface BBSecretLanguageViewController () <UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *languageBlocksCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) NSFetchedResultsController *groupsFetchedResultsController;
@end

@implementation BBSecretLanguageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.groupsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kGroupsTableCellIdentifier];
    [self.languageBlocksCollectionView registerNib:[UINib nibWithNibName:@"BBLanguageBlockCollectionCell" bundle:nil] forCellWithReuseIdentifier:kLanguageBlockCollectionCellIdentifier];
    
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
    self.languageBlocksCollectionView.backgroundColor = [self backgroundColorOfBlocksCollectionViewForGroup:CONTROL_GROUP]; // hack to set initial background color to pink default - SY
}


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
    NSFetchRequest *allGroupsFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"LanguageGroup"];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:YES];
    [allGroupsFetchRequest setSortDescriptors:@[sort]];
    return allGroupsFetchRequest;
}

#pragma mark - Collection View Datasource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return kTotalNumberOfSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger selectedRowIndex = [self groupsTableCellSelectedRowIndex];
    BBLanguageGroup *group;
    if (self.groups.count)
    {
        group = [self.groups objectAtIndex:selectedRowIndex];
    }
    return [group.blocks count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        BBLanguageBlockCollectionCell *cell = (BBLanguageBlockCollectionCell *)[self.languageBlocksCollectionView dequeueReusableCellWithReuseIdentifier:kLanguageBlockCollectionCellIdentifier
                                                                                                                                forIndexPath:indexPath];
        NSInteger selectedRowIndex = [self groupsTableCellSelectedRowIndex];
        NSArray *languageBlocks = [[[self.groups objectAtIndex:selectedRowIndex] blocks] allObjects];
        BBLanguageBlock *block = [languageBlocks objectAtIndex:indexPath.item];
        [cell configureWithBlock:block];
        cell.contentView.backgroundColor = [self backgroundColorForGroupTableCellWithName:block.group.name];
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
    NSString *name = [[self.groups objectAtIndex:indexPath.row] name];
    cell.textLabel.text = name;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:17.0f];
    cell.contentView.backgroundColor = [self backgroundColorForGroupTableCellWithName:name];
    
    CGRect frame = cell.contentView.frame;
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:frame];
    selectedBackgroundView.backgroundColor = [self backgroundColorForGroupTableCellWithName:name];
    [cell setSelectedBackgroundView:selectedBackgroundView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *name = [[self.groups objectAtIndex:indexPath.row] name];
    self.languageBlocksCollectionView.backgroundColor = [self backgroundColorOfBlocksCollectionViewForGroup:name];
    [self.languageBlocksCollectionView reloadData];
}

- (UIColor *)backgroundColorForGroupTableCellWithName:(NSString *)name
{
    if ([name isEqualToString:CONTROL_GROUP])
    {
        return [BBConstants pinkColor];
    }
    else if ([name isEqualToString:FROM_CLOSET_GROUP])
    {
        return [BBConstants orangeColor];
    }
    else if ([name isEqualToString:REACTIONS_GROUP])
    {
        return [BBConstants yellowColor];
    }
    else if ([name isEqualToString:OPERATORS_GROUP])
    {
        return [BBConstants lightBlueColor];
    }
    else if ([name isEqualToString:VARIABLES_GROUP])
    {
        return [BBConstants blueColor];
    }
    else
    {
        return [UIColor grayColor];
    }
}
                                                         
- (UIColor *)backgroundColorOfBlocksCollectionViewForGroup:(NSString *)name
    {
        if ([name isEqualToString:CONTROL_GROUP])
        {
            return [BBConstants pinkBackgroundColor];
        }
        else if ([name isEqualToString:FROM_CLOSET_GROUP])
        {
            return [BBConstants orangeBackgroundColor];
        }
        else if ([name isEqualToString:REACTIONS_GROUP])
        {
            return [BBConstants yellowBackgroundColor];
        }
        else if ([name isEqualToString:OPERATORS_GROUP])
        {
            return [BBConstants lightBlueBackgroundColor];
        }
        else if ([name isEqualToString:VARIABLES_GROUP])
        {
            return [BBConstants blueBackgroundColor];
        }
        else
        {
            return [UIColor lightGrayColor];
        }
    }

#pragma mark - Create test data

- (void)createTestData
{
    NSManagedObjectContext *context = self.context;
    NSEntityDescription *groupEntityDescription = [NSEntityDescription entityForName:@"LanguageGroup" inManagedObjectContext:context];
    NSEntityDescription *languageBlockEntityDescription = [NSEntityDescription entityForName:@"LanguageBlock" inManagedObjectContext:context];
    
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
    
    BBLanguageBlock *ifNearBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    ifNearBlock.name = @"if near";
    
    BBLanguageBlock *repeatBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    repeatBlock.name = @"repeat";
    
    BBLanguageBlock *switchState = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    switchState.name = @"switch state to";

    
    BBLanguageGroup *control = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription
                                         insertIntoManagedObjectContext:context];
    control.name = CONTROL_GROUP;
    control.blocks = [NSSet setWithArray:@[ifNearBlock, repeatBlock, switchState]];
    
    BBLanguageGroup *fromCloset = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription insertIntoManagedObjectContext:context];
    fromCloset.name = FROM_CLOSET_GROUP;
    
    BBLanguageGroup *reactions = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription
                                  
                                          insertIntoManagedObjectContext:context];
    reactions.name = REACTIONS_GROUP;
    reactions.blocks = [NSSet setWithArray:@[blush, giggle, shake, cry, yawn]];
    
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
