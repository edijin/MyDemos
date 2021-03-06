//
//  ViewController.m
//  TracerouteDemo
//
//  Created by LZephyr on 2018/2/6.
//  Copyright © 2018年 LZephyr. All rights reserved.
//

#import "ViewController.h"
#import "Traceroute.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ipAddressField;
@property (weak, nonatomic) IBOutlet UITextView *resultView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)icmpTraceroutePressed:(id)sender {
    _resultView.text = @"";
    NSString *target = _ipAddressField.text;
    
    [Traceroute startTracerouteWithHost:target
                                  queue:dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)
                           stepCallback:^(TracerouteRecord *record) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   NSString *text = [NSString stringWithFormat:@"%@%@\n", _resultView.text, record];
                                   _resultView.text = text;
                               });
                           } finish:^(NSArray<TracerouteRecord *> *results, BOOL succeed) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   NSMutableString *text = [_resultView.text mutableCopy];
                                   if (succeed) {
                                       [text appendString:@"> Traceroute成功 <"];
                                   } else {
                                       [text appendString:@"> Traceroute失败 <"];
                                   }
                                   _resultView.text = [text copy];
                               });
                           }];
}

@end
