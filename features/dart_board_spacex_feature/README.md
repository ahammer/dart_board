# spacex_launch_repository
https://spacexdemo-d312b.web.app

SpaceX past launches API + GraphQL + Dart Board example


Some compromises were made for the sake of time. Project management pyramid is (features/speed/quality). 
In the case of this project, I don't get to compromise speed, I'm leaning towards features. 
Some notes on quality improvements at the end.


Features
- GraphQL
- Pulls 100 listings
- Listing/Details
- Mobile/Web/Desktop support
- 100% stateless widgets (in this demo/code)
- Reactive layout (landscape and portrait support)
- Pagable images
- Pretty background

Shortcuts

- Split into only 2. Ideally this would be 3. App / UI / Data. I did (App + UI) / Data for brevity.
- No paging/refresh etc. It's refresh on launch which is enough since launches don't happen every minute or day.
- No cache (If I were to add, I'd make another 2 repositories.)
  - e.g. DiskRepository and CachedRepository. CachedRepository would delegate to GraphQL and DisRepository and help hydrate the cache
- Deep linking
  - It should be possible via the platform with the Route Resolves in the platform. I might add this after.
  - (e.g. to load a details, I might do this at night because I want to support this in dart-board)


More robust architecture?

- Redux is available in dart-board and flutter, but overkill for this
- There is no reliable ID's that I can see, but time can be used.

*Notes on "Locator" in dart-board.*

You might have noticed LocatorDecoration and locateAndBuild(). This is Locator from dart-board.

The decorators allow you to create state and service objects, and the locate/locateAndBuild can be used to 
integrate them.

I used ChangeNotifiers for this for ease of implementation.

*Error Handling?*

Not really, there is some hooks for errors but I don't catch them. If I was to add, I'd put errors/exceptions into a mock service so I can build out those flows. Skipping for time though, and because API is reliable enough.

Testing/Mocks?

The data layer takes a Repository, so a mock one could be provided.
There is very little logic in the data layer, but could be tested in a widget test 
- (e.g. load app with mock, verify mock data is given to RecentLaunches object)

