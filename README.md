#  Kwan - Mindera Challenge

## About

I'm Marcos Felipe.
This project is for my test for Kwan and Mindera. 😎

## What am I using in it ?
Swift 4.2 and Xcode Version 10.2.1 (10E1001). 🛠

## Initing the project 📱💻☕️

//install the cocoapods

    pod init 
    pod install

Attention : Cocoapods there are some bugs in build of project with
Command CompileSwift failed with a nonzero exit code in Xcode 10 [duplicate]
If this happend run this :

    pod install --repo-update


## UnitTest - managers and viewControllers.states
![alt text](/unitTest.png)

## Coverage 80% up
![alt_text](/coverageUnitTest.png)


## Architecture:

### Supporting File contains :
• xcconfig files are environment config
• Assets
• Info.plist

### Helpers 
There are some utils.

### Controller
There are controller and its respective views.
Controller are present logic and prepare views for showing UI. 
Controller has a state , State is the handle of Controller in that moment.


### Model 
Model is an antity or domain of business. 
Model has its types of Request, Response e View.
Request for request in API.
Response for get Response from API.
View for ViewController.

### Manager 
Manager has a business logic, manager is the class for unit test. 
Manager change the model for view , request, response and others actions or business rules.
Manager is responsible for change the models and build the model flow (Model for View or for Request and Response).

### Service 
Service does connection with API (webapp).
 



