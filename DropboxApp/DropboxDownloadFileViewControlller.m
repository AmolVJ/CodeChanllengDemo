//
//  DropboxDownloadFileViewControlller.m
//  DropboxApp
//
//  Created by Amol Jadhav on 12/03/15.
//  Copyright (c) 2015 Amol Jadhav. All rights reserved.
//

#import "DropboxDownloadFileViewControlller.h"
#import "MBProgressHUD.h"
#import "DropboxCell.h"
#import "OpenImageViewController.h"

@interface DropboxDownloadFileViewControlller ()
@property (nonatomic, strong) OpenImageViewController *openImageViewController;
@end

@implementation DropboxDownloadFileViewControlller

@synthesize downloadTableview;
@synthesize loadData;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!loadData) {
        loadData = @"";
    }
    
    marrDownloadData = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(fetchAllDropboxData) withObject:nil afterDelay:.1];
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

-(void)fetchAllDropboxData
{
    [self.restClient loadMetadata:loadData];
}

-(void)downloadFileFromDropBox:(NSString *)filePath
{
     NSLog(@"%@",[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[filePath lastPathComponent]]);
    [self.restClient loadFile:filePath intoPath:[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[filePath lastPathComponent]]];
}

#pragma mark - DBRestClientDelegate Methods for Load Data
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    for (int i = 0; i < [metadata.contents count]; i++) {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        [marrDownloadData addObject:data];
    }
    [downloadTableview reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    [downloadTableview reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark - DBRestClientDelegate Methods for Download Data
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[destPath lastPathComponent]];
    self.openImageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OpenImageViewController"];
    self.openImageViewController.filePath = filePath;
    [self.navigationController pushViewController:self.openImageViewController animated:YES];
}

-(void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:[error localizedDescription]
                                                  delegate:nil
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil];
    [alert show];
}

#pragma mark - UITableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [marrDownloadData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DropboxCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Dropbox_Cell"];
    
    DBMetadata *metadata = [marrDownloadData objectAtIndex:indexPath.row];
    
    [cell.btnIcon setTitle:metadata.path forState:UIControlStateDisabled];
    [cell.btnIcon addTarget:self action:@selector(btnDownloadPress:) forControlEvents:UIControlEventTouchUpInside];
    
    if (metadata.isDirectory) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.btnIcon.hidden = YES;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.btnIcon.hidden = NO;
    }
    
    cell.lblTitle.text = metadata.filename;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DBMetadata *metadata = [marrDownloadData objectAtIndex:indexPath.row];
    
     if (metadata.isDirectory) {
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
         DropboxDownloadFileViewControlller *dropboxDownloadFileViewControlller = [storyboard instantiateViewControllerWithIdentifier:@"DropboxDownloadFileViewControlller"];
         dropboxDownloadFileViewControlller.loadData = metadata.path;
         [self.navigationController pushViewController:dropboxDownloadFileViewControlller animated:YES];
     }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    if ([self.downloadTableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.downloadTableview setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.downloadTableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.downloadTableview setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - Action Methods
-(void)btnDownloadPress:(id)sender
{
    UIButton *btnDownload = (UIButton *)sender;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(downloadFileFromDropBox:) withObject:[btnDownload titleForState:UIControlStateDisabled] afterDelay:.1];
}

@end