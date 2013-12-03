//
//  AFAnimalFactsController.m
//  AnimalFacts
//
//  Created by Jacob Good on 11/5/13.
//  Copyright (c) 2013 Jacob Good. All rights reserved.
//

#import "AFAnimalFactsController.h"
#import "AFAnimalViewController.h"
#import "AFAnimal.h"
#import "AFAnimalManager.h"

@interface AFAnimalFactsController ()
< NSFetchedResultsControllerDelegate >

@end

@implementation AFAnimalFactsController
{
    NSFetchedResultsController *_fetchController;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"AFAnimal"];
    request.predicate = [NSPredicate predicateWithValue:YES];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSArray *results = [[AFAnimalManager sharedManager].mainContext executeFetchRequest:request error:nil];
    
    _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[AFAnimalManager sharedManager].mainContext sectionNameKeyPath:nil cacheName:@"allAnimals"];
    _fetchController.delegate = self;
    [_fetchController performFetch:nil];
}

- (void) removeAnimal:(AFAnimal *) animal {
    [self.animals removeObject:animal];
    [self sortAnimals];
}

- (void) sortAnimals {
    NSArray *sortedArray;
    sortedArray = [self.animals sortedArrayUsingSelector:@selector(compare:)];
    self.animals = [(NSArray*)sortedArray mutableCopy];
}

- (void) saveAnimals {
    //[AFAnimal saveAnimals:self.animals];
}

- (void) clearSubject:(id) sender {
    self.subject = nil;
}

- (void) saveSubject:(id) sender {
    if (self.subject != nil) {
        if (![self.animals containsObject:self.subject]) {
            [self.animals addObject:self.subject];
            [self sortAnimals];
        }
        [self saveAnimals];
        [self.animalTableView reloadData];
    }
}

- (void) dealloc {
    [self clearSubject:nil];
   /* [[NSNotificationCenter defaultCenter] removeObserver:self name:AFAnimalSubjectSaved object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AFAnimalSubjectCancelled object:nil];*/
}

#pragma mark - Fetched Results Controller Delegate 

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark -

- (void) deleteAnimal:(UILongPressGestureRecognizer*)gr {
    if (gr.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    UITableViewCell *cell = gr.view;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AFAnimal *animal = [_fetchController objectAtIndexPath:indexPath];
    NSManagedObjectContext *context = [AFAnimalManager sharedManager].mainContext;
    [context deleteObject:animal];
    [context save:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_fetchController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    AFAnimal * animal = [_fetchController objectAtIndexPath:indexPath];
    cell.textLabel.text = animal.name;
    if (cell.gestureRecognizers.count == 0) {
        UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteAnimal:)];
        [cell addGestureRecognizer:gr];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        AFAnimal * animal = [self.animals objectAtIndex:indexPath.row];
        [self removeAnimal:animal];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AFAnimalViewController *vc = (AFAnimalViewController*) [segue destinationViewController];
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        // Fetch animal out of list
        UITableViewCell * cell = (UITableViewCell*) sender;
        NSIndexPath * indexPath = [self.animalTableView indexPathForCell:cell];
        vc.animal = self.animals[indexPath.row];
    } else {
        NSManagedObjectContext *ctx = [[AFAnimalManager sharedManager] mainContext];
        AFAnimal *animal = (id)[NSEntityDescription insertNewObjectForEntityForName:@"AFAnimal" inManagedObjectContext:ctx];
        vc.animal = animal;
    }
}

@end
