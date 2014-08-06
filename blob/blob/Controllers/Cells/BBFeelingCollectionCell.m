//
//  BBFeelingCollectionCell.m
//  blob
//
//  Created by Sam Yang on 8/6/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBFeelingCollectionCell.h"

@interface BBFeelingCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *feelingLabel;
@end

@implementation BBFeelingCollectionCell

- (void)configureWithName:(NSString *)name
{
    self.feelingLabel.text = name;
}

@end
