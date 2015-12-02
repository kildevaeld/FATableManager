//
//  FADetailViewController.h
//  FATableViewManager
//
//  Created by Rasmus Kildevæld on 10/06/14.
//  Copyright (c) 2014 Rasmus Kildevæld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FADetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
