# Spindle-Orientation-Analysis
The aim of this script is to find the spindles and return the nulber of division over time
and their orientation. The orientation of a spindle is measured at the telophase, because in many system the spindle rotates during anaphase.

How to use
Prerequisite: first you need to split your hyperstack into tif files, with each timepoint separated. Each file needs to have 3 digits as timepoint. You can find some Fiji plugins that do that for you.
Then you need to use Ilastik (http://ilastik.org/). We recommend training on a few images (5 out of 250 were enough in our hand) representing the different phases of your movie (not 5 consecutive images). The script requires the first channel to be the background and second the spindles. The probability mask must be saved as .h5.
Then you can use the matlab script. Open the file called "Spindle_orientation.m".
A brief descriptin of each important parameter is available in the script. Each function is described in its corresponding .m file.
Rapidly, you first have to set up your parameters, some are purely empirical and you have to test on your own images to determine them. You can process a subset of your stack to determine the best parameters. Once you process one file you can save the parameters and load them next time you want to process that file (obviously if you copy the parameters of another movie with pretty much the same parameters it can work).
Then, the probability mask is read and the putative spindles and background are binarized. Next step consist in applying the intensity and eccentricity parameter to that binarized stack to fin the spindles. At this step you can already add the missed divisions manually.
The next step is to link the different timepoints, basically, a spindle that as already been found must not be found again. To track the spindle over time the distance between consecutive detected spindle must be inferior to a user-defined value.
After this step you can visualise the results and you can manually correct all the (hopefully few) errors.
A csv file can be saved with the orientation timepoint and position of each division.
Finally, a plot is generated to represent all the division on a picture of your tissue as a bar oriented according to the orientation of the division.
All the result can be saved at the end. Of notice, you can also generate movies of the diferent steps.


