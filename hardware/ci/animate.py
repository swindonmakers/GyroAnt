#!/usr/bin/env python

# Renders an animation for a specific machine/assembly combo

import os
import openscad
import shutil
import sys
import c14n_stl
import re
import json
import jsontools
from types import *
from math import floor
import subprocess

import views


def machine_dir(s):
    s = s.replace(" ","")
    return re.sub(r"\W+|\s+", "", s, re.I)


def mapRange(value, leftMin, leftMax, rightMin, rightMax):
    # Figure out how 'wide' each range is
    leftSpan = leftMax - leftMin
    rightSpan = rightMax - rightMin

    # Convert the left range into a 0-1 range (float)
    valueScaled = float(value - leftMin) / float(leftSpan)

    # Convert the 0-1 range into a value in the right range.
    return rightMin + (valueScaled * rightSpan)


def animateAssembly(mname, aname, prefix, numFrames):
    print("Animate Assembly")
    print("----------------")

    print("NB: Make sure you've run parse.py first!")
    print("")

    temp_name =  "temp.scad"

    # load hardware.json
    jf = open("hardware.json","r")
    jso = json.load(jf)
    jf.close()

    # locate required machine
    for m in jso:
        if type(m) is DictType and m['type'] == 'machine' and m['title'] == mname:
            print("Found machine: "+m['title'])

            al = m['assemblies']

            # make target directory
            view_dir = "../assemblies/"+machine_dir(m['title'])
            if not os.path.isdir(view_dir):
                os.makedirs(view_dir)

            # locate required assembly
            for a in al:
                if a['title'] == aname:
                    print("Found assembly: "+a['title'])
                    fn = '../' + a['file']
                    if (os.path.isfile(fn)):

                        print("  Checking csg hash")
                        h = openscad.get_csg_hash(temp_name, a['call']);
                        os.remove(temp_name);

                        hashchanged = ('hash' in a and h != a['hash']) or (not 'hash' in a)

                        numSteps = 0

                        # Calc number of steps, and grab first view
                        view = {}
                        for step in a['steps']:
                            if step['num'] == 1:
                                view = step['views'][0]
                            if step['num'] > numSteps:
                                numSteps = step['num']
                        print("Animating " + str(numSteps) + " steps over "+str(numFrames)+" frames...")

                        # iterate over frames
                        for frame in range(0, numFrames):
                            t = frame / (numFrames-1.0);
                            ShowStep = floor(mapRange(t, 0, 1.0, 1.0, numSteps+1));
                            AnimateExplodeT = mapRange(t, 0,1.0, 1.0, numSteps+1) - ShowStep;

                            print("t: "+str(t) +", s: "+str(ShowStep)+", a:"+str(AnimateExplodeT))

                            # Generate step file
                            f = open(temp_name, "w")
                            f.write("include <../config/config.scad>\n")
                            f.write("DebugConnectors = false;\n");
                            f.write("DebugCoordinateFrames = false;\n");
                            f.write("$Explode = true;\n");
                            f.write("$AnimateExplode = true;\n");
                            f.write("$ShowStep = "+ str(ShowStep) +";\n");
                            f.write("$AnimateExplodeT = "+ str(AnimateExplodeT) +";\n");
                            f.write("rotate([0,"+str(mapRange(t,0,1.0,0,-10))+","+str(mapRange(t,0,1.0,0,90))+"])")
                            f.write(a['call'] + ";\n");
                            f.close()

                            # Views
                            views.PolishTransparentBackground = False
                            views.PolishCrop = False
                            views.render_view_using_file(prefix + format(frame, '03'), temp_name, view_dir, view, hashchanged, h)

                        # build video
                        # ffmpeg -f image2 -r 1/5 -i img%03d.png -c:v libx264 -pix_fmt yuv420p out.mp4
                        cmd = "ffmpeg -r 25 -y -i "+view_dir + "/" + prefix+"%03d_"+view['title']+".png -vcodec libx264 -pix_fmt yuv420p "+view_dir + "/" + prefix+".mp4"
                        print("Encoding video with: "+cmd)
                        os.system(cmd)

                        # clean up temporary images
                        for frame in range(0, numFrames):
                            os.remove(view_dir + "/" +prefix + format(frame, '03') + "_" +view['title']+".png");

                        print("Done")

                        try:
                            if sys.platform == "darwin":
                                check_output(['osascript','-e','display notification "Animation Complete" with title "Animation"'])
                        except:
                            print("Exception running osascript")

                    else:
                        print("    Error: scad file not found: "+a['file'])

    return 0


if __name__ == '__main__':
    if len(sys.argv) == 5:
        animateAssembly(sys.argv[1], sys.argv[2], sys.argv[3], int(sys.argv[4]) )
    else:
        print("Usage: ./animate.py <machine> <assembly> <output prefix> <numFrames>")
        print("Example: ./animate.py House Window windowAnim 100");
