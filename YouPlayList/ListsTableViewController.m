//
//  ListsTableViewController.m
//  YouPlayList
//
//  Created by powen on 2013/11/6.
//  Copyright (c) 2013年 XP801. All rights reserved.
//

#import "ListsTableViewController.h"

@interface ListsTableViewController ()
{
    NSMutableArray *songLists;
}

@end

@implementation ListsTableViewController

#pragma mark - Added methods
- (NSMutableArray *)getListByPlaylistID:(NSString *)playlistID
{
    //NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:0];
    
    //get userID playlist from youtube
    NSString *listURL = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/playlists/%@?v=2&alt=json", playlistID];
    NSURL *url = [NSURL URLWithString:listURL];
    NSData *data = [NSData dataWithContentsOfURL:url];  //sync --> change to unsync
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //NSLog(@"%@", jsonDictionary);
    
    //NSMutableArray *entry = [[jsonDictionary objectForKey:@"feed"] objectForKey:@"entry"];
    
    
    NSMutableArray *rows = [[NSMutableArray alloc] initWithArray:[[jsonDictionary objectForKey:@"feed"] objectForKey:@"entry"]];
    
    //NSLog(@"%@", rows);
    return rows;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    songLists = [self getListByPlaylistID:[self.listDict objectForKey:@"playlistID"]];
    
    //NSLog(@"%@", songLists);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [songLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *title = [[[songLists objectAtIndex:indexPath.row] objectForKey:@"title"] objectForKey:@"$t"];
    NSString *subtitle = [[[songLists objectAtIndex:indexPath.row] objectForKey:@"eontent"] objectForKey:@"src"];
    
    //NSLog(@"%@ - %@", title, subtitle);
    cell.textLabel.text = title;
    cell.detailTextLabel.text = subtitle;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    ViewController *vc = [segue destinationViewController];
    vc.playDict = [songLists objectAtIndex:indexPath.row];
}


@end
