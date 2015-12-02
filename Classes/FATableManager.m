//
//  FATableManager.m
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 18/01/14.
//  Copyright (c) 2014 Rasmus Kildevaeld. All rights reserved.
//

#import "FATableManager.h"
#import <objc/runtime.h>

#import "FACoreDataDataSource.h"
#import "FATableViewArrayDataSource.h"

@implementation FATableManager

@synthesize dataSource = _dataSource;
@synthesize delegate = _tableViewDelegate;

+ (instancetype)managerWithTableView:(UITableView *)tableView {
    return [self managerWithTableView:tableView andType:FATableManagerDynamicType];
}

+ (instancetype)managerWithTableView:(UITableView *)tableView andType:(FATableManagerType)type {
    FATableManager *manager = [[FATableManager alloc] initWithTableView:tableView];
    manager.type = type;
    return manager;
}

- (id)initWithTableView:(UITableView *)tableView {
    if ((self = [self init])) {
        _tableView = tableView;
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        _cells = [NSMutableDictionary new];
        _sections = [NSMutableDictionary new];
        _messages  = [NSMutableDictionary new];
    }
    return self;
}

- (void)reloadData {
    if (_dataSource) {
        [_dataSource performFetch:nil];
    }
    if (_dataSource == nil || [_dataSource fetchedObjects].count == 0) {
        //self.tableView.scrollEnabled = NO;
        [self showMessageForState:FATableManagerNoResultsMessage];
    } else {
        
        [self hideMessage];
    }
    
}

#pragma mark - Setters
- (void)setType:(FATableManagerType)type {
    _type = type;
    
    id<FATableViewDataSourceProtocol> tmpDS;
    id<FATableViewDelegateProtocol, UITableViewDelegate> tmpD;
    
    switch (type) {
        case FATableManagerCoreDataType:
            tmpDS = [[FACoreDataDataSource alloc] initWithTableView:_tableView];
            tmpD = [[FATableViewDelegate alloc] initWithDataSource:tmpDS];
            break;
            
        case FATableManagerArrayType:
            tmpDS = [[FATableViewArrayDataSource alloc] initWithTableView:_tableView];
            tmpD = [[FATableViewDynamicDelegate alloc] initWithDataSource:tmpDS];
            break;
        case FATableManagerDynamicType:
            tmpDS = [[FATableViewDynamicDataSource alloc] initWithTableView:_tableView];
            tmpD = [[FATableViewDynamicDelegate alloc] initWithDataSource:tmpDS];
            break;
    }
    
    self.dataSource = tmpDS;
    self.delegate = tmpD;

}

- (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)identifier {
    _sections[identifier] = nib;
    if (self.tableView) {
        [self.tableView registerNib:nib forHeaderFooterViewReuseIdentifier:identifier];
    }
}

- (void)registerClass:(Class)klass forHeaderFooterViewReuseIdentifier:(NSString *)identifier {
    _sections[identifier] = klass;
    if (self.tableView) {
        [self.tableView registerClass:klass forHeaderFooterViewReuseIdentifier:identifier];
    }
}

- (void)setMessage:(id)message forState:(FATableManagerMessageType)messageType {
    _messages[@(messageType)] = message;
}

- (void)showMessageForState:(FATableManagerMessageType)messageState {
    [self showMessage:_messages[@(messageState)]];
}

- (void)showMessage:(id)str {
    if (str == nil)
        return;
//    CGRect bounds = self.tableView.bounds;
//    //bounds.origin = self.tableView.contentOffset;
//    self.messageView.frame = bounds;
//    
//    self.messageView.userInteractionEnabled = NO;
//    if ([str isKindOfClass:NSAttributedString.class]) {
//        self.messageView.textLabel.attributedText = str;
//        
//    } else if ([str isKindOfClass:NSString.class]) {
//        self.messageView.message = str;
//    }
//    [self.tableView addSubview:self.messageView];
    //self.tableView.scrollEnabled = NO;
}

- (void)hideMessage {
    if (self.messageView && self.messageView.superview) {
        [self.messageView removeFromSuperview];
    }
    //self.tableView.scrollEnabled = YES;
}

#pragma mark - Configure
- (void)configureDataSource:(void (^)(id<FATableViewDataSourceProtocol> __weak d))block {
    if (_dataSource) {
        typeof(&*_dataSource) __weak ds = _dataSource;
        block(ds);
    }
}

- (void)configureDelegate:(void (^)(id<FATableViewDelegateProtocol> __weak delegate))block {
    if (_tableViewDelegate) {
        id<FATableViewDelegateProtocol> __weak d = _tableViewDelegate;
        block(d);
    }
}

#pragma mark - Subscripting
- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (![(id)key isKindOfClass:NSString.class]) {
        return;
    }
    if (class_isMetaClass(object_getClass(obj))) {
        // it's a 'Class' type
        [self.tableView registerClass:obj forCellReuseIdentifier:(NSString *)key];
    } else {
        if ([obj isKindOfClass:NSString.class]) {
            [self.tableView registerNib:[UINib nibWithNibName:obj bundle:nil] forCellReuseIdentifier:(NSString*)key];
        }
    }
    _cells[key] = obj;
}

- (id)objectForKeyedSubscript:(id)key {
    return _cells[key];
}

- (void)setTableView:(UITableView *)tableView {
    if (_tableView) {
        _tableView.dataSource = nil;
        [_tableView reloadData];
    }
    _tableView = tableView;
    
    for (id cell in _cells.allKeys) {
        [self setObject:_cells[cell] forKeyedSubscript:cell];
    }
    
    for (NSString *section in _sections.allKeys) {
        id value = _sections[section];
        if (class_isMetaClass(object_getClass(value))) {
            // it's a 'Class' type
            [self.tableView registerClass:value forHeaderFooterViewReuseIdentifier:section];
        } else {
            
            [self.tableView registerNib:value forHeaderFooterViewReuseIdentifier:section];
            
        }
    }
    _tableView.delegate = _tableViewDelegate;
    
    if (_dataSource) {
        _tableView.dataSource = _dataSource;
        [(NSObject *)_dataSource setValue:tableView forKey:@"_tableView"];
    }
    
}

#pragma mark - Getters
- (FATableManagerMessageView *)messageView {
    if (!_messageView) {
        _messageView = [[FATableManagerMessageView alloc] initWithFrame:self.tableView.bounds];
        _messageView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    }
    return _messageView;
}

#pragma mark - TableView Delegate

- (void)setDelegate:(id<FATableViewDelegateProtocol>)delegate {
    if (delegate) {
        [delegate setDataSource:_dataSource];
    }
    self.tableView.delegate = delegate;
    _tableViewDelegate = delegate;
    
}

- (void)setDataSource:(id<FATableViewDataSourceProtocol>)dataSource {
    if (_dataSource) {
        if ([_dataSource isKindOfClass:FACoreDataDataSource.class]) {
            self.tableView.dataSource = _dataSource;
            
            [self.tableView beginUpdates];
            
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [(FACoreDataDataSource *)_dataSource fetchedResultsController].sections.count)] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        } else {
            [(FATableViewArrayDataSource *)_dataSource clear];
        }

    }
    
    
    if (_tableViewDelegate) {
        [_tableViewDelegate setDataSource:dataSource];
    }
    
    if (dataSource) {
        [dataSource setTableView:self.tableView];
    }
    
    _dataSource = dataSource;
    self.tableView.dataSource = dataSource;
    
}

@end
