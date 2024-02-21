# WeatherApplication

## About the app

The app has 5 screens: Dashboard, Favourites, Map, Search and Location detail screen.

In the Dashboard screen you can see the weather for the current location. There is also a refresh button that does the same thing: fetches the weather for the current location + any other favourite locations. It also have a favourite button which add the current weather into favourite list.

In the Search screen we have implemented the places api to search the places and once user selected the place we are navigating back to home screen and display the place.

In the Map screen user can see all the favourite location on the map and we are also showing annotation for the same.

The Map section displays a map with pins for the user's favourite locations. When you click on the favourite item, user will navigate to the weather detail screen.

The location detail screen contain the details of the location.

The app is created with UIKIT framework, which also include the Storyboard and XIB.

### Considerations

When fetching the weather information for a location, we execute 2 API calls, one for `the current weather information, one for the forecast. The forecast received from the API is for 5 days, with a 3 hour step, meaning we will get 40 entries. These entries are averaged such that we only display 5 items in the forecast section, one for each day.


### Technology

Mac OS Version - Sonoma 14.1.1
XCode - 15.0
Swift version - 5
Architecture - MVVM 
Design Patterns - Creational & Behavioural 
Protocol oriented programming 
Unit Testing (TDD Preferential)
Proper use of the SOLID principles 
Code coverage integration 
Localization implemented for static strings 
Network API client and network reachability implementation 
Alert implementation 
Location manager implementation 
Map implementation


#Online flow

- The application is completely compatible with online and offline. 
- When launching the application, If internet available then-current location weather data, and forecast data will display 
- When launching the application, If the internet available then-current location weather data and forecast data will display and if that location is already saved in the favourite then, favourite button will be selected 
- Once the data is loaded you can make it favourite and unfavourite by clicking on the star icon at the right top 
- We can see favourite list by clicking on favourite list button at right bottom 
- We can see saved location on the map by clicking on the map button at the bottom next to favourite list button


#Offline flow

- When launching the application, If the internet is not available then internet unavailable toast will display.
- When launching the application, If the internet is not available then the last favourite location weather data and forecast data will display.
- When launching the application, If the internet is not available and there is no favourite data saved then an empty screen will display with reloading, map, fav list, and favourite button 
- Favourite and unfavourite functionality will work on offline also 
- By clicking on favourite list item the user will navigate back to the dashboard and the weather and forecast data of that item will display