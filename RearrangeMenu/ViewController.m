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
@property (retain) NSMutableArray *menuItemsAtPageOne;
@property (retain) NSMutableArray *menuItemsAtPageTwo;
@property (retain) NSMutableArray *menuItemsAtPageThree;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.gridMenu = [[GridMenu alloc]initWithFrame:self.view.bounds];
    self.gridMenu.delegate = self;
    self.gridMenu.datasource = self;
    [self.view addSubview:self.gridMenu];
    
    self.menuItemsAtPageOne = [[NSMutableArray alloc]init];
    self.menuItemsAtPageTwo = [[NSMutableArray alloc]init];
    self.menuItemsAtPageThree = [[NSMutableArray alloc]init];
    for (int pageNumber = 0; pageNumber <= 2; pageNumber++) {
        for (int i = 0; i < 10; i++) {
            GridMenuItem *menuItem = [[GridMenuItem alloc]init];
            menuItem.title = [NSString stringWithFormat:@"Item %d", i];
            menuItem.backgroundColor = [UIColor grayColor];
            [menuItem.layer setCornerRadius:10.0f];
            
            if (pageNumber == 0) {
                [self.menuItemsAtPageOne addObject:menuItem];
            }
            else if (pageNumber == 1) {
                [self.menuItemsAtPageTwo addObject:menuItem];
            }
            else if (pageNumber == 2) {
                [self.menuItemsAtPageThree addObject:menuItem];
            }
        }
    }
        
    [self.gridMenu reloadMenu];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GridMenuDataSource methods
- (int)numberOfPagesInGridMenu:(GridMenu*)gridMenu
{
    return 3;
}

- (int)numberOfMenuItemsAtPageNumber:(int)pageNumber inGridMenu:(GridMenu*)gridMenu
{
    if (pageNumber == 0) {
        return [self.menuItemsAtPageOne count];
    }
    else if (pageNumber == 1) {
        return [self.menuItemsAtPageTwo count];
    }
    else if (pageNumber == 2) {
        return [self.menuItemsAtPageThree count];
    }
    return nil;
}

- (int)numberOfColumnsPerPageInGridMenu:(GridMenu*)gridMenu
{
    return 3;
}

- (GridMenuItem*)gridMenuItemAtIndex:(int)index atPageNumber:(int)pageNumber inGridMenu:(GridMenu *)gridMenu
{
    if (pageNumber == 0) {  
        return [self.menuItemsAtPageOne objectAtIndex:index];
    }
    else if (pageNumber == 1) {
        return [self.menuItemsAtPageTwo objectAtIndex:index];
    }
    else if (pageNumber == 2) {
        return [self.menuItemsAtPageThree objectAtIndex:index];
    }
    return nil;
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
