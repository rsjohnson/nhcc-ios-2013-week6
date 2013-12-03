//
//  AFAnimalManager.h
//  AnimalFacts
//
//  Created by Ryan Johnson on 12/2/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface AFAnimalManager : NSObject

+ (instancetype) sharedManager;

@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

@end
