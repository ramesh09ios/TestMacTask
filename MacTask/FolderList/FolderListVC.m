//
//  FolderListVC.m
//  MacTask
//
//  Created by Ramesh Pedapati on 11/01/22.
//

#import "FolderListVC.h"
#import "FoderListTableView.h"
#import "ViewController.h"

@interface FolderListVC ()<NSSearchFieldDelegate>
{
    int selectedRow;
    NSMutableArray*filesArr;
}

@end

@implementation FolderListVC

@synthesize directoryURL,progressLoader,fileList;

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    CGRect rect = CGRectMake(0, 0, 600, 800);
    self.view.window.minSize = NSSizeFromCGSize(CGSizeMake(600, 800));
    fileList = [[NSMutableArray alloc] init];
    filesArr = [[NSMutableArray alloc] init];
   
//    selectedurl = [[NSURL alloc] init];
    if (directoryURL.absoluteString.length > 0){
        [progressLoader startAnimation:nil];
        NSError*error = nil;
        unsigned long long allocatedSize;
        //[self searchAllDireactories];
        [self nr_getAllocatedSize:&allocatedSize ofDirectoryAtURL:self.directoryURL error:&error];
    }
    [self updateTableView];
//    [_folderListTableView registerNib:[[NSNib alloc]initWithNibNamed:@"" bundle:nil] forIdentifier:<#(nonnull NSUserInterfaceItemIdentifier)#>];
    // Do view setup here.
}

-(void)updateTableView{
    [_folderListTableView setAction:@selector(tableCellSelectAction)];

    NSMenu* menu = [[NSMenu alloc] init];
    [menu addItemWithTitle:@"Edit" action:@selector(tableViewEditItemClicked:) keyEquivalent:@""];
    [menu addItemWithTitle:@"Delete" action:@selector(tableViewDeleteItemClicked) keyEquivalent:@""];
    [menu addItemWithTitle:@"Copy" action:@selector(tableViewCopyItemClicked) keyEquivalent:@""];
    [_folderListTableView setMenu:menu];
}


/*
-(void)searchAllDireactories{
   

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        [self nr_getAllocatedSize:allocatedSize ofDirectoryAtURL:self.directoryURL error:error];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            //Run UI Updates
            [progressLoader stopAnimation:nil];
            [progressLoader setHidden:YES];
            [self.folderListTableView reloadData];
        });
    });
}*/

- (IBAction)folderOpenAndCloseAction:(id)sender {
    if ([sender tag] == 1){
        //Open
        FoderListTableView*selectedCellData = [self->filesArr objectAtIndex:selectedRow];
        [[NSWorkspace sharedWorkspace] openURL:selectedCellData.fileURL];
    }else{
        //Close
        [self moveToViewController];
    }
}
-(void)tableCellSelectAction{
    NSLog(@"%d",_folderListTableView.clickedRow);
    selectedRow = _folderListTableView.clickedRow;
    _openBtn.enabled = YES;
}

- (IBAction)reuseAction:(id)sender {
    
}

-(void)moveToViewController{
    ViewController* vc = [[self storyboard] instantiateControllerWithIdentifier:@"ViewController"];
//    subFolder.directoryURL = folderPath;
    [[[self view] window] setContentViewController:vc];
}

//MARK:-TableView Delegate
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return  [filesArr count];
}


- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSString*table_identifier = [tableView identifier];
    NSTextField* textField = [tableView makeViewWithIdentifier:table_identifier owner:self];
    if (textField == nil){
        textField = [[NSTextField alloc] initWithFrame:NSZeroRect];
        [textField setBordered:NO];
        [textField setEditable:NO];
        [textField setDrawsBackground:NO];
        textField.identifier = table_identifier;
    }
    
    NSString*column_identifier = [tableColumn identifier];
    FoderListTableView* file = [filesArr objectAtIndex:row];
    if ([column_identifier isEqualToString:@"Name"]){
        textField.stringValue = file.name;
    }else if ([column_identifier isEqualToString:@"Size"]){
        textField.stringValue = file.size;
    }else if ([column_identifier isEqualToString:@"Type"]){
        textField.stringValue = file.type;
    }
    return  textField;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    
}

//MEnu options
-(void)tableViewEditItemClicked{
    if (_folderListTableView.clickedRow >= 0){
        FoderListTableView*file = [filesArr objectAtIndex:_folderListTableView.clickedRow];
    }
}
-(void)tableViewDeleteItemClicked{
    if (_folderListTableView.clickedRow >= 0){
        FoderListTableView*file = [filesArr objectAtIndex:_folderListTableView.clickedRow];
    }
}
-(void)tableViewCopyItemClicked{
    if (_folderListTableView.clickedRow >= 0){
        FoderListTableView*file = [filesArr objectAtIndex:_folderListTableView.clickedRow];
        NSLog(@"Copy Path: %@",file.fileURL);
    }
}

- (BOOL)nr_getAllocatedSize:(unsigned long long *)size ofDirectoryAtURL:(NSURL *)directoryURL error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(size != NULL);
    NSParameterAssert(directoryURL != nil);

    // We'll sum up content size here:
    unsigned long long accumulatedSize = 0;

    // prefetching some properties during traversal will speed up things a bit.
    NSArray *prefetchedProperties = @[
        NSURLIsRegularFileKey,
        NSURLFileAllocatedSizeKey,
        NSURLTotalFileAllocatedSizeKey,
    ];

    // The error handler simply signals errors to outside code.
    __block BOOL errorDidOccur = NO;
    BOOL (^errorHandler)(NSURL *, NSError *) = ^(NSURL *url, NSError *localError) {
        if (error != NULL)
            *error = localError;
        errorDidOccur = YES;
        return NO;
    };

    // We have to enumerate all directory contents, including subdirectories.
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:directoryURL
                                                             includingPropertiesForKeys:prefetchedProperties
                                                                                options:(NSDirectoryEnumerationOptions)0
                                                                           errorHandler:errorHandler];

    
    NSNumber* finalReturn = [NSNumber numberWithBool:YES];
    
    for (NSURL *contentItemURL in enumerator) {
        NSString*fileStr = contentItemURL.absoluteString;
        if ([fileStr isEqualToString:@".DS_Store"]){
            continue;
        }
        NSLog(@"%@",fileStr);
        FoderListTableView*fileDetails = [[FoderListTableView alloc] init];
        NSString*lastPath = fileStr.lastPathComponent;
        fileDetails.name = lastPath;
        fileDetails.fileURL = contentItemURL;
        fileDetails.type = [lastPath containsString:@"."] ? [[lastPath componentsSeparatedByString:@"."] lastObject] : @"";
        
        // Bail out on errors from the errorHandler.
        if (errorDidOccur){
            finalReturn = NO;
        break;
        }
        // Get the type of this item, making sure we only sum up sizes of regular files.
        NSNumber *isRegularFile;
        if (! [contentItemURL getResourceValue:&isRegularFile forKey:NSURLIsRegularFileKey error:error]){
            finalReturn = NO;
            break;
        }
        if (! [isRegularFile boolValue])
            continue; // Ignore anything except regular files.

        // To get the file's size we first try the most comprehensive value in terms of what the file may use on disk.
        // This includes metadata, compression (on file system level) and block size.
        NSNumber *fileSize;
        if (! [contentItemURL getResourceValue:&fileSize forKey:NSURLTotalFileAllocatedSizeKey error:error]){
            finalReturn = NO;
            break;
        }

        // In case the value is unavailable we use the fallback value (excluding meta data and compression)
        // This value should always be available.
        if (fileSize == nil) {
            if (! [contentItemURL getResourceValue:&fileSize forKey:NSURLFileAllocatedSizeKey error:error]){
                finalReturn = NO;
                break;
            }
            NSAssert(fileSize != nil, @"huh? NSURLFileAllocatedSizeKey should always return a value");
        }
        NSLog(@"%ld",[fileSize unsignedLongLongValue]);
        long sizevalue = [fileSize unsignedLongLongValue];
        NSNumber* vOut = [NSNumber numberWithDouble:sizevalue];
        NSString*size = (NSString*) [self transformedSizeValue:vOut];
        fileDetails.size = size;
        
        // We're good, add up the value.
        accumulatedSize += [fileSize unsignedLongLongValue];
        [fileList addObject:fileDetails];
    }
    filesArr = fileList.copy;
    
    
    // Bail out on errors from the errorHandler.
    if (errorDidOccur){
        finalReturn = NO;
    }
//        return finalReturn;

    // We finally got it.
    *size = accumulatedSize;
    // Start the traversal:
    [progressLoader stopAnimation:nil];
    [progressLoader setHidden:YES];
    [self.folderListTableView reloadData];
    
    return finalReturn;
}

- (id)transformedSizeValue:(id)value
{
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB",@"PB", @"EB", @"ZB", @"YB"];
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, tokens[multiplyFactor]];
}

- (IBAction)searchTextAction:(NSSearchField *)sender {
    NSLog(sender.stringValue);
    [self searchString:sender.stringValue];
}

-(void)searchString:(NSString*)searchText{
    if (searchText.length > 0){
        NSString *predString = [NSString stringWithFormat:@"(name BEGINSWITH[cd] '%@')",searchText];
        NSPredicate *pred = [NSPredicate predicateWithFormat:predString];
        filesArr = [fileList filteredArrayUsingPredicate:pred];
        _folderListTableView.reloadData;
    }else{
        filesArr = fileList;
        _folderListTableView.reloadData;
    }
    
}

//MARK:- SearchFieldDelegate
- (void)searchFieldDidEndSearching:(NSSearchField *)sender{
    [self searchString:sender.stringValue];
}

@end
