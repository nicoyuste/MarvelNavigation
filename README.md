

<html>
<img src="https://pulpfictioncine.com/download/multimedia.normal.a419730bf6237576.4d617276656c2d6c6f676f5f6e6f726d616c2e6a7067.jpg">
<html>

# Requirements
- ​Create an iOS application that communicates with the Public Marvel API and the following requirements:

    - See a list/collection of items from the Marvel API
    - Search or filter the contents of this list/collection
    - See the full details of any item from this list/collection


# Summary

Here you have a sample application which connects to Marvel API, downloads different resources, displays them into a List View and you can see the details of each element. As you can see in the code, the application is done in an abstract way so all the resource types are downloaded and displayed using the same tech stack.

Here you have a click graph of the application architecture:
<html>
<img src="https://github.com/nicoyuste/MarvelNavigation/raw/master/design_view.png">
<html>

There is more documention writter within the code itself.

# Third party libraries I use.

The project is configured to use Cocoapods to download the following dependencies:

- `pod 'Alamofire'` : Helps with API request. This could be done using `NSURLSession` direcly but Alamofire makes things way easier.
- `pod 'SwiftHash'` : Marvel APIs requires to send a MD5 hash. I downloaded this dependency just for that.
- `pod 'PromiseKit'` : Helps with asyncronous tasks. I use it to handle the API request code. 
- `pod 'SDWebImage'` : Helps with `UIImageView` and loading images from the network.
- `pod 'SnapKit'` : Helps setting UI Constraints by code.
- `pod 'JGProgressHUD'` : Simply loading view.
- `pod 'SwiftIcons'` : Easy way to download already created icons from different resources. 

# TODOs

- Unit Testing. There are no much unit tests at this point and we should unit tests:
   - Datasource
   - ViewController
- cellHeights implemantation is not super clean. We could have just a variable with a default value that gets overriden by each subclass
- Configuration could be moved out of the SceneDelegate into some `ConfigFactory` class.
- We could create a protocol so datasources implement it. That will be easier to create different datasources with different implementations. Example: `OfflineDatasource` loading from internal memory and `OnlineDatasource` loading things from the backend.
- `MarvelDetailsViewController`:
   - Instead of loading all the information from the MarvelListViewModel, this viewController could use the API to load the DETAIL resource.
   - UI could show more data than only title and description, at the end, you already see that on the list.
- Create icon and solve small UI issue with iPhone X