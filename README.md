# dlm3ulp
A m3u-downloader designed for mass download from archive org

dlm3ulp.sh is a bash shell script. Start it from the directory where your m3u-files are residing.

* all m3us are being processed
* for each M3U (archive.org only!) the fourth filed of the URL is taken as album and a corresponding directory is created
* all MP3s are downloaded.

There is some logic to remove failed downloads and skip already existing files from prior downloads. So it should be safe to run dlm3ulp multiple times.
