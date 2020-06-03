
#import <Cocoa/Cocoa.h>


@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

- (IBAction)touchCreateFile:(id)sender;
@property (weak) IBOutlet NSTextField *textClass;
@property (weak) IBOutlet NSTextField *tfSuperClass;

@property (weak) IBOutlet NSScrollView *scrollView;

@property (retain) NSTextView *textView;

@property (assign) int tag;

@property (assign) BOOL isHasBtn;

@end
