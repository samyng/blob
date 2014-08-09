//
//  BBClosetCategory.h
//  blob
//
//  Created by Sam Yang on 8/9/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBAccessory;

@interface BBClosetCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *accessories;
@end

@interface BBClosetCategory (CoreDataGeneratedAccessors)

- (void)addAccessoriesObject:(BBAccessory *)value;
- (void)removeAccessoriesObject:(BBAccessory *)value;
- (void)addAccessories:(NSSet *)values;
- (void)removeAccessories:(NSSet *)values;

@end
