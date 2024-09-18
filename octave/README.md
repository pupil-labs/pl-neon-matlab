If you use Octave, please note that support for Neon is somewhat limited relative to MATLAB. Also, Octave-compatbility is somewhat less tested.

If you need the Octave-Neon integration, then keep in mind that there is presently no clean and fast way to convert large numpy arrays to Octave arrays.
This means that you will not be able to inspect the eye or scene camera video frames in Octave, although you can pass them onwards to other Python functions.
Otherwise, there is feature parity with the MATLAB integration.

First, follow the Python install steps [for your operating system](../README.md#python-setup), making sure to put the functions from the [octave folder](octave/) of this repository on your Octave path. Do not use the functions in the `matlab` folder for an Octave installation. Also, if you want to use a specific Python version or you are using a Python version manager, then you will need to consult the [Octave-Pythonic documentation for configuring your system](https://gitlab.com/gnu-octave/octave-pythonic#python-selection). If you want to use an Anaconda install of Python with Octave, then please consult the [Octave-Pythonic documentation](https://gitlab.com/gnu-octave/octave-pythonic).

If you are on Linux, then you need to install the development files for Octave. On Ubuntu, run the following command in the terminal:

```
sudo apt install liboctave-dev
```

Next, start Octave and install the Pythonic package from Octave Forge following [the official installation instructions](https://gitlab.com/gnu-octave/octave-pythonic#octave-pythonic-package):

```
pkg install -forge pythonic
```

Then, after you have added the files in the [octave folder](../octave/) to your Octave path, you can check [octave/examples/basic_recording.m](./examples/basic_recording.m) and [octave/examples/gaze_mapping_example.m](./examples/gaze_mapping_example.m) for examples of how to use our Neon integration.

If you are asked to allow network connections, then choose "allow".
