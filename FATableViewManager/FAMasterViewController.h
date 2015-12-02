//
//  FAMasterViewController.h
//  FATableViewManager
//
//  Created by Rasmus Kildevæld on 10/06/14.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAMasterViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)Insert:(id)sender;

@end
