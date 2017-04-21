//
//  ViewController.m
//  LYSGuideView
//
//  Created by jk on 2017/4/21.
//  Copyright © 2017年 Goldcard. All rights reserved.
//

#import "ViewController.h"
#import "LYSGuideView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 120, CGRectGetWidth(self.view.frame), 44.f);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.userInteractionEnabled = YES;
    [btn setTitle:@"显示" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)btnClicked:(UIButton*)sender{
    LYSGuideView *view = [LYSGuideView new];
    view.maskRadius = 20.f;
    view.dismissOnTouch = NO;
    view.type = LYSGuideViewShowTypeBottom;
    LYSGuideInfoModel * model1 = [LYSGuideInfoModel new];
    model1.desc = @"我在这里，你来找我啊1";
    model1.descImage = [UIImage imageNamed:@"bill_charge_icon"];
    model1.targetPoint = CGPointMake(60, 60);
    LYSGuideInfoModel * model2 = [LYSGuideInfoModel new];
    model2.desc = @"我在这里，你来找我啊2";
    model2.descImage = [UIImage imageNamed:@"bill_charge_icon"];
    model2.targetPoint = CGPointMake(200, 80);
    LYSGuideInfoModel * model3 = [LYSGuideInfoModel new];
    model3.desc = @"我在这里，你来找我啊3";
    model3.descImage = [UIImage imageNamed:@"bill_charge_icon"];
    model3.targetPoint = CGPointMake(100, 300);
    LYSGuideInfoModel * model4 = [LYSGuideInfoModel new];
    model4.desc = @"我在这里，你来找我啊4";
    model4.descImage = [UIImage imageNamed:@"bill_charge_icon"];
    model4.targetPoint = CGPointMake(160, 260);
    LYSGuideInfoModel * model5 = [LYSGuideInfoModel new];
    model5.desc = @"我在这里，你来找我啊5";
    model5.descImage = [UIImage imageNamed:@"bill_charge_icon"];
    model5.targetPoint = CGPointMake(260, 60);
    view.items = @[model1,model2,model3,model4,model5];
    view.dismissOnTouch = YES;
    [view show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
