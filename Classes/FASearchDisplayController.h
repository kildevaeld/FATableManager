//
//  FASearchDisplayController.h
//  SearchTest
//
//  Created by Rasmus Kildevæld on 20/01/14.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FASearchViewViewController;
@protocol FASearchDisplayControllerDelegate;

@interface FASearchDisplayController : NSObject <UISearchBarDelegate, UITextFieldDelegate> {
    UISearchBar *_searchBar;
    
}

@property (nonatomic, weak) id<FASearchDisplayControllerDelegate> delegate;
@property (nonatomic, weak) id<UITableViewDataSource> searchResultsDataSource;
@property (nonatomic, weak) id<UITableViewDelegate> searchResultsDelegate;

@property (nonatomic, strong, readonly) UITableView *searchResultsTableView;
@property (nonatomic ,strong, readonly) UIViewController *contentsController;

- (id)initWithSearchBar:(UISearchBar *)sb contentsController:(UIViewController *)viewController;

- (void)close:(void (^)(void))completion;

@end


@protocol FASearchDisplayControllerDelegate <NSObject>

- (BOOL)searchDisplayController:(FASearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString;

- (void)searchDisplayControllerWillBeginSearch:(FASearchDisplayController *)controller;



@end