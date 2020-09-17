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

debugmode = False
settings = {
    'debugmode': debugmode,
    'pipeline_filename': 'doc2jats.xpl',
    'pygmentize_style': 'native',
    'do_less': False,
    'do_pygmentize': False
   }

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
        settings['extract_folder_rel'] = settings['inputfile_basename'] + "-extracted"
        settings['extract_folder_abs'] = os.path.abspath(settings['extract_folder_rel'])
        settings['output_folder_rel'] = settings['inputfile_baseroot'] + "-files"
        settings['output_folder_abs'] = os.path.abspath(settings['output_folder_rel'])
        settings['output_filename_html'] = settings['inputfile_baseroot'] + '-' + settings['timestamp'] + '.html'
        settings['output_filepath_html_rel'] = os.path.join(settings['output_folder_rel'], settings['output_filename_html'])
        settings['output_filepath_html_abs'] = os.path.abspath(settings['output_filepath_html_rel'])
        settings['output_filename_xml'] = settings['inputfile_baseroot'] + '-' + settings['timestamp'] + '.xml'
        settings['output_filepath_xml_rel'] = os.path.join(settings['output_folder_rel'], settings['output_filename_xml'])
        settings['output_filepath_xml_abs'] = os.path.abspath(settings['output_filepath_xml_rel'])
        settings['error_filename'] = settings['inputfile_baseroot'] + '-' + settings['timestamp'] + '.error.txt'
        settings['output_filepath_flat_ocf_rel'] = os.path.join(settings['output_folder_rel'], settings['inputfile_basename'] + "-ocf.xml")
        settings['output_filepath_flat_ocf_abs'] = os.path.abspath(settings['output_filepath_flat_ocf_rel'])
        settings['error_filepath_rel'] = os.path.join(settings['output_folder_rel'], settings['error_filename'])
        settings['error_filepath_abs'] = os.path.abspath(settings['error_filepath_rel'])
        
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
    input("I will convert %s to html. Press Enter to continue or CTRL-C to exit:" % settings['inputfile_basename'])
    if debugmode():
        print("main()")
    if not is_tool('calabash'):
        print('Did not detect calabash. Please install calabash and make it executable in the PATH:\n')
        print(os.environ['PATH']);
        print('Get calabash from http://xmlcalabash.com/ and install/extract somewhere on your system')
        if not is_tool('java'):
            print('Did not detect java. You need to install a java runtime environment with your package manager, as it is required to run the calabash jarfile.')
        print('Somewhere in your PATH, you need a script called "calabash", made executable, with the following contents:\n')
        print('''#!/bin/sh
java -jar /rooted/path/to/xmlcalabash-version.jar "$@"''')
    else:
        unpack_docx()
        run_pipeline()
            
#def is_odt_file():
#def is_docx_file():

def make_folder(folder):
    try:
        if not os.path.exists(folder):
            if debugmode():
                print("Make directory %s" % folder)
            os.makedirs(folder)
    except OSError:
        if debugmode():
            print ("Creation of the directory %s failed" % folder)
    else:
        if debugmode():
            print ("Successfully created the directory %s " % folder)
    
def unpack_docx():
    if debugmode():
        print("Unpacking file")
    global settings
    zipfile_path = settings['inputfile_normpath']
    target_folder = settings['extract_folder_abs']
    
    make_folder(target_folder)
    
    if os.path.exists(target_folder) and os.path.isdir(target_folder):
        if os.access(target_folder, os.W_OK):
            print("Extracting %s to %s" % (zipfile_path, target_folder))
            with zipfile.ZipFile(zipfile_path, 'r') as zf:
                zf.extractall(target_folder)
        else:
            if debugmode():
                print("Sorry, can't extract to %s, because there is no write permission.") % (target_folder)

def run_pipeline():
    global settings
    command_line_calabash = "calabash -p input_folder=%s output_xml=%s output_flat_ocf=%s %s" % (settings['extract_folder_abs'], settings['output_filepath_xml_abs'], settings['output_filepath_flat_ocf_abs'], settings['pipeline_path'])
    command_line_pygmentize_html = "pygmentize -l xml -O style=%s %s" % (settings['pygmentize_style'], settings['output_filepath_html_abs'])
    command_line_pygmentize_xml = "pygmentize -l xml -O style=%s %s" % (settings['pygmentize_style'], settings['output_filepath_xml_abs'])
    command_line_less = "less -R"
    command_line_preview_html = command_line_pygmentize_html + " | " + command_line_less
    command_line_preview_xml = command_line_pygmentize_xml + " | " + command_line_less
    args_calabash = shlex.split(command_line_calabash)
    output_folder = settings['output_folder_abs']
    make_folder(output_folder)
    timeout = 60
    run_time = 0
    print('Please wait while calabash is transforming %s with %s' % (settings['inputfile_basename'], settings['pipeline_filename']))
    time_begin = datetime.now()
    if debugmode():
        print("args_calabash:\n" + str(args_calabash))
        input("Press Enter to continue or CTRL-C to cancel")
    proc_calabash = subprocess.Popen(args_calabash, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=False)
    stdout_calabash,stderr_calabash = proc_calabash.communicate()
    time_end=None
    time_elapsed=None
    time_elapsed_seconds=None
    transformed_xml=None
    error_log=None
    while True:
        exitcode = proc_calabash.poll()
        if exitcode is None:
            print ("\n[%s]:\nProcess with PID: %d is still running..." % (datetime.now(), proc_calabash.pid))
            time.sleep(1)
            run_time += 1
            if run_time >= timeout:
                proc_calabash.kill()
        else:
            transformed_xml = stdout_calabash.decode("utf-8")
            error_log = stderr_calabash.decode("utf-8")
            time_end = datetime.now()
            time_elapsed = time_end - time_begin
            time_elapsed_seconds = time_elapsed.total_seconds()
            if exitcode == 0:
                print("\nThe document transformation has completed after %d seconds!" % (time_elapsed_seconds))

                # the html5 doctype is inserted with python, and the xml-transformation is appended.
                with open(settings['output_filepath_html_abs'], 'a') as htmlfile:
                     htmlfile.write("<!DOCTYPE html>\n")
                     htmlfile.write(transformed_xml)
                     htmlfile.close()
                print("\nPreview the xml file:\n%s\n" % command_line_preview_xml)
                print("Preview the html file:\n%s\n" % command_line_preview_html)
            else:
                print("The calabash process has terminated after %d seconds with an error status code: %d" % (time_elapsed_seconds, exitcode))
                print("Error log has been stored in: %s\nError:\n %s\n" % (settings['error_filename'], error_log))
            break;
    return
   
def check_args_ok():
    global settings
    # there has to be exactly two arguments
    # the second argument needs to be either a .docx file or a .odt file
    # possible to check the contents of the file also, not just the filename?
    if debugmode():
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
    message = """doc2jats.py:
Convert a .docx file to semantic html
Usage: doc2jats.py path/to/filename.docx
Converted files will be located in a folder called filename-files
"""
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

    from shutil import which
    return which(name) is not None

# running the program    
init()