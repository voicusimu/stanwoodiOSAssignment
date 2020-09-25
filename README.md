# stanwoodiOSAssignment

THIS IS THE UICOLLECTIONVIEW APPROACH

1.    General architecture:

        - For this challenge I chose MVP architecture, because of its simplified form over VIPER or CLEAN. 

        - If I were to add a high UnitTest coverage to this project, I would go for one of the above mentioned architectures because they conform a lot better to the Single Responsibility principle, thus allowing us to easily test all the components we need

2.    Technical choice: Use UITableView instead of UICollectionView:

        - I went ahead and implemented the requested design using a UITableView instead of a UICollectionView. The presented design has all the characteristics that UITableView was created for…to use a UICollectionView would just be over-engineering and would add absolutely no value.

        - For the sole purpose of demo I did create a branch that uses a UICollectionView for the Repositories View, but this was just as a showcase not to lose any points by not respecting the requirements 100%.

3.    Things I would work more on:

        - I would spend more time on the iPad version of the app, making the SplitViewController details screen to hide all the info labels when no repo was selected from the TableView


OVERVIEW OF THE IMPLEMENTED FEATURES:

    •    Created an app that displays the most trending repositories on GitHub that were created in the last day, last week and last month. The can select to which timeframe they want via a UISegmentedControl. 
    •    The list is displayed in a UITableView (or a UICollectionView) and it includes the following: 
        o    The username of the owner and the name of the repository (owner->login and name fields in the API response)
        o    The avatar of the owner as a small thumbnail (owner->avatar_url field). If no avatar exists, use a default "no avatar" image.
        o    The description for the repository (description field). if there is no description, add some default text to imply that.
        o    The number of stars (stargazers_count field)


Additional Features

    •    The list allows for infinite scrolling, loading more items when the user reaches near the end of the list. It also allows the user the pull up to load more after an error has occurred. 
    •    When a user taps on a cell, present a detail screen for the repository (could be full screen or modal, your choice), with all the former details and these additional ones:
        o    Language, if available (language field)
        o    Number of forks (forks field)
        o    Creation date (created_at field)
        o    a working link to the GitHub page of the repository (html_url field)
        
    •    The user is able to add a repository to their own favourite list. The favourites repositories are saved locally using RealmSwift database and are available offline. The user is able view the favourite repositories, get their details and delete them. Favourited repositories are also shown as such in the main list.

Major Bonus Points

    •    The avatar images are cached using KingFisher framework 
    •    The UI is based using a SplitViewController so it is adapted to larger screens as well (i.e. iPad or larger iPhones in landscape mode as well)
    •    Each list have search functionality.
    •    There is also a basic internet reachability feature implemented.

