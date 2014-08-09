//
//  BBAccessory.h
//  blob
//
//  Created by Sam Yang on 8/8/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BBAccessory : NSManagedObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *name;

@end
