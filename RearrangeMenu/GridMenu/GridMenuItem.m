//
//  GridMenuItem.m
//  RearrangeMenu
//
//  Created by Sharma Elanthiraiyan on 9/2/13.
//  Copyright (c) 2013 Sharma Elanthiraiyan. All rights reserved.
//

#import "GridMenuItem.h"
#import "GridMenuItem_Private.h"
#import <QuartzCore/QuartzCore.h>

#define GRID_MENU_WIDTH 320
#define WIDTH 80
#define HEIGHT 80

@interface GridMenuItem ()

@property (nonatomic, readwrite) int index;
@property (nonatomic, readwrite) int pageNumber;
@property (readwrite) int indexOfRow;
@property (readwrite) int indexOfPositionInRow;
@property (retain) CATextLayer *titleLabel;

@end

@implementation GridMenuItem
@synthesize indexOfPositionInRow, indexOfRow, title;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    if (self) {
        
        self.titleLabel = [CATextLayer layer];
        self.titleLabel.alignmentMode = @"center";
        self.titleLabel.bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height / 2.0 - 10.0);
        self.titleLabel.fontSize = 11.0f;
        self.titleLabel.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self.layer addSublayer:self.titleLabel];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                                   initWithTarget:self action:@selector(handleLongPress)];
        longPress.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        
        self.isBeingRepositioned = NO;
    }
    return self;
}

- (void)handleLongPress
{
    [self.delegate longPressedGridMenuItem:self];
}

- (void)handleTap
{
    if (self.canBeMovedOnTouch == NO) {
        [self.delegate gridMenuItemSelected:self];
    }
}

- (void)setTitle:(NSString *)title1
{
    title = title1;
    self.titleLabel.string = self.title;
}

- (void)setIndex:(int)index1 pageNumber:(int)pageNumber1
{
    self.index = index1;
    self.pageNumber = pageNumber1;
    self.indexOfPositionInRow = self.index % [self.delegate numberOfMenuItemsPerRow];
    self.indexOfRow = round(self.index /[self.delegate numberOfMenuItemsPerRow]);
    
    if (self.isBeingRepositioned == NO) {
        [self recalculateFrame];
        [self.delegate gridMenuItemRepositioned:self];
    }
}


- (void)recalculateFrame {
    
    CGFloat remainingX = GRID_MENU_WIDTH - (WIDTH * [self.delegate numberOfMenuItemsPerRow]);
    int numberOfGaps = [self.delegate numberOfMenuItemsPerRow] + 1;
    CGFloat paddingX = remainingX/numberOfGaps;
    CGFloat paddingY = 15;
    
    CGRect frame = CGRectMake(
                              (self.pageNumber * GRID_MENU_WIDTH) + (WIDTH * self.indexOfPositionInRow) + (paddingX * (self.indexOfPositionInRow + 1)),
                              (HEIGHT * self.indexOfRow) + (paddingY * (self.indexOfRow + 1)),
                              WIDTH,
                              HEIGHT);
    
    [UIView
     animateWithDuration:0.5
     animations:^{
         self.frame = frame;
     }];
}

- (void)startJiggling {
#define degreesToRadians(x) (M_PI * (x) / 180.0)
#define kAnimationRotateDeg 1.0
    NSInteger randomInt = arc4random()%500;
    float r = (randomInt/500.0)+0.5;
    
    CGAffineTransform leftWobble = CGAffineTransformMakeRotation(degreesToRadians( (kAnimationRotateDeg * -1.0) - r ));
    CGAffineTransform rightWobble = CGAffineTransformMakeRotation(degreesToRadians( kAnimationRotateDeg + r ));
    
    self.transform = leftWobble;
    
    [[self layer] setAnchorPoint:CGPointMake(0.5, 0.5)];
    
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
                     animations:^{
                         [UIView setAnimationRepeatCount:NSNotFound];
                         self.transform = rightWobble; }
                     completion:nil];
}

- (void)stopJiggling {
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformIdentity;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	
	if ([touch view] == self && self.canBeMovedOnTouch) {
        self.isBeingRepositioned = YES;
        
		CGPoint location = [touch locationInView:self.superview];
		self.center = location;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(fireLocationChangedDelegate:)
                   withObject:touch
                   afterDelay:.5];
		return;
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
	
	if ([touch view] == self && self.canBeMovedOnTouch) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        self.isBeingRepositioned = NO;
        [self setIndex:self.index pageNumber:self.pageNumber];
        return;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self && self.canBeMovedOnTouch) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
        self.isBeingRepositioned = NO;
        [self setIndex:self.index pageNumber:self.pageNumber];
        return;
    }
}

- (void)fireLocationChangedDelegate:(UITouch*)touch {
    
    [self.delegate gridMenuItemDraggedToLocation:self];
    
}
@end
