//
//  FATableViewArrayDataSource.h
//  FATableViewController
//
//  Created by Rasmus Kildevaeld on 10/08/13.
//  Copyright (c) 2013 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+FetchedGroupByString.h"
#import "FAAbstractTableViewDataSource.h"
#import "FATableViewDynamicDataSource.h"

@interface FATableViewArrayDataSource : FATableViewDynamicDataSource

@property (nonatomic, strong) NSArray *data;

@end
