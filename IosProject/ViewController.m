//
//  ViewController.m
//  IosProject
//
//  Created by Rully Winata on 18/10/24.
//

#import "ViewController.h"
#import "DataList.h"

@interface ViewController ()

@end

@implementation ViewController
NSMutableArray *datas;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hitAPI];
}

- (void)hitAPI {
    [self callAPI:@"https://jsonplaceholder.typicode.com/posts" res:^(NSDictionary * _Nullable json, NSError * _Nullable error) {
        NSLog(@"res %@, err %@", json, error);
        
        
        NSArray *array = [[NSMutableArray alloc] initWithArray:json];
        for(NSDictionary *dataDict in array){
            DataList *dataList = [[DataList alloc] initWithDictionary:dataDict];
            [datas addObject:dataList];
        }
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

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datas.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = datas[indexPath.row];
    return cell;
}



@end
