//
//  AFAnimalManager.m
//  AnimalFacts
//
//  Created by Ryan Johnson on 12/2/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "AFAnimalManager.h"

@implementation AFAnimalManager

+ (instancetype)sharedManager {
    static AFAnimalManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setUpCoreData];
    }
    return self;
}

- (void)setUpCoreData {
    _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [docDirectory stringByAppendingPathComponent:@"animals.sqlite"];
    NSURL *sqliteURL = [NSURL fileURLWithPath:sqlitePath];
    
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES,
                               NSInferMappingModelAutomaticallyOption : @YES };
    NSError *error;
    NSPersistentStore *sqliteStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                               configuration:nil
                                                                         URL:sqliteURL
                                                                     options:options
                                                                       error:&error];
//    NSAssert(sqliteStore, @"Error:%@", error);
    
    _mainContext.persistentStoreCoordinator = coordinator;
}

@end
