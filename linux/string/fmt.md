> fmt 格式话输出文本

example: example.txt (1 line)

    Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.

output the lines of example.txt to 20 character width

    cat example.txt | fmt -w 20

    Lorem ipsum
    dolor sit amet,
    consetetur
    sadipscing elitr,
    sed diam nonumy
    eirmod tempor
    invidunt ut labore
    et dolore magna
    aliquyam erat, sed
    diam voluptua. At
    vero eos et
    accusam et justo
    duo dolores et ea
    rebum. Stet clita
    kasd gubergren,
    no sea takimata
    sanctus est Lorem
    ipsum dolor sit
    amet.