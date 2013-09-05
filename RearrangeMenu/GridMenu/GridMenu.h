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

@class GridMenu;

@protocol GridMenuDataSource <NSObject>

@required
- (int)numberOfMenuItemsAtPageNumber:(int)pageNumber inGridMenu:(GridMenu*)gridMenu;
- (GridMenuItem*)gridMenuItemAtIndex:(int)index atPageNumber:(int)pageNumber inGridMenu:(GridMenu*)gridMenu;
- (int)numberOfPagesInGridMenu:(GridMenu*)gridMenu;
- (int)numberOfColumnsPerPageInGridMenu:(GridMenu*)gridMenu;
@end


@protocol GridMenuDelegate <NSObject>

@optional
- (void)gridMenuItemSelected:(GridMenuItem*)item;
- (void)gridMenuItemRepositioned:(GridMenuItem*)item;
@end

@interface GridMenu : UIView <GridMenuItemDelegate, UIScrollViewDelegate>

@property (assign) id<GridMenuDataSource> datasource;
@property (assign) id<GridMenuDelegate> delegate;
@property (nonatomic) NSInteger currentPage; //0 to numberOfPages - 1

- (void)reloadMenu;

@end
