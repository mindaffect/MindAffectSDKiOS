# The NoiseTagging Framework for iOS

Table of Contents:
- [What is Noise Tagging?](#what-is-noise-tagging)
- [What Does the Framework Provide?](#what-does-the-framework-provide)
- [Further Reading](#further-reading)


# What is Noise Tagging?

MindAffect's technology lets users control devices by simply looking at them. This system works as follows:
- One or multiple devices function as *Presentation devices*. Each of these devices shows one or multiple *buttons*. The goal of the system is to know to which button the user is looking, so it can press that button on behalf of the user and execute the corresponding action.
- The user wears an EEG headset. The system uses the EEG to deduce to which button the user is looking. For real? Yes for real! But we need to apply the following 'trick'…
- Each button's background color is controlled by a *noise tag*. For example a noise tag could be BWWBWBBW, which means that the button is black for a certain duration, then white for twice that duration, then black again, then white again, etcetera. As a result all buttons 'flicker'. When a user looks at a flickering button, this flickering can be found back in the EEG signal. Each button flickers in a unique way, so from the EEG we can deduce to which button the user is looking!

Noise Tagging can be used for various presentation devices, but in this document we focus on using an iPad or iPhone as the presentation device. 


# What Does the Framework Provide?

The NoiseTagging Framework for iOS makes it easy to develop iOS apps that can be controlled using noise tagging. To this end it offers the following functionality:
- Integration with other components of the MindAffect system;
- UI for letting users set everything up;
- Precise and effective flickering;
- Trial control;
- Generic UI components that work well with noise tagging;
- An in-app Developer screen with extra functionalities aimed at developers.

In upcoming Sections we discuss these in more detail. 


## System Integration

Here you find an overview of our system architecure: https://drive.google.com/open?id=1rmdK3u1Vxe78UVQbCRCWk8BVX6N4iisN

The 'Presentation' and 'Output' roles as depicted in this overview can be fulfilled by various devices. To this end a device needs to connect to the Recogniser and implement a certain communication protocol. By using this framework you do not need to worry about this: the framework provides standard UI to let your users connect their iOS device to the Recogniser and it handles all communication with the Recogniser. 


## Brain Control Layer

Before users can start controlling your app using noise tagging, they need to perform a number of steps:
1. Connect their iOS device with the Recogniser;
2. Check that the headset is fitted correctly;
3. Calibrate the system.

The NoiseTagging framework provides standard UI in which the user can perform all of these tasks, as well as inspect the status of the system. This UI consists of a number of screens, which collectively we refer to as the *Brain Control Layer*.

If the NoiseTagging framework notices problems – e.g. a connection problem with the Recogniser –, it shows a special type of alert (see Section "Generic UI Components"). If necessary, the user can go directly back into the Brain Control Layer from such an alert. 


## Flicker

For optimal recognition (that is: the best and fastest recognition of where the user is looking), it is important that:
1. Buttons get assigned noise tags such that the EEG signal resulting from looking at them is optimally discernable;
2. These noise tags are displayed as precisely as possible. 

Clients of the NoiseTagging framework only need to tell it which buttons participate in noise tagging. The framework assigns appropriate noise tags.


## Trial Control

Applications that use noise tagging generally repeat these four steps, which together make up one *trial*:
1. All buttons start to flicker.
2. The user looks at the button that she wants to press. We call this button the 'target'. Preferably the user is already looking at the target *before* the buttons start to flicker.
3. At some point the system may decide that it is certain enough about to which button the user is looking. At this point the flickering stops and the button is pressed. Optionally there is a maximum to how long this may take. If time runs out, the flickering stops but no button is pressed. Instead the user will get feedback that the system failed to recognise to which button she was looking.
4. There is a pause before the buttons start to flicker again, giving the user some time to take in the effects of the button press and to move her gaze towards the next target.

The NoiseTagging framework takes care of running trials. It starts running trials automatically once the system has been calibrated. Optionally users can also start or stop the running of trials manually by swiping up or down. 


## Design and Generic UI Components

Most iOS apps use generic UI components provided by iOS, such as UIButton, UITextField, UISlider, UIAlertController, etcetera. However, all of these rely on touch, so when designing a *noise tagging app* (an app that can be controlled using noise tagging) we need to take an alternative approach. The NoiseTagging framework provides a number of components to create UI that fits into the noise tagging paradigm. But before discussing these components, let us discuss some design aspects that determine the effectiveness of noise tagging.


### Important Design Aspects

1. **Pushes only** – iOS is based on multi-touch, which allows users to interact with stuff on the screen in a varied manner of ways. Using noise tagging we currently only have the equivalent to *single taps*. This means all controls must be made up out of simple push buttons.
2. **Button size** – The degree to which the flickering of a target is visible in the EEG signal depends on the size of that target. Buttons need to be much larger than normal for noise tagging to work. On the other hand buttons can also be *too large*; e.g. if a button fills up the whole screen seeing it flicker is uncomfortable.
3. **On top of buttons** – Most of the time buttons have titles or icons to tell the user what those buttons do. Note that in the case of noise tagging buttons there should not be *too much* on any button, because that would obscure the flickering! On the other hand *something* on top of a flickering button may actually help users keep their gaze focussed. For that reason any icon or title is best positioned in the button's center.
4. **Button spacing** – When the user looks at a flickering button, she may be distracted by nearby flickering buttons. Therefore buttons can better not be too close to each other.
5. **Size in general** – In our experience the fact that the buttons need to be big, means that *everything* should be big for the design to be well-balanced. 
6. **Number of buttons** – This one follows from the previous ones: since UI components take up much more space than normally, the number of components that can be shown at any given moment is much smaller. Combined with the fact that pressing buttons using noise tagging is significantly slower than when using touch, this has BIG implications for designing your app. The number of things you can let your users do with just one 'click' is limited, so it becomes key to choose priorities wisely; for each functionality you add you should consider how that affects the speed by which users can access the other functionalities. 


### Generic UI Components

The NoiseTagging framework provides the following components, all specifically designed to be used with noise tagging:
- **Simple button**: a button with a title or icon.
- **Labeled button**: a button consisting of two parts: one with an icon, one with a title. Depending on the settings only the part with the icon flickers. Labeled buttons are especially fit for long button titles, or to provide the user with more state information by dynamically changing the button's icon and/or title. 
- **Checkbox**: a labeled button with a state that is either ON or OFF. The button's icon and title match the button's state.
- **Popup button**: a labeled button to select one out of a number of options. The button itself shows the currently selected option. If it is pressed, a popover is shown to choose from all possible options.
- **Popover with buttons**: a popover which can be populated with simple buttons. Optionally the popover also contains a button to close the popover without pressing any of the other buttons.
- **Keyboard**: a view controller which can be used to present a keyboard and let the user edit a text using noise tagging.
- **Tree navigation**: a controller that lets you create UI that is comparable to UINavigationController. It lets users navigate through a *tree* of *pages*, where each page can provide a list of *sub pages* for the user to navigate to. At the top the title of the current page is displayed and in the top left there is a button to go back to the previous page. 
- **Alert**: a popover similar to normal system alerts, but with buttons that can be pressed using noise tagging. 


## The Developer Screen

As the name already implies, the Developer Screen is *not* aimed at end users. But it does provide some things that can be handy during the development of your app.

In order to access the Developer Screen, double-press with two fingers. For now the only part of the Developer Screen relevant to clients is the *Settings* screen. 


# Further Reading

We recommend that you make your first brain-controllable app by going through our *Quick Start*. 

After that, we recommend to read the *Main Programming Guide*, which should provide you with all the information to start developing your own great, brain-controllable iOS apps!
