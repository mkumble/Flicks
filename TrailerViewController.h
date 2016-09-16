//
//  TrailerViewController.h
//  yahooDemo
//
//  Created by Mithun Kumble on 9/13/16.
//  Copyright © 2016 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface TrailerViewController : AVPlayerViewController
@property(nonatomic, strong) NSDictionary *movie;
@end
