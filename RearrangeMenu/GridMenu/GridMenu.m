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
@synthesize isEditingModeOn, numberOfPages, currentPage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createViews];
        self.numberOfPages = 1;
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
    if (self.isEditingModeOn) {
        return;
    }
    
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
    if ((currentPage1 < 0) || (currentPage1 >= self.numberOfPages)) {
//        [NSException raise:@"Invalid current page." format:[NSString stringWithFormat:@"Failed to set current page as %d", currentPage1]];
        return;
    }
    currentPage = currentPage1;
    CGPoint newOffset = CGPointMake(currentPage * self.scrollView.bounds.size.width, 0);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages1
{
    numberOfPages = numberOfPages1;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * numberOfPages, self.scrollView.bounds.size.height);
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
    
    CGFloat minOffsetFromRightNeededToMoveToNextPage = 10.0f;
    CGFloat actualOffsetFromRight;
    
    CGFloat xPositionOfMovedItem = movedMenuItem.center.x;
    if (xPositionOfMovedItem < self.scrollView.bounds.size.width) {
        actualOffsetFromRight = self.scrollView.bounds.size.width - xPositionOfMovedItem;
    }
    else {
        actualOffsetFromRight = fmodf(xPositionOfMovedItem, self.scrollView.bounds.size.width);
    }
    
//    NSLog(@"minOff %f actualOff %f", minOffsetFromRightNeededToMoveToNextPage, actualOffsetFromRight);
    
    int newIndex = [self getNewIndexForDraggedMenuItem:movedMenuItem];

    if (newIndex == -1) { //-1 means that there are no menu items intersecting the menu item that is being dragged
        return;
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

#pragma mark Helper methods
- (int)getNewIndexForDraggedMenuItem:(GridMenuItem*)movedMenuItem
{
    int newIndex = -1;
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
    return newIndex;
}
@end
