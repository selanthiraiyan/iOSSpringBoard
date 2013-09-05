//
//  GridMenu.m
//  RearrangeMenu
//
//  Created by Sharma Elanthiraiyan on 9/2/13.
//  Copyright (c) 2013 Sharma Elanthiraiyan. All rights reserved.
//

#import "GridMenu.h"
#import "GridMenuItem_Private.h"


@interface GridMenu()

@property (retain) UIScrollView *scrollView;
@property BOOL isEditingModeOn;

@end

@implementation GridMenu
@synthesize isEditingModeOn;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createViews];
    }
    return self;
}

- (void)createViews
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedOnScrollView)];
    [self.scrollView addGestureRecognizer:tap];
    [self addSubview:self.scrollView];
}

- (void)tappedOnScrollView
{
    self.isEditingModeOn = NO;
}

- (void)setIsEditingModeOn:(BOOL)isEditingModeOn1
{
    isEditingModeOn = isEditingModeOn1;
    
    for (UIView *subView in [self.scrollView subviews]) {
        if ([subView isKindOfClass:[GridMenuItem class]]) {
            GridMenuItem *menuItem = ((GridMenuItem*)subView);
            if (self.isEditingModeOn) {
                [menuItem startJiggling];
                menuItem.canBeMovedOnTouch = YES;
            }
            else {
                [menuItem stopJiggling];
                menuItem.canBeMovedOnTouch = NO;
            }
        }
    }
}

- (void)reloadMenu
{
    for (int i = 0; i < [self.datasource numberOfMenuItems]; i++) {
        GridMenuItem *menuItem = [self.datasource gridMenuItemAtIndex:i];
        menuItem.delegate = self;
        [self.scrollView addSubview:menuItem];
    }
}
#pragma mark GridMenuItemDelegate methods
- (void)longPressedGridMenuItem:(GridMenuItem *)menuItem
{
    self.isEditingModeOn = YES;
}

- (void)gridMenuItem:(GridMenuItem *)movedMenuItem draggedToLocation:(CGPoint)location
{    
    int newIndex = movedMenuItem.index;
    
    for (UIView *subView in [self.scrollView subviews]) {
        if ([subView isKindOfClass:[GridMenuItem class]]) {
            GridMenuItem *menuItem = ((GridMenuItem*)subView);
            if (menuItem != movedMenuItem) {
                
                if (CGRectIntersectsRect(movedMenuItem.frame, menuItem.frame)) {
                    newIndex = menuItem.index;
                    break;
                }
            }
        }
    }
    
    for (UIView *subView in [self.scrollView subviews]) {
        if ([subView isKindOfClass:[GridMenuItem class]]) {
            GridMenuItem *menuItem = ((GridMenuItem*)subView);
            if ((movedMenuItem.index < newIndex) && (menuItem.index > movedMenuItem.index) && (menuItem.index <= newIndex)){
                menuItem.index--;
            }
            else if ((movedMenuItem.index > newIndex) && (menuItem.index < movedMenuItem.index) && (menuItem.index >= newIndex)){
                menuItem.index++;
            }
        }
    }
    movedMenuItem.index = newIndex;
}

- (void)gridMenuItemRepositioned:(GridMenuItem *)item
{
    [self.delegate gridMenuItemRepositioned:item];
}

- (void)gridMenuItemSelected:(GridMenuItem*)item
{
    [self.delegate gridMenuItemSelected:item];
}
@end
