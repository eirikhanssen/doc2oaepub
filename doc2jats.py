#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep  3 16:39:03 2020

@author: eirikh
"""
import re
import sys
import time
from datetime import datetime
import os.path
import shlex
import subprocess
import zipfile

debugmode = True
settings = {
    'debugmode': debugmode,
    'pipeline_filename': 'doc2jats.xpl',
    'pygmentize_style': 'native'
   }

#outputfolder = sys.argv[1] + timestamp
#
#docxfolder="$1-$timestamp"
#
#SOURCE="${BASH_SOURCE[0]}"
#while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
##  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
#  SOURCE="$(readlink "$SOURCE")"
#  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
#done
#DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
#PIPELINE="$DIR/doc2jats.xpl"
#
#mkdir $docxfolder && cd $docxfolder && unzip ../$1 && cd ..
#
# get the absolute path and use that as a parameter
#FOLDER=$(readlink -f $docxfolder)

#calabash -p filename=$1 -p timestamp=$timestamp -p folder=$foldername doc2jats.xpl
#calabash -p folder=$FOLDER $PIPELINE | pygmentize -l xml | less -R
# should check if pygmentize is installed before trying to use it
#calabash -p folder=$FOLDER $PIPELINE | less



def init():
    global settings
    if debugmode():
        print("init()")
    if check_args_ok():
        settings['cwd'] = os.path.realpath(os.getcwd())
        settings['timestamp'] = re.sub(':', '', datetime.now().isoformat()[:19])
        settings['inputfile_basename'] = os.path.basename(settings['inputfile_normpath'])
        settings['inputfile_baseroot'] = os.path.splitext(settings['inputfile_basename'])[0]
        settings['script_path'] = os.path.realpath(sys.argv[0])
        settings['script_folder'] = os.path.dirname(settings['script_path'])
        settings['pipeline_path'] = os.path.join(settings['script_folder'], settings['pipeline_filename'])
        settings['output_folder_rel'] = settings['inputfile_basename'] + "-extracted"
        settings['output_folder_abs'] = os.path.abspath(settings['output_folder_rel'])
        settings['output_filename_rel'] = settings['output_folder_rel'] + '-' + settings['timestamp'] + '.html'
        settings['output_filepath_rel'] = os.path.join(settings['output_folder_rel'], settings['output_filename_rel'])
        settings['output_filepath_abs'] = os.path.abspath(settings['output_filepath_rel'])
        
        if debugmode():
            print("args seem ok")
            display_vars()
        main()
    else:
        if debugmode():
            print("args seem NOT ok")
            display_vars()
        display_usage()

def main():
    global settings
    if debugmode():
        print("main()")
    if not is_tool('calabash'):
        print('Please install calabash and make it executable in the PATH:\n')
        print(os.environ['PATH']);
        print('Get it from http://xmlcalabash.com/')
    else:
        print('calabash is installed, will proceed')
        unpack_docx()
        
        if not is_tool('pygmentize'):
            if debugmode():
                print('Notice: pygmentize is not installed. Output will not be syntax highlighted.')
        else:
            if debugmode():
                from pygments.styles import get_all_styles
                styles = list(get_all_styles())
                separator=", "
                all_styles = separator.join(styles)
                
                print('Notice: pygmentize is installed. Output will be syntax highlighted.')
                print('Selected pygmentize style is: ' + settings['pygmentize_style'])
                
                print('Available pygmentize styles are: ' + all_styles)
        if not is_tool('less'):
            if debugmode():
                print('Notice: less is not installed. Output will not be piped through less.')
        else:
            if debugmode():
                print('Notice: less is installed. Output will be piped through less.')
        
        if is_tool('less') and is_tool('pygmentize'):
            #run_pipeline_and_direct_standard_out_through_pygmentize_and_less()
            run_pipeline()
        elif is_tool('less'):
            #run_pipeline_and_direct_standard_out_through_less()
            run_pipeline()
        else:
            run_pipeline()
            
#def is_odt_file():
   
#def is_docx_file():

def unpack_docx():
    if debugmode():
        print("Unpacking file")
    global settings
    zipfile_path = settings['inputfile_normpath']
    target_folder = settings['output_folder_abs']
    #target_folder = "unzipped"
    try:
        if not os.path.exists(target_folder):
            print("Make directory %s" % target_folder)
            os.makedirs(target_folder)
    except OSError:
        print ("Creation of the directory %s failed" % target_folder)
    else:
        print ("Successfully created the directory %s " % target_folder)
    
    if os.path.exists(target_folder) and os.path.isdir(target_folder):
        if os.access(target_folder, os.W_OK):
            print("unzipping files in %s" % zipfile_path)
            with zipfile.ZipFile(zipfile_path, 'r') as zf:
                #listOfFileNames = zf.namelist()
                #for filename in listOfFileNames:
                #    print(filename)
                zf.extractall(target_folder)
                #zf.close()
        else:
            print("Sorry, can't extract to %s, because there is no write permission.") % (target_folder)
    
def run_pipeline_and_direct_standard_out_through_pygmentize_and_less():
    global settings
    # calabash -p folder=$FOLDER $PIPELINE | pygmentize -O style=native -l xml | less -R
    return    

def run_pipeline_and_direct_standard_out_through_less():
    global settings
    command_line_calabash = "calabash -p folder=" + settings['output_folder_rel'] + ' ' + settings['pipeline_path']
    args_calabash = shlex.split(command_line_calabash)
    calabash_process = subprocess.Popen(args_calabash, stdout=subprocess.PIPE)
    command_line_less = "less"
    args_less = shlex.split(command_line_less)
    less_process = subprocess.Popen(args_less, stdin=calabash_process.stdout)
    #calabash -p folder=$FOLDER $PIPELINE | less
    return

def run_pipeline():
    global settings
    command_line_calabash = "calabash -p folder=" + settings['output_folder_abs'] + ' ' + settings['pipeline_path']
    args_calabash = shlex.split(command_line_calabash)
    print(args_calabash)
    p = subprocess.Popen(args_calabash)
    timeout = 30
    run_time = 0
    time_begin = datetime.now()
    while True:
        rc = p.poll()
        if rc is None:
            if run_time % 3 == 0:
                print ("\n[%s]:\nProcess with PID: %d is still running..." % (datetime.now(), p.pid))
            time.sleep(1)
            run_time += 1
            if run_time >= timeout:
                p.kill()
        else:
            time_end = datetime.now()
            time_elapsed = time_end - time_begin
            time_elapsed_seconds = time_elapsed.total_seconds()
            print ("\n[%s]:\nProcess with PID: %d has terminated. Exit code: %d. Run time: %d seconds" % (time_end, p.pid, rc, time_elapsed_seconds))
            break;
    return
    
def check_args_ok():
    global settings
    # there has to be exactly two arguments
    # the second argument needs to be either a .docx file or a .odt file
    # possible to check the contents of the file also, not just the filename?
    if debugmode:
        print("check_args_ok()")
    if len(sys.argv) != 2:
        message="""Wrong number of arguments.
Expecting exactly one .docx or .odt file as argument.
Notice: .odt support is not implemented yet."""
        print(message)
        return False
    else:
        settings['inputfile_normpath'] = os.path.normpath(os.path.realpath(sys.argv[1]))
        settings['inputfile_root'], settings['inputfile_ext'] = os.path.splitext(settings['inputfile_normpath'])
        if settings['inputfile_ext'] != '.docx':
            print('unknown file type: ' + settings['inputfile_ext'])
            return False
        else:
            return True

def debugmode():
    global settings
    if settings['debugmode'] == True:
        return True
    else:
        return False

def display_usage():
    global settings
    if debugmode():
        print("display_usage()")
    message = """doc2jats.py usage:
Timestamp: %s
More docs will come later.""" % (settings['timestamp'])
    print(message)

def display_vars():
    global settings
    width = 20
    message = 'Settings'.rjust(width) + ':\n'
    for key in settings:
        message += str(key).rjust(width,' ') + ': ' + str(settings[key]) + '\n'
    print(message)    
    
def convert_document():
    if debugmode:
        print("convert_document()")
    message = """convert_document()"""
    print(message)

def is_tool(name):
    """Check whether `name` is on PATH and marked as executable."""

    # from whichcraft import which
    from shutil import which

    return which(name) is not None

# running the program    
init()