//
//  BBAccessory.h
//  blob
//
//  Created by Sam Yang on 8/5/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBAccessory : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *thumbnailImage;
- (id)initWithName:(NSString *)name;

@end
