//
//  BBSwitchToBlockView.m
//  blob
//
//  Created by Sam Yang on 8/27/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBSwitchToBlockView.h"
#import "BBAppDelegate.h"
#import "BBFeeling.h"

@interface BBSwitchToBlockView () <UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *switchToButton;
@property (strong, nonatomic) NSFetchedResultsController *feelingsFetchedResultsController;
@property (strong, nonatomic) NSMutableArray *feelings;
@end

@implementation BBSwitchToBlockView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self populateFeelings];
}

- (void)populateFeelings
{
    NSManagedObjectContext *context = ((BBAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;

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


- (IBAction)switchToButtonPressed:(UIButton *)sender {
    self.frame = [self expandedPickerFrame];
    [self.switchToButton setTitle:nil forState:UIControlStateNormal];
    UIPickerView *moodPickerView = [[UIPickerView alloc] initWithFrame:self.switchToButton.frame];
    moodPickerView.dataSource = self;
    moodPickerView.delegate = self;
    [self addSubview:moodPickerView];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    BBFeeling *feeling = [self.feelings objectAtIndex:row];
    return feeling.name;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.feelings count];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [pickerView removeFromSuperview];
    self.frame = [self originalFrame];
    BBFeeling *feeling = [self.feelings objectAtIndex:row];
    self.switchToButton.titleLabel.alpha = 1.0f;
    [self.switchToButton setTitle:feeling.name forState:UIControlStateNormal];
}

- (CGRect)expandedPickerFrame
{
    return CGRectMake(self.frame.origin.x, self.frame.origin.y, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) + 216.0f);
}

- (CGSize)originalSize
{
    return CGSizeMake(310.0f, 55.0f);
}

@end
