//
//  AppDelegate.h
//  OMDB Search
//
//  Created by Alexey Bukhtin on 15.05.16.
//  Copyright © 2016 OMDB. All rights reserved.
//

/**
 Create a client for the the Open Movie Database (OMDb), available on http://omdbapi.com. The app must implement the following functionality:
 
 - Search movies by title
 - Present the results of the search in a list; each cell in the list must have a thumbnail image of the movie (if available) and the title
 - The user can open a detail view of the movie by tapping on a movie. The details should include a larger version of the movie poster and more details about the movie (year, cast, etc.).
 
 Some considerations about the implementation of the app:
 
 - The app can use third party libraries just for the JSON parsing process; the rest of features must be implemented using standard Foundation and UIKit components.
 - The app should be able to handle error's in connection in a user friendly way.
 - The code can be written in either Swift, Objective-C, or a combination of both. Keep in mind that both languages are used within our projects.
 - The deployment target of the app should be iOS 8.
 
 */

#import <UIKit/UIKit.h>

@interface OMAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic) UIWindow *window;

@end

