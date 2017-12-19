//
//  DetailViewController.m
//  ZTestAppDemo
//
//  Created by Zaki P Laliwala on 23/08/17.
//  Copyright © 2017 Zaki P Laliwala. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize tableviewDetail;
@synthesize loadData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!loadData) {
        loadData = @"";
    }
    
    arrDetail = [[NSMutableArray alloc] init];
    
    [self performSelector:@selector(fetchAllData) withObject:nil afterDelay:.1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Dropbox Methods
- (DBRestClient *)restClient
{
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

-(void)fetchAllData
{
    [self.restClient loadMetadata:loadData];
}

-(void)AddFileToDropBox:(NSString *)filePath
{
    [self.restClient uploadFile:@"demo.png" toPath:filePath withParentRev:@"" fromPath:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"png"]];
}

-(void)deleteFile:(NSString *)filePath{
    [self.restClient deletePath:filePath];
}

#pragma mark - DBRestClientDelegate Methods for Load Data
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        if (data.isDirectory) {
            [arrDetail addObject:data];
        }
    }
    [tableviewDetail reloadData];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    [tableviewDetail reloadData];
}

#pragma mark - DBRestClientDelegate Methods for Upload Data
-(void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"File uploaded successfully." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:actionOK];
    
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
    
}

-(void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:actionOK];
    
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
}

#pragma mark - DBRestClientDelegate Methods for Delete Data

- (void)restClient:(DBRestClient*)client deletedPath:(NSString *)path
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"File deleted successfully." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [tableviewDetail reloadData];
    }];
    
    
    [alertC addAction:actionOK];
    
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
    
}
- (void)restClient:(DBRestClient*)client deletePathFailedWithError:(NSError*)error
{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    [alertC addAction:actionOK];
    
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
    
}

#pragma mark - Buttons
- (IBAction)clk_uploadAtRoot:(id)sender {
    [self AddFileToDropBox:@"/"];
}

#pragma mark - UITableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrDetail count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    DBMetadata *metadata = [arrDetail objectAtIndex:indexPath.row];
    cell.textLabel.text = metadata.filename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBMetadata *metadata = [arrDetail objectAtIndex:indexPath.row];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"Demo" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *Add = [UIAlertAction actionWithTitle:@"Add File to this folder" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self AddFileToDropBox:metadata.path];
        
    }];
    
    UIAlertAction *View = [UIAlertAction actionWithTitle:@"View Folder" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        DetailViewController *detailObj = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        detailObj.loadData = metadata.path;
        [self.navigationController pushViewController:detailObj animated:YES];
        
    }];
    
    [alertC addAction:Add];
    [alertC addAction:View];
    
    [self presentViewController:alertC animated:YES completion:^{
        
    }];
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    DBMetadata *metadata = [arrDetail objectAtIndex:indexPath.row];
    [self deleteFile:metadata.path];
    [arrDetail removeObjectAtIndex:indexPath.row];
}
@end
