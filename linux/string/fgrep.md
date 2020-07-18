> fgrep 是 `grep -F`  的别名, 打印与模式匹配的行


```shell script
cat >> example.text << EOF
Lorem ipsum
dolor sit amet,
consetetur
sadipscing elitr,
sed diam nonumy
eirmod tempor
foo (Lorem|dolor) 
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
EOF
```

Find the exact string `'(Lorem|dolor)'` in `example.txt`

```shell script

fgrep '(Lorem|dolor)' example.txt
or
grep -F '(Lorem|dolor)' example.txt

foo (Lorem|dolor) 

```
