//
//  DetailViewController.m
//  IosProject
//
//  Created by Rully Winata on 22/10/24.
//

#import "DetailViewController.h"
#import "DataList.h"

@interface DetailViewController (){
    __weak IBOutlet UILabel *lblId;
    __weak IBOutlet UILabel *lblTitle;
    __weak IBOutlet UILabel *lblUserId;
    __weak IBOutlet UILabel *lblBody;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [lblId setText:[NSString stringWithFormat:@"%ld",(long)self.data.dataId]];
    [lblUserId setText:[NSString stringWithFormat:@"%ld",(long)self.data.userId]];
    [lblTitle setText:self.data.title];
    [lblBody setText:self.data.body];
}

@end
