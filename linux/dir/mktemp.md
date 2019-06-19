> mktemp Linux系统有特殊的目录，专供临时文件使用。Linux使用/tmp目录来存放不需要永久保留的文件。mktemp命令专门用来创建临时文件，并且其创建的临时文件是唯一的。shell会根据mktemp命令创建临时文件，但不会使用默认的umask值（管理权限的）。它会将文件的读写权限分配给文件属主，一旦创建了文件，在shell脚本中就拥有了完整的读写权限，其他人不可访问（除了root）。



选项
----

    -d  create a directory, not a file
    -u  do not create anything; merely print a name (unsafe)
    -q suppress diagnostics about file/dir-creation failure (即使出错也不会提示)
    -t interpret  TEMPLATE  as  a  single  file  name  component, relative to a directory:
              $TMPDIR, if set; else the directory specified via -p; else /tmp [deprecated]
    -p interpret  TEMPLATE  relative  to DIR; if DIR is not specified, use $TMPDIR if set,
              else /tmp.  With this option, TEMPLATE must not be an absolute  name;  unlike  with
              -t, TEMPLATE may contain slashes, but mktemp creates only the final component
    --suffix=SUFF
              append SUFF to TEMPLATE; SUFF must not contain a slash.  This option is implied  if
              TEMPLATE does not end in X



例子
----
    # error: mktemp: failed to create directory via template ‘/a/test.XXXXaaa’: No such file or directory
    mktemp -d -p /a --suffix=aaa test.XXXX
    # no error
    mktemp -d -p /a --suffix=aaa -q test.XXXX
    # 不执行
    mktemp -d -u -p /a --suffix=aaa  test.XXXX # /a/test.M06waaa
    # 在 tmp 目录生成临时文件夹
    mktemp -d -t test.XXXXX # /tmp/test.fgpIa