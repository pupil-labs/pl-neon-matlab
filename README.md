# Pupil Labs Neon-Psychtoolbox integration

Use MATLAB and Octave's Python interfaces to run functions directly from the 
pupil-labs-realtime-api.

This package requires the installation of Psychtoolbox for accurate timestamping of events. Please see the standard Psychtoolbox installation instructions and first make sure that Psychtoolbox is properly installed and functioning:

http://psychtoolbox.org/download.html

Note that this package is currently only tested on Ubuntu 20.04 LTS.

# Installation

## Windows

### MATLAB

MATLAB will connect to your system provided Python by default. It is easiest to install a version of Python provided by the Python Software Foundation on the Windows Store. We recommend Python 3.11 (the latest when this document was created). You can find it here:

https://apps.microsoft.com/detail/9NRWMJP3717K?hl=en-us&gl=US

Ensure that it is from the "Python Software Foundation". It should be free of charge.

Once installed, start a terminal (Start and then enter "cmd.exe") and enter the following to install the necessary packages:

```
pip install opencv-python
pip install pupil-labs-realtime-api
```

Now, put Device.m, get_ns.m and ndarray2mat.m from the matlab folder somewhere on your MATLAB path.

Then, check matlab/test_Device_class.m for examples of how to use our Neon integration.

## MacOS

### MATLAB

MATLAB will connect to your system provided Python by default. It will not see the packages that are installed via the package manager, so you need to first install the required packages with the system-provided pip.

If you do not use a Python version manager, then the following is sufficient:

```
pip3 install opencv-python
pip3 install pupil-labs-realtime-api
```

If you use a Python version manager, like pyenv, then you need to make especially certain that your system-provided pip is used.

Now, put Device.m, get_ns.m and ndarray2mat.m from the matlab folder somewhere on your MATLAB path.

Then, check matlab/test_Device_class.m for examples of how to use our Neon integration.

## Linux (Ubuntu)

### MATLAB

MATLAB will connect to your system provided Python by default. It will not see the packages that are installed via the package manager (e.g., apt on Ubuntu), so you need to first install the required packages with the system-provided pip.

If you do not use a Python version manager, then the following is sufficient:

```
pip3 install opencv-python
pip3 install pupil-labs-realtime-api
```

If you use a Python version manager, like pyenv, then you need to make especially certain that your system-provided pip is used. On Ubuntu 20.04 LTS, the following will do it:

```
/usr/bin/pip3.10 install opencv-python
/usr/bin/pip3.10 install pupil-labs-realtime-api
```

Now, put Device.m, get_ns.m and ndarray2mat.m from the matlab folder somewhere on your MATLAB path.

Then, check matlab/test_Device_class.m for examples of how to use our Neon integration.

## Octave (all systems)

If you have reason to use Octave, first note the following:

- It is still in principle slower than MATLAB
- It is limited in functionality relative to MATLAB
- It is less tested

However, if you still have need for the Octave-Neon integration, then keep in mind
that there is presently no clean and fast way to convert numpy arrays to Octave arrays.
This means that you will not be able to inspect the eye or scene camera video frames.
Otherwise, there is feature parity with the MATLAB integration.

First, follow the same install steps as those for MATLAB for your system, making sure to put the functions from the octave folder on your Octave path. Do not use the functions in the matlab folder for an Octave installation.

Next, install the pythonic package from Octave Forge:

```
pkg install -forge pythonic
```

Then, check octave/test_Device_class.m for examples of how to use our Neon integration.