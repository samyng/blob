//
//  BBLanguageGroup.h
//  blob
//
//  Created by Sam Yang on 8/9/14.
//  Copyright (c) 2014 Crazy Machine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BBLanguageBlock;

@interface BBLanguageGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *blocks;
@end

@interface BBLanguageGroup (CoreDataGeneratedAccessors)

- (void)addBlocksObject:(BBLanguageBlock *)value;
- (void)removeBlocksObject:(BBLanguageBlock *)value;
- (void)addBlocks:(NSSet *)values;
- (void)removeBlocks:(NSSet *)values;

@end
