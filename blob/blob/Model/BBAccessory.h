//
//  BBAccessory.h
//  blob
//
//  Created by Sam Yang on 8/9/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBClosetCategory;

@interface BBAccessory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) BBClosetCategory *category;

@end
