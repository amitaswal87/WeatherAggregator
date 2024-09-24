# WeatherAggregator
# Weather App with Multithreading and Core Data
Objective
The goal of this project is to create an iOS app that fetches weather data for multiple cities in parallel, stores it in Core Data, and uses multithreading to ensure efficient and thread-safe data management. The app displays the weather information in a list, and users can refresh the data, search for specific cities, and sort by city name or temperature.

Features
API Integration:

Fetches weather data for at least 5 predefined cities in parallel.
Uses multithreading techniques such as DispatchGroup and OperationQueue to ensure efficient API handling.
Core Data Integration:

Stores weather data in Core Data using two contexts:
A main context for fetching and displaying data in the UI.
A private context for background data insertion, ensuring thread safety.
Changes made in the private context are propagated to the main context.
User Interface:

A list of cities with their weather data is displayed using SwiftUI.
Users can pull to refresh the list to re-fetch and update the weather information.
A search bar allows users to filter cities by name.
Sorting functionality allows users to sort the cities by name or temperature.
Synchronization:

Ensures that all API requests for weather data are processed concurrently and that data is saved only after all requests are completed.
Uses DispatchGroup to synchronize the parallel requests.
Bonus Features:

Error handling for failed API requests.
Sorting options (city name, temperature).
Search functionality integrated into the SwiftUI interface.
Tech Stack
Swift: Core language for the iOS app.
SwiftUI: Used for the user interface and UI-related logic.
Core Data: Used for data persistence.
Combine: For reactive programming and state management in SwiftUI.
URLSession: For making network requests to fetch weather data.
Multithreading:
DispatchGroup: For synchronizing concurrent API requests.
OperationQueue: For managing API calls in parallel.
Core Data's Main and Private Contexts: Ensuring thread-safe data insertion and UI rendering.
