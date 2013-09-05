//
//  GridMenu.h
//  RearrangeMenu
//
//  Created by Sharma Elanthiraiyan on 9/2/13.
//  Copyright (c) 2013 Sharma Elanthiraiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridMenuItem.h"
#import "GridMenuItemDelegate.h"


@protocol GridMenuDataSource <NSObject>

@required
- (int)numberOfMenuItems;
- (GridMenuItem*)gridMenuItemAtIndex:(int)index;

@end


@protocol GridMenuDelegate <NSObject>

@optional
- (void)gridMenuItemSelected:(GridMenuItem*)item;
- (void)gridMenuItemRepositioned:(GridMenuItem*)item;
@end

@interface GridMenu : UIView <GridMenuItemDelegate>

@property (assign) id<GridMenuDataSource> datasource;
@property (assign) id<GridMenuDelegate> delegate;
@property(nonatomic) NSInteger numberOfPages;
@property(nonatomic) NSInteger currentPage;

- (void)reloadMenu;

@end
