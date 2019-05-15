# mri2stl
A Docker image for converting head MRI data to a 3D surface model of the brain.

[Modified from miykael/3dprintyourbrain](https://github.com/miykael/3dprintyourbrain)

<p align="center"><img src="https://github.com/nimaid/mri2stl/raw/master/images/mri2stl.png" width=500px /></p>

## Instructions
Install Docker for your platform. This will literally be the hardest step of the whole process, and it's different for each OS. You can learn more [here](https://hub.docker.com/), and through Google.

When you try to run an image in Docker, it will automatically download the latest version of that image if it's not already on your local computer. You can run the server as follows:

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

The URL should look something like this: `127.0.0.1:8888/?token=b9596f04a97c1ae9c2b02dd1877568f5ea20c805aa1199fa`. **Make a note of this somewhere** and then go to the URL.

If it all worked well, you should see the "Jupyter" logo up top, and a list of files.

Now you will need to select the scan to upload. When you get an MRI study done, they usually take several sets of images. Not all image sets are created equal! Many only capture a small section of the brain, or don't have enough images for a good recreation, or the images don't show the brain's structure clearly enough, or it's too low of a resolution, or...

Yeah, there's a lot that can go wrong. So when selecting an image set, here are some good criterion to meet, in order of importance:
* The entire brain must be captured, from the subcortical base to the tip of the skull
* The slices must very clearly slow the folds and internal structures of the brain
* The brain must clearly have a gap between it and the skull in most of the slices
* With more slices, more detail and accuracy can be achieved in the final output
* Higher resolution images are better
  * Try for at least 350x350
  * Lower resolutions can fail outright

Below is the scan I used [to make this 3D model](https://www.thingiverse.com/thing:3610884). It is 400x512, with 160 slices. This is the scan that I found in my study that worked the best (it's `test_scan.zip`):

<a href="https://www.thingiverse.com/thing:3632075/"><p align="center"><img src="https://github.com/nimaid/mri2stl/raw/master/images/test_scan.gif" alt="A Perfect Scan" /></p></a>

The images will most likely either be in what's called `DICOM` formatting, or `NIfTI` formatting. `DICOM` image sets are usually a folder filled with a bunch of numbered files, usually with no extension. `NIfTI` image sets are a single file with a `.nii` file extension.

Neither of these image formats are supported by your computer by default, but the CD they gave you with your MRI data on it usually has a viewer program that works for Windows. Alternatively, you could [use this very handy website](http://bit.ly/PapayaViewer) which supports every file format, even the non-mesh 3D surfaces behind the scenes of FreeSurfer!

Find the best image set of your study, using the above rubric. If your image set is in `DICOM` format, you must pack them into a `.zip` file, in the main directory (NOT a sub-folder!). Here is the file structure expected:
* my_scan.zip
  * IMG000001
  * IMG000002
  * IMG000003
  * ...

When you have either your `DICOM` `.zip` file, or your `NIfTI` `.nii` file ready to go, go back to the Jupyter dashboard. Click the `Upload` button left of the `New` button. After selecting your file, it will prompt you a second time in the file browser, click the blue `Upload` button.

Now, in the upper right, click `New > Terminal`. Here, you can use the following commands to create an `.stl` of the surface of the brain from medical imaging data:
* `dicom2stl`
  * Takes a `.zip` file with the `DICOM` images from a head study in the main directory.
* `nii2stl`
  * Takes a `.nii` file with the `NIfTI` images from a head study.

All of these commands, if they complete successfully, should copy the final `.stl` to the main directory, `brain_[NAME]_[CORTICAL]_[SMOOTH].stl`, where:
* `[NAME]` is the name of the input file.
* `[CORTICAL]` is ether
  * `cortical` if only the cortical structure was captured.
  * `cort+subcort` if both the cortical and subcortical structures were captured.
* `[SMOOTH]` is whether the output could have laplacian smoothing applied.
  * `smooth` if smoothed
  * `raw` if smoothing failed

An example command, to convert the included `DICOM` test scan into a `.stl`, would be `dicom2stl test_scan.zip`.

Converting your brain will take quite a few hours to complete (anywhere from 8 hours to a couple days, depending). I recommend you configure your Docker daemon to use most if not all of your CPU's cores.

To download files (like your shiny new `.stl`), tick the box left of the item in question, then click the `Download` button which appears in the upper left.

Once you have all the files you want to save downloaded, you can kill the server by clicking `Quit` in the upper right corner. When you do this, all files uploaded or created that were not downloaded will be forever lost, so be careful!

If you close your browser without clicking `Quit`, the image will still be running in the background. You can reconnect by going to the same URL which you initially noted down. (You did note it down, right?)

The other way to kill the server is to shutdown the Docker container manually. You would use `docker ps` to get the ID of it, then `docker rm -f [ID]`. This will also permenently delete all files uploaded/created.

The conversion process concatenates the two cortical hemispheres and subcortical models, then trys to smooth them together. This means that you can seperate your brain into it's seperate parts by using a 3D editing program (like [Blender](https://www.blender.org/)) to seperate the disconnected meshes ("loose parts" in Blender). If you try and print it as a whole, your printer should print just one solid object, no issues.