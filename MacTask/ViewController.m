//
//  ViewController.m
//  MacTask
//
//  Created by Ramesh Pedapati on 11/01/22.
//

#import "ViewController.h"
#import "FolderListVC.h"

@interface ViewController()
{
    NSURL*folderPath;

}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    folderPath = [[NSURL alloc] init];
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


- (IBAction)nextAndCancelPathAction:(id)sender {
    if ([sender tag] == 1){
        //Cancel
        [self closeWindow];
    }else{
        //Next
        [self moveToSubFolderListWindow];
        //[self closeWindow];
    }
}

-(void)closeWindow{
    [[[NSApplication sharedApplication] mainWindow] close];
}

-(void)moveToSubFolderListWindow{
    FolderListVC* subFolder = [[self storyboard] instantiateControllerWithIdentifier:@"FolderListVC"];
    subFolder.directoryURL = folderPath;
    [[[self view] window] setContentViewController:subFolder];
}

- (IBAction)selectPathAction:(id)sender {
    
    NSOpenPanel*panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result > 0){
            self->folderPath = panel.URL;
            self.pathTextField.stringValue = self->folderPath.absoluteString;
            [self.nextBtn setEnabled:true];
        }
    }];
}

@end
