//
//  ViewController.m
//  CustomDrawBorad
//
//  Created by hebing on 16/12/23.
//  Copyright © 2016年 hebing. All rights reserved.
//

#import "ViewController.h"
#import "CustomBorad.h"
@interface ViewController ()

@property (nonatomic ,strong) CustomBorad *drawBorad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];



    [self.view addSubview:self.drawBorad];
}

- (CustomBorad *)drawBorad
{
    if (!_drawBorad) {
        
        _drawBorad = [[CustomBorad alloc] initWithFrame:self.view.bounds];
    }
    
    return _drawBorad;
}


@end
