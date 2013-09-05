//
//  ViewController.m
//  RearrangeMenu
//
//  Created by Sharma Elanthiraiyan on 9/2/13.
//  Copyright (c) 2013 Sharma Elanthiraiyan. All rights reserved.
//

#import "ViewController.h"
#import "GridMenuItem.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@property (retain) GridMenu *gridMenu;
@property (retain) NSMutableArray *menuItems;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.gridMenu = [[GridMenu alloc]initWithFrame:self.view.bounds];
    self.gridMenu.delegate = self;
    self.gridMenu.datasource = self;
    self.gridMenu.numberOfPages = 3;
    [self.view addSubview:self.gridMenu];
    
    self.menuItems = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        GridMenuItem *menuItem = [[GridMenuItem alloc]initWithIndex:i];
        menuItem.title = [NSString stringWithFormat:@"Item %d", i];
        menuItem.backgroundColor = [UIColor grayColor];
        [menuItem.layer setCornerRadius:10.0f];
        [self.menuItems addObject:menuItem];
    }
        
    [self.gridMenu reloadMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GridMenuDataSource methods
- (int)numberOfMenuItems
{
    return [self.menuItems count];
}

- (GridMenuItem*)gridMenuItemAtIndex:(int)index
{
    return [self.menuItems objectAtIndex:index];
}

#pragma mark GridMenuDelegate methods
- (void)gridMenuItemRepositioned:(GridMenuItem*)item
{
//    NSLog(@"Grid menu item repositioned %@", item);
}

- (void)gridMenuItemSelected:(GridMenuItem*)item
{
//    NSLog(@"Grid menu item selected %@", item);
}

@end
