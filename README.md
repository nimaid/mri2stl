# mri2stl
A Docker image for painlessly converting head MRI data to a 3D surface model of the brain.

[Modified from miykael/3dprintyourbrain](https://github.com/miykael/3dprintyourbrain)

<a href="https://www.thingiverse.com/thing:3632075/"><p align="center"><img src="https://github.com/nimaid/mri2stl/raw/master/images/mri2stl.png" width=600px /></p></a>

## Motivations
I had a head study done, and because I was the curious type, my doctor informed me I could get my medical records for free on a CD. So I naturally did so immediately after the study, and then I started my journey to create a 3D model of my brain from many black and white medical images. [This has been done well before](https://github.com/miykael/3dprintyourbrain), but it was still a *headache* to set up. ;) Also, non-Linux users are left out in the rain, that is unless they want to setup a VM, install a Linux distro, then finally go through the awful setup. There had to be a better way.

Enter Docker! It's sort of like a VM, but it runs way faster, and doesn't take any time to set up. Just download and run, like you might do with a cross-platform Java (`.jar`) file. It creates a virtual computer environment that has the OS and all the files + installed programs that you need for your program! This is my Docker "image" with everything you need already set up for turning `DICOM`/`NIfTI` image sets into an `.stl` 3D model, ready for printing or other uses. You can do this with only one dead-simple command! You use it through your browser, through something very cool called a Jypyter notebook.

## Installing and Running
To run the Docker image:
* Install Docker on your computer
* Run the command `docker run --rm -it -p 8888:8888 nimaid/mri2stl`
* Go to `127.0.0.1:8888` in your web browser
<details><summary>Detailed Instructions for Beginners</summary>
<p>

### Install Docker
Install Docker for your platform. This will literally be the only hard step of the whole process, and it's different for each OS. You can learn more [here](https://hub.docker.com/), and through Google. Don't panic! It's still pretty easy, especially on Windows. 

### Start the server
When you try to run an image in Docker, it will automatically download the latest version of that image if it's not already on your local computer. You can run the server as follows:

`launch.bash` (Linux) **or** `launch.bat` (Win)

This runs the image in the foreground, so that closing the command window or pressing `CTRL-C` kills server. This is equivalent to the command `docker run --rm -it -p 8888:8888 nimaid/mri2stl`

**Be aware that killing the server immediately and permanently erases all data you may have uploaded or created. Please be careful and save your work before killing the server.**

*NOTE: If you want to run the image in the background (advanced), use the command `docker run --rm -p 8888:8888 nimaid/mri2stl`. You will have to manually kill the server, either through the GUI or through `docker` commands.*

After Docker downloads the latest image, the server will start running and you should see something like the following:
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

### Go to the Server's Website
You can now **minimize (not close)** the command line window. In your browser, navigate to the URL `127.0.0.1:8888`. You should see it load a website.

</p>
</details>

## Making the actual 3D model
Now you will need to select the scan to upload. When you get an MRI study done, they usually take several sets of images. Not all image sets are created equal! Many only capture a small section of the brain, or don't have enough images for a good recreation, or the images don't show the brain's structure clearly enough, or it's too low of a resolution, or...

Yeah, there's a lot that can go wrong. So when selecting an image set, here are some good criteria to meet, in order of importance:
* The entire brain must be captured, from the subcortical base to the tip of the skull
* The slices must very clearly show the folds and internal structures of the brain
* The brain must clearly have a gap between it and the skull in most of the slices
* With more slices, more detail and accuracy can be achieved in the final output
* Higher resolution images are better
  * Try for at minimum 350x350
  * Lower resolutions can fail outright

Below is the scan I used [to make this 3D model](https://www.thingiverse.com/thing:3610884). It is 400x512, with 160 slices. This is the scan that I found in my study that worked the best (it's `test_scan.zip`):

<p align="center"><img src="https://github.com/nimaid/mri2stl/raw/master/images/test_scan.gif" alt="A Perfect Scan" /></p>

The images will most likely either be in what's called `DICOM` formatting, or `NIfTI` formatting. `DICOM` image sets are usually a folder filled with a bunch of numbered files, usually with no extension. `NIfTI` image sets are a single file with a `.nii` file extension.

Neither of these image formats are supported by your computer by default, but the CD they gave you with your MRI data on it usually has a viewer program that works for Windows. Alternatively, you could [use this very handy website](http://bit.ly/PapayaViewer) which supports every file format, even the non-mesh 3D surfaces behind the scenes of FreeSurfer!

Find the best image set of your study, using the above rubric. If your image set is in `DICOM` format, you must pack them into a `.zip` file, in the main directory (NOT a sub-folder!). Here is the file structure expected:
* my_scan.zip
  * IMG000001
  * IMG000002
  * IMG000003
  * ...

When you have either your `DICOM` `.zip` file, or your `NIfTI` `.nii` file ready to go, go back to the browser. In the upper left, click the `Upload` button which looks like an up arrow with a line behind it. Select your file and it will be uploaded to the server for processing.

Now, click `Terminal` in the `Other` category. Here, you can use the following commands to create an `.stl` of the surface of the brain from medical imaging data:
* `dicom2stl`
  * Takes a `.zip` file with the `DICOM` images from a head study in the main directory.
* `nii2stl`
  * Takes a `.nii` file with the `NIfTI` images from a head study.

All of these commands, if they complete successfully, will copy the final `.stl` to the main directory, `brain_[NAME]_[CORTICAL]_[SMOOTH].stl`, where:
* `[NAME]` is the name of the input file.
* `[CORTICAL]` is ether
  * `cortical` if only the cortical structure was captured.
  * `cort+subcort` if both the cortical and subcortical structures were captured.
* `[SMOOTH]` is whether the output could have laplacian smoothing applied.
  * `smooth` if smoothed
  * `raw` if smoothing failed

An example command, to convert the included `DICOM` test scan into a `.stl`, would be `dicom2stl test_scan.zip`.

Converting your brain will take quite a few hours to complete (anywhere from 8 hours to a couple days, depending). I recommend you configure your Docker daemon to use most if not all of your CPU's cores.

To download files (like your shiny new `.stl`), right click the file in the browser to the left and select `Download`.

Once you have all the files you want to save downloaded, you can kill the server by clicking `Quit` in the upper right corner. When you do this, all files uploaded or created that were not downloaded will be forever lost, so be careful!

If you close your browser without clicking `Quit`, the image will still be running in the background. You can reconnect by going to `127.0.0.1:8888`.

The other way to kill the server is to shutdown the Docker container manually. You would use `docker ps` to get the ID of it, then `docker rm -f [ID]`. This will also permenently delete all files uploaded/created.

The conversion process concatenates the two cortical hemispheres and subcortical models, then trys to smooth them together. This means that you can seperate your brain into it's constituent parts by using a 3D editing program (like [Blender](https://www.blender.org/)) to seperate the disconnected meshes ("loose parts" in Blender). If you try and print it as a whole, your printer should print just one solid object, no issues.
