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
- (void)gridMenuItem:(GridMenuItem *)menuItem draggedToLocation:(CGPoint)location;
- (void)gridMenuItemRepositioned:(GridMenuItem*)item;
- (void)gridMenuItemSelected:(GridMenuItem*)item;

@end
