//
//  FASearchViewViewController.h
//  SearchTest
//
//  Created by Rasmus Kildevæld on 20/01/14.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FASearchViewViewController : UIViewController <UISearchBarDelegate> {
    
    CGRect originalFrame;
    UISearchBar *_originalSearchBar;
    UIViewController *_originalContentsController;
}

@property (nonatomic, weak) id<UISearchBarDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
- (id)initWithSearchBar:(UISearchBar *)sb contentsController:(UIViewController *)viewController;

- (void)close:(void (^)(void))complete;

- (void)show:(void (^)(void))complete;

@end
