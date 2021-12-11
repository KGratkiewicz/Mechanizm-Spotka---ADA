# "Idź na randkę z Adą", czyli mechanizm spotkań w języku ADA
Program pokazujący rozwiązanie synchronizacji dostępu do sekcji krytycznej poprzez mechanizm spotkań w języku ADA.

Plik projektowy ze środowiska [GNAT Studio | Adacore](https://www.adacore.com/gnatpro/toolsuite/gnatstudio).

### Problem wzajemnego wykluczania
Problem wzajemnego wykluczania występuje wtedy kiedy conajmniej dwa procesy, chcą skorzystać z zasobu współdzielonego. Muszą one jednak skorzystać z niego jeden po drugim, aby nie "wtrącać się" jeden drugiemu. Dostęp do takiego zasobu współdzielonego nazywa się sekcją krytyczną procesu. W naszym przypadku zasobem współdzielonym jest ekran konsoli.


## Treść zadania
Ćwiczenie 3 - Utworzyć 2 zadania tego samego typu zadaniowego wypisujące na ekranie w 2 kolumnach po 10 razy: _"Zadanie nr po raz k"_ gdzie k- aktualna iteracja, nr - numer zadania. Wprowadzić przerwy pomiędzy interacjami o losowej długości. Do synchronizacji użyj mechanizmu spotkań.

## Działanie programu
Program swoją *sekcję lokalną* symuluje poprzez wykonanie opóźnienia `delay` o losowym czasie trwania. W *sekcji krytycznej* program jest dopuszczany do wykonania wypisania na ekranie. W przypadku niezastosowania synchronizacji dostępu do ekranu konsoli, możemy otrzymać wypisane ciągi procesu P1 wraz z ciągiem procesu P2.

## Mechanizm spotkań
Mechanizm spotkań w języku ADA polega na odwoływaniu się przez procesy (task) do procesu biernego, który kolejno oczekuje wywołania wejść. W przypadku tego zadania wykorzystano jako proces bierny następujące zadanie:
```
task Serwer is
      entry Zajmij;
      entry Zwolnij;
   end Serwer;

   task body Serwer is
   begin
      loop
         accept Zajmij;
         accept Zwolnij;
      end loop;
   end Serwer;
```
Proces poprzez wejście w nieskończoną pętlę, oczekuje najpierw wejścia `Zajmij` a następnie `Zwolnij`. W przypadku kiedy jakiś 'proces1' wywoła wejście `Zajmij` podczas gdy inny 'proces2' wykonał już to wywołanie, to 'proces1' zostanie wstrzymany do momentu wywołania przez inny proces wejścia `Zwolnij`.

Moment krytyczny zadania:

```
         Serwer.Zajmij;
         -- sekcja krytyczna BEG
         Set_Col(Positive_Count(kolumna));
         wyswietl(i,nr_zadania);
         -- sekcja krytyczna END
         Serwer.Zwolnij;
```

Dowiedz się więcej o mechaniźmie spotkać w Adzie -> [Spotkania (randki) w Adzie](https://wazniak.mimuw.edu.pl/index.php?title=Programowanie_wsp%C3%B3%C5%82bie%C5%BCne_i_rozproszone/PWR_Wyk%C5%82ad_4) 

Zobacz też inne rozwiązanie tego zadania -> [Algorytm Dekkera](https://github.com/KGratkiewicz/Algorytm-Dekkera-ADA.git) <- algorytmen Dekkera !

### Output działania programu
```
                      Zadanie  2 po raz  1
Zadanie  1 po raz  1
Zadanie  1 po raz  2  Zadanie  2 po raz  2
Zadanie  1 po raz  3
Zadanie  1 po raz  4  Zadanie  2 po raz  3
                      Zadanie  2 po raz  4
                      Zadanie  2 po raz  5
Zadanie  1 po raz  5  Zadanie  2 po raz  6
Zadanie  1 po raz  6  Zadanie  2 po raz  7
                      Zadanie  2 po raz  8
Zadanie  1 po raz  7  Zadanie  2 po raz  9
Zadanie  1 po raz  8  Zadanie  2 po raz 10
Zadanie  1 po raz  9
Zadanie  1 po raz 10
```

### Możliwy output bez synchronizacji dostępu 
```
Zadanie  1 po raz  1
Zadanie  1 po raz      2Zadanie  2 po raz 
 1Zadanie  1 po raz   Zadanie  3 2 po raz 
 2Zadanie  1 po raz  4 Zadanie 
 2Zadanie  po raz  1 3 po raz Zadanie  5 2 po raz 
 4Zadanie  1 po raz  6 Zadanie  2 po raz  5
Zadanie               Zadanie  1 2 po raz  po raz  7 6

Zadanie  1 po raz  8  Zadanie  2 po raz  7
Zadanie               Zadanie  2 po raz  8 1
  po raz              Zadanie  9 2 po raz  9

                      Zadanie  2 po raz 10Zadanie  1 po raz 10
```

### Kod żródłowy 

lokalizajca:

[src/main.adb](/src/main.adb) - plik główny main

[src/RandomPackage.ads](/src/RandomPackage.ads) - pakiet RandomPackage

[src/RandomPackage.adb](/src/RandomPackage.adb) - pakiet RandomPackage - ciało


---
&copy; Jakub Grątkiewicz
