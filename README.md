#Commuze

##Inspiration

Many of our team members had a long commute to their respective highschools. We were unable to use this time to sleep as we were constantly worried about missing our stop. We decided to create Commuze to fix this problem and allow commuters to get the most out of their day. 

##What it does

Tracks the user’s current location relative to their inputted destination and alerts the user when they enter the waking radius of their destination. 

##How we built it

Commuze tracks the user’s current location using the Apple framework CoreLocation. The user then inputs a destination and a waking radius. Using MapKit, we create a geofence around the destination with the waking radius. When the user enters the waking radius, a push notification is sent to their phone, making a custom sound and alerting them that they are close to their destination. 

##Challenges we ran into

* Idea generation
* Testing due to location spoofing
* Having only 2 apple devices across 4 team members to work on
* Bugs with the Geofence and adjusting the map to show the pinned current location, and the inputted destination

##Accomplishments that we’re proud of

* High accurancy of our application
* Clean, seamless UI and UX
* Ease of use

##What we learned

* How to debug effectively using a variety of frameworks and Xcode
* How to work efficiently as a team with separate roles under strict time constraints
* Gained exposure towards mobile app development
* Gained experience using a variety of frameworks

##What’s next for Commuze

* Option to save destinations and routes
* Live tracker on the lock screen and in push notifications
* Siri Shortcuts
