//
//  FASearchDisplayController.m
//  SearchTest
//
//  Created by Rasmus Kildevæld on 20/01/14.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
//

#import "FASearchDisplayController.h"
#import "FASearchViewViewController.h"
@interface FASearchDisplayController ()

@property (nonatomic, strong) FASearchViewViewController *resultsViewController;
@property (nonatomic, strong) UIWindow *window;

- (void)setup;

@end

@implementation FASearchDisplayController

- (id)initWithSearchBar:(UISearchBar *)sb contentsController:(UIViewController *)viewController {
    if ((self = [super init])) {
        _searchBar = sb;
        _searchBar.delegate = self;
        _contentsController = viewController;
    }
    return self;
}


- (void)setup {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _window.opaque = NO;
    
    
    self.resultsViewController.delegate = self;
    _window.rootViewController = self.resultsViewController;
    
    
}

#pragma mark - UISearchBar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.delegate searchDisplayControllerWillBeginSearch:self];
    [self setup];
    
    [_window makeKeyAndVisible];
    [self.resultsViewController show:^{
        self.resultsViewController.tableView.delegate = self.searchResultsDelegate;
        self.resultsViewController.tableView.dataSource = self.searchResultsDataSource;
    }];
    
    
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self setup];
    [_window makeKeyAndVisible];
    return NO;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_resultsViewController close:^{
        [self.window removeFromSuperview];
        [self.contentsController.view.window makeKeyAndVisible];
        self.window = nil;
        
        //self.resultsViewController = nil;
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (self.delegate) {
        BOOL ret = [self.delegate searchDisplayController:self shouldReloadTableForSearchString:searchText];
        
        if (ret) {
            [self.searchResultsTableView reloadData];
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

- (void)close:(void (^)(void))completion {
    _resultsViewController.searchBar.alpha = 0;
    [_resultsViewController close:^{
        [self.window removeFromSuperview];
        [self.contentsController.view.window makeKeyAndVisible];
        self.window = nil;
        if (completion)
            completion();
        self.resultsViewController = nil;
    }];
}

#pragma mark - Getters
- (UITableView *)searchResultsTableView {
    return self.resultsViewController.tableView;
}

- (id<UITableViewDataSource>)searchResultsDataSource {
    return self.resultsViewController.tableView.dataSource;
}

- (id<UITableViewDelegate>)searchResultsDelegate {
    return self.resultsViewController.tableView.delegate;
}

- (FASearchViewViewController *)resultsViewController {
    if (!_resultsViewController) {
        _resultsViewController = [[FASearchViewViewController alloc] initWithSearchBar:_searchBar contentsController:_contentsController];
    }
    return _resultsViewController;
}

@end
