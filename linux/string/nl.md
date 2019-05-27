> nl 输出文件的行号

例子
---


    cat <<EOF | fmt -w 80 | nl -s'. '
    Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
        output the lines of example.txt to 80 character width
    EOF



     1. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy
     2. eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam
     3. voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet
     4. clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
     5.     output the lines of example.txt to 20 character width