//
//  ViewController.m
//  Guteabsicht
//
//  Created by Andrey Manov on 03/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

#import "ViewController.h"
#import "Guteabsicht-Swift.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel* label;

@property (nonatomic, strong) VehiclesRequest* vr;

@property (nonatomic, strong) NSArray *vehiclesList;
@property (weak, nonatomic) IBOutlet UITableView *vehiclesTable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // test swift usage from objc
    TestSwiftFile* tsf = [[TestSwiftFile alloc] init];
    NSString* str = [tsf getTestObjCStringTrhoughSwift];
    self.label.text = str;
    
    AppDelegate* ad = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NetworkLayer* nl = ad.networkLayer;
    
    void (^completion)(NSArray<Vehicle *> * _Nullable, NSError *) = ^(NSArray<Vehicle *> * _Nullable vehList, NSError * _Nullable error) {
        if(error != nil) {
            
        }
        
        self.vehiclesList = vehList;
        [self.vehiclesTable reloadData];
    };
    
    [nl requestVehicles:nil completion:completion];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.vehiclesList count];
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     static NSString* cellIdentifier = @"cellIdentifier";
     
     UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (!cell) {
         cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     }
     
     Vehicle* v = [self.vehiclesList objectAtIndex:indexPath.row];
     cell.textLabel.text = v.name;
 
     return cell;
 }


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

@end
