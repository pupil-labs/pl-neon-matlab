If you plan to use our package with Psychtoolbox on an Apple Silicon Mac, then the install process is different because Psychtoolbox is currently built only for Intel Macs. First, you will need a copy of MATLAB for Intel Macs. If not, then please install that first. You can install multiple copies of MATLAB on the same computer.

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
