//
//  NSString+FetchedGroupByString.h
//  LiveJazz
//
//  Created by Rasmus Kildevæld on 1/3/13.
//  Copyright (c) 2013 Rasmus Kildevæld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FetchedGroupByString)
/* Return the initial character of the string as uppercase */
- (NSString *)stringGroupByFirstInitial;
@end
