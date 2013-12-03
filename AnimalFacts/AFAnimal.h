//
//  AFAnimal.h
//  AnimalFacts
//
//  Created by Ryan Johnson on 12/2/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AFAnimal : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * species;
@property (nonatomic, retain) NSString * fact;
@property (nonatomic, retain) NSData * pictureData;

@end
