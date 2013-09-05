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
@synthesize isEditingModeOn, currentPage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createViews];
        self.currentPage = 0;
    }
    return self;
}

- (void)createViews
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollEnabled = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedOnScrollView)];
    self.scrollView.delegate = self;
    [self.scrollView addGestureRecognizer:tap];
    [self addSubview:self.scrollView];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.scrollView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.scrollView addGestureRecognizer:swipeRight];
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer*)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        self.currentPage--;
    }
    else {
        self.currentPage++;
    }
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

- (void)setCurrentPage:(NSInteger)currentPage1
{
    if ((currentPage1 < 0) || (currentPage1 >= [self.datasource numberOfPagesInGridMenu:self])) {
        //        [NSException raise:@"Invalid current page." format:[NSString stringWithFormat:@"Failed to set current page as %d", currentPage1]];
        return;
    }
    currentPage = currentPage1;
    CGPoint newOffset = CGPointMake(currentPage * self.scrollView.bounds.size.width, 0);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)reloadMenu
{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * [self.datasource numberOfPagesInGridMenu:self], self.scrollView.bounds.size.height);
    
    for (int page = 0; page < [self.datasource numberOfPagesInGridMenu:self]; page++) {
        
        for (int i = 0; i < [self.datasource numberOfMenuItemsAtPageNumber:page inGridMenu:self]; i++) {
            GridMenuItem *menuItem = [self.datasource gridMenuItemAtIndex:i atPageNumber:page inGridMenu:self];
            menuItem.delegate = self;
            [menuItem setIndex:i pageNumber:page];
            [self.scrollView addSubview:menuItem];
        }
        
    }
}
#pragma mark GridMenuItemDelegate methods
- (void)longPressedGridMenuItem:(GridMenuItem *)menuItem
{
    self.isEditingModeOn = YES;
}

- (void)gridMenuItemDraggedToLocation:(GridMenuItem *)movedMenuItem
{
    
    CGFloat minOffsetFromRightNeededToMoveToNextPage = 10.0f;
    CGFloat actualOffsetFromRight;
    
    CGFloat xPositionOfMovedItem = movedMenuItem.center.x;
    if (xPositionOfMovedItem < self.scrollView.bounds.size.width) {
        actualOffsetFromRight = self.scrollView.bounds.size.width - xPositionOfMovedItem;
    }
    else {
        actualOffsetFromRight = fmodf(xPositionOfMovedItem, self.scrollView.bounds.size.width);
    }
    
    NSLog(@"minOff %f actualOff %f", minOffsetFromRightNeededToMoveToNextPage, actualOffsetFromRight);
    
    [self repositionMenuItemInPageNumber:movedMenuItem.pageNumber menuItem:movedMenuItem];
}

- (void)gridMenuItemRepositioned:(GridMenuItem *)item
{
    [self.delegate gridMenuItemRepositioned:item];
}

- (void)gridMenuItemSelected:(GridMenuItem*)item
{
    [self.delegate gridMenuItemSelected:item];
}

- (int)numberOfMenuItemsPerRow
{
    return [self.datasource numberOfColumnsPerPageInGridMenu:self];
}

#pragma mark Helper methods

- (void)repositionMenuItemInPageNumber:(int)pageNumber menuItem:(GridMenuItem*)movedMenuItem
{
    int newIndex = [self getNewIndexForDraggedMenuItem:movedMenuItem];
    
    if (newIndex == -1) { //-1 means that there are no menu items intersecting the menu item that is being dragged
        return;
    }
    
    for (UIView *subView in [self.scrollView subviews]) {
        if ([subView isKindOfClass:[GridMenuItem class]]) {
            GridMenuItem *menuItem = ((GridMenuItem*)subView);
            
            if (movedMenuItem.pageNumber != menuItem.pageNumber) {
                continue;
            }
            
            if ((movedMenuItem.index < newIndex) && (menuItem.index > movedMenuItem.index) && (menuItem.index <= newIndex)){
                [menuItem setIndex:menuItem.index-1 pageNumber:menuItem.pageNumber];
            }
            else if ((movedMenuItem.index > newIndex) && (menuItem.index < movedMenuItem.index) && (menuItem.index >= newIndex)){
                [menuItem setIndex:menuItem.index+1 pageNumber:menuItem.pageNumber];
            }
        }
    }
    
    [movedMenuItem setIndex:newIndex pageNumber:movedMenuItem.pageNumber];
}

- (int)getNewIndexForDraggedMenuItem:(GridMenuItem*)movedMenuItem
{
    int newIndex = -1;
    for (UIView *subView in [self.scrollView subviews]) {
        if ([subView isKindOfClass:[GridMenuItem class]]) {
            GridMenuItem *menuItem = ((GridMenuItem*)subView);

            if (movedMenuItem.pageNumber != menuItem.pageNumber) {
                continue;
            }
            
            if (menuItem != movedMenuItem) {
                
                if (CGRectIntersectsRect(movedMenuItem.frame, menuItem.frame)) {
                    newIndex = menuItem.index;
                    break;
                }
            }
        }
    }
    return newIndex;
}
@end
