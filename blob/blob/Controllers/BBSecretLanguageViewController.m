//
//  BBSecretLanguageViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBSecretLanguageViewController.h"
#import "BBCodeBlockCollectionCell.h"
#import "BBLanguageBlock.h"
#import "BBLanguageGroup.h"

static NSString * const kGroupsTableCellIdentifier = @"groupsTableCellIdentifier";
static NSString * const kCodeBlockCollectionCellIdentifier = @"codeBlockCollectionCellIdentifier";

@interface BBSecretLanguageViewController () <UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *codeBlocksCollectionView;
@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;
@property (strong, nonatomic) NSArray *groups;
@property (strong, nonatomic) NSFetchedResultsController *groupsFetchedResultsController;
@end

@implementation BBSecretLanguageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.groupsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kGroupsTableCellIdentifier];
    [self.codeBlocksCollectionView registerNib:[UINib nibWithNibName:@"BBCodeBlockCollectionCell" bundle:nil] forCellWithReuseIdentifier:kCodeBlockCollectionCellIdentifier];
    
    [self populateLanguageGroups];
    
#warning - test heavily before shipping final product -SY (8/8/14)
    
#if DEBUG
    if ([self.groups count] == 0)
    {
        [self createTestData];
    }
#endif
    
    [self.groupsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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
    if (self.groups)
    {
        group = [self.groups objectAtIndex:selectedRowIndex];
    }
    return [group.blocks count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        BBCodeBlockCollectionCell *cell = (BBCodeBlockCollectionCell *)[self.codeBlocksCollectionView dequeueReusableCellWithReuseIdentifier:kCodeBlockCollectionCellIdentifier
                                                                                                                                forIndexPath:indexPath];
        NSInteger selectedRowIndex = [self groupsTableCellSelectedRowIndex];
        NSArray *languageBlocks = [[[self.groups objectAtIndex:selectedRowIndex] blocks] allObjects];
        BBLanguageBlock *block = [languageBlocks objectAtIndex:indexPath.item];
        [cell configureWithBlock:block];
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
    
    BBLanguageBlock *ifBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    ifBlock.name = @"if";
    
    BBLanguageBlock *repeatBlock = [[BBLanguageBlock alloc] initWithEntity:languageBlockEntityDescription insertIntoManagedObjectContext:context];
    repeatBlock.name = @"repeat";
    
    BBLanguageGroup *reactions = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription
                              
                                          insertIntoManagedObjectContext:context];
    reactions.name = REACTIONS_GROUP;
    reactions.blocks = [NSSet setWithArray:@[blush, giggle, shake, cry]];
    
    BBLanguageGroup *controls = [[BBLanguageGroup alloc] initWithEntity:groupEntityDescription
                                         insertIntoManagedObjectContext:context];
    controls.name = CONTROL_GROUP;
    controls.blocks = [NSSet setWithArray:@[ifBlock, repeatBlock]];
    
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
