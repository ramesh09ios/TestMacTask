//
//  FolderListVC.h
//  MacTask
//
//  Created by Ramesh Pedapati on 11/01/22.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface FolderListVC : NSViewController<NSTableViewDataSource,NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *folderListTableView;
@property (weak) IBOutlet NSProgressIndicator *progressLoader;
@property (weak) IBOutlet NSButton *reuseButton;
@property (weak) IBOutlet NSSearchField *searchBar;
@property (weak) IBOutlet NSButton *openBtn;
@property (weak) IBOutlet NSButton *cancelBtn;

@property NSMutableArray* fileList;


@property (nonatomic,strong)  NSURL*directoryURL;


- (IBAction)reuseAction:(id)sender;
- (IBAction)folderOpenAndCloseAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
