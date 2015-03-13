//
//  CreateNotesViewController.h
//  DropboxApp
//
//  Created by Amol Jadhav on 13/03/15.
//  Copyright (c) 2015 Amol Jadhav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateNotesViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) IBOutlet UITextView *createNoteTextview;
- (IBAction)createNote:(id)sender;
@end
