//
//  ViewController.h
//  IosProject
//
//  Created by Rully Winata on 18/10/24.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

