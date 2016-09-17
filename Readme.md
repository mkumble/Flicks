# Project 1 - Flicks

Flicks is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 15 hours spent in total

## User Stories

The following **required** functionality is completed:

- [X] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User sees loading state while waiting for the API.
- [X] User sees an error message when there is a network error.
- [X] User can pull to refresh the movie list.
- [X] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [X] Implement segmented control to switch between list view and grid view.

The following **optional** features are implemented:

- [X] Add a search bar.
- [ ] All images fade in.
- [ ] For the large poster, load the low-res image first, switch to high-res when complete.
- [ ] Customize the highlight and selection effect of the cell.
- [X] Customize the navigation bar.
- [ ] Tapping on a movie poster image shows the movie poster as full screen and zoomable.
- [X] User can tap on a button to play the movie trailer.

Additional functionality:

- [X] Add a progress bar while fetch data.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://i.giphy.com/3o7TKo5QbOArTlyxP2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Challenges:
1) Creating the collection view and grid view using the same controller was a challenge. 
2) Moving the search bar to the navigation controller was difficult using the storyboard.
3) Since most of the code went into the view controller (without using the model), it was hard to reuse code across controllers.

## License

Copyright [2016] [Mithun Kumble]

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.