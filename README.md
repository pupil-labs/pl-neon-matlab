# Pupil Labs Neon-MATLAB/Octave integration

This integration leverages MATLAB and Octave's Python interfaces to directly run functions from the
[Pupil Labs Real-Time API](https://github.com/pupil-labs/realtime-python-api) and [Real-time Screen Gaze](https://github.com/pupil-labs/real-time-screen-gaze) Python packages.
This means you will need to have an installation of Python on your computer.
For users who are new to Python, please see [the installation and usage instructions below](#installation).
You will also need Psychtoolbox installed, so make sure to take care of that, too.

# Psychtoolbox

This package requires the installation of Psychtoolbox for accurate timestamping of events. Please see [the standard Psychtoolbox installation instructions](
http://psychtoolbox.org/download.html) and first make sure that Psychtoolbox is properly installed and functioning. You can do this after the Psychtoolbox setup has finished, by restarting MATLAB/Octave and then entering ```AssertOpenGL``` and ```KbCheck``` at the MATLAB/Octave command line. If you do not receive any error messages, then Psychtoolbox is properly installed and functioning.

Note that if you want to use Octave and you are on Windows, then you must install version 7.3 of Octave for Psychtoolbox to work correctly. Use the link at the bottom of [the Window install instructions for Octave](https://octave.org/download#ms-windows) to find a list of older binaries.

Now, you can proceed to the steps below for setting up Python.

# Python Setup

## Anaconda and miniconda Python

The Anaconda/miniconda Python suite is popular and user-friendly, but it might be difficult to get it working well with MATLAB and Octave. We have not tested this, so if you use Anaconda and MATLAB, you will need to consult [the MATLAB-Python documentation](https://www.mathworks.com/help/matlab/python-language.html) while following our installation instructions below. If you use Anaconda and Octave, then consult the [Octave-Pythonic documentation](https://gitlab.com/gnu-octave/octave-pythonic).

## MATLAB

You will need MATLAB R2019a or later, as our Python packages require Python version 3.7 or newer. Check [the MATLAB-Python compatability table](https://www.mathworks.com/support/requirements/python-compatibility.html) for more information.

In case you are not a Python user, we provide brief instructions below for installing Python on Windows. If you are on MacOS or Linux, then you already have Python pre-installed.
We also provide steps below to get the necessary Python packages installed on each system.
If you to configure the Python version that MATLAB uses, then please see [the corresponding MATLAB documentation](https://www.mathworks.com/help/matlab/python-language.html).

Note that if you receive unexpected Python errors from MATLAB, then you are using incompatible Python and MATLAB versions.

### Windows

If you are a new Python user, then it is [recommended by Mathworks](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) to install a version of Python from [python.org](https://www.python.org/). Installing Python from the Windows Store will not work! Make sure to choose a Python version that is [compatible with your Matlab version]((https://www.mathworks.com/support/requirements/python-compatibility.html). Also, make sure to select the "Add to path" option when the installer starts.

If you already have a version of Python that you would like to use, then check the [Matlab documentation about configuring your system](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html).

Once Python is ready, start a terminal (Go to the Start Menu and then enter "cmd.exe"). Then, enter the following to install the necessary packages:

```
pip3 install opencv-python
pip3 install opencv-contrib-python
pip3 install pupil-labs-realtime-api
pip3 install real-time-screen-gaze
```

If you are a new Python user or you are satisified with the default Python 3 on your system, then you can close the terminal and can [start testing the Neon integration in MATLAB](#using-the-neon-integration). If you rather want to use a specific Python version, then make sure to change the ```pip3``` commands above accordingly.

If you want to use a Python version manager, like pyenv, then you will need to consult [the MATLAB documentation](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) about how to configure everything correctly.

### MacOS and Linux

You will need to open a terminal. On MacOS, start Terminal.app. It is assumed that if you are on Linux, then you already know how to start a terminal.

Now, enter the following to install the necessary packages:

```
pip3 install opencv-python
pip3 install opencv-contrib-python
pip3 install pupil-labs-realtime-api
pip3 install real-time-screen-gaze
```

Note that on Linux, MATLAB will not see Python packages installed by the package manager (e.g., apt on Ubuntu).

If you are a new Python user or you are satisified with the default Python 3 on your system, then you can continue to the next step. If you rather want to use a specific Python version, then make sure to change the ```pip3``` commands above accordingly.

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

Now, close the terminal. Then, restart MATLAB, copy the files in the [matlab folder](matlab/) to your MATLAB path, and you can [start testing the Neon integration in MATLAB](#using-the-neon-integration).

If you want to use a Python version manager, like pyenv, or a Homebrew version of Python on MacOS, then you will need to consult [the MATLAB documentation](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) about how to configure everything correctly.

### Using the Neon integration

After you have Python and the necessary Python packages, you can put the files in the [matlab folder](matlab/) of this repository somewhere on your MATLAB path.
Then, check [matlab/basic_example.m](matlab/basic_example.m) and [matlab/gaze_mapping_example.m](matlab/gaze_mapping_example.m) for examples of how to use our Neon integration.

If you are asked to allow network connections or to allow MATLAB to communicate on public/private networks, then choose "allow".

## Octave (all systems)

If you have reason to use Octave, first note the following:

- It is still in principle slower than MATLAB
- It is limited in functionality relative to MATLAB
- It is less tested

That said, it is free and open-source.

If you have need for the Octave-Neon integration, then keep in mind
that there is presently no clean and fast way to convert large numpy arrays to Octave arrays.
This means that you will not be able to inspect the eye or scene camera video frames, although you can pass them onwards to other Python functions.
Otherwise, there is feature parity with the MATLAB integration.

First, follow the same install steps as those for MATLAB for your operating system, making sure to put the functions from the [octave folder](octave/) on your Octave path. Do not use the functions in the matlab folder for an Octave installation. Please note that if you want to use a specific Python version or you are using a Python version manager, then you will need to consult the [Octave-Pythonic documentation for configuring your system](https://gitlab.com/gnu-octave/octave-pythonic#python-selection).

If you are on Linux, then you need to first install the development files for Octave. On Ubuntu, run the following command in the terminal:

```
sudo apt install liboctave-dev
```

Next, install the Pythonic package from Octave Forge using [the official installation instructions](https://gitlab.com/gnu-octave/octave-pythonic#octave-pythonic-package).

Then, after you have added the files in the [octave folder](octave/) to your Octave path, you can check [octave/basic_example.m](octave/basic_example.m) and [octave/gaze_mapping_example.m](octave/gaze_mapping_example.m) for examples of how to use our Neon integration.

If you are asked to allow network connections, then choose "allow".

# System compatibility & tests

This integration has been tested on:

- Windows 11
- Ubuntu 20.04 LTS
- MacOS 11.6.7 (Macbook Pro, Late 2013)

Both the MATLAB and Octave implementations have been tested for speed, stability, and numerical consistency on all platforms. For example, on the old Macbook Pro with Python 3.7 and Matlab R2019a, the speed of common function calls was 0.0055 seconds on average (0.0038 seconds median), matching the speed of the Python packages on modern systems.
