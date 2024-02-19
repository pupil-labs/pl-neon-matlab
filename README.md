# Pupil Labs Neon-MATLAB/Octave integration

This integration leverages MATLAB and Octave's Python interfaces to directly run functions from the
[Pupil Labs Real-Time API](https://github.com/pupil-labs/realtime-python-api) and [Real-time Screen Gaze](https://github.com/pupil-labs/real-time-screen-gaze) Python packages.
This means you will need to have an installation of Python on your computer.
For users who are new to Python, please see [the Python setup instructions below](#python-setup).
We also depend on a function from Psychtoolbox, so let's take care of that first.

# Psychtoolbox

***Note that if you are on an Apple Silicon Mac (M1, M2, and M3), then the Psychtoolbox installation requires some extra steps. In that case, follow the [instructions below](#apple-silicon-mac).***

This package requires the installation of Psychtoolbox for accurate timestamping of events. Please see [the standard Psychtoolbox installation instructions](
http://psychtoolbox.org/download.html) and first make sure that Psychtoolbox is properly installed and functioning. You can do this after the Psychtoolbox setup has finished, by restarting MATLAB/Octave and then entering ```AssertOpenGL``` and ```KbCheck``` at the MATLAB/Octave command line. If you do not receive any error messages, then Psychtoolbox is properly installed and functioning.

## Windows, Psychtoolbox, and Octave

Note that if you want to use Octave on Windows, then you must install version 7.3 of Octave for Psychtoolbox to work correctly. Use the mirror link at the bottom of [the Windows install instructions for Octave](https://octave.org/download#ms-windows) to find a list of older binaries.

Now, you can proceed to the steps below for setting up Python.

# Python Setup

## Anaconda and miniconda Python

The Anaconda/miniconda Python suite is popular and user-friendly, but it might be difficult to get it working well with MATLAB and Octave. We have not tested this, so if you want to use Anaconda with MATLAB, you will need to consult [the MATLAB-Python documentation](https://www.mathworks.com/help/matlab/python-language.html) while following our installation instructions below. If you want to use Anaconda with Octave, then consult the [Octave-Pythonic documentation](https://gitlab.com/gnu-octave/octave-pythonic).

## MATLAB

You will need MATLAB R2019a or later, as our Python packages require Python version 3.7 or newer. Check [the MATLAB-Python compatability table](https://www.mathworks.com/support/requirements/python-compatibility.html) for more information.

We provide steps below to get the our Neon Python packages installed on each system.

In case you are not a Python user, we also provide brief instructions below for installing Python on Windows and MacOS. If you are on Linux, then you already have Python pre-installed.

Note that if you receive unexpected Python errors from MATLAB, then you are most likely using incompatible Python and MATLAB versions.

### Windows

If you are a new Python user, then it is [recommended by Mathworks](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) to install a version of Python from [python.org](https://www.python.org/).

***Installing Python from the Windows Store will not work!***

Make sure to choose a Python version that is [compatible with your MATLAB version](https://www.mathworks.com/support/requirements/python-compatibility.html). Also, make sure to select the "Add to path" option when the Python installer starts.

If you already have a version of Python that you would like to use, then check the [MATLAB documentation about configuring your system](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html).

Once Python is ready, start a terminal (Go to the Start Menu and then enter "cmd.exe"). Then, enter the following to install the necessary packages:

```
pip3 install opencv-python
pip3 install opencv-contrib-python
pip3 install pupil-labs-realtime-api
pip3 install real-time-screen-gaze
```

If you are a new Python user or you are satisified with the default Python 3 on your system, then you can close the terminal and you will need to restart MATLAB. Now, you can [start testing the Neon integration](#using-the-neon-integration). If you rather want to use a specific Python version or you use a Python version manager, like pyenv, then change the ```pip3``` commands above accordingly and make sure to consult [the MATLAB documentation](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) about how to configure everything correctly.

### Linux

If you are on Linux, then your system already provides Python and MATLAB will automatically use this version.

To install the necessary packages, you will need to open a terminal and enter the following:

```
pip3 install opencv-python
pip3 install opencv-contrib-python
pip3 install pupil-labs-realtime-api
pip3 install real-time-screen-gaze
```

If you are a new Python user or you are satisified with the default Python 3 on your system, then you can restart MATALB and [start testing the Neon integration](#using-the-neon-integration). If you rather want to use a specific Python version or you use a Python version manager, like pyenv, then change the ```pip3``` commands above accordingly and make sure to check the [MATLAB-Python documentation about configuring your system](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html).

Note that on Linux, MATLAB will not see Python packages installed by the package manager (e.g., apt on Ubuntu).

### MacOS

For MacOS, the installation steps depend on whether you have an Apple Silicon Mac (M1, M2, or M3) or an Intel Mac. You can find out by clicking the Apple Icon in the top left corner of your desktop and going to "About this Mac".

For all Macs, you will need a Python version that is [compatible with your MATLAB version](https://www.mathworks.com/support/requirements/python-compatibility.html).

Note that [Mathworks recommends](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) installing Python from [python.org](https://www.python.org/) on MacOS. If you already have Python installed from a different source on your Mac, then installing an additional version from [python.org](https://www.python.org/) will not overwrite your current installation, although it might temporarily alter your system path.

If you would rather use a Python version that you already have or you want to use a Python version manager, like pyenv, or a Homebrew version of Python on MacOS, then you will need to consult [the MATLAB documentation](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) about how to configure everything correctly.

Once Python is ready, then continue with the steps below that are appropriate for your Mac. 

#### Intel Mac

You will need to open a terminal by starting Terminal.app. Now, enter the following in the terminal to install the necessary packages:

```
pip3 install opencv-python
pip3 install opencv-contrib-python
pip3 install pupil-labs-realtime-api
pip3 install real-time-screen-gaze
```

If you have multiple copies of Python installed, then you will need to change ```pip3``` to point to the Python installation that you want to use.

On Intel Macs, after the packages have been installed, you need to start Python one time and import the packages. Do that by first entering the following in the terminal:

```
python3
```

A Python session will start. Now enter the following:

```
import cv2
import numpy
import pupil_labs.realtime_api.simple
import pupil_labs.real_time_screen_gaze.gaze_mapper
import pupil_labs.real_time_screen_gaze.marker_generator
```

It might take a moment for each of those commands to complete. You can then quit Python by entering the following:

```
exit()
```

Now, close the terminal. Then, restart MATLAB and you can [start testing the Neon integration](#using-the-neon-integration).

#### Apple Silicon Mac

The install process is different for Apple Silicon Macs because Psychtoolbox is currently built only for Intel Macs. However, it can run on Apple Silicon Macs. So, in order to use our Neon-MATLAB integration, you will need to first make sure that you have a copy of MATLAB for Intel Macs. If not, then please install that first. You can install multiple copies of MATLAB on the same computer.

When you start the install of the Intel Mac copy of MATLAB, you will be asked if you want to activate/install the [Rosetta software from Apple](https://support.apple.com/en-us/HT211861), which enables Intel-based programs to work on your Apple Silicon Mac. Click "Install" and once the Rosetta installation is complete, you can restart the MATLAB installer.

After MATLAB for Intel Macs is installed, you can then proceed [to install Psychtoolbox](http://psychtoolbox.org/download.html#Mac).

Next, make sure that a compatible copy of [Python is installed](https://www.mathworks.com/support/requirements/python-compatibility.html).

Now, you can open Terminal.app. 

***Please note that if you already have Python installed and are a numpy/OpenCV user, then the following commands could interfere with your current setup. So, if you already have/use Python, then just make sure that you use the right ```pip``` when doing the next step. Maybe consider installing a separate Python just for the Intel Mac copy of MATLAB.***

We need to install Intel-versions of the necessary Python packages. Mathworks provides details on how to do that [here](https://www.mathworks.com/matlabcentral/answers/1977529-how-to-use-python-from-matlab-on-mac-with-apple-silicon), although there is a typo in their instructions. For our Neon packages, you need to enter the following commands:

```
arch -x86_64 python3 -m pip install opencv-python
arch -x86_64 python3 -m pip install opencv-contrib-python
arch -x86_64 python3 -m pip install pupil-labs-realtime-api
arch -x86_64 python3 -m pip install real-time-screen-gaze
```

If you are a new Python user, then the commands above are sufficient and you can move to the next step. If you want to use a specific Python version, then change the ```python3``` command to point to the Python installation that you want to use with MATLAB.

Now, close the terminal. Then, restart MATLAB and you can [start testing the Neon integration](#using-the-neon-integration).


### Using the Neon integration

After you have installed Psychtoolbox, Python and the necessary Python packages, you can put the files in the [matlab folder](matlab/) of this repository somewhere on your MATLAB path.
Then, check [matlab/basic_example.m](matlab/basic_example.m) and [matlab/gaze_mapping_example.m](matlab/gaze_mapping_example.m) for examples of how to use our Neon integration.

If you are asked to allow network connections or to allow MATLAB to communicate on public/private networks, then choose "allow".

## Octave (all systems)

If you have reason to use Octave, first note the following:

- It is still in principle slower than MATLAB
- It is limited in functionality relative to MATLAB
- It is less tested

That said, it is free and open-source.

Please note that getting Octave and Psychtoolbox to work together on Apple Silicon Macs (M1, M2 and M3) is quite difficult and we have not managed to get it working. On all other systems, it works fine.

If you have need for the Octave-Neon integration, then keep in mind
that there is presently no clean and fast way to convert large numpy arrays to Octave arrays.
This means that you will not be able to inspect the eye or scene camera video frames in Octave, although you can pass them onwards to other Python functions.
Otherwise, there is feature parity with the MATLAB integration.

First, follow the Python install steps from above for your operating system, making sure to put the functions from the [octave folder](octave/) of this repository on your Octave path. Do not use the functions in the matlab folder for an Octave installation. Also, if you want to use a specific Python version or you are using a Python version manager, then you will need to consult the [Octave-Pythonic documentation for configuring your system](https://gitlab.com/gnu-octave/octave-pythonic#python-selection).

If you are on Linux, then you need to first install the development files for Octave. On Ubuntu, run the following command in the terminal:

```
sudo apt install liboctave-dev
```

Next, start Octave and install the Pythonic package from Octave Forge following [the official installation instructions](https://gitlab.com/gnu-octave/octave-pythonic#octave-pythonic-package):

```
pkg install -forge pythonic
```

Then, after you have added the files in the [octave folder](octave/) to your Octave path, you can check [octave/basic_example.m](octave/basic_example.m) and [octave/gaze_mapping_example.m](octave/gaze_mapping_example.m) for examples of how to use our Neon integration.

If you are asked to allow network connections, then choose "allow".

# Troubleshooting

- What if I get the error, ```ServerDisconnectedError: Server disconnected```?
    - Check the "Stream" section of the Neon Companion app. You will probably see "waiting for dns service". You need to either restart the app or restart the phone.
    - When you start the Neon Companion app again, it might ask you to allow permissions for Neon. Make sure to select "yes" and "always".


- Do I need to be concerned when I see the message, ```unable to create requested socket pair```?

    If working on Windows, you might briefly see this message when initiating a connection with Neon via the ```Device``` command. This message can be safely ignored. As long as you can send messages to Neon and remotely control it, then you are good to go.

- I am using Octave and got the message, ```error on received data: InvalidStateError```.

    This error is rare. Restart Octave and that should resolve the issue. If the issue persists, then also restart the Neon Companion phone.

- I repeatedly get the message, ```'no RTP received for 10 seconds: closing'```.

    This message is in principle harmless and you can continue using the Neon integration as usual. In rare cases, you might receive this message several times in a row and it could lock up MATLAB/Octave. In that case, you will need to force quit MATLAB/Octave and start them again. 


# System compatibility & tests

This integration has been tested for speed, stability, and numerical consistency on the following platforms:

| OS | Environment | Python version | Tested & works |
| -- | ----------- | -------------- | -------------- |
| Windows 11 | MATLAB R2023b | 3.10 | Yes :green_heart: |
| Windows 11 | Octave 7.3.0 with Psychtoolbox ([See above](#windows-psychtoolbox-and-octave)) | 3.10 | Yes :green_heart: |
| Windows 11 | Octave 8.1.0 and up ([See above](#windows-psychtoolbox-and-octave)) | 3.10 | :x: No. Pythonic fails to install |
| Ubuntu 20.04 LTS | MATLAB R2023b | 3.10 | Yes :green_heart: |
| Ubuntu 20.04 LTS | Octave 6.4.0 (installed from Apt repository) | 3.10 | Yes :green_heart: |
| MacOS Sonoma (14.3.1); M2 Macbook Air | MATLAB R2023b without Psychtoolbox | 3.10 | Yes :green_heart: |
| MacOS Sonoma (14.3.1); M2 Macbook Air | MATLAB R2023b (Intel version) with Psychtoolbox (Rosetta) | 3.10 | Yes :green_heart: |
| MacOS Sonoma (14.3.1); M2 Macbook Air | Octave 8.4.0 without Psychtoolbox | 3.10 | :heart: Yes, but requires Rosetta 2 installs of Homebrew, Octave, Python, and associated packages. Tested, but unstable (Pythonic needs to be re-installed after every restart of Octave). |
| MacOS Sonoma (14.3.1); M2 Macbook Air | Octave 8.4.0 with Psychtoolbox | 3.10 | :heart: Yes, but requires Rosetta 2 installs of Homebrew, Octave/Psychtoolbox, Python, and associated packages. Tested, but unstable (Pythonic needs to be re-installed after every restart of Octave). |
| MacOS Big Sur (11.6.7); Intel Macbook Pro, Late 2013 | MATLAB R2019a | 3.7 (deprecated) | Yes :green_heart: |
| MacOS Big Sur (11.6.7); Intel Macbook Pro, Late 2013 | Octave 7.1.0 with Psychtoolbox | 3.7 (deprecated) | Yes :yellow_heart: (for this configuration, the ```receive_gaze_datum``` call took 0.0074 seconds on average) |

All systems marked with a heart in the table above have passed a small stress test. For example, on the old Macbook Pro with Python 3.7 and MATLAB R2019a, the speed of the ```receive_gaze_datum``` function call was 0.0055 seconds on average (0.0038 seconds median), matching the speed of the Python packages on modern systems, as desired.
