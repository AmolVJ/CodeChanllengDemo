//
//  CreateNotesViewController.m
//  DropboxApp
//
//  Created by Amol Jadhav on 13/03/15.
//  Copyright (c) 2015 Amol Jadhav. All rights reserved.
//

#import "CreateNotesViewController.h"

@interface CreateNotesViewController ()
@property (nonatomic, strong) IBOutlet UITextView *createNoteTextview;
- (IBAction)createNote:(id)sender;
@end

@implementation CreateNotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.createNoteTextview becomeFirstResponder];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - Button methods

- (IBAction)createNote:(id)sender {
    NSError *error;
    NSString *stringToWrite = self.createNoteTextview.text;
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"note.txt"];
    [stringToWrite writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@""
                                                   message:NSLocalizedString(@"NOTE_CREATED", @"")
                                                  delegate:nil
                                         cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                         otherButtonTitles:nil];
    [alert show];

}

- (IBAction)openNote:(id)sender {
    NSError *error;
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"note.txt"];
    
   NSString *noteData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    self.createNoteTextview.text = noteData;
}

@end
