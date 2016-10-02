//
//  UserViewController.m
//  RagialAlarm2.0
//
//  Created by Jimmy Ko on 2016-09-22.
//  Copyright © 2016 mrjko. All rights reserved.
//

#import "UserViewController.h"
#import "DBManager.h"
#import "FMDatabase.h"

@interface UserViewController ()

@property(nonatomic, weak) IBOutlet UITextView *header;
@property(strong, nonatomic) DBManager *dbManager;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.header.delegate = self;
    
    self.header.text = [NSString stringWithFormat:@"Welcome, %@!", self.logged_in_user];
    
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
