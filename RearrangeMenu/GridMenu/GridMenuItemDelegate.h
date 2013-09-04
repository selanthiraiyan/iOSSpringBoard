//
//  GridMenuItemDelegate.h
//  RearrangeMenu
//
//  Created by Sharma Elanthiraiyan on 9/4/13.
//  Copyright (c) 2013 Sharma Elanthiraiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GridMenuItemDelegate <NSObject>

- (void)longPressedGridMenuItem:(GridMenuItem*)menuItem;
- (void)gridMenuItem:(GridMenuItem *)menuItem movedToLocation:(CGPoint)location;

@end
