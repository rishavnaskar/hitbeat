# Hit Beat

Welcome to HitBeat, a fun learning app, which teaches you beatboxing and analyzes your progress in real time. The app uses extensive deep learning models to analyze the users' recorded audios and shows a percentage of improvement.

## Inspiration
Music comes from practice, not just books. In this pandemic era, amateur beatboxers only have plenty of youtube tutorials to learn from, but not a single one of them can analyze the users' progress over time. Something quite similar happened to one of our teammates a couple of months back where he was unable to improve since he couldn't track his progress. And That is exactly where our app comes in! And not just beatboxing, we plan to implement our app on various other domains of music, in future.

## What it does
Our app shows various beatboxing audios (Lip Roller, Siren, Clip Roller, etc.) which the user can listen to and try to cover that by recording their own audio. Once recorded, the users can choose to compare, which in turn shows the percentage of match of the users' audio with the original audio. When the users records again after some practice, they can see that their score improved. Hence, with time, the users will be able to track their improvement!

## Challenges we ran into
• Extracting the audio signal from the audio file, given its file URL  
• Comparing the audio signals based on multiples beatboxing factors using Deep Learning  
• Storing the large audio file on the server  
• Implementing the audio recorder in Flutter  
• Connecting the flutter app with the API  

## Accomplishments that we are proud of
Althought we were glad we could overcome all the challenges we faced in this project, some memorable ones are -  
• Developing our Deep Learning model for analyzing audio signals, which was one of the biggest challenge in this project  
• Integrating the audio recorded in our app needed quite a bit of research, but at the end was successful!  

## What we learned
We got to learn a lot in this project and are thankful to the organizers of the hackathon. Few memorable ones are -  
• Analyzing audio signals using Python and further hosting the same on Heroku  
• Using AWS buckets to save large audio files  
• Working together patiently and respectfully as a team  

## Whats next for
• We plan to not limit HitBeat to just beatboxing, but take this further to all other domains of music such as drums, guitar, vocals, etc. Along with that, we also plan to optimize our Deep Learning model further to get even faster and more accurate results.  
• We will be adding a Challenge Tab where Beat Boxers can challenge each other and will learn from each other. Further, this helps to strengthen our business model too.

## Built with
• Flutter and Dart  
• Django rest framework  
• Python  
• AWS  
• LibROSA  
• Figma  
• REST API  

## Installation
Simply download the app from the releases, install in your android phone and run.

## Instructions to run
Clone the repository on your local machine, and open each individual project in Android Studio to test it out.

## A quick look
Login Screen             |  Home Screen
:-------------------------:|:-------------------------:
![WhatsApp Image 2021-03-28 at 4 12 32 PM (1)](https://user-images.githubusercontent.com/59786899/112750250-2a9ac180-8fe5-11eb-8cfe-727f2fd002d2.jpeg)  |  ![WhatsApp Image 2021-03-28 at 4 12 22 PM](https://user-images.githubusercontent.com/59786899/112750365-d17f5d80-8fe5-11eb-9498-06c5bc026c26.jpeg)

Record Audio             |  Performance Evaluation
:-------------------------:|:-------------------------:
![WhatsApp Image 2021-03-28 at 4 12 31 PM](https://user-images.githubusercontent.com/59786899/112750401-0db2be00-8fe6-11eb-9612-90142e0443bd.jpeg)  |  ![WhatsApp Image 2021-03-28 at 4 12 32 PM](https://user-images.githubusercontent.com/59786899/112750393-012e6580-8fe6-11eb-8df6-5e6b31cdcf6a.jpeg)
