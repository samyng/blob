//
//  BBClosetViewController.m
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBClosetViewController.h"

static NSString * const kCategoriesTableCellIdentifier = @"categoriesTableCellIdentifier";

@interface BBClosetViewController () <UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoriesTableView;
@property (strong, nonatomic) NSArray *categories;

@end

@implementation BBClosetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.categoriesTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCategoriesTableCellIdentifier];
    self.categories = @[@"All", @"Food", @"Clothes", @"Friends", @"Places"];
}

#pragma mark - Table View Datasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.categories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.categoriesTableView dequeueReusableCellWithIdentifier:kCategoriesTableCellIdentifier];
    cell.textLabel.text = [self.categories objectAtIndex:indexPath.row];
    return cell;
}

@end
