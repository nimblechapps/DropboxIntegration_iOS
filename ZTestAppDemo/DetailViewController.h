//
//  DetailViewController.h
//  ZTestAppDemo
//
//  Created by Zaki P Laliwala on 23/08/17.
//  Copyright © 2017 Zaki P Laliwala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface DetailViewController : UIViewController<DBRestClientDelegate,UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *arrDetail;
    DBRestClient *restClient;
}

@property (strong, nonatomic) IBOutlet UITableView *tableviewDetail;
@property (nonatomic, readonly) DBRestClient *restClient;
@property (nonatomic, strong) NSString *loadData;

@end
