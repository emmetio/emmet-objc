//
//  EMUpdates.m
//  Emmet
//
//  Created by Sergey Chikuyonok on 2/21/13.
//  Copyright (c) 2013 Аймобилко. All rights reserved.
//

#import "EMUpdates.h"

@implementation EMUpdates

- (BOOL)canPerformActionWithContext:(id)context {
	return YES;
}

- (BOOL)performActionWithContext:(NSObject *)context error:(NSError **)outError {
	if (updater == nil) {
		NSBundle *bundle = [NSBundle bundleWithIdentifier:@"io.emmet.EspressoPlugin"];
		updater = [SUUpdater updaterForBundle:bundle];
		[updater setAutomaticallyChecksForUpdates:NO];
		[updater resetUpdateCycle];
	}
	
	[updater checkForUpdates:context];
	return YES;
}


@end
