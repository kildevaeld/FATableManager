//
//  FAMasterViewController.m
//  FATableViewManager
//
//  Created by Rasmus Kildevæld on 10/06/14.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
//

#import "FAMasterViewController.h"

#import "FADetailViewController.h"
#import "FATableManager.h"
#import "FADataStore.h"

#import "FASearchDisplayController.h"

@interface FAMasterViewController () {
    NSMutableArray *_objects;
    FATableManager *manager;
    FASearchDisplayController *search_display_controller;
}
@end

@implementation FAMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    
    search_display_controller = [[FASearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    manager = [[FATableManager alloc] initWithTableView:self.tableView];
    
    manager.type = FATableManagerCoreDataType;
    
    [manager setMessage:@"Empty table message" forState:FATableManagerNoResultsMessage];
    
    [manager configureDataSource:^(__weak FACoreDataDataSource *ds) {

        ds.batchSize = 10;
        ds.managedObjectContext = [FADataStore defaultStore].mainQueueManagedObjectContext;
        
        ds.entity = @"Blog";
        ds.sortKey = @"name";
        
        //ds.cellIdentifier = @"NoBrain";
        ds.sortAscending = YES;
        ds.sectionNameKeyPath = @"name.stringGroupByFirstInitial";
        [ds setConfigureCell:^(UITableViewCell *cell, NSIndexPath *ip, FATableViewDynamicItem *item) {
            cell.textLabel.text = [item valueForKey:@"name"];
        }];
        
        self.tableView.dataSource = ds;
        
    }];
    
    
    [manager configureDelegate:^(FATableViewDelegate *__weak delegate) {
        [delegate setAnimation:YES];
        delegate.animator.animationBlock = ADLivelyTransformCurl;
        [delegate setOnRowSelected:^(NSIndexPath *ip, FATableViewDynamicItem *item) {
            [self performSegueWithIdentifier:@"showDetail" sender:self.tableView];
        }];
        
        delegate.headerHeight = 22;
        
    }];
    
    
    
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   // self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    /*if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];*/
    /*[manager configureDataSource:^(__weak FATableViewDynamicDataSource *d) {
        FATableViewDynamicSection *section = [d sectionAtIndex:0];
        NSLog(@"Test Data %@",section);
        [section addRowWithData:@"Test noget data"];
    }];*/
    [manager.dataSource clear];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [manager reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FATableViewDynamicItem *data = [manager.dataSource dataAtIndexPath:indexPath];
        
        //NSDate *object = _objects[indexPath.row];
        
        [[segue destinationViewController] setDetailItem:data];
    }
}

- (IBAction)Insert:(id)sender {
    
    if ([manager.dataSource fetchedObjects].count > 0) {
        /*[(FATableViewDynamicDataSource*)manager.dataSource clear];
        [manager reloadData];
        [manager.dataSource performFetch:nil];
        return;*/
    }
    if ([manager.dataSource isKindOfClass:[FACoreDataDataSource class]]) {
        NSManagedObjectContext *context = [[FADataStore defaultStore] newChildManagedObjectContextWithConcurrencyType:NSPrivateQueueConcurrencyType];
        //[context deleteAllObjectsForEntity:@"Blog"];
        [context performBlock:^{
            for (int i = 0; i < 100; i++) {
                NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:@"Blog" inManagedObjectContext:context];
                [object setValue:[NSString stringWithFormat:@"Blog title #%i",i] forKey:@"name"];
                [object setValue:[NSString stringWithFormat:@"Description #%i",i] forKey:@"desc"];
                [object setValue:@(i) forKey:@"age"];
                if (i % 100)
                    [context saveToPersistentStore:nil];
            }
            [context saveToPersistentStore:nil];
            //[manager.dataSource performFetch:nil];
            //[manager reloadData];
            
            NSLog(@"Result %@", [manager.dataSource fetchedObjects]);
        }];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            FATableViewDynamicDataSource *d = (FATableViewDynamicDataSource *)manager.dataSource;
            FATableViewDynamicSection *section = [d addSectionWithTitle:@"En ny section"];
            
            for (int i = 0; i < 1000; i++) {
                [section addRowWithData:[NSString stringWithFormat:@"Row #%i",i]];
                if (i % 100 == 0)
                    section = [d addSectionWithTitle:[NSString stringWithFormat:@"Test title #%i - %i",i,i+100]];
            }
            [section addRowWithData:@"Test Data"];
            [section addRowWithData:@"Der var engang"];
            [section addRowWithData:@"Tjek tjek"];
            [manager reloadData];
        });

    }
    
    
    
}
@end
