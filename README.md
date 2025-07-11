# Pupil Labs Neon(+Pupil Invisible)-MATLAB/Octave integration

This integration leverages MATLAB and Octave's Python interfaces to directly run functions from the
[Pupil Labs Real-Time API](https://github.com/pupil-labs/realtime-python-api) and [Real-time Screen Gaze](https://github.com/pupil-labs/real-time-screen-gaze) Python packages.
This means you will need to have an installation of Python on your computer.
For users who are new to Python, please see [the Python setup instructions below](#python-setup).

It is primarily designed with Neon in mind, but it is also compatible with Pupil Invisible.

This package is completely stand-alone and can be used on its own. It can be used alongside psychophysics toolboxes, such as [Psychtoolbox](http://psychtoolbox.org/) and [mgl](https://gru.stanford.edu/doku.php/mgl/overview), as well as in conjunction with neuroscience/physiology toolboxes. If you prefer, you can use Psychtoolbox functions to timestamp events.

Make sure to check out our guide on how to use this integration: [track your experiment in MATLAB](track-your-experiment-progress-using-events.md).

## MATLAB+Python Setup

Here, we provide installation instructions for using MATLAB with our Python packages.

### Octave

If you are an Octave user, then please see [the dedicated Octave instructions](octave/README.md).

### Anaconda and miniconda Python

The Anaconda/miniconda Python suite is popular and user-friendly, but it might be difficult to get it working well with MATLAB and Octave. We have not tested this, so if you want to use Anaconda with MATLAB, you will need to consult [the MATLAB-Python documentation](https://www.mathworks.com/help/matlab/python-language.html) while following our installation instructions below.

### MATLAB

You will need MATLAB R2021b or later, as our Python packages require Python version 3.9 or newer. You will also need a version of Python that is compatible with your MATLAB version. Check [the MATLAB-Python compatability table](https://www.mathworks.com/support/requirements/python-compatibility.html) for more information.

We provide steps below to get our Neon Python packages installed on each system.

In case you are not a Python user, we also provide brief tips below for installing Python on Windows and MacOS. If you are on Linux, then you already have Python pre-installed. Note that if you receive unexpected Python errors from MATLAB, then you are most likely using incompatible Python and MATLAB versions.

#### Windows
<details>
    <summary>View instructions</summary>

If you are a new Python user, then it is [recommended by Mathworks](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) to install a version of Python from [python.org](https://www.python.org/). Make sure to select the "Add to path" option when the Python installer starts.

***Installing Python from the Windows Store will not work!***

If you already have a version of Python that you would like to use, then check the [MATLAB documentation about configuring your system](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html#buialof-39).

Once Python is ready, start a terminal (Go to the Start Menu and then enter "cmd.exe"). Then:

1. Enter the following to install the necessary packages:
    ```
    pip3 install opencv-python
    pip3 install opencv-contrib-python
    pip3 install pupil-labs-realtime-api
    pip3 install real-time-screen-gaze
    ```
    If you are a new Python user or you are satisified with the default Python 3 on your system, then you can skip to the next step. If you instead want to use a specific Python version or you use a Python version manager, like pyenv, then change the ```pip3``` commands above accordingly and make sure to consult [the MATLAB documentation](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html#buialof-39) about how to configure everything correctly.

2. Close the terminal and restart MATLAB. Now, you can [start testing the Neon integration](#using-the-neon-integration).
</details>

#### Linux
<details>
    <summary>View instructions</summary>

If you are on Linux, then your system already provides Python and MATLAB will automatically use this version. Just make sure that [your Python and MATLAB versions are compatible](https://www.mathworks.com/support/requirements/python-compatibility.html).

To get started, you will need to open a terminal. Then:

1. Enter the following:
    ```
    pip3 install opencv-python
    pip3 install opencv-contrib-python
    pip3 install pupil-labs-realtime-api
    pip3 install real-time-screen-gaze
    ```
    If you are a new Python user or you are satisified with the default Python 3 on your system, then you can skip to the next step. If you instead want to use a specific Python version or you use a Python version manager, like pyenv, then change the ```pip3``` commands above accordingly and make sure to check the [MATLAB-Python documentation about configuring your system](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html#buialof-40).

2. Restart MATLAB and [start testing the Neon integration](#using-the-neon-integration).

Note that on Linux, MATLAB will not see Python packages installed by the package manager (e.g., apt on Ubuntu).
</details>

#### MacOS
<details>
    <summary>View instructions</summary>

For MacOS, the installation steps depend on whether you have an Apple Silicon Mac (M1, M2, or M3) or an Intel Mac. You can find out by clicking the Apple Icon in the top left corner of your desktop and going to "About this Mac".

Note that [Mathworks recommends](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html) installing Python from [python.org](https://www.python.org/) on MacOS. If you already have Python installed from a different source on your Mac, then installing an additional version from [python.org](https://www.python.org/) will not overwrite your current installation, although it might temporarily alter your system path.

If you would rather use a Python version that you already have or you want to use a Python version manager, like pyenv, or a Homebrew version of Python on MacOS, then you will need to consult [the MATLAB documentation](https://www.mathworks.com/help/matlab/matlab_external/install-supported-python-implementation.html#buialof-40) about how to configure everything correctly.

Once Python is ready, then continue with the steps below that are appropriate for your Mac.

<details>
    <summary>Intel Mac</summary>

After you have installed a compatible copy of Python, you will need to open a terminal by starting Terminal.app and then:

1. Enter the following in the terminal to install the necessary packages:
    ```
    pip3 install opencv-python
    pip3 install opencv-contrib-python
    pip3 install pupil-labs-realtime-api
    pip3 install real-time-screen-gaze
    ```
    If you are a new Python user, then the commands above are sufficient and you can move to the next step. If you want to use a specific Python version, then change the ```pip3``` command to point to the Python installation that you want to use with MATLAB.

2. On Intel Macs, after the packages have been installed, you need to start Python one time and import the packages. Do that by first entering the following in the terminal:
    ```
    python3
    ```
3. A Python session will start. Now enter the following:
    ```
    import cv2
    import numpy
    import pupil_labs.realtime_api.simple
    import pupil_labs.real_time_screen_gaze.gaze_mapper
    import pupil_labs.real_time_screen_gaze.marker_generator
    ```
    It might take a few moments for each of those commands to complete.
4. You can then quit Python by entering the following:
    ```
    exit()
    ```
5. Now, close the terminal. Restart MATLAB and you can [start testing the Neon integration](#using-the-neon-integration).
</details>

<details>
    <summary>Apple Silicon Mac</summary>

***NOTE: If you intend to use this package in MATLAB with Psychtoolbox on an Apple Silicon Mac, then you must follow the [alternate installation instructions](./psychtoolbox_apple_silicon.md).***

Otherwise, install a compatible copy of Python. Then:

1. Open Terminal.app and run:
    ```
    pip3 install opencv-python
    pip3 install opencv-contrib-python
    pip3 install pupil-labs-realtime-api
    pip3 install real-time-screen-gaze
    ```
    If you are a new Python user, then the commands above are sufficient and you can move to the next step. If you want to use a specific Python version, then change the ```pip3``` command to point to the Python installation that you want to use with MATLAB.

2. Now, close the terminal. Restart MATLAB and you can [start testing the Neon integration](#using-the-neon-integration).
</details>
</details>

## Using the Neon integration

After you have installed Python and the necessary Python packages, you can put the files in the [matlab folder](matlab/) of this repository somewhere on your MATLAB path. Then, check [matlab/examples/basic_recording.m](matlab/examples/basic_recording.m) and [matlab/examples/gaze_mapping_example.m](matlab/examples/gaze_mapping_example.m) for examples of how to use our Neon integration.

If you are asked to allow network connections or to allow MATLAB to communicate on public/private networks, then choose "allow".

## Troubleshooting

- What if I get the error, ```ServerDisconnectedError: Server disconnected```?
  - Check the "Stream" section of the Neon Companion App. You will probably see "waiting for dns service". You need to either force stop and restart app or restart the phone.
  - When you start the Neon Companion app again, it might ask you to allow permissions for Neon. Make sure to select "yes" and "always".

- Do I need to be concerned when I see the message, ```unable to create requested socket pair```?

    If working on Windows, you might briefly see this message when initiating a connection with Neon via the ```Device``` command. This message can be safely ignored. As long as you can send messages to Neon and remotely control it, then you are good to go.

- I am using Octave and got the message, ```error on received data: InvalidStateError```.

    This error is rare. Restart Octave and that should resolve the issue. If the issue persists, then also restart the Neon Companion Device.

- I repeatedly get the message, ```'no RTP received for 10 seconds: closing'```.

    This diagnostic message is in principle harmless and you can continue using the Neon integration as usual.

## System compatibility & tests

This integration has been tested for speed, stability, and numerical consistency on the following platforms:

| OS | Environment | Python version | Tested & works |
| -- | ----------- | -------------- | -------------- |
| Windows 11 | MATLAB R2023b | 3.10 | Yes :white_check_mark: |
| Windows 11 | Octave 7.3.0 with Psychtoolbox ([See above](#windows-psychtoolbox-and-octave)) | 3.10 | Yes :white_check_mark: |
| Windows 11 | Octave 8.1.0 and up ([See above](#windows-psychtoolbox-and-octave)) | 3.10 | :x: No. Pythonic fails to install |
| Ubuntu 20.04 LTS | MATLAB R2023b | 3.10 | Yes :white_check_mark: |
| Ubuntu 20.04 LTS | Octave 6.4.0 (installed from Apt repository) | 3.10 | Yes :white_check_mark: |
| MacOS Sonoma (14.3.1); M2 Macbook Air | MATLAB R2023b without Psychtoolbox | 3.10 | Yes :white_check_mark: |
| MacOS Sonoma (14.3.1); M2 Macbook Air | MATLAB R2023b (Intel version) with Psychtoolbox (Rosetta) | 3.10 | Yes :white_check_mark: |
| MacOS Sonoma (14.3.1); M2 Macbook Air | Octave 8.4.0 without Psychtoolbox | 3.10 | :bangbang: Yes, but requires Rosetta 2 installs of Homebrew, Octave, Python, and associated packages. Tested, but unstable (Pythonic needs to be re-installed after every restart of Octave). |
| MacOS Sonoma (14.3.1); M2 Macbook Air | Octave 8.4.0 with Psychtoolbox | 3.10 | :bangbang: Yes, but requires Rosetta 2 installs of Homebrew, Octave/Psychtoolbox, Python, and associated packages. Tested, but unstable (Pythonic needs to be re-installed after every restart of Octave). |
| MacOS Big Sur (11.6.7); Intel Macbook Pro, Late 2013 | MATLAB R2019a | 3.7 (deprecated) | Yes :white_check_mark: |
| MacOS Big Sur (11.6.7); Intel Macbook Pro, Late 2013 | Octave 7.1.0 with Psychtoolbox | 3.7 (deprecated) | Yes :large_orange_diamond: (for this configuration, the ```receive_gaze_datum``` call took 0.0074 seconds on average) |

All systems marked with a :white_check_mark: in the table above have passed a small stress test. For example, on the Late 2013 Macbook Pro with Python 3.7 and MATLAB R2019a, the speed of the ```receive_gaze_datum``` function call was 0.0055 seconds on average (0.0038 seconds median), matching the speed of the Python packages on modern systems, as desired.
