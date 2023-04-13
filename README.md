# MapKit Gas Calculator

* This will take two locations and give you the distance between them
* Then it will ask you for the MPG of your car
* It will then display the approximate cost of the trip by doing (distance / national gas price average) = cost of trip
* Then it will give you the option to preview the route using MapKit and MKDirections
* Going to add an API for grabbing the gas Average price so its not just a constant value
* Also tolls toggle switch because tolls suck
* Able to open the route in apple maps with click

Components used
* MapKit framework with the class MKDirections
* SwiftUI 

References used
* https://www.hackingwithswift.com/example-code/location/how-to-find-directions-using-mkmapview-and-mkdirectionsrequest


Issues: 
* have to make sure i add the tollsPreference to map call
* There is no free API to check for gas prices in the US, for now ill just have the user enter it, i know its one more step but I dont want to pay for an API atm
* Not sure how to format the map in the view, looks too small at the bottom, may remove later
* AppleMaps not taking tollPreference upon opening, on the dev forums people said this isnt possible but the thread was old so Im not sure 
