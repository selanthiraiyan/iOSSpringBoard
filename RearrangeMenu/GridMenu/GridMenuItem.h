//
//  GridMenuItem.h
//  RearrangeMenu
//
//  Created by Sharma Elanthiraiyan on 9/2/13.
//  Copyright (c) 2013 Sharma Elanthiraiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridMenuItem : UIView 

@property (retain) NSString *title;
@property (nonatomic, readonly) int index;
@property (nonatomic, readonly) int pageNumber;

@end
