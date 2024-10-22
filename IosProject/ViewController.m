//
//  ViewController.m
//  IosProject
//
//  Created by Rully Winata on 18/10/24.
//

#import "ViewController.h"
#import "DataList.h"
#import "DetailViewController.h"

@interface ViewController (){
    __weak IBOutlet UITextField *tfSearch;
    __weak IBOutlet UIButton *btnSearch;
    
    NSArray *filteredData;
    DataList *selectedData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    datas = [[NSMutableArray alloc] init];
    filteredData = [[NSMutableArray alloc] init];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self hitAPI];
}

- (IBAction)btnSearchOnClick:(id)sender {
    NSString *searchTitle = tfSearch.text;
    
    if (![searchTitle isEqual:@""]) {
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.title contains[cd] %@",tfSearch.text];
        self->filteredData = [self->datas filteredArrayUsingPredicate:bPredicate];
    } else {
        self->filteredData = self->datas;
    }
    
    [self.tableView reloadData];
}


- (void)hitAPI {
    [self callAPI:@"https://jsonplaceholder.typicode.com/posts" res:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
        for(NSDictionary *dataDict in json){
            DataList *dataList = [[DataList alloc] initWithDictionary:dataDict];
            [self->datas addObject:dataList];
        }
        
        self->filteredData = self->datas;
        [self.tableView reloadData];
    }];
}

- (void)callAPI:(NSString*)url res:(void (^)(NSDictionary * _Nullable json, NSError * _Nullable error))completionHandler {
    [self callAPI:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil, error);
            return;
        }
        NSError* error1;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error1];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(json, error1);
        });
    }];
}
    
- (void)callAPI:(NSString*)url completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [[defaultSession dataTaskWithRequest:urlRequest
                       completionHandler:completionHandler] resume];
}


+ (void)call:(NSString*_Nonnull)strURL
      method:(NSString*_Nullable)method
     headers:(NSDictionary*_Nullable)headers
   andParams:(NSDictionary*_Nullable)params
         res:(void (^_Nonnull)(NSDictionary * _Nullable json, NSError * _Nullable error))completionHandler {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:strURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    for (NSString *key in headers) {
        [request addValue:headers[key] forHTTPHeaderField:key];
    }
    method = method ?: @"GET";
    [request setHTTPMethod:method.uppercaseString];
    if (params) {
        NSError *error;
        NSData *body = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        [request setHTTPBody:body];
    }
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (error) {
                        completionHandler(nil, error);
                        return;
                    }
                    NSError* error1;
                    id json = [NSJSONSerialization JSONObjectWithData:data
                                                              options:kNilOptions
                                                                error:&error1];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completionHandler(json, error1);
                    });
                }] resume];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self->filteredData.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    DataList *dataList = self->filteredData[indexPath.row];

    [(UILabel *)[cell viewWithTag:1]setText:[NSString stringWithFormat:@"%ld",(long)dataList.dataId]];
    [(UILabel *)[cell viewWithTag:2]setText:dataList.title];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 80;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (datas.count > 0) {
        selectedData = self->filteredData[indexPath.row];
        [self performSegueWithIdentifier:@"segueToDetail" sender:self];
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:@"segueToDetail"]){
        DetailViewController *vc = segue.destinationViewController;
        vc.data = selectedData;
    }
}

@end
