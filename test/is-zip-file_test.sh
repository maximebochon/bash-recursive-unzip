#!/usr/bin/env bash
# vim:et:ft=sh:sts=2:sw=2

# Loading 'is_zip_file' function
# from 'unzzzip.sh' in test mode:
TESTING=true . ../unzzzip.sh

testZipFile() {
  echo -n "${FUNCNAME[0]}: " \
  && cd $(mktemp --directory) \
  && touch "file1_for_zip"     \
  && touch "file2_for_zip"      \
  && zip -q "file" *"for_zip"   \
  && is_zip_file "file.zip"    \
  && mv "file.zip" "file"     \
  && is_zip_file "file"      \
  && echo OK || echo KO    #
}

testZZZipFile() {
  echo -n "${FUNCNAME[0]}: "         \
  && cd $(mktemp --directory)         \
  && touch "file1" "file2"             \
  && zip -q "file" "file1" "file2"      \
  && zip -q "ffile" "file1" "file.zip"   \
  && zip -q "fffile"                     \
         "file2" "file.zip" "ffile.zip" \
  && is_zip_file "fffile.zip"         \
  && mv "fffile.zip" "fffile"      \
  && is_zip_file "fffile"       \
  && echo OK || echo KO     #
}

testJarFile() {
  echo -n "${FUNCNAME[0]}: "    \
  && cd $(mktemp --directory)    \
  && touch "a.class"              \
  && touch "b.class"               \
  && touch "c.xml"                  \
  && jar cf "file.jar" *.class *.xml \
  && is_zip_file "file.jar"          \
  && mv "file.jar" "file"           \
  && is_zip_file "file"            \
  && echo OK || echo KO          #
}

testWarFile() {
  echo -n "${FUNCNAME[0]}: " \
  && echo NOT IMPLEMENTED YET #
}

testEarFile() {
  echo -n "${FUNCNAME[0]}: " \
  && echo NOT IMPLEMENTED YET #
}

testTarArchive() {
  echo -n "${FUNCNAME[0]}: "   \
  && cd $(mktemp --directory)   \
  && touch "file1_for_tar"       \
  && touch "file2_for_tar"        \
  && tar cf "file.tar" *"for_tar"  \
  && ! is_zip_file "file.tar"      \
  && mv "file.tar" "file"         \
  && ! is_zip_file "file"       \
  && echo OK || echo KO       #
}

testBinaryFile() {
  echo -n "${FUNCNAME[0]}: "           \
  && cd $(mktemp --directory)           \
  && echo "0000" > "file.bin"            \
  && dd bs="1" count="1024" status="none" \
        if="/dev/urandom" >> "file.bin"   \
  && ! is_zip_file "file.bin"            \
  && mv "file.bin" "file"              \
  && ! is_zip_file "file"           \
  && echo OK || echo KO         #
}

testTextFile() {
  echo -n "${FUNCNAME[0]}: "     \
  && cd $(mktemp --directory)     \
  && touch "file.txt"              \
  && echo "some text" >> "file.txt" \
  && echo "some more" >> "file.txt" \
  && ! is_zip_file "file.txt"      \
  && mv "file.txt" "file"         \
  && ! is_zip_file "file"        \
  && echo OK || echo KO        #
}

testDirectory() {
  echo -n "${FUNCNAME[0]}: "  \
  && cd $(mktemp --directory)  \
  && mkdir "directory"          \
  && touch "file1_for_zip"       \
  && touch "file2_for_zip"        \
  && zip -q "zip_file" *"for_zip"  \
  && mv "zip_file.zip" "directory" \
  && ! is_zip_file "directory"    \
  && echo OK || echo KO         #
}

testNoArgument() {
  echo -n "${FUNCNAME[0]}: " \
  && ! is_zip_file           \
  && echo OK || echo KO      #
}

testMoreArguments() {
  echo -n "${FUNCNAME[0]}: "           \
  && ! is_zip_file "arg1" "arg2"        \
  && ! is_zip_file "arg1" "arg2" "arg3" \
  && echo OK || echo KO                #
}


testZipFile
testZZZipFile
testJarFile
testWarFile
testEarFile

testTarArchive
testBinaryFile
testTextFile
testDirectory
testNoArgument
testMoreArguments

