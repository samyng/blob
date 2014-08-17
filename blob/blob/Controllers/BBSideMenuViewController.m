//
//  BBSideMenuViewController.m
//  blob
//
//  Created by Sam Yang on 8/12/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBSideMenuViewController.h"

static NSString * const kSideMenuTableCellIdentifier = @"sideMenuTableCellIdentifier";

@interface BBSideMenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *rowTitles;
@property (weak, nonatomic) IBOutlet UITableView *sideMenuTableView;
@end

@implementation BBSideMenuViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.sideMenuTableView registerClass:[UITableViewCell class]
                   forCellReuseIdentifier:kSideMenuTableCellIdentifier];
    self.sideMenuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    self.rowTitles = @[@"Examples", @"Tutorial", @"About Blob", @"User Settings", @"Logout"];
}

#pragma mark - Table View Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rowTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.sideMenuTableView dequeueReusableCellWithIdentifier:kSideMenuTableCellIdentifier];
    cell.contentView.backgroundColor = [BBConstants tealColor];
    cell.textLabel.text = [self.rowTitles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:BLOB_FONT_BOLD size:21.0f];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

@end
