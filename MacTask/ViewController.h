//
//  ViewController.h
//  MacTask
//
//  Created by Ramesh Pedapati on 11/01/22.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

@property (weak) IBOutlet NSTextField *pathTextField;
@property (weak) IBOutlet NSButton *pathBtn;
@property (weak) IBOutlet NSButton *nextBtn;


- (IBAction)selectPathAction:(id)sender;
- (IBAction)nextAndCancelPathAction:(id)sender;


@end

