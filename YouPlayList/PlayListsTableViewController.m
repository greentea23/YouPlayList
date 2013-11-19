//
//  PlayListsTableViewController.m
//  YouPlayList
//
//  Created by powen on 2013/11/6.
//  Copyright (c) 2013年 XP801. All rights reserved.
//

#import "PlayListsTableViewController.h"
#import "ListsTableViewController.h"

@interface PlayListsTableViewController ()
{
    NSMutableArray *playLists;
}

@end

@implementation PlayListsTableViewController

#pragma mark - Added Methods

- (NSMutableArray *)getPlayListsByID:(NSString *)userID
{
    NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:0];
    
    //get userID playlist from youtube
    NSString *listURL = [NSString stringWithFormat:@"http://gdata.youtube.com/feeds/api/users/%@/playlists?v=2&alt=json", userID];
    NSURL *url = [NSURL URLWithString:listURL];
    NSData *data = [NSData dataWithContentsOfURL:url];  //sync --> change to unsync
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    //NSLog(@"%@", jsonDictionary);

    NSMutableArray *entry = [[jsonDictionary objectForKey:@"feed"] objectForKey:@"entry"];
    
    
    for (NSDictionary *indexDict in entry)
    {
        NSString *title = [[indexDict objectForKey:@"title"] objectForKey:@"$t"];
        NSString *playlistID = [[indexDict objectForKey:@"yt$playlistId"] objectForKey:@"$t"];
        NSString *href = [[[indexDict objectForKey:@"link"] objectAtIndex:1] objectForKey:@"href"];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        title, @"title",
                        playlistID, @"playlistID",
                        href, @"href",
                        nil];
        
        //NSLog(@"%@", dict);
        
        [rows addObject:dict];
    }
    
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

    playLists =[self getPlayListsByID:@"binmusictaipei"];
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
    return [playLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [[playLists objectAtIndex:indexPath.row] objectForKey:@"title"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[playLists objectAtIndex:indexPath.row] objectForKey:@"playlistID"]];
    
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *href = [[playLists objectAtIndex:indexPath.row] objectForKey:@"href"];
    NSURL *url = [NSURL URLWithString:href];
    [[UIApplication sharedApplication] openURL:url];    //open safari 
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    ListsTableViewController *vc = [segue destinationViewController];
    vc.listDict = [playLists objectAtIndex:indexPath.row];
}


@end
