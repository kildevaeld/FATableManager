//
//  FATableManager.h
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 18/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FATableViewDynamicDelegate.h"
#import "FACoreDataDataSource.h"
#import "FATableViewArrayDataSource.h"
#import "FATableManagerMessageView.h"

typedef NS_ENUM(NSUInteger, FATableManagerType) {
    FATableManagerCoreDataType,
    FATableManagerArrayType,
    FATableManagerDynamicType
};

typedef NS_ENUM(NSUInteger, FATableManagerMessageType) {
    FATableManagerNoResultsMessage,
    FATableManagerUpdateMessage,
};

@interface FATableManager : NSObject <UITableViewDelegate> {
    id<FATableViewDataSourceProtocol> _dataSource;
    id<FATableViewDelegateProtocol> _tableViewDelegate;
    NSMutableDictionary *_cells;
    NSMutableDictionary *_sections;
    NSMutableDictionary *_messages;
}

@property (nonatomic) FATableManagerType type;
@property (nonatomic, strong) FATableManagerMessageView *messageView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, readonly) id<FATableViewDataSourceProtocol> dataSource;
@property (nonatomic, readonly) id<FATableViewDelegateProtocol> delegate;

+ (instancetype)managerWithTableView:(UITableView *)tableView;

+ (instancetype)managerWithTableView:(UITableView *)tableView andType:(FATableManagerType)type;

- (id)initWithTableView:(UITableView *)tableView;

- (void)configureDataSource:(void (^)(id<FATableViewDataSourceProtocol> __weak dataSource))block;

- (void)configureDelegate:(void (^)(id<FATableViewDelegateProtocol> __weak delegate))block;

- (void)reloadData;

- (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)identifier;

- (void)registerClass:(Class)klass forHeaderFooterViewReuseIdentifier:(NSString *)identifier;

- (void)setMessage:(id)message forState:(FATableManagerMessageType)messageType;

/// @name Subscripting
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;

- (id)objectForKeyedSubscript:(id)key;

- (void)showMessageForState:(FATableManagerMessageType)messageState;

- (void)showMessage:(id)str;

- (void)hideMessage;

@end
