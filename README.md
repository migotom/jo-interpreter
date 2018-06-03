# Jo lang interpreter

Very simple Jo language intepreter for Perl6. It's not existing language interpeter developed as an exercise.

### Run 

```
$ perl6 jo
```

### Testing

```
prove --exec perl6 -r -t
```

### Syntax

```
{ if(true) { print(ala); } elsif (false or (true and false)) { print(kota); } else { print(malpke); } }
```

### Credits

Jo fun project was developed by Tomasz Kolaj and is licensed under Apache License Version 2.0.
Please reports bugs at https://github.com/migotom/jo-interpeter/issues and major security issues directly to me at tomasz246@gmail.com.
