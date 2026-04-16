#!/bin/bash
# Create try-it .xq files for bin: and file: modules
BASE="/Users/wicentowskijc/workspace/documentation-next/data/try-it"

write_xq() {
    local prefix="$1" fn="$2" arity="$3" content="$4"
    local dir="$BASE/$prefix/$fn/$arity"
    local file="$dir/${prefix}_${fn}_${arity}.xq"
    mkdir -p "$dir"
    echo "$content" > "$file"
}

# =============================
# bin: module (binary data)
# =============================

write_xq bin hex 1 '(: Convert hex string to binary :)
let $data := bin:hex("48656C6C6F")
return bin:decode-string($data, "UTF-8")'

write_xq bin octal 1 '(: Convert octal string to binary :)
let $data := bin:octal("110145154154157")
return bin:decode-string($data, "UTF-8")'

write_xq bin bin 1 '(: Convert binary (base-2) string to binary data :)
let $data := bin:bin("01001000011001010110110001101100011011110")
return bin:decode-string($data, "UTF-8")'

write_xq bin encode-string 1 '(: Encode a string as binary using default UTF-8 :)
let $data := bin:encode-string("Hello, World!")
return xs:hexBinary($data)'

write_xq bin encode-string 2 '(: Encode a string as binary using a specific encoding :)
let $data := bin:encode-string("Héllo", "ISO-8859-1")
return xs:hexBinary($data)'

write_xq bin decode-string 1 '(: Decode binary to string using default UTF-8 :)
let $binary := bin:hex("48656C6C6F")
return bin:decode-string($binary, "UTF-8")'

write_xq bin decode-string 2 '(: Decode binary to string with encoding :)
let $binary := bin:hex("48E96C6C6F")
return bin:decode-string($binary, "ISO-8859-1")'

write_xq bin decode-string 3 '(: Decode a portion of binary to string :)
let $binary := bin:hex("48656C6C6F20576F726C64")
return bin:decode-string($binary, "UTF-8", 6, 5)'

write_xq bin decode-string 4 '(: Decode binary with offset and length :)
let $binary := bin:encode-string("Hello World!")
return bin:decode-string($binary, "UTF-8", 0, 5)'

write_xq bin length 1 '(: Get the length of binary data in octets :)
let $data := bin:encode-string("Hello")
return bin:length($data) || " octets"'

write_xq bin part 2 '(: Extract a subsequence of binary data starting at offset :)
let $data := bin:encode-string("Hello World")
let $part := bin:part($data, 6)
return bin:decode-string($part, "UTF-8")'

write_xq bin part 3 '(: Extract a fixed-length portion of binary data :)
let $data := bin:encode-string("Hello World")
let $part := bin:part($data, 0, 5)
return bin:decode-string($part, "UTF-8")'

write_xq bin join 1 '(: Concatenate multiple binary values :)
let $hello := bin:encode-string("Hello")
let $space := bin:encode-string(" ")
let $world := bin:encode-string("World")
let $joined := bin:join(($hello, $space, $world))
return bin:decode-string($joined, "UTF-8")'

write_xq bin insert-before 3 '(: Insert binary data at a specific position :)
let $original := bin:encode-string("Hllo")
let $insert := bin:encode-string("e")
let $result := bin:insert-before($original, 1, $insert)
return bin:decode-string($result, "UTF-8")'

write_xq bin find 3 '(: Find the position of a byte sequence within binary data :)
let $data := bin:encode-string("Hello World Hello")
let $search := bin:encode-string("World")
return bin:find($data, 0, $search)'

write_xq bin pad-left 2 '(: Pad binary data on the left to a specified size :)
let $data := bin:hex("FF")
let $padded := bin:pad-left($data, 4)
return xs:hexBinary($padded)'

write_xq bin pad-left 3 '(: Pad binary data on the left with a specific byte :)
let $data := bin:hex("FF")
let $padded := bin:pad-left($data, 4, 170)
return xs:hexBinary($padded)'

write_xq bin pad-right 2 '(: Pad binary data on the right to a specified size :)
let $data := bin:hex("FF")
let $padded := bin:pad-right($data, 4)
return xs:hexBinary($padded)'

write_xq bin pad-right 3 '(: Pad binary data on the right with a specific byte :)
let $data := bin:hex("FF")
let $padded := bin:pad-right($data, 4, 170)
return xs:hexBinary($padded)'

write_xq bin pack-integer 2 '(: Pack an integer into binary with specified byte count :)
(
    "255 as 1 byte: " || xs:hexBinary(bin:pack-integer(255, 1)),
    "255 as 2 bytes: " || xs:hexBinary(bin:pack-integer(255, 2)),
    "65535 as 2 bytes: " || xs:hexBinary(bin:pack-integer(65535, 2))
)'

write_xq bin pack-integer 3 '(: Pack integer with specified byte order :)
(
    "Big-endian: " || xs:hexBinary(bin:pack-integer(256, 2, "most-significant-first")),
    "Little-endian: " || xs:hexBinary(bin:pack-integer(256, 2, "least-significant-first"))
)'

write_xq bin unpack-integer 3 '(: Unpack a signed integer from binary data :)
let $data := bin:hex("00FF")
return bin:unpack-integer($data, 0, 2)'

write_xq bin unpack-integer 4 '(: Unpack integer with byte order :)
let $data := bin:hex("0100")
return (
    "Big-endian: " || bin:unpack-integer($data, 0, 2, "most-significant-first"),
    "Little-endian: " || bin:unpack-integer($data, 0, 2, "least-significant-first")
)'

write_xq bin unpack-unsigned-integer 3 '(: Unpack an unsigned integer from binary :)
let $data := bin:hex("FF")
return bin:unpack-unsigned-integer($data, 0, 1)'

write_xq bin unpack-unsigned-integer 4 '(: Unpack unsigned integer with byte order :)
let $data := bin:hex("FFFF")
return bin:unpack-unsigned-integer($data, 0, 2, "most-significant-first")'

write_xq bin pack-double 1 '(: Pack a double-precision float into binary :)
xs:hexBinary(bin:pack-double(3.14))'

write_xq bin pack-double 2 '(: Pack double with byte order :)
(
    "Big-endian: " || xs:hexBinary(bin:pack-double(3.14, "most-significant-first")),
    "Little-endian: " || xs:hexBinary(bin:pack-double(3.14, "least-significant-first"))
)'

write_xq bin unpack-double 2 '(: Unpack a double from binary data :)
let $packed := bin:pack-double(3.14)
return bin:unpack-double($packed, 0)'

write_xq bin unpack-double 3 '(: Unpack double with byte order :)
let $packed := bin:pack-double(2.718, "most-significant-first")
return bin:unpack-double($packed, 0, "most-significant-first")'

write_xq bin pack-float 1 '(: Pack a single-precision float into binary :)
xs:hexBinary(bin:pack-float(3.14))'

write_xq bin pack-float 2 '(: Pack float with byte order :)
xs:hexBinary(bin:pack-float(3.14, "most-significant-first"))'

write_xq bin unpack-float 2 '(: Unpack a float from binary :)
let $packed := bin:pack-float(3.14)
return bin:unpack-float($packed, 0)'

write_xq bin unpack-float 3 '(: Unpack float with byte order :)
let $packed := bin:pack-float(1.5, "most-significant-first")
return bin:unpack-float($packed, 0, "most-significant-first")'

write_xq bin to-octets 1 '(: Convert binary data to a sequence of octets (integers 0-255) :)
let $data := bin:encode-string("ABC")
return bin:to-octets($data)'

write_xq bin from-octets 1 '(: Create binary data from a sequence of octets :)
let $octets := (72, 101, 108, 108, 111)
let $data := bin:from-octets($octets)
return bin:decode-string($data, "UTF-8")'

write_xq bin and 2 '(: Bitwise AND of two binary values :)
let $a := bin:hex("FF0F")
let $b := bin:hex("0FF0")
return xs:hexBinary(bin:and($a, $b))'

write_xq bin or 2 '(: Bitwise OR of two binary values :)
let $a := bin:hex("FF00")
let $b := bin:hex("00FF")
return xs:hexBinary(bin:or($a, $b))'

write_xq bin xor 2 '(: Bitwise XOR of two binary values :)
let $a := bin:hex("FFFF")
let $b := bin:hex("0F0F")
return xs:hexBinary(bin:xor($a, $b))'

write_xq bin not 1 '(: Bitwise NOT (complement) of binary data :)
let $data := bin:hex("0F0F")
return xs:hexBinary(bin:not($data))'

write_xq bin shift 2 '(: Shift binary data left (positive) or right (negative) :)
let $data := bin:hex("01")
return (
    "Original:    " || xs:hexBinary($data),
    "Shift left 4:  " || xs:hexBinary(bin:shift($data, 4)),
    "Shift right 4: " || xs:hexBinary(bin:shift($data, -4))
)'

# =============================
# file: module (filesystem)
# =============================

write_xq file base-dir 0 '(: Get the base directory of the running query :)
file:base-dir()'

write_xq file current-dir 0 '(: Get the current working directory :)
file:current-dir()'

write_xq file temp-dir 0 '(: Get the system temporary directory :)
file:temp-dir()'

write_xq file dir-separator 0 '(: Get the platform directory separator :)
file:dir-separator()'

write_xq file line-separator 0 '(: Get the platform line separator :)
"Line separator codepoints: " ||
    string-join(string-to-codepoints(file:line-separator()) ! string(.), ", ")'

write_xq file path-separator 0 '(: Get the platform path separator (: on Unix, ; on Windows) :)
file:path-separator()'

write_xq file list-roots 0 '(: List filesystem root directories :)
file:list-roots()'

write_xq file exists 1 '(: Check if a file or directory exists :)
(
    file:temp-dir() || " exists: " || file:exists(file:temp-dir()),
    "/nonexistent exists: " || file:exists("/nonexistent")
)'

write_xq file is-dir 1 '(: Check if a path is a directory :)
(
    file:temp-dir() || " is-dir: " || file:is-dir(file:temp-dir())
)'

write_xq file is-file 1 '(: Check if a path is a file :)
let $tmp := file:temp-dir()
return
    $tmp || " is-file: " || file:is-file($tmp)'

write_xq file is-absolute 1 '(: Check if a path is absolute :)
(
    "is-absolute(/tmp): " || file:is-absolute("/tmp"),
    "is-absolute(relative): " || file:is-absolute("relative/path")
)'

write_xq file name 1 '(: Get the filename from a path :)
(
    file:name("/home/user/document.xml"),
    file:name("/home/user/"),
    file:name("file.txt")
)'

write_xq file parent 1 '(: Get the parent directory of a path :)
file:parent("/home/user/document.xml")'

write_xq file resolve-path 1 '(: Resolve a path against the current directory :)
file:resolve-path(".")'

write_xq file resolve-path 2 '(: Resolve a path against a base directory :)
file:resolve-path("docs/readme.txt", "/home/user")'

write_xq file path-to-native 1 '(: Convert a URI path to native OS path :)
file:path-to-native(file:temp-dir())'

write_xq file path-to-uri 1 '(: Convert a path to a file:// URI :)
file:path-to-uri(file:temp-dir())'

write_xq file size 1 '(: Get the size of a file in bytes :)
let $tmp := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text($tmp, "Hello World!")
let $sz := file:size($tmp)
let $_ := file:delete($tmp)
return "File size: " || $sz || " bytes"'

write_xq file size 2 '(: Get the size of a directory entry :)
let $tmp := file:temp-dir()
return "Temp dir path: " || $tmp'

write_xq file last-modified 1 '(: Get the last-modified timestamp of a file :)
let $tmp := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text($tmp, "test")
let $mod := file:last-modified($tmp)
let $_ := file:delete($tmp)
return "Last modified: " || $mod'

write_xq file create-dir 1 '(: Create a directory (including parents) :)
let $dir := file:temp-dir() || "tryit-test-" || generate-id(<x/>)
let $_ := file:create-dir($dir)
let $exists := file:is-dir($dir)
let $_ := file:delete($dir)
return "Created and verified: " || $exists'

write_xq file create-temp-dir 2 '(: Create a temporary directory :)
let $dir := file:create-temp-dir("tryit", ".d")
let $exists := file:is-dir($dir)
let $_ := file:delete($dir)
return "Temp dir: " || $dir || " (existed: " || $exists || ")"'

write_xq file create-temp-dir 3 '(: Create temp directory in a specific parent :)
let $dir := file:create-temp-dir("tryit", ".d", file:temp-dir())
let $_ := file:delete($dir)
return "Created in: " || file:parent($dir)'

write_xq file create-temp-file 2 '(: Create a temporary file :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text($f, "Hello!")
let $content := file:read-text($f)
let $_ := file:delete($f)
return "Temp file content: " || $content'

write_xq file create-temp-file 3 '(: Create temp file in a specific directory :)
let $f := file:create-temp-file("tryit", ".txt", file:temp-dir())
let $_ := file:delete($f)
return "Created: " || file:name($f)'

write_xq file write-text 2 '(: Write text to a file :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text($f, "Hello from XQuery!")
let $content := file:read-text($f)
let $_ := file:delete($f)
return content'

write_xq file write-text 3 '(: Write text with specific encoding :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text($f, "Héllo", "ISO-8859-1")
let $content := file:read-text($f, "ISO-8859-1")
let $_ := file:delete($f)
return $content'

write_xq file read-text 1 '(: Read text from a file :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text($f, "XQuery is powerful!")
let $text := file:read-text($f)
let $_ := file:delete($f)
return $text'

write_xq file read-text 2 '(: Read text with encoding :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text($f, "Héllo Wörld", "UTF-8")
let $text := file:read-text($f, "UTF-8")
let $_ := file:delete($f)
return $text'

write_xq file read-text-lines 1 '(: Read lines from a text file :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text-lines($f, ("Line 1", "Line 2", "Line 3"))
let $lines := file:read-text-lines($f)
let $_ := file:delete($f)
return
    for $line at $n in $lines
    return $n || ": " || $line'

write_xq file write-text-lines 2 '(: Write multiple lines to a file :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text-lines($f, ("apple", "banana", "cherry"))
let $content := file:read-text($f)
let $_ := file:delete($f)
return $content'

write_xq file append-text 2 '(: Append text to an existing file :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text($f, "Hello")
let $_ := file:append-text($f, " World!")
let $content := file:read-text($f)
let $_ := file:delete($f)
return $content'

write_xq file append-text-lines 2 '(: Append lines to an existing file :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text-lines($f, ("first", "second"))
let $_ := file:append-text-lines($f, ("third", "fourth"))
let $lines := file:read-text-lines($f)
let $_ := file:delete($f)
return $lines'

write_xq file write-binary 2 '(: Write binary data to a file :)
let $f := file:create-temp-file("tryit", ".bin")
let $data := bin:encode-string("Binary content!")
let $_ := file:write-binary($f, $data)
let $read := file:read-binary($f)
let $_ := file:delete($f)
return bin:decode-string($read, "UTF-8")'

write_xq file read-binary 1 '(: Read binary data from a file :)
let $f := file:create-temp-file("tryit", ".bin")
let $_ := file:write-binary($f, bin:hex("DEADBEEF"))
let $data := file:read-binary($f)
let $_ := file:delete($f)
return xs:hexBinary($data)'

write_xq file children 1 '(: List children of a directory :)
let $dir := file:create-temp-dir("tryit", ".d")
let $_ := file:write-text($dir || "/a.txt", "a")
let $_ := file:write-text($dir || "/b.txt", "b")
let $children := file:children($dir)
let $_ := file:delete($dir, true())
return
    for $c in $children
    return file:name($c)'

write_xq file list 1 '(: List files in a directory :)
let $dir := file:create-temp-dir("tryit", ".d")
let $_ := file:write-text($dir || "/test.txt", "test")
let $_ := file:write-text($dir || "/data.xml", "<data/>")
let $files := file:list($dir)
let $_ := file:delete($dir, true())
return $files'

write_xq file list 2 '(: List files matching a pattern :)
let $dir := file:create-temp-dir("tryit", ".d")
let $_ := (file:write-text($dir || "/a.txt", "a"),
           file:write-text($dir || "/b.xml", "b"),
           file:write-text($dir || "/c.txt", "c"))
let $txt-files := file:list($dir, false(), "*.txt")
let $_ := file:delete($dir, true())
return $txt-files'

write_xq file copy 2 '(: Copy a file :)
let $src := file:create-temp-file("tryit-src", ".txt")
let $dst := file:temp-dir() || "tryit-dst-" || generate-id(<x/>) || ".txt"
let $_ := file:write-text($src, "Original content")
let $_ := file:copy($src, $dst)
let $content := file:read-text($dst)
let $_ := (file:delete($src), file:delete($dst))
return "Copied: " || $content'

write_xq file move 2 '(: Move (rename) a file :)
let $src := file:create-temp-file("tryit-mv", ".txt")
let $dst := file:temp-dir() || "tryit-moved-" || generate-id(<x/>) || ".txt"
let $_ := file:write-text($src, "Moved content")
let $_ := file:move($src, $dst)
let $content := file:read-text($dst)
let $src-exists := file:exists($src)
let $_ := file:delete($dst)
return "Content: " || $content || ", source gone: " || not($src-exists)'

write_xq file delete 1 '(: Delete a file :)
let $f := file:create-temp-file("tryit", ".txt")
let $_ := file:write-text($f, "delete me")
let $existed := file:exists($f)
let $_ := file:delete($f)
return "Existed: " || $existed || ", Deleted: " || not(file:exists($f))'

write_xq file delete 2 '(: Delete a directory recursively :)
let $dir := file:create-temp-dir("tryit", ".d")
let $_ := file:write-text($dir || "/file.txt", "test")
let $_ := file:create-dir($dir || "/subdir")
let $_ := file:delete($dir, true())
return "Deleted: " || not(file:exists($dir))'

write_xq file descendants 1 '(: List all descendant files recursively :)
let $dir := file:create-temp-dir("tryit", ".d")
let $_ := (file:write-text($dir || "/a.txt", "a"),
           file:create-dir($dir || "/sub"),
           file:write-text($dir || "/sub/b.txt", "b"))
let $all := file:descendants($dir)
let $_ := file:delete($dir, true())
return
    for $f in $all return file:name($f)'

echo "Created $(find $BASE/bin $BASE/file -name '*.xq' | wc -l) try-it files"
