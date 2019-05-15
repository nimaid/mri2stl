# mri2stl
A Docker image for converting head MRI data to a 3D surface model of the brain.

[Modified from miykael/3dprintyourbrain](https://github.com/miykael/3dprintyourbrain)

## Instructions
Install Docker for your platform. Docker will automatically download the latest version of the image if it's not already on your local computer. You can run the server as follows:

**CTRL-C kills server:** `docker run --rm -it -p 8888:8888 nimaid/mri2stl` (This is the command in `launch.sh` and `launch.bat`.)

**CTRL-C sends to BG (kill server manually):** `docker run --rm -p 8888:8888 nimaid/mri2stl`

After Docker downloads the latest image, you should get something like the following:
```
[I 22:39:57.565 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
[I 22:39:57.728 NotebookApp] Serving notebooks from local directory: /3dprintscript
[I 22:39:57.728 NotebookApp] The Jupyter Notebook is running at:
[I 22:39:57.729 NotebookApp] http://(0d0e3db6f247 or 127.0.0.1):8888/?token=b9596f04a97c1ae9c2b02dd1877568f5ea20c805aa1199fa
[I 22:39:57.729 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 22:39:57.734 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///root/.local/share/jupyter/runtime/nbserver-6-open.html
    Or copy and paste one of these URLs:
        http://(0d0e3db6f247 or 127.0.0.1):8888/?token=b9596f04a97c1ae9c2b02dd1877568f5ea20c805aa1199fa
```
We are interested in the line that looks like `http://(0d0e3db6f247 or 127.0.0.1):8888/?token=b9596f04a97c1ae9c2b02dd1877568f5ea20c805aa1199fa`.

Copy the `127.0.0.1` and everything after it. Then paste it into your web browser, and remove the right parentheses right of the `127.0.0.1`.

The URL should look something like this: `127.0.0.1:8888/?token=b9596f04a97c1ae9c2b02dd1877568f5ea20c805aa1199fa`. Go ahead and go to the URL.

If it all worked well, you should see the "Jupyter" logo up top, and a list of files.

Now, in the upper right, click `New > Terminal`. Here, you can use the following commands to create an .stl of the surface of the brain from medical imaging data:
* `dicom2stl`
  * Takes a .zip file with the DICOM images from a head study in the parent directory.
* `nii2stl`
  * Takes a .nii file with the NIfTI images from a head study in the parent directory.
* `mri2stl`
  * If you had run `nii2stl` or `dicom2stl` and the job got interrupted, you can restart the job by passing just the name (no `.nii` or `.zip`) of the file you passed in.
  * So if you ran `dicom2stl.sh SE000004.zip`, you could re-start that job from the beginning with `mri2stl.sh SE000004`.

All of these commands, if they complete successfully, should copy the final .stl to the main directory, `brain_[NAME]_[CORTICAL]_[SMOOTH].stl`, where:
* `[NAME]` is the name of the input file.
* `[CORTICAL]` is ether
  * `cortical` if only the cortical structure was captured.
  * `cort+subcort` if both the cortical and subcortical structures were captured.
* `[SMOOTH]` is whether the output could have laplacian smoothing applied.
  * `smooth` if smoothed
  * `raw` if smoothing failed

You can test the program by running the following command:

`dicom2stl test_scan.zip`

This will take quite a few hours to complete (anywhere from 8 hours to a couple days depending). I recommend you configure your Docker daemon to use most if not all of your CPU's cores.

If you want to use your own file, use the `Upload` button left of the `New` button. After selecting the file, it will prompt you again in the file browser, click the blue `Upload` button.

To download files, tick the box left of the item in question, then click the `Download` button which appears in the upper left.