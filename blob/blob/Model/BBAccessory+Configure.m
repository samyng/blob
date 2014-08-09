//
//  BBAccessory+Configure.m
//  blob
//
//  Created by Sam Yang on 8/8/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import "BBAccessory+Configure.h"

@implementation BBAccessory (Configure)

- (UIImage *)thumbnailImage
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"thumbnail_%@", self.name]];
}

@end
