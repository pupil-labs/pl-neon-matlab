# Pupil Labs Neon-Psychtoolbox integration

This integration leverages MATLAB and Octave's Python interfaces to directly run functions from the
[Pupil Labs Real-Time API](https://github.com/pupil-labs/realtime-python-api) and [Real-time Screen Gaze](https://github.com/pupil-labs/real-time-screen-gaze) Python packages.
This means you will need to have an installation of Python on your computer.
For users who are new to Python, please see [the installation and usage instructions below](#installation).

# Necessary: Psychtoolbox

This package requires the installation of Psychtoolbox for accurate timestamping of events. Please see [the standard Psychtoolbox installation instructions](
http://psychtoolbox.org/download.html) and first make sure that Psychtoolbox is properly installed and functioning. You can do this, after the Psychtoolbox setup has finished, by restarting MATLAB and then entering ```AssertOpenGL``` and ```KbCheck``` at the MATLAB command line. If you do not receive any error messages, then Psychtoolbox is properly installed and functioning.

# Anaconda and miniconda Python

The Anaconda/miniconda Python suite is popular and user-friendly, but it might be difficult to get it working well with MATLAB and Octave. We have not tested this, so if you use Anaconda, you will need to consult [the MATLAB-Python documentation](https://www.mathworks.com/help/matlab/python-language.html) while following our installation instructions below.

# Installation

## MATLAB

You will need MATLAB R2019a or later, as our Python packages require Python version 3.7 or newer. Check [the MATLAB-Python compatability table](https://www.mathworks.com/support/requirements/python-compatibility.html) for more information.

On all systems, MATLAB will connect to your system-provided Python by default and on Linux, it will not see Python packages installed by the package manager (e.g., apt on Ubuntu).
In case you are not a Python user, we provide brief instructions below for installing Python on Windows. If you are on MacOS or Linux, then you already have Python pre-installed.
We also provide steps below to get the necessary Python packages on each system.
If you do not want to use the system-provided Python, then please see [the corresponding MATLAB documentation](https://www.mathworks.com/help/matlab/python-language.html) about how to change the Python version that MATLAB uses.

Note that if you receive unexpected Python errors from MATLAB, then you are using incompatible Python and MATLAB versions.

After you have Python and the necessary Python packages, you can put the files in the [matlab folder](matlab/) of this repository somewhere on your MATLAB path.
Then, check [matlab/basic_example.m](matlab/basic_example.m) and [matlab/gaze_mapping_example.m](matlab/gaze_mapping_example.m) for examples of how to use our Neon integration.

### Windows

If you are a new or average Python user, then it is [recommended by the Python Software Foundation](https://docs.python.org/3/using/windows.html) to install a version of Python from the Windows Store. We recommend Python 3.11, as it is new enough, well tested, and properly supported by recent versions of MATLAB and Octave. You can download Python 3.11 for Windows [here](https://apps.microsoft.com/detail/9NRWMJP3717K?hl=en-us&gl=US). Ensure that it is from the "Python Software Foundation". It should be free of charge.

Once Python is installed, start a terminal (Go to the Start Menu and then enter "cmd.exe"). Then, enter the following to install the necessary packages:

```
pip3 install opencv-python
pip3 install opencv-contrib-python
pip3 install pupil-labs-realtime-api
pip3 install real-time-screen-gaze
```

### MacOS and Linux

You will need to open a terminal. On MacOS, start Terminal.app. It is assumed that if you are on Linux, then you already know how to start a terminal.

If you do not use a Python version manager, then the following is sufficient (if you don't know what a version manager is, then you are most likely not using a version manager):

```
pip3 install opencv-python
pip3 install opencv-contrib-python
pip3 install pupil-labs-realtime-api
pip3 install real-time-screen-gaze
```

On MacOS, after the packages have been installed, you need to start Python one time and import the packages. Enter the following:

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

Now, close the terminal. Then, restart MATLAB, copy the files in the [matlab folder](matlab/) to your MATLAB path, and you should be good to go.

If you use a Python version manager, like pyenv, or you use a Homebrew version of Python on MacOS, then you will need to consult [the MATLAB documentation](https://www.mathworks.com/help/matlab/python-language.html) about how to configure everything correctly.

## Octave (all systems)

If you have reason to use Octave, first note the following:

- It is still in principle slower than MATLAB
- It is limited in functionality relative to MATLAB
- It is less tested

That said, it is free and open-source.

If you have need for the Octave-Neon integration, then keep in mind
that there is presently no clean and fast way to convert large numpy arrays to Octave arrays.
This means that you will not be able to inspect the eye or scene camera video frames, although you can pass them onwards to other Python functions.
Otherwise, there is feature parity with the MATLAB integration. Just make sure you are running a relatively recent version of Octave from the last year or so ([upgrading is free and easy!](https://octave.org/)).

First, follow the same install steps as those for MATLAB for your operating system, making sure to put the functions from the [octave folder](octave/) on your Octave path. Do not use the functions in the matlab folder for an Octave installation.

If you are on Linux, then you need to install the development files for Octave. On Ubuntu, run the following command in the terminal:

```
sudo apt install liboctave-dev
```

Next, install the pythonic package from Octave Forge. Run the following command within Octave:

```
pkg install -forge pythonic
```

Then, check [octave/basic_example.m](octave/basic_example.m) and [octave/gaze_mapping_example.m](octave/gaze_mapping_example.m) for examples of how to use our Neon integration.

# System compatibility & tests

This integration has been tested on:

- Windows 11
- Ubuntu 20.04 LTS
- MacOS 11.6.7 (Macbook Pro, Late 2013)

Both the MATLAB and Octave implementations have been tested for speed, stability, and numerical consistency on all platforms. For example, on the old Macbook Pro with Python 3.7 and Matlab R2019a, the speed of common function calls was 0.0055 seconds on average (0.0038 seconds median), matching the speed of the Python packages on modern systems.
