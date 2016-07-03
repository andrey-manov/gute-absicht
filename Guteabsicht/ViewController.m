//
//  ViewController.m
//  Guteabsicht
//
//  Created by Andrey Manov on 03/07/16.
//  Copyright © 2016 Andrey Manov. All rights reserved.
//

#import "ViewController.h"
#import "Guteabsicht-Swift.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UILabel* label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    TestSwiftFile* tsf = [[TestSwiftFile alloc] init];
    
    NSString* str = [tsf getTestObjCStringTrhoughSwift];
    
    self.label.text = str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
