# ztools

Several gadgets for Linux.

## `base64decode`

Base64 decoder constructed in Python 3.

### Test Environment:

* Python 3.6.7

### Usage

```sh
base64decode --help
```

```
usage: base64decode [-h] [--decode DECODE] [--file FILE] [--encoding ENCODING]

optional arguments:
  -h, --help            show this help message and exit
  --decode DECODE, -d DECODE
                        Base64 string to be decoded
  --file FILE, -f FILE  Text file where stored Base64 string to be decoded; "-" for stdin; If either
                        this option or "--decode" isn't set, the coded string will be read from stdin
  --encoding ENCODING   Encoding of decoded string; Default to utf-8
```

## target-pool

Trick for target scheduling.

### Test Environment:

* GNU bash 4.4.19(1)-release
* Python 3.6.7
* Vi IMproved 8.0, with patch 1-1766

### Usage

* `target init` - initiate a target pool (`~/.target_pool`)
* `target edit` - edit the target pool
* `target plan` - edit the every-week plan (`~/.target_update_plan`)
* `target ddl` - edit the one-shot DDL-s (`~/.target_ddl`)
* `target update` - update the weights in the target pool in accordance with `~/.target_update_plan` and `~/.target_ddl`; this command will update the weights subject to a reciprocal function of the difference to the ddl
* `target select` - randomly select a target in accordance with the weights in the target pool
* `target list-ddls` - list the closest DDL-s in `~/.target_update_plan` and `~/.target_ddl`

### Configuration for Autocompletion

In order to configure `bash` to autocomplete the command names, add following statements to `~/.bashrc`.

```sh
function _target() {
	COMPREPLY=($(compgen -W "update edit init select plan ddl list-ddls" ${COMP_WORDS[$COMP_CWORD]}))
	return 0
}
complete -F _target target
```

### About the Structure of the Target Pool File

The target pool file is in the following form:

```
# target	weight
Read papers	3
Lab	4
Literary read	2
```

The lines starting with "#" will be considered as comments. The last field separated by white space characters is considered as the weight while the other fields are considered as the target name integrally.

### About the Structure of the Every-week Plan File

The plan file is in the following form:

```
# target	DDL (weekday)
Application for summer practice		4
Prepare for experiment 1
```

The lines starting with "#" will be considered as comments as well. The last field separated by white space characters is considered as the weekday of the periodic deadline of the particular target while the other fields are considered as the target name integrally as well.

### About the Structure of the One-shot DDL File

The ddl file is in the similar form with the pool file and the plan file:

```
# target	DDL (yyyy-mm-dd)
Big project of Intelligent Optimisation Algorithms	2019-6-13
Report of oral history requested for Mao Thought	2019-5-31
```

The difference is that the last field indicates the one-shot ddl of the corresponding target but not the weight or the periodic ddl.

## simple-encryptor

A simple encryption tool using XOR algorithm.

### Test Environment:

* Python 3.6.7

### Usage

```sh
encrypt --help
```

```
usage: encrypt [-h] [--password [PASSWORD]] [--decode] [--delete]
               [--recursive] [--suffix SUFFIX]
               input [input ...]

positional arguments:
  input                 The file to encrypt or decrypt

optional arguments:
  -h, --help            show this help message and exit
  --password [PASSWORD], -p [PASSWORD]
                        Indicates whether a password should be used
  --decode, -d          Decrypts the file if set
  --delete              Delete the inputed file if set
  --recursive, -r       Encrypt the files under the directory recursively if
                        set. With "--delete" option set implicitly
  --suffix SUFFIX, -a SUFFIX
                        Specify the suffix of the encrypted file. The suffix
                        will be appended to the inputed file name during
                        encryption and be truncated from the inputed file name
                        during decryption
```

## Custom config files

Now such config files as follows are collected in this repo:

* `~/.bashrc`
* `~/.profile`
* `~/.vimrc`
* `~/.tmux.conf`
* `~/.config/fcitx/data/punc-ng.mb.zh_CN`
* `~/.config/fcitx/data/QuickPhrase.mb`

## Other tiny tools

* `~/.sogoubackup/backup` - backup the configs of Sogou Input Method routinely
* `convert_file_name` - convert the extension name of the images from the mobile from 'jpeg' to the correct one
