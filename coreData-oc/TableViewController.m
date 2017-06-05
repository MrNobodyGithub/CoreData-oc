//
//  TableViewController.m
//  coreData-oc
//
//  Created by jason on 17/6/5.
//  Copyright © 2017年 jason. All rights reserved.
//

#import "TableViewController.h"

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Person+CoreDataClass.h"
#import "AddPersonViewController.h"
@interface TableViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic,strong) NSFetchedResultsController * fetchCon;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1 初始化 coreData
    [self initCoreData];
    //2 设置 barButton
    [self setupBarButtonitem];
}
- (void)setupBarButtonitem{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPerson)];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}
- (void)addPerson{
    AddPersonViewController * perCon = [[AddPersonViewController alloc] init];
    [self.navigationController pushViewController:perCon animated:YES];
}
- (NSManagedObjectContext *)managerObjectContext{
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return  appdelegate.persistentContainer.viewContext;
}
- (void) initCoreData{
    NSEntityDescription * entityDes = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[self managerObjectContext]];
    
    NSSortDescriptor * sortAge = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    NSSortDescriptor * sortFN = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES];
    
    NSFetchRequest * fetchRq = [[NSFetchRequest alloc] init];
    fetchRq.entity = entityDes;
    fetchRq.sortDescriptors = @[sortAge,sortFN];
    //
    NSFetchedResultsController * fetCon = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRq managedObjectContext:[self managerObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.fetchCon = fetCon;
    self.fetchCon.delegate = self;
    
    NSError * error = nil;
    if ([self.fetchCon performFetch:&error]) {
        NSLog(@"--perfom success--");
    }
}
#pragma mark -NSFetchedResultsControllerDelegate
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}
#pragma mark UITableViewDelegate DataSource
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSEntityDescription * entity = [self.fetchCon objectAtIndexPath:indexPath];
        [[self managerObjectContext] deleteObject:(NSManagedObject *)entity];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObjectContext * context = [self managerObjectContext];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    Person * person = [self.fetchCon objectAtIndexPath:indexPath];
    request.predicate = [NSPredicate predicateWithFormat:@"age == 22",person.age];
    NSArray * arr = [context executeFetchRequest:request error:nil];
    for (Person *pp  in arr) {
        pp.firstName = @"changed";
    }
    [context save:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.fetchCon.sections.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     
    NSFetchRequest * request = [[NSFetchRequest alloc] initWithEntityName:@"Person"];
    NSArray * arr = [[self managerObjectContext] executeFetchRequest:request error:nil];
    return  arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"perCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    Person * person = [self.fetchCon objectAtIndexPath:indexPath];
    cell.textLabel.text = person.firstName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",person.age];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
