UserVault

A clean, responsive, and feature-rich Flutter application to search, browse, and explore users from a remote API—complete with offline caching, theme toggle, and modern UI.

FEATURES :

1] User List
  - Fetches users from DummyJSON API
  - Infinite scrolling with pagination
  - Pull-to-refresh
    
2] Real-Time Search
  - Filters users by name as you type
  - 
3] User Detail Page
  - Displays user information
  - Fetches and displays posts and todos
  - 
4] Create Post (added locally per user)

5] Offline Support
  - Caches user list using 'shared_preferences'
  - Loads from cache if offline

6] Error Handling
  - Handles API errors with retry buttons and messages
    
7] Light/Dark Theme Toggle

8] Clean, Modern UI with Material Design 3

Dependancies:
flutter_bloc: ^8.1.3
http: ^0.13.6
equatable: ^2.0.5

Users:

![image](https://github.com/user-attachments/assets/b4d254ba-73f1-4898-9499-ff15c2528be0)
Searching:

![image](https://github.com/user-attachments/assets/5e411875-0de9-470d-980f-806b8d5da28d)
Dark Theme:

![image](https://github.com/user-attachments/assets/b4dcbfcc-380c-4b05-aa01-96dedee63ee0)
User Profile : (posts and Todos)

![image](https://github.com/user-attachments/assets/1b5db289-6065-47e0-9a1e-6e0bbdb3ff7c)
button to add post:

![image](https://github.com/user-attachments/assets/f03846e4-f6a9-4e64-84bb-bcc32f55e199)
The added Post:

![image](https://github.com/user-attachments/assets/20f0aba9-540f-44f7-9ef1-7b5cf6b3b313)


API Used: 
All data is fetched from the DummyJSON API:
1] Users: https://dummyjson.com/users
2] Posts: https://dummyjson.com/posts/user/{userId}
3] Todos: https://dummyjson.com/todos/user/{userId}
4] Search: https://dummyjson.com/users/search?q={query}


Setup Instructon: 
 1] git clone https://github.com/AviShkarGadade/Assessment.git
 2] cd assessment
 3] flutter pub get 
 4] flutter run

