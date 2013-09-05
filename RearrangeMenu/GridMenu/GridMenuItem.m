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

#define NUMBER_OF_MENU_ITEMS_PER_ROW 3
#define WIDTH 80
#define HEIGHT 80

@interface GridMenuItem ()

@property (readwrite) int indexOfRow;
@property (readwrite) int indexOfPositionInRow;
@property (retain) CATextLayer *titleLabel;

@end

@implementation GridMenuItem
@synthesize index, indexOfPositionInRow, indexOfRow, title;

- (id)initWithIndex:(int)index1
{
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    if (self) {
        
        self.titleLabel = [CATextLayer layer];
        self.titleLabel.alignmentMode = @"center";
        self.titleLabel.bounds = CGRectMake(0.0, 0.0, 25.0, self.bounds.size.height / 2.0 - 10.0);
        self.titleLabel.fontSize = 11.0f;
        self.titleLabel.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        [self.layer addSublayer:self.titleLabel];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(handleLongPress)];
        longPress.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
        [self addGestureRecognizer:tap];
        
        self.index = index1;
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
    self.titleLabel.string = title;
}

- (void)setIndex:(int)index1 {
    index = index1;
    self.indexOfPositionInRow = self.index % NUMBER_OF_MENU_ITEMS_PER_ROW;
    self.indexOfRow = round(self.index /NUMBER_OF_MENU_ITEMS_PER_ROW);

    [self recalculateFrame];
    [self.delegate gridMenuItemRepositioned:self];
}

- (void)recalculateFrame {
    
    CGFloat remainingX = 320 - (WIDTH * NUMBER_OF_MENU_ITEMS_PER_ROW);
    int numberOfGaps = NUMBER_OF_MENU_ITEMS_PER_ROW + 1;
    CGFloat paddingX = remainingX/numberOfGaps;
    CGFloat paddingY = 15;
    
    CGRect frame = CGRectMake(WIDTH * self.indexOfPositionInRow + paddingX * (self.indexOfPositionInRow + 1), HEIGHT * self.indexOfRow + paddingY * (self.indexOfRow + 1), WIDTH, HEIGHT);
    
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
		CGPoint location = [touch locationInView:self.superview];
		self.center = location;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(fireLocationChangedDelegate:)
                   withObject:touch
                   afterDelay:.5];
		return;
	}
}

- (void)fireLocationChangedDelegate:(UITouch*)touch {
    CGPoint location = [touch locationInView:self.superview];
    [self.delegate gridMenuItem:self draggedToLocation:location];

}
@end
