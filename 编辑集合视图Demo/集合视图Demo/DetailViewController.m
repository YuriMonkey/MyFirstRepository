//
//  DetailViewController.m
//  集合视图Demo
//
//  Created by zhongjunpan on 15/12/23.
//  Copyright © 2015年 zhimeng. All rights reserved.
//

#import "DetailViewController.h"
#import "Goods.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *valueField;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.valueField.text = self.value.name;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.value.name = self.valueField.text;
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
