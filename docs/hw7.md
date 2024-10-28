# Name of lab or homework assignment (e.g., Lab 7: Verifying Your Custom Component Using System Console and `/dev/mem`)

## Overview
This is a homework assignment focused on teaching several useful commands for linux command line interface.

### Question 1:
```
wc -w lorem-ipsum.txt
```

output:
![question1](./assets/hw7_questions/question1.jpg)

### Question 2:
```
wc -c lorem-ipsum.txt
```

output:
![question2](./assets/hw7_questions/question2.jpg)

### Question 3:
```
wc -l lorem-ipsum.txt
```

output:
![question3](./assets/hw7_questions/question3.jpg)

### Question 4:
```

```

output:
![question4](./assets/hw7_questions/question4.jpg)

### Question 5:
```

```

output:
![question5](./assets/hw7_questions/question5.jpg)

### Question 6:
```
cut -d, -f3 log.csv
```

output:
![question6](./assets/hw7_questions/question6.jpg)

### Question 7:
```
cut -d, -f2,3 log.csv
```

output:
![question7](./assets/hw7_questions/question7.jpg)

### Question 8:
```
cut -d, -f1,4 log.csv
```

output:
![question8](./assets/hw7_questions/question8.jpg)

### Question 9:
```
head -n 3 gibberish.txt
```

output:
![question9](./assets/hw7_questions/question9.jpg)

### Question 10:
```
tail -n 2 gibberish.txt
```

output:
![question10](./assets/hw7_questions/question10.jpg)

### Question 11:
```
tail -n +2 log.csv
```

output:
![question11](./assets/hw7_questions/question11.jpg)

### Question 12:
```
grep -i 'and' gibberish.txt
```

output:
![question12](./assets/hw7_questions/question12.jpg)

### Question 13:
```
grep -i ' we ' gibberish.txt
```

output:
![question13](./assets/hw7_questions/question13.jpg)

### Question 14:
```
grep -o -E 'to [a-zA-Z]+' gibberish.txt
```

output:
![question14](./assets/hw7_questions/question14.jpg)

### Question 15:
```
grep -c 'FPGAs' fpgas.txt
```

output:
![question15](./assets/hw7_questions/question15.jpg)

### Question 16:
```
grep -E '\b(hot|not|cower|tower|smile|compile)' fpgas.txt
```

output:
![question16](./assets/hw7_questions/question16.jpg)

### Question 17:
```
grep -r -P '\-\-' --include="*.vhd" hdl -c
```

output:
![question17](./assets/hw7_questions/question17.jpg)

### Question 18:
```
ls > ls-putput.txt; cat ls-oputput.txt
```

output:
![question18](./assets/hw7_questions/question18.jpg)

### Question 19:
```
dmesg | grep 'CPU'
```

output:
![question19](./assets/hw7_questions/question19.jpg)

### Question 20:
```
find hdl -iname '*.vhd' | wc -l
```

output:
![question20](./assets/hw7_questions/question20.jpg)

### Question 21:
```
grep -roh --include="*.vhd" -- '\-\-' ./hdl | wc -l
```

output:
![question21](./assets/hw7_questions/question21.jpg)

### Question 22:
```
grep -n 'FPGAs' fpgas.txt
```

output:
![question22](./assets/hw7_questions/question22.jpg)

### Question 23:
```
du -a -h . | sort -h -r | head -n 3
```

output:
![question23](.assets/hw7_questions/question23.jpg)
