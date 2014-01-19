/**
 * FLASHABLE ZIP
 * See http://android-dls.com/wiki/index.php?title=Generating_Keys
 */

$ cd easygis-updater-15/
$ 7za a -tzip ../easygis-updater-15.zip *
$ cd ..
$ jarsigner -verbose -keystore EasyGIS easygis-updater-15.zip cwm


