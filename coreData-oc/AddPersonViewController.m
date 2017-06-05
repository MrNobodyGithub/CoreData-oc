//
//  AddPersonViewController.m
//  coreData-oc
//
//  Created by jason on 17/6/5.
//  Copyright © 2017年 jason. All rights reserved.
//

#import "AddPersonViewController.h"
#import "Person+CoreDataClass.h"
#import "AppDelegate.h"
@interface AddPersonViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldAge;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFN;

@end

@implementation AddPersonViewController
- (IBAction)addAction:(id)sender {
    
    AppDelegate * appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    Person * per = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:appdelegate.persistentContainer.viewContext];
    if (per) {
        per.age = [self.textFieldAge.text integerValue];
        per.firstName = self.textFieldFN.text;
        NSError * errorSave = nil;
        if ([appdelegate.persistentContainer.viewContext save:&errorSave]) {
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"--save success--");
        }else{
            NSLog(@"--save fail--");
        }
        
    }else{
        NSLog(@"--create personEntity fail--");
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
