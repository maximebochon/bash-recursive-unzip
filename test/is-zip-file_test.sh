#!/usr/bin/env bash
# vim:et:ft=sh:sts=2:sw=2

#echo -n "Loading unzzzip.sh: "
TESTING=true . ../unzzzip.sh
#echo "done"

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
  echo -n "${FUNCNAME[0]}: " \
  && echo NOT IMPLEMENTED YET #
}

testBinaryFile() {
  echo -n "${FUNCNAME[0]}: " \
  && echo NOT IMPLEMENTED YET #
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
testJarFile
testWarFile
testEarFile

testTarArchive
testBinaryFile
testTextFile
testDirectory
testNoArgument
testMoreArguments

