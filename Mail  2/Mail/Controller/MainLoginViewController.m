//
//  MainLoginViewController.m
//  AronMail
//
//  Created by Aron Ruan on 2022/7/18.
//

#import "MainLoginViewController.h"
#import "MainLoginView.h"
@import GoogleSignIn;

@interface MainLoginViewController ()

@end

@implementation MainLoginViewController
//- (instancetype)init
//{
//    self = [super init];
//    if(self)
//    {
//        _mainLoginView = [[MainLoginView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self loginViewInit];

   

}
-(void)loginViewInit
{
    _mainLoginView = [[MainLoginView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mainLoginView];
   
}



@end
