/**
 * Video Export
 * Simple video file exporter.
 * https://funprogramming.org/VideoExport-for-Processing
 * <p>
 * Copyright (c) 2017 Abe Pazos http://hamoid.com
 * <p>
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * <p>
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 * <p>
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA
 *
 * @author Abe Pazos http://hamoid.com
 * @modified 02/28/2018
 * @version 0.2.3 (23)
 */

package com.hamoid;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URISyntaxException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.swing.JOptionPane;

import com.sun.jna.platform.win32.Kernel32;
import com.sun.jna.platform.win32.Wincon;

import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PImage;
import processing.data.JSONArray;
import processing.data.JSONObject;
import processing.data.StringList;

/**
 * @example basic
 */

public class VideoExport {

    public final static String VERSION = "0.2.3";
    protected final static String SETTINGS_FFMPEG_PATH = "ffmpeg_path";
    protected final static String SETTINGS_CMD_ENCODE_VIDEO = "encode_video";
    protected final static String SETTINGS_CMD_ENCODE_AUDIO = "encode_audio";
    protected final static String FFMPEG_PATH_UNSET = "ffmpeg_path_unset";
    protected static JSONArray CMD_ENCODE_AUDIO_DEFAULT;
    protected static JSONArray CMD_ENCODE_VIDEO_DEFAULT;
    protected final String ffmpegMetadataComment = "Made with " +
            "Video Export for Processing - https://git.io/vAXLk";
    protected ProcessBuilder processBuilder;
    protected Process process;
    protected byte[] pixelsByte = null;
    protected int frameCount;
    protected boolean loadPixelsEnabled = true;
    protected boolean saveDebugInfo = true;
    protected String outputFilePath;
    protected String audioFilePath;
    protected PImage img;
    protected PApplet parent;
    protected int ffmpegCrfQuality;
    protected int ffmpegAudioBitRate;
    protected float ffmpegFrameRate;
    protected boolean ffmpegFound = false;
    protected File ffmpegOutputLog;
    protected OutputStream ffmpeg;
    protected JSONObject settings;
    protected String settingsPath;

    /**
     * Constructor, usually called in the setup() method in your sketch to
     * initialize and start the library.
     * <p>
     * Using a default movie file name (processing-movie.mp4).
     *
     * @param parent
     *            Pass "this" when constructing a VideoExport instance
     */
    public VideoExport(PApplet parent) {
        this(parent, "processing-movie.mp4", parent.g);
    }

    /**
     * Constructor that allows specifying a movie file name.
     *
     * @param parent
     *            Parent PApplet, normally "this" when called from setup()
     * @param outputFileName
     *            The name of the video file to produce, for instance
     *            "beauty.mp4"
     * @example basic
     */
    public VideoExport(PApplet parent, String outputFileName) {
        this(parent, outputFileName, parent.g);
    }

    /**
     * Constructor that allows to set a PImage to export as video (advanced)
     *
     * @param parent
     *            Parent PApplet, normally "this" when called from setup()
     * @param outputFileName
     *            The name of the video file to produce, for instance
     *            "beauty.mp4"
     * @param img
     *            PImage object to export as video (can be a PGraphics, Movie,
     *            Capture...)
     * @example usingPGraphics
     */
    public VideoExport(PApplet parent, final String outputFileName,
            PImage img) {

        parent.registerMethod("dispose", this);

        // // Disabling this, since it doesn't seem to help dispose()
        // // being called by Processing on shut down.

        // // dispose() workaround suggested at
        // // https://github.com/processing/processing/issues/4381

        // Runtime.getRuntime().addShutdownHook(new Thread() {
        // @Override public void run() { dispose(); }
        // });

        this.parent = parent;
        this.img = img;

        CMD_ENCODE_VIDEO_DEFAULT = new JSONArray(new StringList(
                new String[]{
                        "[ffmpeg]",                       // ffmpeg executable
                        "-y",                             // overwrite old file
                        "-f", "rawvideo",                 // format rgb raw
                        "-vcodec", "rawvideo",            // in codec rgb raw
                        "-s", "[width]x[height]",         // size
                        "-pix_fmt", "rgb24",              // pix format rgb24
                        "-r", "[fps]",                    // frame rate
                        "-i", "-",                        // pipe input
                        "-an",                            // no audio
                        "-vcodec", "h264",                // out codec h264
                        "-pix_fmt", "yuv420p",            // color space yuv420p
                        "-crf", "[crf]",                  // quality
                        "-metadata", "comment=[comment]", // comment
                        "[output]"                        // output file
                }));

        CMD_ENCODE_AUDIO_DEFAULT = new JSONArray(new StringList(
                new String[]{
                        "[ffmpeg]",                       // ffmpeg executable
                        "-y",                             // overwrite old file
                        "-i", "[inputvideo]",             // video file path
                        "-i", "[inputaudio]",             // audio file path
                        "-filter_complex", "[1:0]apad",   // pad with silence
                        "-shortest",                      // match shortest file
                        "-vcodec", "copy",                // don't reencode vid
                        "-acodec", "aac",                 // aac audio encoding
                        "-b:a", "[bitrate]k",             // bit rate (quality)
                        "-metadata", "comment=[comment]", // comment
                        // https://stackoverflow.com/questions/28586397/ffmpeg-error-while-re-encoding-video#28587897
                        "-strict", "-2",                  // enable aac
                        "[output]"                        // output file
                }));

        // settings = Preferences.userNodeForPackage(this.getClass());
        // The Preferences object does not work on Windows 10:
        // it requires fiddling with the registry to add a missing key.
        // Therefore I decided to find the location of VideoExport.jar in the
        // disk, and create a settings file two folders above (which is the root
        // folder of this library)
        try {
            File thisJar = new File(VideoExport.class.getProtectionDomain()
                    .getCodeSource().getLocation().toURI().getPath())
                            .getParentFile().getParentFile();
            settingsPath = thisJar.getAbsolutePath() + File.separator
                    + "settings.json";
            File settingsFile = new File(settingsPath);
            if (settingsFile.isFile()) {
                settings = parent.loadJSONObject(settingsPath);

                // Update config files from v0.2.2
                Object o;

                // If String, make it JSONArray
                o = settings.get(SETTINGS_CMD_ENCODE_VIDEO);
                if(o instanceof String) {
                    settings.setJSONArray(SETTINGS_CMD_ENCODE_VIDEO,
                            toJSONArray((String) o));
                }
                // If String, make it JSONArray
                o = settings.get(SETTINGS_CMD_ENCODE_AUDIO);
                if(o instanceof String) {
                    settings.setJSONArray(SETTINGS_CMD_ENCODE_AUDIO,
                            toJSONArray((String) o));
                }
            } else {
                settings = new JSONObject();
                settings.setJSONArray(SETTINGS_CMD_ENCODE_VIDEO,
                        CMD_ENCODE_VIDEO_DEFAULT);
                settings.setJSONArray(SETTINGS_CMD_ENCODE_AUDIO,
                        CMD_ENCODE_AUDIO_DEFAULT);
            }
        } catch (URISyntaxException e) {
            e.printStackTrace();
            System.err.println("Error loading settings.json");
        }

        outputFilePath = parent.sketchPath(outputFileName);
        ffmpegFrameRate = 30f;
        ffmpegCrfQuality = 15;
        ffmpegAudioBitRate = 128;
    }

    /**
     * Return the version of the library.
     *
     * @return String
     */
    public static String version() {
        return VERSION;
    }

    /**
     * Allow setting a new movie name, in case we want to export several movies,
     * one after the other.
     *
     * @param newMovieFileName
     *            String with file name of the new movie to create
     */
    public void setMovieFileName(final String newMovieFileName) {
        outputFilePath = parent.sketchPath(newMovieFileName);
    }

    public void setAudioFileName(final String audioFileName) {
        audioFilePath = parent.dataPath(audioFileName);
    }

    /**
     * Set the PImage element. Advanced use only. Optional.
     *
     * @param img
     *            A PImage object. Probably used for off-screen exporting..
     */
    public void setGraphics(PImage img) {
        this.img = img;
    }

    /**
     * Set the quality of the produced video file. Optional.
     *
     * @param crf
     *            Video quality. A value between 0 (high compression) and 100
     *            (high quality, lossless). Default is 70.
     * @param audioBitRate
     *            Audio quality (bit rate in kbps).
     *            128 is the default. 192 is very good.
     *            More than 256 does not make sense.
     *            Higher numbers produce heavier files.
     */
    public void setQuality(int crf, int audioBitRate) {
        if (ffmpeg != null) {
            System.err.println("Can't setQuality() after saveFrame()!");
            return;
        }
        if (crf > 100) {
            crf = 100;
        } else if (crf < 0) {
            crf = 0;
        }
        ffmpegCrfQuality = (100 - crf) / 2;
        ffmpegAudioBitRate = audioBitRate;
    }

    /**
     * Set the frame rate of the produced video file. Optional.
     *
     * @param frameRate
     *            The frame rate at which the resulting video file should be
     *            played. The default is 30, which is the recommended for online
     *            video.
     */
    public void setFrameRate(float frameRate) {
        if (ffmpeg != null) {
            System.err.println("Can't setFrameRate() after saveFrame()!");
            return;
        }
        ffmpegFrameRate = frameRate;
    }

    /**
     * You can tell VideoExport not to call loadPixels() internally.
     * Use it only if you already call loadPixels() in your program.
     * Useful to avoid calling it twice, which might hurt the
     * performance a bit. Optional.
     *
     * @param doLoadPixels
     *            Set to false to disable the internal loadPixels() call.
     */
    public void setLoadPixels(boolean doLoadPixels) {
        loadPixelsEnabled = doLoadPixels;
    }

    /**
     * Call this method to specify if you want a debug text file saved
     * together with the video file. The text file normally contains the
     * output messages from ffmpeg, which may be useful for diagnosing
     * problems. If video is being exported correctly you may want to
     * call videoExport.setDebugging(false) to avoid creating unnecessary
     * files. Optional.
     *
     * @param saveDebugFile
     *            Set to false to disable saving the ffmpeg output in a text
     *            file
     */
    public void setDebugging(boolean saveDebugFile) {
        saveDebugInfo = saveDebugFile;
    }

    /**
     * Advanced. You can use this if you want to change how ffmpeg behaves,
     * for example to add filters, custom encodings, or anything else you
     * could do with ffmpeg in the command line. See
     * https://forum.processing.org/two/discussion/22139/video-export-library-0-1-9
     * To find the default values find CMD_ENCODE_VIDEO_DEFAULT in
     * https://github.com/hamoid/video_export_processing/blob/master/src/com/hamoid/VideoExport.java
     *
     * @param newSettings An array with all the command line
     *                    arguments to call to produce a video.
     */
    public void setFfmpegVideoSettings(String[] newSettings) {
        settings.setJSONArray(SETTINGS_CMD_ENCODE_VIDEO,
                new JSONArray(new StringList(newSettings)));
    }

    /**
     * Advanced. You can use this if you want to change how ffmpeg behaves,
     * for example to add filters, custom encodings, or anything else you
     * could do with ffmpeg in the command line. See
     * https://forum.processing.org/two/discussion/22139/video-export-library-0-1-9
     * To find the default values find CMD_ENCODE_AUDIO_DEFAULT in
     * https://github.com/hamoid/video_export_processing/blob/master/src/com/hamoid/VideoExport.java
     *
     * @param newSettings An array with all the command line
     *                    arguments to call to produce a video.
     */
    public void setFfmpegAudioSettings(String[] newSettings) {
        settings.setJSONArray(SETTINGS_CMD_ENCODE_AUDIO,
                new JSONArray(new StringList(newSettings)));
    }

    /**
     * Adds one frame to the video file. The frame will be the content of the
     * display, or the content of a PImage if you specified one in the
     * constructor.
     */
    public void saveFrame() {
        if (img != null && img.width > 0) {
            if (!ffmpegFound) {
                return;
            }
            if (pixelsByte == null) {
                pixelsByte = new byte[img.pixelWidth * img.pixelHeight * 3];
            }
            if (loadPixelsEnabled) {
                img.loadPixels();
            }

            int byteNum = 0;
            for (final int px : img.pixels) {
                pixelsByte[byteNum++] = (byte) (px >> 16);
                pixelsByte[byteNum++] = (byte) (px >> 8);
                pixelsByte[byteNum++] = (byte) (px);
            }

            try {
                ffmpeg.write(pixelsByte);
                frameCount++;
            } catch (Exception e) {
                e.printStackTrace();
                err(ffmpegOutputLog);
            }
        }
    }

    /**
     * Make sure ffmpeg is found, then create a process
     * to run it.
     */
    protected void initialize() {
        // Get the saved ffmpeg path from the settings file
        // which maybe does not exist.
        String ffmpeg_path = getFfmpegPath();
        // If it did not exist, try to guess where it is
        if (ffmpeg_path.equals(FFMPEG_PATH_UNSET)) {
            String[] guess_paths = { "/usr/local/bin/ffmpeg",
                    "/usr/bin/ffmpeg" };
            for (String guess_path : guess_paths) {
                if ((new File(guess_path)).isFile()) {
                    ffmpeg_path = guess_path;
                    settings.setString(SETTINGS_FFMPEG_PATH, ffmpeg_path);
                    parent.saveJSONObject(settings, settingsPath);
                    break;
                }
            }
        } else {
            // If it did exist in the settings file,
            // check if the path is still valid
            // (maybe the user moved ffmpeg to a different folder)
            File ffmpegFile = new File(ffmpeg_path);
            if (!ffmpegFile.isFile()) {
                ffmpeg_path = FFMPEG_PATH_UNSET;
            }
        }
        // If it was not set, or if it was moved, ask the user where
        // to find ffmpeg. We will try to start after the user makes
        // a decision and onFfmpegSelected() is called.
        if (ffmpeg_path.equals(FFMPEG_PATH_UNSET)) {
            JOptionPane.showMessageDialog(parent.frame,
                    "The VideoExport library requires ffmpeg,\n"
                            + "a free command line tool.\n\n"
                            + "If you don't have ffmpeg yet:\n\n"
                            + "-- Windows / Mac --\n"
                            + "1. Download a static build from http://ffmpeg.org\n"
                            + "2. Unzip it\n\n" + "-- Linux --\n"
                            + "1. Install ffmpeg using your package manager\n\n"
                            + "-- When you already have ffmpeg --\n"
                            + "Click OK and select the ffmpeg or ffmpeg.exe program");

            // Show "select file" dialog
            parent.selectInput(
                    "Please select the previously downloaded ffmpeg or ffmpeg.exe executable",
                    "onFfmpegSelected", new File("/"), this);
        } else {
            // If it was found, all good. Start.
            startFfmpeg(ffmpeg_path);
        }
    }

    /**
     * Call this function to figure out how many frames your movie has so far.
     *
     * @return the number of frames added to the movie so far
     */
    public int getCurrentFrame() {
        return frameCount;
    }

    /**
     * You could use the returned value to display a time counter, a progress
     * bar or to create periodic motion, for instance by feeding
     * the returned value into the sin() function, and using the result to drive
     * the position of an object.
     *
     * @return the duration of the movie (so far) in seconds
     */
    public float getCurrentTime() {
        return frameCount / ffmpegFrameRate;
    }

    /**
     * Call this if you need to figure out the path to the ffmpeg program
     * (advanced).
     *
     * @return the path to the ffmpeg program as a String
     */
    public String getFfmpegPath() {
        return settings.getString(SETTINGS_FFMPEG_PATH, FFMPEG_PATH_UNSET);
    }

    /**
     * Call this method if you know the path to ffmpeg on your computer
     * (advanced).
     * @param path
     */
    public void setFfmpegPath(String path) {
        settings.setString(SETTINGS_FFMPEG_PATH, path);
        parent.saveJSONObject(settings, settingsPath);
    }

    /**
     * Makes the library forget about where the ffmpeg binary was located.
     * Useful if you moved ffmpeg to a different location. After calling this
     * function the library will ask you again for the location of ffmpeg.
     * Optional.
     */
    public void forgetFfmpegPath() {
        settings.setString(SETTINGS_FFMPEG_PATH, FFMPEG_PATH_UNSET);
        parent.saveJSONObject(settings, settingsPath);
    }

    /**
     * Called internally by the file selector when the user chooses
     * the location of ffmpeg on the disk.
     *
     * @param selection
     *            (internal)
     */
    public void onFfmpegSelected(File selection) {
        if (selection == null) {
            System.err.println(
                    "The VideoExport library requires ffmpeg but it was not found. "
                            + "Please try again or read the library documentation.");
        } else {
            String ffmpeg_path = selection.getAbsolutePath();
            System.out.println("ffmpeg selected at " + ffmpeg_path);
            settings.setString(SETTINGS_FFMPEG_PATH, ffmpeg_path);
            parent.saveJSONObject(settings, settingsPath);
            startFfmpeg(ffmpeg_path);
        }
    }

    // ffmpeg -i input -c:v libx264 -crf 20 -maxrate 400k -bufsize 1835k
    // output.mp4 -profile:v baseline -level 3.0
    // https://trac.ffmpeg.org/wiki/Encode/H.264#Compatibility
    protected void startFfmpeg(String executable) {
        // -y = overwrite, otherwise it fails the second time you run
        // -an = no audio
        // "-b:v", "3000k" = video bit rate
        // "-i", "-" = pipe:0

        if (img.pixelWidth == 0 || img.pixelHeight == 0) {
            err("The export image size is 0!");
        }

        if (img.pixelWidth % 2 == 1 || img.pixelHeight % 2 == 1) {
            err("Width and height can only be even numbers when using the h264 encoder\n"
                    + "but the requested image size is " + img.pixelWidth + "x"
                    + img.pixelHeight);
        }

        // Get command as JSONArray
        JSONArray cmd;
        try {
            cmd = settings.getJSONArray(SETTINGS_CMD_ENCODE_VIDEO);
        } catch (RuntimeException e) {
            cmd = CMD_ENCODE_VIDEO_DEFAULT;
        }
        // JSONArray -> String[]
        String[] cmdArgs = cmd.getStringArray();
        // Replace variables. I first split, then replace (instead of
        // replace, then split) because the replacement may contain spaces.
        // For instance the comment would be split into parts and
        // break the command.
        for (int i = 0; i < cmdArgs.length; i++) {
            if (cmdArgs[i].contains("[")) {
                cmdArgs[i] = cmdArgs[i]
                        .replace("[ffmpeg]", executable)
                        .replace("[width]", "" + img.pixelWidth)
                        .replace("[height]", "" + img.pixelHeight)
                        .replace("[fps]", "" + ffmpegFrameRate)
                        .replace("[crf]", "" + ffmpegCrfQuality)
                        .replace("[comment]", ffmpegMetadataComment)
                        .replace("[output]", outputFilePath);
            }

        }
        processBuilder = new ProcessBuilder(cmdArgs);
        processBuilder.redirectErrorStream(true);
        ffmpegOutputLog = new File(parent.sketchPath("ffmpeg.txt"));
        processBuilder.redirectOutput(ffmpegOutputLog);
        processBuilder.redirectInput(ProcessBuilder.Redirect.PIPE);
        try {
            process = processBuilder.start();
        } catch (Exception e) {
            e.printStackTrace();
            err(ffmpegOutputLog);
        }

        ffmpeg = process.getOutputStream();
        ffmpegFound = true;
        frameCount = 0;
    }

    public void startMovie() {
        initialize();
    }

    /**
     * Called to end exporting a movie before exiting our program, or before
     * exporting a new movie.
     */
    public void endMovie() {
        if (ffmpeg != null) {
            try {
                ffmpeg.flush();
                ffmpeg.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            ffmpeg = null;
        }
        if (process != null) {
            try {
                // Delay to avoid creating corrupted video files.
                // Probably not useful: Thread.sleep(500);
                // Using a different approach now, by sending the
                // CTRL+C keys to ffmpeg if using Windows.

                if (PApplet.platform == PConstants.WINDOWS) {
                    // Launch tasklist
                    ProcessBuilder ps = new ProcessBuilder("tasklist");
                    Process pr = ps.start();

                    // Get all processes from tasklist
                    BufferedReader allProcesses = new BufferedReader(
                            new InputStreamReader(pr.getInputStream()));
                    // Regex to find the word "ffmpeg.exe"
                    Pattern isFfmpeg = Pattern
                            .compile("ffmpeg\\.exe.*?([0-9]+)");
                    String processDetails;
                    // Iterate over all processes
                    while ((processDetails = allProcesses.readLine()) != null) {
                        Matcher m = isFfmpeg.matcher(processDetails);
                        // Check if this process is ffmpeg.exe
                        if (m.find()) {
                            // If it is, send it CTRL+C to stop it
                            Wincon wincon = Kernel32.INSTANCE;
                            wincon.GenerateConsoleCtrlEvent(Wincon.CTRL_C_EVENT,
                                    Integer.parseInt(m.group(1)));
                            break;
                        }
                    }
                } else {
                    // In Linux and Mac tell the process to end
                    process.destroy();
                }

                process.waitFor();

                if (audioFilePath != null && !audioFilePath.isEmpty()) {
                    attachSound();
                    audioFilePath = null;
                }

                if (!saveDebugInfo && ffmpegOutputLog.isFile()) {
                    ffmpegOutputLog.delete();
                    ffmpegOutputLog = null;
                }

                PApplet.println(outputFilePath, "saved.");
            } catch (InterruptedException e) {
                PApplet.println("Waiting for ffmpeg timed out!");
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            processBuilder = null;
            process = null;
        }
    }

    protected void attachSound() {
        // Add sound to outputFilePath (crop at shortest)
        // ffmpeg -i video.avi -i audio.mp3 -codec copy -shortest output.avi

        // if sound is shorter, pad with silence
        // ffmpeg -i videofile.mp4 -i audiofile.wav -filter_complex " [1:0] apad
        // " -shortest output.mp4

        // Fade in/out. Works with ffmpeg 2.5.2.
        // Fade in and fade out both for the duration of 3 seconds.
        // ffmpeg -i audio.mp3 -af 'afade=t=in:ss=0:d=3,afade=t=out:st=27:d=3'
        // out.mp3

        // Specify length in frames (-t for seconds)
        // If source audio is mp3 or aac, use acodec copy
        // ffmpeg -i videofile.mp4 -i audiofile.wav -vframes 260 -vcodec copy
        // -acodec copy output.mp4

        // Check if the sound file exists and is a regular file (not a
        // directory)
        File audioPath = new File(audioFilePath);
        if (!audioPath.exists() || !audioPath.isFile()) {
            System.err.println("The file " + audioFilePath
                    + " was not found or is not a regular file.");
            return;
        }

        // Get command as JSONArray
        JSONArray cmd;
        try {
            cmd = settings.getJSONArray(SETTINGS_CMD_ENCODE_AUDIO);
        } catch (RuntimeException e) {
            cmd = CMD_ENCODE_AUDIO_DEFAULT;
        }
        // JSONArray -> String[]
        String[] cmdArgs = cmd.getStringArray();

        String tmpAudioFile = "temp-with-audio.mp4";

        // Replace variables. I first split, then replace (instead of
        // replace, then split) because the replacement may contain spaces.
        // For instance the comment would be split into parts and
        // break the command.
        for (int i = 0; i < cmdArgs.length; i++) {
            if (cmdArgs[i].contains("[")) {
                cmdArgs[i] = cmdArgs[i]
                        .replace("[ffmpeg]", getFfmpegPath())
                        .replace("[inputvideo]", outputFilePath)
                        .replace("[inputaudio]", audioFilePath)
                        .replace("[bitrate]", "" + ffmpegAudioBitRate)
                        .replace("[comment]", ffmpegMetadataComment)
                        .replace("[output]",
                                parent.sketchFile(tmpAudioFile)
                                        .getAbsolutePath());
            }
        }

        processBuilder = new ProcessBuilder(cmdArgs);
        processBuilder.redirectErrorStream(true);
        File ffmpegOutputLogAudio = new File(
                parent.sketchPath("ffmpeg-audio.txt"));
        processBuilder.redirectOutput(ffmpegOutputLogAudio);

        try {
            process = processBuilder.start();
        } catch (IOException e) {
            e.printStackTrace();
            err(ffmpegOutputLogAudio);
        }

        if (process != null) {
            try {
                // wait until done
                process.waitFor();
                new File(outputFilePath).delete();
                parent.sketchFile(tmpAudioFile)
                        .renameTo(new File(outputFilePath));
            } catch (InterruptedException e) {
                PApplet.println(
                        "Waiting for ffmpeg while adding audio timed out!");
                e.printStackTrace();
            }
        }
        if (!saveDebugInfo && ffmpegOutputLogAudio.isFile()) {
            ffmpegOutputLogAudio.delete();
        }
        processBuilder = null;
        process = null;

    }

    /**
     * Called automatically by Processing to clean up before shut down
     */
    public void dispose() {
        endMovie();
    }

    private static JSONArray toJSONArray(String s) {
        return new JSONArray(new StringList(s.split(" ")));
    }

    protected void err(String msg) {
        System.err.println("\nVideoExport error: " + msg + "\n");
        System.exit(1);
    }

    protected void err(File f) {
        err("Ffmpeg failed. Study " + f + " for more details.");
    }

}
