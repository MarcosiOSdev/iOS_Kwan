#  Kwan Challenge

## About

I'm Marcos Felipe.
This project is for my test for Kwan. 

## UnitTest - managers and viewControllers UI states
![alt text](/unitTest.png)

## Coverage 80% up
![alt_text](/coverageUnitTest.png)


## Start the project

//install the cocoapods
    
    pod init 
    pod install

Attention : Cocoapods there are some bugs in build of project with
Command CompileSwift failed with a nonzero exit code in Xcode 10 [duplicate]
If this happend run this :
    
    pod install --repo-update

## Architecture:

### Supporting File contains :
• xcconfig files are environment config
• Assets
• Info.plist

### Helpers 
There are some utils.

### Controller
There are controller and its respective views.
Controller are present logic and prepare views for showing UI


### Model 
Model is an antity or domain of business. 
Model has its types of Request, Response, View e others.

### Manager 
Manager has a business logic, manager is the class for unit test. 
Manager change the model for view , request, response and others actions or business rules.

### Service 
Service does connection with API (webapp)
 



