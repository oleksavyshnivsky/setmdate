# setmdate
Set older Modify timestamp for multiple files

## "Problem"
Say, you want to have all the files in some folder (including subfolders) to look like they were not accessed or modified after a certain date. You can use this script to reset all newer Access and Modify timestamps to that date (without changing Time part of those timestamps — hh:mm:ss.ns are preserved).

## Usage: 
sh setmdate.sh \[maxdate \[ root \[ filenamepattern \]\]\]

- maxdate — the latest allowed date. Format: Any string that can be parsed into a date by bash (for example, 1999-12-31). Default: 'yesterday'
- root — directory in which the target files are located. Default: '.'
- filenamepattern — files for which Access and Modify timestamps must be changed. Default: '\*' ('.' and this .sh file are always excluded)

## Algorithm
For each file in the results of <code>find "$ROOT" -name "$FILENAMEPATTERN" -not -name '.' -not -name "$0"</code>:
  - if the date in Access timestamp is newer than <code>maxdate</code> — reset the date in Access timestamp to <code>maxdate</code>
  - if the date in Modify timestamp is newer than <code>maxdate</code> — reset the date in Modify timestamp to <code>maxdate</code>

## Special notes
- Script must by run with appropriate privileges (owner or read/write access).
- Changing Access and Modify timestamps leads to automatic change of Change timestamp. If you want to reset it to <code>maxdate</code> too, change your system date before running this script.
