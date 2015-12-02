//
//  FATableViewCell.h
//  LiveJazz iPad
//
//  Created by Rasmus Kildevæld on 5/25/13.
//  Copyright (c) 2013 Rasmus Kildevæld. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FATableViewCellProtocol <NSObject>

- (void)arrange;

- (void)arrangeWithData:(id)data;

@end
