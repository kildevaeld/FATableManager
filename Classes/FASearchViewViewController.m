//
//  FASearchViewViewController.m
//  SearchTest
//
//  Created by Rasmus Kildevæld on 20/01/14.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
//

#import "FASearchViewViewController.h"

@interface FASearchViewViewController ()

@end

@implementation FASearchViewViewController


- (id)initWithSearchBar:(UISearchBar *)sb contentsController:(UIViewController *)viewController {
    if ((self = [super init])) {
        originalFrame = [sb convertRect:sb.window.bounds toView:nil];
        originalFrame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, sb.frame.size.width, sb.frame.size.height);
        _searchBar = [[UISearchBar alloc] initWithFrame:originalFrame];
        
        _searchBar.delegate = self;
        _searchBar.tintColor = sb.tintColor;
        _searchBar.translucent = sb.translucent;
        _searchBar.barStyle = sb.barStyle;
        _searchBar.barTintColor = sb.barTintColor;
        _originalSearchBar = sb;
        _originalContentsController = viewController;
        
    }
    return self;
}

- (void)loadView{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_searchBar];
    
   
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)show:(void (^)(void))complete {
    _originalSearchBar.hidden = YES;
    
    [UIView animateWithDuration:0.4f animations:^{
        CGRect frame = _searchBar.frame;
        frame.origin.y = 20.f;
        _searchBar.frame = frame;
        
        frame = _originalContentsController.navigationController.navigationBar.frame;
        frame.origin.y -= 64;
        _originalContentsController.navigationController.navigationBar.frame = frame;
        
        frame = _originalContentsController.view.window.frame;
        frame.origin.y -= 44;
        frame.size.height += 44;
        _originalContentsController.view.window.frame = frame;
        
    } completion:^(BOOL finished) {
        
        [_searchBar setShowsCancelButton:YES animated:YES];
        [_searchBar becomeFirstResponder];
        if (complete)
            complete();
    }];
}

- (void)close:(void (^)(void))complete {
    [_searchBar resignFirstResponder];
    
    
    
    originalFrame = [_originalSearchBar convertRect:_originalSearchBar.window.bounds toView:nil];
    originalFrame = CGRectMake(originalFrame.origin.x, originalFrame.origin.y, _originalSearchBar.frame.size.width, _originalSearchBar.frame.size.height);
    
    [UIView animateWithDuration:0.6f animations:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        
        _searchBar.frame = originalFrame;
        _searchBar.text = @"";
        
        CGRect frame = originalFrame;
        CGRect newFrame = self.view.bounds;
        newFrame.size.height -= frame.size.height+frame.origin.y;
        newFrame.origin.y += frame.size.height+frame.origin.y;
        
        self.tableView.frame = newFrame;
        self.tableView.alpha = 0.f;
        
        frame = _originalContentsController.navigationController.navigationBar.frame;
        frame.origin.y += 64;
        _originalContentsController.navigationController.navigationBar.frame = frame;
        
        frame = _originalContentsController.view.window.frame;
        frame.origin.y += 44;
        frame.size.height -= 44;
        _originalContentsController.view.window.frame = frame;
        
    } completion:^(BOOL finished) {
        _originalSearchBar.hidden = NO;
        [self.tableView removeFromSuperview];
        CGRect newFrame = self.view.bounds;
        newFrame.size.height -= 64;
        newFrame.origin.y += 64;
        self.tableView.frame = newFrame;
        
        if (finished)
            if (complete)
                complete();
    }];
    
    [_searchBar setShowsCancelButton:NO animated:YES];
    
}


#pragma mark UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.delegate searchBarCancelButtonClicked:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.delegate searchBar:searchBar textDidChange:searchText];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.delegate searchBarTextDidBeginEditing:searchBar];
    
    if (!self.tableView.superview) {
        self.tableView.backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.8];
        self.tableView.backgroundColor = [UIColor clearColor];
        
        [self.view addSubview:self.tableView];
        
        self.tableView.alpha = 0.f;
        [UIView animateWithDuration:0.3f animations:^{
            self.tableView.alpha = 1.f;
        }];
    }
}


#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        /*CGRect frame = _searchBar.frame;
        CGRect newFrame = self.view.bounds;
        newFrame.size.height -= frame.size.height+frame.origin.y;
        newFrame.origin.y += frame.size.height+frame.origin.y;*/
        
        CGRect newFrame = self.view.bounds;
        newFrame.size.height -= 64;
        newFrame.origin.y += 64;
        
        _tableView = [[UITableView alloc] initWithFrame:newFrame];
    }
    return _tableView;
}
@end
