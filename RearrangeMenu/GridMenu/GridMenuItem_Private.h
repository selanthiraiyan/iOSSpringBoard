//
//  GridMenuItem_Private.h
//  RearrangeMenu
//
//  Created by Sharma Elanthiraiyan on 9/2/13.
//  Copyright (c) 2013 Sharma Elanthiraiyan. All rights reserved.
//

#import "GridMenuItem.h"
#import "GridMenuItemDelegate.h"
@interface GridMenuItem ()

@property (weak) id<GridMenuItemDelegate> delegate;
@property (nonatomic, readwrite) int index;
@property BOOL canBeMovedOnTouch;
@property BOOL isBeingRepositioned;;
- (void)startJiggling;
- (void)stopJiggling;

@end
